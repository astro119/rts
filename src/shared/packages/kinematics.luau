local rotation = require(script.Parent.rotation)

local kinematics = {}
kinematics.__index = kinematics

local rot_rate = {
    pitch_rate = 0,
    yaw_rate = 0,
    roll_rate = 0
}

-- positive x -> right
-- positive y -> upwards
-- negative z -> forward
function kinematics.new(root)
	return setmetatable({
		object = root,
        rotation = rotation.new(root.CFrame:ToOrientation()),
        rot_rate,
	}, kinematics)
end

function kinematics:update()
    self.rotation = rotation.new(self.object.CFrame:ToOrientation())
end

return kinematics
