local pretty = require("pl.pretty")
local stringx = require("pl.stringx")
local Set = require("pl.Set")

local function main()
  io.input(arg[1])
  local sum = 0
  for line in io.lines() do
    local _, numbers_part = stringx.splitv(line, ":%s+")
    local win_part, our_part = stringx.splitv(numbers_part, "%s+|%s+")
    local win_numbers = Set(table.pack(stringx.splitv(win_part, "%s+")))
    local our_numbers = Set(table.pack(stringx.splitv(our_part, "%s+")))
    local matched = win_numbers * our_numbers
    print(pretty.write(matched))
    if #matched > 0 then
      sum = sum + 2 ^ (#matched - 1)
    end
  end

  print(sum)
end

main()
