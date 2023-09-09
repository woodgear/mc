local p = require "serious.init"
local function debug()
    -- p.read_lock()
    -- p.gen_lock()
    p.apply_lock(p.read_lock())
    vim.cmd(":qa")
end
debug()
-- p.setup { exit = true }
