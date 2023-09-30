local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local log = require "mc.util.vlog"

local function parse_reverse_call(m)
    local break_index = #m
    for i = #m, 1, -1 do
        local c = m:sub(i, i)
        if c == '.' then
            break_index = i
            break
        end
    end
    -- log.info(m, break_index, m:sub(break_index + 1, #m))
    if break_index == #m or break_index == 1 then
        return nil, nil, "not find"
    end
    return m:sub(break_index + 1, #m), m:sub(1, break_index - 1), nil
end

ls.add_snippets("all", {
    s("trig", {
        t("luasnip ok")
    }),
    postfix({ trig = ".rb", docstring = "圆括号" }, l("(" .. l.POSTFIX_MATCH .. ")")),
    postfix({ trig = ".sb",docstring = "中括号" }, l("[" .. l.POSTFIX_MATCH .. "]")),
    postfix({ trig = ".cb", docstring = "花括号"}, l("{" .. l.POSTFIX_MATCH .. "}")),
    postfix({ trig = ".ab",docstring = "尖括号" }, l("<" .. l.POSTFIX_MATCH .. ">")),
    postfix({ trig = ".dq",docstring = "双括号" }, l("\"" .. l.POSTFIX_MATCH .. "\"")),
    postfix({ trig = ".sq",docstring = "单引号" }, l("'" .. l.POSTFIX_MATCH .. "'")),
    postfix({ trig = ".rq", docstring = "反引号" }, l("`" .. l.POSTFIX_MATCH .. "`")),
    postfix({
        trig = ".rc",
        match_pattern = "[%w%.%_%-%$%(%)]+$",
        docstring = [[
反向函数调用
a().b.rc => b(a())
]]
    }, f(function(_, p)
        local m = p.snippet.env.POSTFIX_MATCH
        local c, arg, err = parse_reverse_call(m)
        if err ~= nil then return m end
        return c .. "(" .. arg .. ")"
    end)),
})
