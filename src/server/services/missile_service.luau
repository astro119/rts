-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- dependencies --
local msl_data = require(ServerScriptService.data.msl_data)

-- types --

-- variables --
local missile_service = {}

-- constants --

-- private functions --

-- public functions --
function missile_service:init() 
end

function missile_service:start()

	RunService.Heartbeat:Connect(function(dt)
		for _, msl in pairs(msl_data) do
			msl:update(dt)
		end
	end)

end

-- main --
return missile_service
