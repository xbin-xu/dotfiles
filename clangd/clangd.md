# [Clangd]

## 配置优先级

配置应用顺序：`clang-tidy` -> 项目配置 -> 用户配置

- `.clang-tidy` 配置：`/proj/.clang-tidy`
- 项目配置：`/proj/.clangd`
- 用户配置：`~/.config/clangd/config.yaml`, `~/AppData/Local/clangd/config.yaml`

## 推荐的编译选项

> [The Best and Worst GCC Compiler Flags For Embedded]

```yaml
# config.yaml
CompileFlags:
    # Compiler: gcc
    # Compiler: arm-noen-eabi-gcc
    # Compiler: clang++
    Add:
        # Add -isystem<directory> to fix can’t find standard library headers
        # - -isystemD:/software/scoop/apps/gcc/current/x86_64-w64-mingw32/include
        # - -isystemD:/software/scoop/apps/gcc-arm-none-eabi/current/arm-none-eabi/include
        - -xc
        - -std=c99
        # - --target=avr # for 8-bit mcus
        - -Wall
        - -Wextra
        - -Wpedantic
        - -Wundef
        - -Wshadow
        - -Wformat=2
        - -Wformat-overflow=2
        - -Wformat-truncation=2
        - -Warray-bounds=2
        - -Wstringop-overflow=4
        - -Wpadded
        - -Wvla
        - -Wcast-align
        - -Wcast-qual
        - -Wpointer-arith
        - -Wwrite-strings
        - -Wconversion
        - -Wfloat-equal
        - -Wdouble-promotion
        - -Wlogical-op
        - -Wduplicated-cond
        - -Wduplicated-branches
        - -Wjump-misses-init
        - -Wmissing-declarations
        - -Wmissing-prototypes
        - -Wstrict-prototypes
        - -Wold-style-definition
        - -Wunreachable-code
        - -Wnull-dereference
        # - -Walloca
        # - -Walloc-zero
        # - -Wstack-usage=512
        # - -Wno-unused-variable
        # - -Wno-unused-parameter
        - -Wno-unused-function
        - -Wno-empty-translation-unit
        # - -Wno-override-init # for override init while use designated initializer
        - -fno-common
        # - -fshort-enums
        - -fno-short-enums
        # - -fno-builtin
    Remove: []

Diagnostics:
    ClangTidy:
        Add: []
        Remove: []
```

[Clangd]: https://clangd.llvm.org
[The Best and Worst GCC Compiler Flags For Embedded]: https://interrupt.memfault.com/blog/best-and-worst-gcc-clang-compiler-flags
