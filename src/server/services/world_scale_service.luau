-- services --

-- dependencies --

-- types --

-- variables --
local world_scale = {}

world_scale.meter_to_stud = 1 / 3
world_scale.grav_ro_to_metric = 35/9.8

-- constants --

-- private functions --
local function print_basic_world_params()
	print("meter to stud scale: ", world_scale.meter_to_stud)
	print("gravity: ", game.Workspace.Gravity)
	print("air density: ", game.Workspace.AirDensity)
end

-- public functions --
function world_scale:init() 
	local mts = world_scale.meter_to_stud

	table.insert(world_scale, mts)

	game.Workspace.Gravity *= mts
	game.Workspace.AirDensity *= mts

	print_basic_world_params()
end

function world_scale:start()

end

-- main --
return world_scale

