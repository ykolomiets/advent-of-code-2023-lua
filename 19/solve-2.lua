local pretty = require("pl.pretty")
local stringx = require("pl.stringx")

local function parse_input()
  local workflows = {}
  local parts = {}
  local parsing_subject = "rule"
  for line in io.lines(arg[1]) do
    if line == "" then
      parsing_subject = "part"
    else
      if parsing_subject == "rule" then
        local workflow = {}
        local workflow_name, rules_str = string.match(line, "(.+){(.+)}")
        local rules = stringx.split(rules_str, ",")
        for i = 1, #rules - 1 do
          local category, sign, number, next_workflow = string.match(rules[i], "(.)(.)(%d+):(.+)")
          table.insert(workflow, { category = category, sign = sign, number = tonumber(number), next_workflow = next_workflow })
        end
        table.insert(workflow, { next_workflow = rules[#rules] })
        workflows[workflow_name] = workflow
      else
        local factory_fn = assert(loadstring("return " .. line))
        table.insert(parts, factory_fn())
      end
    end
  end

  return workflows, parts
end

local function copy_part(part)
  return {
    x = { part.x[1], part.x[2] },
    m = { part.m[1], part.m[2] },
    a = { part.a[1], part.a[2] },
    s = { part.s[1], part.s[2] },
  }
end

local function main()
  local workflows = parse_input()
  local queue = {}
  local accepted = {}

  table.insert(queue, {
    part = {
      x = {1, 4000},
      m = {1, 4000},
      a = {1, 4000},
      s = {1, 4000},
    },
    workflow = "in"
  })

  while #queue > 0 do
    local item = table.remove(queue)
    local workflow = workflows[item.workflow]
    local part = copy_part(item.part)
    for idx, rule in ipairs(workflow) do
      local next_part = copy_part(part)

      if idx < #workflow then
        if rule.sign == ">" then
          part[rule.category][1] = rule.number + 1
          next_part[rule.category][2] = rule.number
        else
          part[rule.category][2] = rule.number - 1
          next_part[rule.category][1] = rule.number
        end
      end

      if rule.next_workflow == "A" then
        table.insert(accepted, part)
      elseif rule.next_workflow == "R" then
      else
        table.insert(queue, { part = part, workflow = rule.next_workflow })
      end
      part = next_part
    end
  end

  for _, part in ipairs(accepted) do
    print(
      ((part.x[2] - part.x[1] + 1) *
      (part.s[2] - part.s[1] + 1) *
      (part.m[2] - part.m[1] + 1) *
      (part.a[2] - part.a[1] + 1))
    )
  end
end

main()
