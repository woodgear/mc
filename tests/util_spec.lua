local u = require "mc.util"

describe("try test", function()
  it("should ok", function()
    assert.are.same({ 3 }, u.add(1, 2))
  end)

  it("should list all ft", function()
    local allft = u.list_to_map(vim.fn.getcompletion('', "filetype"))
    print(vim.inspect(allft))
    assert.are.same({ allft.c }, { true })
    local luaft = u.list_to_map(vim.fn.getcompletion('lua', "filetype"))
    assert.are.same({ luaft.lua }, { true })
  end)
end)
