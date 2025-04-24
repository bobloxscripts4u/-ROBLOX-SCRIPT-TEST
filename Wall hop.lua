local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local upwardForce = 50 -- Upward velocity for jumps

-- UI Colors
local enabledColor = Color3.fromRGB(85, 255, 85) -- Green when enabled
local disabledColor = Color3.fromRGB(255, 85, 85) -- Red when disabled
local textColor = Color3.fromRGB(255, 255, 255) -- White text

-- Remove old UI if it exists
pcall(function() CoreGui:FindFirstChild("InfiniteJumpUI"):Destroy() end)

-- Create UI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "InfiniteJumpUI"
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
titleLabel.Text = "Infinite Jump Script"
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
toggleButton.Text = "Enable Infinite Jump"
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = disabledColor
toggleButton.TextColor3 = textColor

-- Variables for infinite jump
local infiniteJumpEnabled = false

-- Perform a jump
local function performJump()
    local character = LocalPlayer.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid and rootPart then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Trigger jump
        rootPart.Velocity = rootPart.Velocity + Vector3.new(0, upwardForce, 0) -- Apply upward force
    end
end

-- Handle jump input
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if infiniteJumpEnabled and not isProcessed then
        if input.KeyCode == Enum.KeyCode.Space then -- Desktop: Spacebar
            performJump()
        end
    end
end)

-- Mobile support for jump input
UserInputService.TouchTap:Connect(function()
    if infiniteJumpEnabled then
        performJump()
    end
end)

-- Toggle infinite jump functionality
toggleButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    toggleButton.Text = infiniteJumpEnabled and "Disable Infinite Jump" or "Enable Infinite Jump"
    toggleButton.BackgroundColor3 = infiniteJumpEnabled and enabledColor or disabledColor
    statusLabel.Text = infiniteJumpEnabled and "Status: Enabled" or "Status: Disabled"
end)
