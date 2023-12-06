local stringx = require("pl.stringx")

local function parse_numbers(str)
  local _, numbers_part = stringx.splitv(str, ":%s+")
  local number_str = string.gsub(numbers_part, "%s+", "")
  return tonumber(number_str)
end

local function parse_record()
  io.input(arg[1])
  local records_text = io.read("a")
  local times_part, distances_part = stringx.splitv(records_text, "\n")
  return {
    time = parse_numbers(times_part),
    distance = parse_numbers(distances_part)
  }
end

--[[ d(t) = t * (RT - t), d(t) > RD -> t^2 - RT * t + RD < 0
-- satisfying range [next_int(t1), prev_int(t2)]
--]]
local function solve(record)
  local discriminant = record.time * record.time - 4 * record.distance
  local x1 = (record.time - math.sqrt(discriminant)) / 2
  local x2 = (record.time + math.sqrt(discriminant)) / 2

  if math.tointeger(x1) then
    x1 = math.tointeger(x1) + 1
  else
    x1 = math.tointeger(math.ceil(x1))
  end

  if math.tointeger(x2) then
    x2 = math.tointeger(x2) - 1
  else
    x2 = math.tointeger(math.floor(x2))
  end

  return x2 - x1 + 1
end

local function main()
  local record = parse_record()
  print(solve(record))
end

main()
