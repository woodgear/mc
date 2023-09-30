local p = require "serious.init"
local log = require "mc.util.vlog"

local function debug()
    -- p.read_lock()
    -- p.gen_lock()
    -- p.apply_lock(p.read_lock())
    -- vim.cmd(":qa")
end
local function debug()
    -- p.read_lock()
    -- p.gen_lock()
    -- p.apply_lock(p.read_lock())
    -- vim.cmd(":qa")
end
local function exit()
    vim.cmd(":qa")
end
-- debug()
-- p.setup { exit = true }
local arg = vim.v.argv[6]
log.info("in cli mode", "arg", arg, "all", vim.v.argv)
if arg == "check-lsp" then
    log.info("try check-lsp")
    p.check_lsp()
    exit()
end
if arg == "init-lsp" then
    log.info("try init-lsp")
    p.init_lsp()
    exit()
end
if arg == "gen-patch" then
    p.gen_patch(vim.v.argv[7])
    exit()
end
log.info("could not find a action just exit")
exit()
