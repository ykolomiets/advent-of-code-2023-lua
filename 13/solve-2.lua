local stringx = require("pl.stringx")
local List = require("pl.List")

local function parse_input()
  io.input(arg[1])
  local input = io.read("a")
  local patterns = stringx.split(input, "\n\n")
  local encoded_patterns = List()
  for _, pattern in pairs(patterns) do
    local horizontal = List()
    local vertical = List()
    local lines = stringx.splitlines(pattern)
    for _ = 1, #lines[1] do
      vertical:append(0)
    end
    for row_number, line in ipairs(lines) do
      local bitwise_encoded = 0
      for column_number = 1, #line do
        local ch = stringx.at(line, column_number)
        if ch == "#" then
          bitwise_encoded = bitwise_encoded | (1 << (#line - column_number))
          vertical[column_number] = vertical[column_number] | (1 << (#lines - row_number))
        end
      end
      horizontal:append(bitwise_encoded)
    end
    encoded_patterns:append({pattern = pattern, vertical = vertical, horizontal = horizontal })
  end
  return encoded_patterns
end

local function validate_reflection(values, split_after)
  local left = split_after - 1
  local right = split_after + 2
  while (left >= 1) and (right <= #values) do
    if values[left] ~= values[right] then
      return false
    end
    left = left - 1
    right = right + 1
  end
  return true
end

local function is_one_bit_off(a, b)
  local c = a ~ b
  return c ~= 0 and (c & (c - 1)) == 0
end

local function validate_reflection_with_exactly_one_smudge(values, split_after)
  local left = split_after - 1
  local right = split_after + 2
  local fixed = false
  while (left >= 1) and (right <= #values) do
    if fixed then
      if values[left] ~= values[right] then
        return false
      end
    else
      if values[left] ~= values[right] then
        if is_one_bit_off(values[left], values[right]) then
          fixed = true
        else
          return false
        end
      end
    end
    left = left - 1
    right = right + 1
  end
  return fixed
end

local function find_reflection_index(values)
  for i = 1, #values - 1 do
    if
      (values[i] == values[i + 1] and validate_reflection_with_exactly_one_smudge(values, i)) or
      (is_one_bit_off(values[i], values[i + 1]) and validate_reflection(values, i))
    then
      return i
    end
  end

  return 0
end

local function main()
  local patterns = parse_input()
  local sum_horizontal = patterns
    :map(function (p)
      return find_reflection_index(p.horizontal)
    end)
    :reduce('+')
  local sum_vertical = patterns
    :map(function (p)
      return find_reflection_index(p.vertical)
    end)
    :reduce('+')
  print(sum_horizontal * 100 + sum_vertical)
end

main()

