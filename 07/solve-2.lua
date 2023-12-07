local card_strength = {
  ["A"] = 14,
  ["K"] = 13,
  ["Q"] = 12,
  ["T"] = 10,
  ["9"] = 9,
  ["8"] = 8,
  ["7"] = 7,
  ["6"] = 6,
  ["5"] = 5,
  ["4"] = 4,
  ["3"] = 3,
  ["2"] = 2,
  ["J"] = 1,
}
local hand_type_strength = {
  ["five_of_a_kind"] = 7,
  ["four_of_a_kind"] = 6,
  ["full_house"] = 5,
  ["three_of_a_kind"] = 4,
  ["two_pair"] = 3,
  ["pair"] = 2,
  ["high_card"] = 1,
}

local function get_hand_type(cards)
  local occurances = {}
  local jokers = 0
  for _, card in pairs(cards) do
    if card == "J" then
      jokers = jokers + 1
    else
      occurances[card] = (occurances[card] or 0) + 1
    end
  end

  if jokers == 5 then
    return "five_of_a_kind"
  end

  local max_count = 0
  local max_card = nil
  for card, count in pairs(occurances) do
    if count > max_count then
      max_count = count
      max_card = card
    end
  end
  occurances[max_card] = occurances[max_card] + jokers

  local grouped_by_occurances = {}
  for card, count in pairs(occurances) do
    if grouped_by_occurances[count] == nil then
      grouped_by_occurances[count] = {}
    end
    table.insert(grouped_by_occurances[count], card)
  end

  if grouped_by_occurances[5] then
    return "five_of_a_kind"
  elseif grouped_by_occurances[4] then
    return "four_of_a_kind"
  elseif grouped_by_occurances[3] then
    if grouped_by_occurances[2] then
      return "full_house"
    else
      return "three_of_a_kind"
    end
  elseif grouped_by_occurances[2] then
    if #grouped_by_occurances[2] == 2 then
      return "two_pair"
    else
      return "pair"
    end
  else
    return "high_card"
  end
end

local function parse_hand(hand)
  local cards = {}
  for card in string.gmatch(hand, ".") do
    table.insert(cards, card)
  end

  return {
    cards = cards,
    type = get_hand_type(cards),
  }
end

local function compare_hands(a, b)
  local type_diff = hand_type_strength[a.type] - hand_type_strength[b.type]
  if type_diff ~= 0 then
    return type_diff > 0
  end
  for i = 1, 5 do
    local card_diff = card_strength[a.cards[i]] - card_strength[b.cards[i]]
    if card_diff ~= 0 then
      return card_diff > 0
    end
  end
  return true
end

local function main()
  io.input(arg[1])
  local hands = {}
  for line in io.lines() do
    local hand_part, bid_part = string.match(line, "(.....) (%d+)")
    local bid = tonumber(bid_part)
    local hand = parse_hand(hand_part)
    table.insert(hands, { hand = hand, bid = bid })
  end

  table.sort(hands, function (a, b)
    return not compare_hands(a.hand, b.hand)
  end)

  local sum = 0
  for rank, hand in ipairs(hands) do
    sum = sum + rank * hand.bid
  end

  print(sum)
end

main()
