local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local maxStuds = 5 -- Maximum range in studs for wall hop to work
local wallHopCooldown = 0.2 -- Cooldown in seconds between wall hops
local jumpKey = Enum.KeyCode.Space -- Key to trigger wall hop

-- UI Colors
local buttonActiveColor = Color3.fromRGB(85, 255, 85) -- Green for active
local buttonInactiveColor = Color3.fromRGB(255, 85, 85) -- Red for inactive
local textColor = Color3.fromRGB(255, 255, 255) -- White text

-- Remove old UI if it exists
pcall(function() CoreGui:FindFirstChild("WallhopUI"):Destroy() end)

-- Create Main UI Frame
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "WallhopUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0.5, -75, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true

-- Add Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = frame
titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Wallhop Script"
titleLabel.TextSize = 16
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.TextColor3 = textColor
titleLabel.BorderSizePixel = 0

-- Add Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = frame
statusLabel.Size = UDim2.new(1, 0, 0.3, 0)
statusLabel.Position = UDim2.new(0, 0, 0.3, 0)
statusLabel.Text = "Status: Disabled"
statusLabel.TextSize = 14
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusLabel.TextColor3 = textColor
statusLabel.BorderSizePixel = 0

-- Add Button
local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(1, 0, 0.4, 0)
button.Position = UDim2.new(0, 0, 0.6, 0)
button.Text = "Enable Wallhop"
button.TextSize = 16
button.BackgroundColor3 = buttonInactiveColor
button.TextColor3 = textColor
button.BorderSizePixel = 0

-- Wallhop logic
local isWallhopEnabled = false
local lastWallHopTime = 0

-- Function to check if player is touching a wall
local function isTouchingWall()
    local character = LocalPlayer.Character
    if not character then return false end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    -- Raycast to detect walls within maxStuds
    local ray = Ray.new(root.Position, root.CFrame.LookVector * maxStuds)
    local part, position = workspace:FindPartOnRay(ray, character)

    if part and not part:IsDescendantOf(character) then
        local distance = (position - root.Position).Magnitude
        return distance <= maxStuds
    end
    return false
end

-- Wallhop movement logic
local function performWallHop()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Detect jump key press for wallhop
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end -- Ignore processed input
    if input.KeyCode == jumpKey and isWallhopEnabled then
        if tick() - lastWallHopTime > wallHopCooldown and isTouchingWall() then
            performWallHop()
            lastWallHopTime = tick()
        end
    end
end)

-- Button functionality to toggle wallhop
button.MouseButton1Click:Connect(function()
    isWallhopEnabled = not isWallhopEnabled
    if isWallhopEnabled then
        button.Text = "Disable Wallhop"
        button.BackgroundColor3 = buttonActiveColor
        statusLabel.Text = "Status: Enabled"
    else
        button.Text = "Enable Wallhop"
        button.BackgroundColor3 = buttonInactiveColor
        statusLabel.Text = "Status: Disabled"
    end
end)
