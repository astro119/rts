-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- dependencies --
local remote_service = require(ReplicatedStorage.shared.services.remote_service)

-- types --

-- variables --
local module = {}

local trail_to_client = remote_service.get("trail_to_client")


-- constants --

-- private functions --

-- public functions --
function module:init() 
end

function module:start() 
    local target = workspace:WaitForChild("target")
    local root = target:WaitForChild("root")
    local att = root:WaitForChild("Attachment")

        
    local cfg = target:WaitForChild("cfg")
    local effects = cfg:WaitForChild("effects")
  
    -----------
    local trail_cfg
    if effects then
        local trail_cfg_temp = effects:WaitForChild("trail_cfg")
        trail_cfg = {
            beam = effects:WaitForChild("beam"),
            emitter = att,
            lifetime = trail_cfg_temp:GetAttribute("lifetime"),
            time_to_max_width = trail_cfg_temp:GetAttribute("time_to_max_width"),
            max_trail_width = trail_cfg_temp:GetAttribute("max_trail_width"),
            randomness = trail_cfg_temp:GetAttribute("randomness"),
            resolution = trail_cfg_temp:GetAttribute("resolution")
        }
    end

    -- trail_to_client:FireAllClients(trail_cfg)
    RunService.Heartbeat:Connect(function(deltaTime)
        -- print(root.AssemblyLinearVelocity.Magnitude)
    end)
end

-- main --
return module
