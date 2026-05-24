local fm_rudimentary = {}
fm_rudimentary.__index = fm_rudimentary

function fm_rudimentary.new(part: BasePart, cd_front, cd_side)
	return setmetatable({
		area_front = part.Size.X * part.Size.Y,
		cd_front = cd_front,
		area_side = part.Size.Y * part.Size.Z,
		cd_side = cd_side,
	}, fm_rudimentary)
end

return fm_rudimentary
