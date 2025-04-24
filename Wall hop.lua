local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FlingUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.02, 0, 0.4, 0)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Fling: OFF"
button.TextScaled = true
button.Draggable = true
button.Active = true

-- Create fling block
local flingBlock = Instance.new("Part")
flingBlock.Size = Vector3.new(4, 4, 4)
flingBlock.Shape = Enum.PartType.Block
flingBlock.Color = Color3.fromRGB(255, 0, 0)
flingBlock.Material = Enum.Material.Neon
flingBlock.Transparency = 0.3
flingBlock.Anchored = false
flingBlock.CanCollide = false
flingBlock.Massless = true
flingBlock.Name = "FlingBlock"
flingBlock.Parent = workspace

-- Attach to player
local attachPart = character:WaitForChild("HumanoidRootPart")
local weld = Instance.new("WeldConstraint")
weld.Part0 = flingBlock
weld.Part1 = attachPart
weld.Parent = flingBlock
flingBlock.CFrame = attachPart.CFrame * CFrame.new(0, 0, -3)

-- Fling logic
local flingEnabled = false

local function updateFling()
	if flingEnabled then
		button.Text = "Fling: ON"
	else
		button.Text = "Fling: OFF"
	end
end

-- Toggle button click
button.MouseButton1Click:Connect(function()
	flingEnabled = not flingEnabled
	updateFling()
end)

-- Constant flinging loop
RunService.RenderStepped:Connect(function()
	if flingEnabled then
		pcall(function()
			flingBlock.Velocity = Vector3.new(
				math.random(-5000, 5000),
				math.random(-5000, 5000),
				math.random(-5000, 5000)
			)
		end)
	else
		flingBlock.Velocity = Vector3.zero
	end
end)

-- Fling touch
flingBlock.Touched:Connect(function(hit)
	if not flingEnabled then return end
	local char = hit:FindFirstAncestorOfClass("Model")
	if char and char:FindFirstChild("Humanoid") and char ~= character then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(9999, 9999, 9999)
		end
	end
end)

updateFling()
