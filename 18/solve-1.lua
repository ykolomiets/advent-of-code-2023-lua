local function parse_input()
  local plan = {}
  for line in io.lines(arg[1]) do
    local direction, length, color = string.match(line, "(.)%s(%d+)%s%((.+)%)")
    table.insert(plan, {
      direction = direction,
      length = tonumber(length),
      color = color,
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
