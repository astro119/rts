-- LowPassFilter.lua
local low_pass_filter = {}
low_pass_filter.__index = low_pass_filter

-- create a new filter with a given smoothing strength
function low_pass_filter.new(smoothing: number)
	local self = setmetatable({}, low_pass_filter)

	self.smoothing = smoothing or 12
	self.value = nil

	return self
end

-- internal alpha calculation (frame-rate independent)
function low_pass_filter:_alpha(dt: number)
	return 1 - math.exp(-self.smoothing * dt)
end

-- update with a scalar
function low_pass_filter:update_scalar(raw: number, dt: number): number
	if self.value == nil then
		self.value = raw
		return raw
	end

	local alpha = self:_alpha(dt)
	self.value = self.value + (raw - self.value) * alpha

	return self.value
end

-- update with Vector2
function low_pass_filter:update_vec2(raw: Vector2, dt: number): Vector2
	if self.value == nil then
		self.value = raw
		return raw
	end

	local alpha = self:_alpha(dt)
	self.value = self.value + (raw - self.value) * alpha

	return self.value
end

-- update with Vector3
function low_pass_filter:update_vec3(raw: Vector3, dt: number): Vector3
	if self.value == nil then
		self.value = raw
		return raw
	end

	local alpha = self:_alpha(dt)
	self.value = self.value + (raw - self.value) * alpha

	return self.value
end

-- reset filter
function low_pass_filter:reset()
	self.value = nil
end

return low_pass_filter