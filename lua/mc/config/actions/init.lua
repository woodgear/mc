require("mc.config.actions.panels")
require("mc.config.actions.terminal")
local async = require('async')
local promise = require('promise')


local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local ta = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"

local log = require("mc.util.vlog")
local sext = require("mc.util.string_ext")
local api = vim.api

local init_actions
local gen_actions
local action_list_all_actions
local a_find_file_in_project
local a_find_buffer_in_project
local a_find_string_in_project
local a_find_function_in_current_file
local a_find_function_in_project
local a_delete_current_file
local a_toggle_side
local a_format
local a_sync_package
local a_focus_file

local ALL_ACTIONS = {}
init_actions = function()
  local actions = gen_actions()
  for _, a in ipairs(actions) do
    local cmd_name = sext.snakecase_to_uppercase(a.name)
    ALL_ACTIONS[a.name] = a
    -- log.info("regx", cmd_name)
    if (a.keys ~= nil) then
      for _, kmap in pairs(a.keys) do
        -- log.info("  mode", kmap.mode, "key", kmap.key)
        vim.keymap.set(kmap.mode, kmap.key, a.fn, {})
      end
    end
    api.nvim_create_user_command(cmd_name, a.fn, {})
  end

  vim.keymap.set('n', '<leader>ff', a_find_buffer_in_project, {})
  vim.keymap.set('n', '<leader>qq', a_find_string_in_project, {})
  vim.keymap.set('n', '<leader>ii', a_find_function_in_current_file, {})
  vim.keymap.set('n', '<leader>ai', a_find_function_in_project, {})
end


local function ui_get_file_from_user()
  local cwd = vim.fn.getcwd()
  local util = require 'lspconfig.util'
  local find_files = require 'telescope.builtin'.find_files
  local root = util.find_git_ancestor(cwd)
  -- log.info("find file cwd " .. cwd .. " root " .. root)
  local gpath = ""
  find_files({
    find_command = { 'fd', "-t", "f", "--exclude", ".git", "-L", "-H", ".", root },
    attach_mappings = function(prompt_bufnr, _)
      ta.select_default:replace(function()
        ta.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local path = selection[1]
        gpath = path
      end)
      return true
    end
  })
  log.info("gpath ", gpath)
end

local function async_ui_input(prompt)
  return promise:new(function(resolve, reject)
    vim.ui.input({ prompt = prompt }, function(input)
      resolve(input)
    end)
  end)
end

local function async_ui_select_file_in_project()
  return promise:new(function(resolve, reject)
    require 'telescope.builtin'.find_files({
      find_command = { 'fd', "-t", "f", "--exclude", ".git", "-L", ".", root },
      attach_mappings = function(prompt_bufnr, _)
        ta.select_default:replace(function()
          ta.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local path = selection[1]
          resolve(path)
        end)
        return true
      end
    })
  end)
end

local function demo_actions()
  return {
    name = "demo-actions",
    fn = function()
      log.info("try async")
      return async(function()
        local input = await(async_ui_input("you name:"))
        log.info("get it ", input)
      end)
    end
  }
end

gen_actions = function()
  return {
    action_list_all_actions(),
    a_find_file_in_project(),
    a_delete_current_file(),
    a_toggle_side(),
    a_format(),
    a_sync_package(),
    a_focus_file(),
    demo_actions(),
    {
      name = "open-file-in-splited-right",
      fn = function()
        async(function()
          local p = await(async_ui_select_file_in_project())
          vim.api.nvim_command(':rightbelow vsp '..p)
        end)
      end
    }
  }
end

a_delete_current_file = function()
  return {
    name = "delete-current-file",
    fn = function()
      local filename = vim.api.nvim_buf_get_name(0)
      os.remove(filename)
      vim.api.nvim_command(':bd!')
    end
  }
end

a_toggle_side = function()
  return {
    name = "toggle-side",
    aliass = { "close-side", "open-side" },
    fn = function()
      vim.api.nvim_command(':NvimTreeToggle')
    end
  }
end

a_focus_file = function()
  local real_fn = function(opt)
    if opt.path == nil then
      log.info("args is empty.ignote")
      return
    else
      -- log.info("focus " .. tostring(opt.path))
      require("nvim-tree.actions.finders.find-file").fn(opt.path)
    end
  end

  return {
    name = "focus-file-on-side",
    fn = function()
      vim.ui.input({ prompt = "path: " }, function(input)
        if input ~= nil then
          real_fn({ path = input })
        end
      end)
    end
  }
end

-- l-ide-jump-to-file
a_find_file_in_project = function()
  local on_select_path = (function(p)
    log.info("in find file in project sel path", p)

    local tree_api = require("nvim-tree.api")

    local check_path = function(path)
      local luv = vim.loop
      -- Check if the path exists
      if luv.fs_stat(path) then
        -- Path exists
        local file_type = luv.fs_stat(path).type
        if file_type == 'file' then
          return "file"
        elseif file_type == 'directory' then
          return "dir"
        else
          return "unknow-type"
        end
      else
        -- Path does not exist
        return "no-exist"
      end
    end

    local f_type = check_path(p)
    if f_type == "file" then
      vim.api.nvim_command('edit ' .. p)
    elseif f_type == "dir" then
      -- log.info("is a dir " .. p)
      tree_api.tree.find_file({ buf = p, focus = true, open = true })
      local node = require("nvim-tree.lib").get_node_at_cursor()
      require("nvim-tree.lib").expand_or_collapse(node)
    else
      log.info("?? " .. p .. f_type)
    end
  end)

  return {
    name = "find-file-in-project",
    keys = { {
      mode = "n",
      key = "<leader>kk"
    } },
    fn = function()
      return async(function()
        local p = await(async_ui_select_file_in_project())
        on_select_path(p)
      end)
    end
  }
end

a_find_buffer_in_project = function()
  local builtin = require('telescope.builtin')
  builtin.buffers()
end

a_find_string_in_project = function()
  local builtin = require('telescope.builtin')
  builtin.live_grep()
end

a_find_function_in_current_file = function()
  local builtin = require('telescope.builtin')
  builtin.lsp_document_symbols({
    symbols = { "method", "function" }
  })
end

a_find_function_in_project = function()
  local builtin = require('telescope.builtin')
  builtin.lsp_workspace_symbols()
end

a_format = function()
  return {
    name = "format",
    keys = { {
      mode = "n",
      key = "<leader>fm"
    } },
    fn = function()
        vim.cmd(":FormatWrite")
    end
  }
end

a_sync_package = function()
  return {
    name = "sync-package",
    fn = function()
      local p = vim.fn.stdpath "config"
      vim.cmd(":luafile " .. p .. "/serious/inside.lua")
      vim.cmd(":ConfigReloadAll")
    end
  }
end

-- l-ide-eval-actions
action_list_all_actions = function()
  return {
    name = "list-all-actions",
    keys = { {
      mode = "n",
      key = "<leader>xm"
    } },
    fn = function()
      local conf = require("telescope.config").values
      local opts = require("telescope.themes").get_dropdown {}
      local actions = {}
      for k, a in pairs(ALL_ACTIONS) do
        local a_entry = { key = a.name, name = a.name, display = a.name }
        if a.aliass ~= nil then
          for _, n in ipairs(a.aliass) do
            local link_entry = { key = a.name, name = n, display = n .. " -> " .. a.name }
            table.insert(actions, link_entry)
          end
        end
        log.info("action", a_entry)
        table.insert(actions, a_entry)
      end
      log.info("action", actions)
      local out = pickers.new(opts, {
        prompt_title = "actions",
        finder = finders.new_table {
          results = actions,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry["display"],
              ordinal = entry["name"] -- only use to sort
            }
          end
        },
        sorter = conf.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr, _map)
          ta.select_default:replace(function()
            ta.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            log.info("sel entry", selection)
            local action = ALL_ACTIONS[selection.value["key"]]
            if action.args then
              action.fn(action.get_args())
            else
              action.fn()
            end
          end)
          return true
        end

      }):find()
      log.info("out", out)
    end
  }
end

init_actions()
