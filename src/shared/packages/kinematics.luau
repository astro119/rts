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

		last_cf = root.CFrame,

		rot_rate = {
			pitch = 0,
			yaw = 0,
			roll= 0,
		},
        
        previousLookVector = nil,
        previousUpVector = nil

	}, kinematics)
end


function kinematics:update(dt)

	-- current orientation
	local pitch, yaw, roll = self.object.CFrame:ToOrientation()

	self.rotation.pitch = pitch
	self.rotation.yaw = yaw
	self.rotation.roll = roll

    
    ---------------------
	local root_direction = self.object.CFrame.LookVector
	local UpVector = self.object.CFrame.UpVector


	local pitch_rate, roll_rate, yaw_rate

	if self.previousLookVector ~= nil and self.previousUpVector ~= nil then
		self.previousLookVector = self.object.CFrame:VectorToObjectSpace(self.previousLookVector)
		self.previousUpVector = self.object.CFrame:VectorToObjectSpace(self.previousUpVector)

		pitch_rate = math.atan(self.previousLookVector.Y / self.previousLookVector.Z) / dt -- positive when up
		roll_rate = -math.atan2(self.previousUpVector.X, self.previousUpVector.Y) / dt -- positive when roll right
		yaw_rate = math.atan(self.previousLookVector.X / self.previousLookVector.Z) / dt -- positive when right

		--print(previousLookVector)
		--print(previousUpVector)
		--print(pitchRate, rollRate, yawRate)
	end

	self.previousLookVector = root_direction
	self.previousUpVector = UpVector
    --------------------------------------------

    self.rot_rate.pitch = pitch_rate
    self.rot_rate.yaw = yaw_rate
    self.rot_rate.roll = roll_rate


end

return kinematics