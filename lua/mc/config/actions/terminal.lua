local log = require("mc.util.vlog")

local jump_to_terminal = function()
  log.info("jump to terminal")
  -- has terminal window in current page
  -- if has jump to it
  -- if not create one with spit and set it to terminal mode and jump to it
end

vim.keymap.set('n', '<A-m>',jump_to_terminal)
