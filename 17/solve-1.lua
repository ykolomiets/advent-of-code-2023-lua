local dir = {
  up = 1,
  right = 2,
  down = 3,
  left = 4
}

local max_steps_before_turn = 3

local function parse_input()
  local values = {}
  local idx = 0
  local rows = 0
  for line in io.lines(arg[1]) do
    rows = rows + 1
    for n in string.gmatch(line, ".") do
      values[idx] = n
      idx = idx + 1
    end
  end
  return { values = values, rows = rows, columns = idx / rows }
end

local function create_min_heap()
  local heap_size = 0
  local heap = {}
  local map = {}

  local function is_empty()
    return heap_size == 0
  end

  local function swim()
    local idx = heap_size

    while math.floor(idx / 2) > 0 do
      local parent_index = math.floor(idx / 2)
      if heap[idx][2] < heap[parent_index][2] then
        heap[idx], heap[parent_index] = heap[parent_index], heap[idx]
      end
      idx = parent_index
    end
  end

  local function enqueue(node, priority)
    heap[heap_size + 1] = { node, priority }
    heap_size = heap_size + 1
    map[node.hash] = true
    swim()
  end

  local function min_child(i)
    if (i * 2) + 1 > heap_size then
      return i * 2
    else
      if heap[i * 2][2] < heap[i * 2 + 1][2] then
        return i * 2
      else
        return i * 2 + 1
      end
    end
  end

  local function sink()
    local i = 1
    while (i * 2) <= heap_size do
      local mc = min_child(i)
      if heap[i][2] > heap[mc][2] then
        heap[i], heap[mc] = heap[mc], heap[i]
      end
      i = mc
    end
  end

  local function dequeue()
    local node = heap[1][1]
    heap[1] = heap[heap_size]
    heap[heap_size] = nil
    heap_size = heap_size - 1
    sink()
    map[node.hash] = nil
    return node
  end

  local function contains(node)
    return map[node.hash] ~= nil
  end

  return {
    is_empty = is_empty,
    enqueue = enqueue,
    dequeue = dequeue,
    contains = contains
  }
end

local function get_neighbors(grid, current)
  local y = math.floor(current.pos / grid.columns)
  local x = current.pos % grid.columns
  local neighbors = {}
  if x > 0 then
    local next_pos = grid.columns * y + (x - 1)
    if current.dir == dir.left and current.must_turn_in ~= 1 then
      table.insert(neighbors, { pos = next_pos, dir = dir.left, must_turn_in = current.must_turn_in - 1 })
    elseif current.dir == dir.up or current.dir == dir.down then
      table.insert(neighbors, { pos = next_pos, dir = dir.left, must_turn_in = max_steps_before_turn })
    end
  end
  if x < grid.columns - 1 then
    local next_pos = grid.columns * y + (x + 1)
    if current.dir == dir.right and current.must_turn_in ~= 1 then
      table.insert(neighbors, { pos = next_pos, dir = dir.right, must_turn_in = current.must_turn_in - 1 })
    elseif current.dir == dir.up or current.dir == dir.down then
      table.insert(neighbors, { pos = next_pos, dir = dir.right, must_turn_in = max_steps_before_turn })
    end
  end
  if y > 0 then
    local next_pos = grid.columns * (y - 1) + x
    if current.dir == dir.up and current.must_turn_in ~= 1 then
      table.insert(neighbors, { pos = next_pos, dir = dir.up, must_turn_in = current.must_turn_in - 1 })
    elseif current.dir == dir.left or current.dir == dir.right then
      table.insert(neighbors, { pos = next_pos, dir = dir.up, must_turn_in = max_steps_before_turn })
    end
  end
  if y < grid.rows - 1 then
    local next_pos = grid.columns * (y + 1) + x
    if current.dir == dir.down and current.must_turn_in ~= 1 then
      table.insert(neighbors, { pos = next_pos, dir = dir.down, must_turn_in = current.must_turn_in - 1 })
    elseif current.dir == dir.left or current.dir == dir.right then
      table.insert(neighbors, { pos = next_pos, dir = dir.down, must_turn_in = max_steps_before_turn })
    end
  end
  return neighbors
end

local function encode_node(node)
 return node.pos .. "-" .. node.dir .. node.must_turn_in
end

local function decode_node(str)
  local pos, d, must_turn_in = string.match(str, "(%d+)-(%d)(%d)")
  return { pos = tonumber(pos), dir = tonumber(d), must_turn_in = tonumber(must_turn_in) }
end

local function reconstruct_path(came_from, current)
  local path = { current.pos }
  while came_from[encode_node(current)] do
    current = decode_node(came_from[encode_node(current)])
    table.insert(path, 1, current.pos)
  end
  return path
end

local function a_star(grid, start, goal, h)
  local came_from = {}

  local start_node = { pos = start, dir = dir.right, must_turn_in = max_steps_before_turn }
  local start_hash = encode_node(start_node)
  start_node.hash = start_hash;

  local gScore = {}
  gScore[start_hash] = 0

  local fScore = {}
  fScore[start_hash] = h(start_node.pos, goal, grid)

  local open_set = create_min_heap()
  open_set.enqueue(start_node, fScore[start_hash])

  while not open_set.is_empty() do
    local current = open_set.dequeue()
    if current.pos == goal then
      return reconstruct_path(came_from, current)
    end

    for _, neighbor in pairs(get_neighbors(grid, current)) do
      neighbor.hash = encode_node(neighbor)
      local tentative_score = gScore[current.hash] + grid.values[neighbor.pos]
      if gScore[neighbor.hash] == nil or tentative_score < gScore[neighbor.hash] then
        came_from[neighbor.hash] = current.hash
        gScore[neighbor.hash] = tentative_score
        fScore[neighbor.hash] = tentative_score + h(neighbor.pos, goal, grid)
        if not open_set.contains(neighbor) then
          open_set.enqueue(neighbor, fScore[neighbor.hash])
        end
      end
    end
  end

  error("path to goal is not found")
end

local function print_grid(grid)
  for i = 0, grid.rows - 1 do
    local line = ""
    for j = 0, grid.columns - 1 do
      line = line .. grid.values[i * grid.columns + j]
    end
    print(line)
  end
end


local function print_path(grid, path)
  local function contains(arr, val)
    for _, v in ipairs(arr) do
      if v == val then
        return true
      end
    end
    return false
  end

  for i = 0, grid.rows - 1 do
    local line = ""
    for j = 0, grid.columns - 1 do
      local pos = i * grid.columns + j
      if contains(path, pos) then
        line = line .. "*"
      else
        line = line .. grid.values[i * grid.columns + j]
      end
    end
    print(line)
  end
end

local function calculate_heat_loss(grid, path)
  local sum = -grid.values[0]
  for _, pos in ipairs(path) do
    sum = sum + grid.values[pos]
  end
  return sum
end

local function manhattan_distance(a, b, grid)
  return math.abs((a % grid.columns) - (b % grid.columns))
    + math.abs((a / grid.columns) - (b / grid.columns))
end

local function main()
  local grid = parse_input()
  local path = a_star(grid, 0, grid.columns * grid.rows - 1, manhattan_distance)
  print_path(grid, path)
  print(calculate_heat_loss(grid, path))
end

main()
