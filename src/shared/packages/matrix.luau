local matrix = {}
matrix.__index = matrix

-- requires target velocity and self velocity to be passed from
-- AssemblyLinearVelocity instead of being internally calculated using
-- target position and self position
function matrix.new(target_pos: Vector3, target_v: Vector3, self_pos: Vector3, N)
	return setmetatable({
		vt = target_v,
		N = N,
		rlos = target_pos - self_pos,
	}, matrix)
end

return matrix
