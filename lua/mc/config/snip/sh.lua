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
local ck = require("mc.config.snip.common-key").keys
local log = require("mc.util.vlog")
ls.add_snippets("sh", {
    s({
        trig = ck["L_DEF"],
        desc = "sh function"
    }, fmt([[
function <>() {
    <>
}
]],
        {
            i(1), i(2)
        },
        {
            delimiters = "<>"
        }
    )),
    postfix({
        trig = ".str-contains"
    }, fmt([[
if echo "{}" | grep -q "{}" ; then
    {}
fi
]],
        {
            f(function(_, parent)
                local m = parent.snippet.env.POSTFIX_MATCH
                if m[1] == '"' and m[#m] == '"' then
                    return string.sub(m, 1, #m)
                end
                return "$" .. m
            end), i(2), i(3),
        }
    )),
})
