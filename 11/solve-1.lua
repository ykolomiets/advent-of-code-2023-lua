local function parse_input()
  io.input(arg[1])
  local universe = {}
  for line in io.lines() do
    local row = {}
    for ch in string.gmatch(line, ".") do
      table.insert(row, ch)
    end
    table.insert(universe, row)
  end

  return universe
end

local function expand_vertically(universe)
  local i = 1
  while i <= #universe do
    local no_galaxies = true
    for j = 1, #universe[i] do
      if universe[i][j] == "#" then
        no_galaxies = false
        break
      end
    end
    if no_galaxies then
      table.insert(universe, i, universe[i])
      i = i + 1
    end
    i = i + 1
  end
end

local function expand_horizontally(universe)
  local i = 1
  while i <= #universe[1] do
    local no_galaxies = true
    for j = 1, #universe do
      if universe[j][i] == "#" then
        no_galaxies = false
        break
      end
    end
    if no_galaxies then
      for k = 1, #universe do
        table.insert(universe[k], i, ".")
      end
      i = i + 1
    end
    i = i + 1
  end
end

local function find_galaxies(universe)
  local galaxies = {}
  for i = 1, #universe do
    for j = 1, #universe[1] do
      if universe[i][j] == "#" then
        table.insert(galaxies, { x = j, y = i })
      end
    end
  end
  return galaxies
end

local function calculate_distance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function main()
  local universe = parse_input()
  expand_vertically(universe)
  expand_horizontally(universe)
  local galaxies = find_galaxies(universe)
  local sum = 0
  for i = 1, #galaxies do
    for j = i + 1, #galaxies do
      sum = sum + calculate_distance(galaxies[i], galaxies[j])
    end
  end

  print(sum)
end

main()
