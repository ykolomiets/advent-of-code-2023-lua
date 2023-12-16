local stringx = require("pl.stringx")

local function hash(str)
  local h = 0
  for ch in string.gmatch(str, ".") do
    h = h + string.byte(ch)
    h = h * 17
    h = h % 256
  end
  return h
end

local function main()
  io.input(arg[1])
  local input = io.read("l")
  local steps = stringx.split(input, ",")
  local sum = 0
  for _, step in ipairs(steps) do
    sum = sum + hash(step)
  end
  print(sum)
end

main()
