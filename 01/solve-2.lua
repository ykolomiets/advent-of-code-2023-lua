io.input(arg[1])


local digit_words = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }

local function isdigit(char)
  return string.match(char, "%d") ~= nil
end

local function get_digit_from_word(str)
  for digit, word in pairs(digit_words) do
    if word == string.sub(str, 1, #word) then
      return digit
    end
  end

  return nil
end

local sum = 0
for line in io.lines() do
  local digits = {}
  for i = 1, #line do
    local first = string.sub(line, i, i)
    if isdigit(first) then
      table.insert(digits, first)
    else
      local digit = get_digit_from_word(string.sub(line, i))
      if digit then
        table.insert(digits, digit)
      end
    end
  end
  sum = sum + tonumber(digits[1] .. digits[#digits])
end

print(sum)
