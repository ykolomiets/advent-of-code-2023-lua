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
    for j = 1, #maze[1] do
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
  if pos.x ~= #maze[1] then
    return { y = pos.y, x = pos.x + 1 }
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

local function get_start_pipe_type(maze, start_pos)
  local u = up(start_pos, maze)
  local d = down(start_pos, maze)
  local l = left(start_pos, maze)
  local r = right(start_pos, maze)

  local u_pipe = u and maze[u.y][u.x]
  local d_pipe = d and maze[d.y][d.x]
  local l_pipe = l and maze[l.y][l.x]
  local r_pipe = r and maze[r.y][r.x]

  if (u_pipe == "|" or u_pipe == "7" or u_pipe == "F") and (d_pipe == "|" or d_pipe == "L" or d_pipe == "J") then
    return "|"
  elseif (l_pipe == "-" or l_pipe == "L" or l_pipe == "F") and (r_pipe == "-" or r_pipe == "J" or r_pipe == "7") then
    return "-"
  elseif (u_pipe == "|" or u_pipe == "7" or u_pipe == "F") and (r_pipe == "-" or r_pipe == "7" or r_pipe == "J") then
    return "L"
  elseif (u_pipe == "|" or u_pipe == "7" or u_pipe == "F") and (l_pipe == "-" or l_pipe == "L" or l_pipe == "F") then
    return "J"
  elseif (d_pipe == "|" or d_pipe == "J" or d_pipe == "L") and (l_pipe == "|" or l_pipe == "L" or l_pipe == "F") then
    return "7"
  elseif (d_pipe == "|" or d_pipe == "J" or d_pipe == "L") and (r_pipe == "-" or r_pipe == "7" or r_pipe == "J") then
    return "F"
  end
end

local function map_to_single_number(pos, maze_width)
  return (pos.y - 1) * maze_width + pos.x
end

local function main()
  local maze = parse_input()
  local maze_width = #maze[1]
  local start_pos = find_starting_position(maze)
  maze[start_pos.y][start_pos.x] = get_start_pipe_type(maze, start_pos)
  local loop_parts = { [map_to_single_number(start_pos, maze_width)] = true }

  local current_pos = start_pos
  local prev_pos = start_pos
  repeat
    loop_parts[map_to_single_number(current_pos, maze_width)] = true
    local next_pos = get_next_position(maze, current_pos, prev_pos)
    prev_pos = current_pos
    current_pos = next_pos
  until is_equal_pos(current_pos, start_pos)

  local enclosed_tiles = 0
  for i = 1, #maze do
    local inside = false
    local up = false
    print(List(maze[i]):join(""))
    for j = 1, maze_width do
      if loop_parts[map_to_single_number({ y = i, x = j }, maze_width)] then
        local pipe_type = maze[i][j]
        if pipe_type == "|" then
          inside = not inside
        elseif pipe_type == "L" then
          up = true
        elseif pipe_type == "F" then
          up = false
        elseif pipe_type == "7" then
          if up then
            inside = not inside
          end
        elseif pipe_type == "J" then
          if not up then
            inside = not inside
          end
        end
      else
        if inside then
          enclosed_tiles = enclosed_tiles + 1
        end
      end
    end
  end
  print(enclosed_tiles)
end

main()
