local string = require "std.string"

BAG_CONTENT = {
  ['red'] = 12,
  ['green'] = 13,
  ['blue'] = 14,
}

local function is_possible_game(grabs_string)
  local grabs = string.split(grabs_string, ";")

  for _, grab in pairs(grabs) do
    for amount, color in string.gmatch(grab, "(%d+) (%a+)") do
      if tonumber(amount) > BAG_CONTENT[color] then
        return false
      end
    end
  end

  return true
end

local function main()
  local sum = 0

  io.input(arg[1])
  for line in io.lines() do
    local game_id_part, grabs_part = table.unpack(string.split(line, ":"))
    local _, _, game_id = string.find(game_id_part, "Game (%d+)")

    if is_possible_game(grabs_part) then
      sum = sum + tonumber(game_id)
    end
  end

  print(sum)
end

main()
