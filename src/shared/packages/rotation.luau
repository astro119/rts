local rotations = {}
rotations.__index = rotations

function rotations.new(pitch, yaw, roll)
	return setmetatable({
		pitch = pitch,
		yaw = yaw,
		roll = roll,
	}, rotations)
end

function rotations:__tostring()
	return string.format(
		"%.2f, %.2f, %.2f",
		self.pitch,
		self.yaw,
		self.roll
	)
end

return rotations