local class = {}
class.__index = class

function class.new()
	return setmetatable({
    }, class)
end

function class:update()
end

return class