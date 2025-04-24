local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local maxWallDistance = 4 -- Maximum distance to detect a wall
local upwardForce = 50 -- Upward velocity for jumps
local sidewaysForce = 15 -- Sideways velocity for wall hops

-- UI Colors
local enabledColor = Color3.fromRGB(85, 255, 85) -- Green when enabled
local disabledColor = Color3.fromRGB(255, 85, 85) -- Red when disabled
local textColor = Color3.fromRGB(255, 255, 255) -- White text

-- Remove old UI if it exists
pcall(function() CoreGui:FindFirstChild("WallhopUI"):Destroy() end)

-- Create UI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "WallhopUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
titleLabel.Text = "Wallhop Script"
titleLabel.TextSize = 16
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.TextColor3 = textColor

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0.3, 0)
statusLabel.Position = UDim2.new(0, 0, 0.3, 0)
statusLabel.Text = "Status: Disabled"
statusLabel.TextSize = 14
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusLabel.TextColor3 = textColor

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, 0, 0.4, 0)
toggleButton.Position = UDim2.new(0, 0, 0.6, 0)
toggleButton.Text = "Enable Wallhop"
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = disabledColor
toggleButton.TextColor3 = textColor

-- Variables for wallhop and infinite jump
local wallhopEnabled = false
local infiniteJumping = false

-- Detect walls
local function detectWall()
    local character = LocalPlayer.Character
    if not character then return nil end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    -- Raycast to detect walls
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayDirection = rootPart.CFrame.LookVector * maxWallDistance
    local rayResult = workspace:Raycast(rootPart.Position, rayDirection, rayParams)

    return rayResult
end

-- Perform realistic wall hop
local function performWallHop()
    local character = LocalPlayer.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid and rootPart then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Trigger jump

        -- Apply upward and sideways velocity
        local wall = detectWall()
        local sidewaysBoost = Vector3.new(0, 0, 0)

        if wall then
            local wallNormal = wall.Normal
            sidewaysBoost = Vector3.new(wallNormal.X * sidewaysForce, 0, wallNormal.Z * sidewaysForce)
        end

        rootPart.Velocity = rootPart.Velocity + Vector3.new(0, upwardForce, 0) + sidewaysBoost
    end
end

-- Infinite jump loop
local function startInfiniteJump()
    infiniteJumping = true
    RunService.RenderStepped:Connect(function()
        if infiniteJumping then
            performWallHop()
        end
    end)
end

local function stopInfiniteJump()
    infiniteJumping = false
end

-- Mobile support for wallhop (touch)
UserInputService.TouchTap:Connect(function()
    if wallhopEnabled then
        performWallHop()
    end
end)

-- Desktop support for wallhop (spacebar)
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if input.KeyCode == Enum.KeyCode.Space and wallhopEnabled and not isProcessed then
        performWallHop()
    end
end)

-- Toggle wallhop functionality
toggleButton.MouseButton1Click:Connect(function()
    wallhopEnabled = not wallhopEnabled
    toggleButton.Text = wallhopEnabled and "Disable Wallhop" or "Enable Wallhop"
    toggleButton.BackgroundColor3 = wallhopEnabled and enabledColor or disabledColor
    statusLabel.Text = wallhopEnabled and "Status: Enabled" or "Status: Disabled"

    -- Start or stop infinite jumping
    if wallhopEnabled then
        startInfiniteJump()
    else
        stopInfiniteJump()
    end
end)
