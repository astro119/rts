-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- dependencies --
local lpf = require(ReplicatedStorage.packages.low_pass_filter)

-- types --

-- variables --
local player_input = {}


-- positive x mouse_delta -> rightward mouse movement
-- positive y mouse_delta -> downward mouse movement
player_input.raw_mouse_delta = Vector2.zero
player_input.smooth_mouse_delta = Vector2.zero
local mouse_low_pass = lpf.new(12, 0.2, 10)

-- positive -> scrolling up
-- negative -> scrolling down
player_input.scroll_delta = 0
player_input.smooth_scroll_delta = 0
local scroll_low_pass = lpf.new(12, 0.2, 10)

-- constants --
local SMOOTH_MOUSE_THRESHOLD = 0.1

-- private functions --

-- public functions --
function player_input:init()
	RunService.RenderStepped:Connect(function(dt)
        local raw_mouse_delta = UserInputService:GetMouseDelta()
		player_input.raw_mouse_delta = raw_mouse_delta
		-- player_input.smooth_mouse_delta = mouse_low_pass:update_vec2(raw_mouse_delta, dt)
        
		player_input.scroll_delta = 0

        -- print(
        --     player_input.raw_mouse_delta,
        --     player_input.smooth_mouse_delta,
        --     player_input.scroll_delta,
        --     player_input.smooth_scroll_delta
        -- )
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			player_input.scroll_delta += input.Position.Z
		end
	end)
end

function player_input:start()
    
end

-- main --
return player_input
