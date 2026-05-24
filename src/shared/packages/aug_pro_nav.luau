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
	local vt_prev = self.vt
	local rlos_prev = self.rlos

	--
	local rlos = pt - ps
	local vr = vt - vs

	local omega = rlos:Cross(vr) / rlos:Dot(rlos)

	local at = (vt - vt_prev) / dt
	local at_flat = at - at:Dot(rlos.Unit) * rlos.Unit

	local los_rate = (rlos - rlos_prev).Magnitude

	local a_cmd = self.N * vr:Cross(omega) + (self.N * at_flat * los_rate) / 2

	--
	self.vt = vt
	self.rlos = rlos

	--
	return a_cmd
end

return aug_pro_nav
