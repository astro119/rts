local w = {}

function w.weld(part0: BasePart, part1: BasePart)
	local weld_constraint = Instance.new("WeldConstraint")
	weld_constraint.Parent = part0
	weld_constraint.Part0 = part0
	weld_constraint.Part1 = part1
end

function w.weld2(part0: BasePart, part1: BasePart, container)
	local weld_constraint = Instance.new("WeldConstraint")
	weld_constraint.Parent = container
	weld_constraint.Part0 = part0
	weld_constraint.Part1 = part1
end

-- weld all part descendants to root part
-- @param root BasePart
function w.weld_descendants(root: BasePart)
	-- create folder to put the weldconstraints in
	local weld_folder = Instance.new("Folder")
	weld_folder.Name = "welds"
	weld_folder.Parent = root

	for _, object in ipairs(root:GetDescendants()) do
		if object:IsA("BasePart") then
			w.weld2(root, object, weld_folder)
		end
	end
end

-- weld all children to root part
-- @param root BasePart
function w.weld_children(root: BasePart)
	-- create folder to put the weldconstraints in
	local weld_folder = Instance.new("Folder")
	weld_folder.Name = "welds"
	weld_folder.Parent = root

	for _, object in ipairs(root:GetChildren()) do
		if object:IsA("BasePart") then
			w.weld2(root, object, weld_folder)
		end
	end
end

return w
