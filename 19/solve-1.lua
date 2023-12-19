local stringx = require("pl.stringx")

local function parse_input()
  local rules = {}
  local parts = {}
  local parsing_subject = "rule"
  for line in io.lines(arg[1]) do
    if line == "" then
      parsing_subject = "part"
    else
      if parsing_subject == "rule" then
        local rule_name, conditions_str = string.match(line, "(.+){(.+)}")
        local conditions = stringx.split(conditions_str, ",")

        local body = "return function (part)\n"
        body = body .. "\tif part." .. string.gsub(conditions[1], ":", " then return \"") .. "\"\n"
        for i = 2, #conditions - 1 do
          body = body .. "\telseif part." .. string.gsub(conditions[i], ":", " then return \"") .. "\"\n"
        end
        body = body .. "\telse return \"" .. conditions[#conditions] .. "\" end\n"
        body = body .. "end"

        local compiled_rule = assert(loadstring(body, rule_name))()
        rules[rule_name] = compiled_rule
      else
        local factory_fn = assert(loadstring("return " .. line))
        table.insert(parts, factory_fn())
      end
    end
  end

  return rules, parts
end

local function is_accepted(rules, part)
  local current_rule = rules["in"]
  while true do
    local res = current_rule(part)
    if res == "A" then return true
    elseif res == "R" then return false
    else current_rule = rules[res] end
  end
end

local function main()
  local rules, parts = parse_input()
  local sum = 0
  for _, part in ipairs(parts) do
    if is_accepted(rules, part) then
      sum = sum + part.x + part.m + part.a + part.s
    end
  end
  print(sum)
end

main()
