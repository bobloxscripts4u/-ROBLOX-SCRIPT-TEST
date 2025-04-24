local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local maxStuds = 4 -- Maximum range for wall detection
local jumpForce = 50 -- Upward force for wall hops
local sidewaysForce = 15 -- Sideways force for realistic wall hop
local jumpKey = Enum.KeyCode.Space -- Key for jumping

-- UI Colors
local buttonActiveColor = Color3.fromRGB(85, 255, 85) -- Green (enabled)
local buttonInactiveColor = Color3.fromRGB(255, 85, 85) -- Red (disabled)
local textColor = Color3.fromRGB(255, 255, 255) -- Text color

-- Remove old UI if it exists
pcall(function() CoreGui:FindFirstChild("WallhopUI"):Destroy() end)

-- Create UI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "WallhopUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0.5, -75, 0.1, 0)
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

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 0.4, 0)
button.Position = UDim2.new(0, 0, 0.6, 0)
button.Text = "Enable Wallhop"
button.TextSize = 16
button.BackgroundColor3 = buttonInactiveColor
button.TextColor3 = textColor

-- Wall hop logic
local isWallhopEnabled = false

-- Function to detect walls
local function isTouchingWall()
    local character = LocalPlayer.Character
    if not character then return false end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    -- Raycast for wall detection
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayResult = workspace:Raycast(root.Position, root.CFrame.LookVector * maxStuds, rayParams)
    return rayResult
end

-- Perform realistic wall hop
local function performWallHop()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoid and rootPart then
        -- Apply upward and sideways velocity
        local wallDetection = isTouchingWall()
        local sidewaysBoost = Vector3.new(sidewaysForce, 0, 0)

        if wallDetection then
            local normal = wallDetection.Normal
            sidewaysBoost = Vector3.new(normal.X * sidewaysForce, 0, normal.Z * sidewaysForce)
        end

        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        rootPart.Velocity = rootPart.Velocity + Vector3.new(0, jumpForce, 0) + sidewaysBoost
    end
end

-- Infinite jump and wall hop functionality
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if input.KeyCode == jumpKey and isWallhopEnabled and not isProcessed then
        performWallHop()
    end
end)

-- Button functionality to toggle wallhop
button.MouseButton1Click:Connect(function()
    isWallhopEnabled = not isWallhopEnabled
    button.Text = isWallhopEnabled and "Disable Wallhop" or "Enable Wallhop"
    button.BackgroundColor3 = isWallhopEnabled and buttonActiveColor or buttonInactiveColor
    statusLabel.Text = isWallhopEnabled and "Status: Enabled" or "Status: Disabled"
end)
