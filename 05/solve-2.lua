local List = require("pl.List")

local function range_intersection(a, b)
  if b.s > a.e or a.s > b.e then
    return nil
  end
  return { s = math.max(a.s, b.s), e = math.min(a.e, b.e) }
end

local function apply_mapping(input_range, maps)
  local res = List()
  for m in maps:iter() do
    local intersection = range_intersection(input_range, m.source_range)
    if intersection then
      local mapped = {
        s = m.dest_range_start + (intersection.s - m.source_range.s),
        e = m.dest_range_start + (intersection.e - m.source_range.s)
      }
      res:append(mapped)
    end
  end
  return res
end

local function map_to_location_ranges(location_ranges, input_range, maps)
  local mapped = apply_mapping(input_range, maps[1])
  if #maps == 1 then
    return location_ranges:extend(mapped)
  end
  local rest_maps = maps:slice(2, #maps)
  for next_range in mapped:iter() do
    map_to_location_ranges(location_ranges, next_range, rest_maps)
  end
end

local function main()
  io.input(arg[1])
  local almanac = io.read("a")
  local blocks = List.split(almanac, "\n\n")

  local seeds_block = blocks:pop(1)
  local seed_ranges_part = string.match(seeds_block, "seeds: (.+)")
  local seed_ranges = List()
  for start, range in string.gmatch(seed_ranges_part, "(%d+) (%d+)") do
    seed_ranges:append({ s = tonumber(start), e = tonumber(start) + tonumber(range) - 1 })
  end

  local maps = blocks:map(function(block)
    local lines = List.split(block, "\n")
    lines:remove(1)

    local map = lines
      :map(function(line)
        local dest_range_start, source_range_start, range = string.match(line, "(%d+) (%d+) (%d+)")
        return {
          source_range = {
            s = tonumber(source_range_start),
            e = tonumber(source_range_start) + tonumber(range) - 1,
          },
          dest_range_start = tonumber(dest_range_start),
        }
      end)
      :sort(function (a, b)
        return a.source_range.s < b.source_range.s
      end)

    map:put({
      source_range = {
        s = 0,
        e = map[1].source_range.s - 1,
      },
      dest_range_start = 0
    })

    map:append({
      source_range = {
        s = map[#map].source_range.e + 1,
        e = math.maxinteger,
      },
      dest_range_start = map[#map].source_range.e + 1,
    })

    return map
  end)

  local location_ranges = List()
  for seed_range in seed_ranges:iter() do
    map_to_location_ranges(location_ranges, seed_range, maps)
  end

  print(location_ranges:sort(function (a, b) return a.s < b.s end)[1].s)
end

main()
