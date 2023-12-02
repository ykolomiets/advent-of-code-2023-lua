local string = require "std.string"

local function get_bag(grabs_string)
  local bag = {}

  local grabs = string.split(grabs_string, ";")
  for _, grab in pairs(grabs) do
    for amount_str, color in string.gmatch(grab, "(%d+) (%a+)") do
      local amount = tonumber(amount_str)
      if bag[color] == nil or bag[color] < amount then
        bag[color] = amount
      end
    end
  end

  return bag
end

local function main()
  local sum = 0

  io.input(arg[1])
  for line in io.lines() do
    local _, grabs_part = table.unpack(string.split(line, ":"))
    local bag = get_bag(grabs_part)

    local power = 1
    for _, amount in pairs(bag) do
      power = power * amount
    end

    sum = sum + power
  end

  print(sum)
end

main()

