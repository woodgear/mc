local M = {}
local k = {}
k.L_DEF = "l-def"
k.L_FOR_COUN = "l-for-count"
k.L_STR_CONTIANS = "l-str-contains"
M.keys = k

M[k.L_DEF] = {
  ["desc"] = "定义一个函数",
}

M[k.L_FOR_COUN] = {
  ["desc"] = "for 循环",
}

M[k.L_STR_CONTIANS] = {
  ["desc"] = "一个字符串是否包含另一个字符串",
}

return M
