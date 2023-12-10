local function parse_input()
  io.input(arg[1])

  local maze = {}
  for line in io.lines() do
    local maze_line = {}
    for s in string.gmatch(line, ".") do
      table.insert(maze_line, s)
    end
    table.insert(maze, maze_line)
  end

  return maze
end

local function find_starting_position(maze)
  for i = 1, #maze do
    for j = 1, #maze do
      if maze[i][j] == "S" then
        return { y = i, x = j }
      end
    end
  end
end

local function up(pos, maze)
  if pos.y ~= 1 then
    return { y = pos.y - 1, x = pos.x }
  end
end

local function down(pos, maze)
  if pos.y ~= #maze then
    return { y = pos.y + 1, x = pos.x }
  end
end

local function left(pos, maze)
  if pos.x ~= 1 then
    return { y = pos.y, x = pos.x - 1 }
  end
end

local function right(pos, maze)
  if pos.x ~= #maze then
    return { y = pos.y, x = pos.x + 1 }
  end
end

local function find_first_adjacent_position(maze, start_pos)
  do
    local pos = left(start_pos, maze)
    if pos and (maze[pos.y][pos.x] == "-" or maze[pos.y][pos.x] == "L" or maze[pos.y][pos.x] == "F") then
      return pos
    end
  end

  do
    local pos = up(start_pos, maze)
    if pos and (maze[pos.y][pos.x] == "|" or maze[pos.y][pos.x] == "7" or maze[pos.y][pos.x] == "F") then
      return pos
    end
  end

  do
    local pos = right(start_pos, maze)
    if pos and (maze[pos.y][pos.x] == "J" or maze[pos.y][pos.x] == "7" or maze[pos.y][pos.x] == "-") then
      return pos
    end
  end

  do
    local pos = down(start_pos, maze)
    if pos and (maze[pos.y][pos.x] == "|" or maze[pos.y][pos.x] == "J" or maze[pos.y][pos.x] == "L") then
      return pos
    end
  end
end

local function is_equal_pos(a, b)
  return a.x == b.x and a.y == b.y
end

local function get_next_position(maze, current_pos, prev_pos)
  local pipe_type = maze[current_pos.y][current_pos.x]

  if pipe_type == "|" then
    local u = up(current_pos, maze)
    if not is_equal_pos(u, prev_pos) then
      return u
    end
    return down(current_pos, maze)
  elseif pipe_type == "-" then
    local l = left(current_pos, maze)
    if not is_equal_pos(l, prev_pos) then
      return l
    end
    return right(current_pos, maze)
  elseif pipe_type == "L" then
    local u = up(current_pos, maze)
    if not is_equal_pos(u, prev_pos) then
      return u
    end
    return right(current_pos, maze)
  elseif pipe_type == "J" then
    local u = up(current_pos, maze)
    if not is_equal_pos(u, prev_pos) then
      return u
    end
    return left(current_pos, maze)
  elseif pipe_type == "7" then
    local d = down(current_pos, maze)
    if not is_equal_pos(d, prev_pos) then
      return d
    end
    return left(current_pos, maze)
  elseif pipe_type == "F" then
    local d = down(current_pos, maze)
    if not is_equal_pos(d, prev_pos) then
      return d
    end
    return right(current_pos, maze)
  end
end

local function main()
  local maze = parse_input()
  local start_pos = find_starting_position(maze)
  local current_pos = find_first_adjacent_position(maze, start_pos)
  local prev_pos = start_pos
  local steps = 1
  repeat
    local next_pos = get_next_position(maze, current_pos, prev_pos)
    prev_pos = current_pos
    current_pos = next_pos
    steps = steps + 1
  until is_equal_pos(current_pos, start_pos)

  print(steps / 2)
end

main()
