--// TSB Morning Mode v2 - Smart Skills Edition //--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Create GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TSBModMenu"

-- Floating "S" Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.Text = "S"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Draggable = true
toggleBtn.Active = true

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 60, 0.5, -100)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Visible = false
frame.Draggable = true
frame.Active = true

local uilist = Instance.new("UIListLayout", frame)
uilist.Padding = UDim.new(0, 5)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Morning Mod Menu v2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true

-- Toggles
local toggles = {
	morning = false,
	autofarm = false,
	autoskill = false,
	autoblock = false,
	autocounter = false
}

-- Utility: Find closest enemy
local function getClosestTarget()
	local closest, dist = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if mag < dist and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
				closest = p
				dist = mag
			end
		end
	end
	return closest
end

-- Button creation helper
local function createButton(name, func)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.MouseButton1Click:Connect(func)
end

-- Morning Mode
createButton("Morning Mode: Toggle All", function()
	toggles.morning = not toggles.morning
	toggles.autofarm = toggles.morning
	toggles.autoskill = toggles.morning
	toggles.autoblock = toggles.morning
	toggles.autocounter = toggles.morning
end)

-- Fly Mode
local flying = false
createButton("Toggle Fly", function()
	flying = not flying
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if flying and hrp then
		local bodyGyro = Instance.new("BodyGyro", hrp)
		local bodyVel = Instance.new("BodyVelocity", hrp)
		bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bodyVel.Velocity = Vector3.zero
		bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		RunService:BindToRenderStep("Fly", Enum.RenderPriority.Camera.Value + 1, function()
			bodyVel.Velocity = Vector3.new(
				(UIS:IsKeyDown(Enum.KeyCode.D) and 50 or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and 50 or 0),
				(UIS:IsKeyDown(Enum.KeyCode.Space) and 50 or 0) - (UIS:IsKeyDown(Enum.KeyCode.LeftControl) and 50 or 0),
				(UIS:IsKeyDown(Enum.KeyCode.S) and 50 or 0) - (UIS:IsKeyDown(Enum.KeyCode.W) and 50 or 0)
			)
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end)
	else
		RunService:UnbindFromRenderStep("Fly")
		if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
		if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
	end
end)

-- Invisibility
createButton("Toggle Invisibility", function()
	for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = part.Transparency == 1 and 0 or 1
		end
	end
end)

-- Automation Logic
RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local humanoid = char and char:FindFirstChild("Humanoid")

	local target = getClosestTarget()
	local isValid = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid")
	local knocked = isValid and (target.Character:FindFirstChild("Knocked") or target.Character:FindFirstChild("Ragdolled"))

	-- AutoFarm
	if toggles.autofarm and isValid and not knocked then
		root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		mouse1click()
	end

	-- AutoSkill (smart cast)
	if toggles.autoskill and isValid and not knocked then
		local keys = {"Z", "X", "C", "V"}
		for _, key in pairs(keys) do
			keypress(Enum.KeyCode[key])
			wait(0.25)
			keyrelease(Enum.KeyCode[key])
		end
	end

	-- AutoBlock
	if toggles.autoblock and humanoid and humanoid.Health > 0 then
		keypress(Enum.KeyCode.F)
		wait(0.1)
		keyrelease(Enum.KeyCode.F)
	end

	-- AutoCounter
	if toggles.autocounter and humanoid and humanoid.Health < 70 then
		keypress(Enum.KeyCode.G)
		wait(0.1)
		keyrelease(Enum.KeyCode.G)
	end
end)

-- Toggle Menu
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
