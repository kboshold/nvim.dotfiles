local M = {}

M.color = {}

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function hex_to_rgb(hex)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)
  return r, g, b
end

M.color.darken = function(color, ratio)
  local r, g, b = hex_to_rgb(color)
  r = math.max(0, math.floor(r - 255 * ratio))
  g = math.max(0, math.floor(g - 255 * ratio))
  b = math.max(0, math.floor(b - 255 * ratio))
  return rgb_to_hex(r, g, b)
end

M.color.lighten = function(color, ratio)
  local r, g, b = hex_to_rgb(color)
  r = math.min(255, math.floor(r + 255 * ratio))
  g = math.min(255, math.floor(g + 255 * ratio))
  b = math.min(255, math.floor(b + 255 * ratio))
  return rgb_to_hex(r, g, b)
end

M.color.interpolate = function(base, accent, ratio)
  -- Interpoliere zwischen den beiden Farben basierend auf dem Verhältnis
  local base_r, base_g, base_b = hex_to_rgb(base)
  local accent_r, accent_g, accent_b = hex_to_rgb(accent)
  local interpolated_r = math.floor(base_r * ratio + accent_r * (1 - ratio))
  local interpolated_g = math.floor(base_g * ratio + accent_g * (1 - ratio))
  local interpolated_b = math.floor(base_b * ratio + accent_b * (1 - ratio))

  return rgb_to_hex(interpolated_r, interpolated_g, interpolated_b)
end

return M
