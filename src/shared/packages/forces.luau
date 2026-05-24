local forces = {}

function forces.create_force(part: BasePart, name: string) 
    local attachment = Instance.new("Attachment")
    attachment.Name = name.."_attachment"
	attachment.Parent = part

    local force = Instance.new("VectorForce")
    force.Name = name.."_force"
    force.Attachment0 = attachment
    force.Force = Vector3.zero
    force.Parent = part
    return force
end

function forces.make_part_weightless(part: BasePart)
	local mass = part:GetMass()
	local gravity = game.Workspace.Gravity

	local weightless_attachment = Instance.new("Attachment")
    weightless_attachment.Name = "weightless_attachment"
	weightless_attachment.Position = Vector3.zero
	weightless_attachment.Parent = part

	local weightless_force = Instance.new("VectorForce")
    weightless_force.Name = "weightless_force"
	weightless_force.Attachment0 = weightless_attachment
	weightless_force.RelativeTo = Enum.ActuatorRelativeTo.World
	weightless_force.Force = Vector3.new(0, mass * gravity, 0)
	weightless_force.Parent = part
end

return forces
