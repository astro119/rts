-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local classes = script.Parent.Parent.classes
local aircraft = require(classes.aircraft)
local cfgs = ReplicatedStorage.cfgs

-- dependencies --

-- types --

-- variables --
local aircraft_test = {}

local arcrft
local root

local plane_behv

local trail_event

-- constants --

-- private functions --

-- public functions --
function aircraft_test:init() 

    local arcrft_model = cfgs.plane:Clone()
    arcrft = aircraft.new(arcrft_model)
    arcrft_model.Parent = workspace

end

function aircraft_test:start()
    RunService.Heartbeat:Connect(function(dt)
        -- plane_behv:update(dt)
    end)
end

-- main --
return aircraft_test
