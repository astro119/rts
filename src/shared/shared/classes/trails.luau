local TweenService = game:GetService("TweenService")

local RESOLUTION = 0.2 -- measured in seconds, amount of time between each beam segment

local parent

local trails = {}
trails.__index = trails

function trails.new(
    template: Beam,
    emitter: Attachment, 
    max_trail_width: number,
    lifetime: number,
    randomness: number
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
        lifetime, -- time for tween to complete
        Enum.EasingStyle.Cubic,
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
        template = template,

        host = host,
        emitter = emitter,

        tween_info = tween_info,
        max_trail_width = max_trail_width,
        lifetime = lifetime,
        randomness = randomness * 10,

        atts = {a0},
        beams = {},

        new_beam_interval = RESOLUTION
        -- doesnt start at 0 since, after the interval time, it should immediately create the starting
        -- beam with its corresponding attachment
    }, trails)

end

function trails:update(dt)
    -- after each interval, create a new attachment and beam, and apply tween
    -- on both the new attachment and beam
    if self.new_beam_interval > RESOLUTION then

        -- new attachment configuration
        local init_pos = self.emitter.WorldPosition
        local new_att = Instance.new("Attachment")
        new_att.Position = init_pos
        new_att.Parent = parent

        local tween_att_properties = {
            ["Position"] = Vector3.new(
                init_pos.X + math.random(-self.randomness, self.randomness)/10,
                init_pos.Y + math.random(-self.randomness, self.randomness)/10,
                init_pos.Z + math.random(-self.randomness, self.randomness/10)
            )
        }
        local tween_att = TweenService:Create(new_att, self.tween_info, tween_att_properties)
        tween_att:Play()

        -- new beam configuration
        local beam = self.template:Clone()
        beam.Attachment0 = self.atts[#self.atts]
        beam.Attachment1 = new_att
        beam.Parent = parent

        local tween_beam_properties = {
            ["Width0"] = self.max_trail_width
        }
        local tween_beam = TweenService:Create(beam, self.tween_info, tween_beam_properties)
        tween_beam:Play()

        -- modify the tables and reset interval
        table.insert(self.atts, new_att)
        table.insert(self.beams, beam)
        self.new_beam_interval = 0
    else
        -- update attachment positions
        self.atts[#self.atts].Position = self.emitter.WorldPosition

        -- update beam widths
        for i = 1, #self.beams - 1 do
            self.beams[i].Width1 = self.beams[i + 1].Width0
        end
    end
    self.new_beam_interval += dt
end

return trails