-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.shared.services

-- dependencies --
local remote_service = require(services.remote_service)

-- types --

-- variables --
local module = {}

local missile_to_client = remote_service.get("missile_to_client")

-- constants --

-- private functions --

-- public functions --
function module:init() 
end

function module:start() 
end

-- main --
return module
