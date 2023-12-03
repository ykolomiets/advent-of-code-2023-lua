local std = require("std")

local function get_adjacent_positions(pos, max_x, max_y)
  local result = {}

  --[[
  --  -****-
  --  --xx--
  --]]
  if pos.y > 1 then
    for i = math.max(pos.x[1] - 1, 1), math.min(pos.x[2] + 1, max_x) do
      table.insert(result, { y = pos.y - 1, x = i })
    end
  end

  --[[
  --  -*XX--
  --]]
  if pos.x[1] > 1 then
    table.insert(result, { y = pos.y, x = pos.x[1] - 1 })
  end

  --[[
  --  --XX*-
  --]]
  if pos.x[2] < max_x then
    table.insert(result, { y = pos.y, x = pos.x[2] + 1 })
  end

  --[[
  --  --xx--
  --  -****-
  --]]
  if pos.y < max_y then
    for i = math.max(pos.x[1] - 1, 1), math.min(pos.x[2] + 1, max_x) do
      table.insert(result, { y = pos.y + 1, x = i })
    end
  end

  return result
end

local function parse_input()
  local symbols = {}
  local numbers = {}

  local y = 0
  local max_x = 0

  io.input(arg[1])
  for line in io.lines() do
    y = y + 1
    max_x = #line

    local symbols_in_line = {}
    for t in std.elems(std.string.finds(line, "([%%%*%+%-%$&@/#=])")) do
      symbols_in_line[t[1]] = t.capt[1]
    end
    symbols[y] = symbols_in_line

    for t in std.elems(std.string.finds(line, "(%d+)")) do
      table.insert(
        numbers,
        {
          value = tonumber(t.capt[1]),
          pos = { y = y, x = { t[1], t[2] } }
        }
      )
    end
  end

  return { max_y = y, max_x = max_x, numbers = numbers, symbols = symbols }
end

local function main()
  local map = parse_input()

  local sum = 0
  for num in std.elems(map.numbers) do
    local adjacent_positions = get_adjacent_positions(num.pos, map.max_x, map.max_y)
    local is_symbol_adjacent = false
    for pos in std.elems(adjacent_positions) do
      if map.symbols[pos.y][pos.x] then
        is_symbol_adjacent = true
        break
      end
    end
    if is_symbol_adjacent then
      sum = sum + num.value
    end
  end

  print(sum)
end

main();
