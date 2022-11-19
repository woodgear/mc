local u = require "util"

describe("try test", function()
    it("should ok", function()
        assert.are.same({3}, u.add(1, 2))
    end)
end)
