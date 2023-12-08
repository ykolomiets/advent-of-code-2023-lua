local function steps_to_z(starting_pos, map, steps)
  local current_pos = starting_pos
  local steps_pointer = 1
  local total_steps = 0

  repeat
    current_pos = map[current_pos][steps[steps_pointer]]

    steps_pointer = steps_pointer + 1
    if (steps_pointer > #steps) then
      steps_pointer = 1
    end

    total_steps = total_steps + 1
  until string.sub(current_pos, 3) == "Z"

  return total_steps
end

local function gcd(a, b)
  if b == 0 then
    return a
  end
  return gcd(b, a % b)
end

local function lcm(a, b)
  return math.abs(a * b) / gcd(a, b)
end

local function main()
  io.input(arg[1])

  local steps_part = io.read("l")
  local steps = {}
  for step in string.gmatch(steps_part, ".") do
    table.insert(steps, step)
  end

  local _ = io.read("l") -- skip empty line

  local map = {}
  for line in io.lines() do
    local position, left_turn, right_turn = string.match(line, "(...) = %((...), (...)%)")
    map[position] = { L = left_turn, R = right_turn }
  end

  local starting_positions = {}
  for pos in pairs(map) do
    if string.sub(pos, 3) == "A" then
      table.insert(starting_positions, pos)
    end
  end

  local loop_sizes = {}
  for idx, pos in ipairs(starting_positions) do
    loop_sizes[idx] = steps_to_z(pos, map, steps)
  end

  local result = loop_sizes[1]
  for i = 2, #loop_sizes do
    result = lcm(result, loop_sizes[i])
  end

  print(result)
end

main()
