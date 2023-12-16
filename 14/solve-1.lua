local function parse_input()
  io.input(arg[1])
  local dish = {}
  for line in io.lines() do
    local row = {}
    for ch in string.gmatch(line, ".") do
      table.insert(row, ch)
    end
    table.insert(dish, row)
  end
  return dish
end

local function print_dish(dish)
  for _, row in ipairs(dish) do
    local line = ""
    for _, ch in ipairs(row) do
      line = line .. ch
    end
    print(line)
  end
end

local function tilt_north(dish)
  for i = 1, #dish[1] do
    local last_cube_rock = 0
    local round_rocks = 0
    for j = 1, #dish + 1 do
      if dish[j] == nil or dish[j][i] == "#" then
        for k = 1, round_rocks do
          dish[last_cube_rock + k][i] = "O"
        end
        round_rocks = 0
        last_cube_rock = j
      elseif dish[j][i] == "O" then
        round_rocks = round_rocks + 1
        dish[j][i] = "."
      end
    end
  end
end

local function calculate_load(dish)
  local load = 0
  for i, row in ipairs(dish) do
    for _, ch in ipairs(row) do
      if ch == "O" then
        load = load + (#dish - i + 1)
      end
    end
  end
  return load
end

local function main()
  local dish = parse_input()
  tilt_north(dish)
  print(calculate_load(dish))
end

main()
