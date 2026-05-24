local aug_pro_nav = {}
aug_pro_nav.__index = aug_pro_nav

-- requires target velocity and self velocity to be passed from
-- AssemblyLinearVelocity instead of being internally calculated using
-- target position and self position
function aug_pro_nav.new(target_pos: Vector3, target_v: Vector3, self_pos: Vector3, N)
	return setmetatable({
		vt = target_v,
		N = N,
		rlos = target_pos - self_pos,
	}, aug_pro_nav)
end

function aug_pro_nav:update(pt: Vector3, vt: Vector3, ps: Vector3, vs: Vector3, dt)
	local rlos = pt - ps
	local vr = vt - vs

	local omega = rlos:Cross(vr) / rlos:Dot(rlos)

	local a_cmd = self.N * vr:Cross(omega)

	return a_cmd
end

return aug_pro_nav
