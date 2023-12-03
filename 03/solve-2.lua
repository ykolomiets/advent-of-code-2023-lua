local std = require("std")

local function get_adjacent_positions(pos, max_x, max_y)
  local result = {}

  --[[
  --  -XXX-
  --  --*--
  --]]
  if pos.y > 1 then
    for i = math.max(pos.x - 1, 1), math.min(pos.x + 1, max_x) do
      table.insert(result, { y = pos.y - 1, x = i })
    end
  end

  --[[
  --  -X*--
  --]]
  if pos.x > 1 then
    table.insert(result, { y = pos.y, x = pos.x - 1 })
  end

  --[[
  --  --*X-
  --]]
  if pos.x < max_x then
    table.insert(result, { y = pos.y, x = pos.x + 1 })
  end

  --[[
  --  --*--
  --  -XXX-
  --]]
  if pos.y < max_y then
    for i = math.max(pos.x - 1, 1), math.min(pos.x + 1, max_x) do
      table.insert(result, { y = pos.y + 1, x = i })
    end
  end

  return result
end

local function parse_input()
  local asterisks = {}
  local numbers = {}

  local y = 0
  local max_x = 0

  io.input(arg[1])
  for line in io.lines() do
    y = y + 1
    max_x = #line

    for t in std.elems(std.string.finds(line, "(%*)")) do
      table.insert(asterisks, { y = y, x = t[1] })
    end

    numbers[y] = {}
    for t in std.elems(std.string.finds(line, "(%d+)")) do
      local number = { value = tonumber(t.capt[1]) }
      for x = t[1], t[2] do
        numbers[y][x] = number
      end
    end
  end

  return {
    max_y = y,
    max_x = max_x,
    numbers = numbers,
    asterisks = asterisks
  }
end

local function main()
  local map = parse_input()

  local sum = 0
  for pos in std.elems(map.asterisks) do
    local adjacent_positions = get_adjacent_positions(pos, map.max_x, map.max_y)

    local adjacent_numbers = {}
    for adj_pos in std.elems(adjacent_positions) do
      local number = map.numbers[adj_pos.y][adj_pos.x]
      if number and not adjacent_numbers[number] then
        adjacent_numbers[number] = number.value
      end
    end

    if std.table.size(adjacent_numbers) == 2 then
      local first, second = table.unpack(std.table.values(adjacent_numbers))
      sum = sum + first * second
    end
  end

  print(sum)
end

main();
