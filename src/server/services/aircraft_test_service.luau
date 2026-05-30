-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local classes = script.Parent.Parent.classes
local aircraft = require(classes.aircraft)
local cfgs = ReplicatedStorage.cfgs

local anchor = require(ReplicatedStorage.packages.anchor)

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

    anchor.anchor_descendants(arcrft.root)
    local msl = cfgs.missile
    for _, v in ipairs({1,2,3,4,5}) do
        arcrft:attach_to_hardpoint(v, msl)
    end
    anchor.unanchor_descendants(arcrft.root)


    
end

function aircraft_test:start()

    local guided1 = false
    local target = workspace:WaitForChild("target")

    local t = 0
    RunService.Heartbeat:Connect(function(dt)
        t += dt
        if t > 2 then
            arcrft:deploy_weapon(1)
            -- arcrft:set_weapon_target(1, target:WaitForChild("root"))
            arcrft:deploy_weapon(5)
        end
        if t > 5 then
            arcrft:deploy_weapon(4)
            arcrft:set_weapon_target(4, target:WaitForChild("root"))
        end
        if t > 9 then
            arcrft:deploy_weapon(2)
            arcrft:set_weapon_target(2, target:WaitForChild("root"))
        end
        if t > 11 then
            arcrft:deploy_weapon(3)
            arcrft:set_weapon_target(3, target:WaitForChild("root"))
        end
    end)
end

-- main --
return aircraft_test
