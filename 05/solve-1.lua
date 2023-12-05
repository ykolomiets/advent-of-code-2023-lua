local stringx = require("pl.stringx")
local List = require("pl.List")

local function main()
  io.input(arg[1])
  local almanac = io.read("a")
  local blocks = List.split(almanac, "\n\n")

  local seeds_block = blocks:pop(1)
  local seed_numbers_part = string.match(seeds_block, "seeds: (.+)")
  local seed_numbers = List.split(seed_numbers_part, " "):map(tonumber)

  local mappings = blocks:map(function(block)
    local lines = List.split(block, "\n")
    local name = stringx.splitv(lines:pop(1), " ")

    local mapping = lines
      :map(function(line)
        local dest_range_start, source_range_start, range = string.match(line, "(%d+) (%d+) (%d+)")
        return {
          source_range_start = tonumber(source_range_start),
          dest_range_start = tonumber(dest_range_start),
          range = tonumber(range),
        }
      end)
      :sort(function (a, b)
        return a.source_range_start < b.source_range_start
      end)

    return {
      name = name,
      mapping = mapping,
    }
  end)

  local location_numbers = seed_numbers:map(function (seed_number)
    local res = seed_number
    for mapping in mappings:iter() do
      for m in mapping.mapping:iter() do
        if (m.source_range_start <= res) and (res < m.source_range_start + m.range) then
          res = m.dest_range_start + (res - m.source_range_start)
          break;
        end
      end
    end
    return res
  end)

  print(location_numbers:sort()[1])
end

main()
