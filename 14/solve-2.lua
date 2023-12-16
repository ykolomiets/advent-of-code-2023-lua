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

local function add_walls(dish)
  for _, row in pairs(dish) do
    table.insert(row, 1, "#")
    table.insert(row, "#")
  end

  local horizontal_wall = {}
  for _ = 1, #dish[1] do
    table.insert(horizontal_wall, "#")
  end
  table.insert(dish, 1, horizontal_wall)
  table.insert(dish, horizontal_wall)
end

local function to_string(dish)
  local lines = {}
  for _, row in ipairs(dish) do
    table.insert(lines, table.concat(row, ""))
  end
  return table.concat(lines, "\n")
end

local function tilt_north(dish)
  for i = 1, #dish[1] do
    local last_cube_rock = 0
    local round_rocks = 0
    for j = 1, #dish do
      if dish[j][i] == "#" then
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

local function tilt_east(dish)
  for i = 1, #dish do
    local last_cube_rock = 0
    local round_rocks = 0
    for j = #dish[i], 1, -1 do
      if dish[i][j] == "#" then
        for k = 1, round_rocks do
          dish[i][last_cube_rock - k] = "O"
        end
        round_rocks = 0
        last_cube_rock = j
      elseif dish[i][j] == "O" then
        round_rocks = round_rocks + 1
        dish[i][j] = "."
      end
    end
  end
end

local function tilt_south(dish)
  for i = 1, #dish[1] do
    local last_cube_rock = 0
    local round_rocks = 0
    for j = #dish, 1, -1 do
      if dish[j][i] == "#" then
        for k = 1, round_rocks do
          dish[last_cube_rock - k][i] = "O"
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

local function tilt_west(dish)
  for i = 1, #dish do
    local last_cube_rock = 0
    local round_rocks = 0
    for j = 1, #dish[i] do
      if dish[i][j] == "#" then
        for k = 1, round_rocks do
          dish[i][last_cube_rock + k] = "O"
        end
        round_rocks = 0
        last_cube_rock = j
      elseif dish[i][j] == "O" then
        round_rocks = round_rocks + 1
        dish[i][j] = "."
      end
    end
  end
end

local function calculate_load(dish)
  local load = 0
  for i, row in ipairs(dish) do
    for _, ch in ipairs(row) do
      if ch == "O" then
        load = load + (#dish - i)
      end
    end
  end
  return load
end

local function cycle(dish)
  tilt_north(dish)
  tilt_west(dish)
  tilt_south(dish)
  tilt_east(dish)
end

local function main()
  local dish = parse_input()
  add_walls(dish)

  local total_cycles = 1000000000
  local snapshots = {}
  for i = 1, total_cycles do
    cycle(dish)
    local str = to_string(dish)
    local snapshot = snapshots[str]
    if snapshot then
      local loop_length = i - snapshot.cycle_index
      local looped_cycles_left = total_cycles - snapshot.cycle_index
      local index_in_snapshots = snapshot.cycle_index + looped_cycles_left % loop_length
      for _, v in pairs(snapshots) do
        if v.cycle_index == index_in_snapshots then
          print(v.load)
        end
      end
      return
    end
    snapshots[str] = {
      cycle_index = i,
      load = calculate_load(dish)
    }
  end
end

main()
