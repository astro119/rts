local telemetry = {}
telemetry.__index = telemetry

function telemetry.new()
	return setmetatable({
		
	}, telemetry)
end

return telemetry
