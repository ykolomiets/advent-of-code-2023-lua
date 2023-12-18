
local function parse_input()
  local plan = {}
  local decoded_direction = {
    ["0"] = "R",
    ["1"] = "D",
    ["2"] = "L",
    ["3"] = "U",
  }
  for line in io.lines(arg[1]) do
    local encoded = string.match(line, ".%s%d+%s%(#(.+)%)")
    table.insert(plan, {
      length = tonumber(string.sub(encoded, 1, 5), 16),
      direction = decoded_direction[string.sub(encoded, 6)]
    })
  end
  return plan
end

local function calculate_area(plan)
  local cur = { y = 0, x = 0 }
  local area = 0
  for _, step in ipairs(plan) do
    local next = { y = cur.y, x = cur.x }
    if step.direction == "U" then
      next.y = next.y - step.length
    elseif step.direction == "D" then
      next.y = next.y + step.length
    elseif step.direction == "R" then
      next.x = next.x + step.length
    elseif step.direction == "L" then
      next.x = next.x - step.length
    end
    area = area + (cur.x * next.y) - (cur.y * next.x) + step.length
    cur = next
  end

  return area / 2 + 1
end

local function main()
  local plan = parse_input()
  print(calculate_area(plan))
end

main()
