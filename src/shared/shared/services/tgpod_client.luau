-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- dependencies --
local kinematics = require(ReplicatedStorage.packages.kinematics)
local player_input = require(script.Parent.player_input_client)

-- types --

-- variables --
local tgpod = {}

local cam = false
-- local cam = true

local camera
local root

local ray_params = RaycastParams.new()

-- constants --
local CAM_SENSITIVITY = 0.016
local DEFAULT_CAM_FOV = 70
local USE_SMOOTH_MOUSE_DELTA = false

-- private functions --

-- public functions --
function tgpod:init()
	camera = workspace.CurrentCamera
    if cam then
        camera.CameraType = Enum.CameraType.Scriptable
    end

	root = workspace:WaitForChild("Platform"):WaitForChild("Part")
        
    -- calculate the raycast parameters once, since it likely doesn't need to be updated
    -- every time, unless {terrain} is changed
    ray_params.FilterType = Enum.RaycastFilterType.Whitelist
    ray_params.FilterDescendantsInstances = CollectionService:GetTagged("terrain")

    self.test_part = workspace:WaitForChild("ref")
    self.test_part.Transparency = 1
    
    self.test_part2 = workspace:WaitForChild("ref2")
    self.test_part2.Transparency = 1
end

function tgpod:start()

    local root_kinematics = kinematics.new(root)
    
    local cam_pitch = 0
    local cam_yaw = 0

    local ray_distance = 1000

    local result_position
    local result_distance
    local last_ray_position
    local direction_to_last_ray

    RunService.RenderStepped:Connect(function(dt)
        if cam then
            root_kinematics:update(dt)


            -- PLAYER INPUT
            local mouse_delta = Vector2.zero

            -- decide whether to use raw or smoothed mouse delta values
            if USE_SMOOTH_MOUSE_DELTA then
                mouse_delta = Vector2.new(player_input.smooth_mouse_delta.X, 
                                            player_input.smooth_mouse_delta.Y)
            else
                mouse_delta = Vector2.new(player_input.raw_mouse_delta.X, 
                                            player_input.raw_mouse_delta.Y)
            end

            -- change fov
            camera.FieldOfView = camera.FieldOfView - player_input.scroll_delta
            
            -- doesn't need to be multiplied by dt since mouse_delta is already taken
            -- every renderstepped, at least i think this logic makes sense
            cam_pitch -= mouse_delta.Y 
                        * CAM_SENSITIVITY 
                        * (camera.FieldOfView / DEFAULT_CAM_FOV)
                        + root_kinematics.rot_rate.pitch * dt
            cam_yaw -= mouse_delta.X * CAM_SENSITIVITY * (camera.FieldOfView / DEFAULT_CAM_FOV)
                        - root_kinematics.rot_rate.yaw * dt

            -- copy position of camera to the platform
            -- rotate camera based on mouse input
            -- positive x mouse_delta -> rightward mouse movement
            -- positive y mouse_delta -> downward mouse movement
            camera.CFrame =  root.CFrame
                                * CFrame.Angles(0, cam_yaw, 0) -- apply yaw,
                                * CFrame.Angles(cam_pitch, 0, 0) -- then pitch
                                -- this ensures correct rotational behaviour

            -- ANGLES                    
            local yaw_diff = 0
            local pitch_diff = 0
            -- find cam_yaw and cam_pitch to apply to cframe to look at the last raycast position
            if last_ray_position then
                local local_offset = root.CFrame:PointToObjectSpace(last_ray_position)
                yaw_diff = -math.atan2(local_offset.X, -local_offset.Z)

                local rotation = CFrame.Angles(0, -yaw_diff, 0)
                local rotated = rotation:VectorToWorldSpace(local_offset)
                pitch_diff = math.atan2(rotated.Y, -rotated.Z)

                -- print(  general.round(math.deg(yaw_diff), 2),
                --         general.round(math.deg(pitch_diff), 2))
            end

            -- RAYCASTING
            -- only raycast when player starts moving camera around
            if mouse_delta.X ~= 0 or mouse_delta.Y ~= 0 then
                                
                local ray_origin = camera.CFrame.Position
                local direction = camera.CFrame.LookVector

                local raycast_result = workspace:Raycast(ray_origin, direction * ray_distance, ray_params)

                -- if the ray hits something, then use that result,
                -- if it doesnt, then use a fallback position
                if raycast_result then
                    result_position = raycast_result.Position
                    result_distance = raycast_result.Distance
                else
                    result_position = ray_origin + direction * ray_distance
                    result_distance = ray_distance
                end
                -- print(general.round_vector3(direction), math.round(result_distance), general.round_vector3(result_position))

            -- player not moving the camera, keep it looking at the last known ray position
            -- and update cam_yaw, cam_pitch so that once the player tries to move the camera
            -- it will move correctly
            else
                cam_yaw = yaw_diff
                cam_pitch = pitch_diff
                camera.CFrame =  root.CFrame
                                    * CFrame.Angles(0, cam_yaw, 0) -- apply yaw,
                                    * CFrame.Angles(cam_pitch, 0, 0) -- then pitch
            end
            
            last_ray_position = result_position
            if result_position then
                self.test_part.Position = result_position
            end

            -- print(  general.round(math.deg(yaw_diff), 2),
            --         general.round(math.deg(pitch_diff), 2),
            --         "  ",
            --         general.round(math.deg(cam_yaw), 2),
            --         general.round(math.deg(cam_pitch), 2),
            --         "  ",
            --         general.round(math.deg(cam_yaw - yaw_diff), 2),
            --         general.round(math.deg(cam_pitch - pitch_diff), 2))
        end
    end)
end

-- main --
return tgpod
