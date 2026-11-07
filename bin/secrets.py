#!/usr/bin/env -S python3 -I -S
"""Local secret store: one Secret per Name, addressed by `secrets get <name>`.

One file per Name under $XDG_DATA_HOME/secrets (~/.local/share/secrets by
default). The file holds either a DPAPI-protected Blob (Windows) or the Secret
itself as owner-only plaintext (Linux):

  Windows   a Blob: DPAPI ciphertext, bound to this user on this machine
  Linux     the text, 0600 in a 0700 directory, protected by the disk

Standard library only, and the -S shebang means third-party packages could not
be imported anyway.

The only consumer is a `!command` credential source, so `get` writes the Secret
byte for byte, never prompts, and prints nothing else.
"""

from __future__ import annotations

import argparse
import os
import sys
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path

WINDOWS: bool = sys.platform == "win32"
PROG: str = Path(sys.argv[0]).stem or "secrets"
SUFFIX: str = ".dpapi" if WINDOWS else ".secret"
FORBID: int = 0x1  # CRYPTPROTECT_UI_FORBIDDEN: never raise a UI prompt


class Error(Exception):
    """Failure reported as a one-line message rather than a traceback."""

    exit_code: int = 1


class InvalidName(Error):
    """A Name that would not survive a round trip through the filesystem."""

    exit_code: int = 2


class SecretNotFound(Error):
    """The Store holds no Secret for that Name."""


class CorruptBlob(Error):
    """A file the Store cannot turn back into a Secret."""


def _dpapi(encrypt: bool, data: bytes) -> bytes:
    """Run CryptProtectData/CryptUnprotectData, raising OSError on failure."""
    import ctypes  # deferred: only Windows pays for it

    class Blob(ctypes.Structure):
        _fields_ = [
            ("cbData", ctypes.c_ulong),
            ("pbData", ctypes.POINTER(ctypes.c_char)),
        ]

    blob_p = ctypes.POINTER(Blob)
    ctypes_buffer_p = ctypes.POINTER(ctypes.c_char)
    crypt32 = ctypes.WinDLL("crypt32", use_last_error=True)
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    # argtypes are declared, not inferred: a bare DWORD or pointer marshals as
    # a C int, correct on x64 only by luck.
    for name in ("CryptProtectData", "CryptUnprotectData"):
        function = getattr(crypt32, name)
        function.restype = ctypes.c_bool
        function.argtypes = [
            blob_p,  # pDataIn
            ctypes.POINTER(ctypes.c_wchar),  # pszDataDescr / ppszDataDescr
            blob_p,  # pOptionalEntropy
            ctypes.c_void_p,  # pvReserved
            ctypes.c_void_p,  # pPromptStruct
            ctypes.c_ulong,  # dwFlags
            blob_p,  # pDataOut
        ]
    kernel32.LocalFree.restype = ctypes.c_void_p
    kernel32.LocalFree.argtypes = [ctypes.c_void_p]
    buffer = ctypes.create_string_buffer(data, len(data))
    source = Blob(len(data), ctypes.cast(buffer, ctypes_buffer_p))
    out = Blob()
    call = crypt32.CryptProtectData if encrypt else crypt32.CryptUnprotectData
    if not call(
        ctypes.byref(source), None, None, None, None, FORBID, ctypes.byref(out)
    ):
        raise OSError(f"DPAPI call failed (error {ctypes.get_last_error()})")
    try:
        return ctypes.string_at(out.pbData, out.cbData)
    finally:
        kernel32.LocalFree(ctypes.cast(out.pbData, ctypes.c_void_p))


def _protect(secret: str) -> bytes:
    """Secret -> the bytes of its file: DPAPI ciphertext, or the text itself."""
    plain = secret.encode("utf-8")
    return _dpapi(True, plain) if WINDOWS else plain


def _unprotect(raw: bytes) -> str:
    """The bytes of a file -> Secret: the one gate every read goes through.

    Empty means damage, not an empty Secret: nothing writes an empty file.
    """
    if not raw:
        raise CorruptBlob("the file is empty")
    try:
        plain = _dpapi(False, raw) if WINDOWS else raw
    except OSError as exc:
        raise CorruptBlob(f"DPAPI could not decrypt ({exc})") from exc
    try:
        return plain.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise CorruptBlob(f"not UTF-8: {exc}") from exc


def valid_name(name: str) -> bool:
    """Strict ASCII: no separators, no traversal, no locale surprises."""
    if not name or not name.isascii():
        return False
    return all(char.isalnum() or char in "-_" for char in name)


@dataclass(frozen=True)
class FileStore:
    """One file per Name: a DPAPI Blob on Windows, plaintext on Linux."""

    root: Path
    suffix: str = SUFFIX

    def read(self, name: str) -> str:
        path = self.path(name)
        try:
            raw = path.read_bytes()
        except FileNotFoundError:
            raise SecretNotFound(f"no stored secret named {name}") from None
        except OSError as exc:
            raise Error(f"cannot read {path}: {exc.strerror or exc}") from exc
        return _unprotect(raw)

    def write(self, name: str, secret: str) -> str:
        """Replace atomically: a reader sees the old file or the new one.

        Off Windows the file holds the Secret as plaintext, so permissions
        are its only barrier.
        """
        path = self.path(name)
        path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
        try:
            os.chmod(
                path.parent, 0o700
            )  # a pre-existing looser directory is not trusted
        except OSError:
            pass  # hardening is best effort; it must not fail the write
        staging = path.with_name(f".{path.name}.{os.getpid()}.tmp")
        descriptor = os.open(
            staging,
            os.O_WRONLY | os.O_CREAT | os.O_TRUNC | getattr(os, "O_BINARY", 0),
            0o600,
        )
        with os.fdopen(descriptor, "wb") as handle:
            handle.write(_protect(secret))
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(staging, 0o600)  # not every umask leaves the 0600 intact
        os.replace(staging, path)
        return str(path)

    def names(self) -> list[str]:
        try:
            entries = list(self.root.iterdir())
        except FileNotFoundError:
            return []
        stored = [p.stem for p in entries if p.is_file() and p.suffix == self.suffix]
        return sorted(name for name in stored if valid_name(name))

    def remove(self, name: str) -> None:
        try:
            self.path(name).unlink()
        except FileNotFoundError:
            raise SecretNotFound(f"no stored secret named {name}") from None

    def path(self, name: str) -> Path:
        if not valid_name(name):
            raise InvalidName(f"invalid name: {name!r}")
        return self.root / f"{name}{self.suffix}"


def store_root() -> Path:
    base = os.environ.get("XDG_DATA_HOME")
    root = Path(base) if base else Path.home() / ".local" / "share"
    return root / "secrets"


def _print_exact(text: str) -> None:
    """Print to stdout. Windows text mode would turn every \\n into \\r\\n."""
    reconfigure = getattr(sys.stdout, "reconfigure", None)
    if reconfigure is not None:
        reconfigure(newline="")
    sys.stdout.write(text)
    sys.stdout.flush()


def _drop_one_line_ending(text: str) -> str:
    """Remove the single newline a pipe or heredoc appends, and nothing more."""
    return text.removesuffix("\r\n").removesuffix("\n")


def cmd_get(store: FileStore, args: argparse.Namespace) -> int:
    _print_exact(store.read(args.name))
    return 0


def cmd_set(store: FileStore, args: argparse.Namespace) -> int:
    if args.stdin:
        try:
            secret = _drop_one_line_ending(sys.stdin.read())
        except KeyboardInterrupt:
            sys.stderr.write("\n")
            raise Error("aborted") from None
    else:
        import getpass  # deferred: only the prompt path pays for it

        try:
            secret = getpass.getpass("Secret value: ")
        except (EOFError, KeyboardInterrupt):
            sys.stderr.write("\n")
            raise Error("aborted") from None
    if not secret:
        raise Error("empty secret, nothing stored")
    sys.stderr.write(f"stored: {store.write(args.name, secret)}\n")
    return 0


def cmd_list(store: FileStore, args: argparse.Namespace) -> int:
    _print_exact("".join(f"{name}\n" for name in store.names()))
    return 0


def cmd_delete(store: FileStore, args: argparse.Namespace) -> int:
    store.remove(args.name)
    sys.stderr.write(f"removed: {args.name}\n")
    return 0


def cmd_help(store: FileStore, args: argparse.Namespace) -> int:
    build_parser().print_help()
    return 0


def build_parser() -> argparse.ArgumentParser:
    """The whole CLI grammar in one table.

    Usage errors exit 2 from here, not from main.
    """
    parser = argparse.ArgumentParser(
        prog=PROG, description="Local secret store: one Secret per Name."
    )
    sub = parser.add_subparsers(dest="command", required=True)
    p = sub.add_parser("get", help="print a secret")
    p.add_argument("name")
    p.set_defaults(func=cmd_get)
    p = sub.add_parser("set", help="store a secret (hidden prompt, or --stdin)")
    p.add_argument("name")
    p.add_argument("--stdin", action="store_true", help="read the secret from stdin")
    p.set_defaults(func=cmd_set)
    p = sub.add_parser("list", help="list stored names")
    p.set_defaults(func=cmd_list)
    p = sub.add_parser("delete", help="delete a stored secret")
    p.add_argument("name")
    p.set_defaults(func=cmd_delete)
    p = sub.add_parser("help", help="show this message")
    p.set_defaults(func=cmd_help)
    return parser


def main(argv: list[str]) -> int:
    try:
        args = build_parser().parse_args(argv)
    except SystemExit as exc:  # -h and usage errors exit from argparse
        return int(exc.code or 0)
    handler: Callable[[FileStore, argparse.Namespace], int] = args.func
    try:
        return handler(FileStore(store_root()), args)
    except Error as exc:
        sys.stderr.write(f"{PROG}: {exc}\n")
        return exc.exit_code
    except OSError as exc:
        sys.stderr.write(f"{PROG}: {exc}\n")
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
