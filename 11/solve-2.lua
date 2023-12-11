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

local function find_horizontal_gaps(universe)
  local gaps = {}
  for i = 1, #universe do
    local no_galaxies = true
    for j = 1, #universe[i] do
      if universe[i][j] == "#" then
        no_galaxies = false
        break
      end
    end
    if no_galaxies then
      table.insert(gaps, i)
    end
  end
  return gaps
end

local function find_vertical_gaps(universe)
  local gaps = {}
  for i = 1, #universe[1] do
    local no_galaxies = true
    for j = 1, #universe do
      if universe[j][i] == "#" then
        no_galaxies = false
        break
      end
    end
    if no_galaxies then
      table.insert(gaps, i)
    end
  end
  return gaps
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

local function calculate_one_dimenstion_distance(a, b, gaps)
  local start = math.min(a, b)
  local finish = math.max(a, b)

  local dist = finish - start

  for _, v in ipairs(gaps) do
    if v > start and v < finish then
      dist = dist + (1000000 - 1)
    end
  end

  return dist
end

local function calculate_distance(a, b, vertical_gaps, horizontal_gaps)
  return calculate_one_dimenstion_distance(a.x, b.x, vertical_gaps) +
    calculate_one_dimenstion_distance(a.y, b.y, horizontal_gaps)
end

local function main()
  local universe = parse_input()
  local horizontal_gaps = find_horizontal_gaps(universe)
  local vertical_gaps = find_vertical_gaps(universe)
  local galaxies = find_galaxies(universe)

  local sum = 0
  for i = 1, #galaxies do
    for j = i + 1, #galaxies do
      sum = sum + calculate_distance(galaxies[i], galaxies[j], vertical_gaps, horizontal_gaps)
    end
  end

  print(sum)
end

main()
