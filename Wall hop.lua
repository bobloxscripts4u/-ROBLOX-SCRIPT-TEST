local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Remove old UI if it exists
pcall(function() CoreGui:FindFirstChild("WallhopUI"):Destroy() end)

-- Create UI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "WallhopUI"
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.5, -60, 0.1, 0)
button.Text = "Walking"
button.TextSize = 18
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 2
button.BackgroundTransparency = 0.2
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.Active = true
button.Draggable = true

-- Wallhop logic
local isWallhopEnabled = false
local connection

local function isTouchingWall()
    local character = LocalPlayer.Character
    if not character then return false end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local ray = Ray.new(root.Position, root.CFrame.LookVector * 2)
    local part = workspace:FindPartOnRay(ray, character)
    return part and not part:IsDescendantOf(character)
end

local function startWallhop()
    if not isWallhopEnabled then return end -- Ensure we don't start wallhop when it's disabled
    connection = RunService.RenderStepped:Connect(function()
        if isTouchingWall() then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function stopWallhop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Toggle button functionality
button.MouseButton1Click:Connect(function()
    isWallhopEnabled = not isWallhopEnabled
    if isWallhopEnabled then
        button.Text = "Wallhop On"
        startWallhop()
    else
        button.Text = "Walking"
        stopWallhop()
    end
end)
