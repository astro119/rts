local TweenService = game:GetService("TweenService")

local DISAPPEAR = 0.6

local parent

local trails = {}
trails.__index = trails

function trails.new(
    template: Beam,
    emitter: Attachment, 
    lifetime: number,
    time_to_max_width: number,
    max_trail_width: number,
    randomness: number,
    resolution: number
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
    -- initial attachment instancing and tweening
    local a0 = Instance.new("Attachment")
    a0.Position = emitter.WorldPosition
    a0.Parent = parent

    return setmetatable({
        template = template,

        host = host,
        emitter = emitter,

        lifetime = lifetime,
        time_to_max_width = time_to_max_width,
        max_trail_width = max_trail_width,
        randomness = randomness * 10,

        d_time = DISAPPEAR * lifetime,

        active_time = 0,
        atts = {a0},
        beams = {},
        beam_time = {},
        beam_fading = {},

        resolution = resolution,
        new_beam_interval = resolution
        -- doesnt start at 0 since, after the interval time, it should immediately create the starting
        -- beam with its corresponding attachment
    }, trails)

end

function trails:update(dt)
    -- after each interval, create a new attachment and beam, and apply tween
    -- on both the new attachment and beam
    if self.new_beam_interval > self.resolution then
        local init_pos = self.emitter.WorldPosition
        local new_att
        local beam
        -- create new beams and attachments
        if self.active_time < self.lifetime then
            new_att = Instance.new("Attachment")
            new_att.Parent = parent
            beam = self.template:Clone()
        beam.Parent = parent
        -- reuse old beams and attachments that are past their lifetime
        else
            new_att = self.atts[1]
            beam = self.beams[1]
            beam.Width0 = self.template.Width0
            beam.Width1 = self.template.Width1
            table.remove(self.atts, 1)
            table.remove(self.beams, 1)
            table.remove(self.beam_time, 1)
            table.remove(self.beam_fading, 1)
        end

        new_att.Position = init_pos
        beam.Attachment0 = self.atts[#self.atts]
        beam.Attachment1 = new_att

        -- attachment to max randomness position
        local tween_info = TweenInfo.new(
            self.lifetime, -- time for tween to complete
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out, -- default direction is out
            0, -- repeat count (should not be repeating)
            false, -- move back to start after reaching goal?
            0 -- delay before tweening, i dont even really know when this would ever be useful
        )

        local tween_att_properties = {
            ["Position"] = Vector3.new(
                init_pos.X + math.random(-self.randomness, self.randomness)/10,
                init_pos.Y + math.random(-self.randomness, self.randomness)/10,
                init_pos.Z + math.random(-self.randomness, self.randomness/10)
            )
        }
        local tween_att = TweenService:Create(new_att, tween_info, tween_att_properties)
        tween_att:Play()

        -- beam to max trail width
        tween_info = TweenInfo.new(
            self.d_time, -- time for tween to complete
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out, -- default direction is out
            0, -- repeat count (should not be repeating)
            false, -- move back to start after reaching goal?
            0 -- delay before tweening, i dont even really know when this would ever be useful
        )

        local tween_beam_properties = {
            ["Width0"] = self.max_trail_width
        }
        local tween_beam = TweenService:Create(beam, tween_info, tween_beam_properties)
        tween_beam:Play()


        -- modify the tables and reset interval
        table.insert(self.atts, new_att)
        table.insert(self.beams, beam)
        table.insert(self.beam_time, 0)
        table.insert(self.beam_fading, false)
        self.new_beam_interval = 0
    else
        -- update attachment positions
        self.atts[#self.atts].Position = self.emitter.WorldPosition

        -- update beam widths
        for i = 1, #self.beams - 1 do

            if self.beam_time[i] > self.d_time and not self.beam_fading[i] then

                -- beam to 0 trail width 
                local tween_info = TweenInfo.new(
                    self.lifetime - self.d_time, -- time for tween to complete
                    Enum.EasingStyle.Exponential,
                    Enum.EasingDirection.Out, -- default direction is out
                    0, -- repeat count (should not be repeating)
                    false, -- move back to start after reaching goal?
                    0 -- delay before tweening, i dont even really know when this would ever be useful
                )
                local tween_beam_properties = {
                    ["Width0"] = 0
                }
                local tween_beam = TweenService:Create(self.beams[i], tween_info, tween_beam_properties)
                tween_beam:Play()
            end
            self.beams[i].Width1 = self.beams[i + 1].Width0
            self.beam_time[i] += dt
        end
    end
    self.active_time += dt
    self.new_beam_interval += dt
    print(self.active_time, self.new_beam_interval)
end

return trails