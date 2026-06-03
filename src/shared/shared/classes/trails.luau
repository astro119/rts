local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local data = ReplicatedStorage.data

local trail_data = require(data.trail_data)

local FADE_POINT = 0.5

local parent

local trails = {}
trails.__index = trails

function trails.new(
    id,
    trail_cfg
)
    local id = id
    local template = trail_cfg.beam
    local emitter = trail_cfg.emitter
    local lifetime = trail_cfg.lifetime
    local time_to_max_width = trail_cfg.time_to_max_width
    local max_trail_width = trail_cfg.max_trail_width
    local randomness = trail_cfg.randomness
    local resolution = trail_cfg.resolution

    -- this is the part that all the attachments and beams should go to
    if not parent then
        parent = Instance.new("Part")
        
        parent.Name = "client_trails"
        parent.Transparency = 1
        parent.Position = Vector3.new(0, 0, 0)
        parent.CanCollide = false
        parent.CanQuery = false
        parent.CanTouch = false
        parent.Anchored = true
        parent.Massless = true

        parent.Parent = workspace
    end

    -- things to tween:
    -- position of all the attachments
    -- width0 and width1 of each of the beams
    -- initial attachment instancing and tweening
    local a0 = Instance.new("Attachment")
    a0.Position = emitter.WorldPosition
    a0.Parent = parent

    return setmetatable({
        id = id,

        template = template,
        emitter = emitter,

        lifetime = lifetime,
        time_to_max_width = time_to_max_width,
        max_trail_width = max_trail_width,
        randomness = randomness * 10,

        d_time = FADE_POINT * lifetime,

        active = true,
        last_active = true,
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
    -- only update if the emitter is visible and replicated to the client
    

    -- after each interval, create a new attachment and beam, and apply tween
    -- on both the new attachment and beam
    -- this condition only runs every interval (i.e., essentially "once")
    if self.new_beam_interval > self.resolution then
        if self.active then
            
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
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out, -- default direction is out
                0, -- repeat count (should not be repeating)
                false, -- move back to start after reaching goal?
                0 -- delay before tweening, i dont even really know when this would ever be useful
            )

            local tween_att_properties = {
                ["Position"] = Vector3.new(
                    init_pos.X + math.random(-self.randomness, self.randomness)/10,
                    init_pos.Y + math.random(-self.randomness, self.randomness)/10,
                    init_pos.Z + math.random(-self.randomness, self.randomness)/10
                )
            }
            local tween_att = TweenService:Create(new_att, tween_info, tween_att_properties)
            tween_att:Play()

            -- beam to max trail width
            tween_info = TweenInfo.new(
                self.d_time, -- time for tween to complete
                Enum.EasingStyle.Linear,
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
            -- self.new_beam_interval = 0
        end
        self.new_beam_interval = 0

    -- continuous updating loop
    else
        -- update attachment position closest to emitter
        if self.active then
            self.atts[#self.atts].Position = self.emitter.WorldPosition

        -- final beam both widths go to 0 (disappearing) - must manually do this, also only happens once
        else
            if self.beam_time[#self.beams] > self.d_time and not self.beam_fading[#self.beams] then
                local tween_info = TweenInfo.new(
                    (self.lifetime - self.d_time) * 0.9, -- time for tween to complete
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.Out, -- default direction is out
                    0, -- repeat count (should not be repeating)
                    false, -- move back to start after reaching goal?
                    0 -- delay before tweening, i dont even really know when this would ever be useful
                )
                local tween_beam_properties = {
                    ["Width0"] = 0,
                    ["Width1"] = 0
                }
                local tween_beam = TweenService:Create(self.beams[#self.beams], tween_info, tween_beam_properties)
                tween_beam:Play()

                tween_beam.Completed:Connect(function(state)
                    print("stopping because of "..tostring  (state))

                    if state == Enum.PlaybackState.Completed then
                        self:stop()
                    end
                end)
                self.beam_fading[#self.beams] = true
            end
        end

        -- update beam widths
        for i = 1, #self.beams - 1 do

            -- beam to 0 trail width, only happens once at the time the beam needs to fade
            if self.beam_time[i] > self.d_time and not self.beam_fading[i] then

                local tween_info = TweenInfo.new(
                    (self.lifetime - self.d_time) * 0.9, -- time for tween to complete
                    Enum.EasingStyle.Sine,
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

                self.beam_fading[i] = true
            end

            -- continuous update
            -- update forward width of beam with the rear width of the next one
            self.beams[i].Width1 = self.beams[i + 1].Width0
        end

        for i = 1, #self.beams do
            self.beam_time[i] += dt
        end
    end

    if not self.active and self.active_time > self.lifetime * 2 then
        -- self:stop()
    end
    self.last_active = self.active
    self.active_time += dt
    self.new_beam_interval += dt
end

function trails:deactivate()
    self.active = false
    self.active_time = 0

    -- final beam to max width when trail is deactivated
    local tween_info = TweenInfo.new(
        self.d_time, -- time for tween to complete
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out, -- default direction is out
        0, -- repeat count (should not be repeating)
        false, -- move back to start after reaching goal?
        0 -- delay before tweening, i dont even really know when this would ever be useful
    )

    local tween_beam_properties = {
        ["Width1"] = self.max_trail_width
    }
    local tween_beam = TweenService:Create(self.beams[#self.beams], tween_info, tween_beam_properties)
    tween_beam:Play()
end

function trails:stop()
    print("destroying trail")
    for i = 1, #self.beams do
        self.beams[i]:Destroy()
        self.atts[i]:Destroy()
    end
    self.atts[#self.atts]:Destroy()
    self:remove_from_data(trail_data)
    self = nil
end

function trails:remove_from_data(table)
    table[self.id] = nil
end

return trails