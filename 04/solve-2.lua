local stringx = require("pl.stringx")
local tablex = require("pl.tablex")
local seq = require("pl.seq")
local Set = require("pl.Set")

local function main()
  io.input(arg[1])
  local my_cards = {}
  for line in io.lines() do
    local card_title, numbers_part = stringx.splitv(line, ":%s+")
    local card_number = tonumber(string.match(card_title, "(%d+)"))
    my_cards[card_number] = (my_cards[card_number] or 0) + 1

    local win_part, our_part = stringx.splitv(numbers_part, "%s+|%s+")
    local win_numbers = Set(table.pack(stringx.splitv(win_part, "%s+")))
    local our_numbers = Set(table.pack(stringx.splitv(our_part, "%s+")))
    local matched = win_numbers * our_numbers

    for i = 1, #matched do
      my_cards[card_number + i] = (my_cards[card_number + i] or 0) + my_cards[card_number]
    end
  end

  print(seq.sum(tablex.values(my_cards)))
end

main()
