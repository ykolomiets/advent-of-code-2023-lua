local List = require("pl.list")

local function calculate_next_in_sequence(sequence)
  local diffs = {}
  for i = 1, #sequence - 1 do
    diffs[i] = sequence[i + 1] - sequence[i]
  end

  local all_zeroes = true
  for i = 1, #diffs do
    if diffs[i] ~= 0 then
      all_zeroes = false
      break
    end
  end

  if all_zeroes then
    return sequence[1]
  end

  return sequence[#sequence] + calculate_next_in_sequence(diffs)
end

local function main()
  io.input(arg[1])
  local sum = 0
  for line in io.lines() do
    local sequence = List.split(line, " "):map(tonumber)
    sum = sum + calculate_next_in_sequence(sequence)
  end
  print(sum)
end

main()
