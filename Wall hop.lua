-- No Cooldown Tool Bypass + Floating UI Toggle | Delta-Compatible

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

-- Create UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CooldownBypassMenu"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 100, 0, 40)
btn.Position = UDim2.new(0.01, 0, 0.45, 0)
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "No Cooldown: OFF"
btn.Active = true
btn.Draggable = true

-- Main Logic
local noCooldownEnabled = false
local toolConnections = {}

function enableCooldownBypass(tool)
    if not tool:IsA("Tool") then return end
    if toolConnections[tool] then return end

    for _, v in pairs(tool:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            v.Disabled = true
        end
    end

    local con = tool.Activated:Connect(function()
        if noCooldownEnabled then
            local fire = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChildWhichIsA("RemoteEvent", true)
            if fire then
                for i = 1, 3 do
                    fire:FireServer()
                    task.wait(0.05)
                end
            end
        end
    end)
    toolConnections[tool] = con
end

function setupTools()
    for _, tool in ipairs(lp.Backpack:GetChildren()) do
        enableCooldownBypass(tool)
    end
    for _, tool in ipairs(char:GetChildren()) do
        enableCooldownBypass(tool)
    end
end

-- Monitor for new tools
lp.Backpack.ChildAdded:Connect(enableCooldownBypass)
char.ChildAdded:Connect(enableCooldownBypass)

-- Button toggle
btn.MouseButton1Click:Connect(function()
    noCooldownEnabled = not noCooldownEnabled
    btn.Text = noCooldownEnabled and "No Cooldown: ON" or "No Cooldown: OFF"
    if noCooldownEnabled then
        setupTools()
    end
end)
