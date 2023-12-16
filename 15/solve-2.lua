local stringx = require("pl.stringx")

local function hash(str)
  local h = 0
  for ch in string.gmatch(str, ".") do
    h = h + string.byte(ch)
    h = h * 17
    h = h % 256
  end
  return h
end

local function print_boxes(boxes)
  for idx = 0, 256 do
    local box = boxes[idx]
    if box and #box > 0 then
      local str = "Box " .. idx .. ": "
      for _, lens in ipairs(box) do
        str = str .. " [" .. lens.label .. " " .. lens.focal_length .. "]"
      end
      print(str)
    end
  end
end

local function calculate_focusing_power(boxes)
  local power = 0
  for box_number = 0, 256 do
    local box = boxes[box_number]
    if box and #box > 0 then
      for lens_slot, lens in ipairs(box) do
        power = power + (box_number + 1) * lens_slot * lens.focal_length
      end
    end
  end
  return power
end

local function main()
  io.input(arg[1])
  local input = io.read("l")
  local steps = stringx.split(input, ",")
  local boxes = {}
  for _, step in ipairs(steps) do
    local label, operation, focal_length = string.match(step, "(%a+)(.)(%d*)")
    local box_number = hash(label)
    local box = boxes[box_number] or {}
    if operation == "=" then
      for _, lens in ipairs(box) do
        if lens.label == label then
          lens.focal_length = tonumber(focal_length)
          goto continue
        end
      end
      table.insert(box, {
        label = label,
        focal_length = tonumber(focal_length),
      })
    elseif operation == "-" then
      local index_to_remove = 0
      for i, lens in ipairs(box) do
        if lens.label == label then
          index_to_remove = i
          break
        end
      end
      if index_to_remove > 0 then
        table.remove(box, index_to_remove)
      end
    end
    ::continue::
    boxes[box_number] = box
  end
  print_boxes(boxes)
  print(calculate_focusing_power(boxes))
end

main()
