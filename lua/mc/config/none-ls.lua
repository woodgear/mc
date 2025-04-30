local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell,
  },
})


local no_really = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "lua" },
  generator = {
    fn = function(params)
      local diagnostics = {}
      -- sources have access to a params object
      -- containing info about the current file and editor state
      for i, line in ipairs(params.content) do
        local col, end_col = line:find("really-no")
        if col and end_col then
          -- null-ls fills in undefined positions
          -- and converts source diagnostics into the required format
          table.insert(diagnostics, {
            row = i,
            col = col,
            end_col = end_col + 1,
            source = "no-really",
            message = "Don't use 'really!'",
            severity = vim.diagnostic.severity.WARN,
          })
        end
      end
      return diagnostics
    end,
  },
}

null_ls.register(no_really)

local frozen_string_actions = {
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "lua" },
  generator = {
    fn = function(context)
      local frozen_string_literal_comment = "-- frozen_string_literal: true"
      local first_line = context.content[1]
      if first_line ~= frozen_string_literal_comment then
        return {
          {
            title = "🥶Add frozen string literal comment",
            action = function()
              local lines = {
                frozen_string_literal_comment, "", first_line
              }

              vim.api.nvim_buf_set_lines(context.bufnr, 0, 1,
                false, lines)
            end
          }
        }
      end
    end
  }
}

null_ls.register(frozen_string_actions)
