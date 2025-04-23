--// Simple Roblox Mod Menu (Executor GUI) //--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ModMenu"

-- Frame
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "Mod Menu"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true

-- Target Input
local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Enter player name"
input.Position = UDim2.new(0.05, 0, 0.2, 0)
input.Size = UDim2.new(0.9, 0, 0, 30)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Utility function
local function getPlayer(name)
	for _, p in pairs(Players:GetPlayers()) do
		if string.lower(p.Name):sub(1, #name) == string.lower(name) then
			return p
		end
	end
end

-- Kill Button
local killBtn = Instance.new("TextButton", frame)
killBtn.Text = "Kill"
killBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
killBtn.Size = UDim2.new(0.9, 0, 0, 30)
killBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

killBtn.MouseButton1Click:Connect(function()
	local target = getPlayer(input.Text)
	if target and target.Character then
		target.Character:BreakJoints()
	end
end)

-- Speed Button
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Text = "Set Speed (100)"
speedBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
speedBtn.Size = UDim2.new(0.9, 0, 0, 30)
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

speedBtn.MouseButton1Click:Connect(function()
	local target = getPlayer(input.Text)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.WalkSpeed = 100
	end
end)

-- Fake Kick Button
local kickBtn = Instance.new("TextButton", frame)
kickBtn.Text = "Fake Kick"
kickBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
kickBtn.Size = UDim2.new(0.9, 0, 0, 30)
kickBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 0)
kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

kickBtn.MouseButton1Click:Connect(function()
	local target = getPlayer(input.Text)
	if target then
		target:Kick("Fake kicked by ModMenu")
	end
end)
