local stringx = require("pl.stringx")
local List = require("pl.List")
local seq = require("pl.seq")

local function parse_input()
  local rows = {}

  io.input(arg[1])
  for line in io.lines() do
    local springs_part, group_part = stringx.splitv(line, " ")
    local springs = List()
    for s in string.gmatch(springs_part, ".") do
      springs:append(s)
    end

    local groups = List()
    for g in string.gmatch(group_part, "(%d+)") do
      groups:append(tonumber(g))
    end

    local unfolded_springs = List()
    local unfolded_groups = List()
    for i = 1, 5 do
      unfolded_springs:extend(springs)
      if i < 5 then
        unfolded_springs:append("?")
      end
      unfolded_groups:extend(groups)
    end

    table.insert(
      rows,
      {
        springs = unfolded_springs,
        groups = unfolded_groups,
      }
    )
  end

  return rows
end

local function count_arrangements(row)
  local function set_cache(cache, key, value)
    cache[key] = value
    return value
  end

  local function munch_not_working(springs, group_size)
    local i = 1
    while i <= group_size do
      if springs[i] == "?" or springs[i] == "#" then
        i = i + 1
      else
        return nil
      end
    end

    if springs[i] == "#" then
      return nil
    end

    return springs:slice(i + 1, #springs)
  end

  local function recursion(springs, groups, cache)
    -- skip working springs
    local first_not_working = 1
    while springs[first_not_working] == "." do
      first_not_working = first_not_working + 1
    end
    springs = springs:slice(first_not_working, #springs)

    -- if no springs, then there is only one arrangement if there are no groups
    if #springs == 0 then
      if #groups == 0 then
        return 1
      end

      return 0
    end

    -- if no groups, then there is only one arrangement if there are no broken springs
    if #groups == 0 then
      local all_not_broken = true
      for s in springs:iter() do
        if s == "#" then
          all_not_broken = false
          break
        end
      end

      if all_not_broken then
        return 1
      else
        return 0
      end
    end

    local cache_key = #springs .. "." .. #groups
    if cache[cache_key] then
      return cache[cache_key]
    end

    -- if not enough springs to cover all groups (sum group sizes + working spring between groups)
    if #springs < #groups + seq.sum(groups:iter()) - 1 then
      return set_cache(cache, cache_key, 0)
    end

    -- if spring is unkwown check both cases and add them up
    if springs[1] == "?" then
      local count_if_working = recursion(springs:slice(2, #springs), groups, cache)

      local count_if_broken = 0
      local munched = munch_not_working(springs, groups[1])
      if munched then
        count_if_broken = recursion(munched, groups:slice(2, #groups), cache)
      end

      return set_cache(cache, cache_key, count_if_working + count_if_broken)
    end

    -- spring is broken
    local munched = munch_not_working(springs, groups[1])
    if munched then
      return set_cache(cache, cache_key, recursion(munched, groups:slice(2, #groups), cache))
    end

    return set_cache(cache, cache_key, 0)
  end

  return recursion(row.springs, row.groups, {})
end

local function main()
  local rows = parse_input()
  local sum = 0
  for _, row in ipairs(rows) do
    sum = sum + count_arrangements(row)
  end
  print(sum)
end

main()
