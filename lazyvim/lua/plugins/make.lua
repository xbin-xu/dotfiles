local M = {}

M.opts = {
  builder = {
    make = {
      glob = "**/[Mm]akefile",
      cmd = function(target)
        return target and ("make " .. target .. " 2>&1") or "make 2>&1"
      end,
      efm = "%f:%l:%c:\\ %t%*[^:]:\\ %m,%f:%l:\\ %t%*[^:]:\\ %m",
      parse_targets = function(content)
        local targets = {}
        for _, line in ipairs(vim.split(content, "\n")) do
          local t = line:match("^(%a[%w_.-]-)%s*:[^=]")
          if t then
            targets[#targets + 1] = t
          end
        end
        return targets
      end,
    },
    keil = {
      glob = "**/*.uvproj[xw]",
      cmd = function(target)
        return target and ('keil -b -t"%s"'):format(target) or "keil -b"
      end,
      efm = "%f(%l):\\ %t%*[^:]:\\ \\ %#%*[^:]:\\ %m",
      parse_targets = function(content)
        local targets = {}
        for name in content:gmatch("<TargetName>([^<]+)</TargetName>") do
          targets[#targets + 1] = name
        end
        return targets
      end,
    },
  },
}

-- Coroutine await wrappers
local function await_system(cmd)
  local co = coroutine.running()
  vim.system(cmd, { text = true }, function(result)
    vim.schedule(function()
      coroutine.resume(co, result)
    end)
  end)
  return coroutine.yield()
end

local function await_select(items, opts)
  local co = coroutine.running()
  vim.ui.select(items, opts, function(choice)
    coroutine.resume(co, choice)
  end)
  return coroutine.yield()
end

local CANCELLED = {}

local function pick_one(items, prompt)
  if #items == 0 then
    return nil
  elseif #items == 1 then
    return items[1]
  else
    local choice = await_select(items, { prompt = prompt })
    return choice == nil and CANCELLED or choice
  end
end

local function pick_file(glob)
  return pick_one(vim.fn.glob(glob, false, true), "Select: " .. glob)
end

local function exec_cmd(cmd)
  return await_system({ "bash", "-ic", cmd })
end

local function parse(output, efm, resolve_dir)
  local lines = vim.split(output, "\n")

  local saved_cwd
  if resolve_dir then
    saved_cwd = vim.fn.getcwd()
    vim.fn.chdir(resolve_dir)
  end
  vim.fn.setqflist({}, " ", { lines = lines, efm = efm })
  if saved_cwd then
    vim.fn.chdir(saved_cwd)
  end

  local errors, warnings = 0, 0
  for _, item in ipairs(vim.fn.getqflist()) do
    if item.valid == 1 then
      local t = item.type:lower()
      if t == "e" then
        errors = errors + 1
      elseif t == "w" then
        warnings = warnings + 1
      end
    end
  end
  return errors, warnings
end

local function on_finished(code, errors, warnings)
  if errors == 0 and warnings == 0 then
    local ok, trouble = pcall(require, "trouble")
    if ok then
      trouble.close("qflist")
    end
    if code ~= 0 then
      vim.notify(string.format("Build failed (exit %d)", code), vim.log.levels.ERROR)
    else
      vim.notify("0 error(s), 0 warning(s)", vim.log.levels.INFO)
    end
  else
    local ok, trouble = pcall(require, "trouble")
    if ok then
      trouble.open("qflist")
    end
    vim.notify(
      string.format("%d error(s), %d warning(s)", errors, warnings),
      errors > 0 and vim.log.levels.ERROR or vim.log.levels.WARN
    )
  end
end

local function run(builder)
  coroutine.wrap(function()
    local file = pick_file(builder.glob)
    if file == CANCELLED then
      return
    elseif not file then
      vim.notify("Not found: `" .. builder.glob .. "`", vim.log.levels.WARN)
      return
    end

    local target
    if builder.parse_targets then
      local content = table.concat(vim.fn.readfile(file), "\n")
      local targets = builder.parse_targets(content)
      target = pick_one(targets, "Select target:")
      if target == CANCELLED then
        return
      end
    end

    local cmd = type(builder.cmd) == "function" and builder.cmd(target) or builder.cmd
    local dir = vim.fn.fnamemodify(file, ":p:h")
    local results = exec_cmd("cd '" .. dir .. "' && " .. cmd)

    local output = (results.stdout or "") .. (results.stderr or "")
    local errors, warnings = parse(output, builder.efm, dir)
    on_finished(results.code, errors, warnings)
  end)()
end

function M.make()
  run(M.opts.builder.make)
end

function M.keil()
  run(M.opts.builder.keil)
end

vim.keymap.set("n", "<leader>mb", M.make, { desc = "Make build" })
vim.keymap.set("n", "<leader>mK", M.keil, { desc = "Make keil" })

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>m", group = "make" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    optional = true,
    opts = { auto_preview = false },
  },
}
