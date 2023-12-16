local function parse_input()
  local grid = {}
  for line in io.lines(arg[1]) do
    local row = {}
    for ch in string.gmatch(line, ".") do
      table.insert(row, ch)
    end
    table.insert(grid, row)
  end
  return grid
end

local function create_energy_grid(grid)
  local result = {}
  for _ = 1, #grid do
    local row = {}
    for _ = 1, #grid[1] do
      table.insert(row, ".")
    end
    table.insert(result, row)
  end
  return result
end

local function print_grid(grid)
  for _, row in ipairs(grid) do
    print(table.concat(row))
  end
end

local function is_out_of_grid(grid, pos)
  return pos.x < 1 or pos.x > #grid[1]
    or pos.y < 1 or pos.y > #grid
end

local function hash_beam(beam)
  return beam.pos.y .. "." .. beam.pos.x .. "." .. beam.direction
end

local visited = {}

local function energize_grid(grid, energy_grid, beam)
  local hash = hash_beam(beam)
  if visited[hash] then
    return
  end
  visited[hash] = true

  energy_grid[beam.pos.y][beam.pos.x] = "#"
  local next_pos = { y = beam.pos.y, x = beam.pos.x }
  if beam.direction == "right" then
    next_pos.x = next_pos.x + 1
  elseif beam.direction == "left" then
    next_pos.x = next_pos.x - 1
  elseif beam.direction == "up" then
    next_pos.y = next_pos.y - 1
  elseif beam.direction == "down" then
    next_pos.y = next_pos.y + 1
  end

  if is_out_of_grid(grid, next_pos) then
    return
  end

  local next_tile = grid[next_pos.y][next_pos.x]
  local next_directions = {}
  if next_tile == "." then
    return energize_grid(grid, energy_grid, { pos = next_pos, direction = beam.direction })
  elseif next_tile == "-" then
    if beam.direction == "up" or beam.direction == "down" then
      table.insert(next_directions, "right")
      table.insert(next_directions, "left")
    else
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = beam.direction })
    end
  elseif next_tile == "|" then
    if beam.direction == "right" or beam.direction == "left" then
      table.insert(next_directions, "up")
      table.insert(next_directions, "down")
    else
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = beam.direction })
    end
  elseif next_tile == "/" then
    if beam.direction == "right" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "up" })
    elseif beam.direction == "down" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "left" })
    elseif beam.direction == "left" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "down" })
    elseif beam.direction == "up" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "right" })
    end
  elseif next_tile == "\\" then
    if beam.direction == "right" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "down" })
    elseif beam.direction == "down" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "right" })
    elseif beam.direction == "left" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "up" })
    elseif beam.direction == "up" then
      return energize_grid(grid, energy_grid, { pos = next_pos, direction = "left" })
    end
  end

  for _, direction in ipairs(next_directions) do
    energize_grid(grid, energy_grid, { pos = next_pos, direction = direction })
  end
end

local function count_energized_tiles(energy_grid)
  local count = 0
  for _, row in ipairs(energy_grid) do
    for _, tile in ipairs(row) do
      if tile == "#" then
        count = count + 1
      end
    end
  end
  return count
end

local function main()
  local grid = parse_input()
  local energy_grid = create_energy_grid(grid)
  energize_grid(grid, energy_grid, { pos = { x = 0, y = 1 }, direction = "right" })
  print_grid(energy_grid)
  print(count_energized_tiles(energy_grid))
end

main()
