local TweenService = game:GetService("TweenService")

local INTERVAL = 0.75 -- measured in seconds, amount of time between each beam segment

local parent
local fade_time = 2

local trails = {}
trails.__index = trails

local function att_tween_properties()
end

function trails.new(
    emitter: Attachment, 
    lifetime: number,
    noise: number
)
    -- this is the part that all the attachments and beams should go to
    if not parent then
        parent = Instance.new("Part")
        
        parent.Transparency = 1
        parent.Position = Vector3.new(0, 0, 0)
        parent.CanCollide = false
        parent.CanQuery = false
        parent.CanTouch = false
        parent.Anchored = true
        parent.Massless = true

        parent.Parent = workspace
    end

    local host = emitter.Parent -- trail takes new positions from this object

    -- things to tween:
    -- position of all the attachments
    -- width0 and width1 of each of the beams
    local tween_info = TweenInfo.new(
        fade_time, -- time for tween to complete
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out, -- default direction is out
        0, -- repeat count (should not be repeating)
        false, -- move back to start after reaching goal?
        0 -- delay before tweening, i dont even really know when this would ever be useful
    )

    -- initial attachment instancing and tweening
    local a0 = Instance.new("Attachment")
    a0.Position = emitter.WorldPosition
    a0.Parent = parent

    return setmetatable({
        host = host,
        emitter = emitter,

        atts = {a0},
        beams = {},

        new_beam_interval = INTERVAL
        -- doesnt start at 0 since, after the interval time, it should immediately create the starting
        -- beam with its corresponding attachment
    }, trails)

end

function trails:update(dt)
    -- after each interval, create a new attachment and beam, and apply tween
    -- on both the new attachment and beam
    if self.new_beam_interval > INTERVAL then

        local new_att = Instance.new("Attachment")
        new_att.Position = self.emitter.WorldPosition
        new_att.Parent = parent

        -- replace beam later, trails.new() should be able to pass in a reference beam in the future
        -- since missiles will have a detailed and proper configuration in the future in ReplicatedStorage
        local beam = Instance.new("Beam")
        beam.Attachment0 = self.atts[#self.atts]
        beam.Attachment1 = new_att
        beam.Parent = parent
        beam.FaceCamera = true
        beam.Width0 = 0.1
        beam.Width1 = 0.1

        table.insert(self.atts, new_att)
        table.insert(self.beams, beam)
        self.new_beam_interval = 0
    else
        local ref3 = workspace:WaitForChild("ref3")
        ref3.Position = self.emitter.WorldPosition
        self.atts[#self.atts].Position = self.emitter.WorldPosition
        print((self.atts[#self.atts].Position - self.emitter.WorldPosition).Magnitude,
        self.atts[#self.atts].Position, self.emitter.WorldPosition)
    end
    self.new_beam_interval += dt
end

return trails