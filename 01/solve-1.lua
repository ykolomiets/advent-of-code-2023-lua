io.input(arg[1])

local sum = 0
for line in io.lines() do
  local first = string.match(line, "%a*(%d)")
  local last = string.match(line, "(%d)%a*$")
  sum = sum + tonumber(first .. last)
end

print(sum)
