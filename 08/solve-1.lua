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

  local current_position = "AAA"
  local steps_pointer = 1
  local total_steps = 0

  repeat
    current_position = map[current_position][steps[steps_pointer]]

    steps_pointer = steps_pointer + 1
    if (steps_pointer > #steps) then
      steps_pointer = 1
    end

    total_steps = total_steps + 1
  until current_position == "ZZZ"

  print(total_steps)
end

main()
