local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Creation
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SLegendMenu"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "S-Legend Mod Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
title.TextScaled = true

local function createToggle(name, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Text = name .. " [OFF]"
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. (state and " [ON]" or " [OFF]")
		callback(state)
	end)
end

-- Feature Variables
local autoSkill = false
local autoBlock = false
local autoCounter = false
local behindEnemy = false
local noclip = false
local speedHack = false
local flyMode = false
local invisibility = false
local vipMode = false

-- Toggles
createToggle("AutoSkill", 50, function(v) autoSkill = v end)
createToggle("AutoBlock", 90, function(v) autoBlock = v end)
createToggle("AutoCounter", 130, function(v) autoCounter = v end)
createToggle("Behind Enemy", 170, function(v) behindEnemy = v end)
createToggle("Noclip", 210, function(v)
	noclip = v
	LocalPlayer.Character.Humanoid:ChangeState(v and 11 or 8)
end)
createToggle("Speed Hack", 250, function(v)
	speedHack = v
	if v then
		LocalPlayer.Character.Humanoid.WalkSpeed = 100
	else
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)
createToggle("Fly Mode", 290, function(v)
	flyMode = v
	if not v then
		LocalPlayer.Character.Humanoid.PlatformStand = false
	end
end)
createToggle("Invisibility", 330, function(v)
	invisibility = v
	if LocalPlayer.Character:FindFirstChild("Head") then
		LocalPlayer.Character.Head.Transparency = v and 1 or 0
	end
end)
createToggle("VIP Mode", 370, function(v)
	vipMode = v
	autoSkill = v
	autoBlock = v
	autoCounter = v
	behindEnemy = v
	speedHack = v
	noclip = v
	invisibility = v
end)

-- Core Loops
RunService.RenderStepped:Connect(function()
	if flyMode then
		LocalPlayer.Character.Humanoid:ChangeState(11)
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
	end
end)

RunService.Heartbeat:Connect(function()
	local enemy = nil
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			enemy = p
			break
		end
	end

	if enemy and enemy.Character and LocalPlayer.Character then
		local enemyHRP = enemy.Character:FindFirstChild("HumanoidRootPart")
		local playerHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if behindEnemy then
			playerHRP.CFrame = enemyHRP.CFrame * CFrame.new(0, 0, -3)
		end

		if autoBlock then
			local dist = (enemyHRP.Position - playerHRP.Position).magnitude
			if dist < 8 then
				keypress(0x46) -- F
				wait(0.2)
				keyrelease(0x46)
			end
		end

		if autoCounter then
			if enemyHRP.Velocity.magnitude > 20 then
				keypress(0x47) -- G
				wait(0.2)
				keyrelease(0x47)
			end
		end

		if autoSkill then
			local enemyState = enemy.Character:FindFirstChild("Ragdoll")
			if not enemyState or enemyState.Value == false then
				keypress(0x45) -- E
				wait(0.3)
				keyrelease(0x45)
			end
		end
	end
end)
