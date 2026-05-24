local services = script.Parent:WaitForChild("services")

for _, service in ipairs(services:GetChildren()) do
	local module = require(service)

	if typeof(module.init) == "function" then
		module:init()
	end
end