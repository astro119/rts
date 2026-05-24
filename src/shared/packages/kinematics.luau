local rotation = require(script.Parent.rotation)

local kinematics = {}
kinematics.__index = kinematics

-- positive x -> right
-- positive y -> upwards
-- negative z -> forward

function kinematics.new(root)

	local pitch, yaw, roll = root.CFrame:ToOrientation()

	local rot = rotation.new(pitch, yaw, roll)

	return setmetatable({

		object = root,
		rotation = rot,

		rot_rate = {
			pitch = 0,
			yaw = 0,
			roll= 0,
		},
        
        prev_look_vec = nil,
        prev_up_vec = nil

	}, kinematics)
end


function kinematics:update(dt)

	-- current orientation
	local pitch, yaw, roll = self.object.CFrame:ToOrientation()

	self.rotation.pitch = pitch
	self.rotation.yaw = yaw
	self.rotation.roll = roll

    
    -- rotation rate
	local look_vec = self.object.CFrame.LookVector
	local up_vec = self.object.CFrame.UpVector

	if self.prev_look_vec ~= nil and self.prev_up_vec ~= nil then
		self.prev_look_vec = self.object.CFrame:VectorToObjectSpace(self.prev_look_vec)
		self.prev_up_vec = self.object.CFrame:VectorToObjectSpace(self.prev_up_vec)

		self.rot_rate.pitch = math.atan(self.prev_look_vec.Y / self.prev_look_vec.Z) / dt -- positive when up
        self.rot_rate.yaw = math.atan(self.prev_look_vec.X / self.prev_look_vec.Z) / dt -- positive when right
		self.rot_rate.roll = -math.atan2(self.prev_up_vec.X, self.prev_up_vec.Y) / dt -- positive when roll right
	end

	self.prev_look_vec = look_vec
	self.prev_up_vec = up_vec


end

return kinematics