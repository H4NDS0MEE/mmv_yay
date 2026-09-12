-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 1]
-- ====================================================================

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

if PlayerGui:FindFirstChild("QAZX_HUB") then
	PlayerGui.QAZX_HUB:Destroy()
end

_G.QAZX_SETTINGS = {
	espAll = false,
	espMurderer = false,
	espSheriff = false,
	espHero = false,
	espInnocent = false,
	espGun = false,
	autoCoinFarm = false,
	farmSpeed = 32,
	onFullReset = false,
	onFullFling = false,
	sgEnabled = false,
	bombEnabled = false,
	bombCooldown = 2,
	autoTakeEnabled = false,
	invisibleEnabled = false, -- Новая настройка невидимости
	guiVisible = true,
	hideBind = Enum.KeyCode.H
}

local QAZX_HUB = Instance.new("ScreenGui")
QAZX_HUB.Name = "QAZX_HUB"
QAZX_HUB.ResetOnSpawn = false

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
QAZX_HUB.Parent = (success and coreGui) and coreGui or PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
-- Высота увеличена до 940, чтобы поместить новые кнопки телепорта и невидимости
MainFrame.Size = UDim2.new(0, 260, 0, 940)
MainFrame.Position = UDim2.new(0.05, 0, 0.02, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = QAZX_HUB

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 12) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.5 MainStroke.Color = Color3.fromRGB(40, 40, 43) MainStroke.Parent = MainFrame

local function createSectionTitle(text, pos)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -20, 0, 25)
	lbl.Position = pos
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(150, 150, 155)
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = MainFrame
end

createSectionTitle("ESP MENU", UDim2.new(0, 15, 0, 8))

local function createToggleRow(text, pos, settingKey)
	local RowFrame = Instance.new("Frame")
	RowFrame.Size = UDim2.new(1, -20, 0, 36)
	RowFrame.Position = pos
	RowFrame.BackgroundTransparency = 1
	RowFrame.Parent = MainFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 225)
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = RowFrame

	local SwitchBg = Instance.new("TextButton")
	SwitchBg.Size = UDim2.new(0, 40, 0, 22)
	SwitchBg.Position = UDim2.new(1, -40, 0.5, -11)
	SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	SwitchBg.Text = ""
	SwitchBg.AutoButtonColor = false
	SwitchBg.Parent = RowFrame

	local SwitchCorner = Instance.new("UICorner") SwitchCorner.CornerRadius = UDim.new(1, 0) SwitchCorner.Parent = SwitchBg
	local ToggleCircle = Instance.new("Frame") ToggleCircle.Size = UDim2.new(0, 16, 0, 16) ToggleCircle.Position = UDim2.new(0, 3, 0.5, -8) ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) ToggleCircle.BorderSizePixel = 0 ToggleCircle.Parent = SwitchBg
	local CircleCorner = Instance.new("UICorner") CircleCorner.CornerRadius = UDim.new(1, 0) CircleCorner.Parent = ToggleCircle

	local function updateVisual(state)
		if state then
			TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 255, 127)}):Play()
			TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
		else
			TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
			TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
		end
	end

	SwitchBg.MouseButton1Click:Connect(function()
		_G.QAZX_SETTINGS[settingKey] = not _G.QAZX_SETTINGS[settingKey]
		updateVisual(_G.QAZX_SETTINGS[settingKey])
	end)
	updateVisual(_G.QAZX_SETTINGS[settingKey])
end

createToggleRow("ESP All", UDim2.new(0, 10, 0, 35), "espAll")
createToggleRow("ESP Murderer", UDim2.new(0, 10, 0, 70), "espMurderer")
createToggleRow("ESP Sheriff", UDim2.new(0, 10, 0, 105), "espSheriff")
createToggleRow("ESP Hero", UDim2.new(0, 10, 0, 140), "espHero")
createToggleRow("ESP Innocent", UDim2.new(0, 10, 0, 175), "espInnocent")
createToggleRow("ESP Gun (Dropped)", UDim2.new(0, 10, 0, 210), "espGun")
-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 2]
-- ====================================================================

local function createSectionTitle(text, pos)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -20, 0, 25) lbl.Position = pos lbl.BackgroundTransparency = 1 lbl.Text = text lbl.TextColor3 = Color3.fromRGB(150, 150, 155) lbl.Font = Enum.Font.GothamBold lbl.TextSize = 13 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.Parent = MainFrame
end

local function createToggleRow(text, pos, settingKey)
	local RowFrame = Instance.new("Frame")
	RowFrame.Size = UDim2.new(1, -20, 0, 36) RowFrame.Position = pos RowFrame.BackgroundTransparency = 1 RowFrame.Parent = MainFrame
	local Label = Instance.new("TextLabel") Label.Size = UDim2.new(0.7, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Text = text Label.TextColor3 = Color3.fromRGB(220, 220, 225) Label.Font = Enum.Font.GothamMedium Label.TextSize = 13 Label.TextXAlignment = Enum.TextXAlignment.Left Label.Parent = RowFrame
	local SwitchBg = Instance.new("TextButton") SwitchBg.Size = UDim2.new(0, 40, 0, 22) SwitchBg.Position = UDim2.new(1, -40, 0.5, -11) SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45) SwitchBg.Text = "" SwitchBg.AutoButtonColor = false SwitchBg.Parent = RowFrame
	local SwitchCorner = Instance.new("UICorner") SwitchCorner.CornerRadius = UDim.new(1, 0) SwitchCorner.Parent = SwitchBg
	local ToggleCircle = Instance.new("Frame") ToggleCircle.Size = UDim2.new(0, 16, 0, 16) ToggleCircle.Position = UDim2.new(0, 3, 0.5, -8) ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) ToggleCircle.BorderSizePixel = 0 ToggleCircle.Parent = SwitchBg
	local CircleCorner = Instance.new("UICorner") CircleCorner.CornerRadius = UDim.new(1, 0) CircleCorner.Parent = ToggleCircle

	local function updateVisual(state)
		if state then
			TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 255, 127)}):Play()
			TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
		else
			TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
			TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
		end
	end
	SwitchBg.MouseButton1Click:Connect(function() _G.QAZX_SETTINGS[settingKey] = not _G.QAZX_SETTINGS[settingKey] updateVisual(_G.QAZX_SETTINGS[settingKey]) end)
	updateVisual(_G.QAZX_SETTINGS[settingKey])
end

createSectionTitle("Farm", UDim2.new(0, 15, 0, 255))
createToggleRow("Auto Coin Farm", UDim2.new(0, 10, 0, 280), "autoCoinFarm")

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.5, 0, 0, 20) SpeedLabel.Position = UDim2.new(0, 10, 0, 320) SpeedLabel.BackgroundTransparency = 1 SpeedLabel.Text = "Farm Speed:" SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 225) SpeedLabel.Font = Enum.Font.GothamMedium SpeedLabel.TextSize = 13 SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left SpeedLabel.Parent = MainFrame

local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -70, 0, 6) SliderBg.Position = UDim2.new(0, 15, 0, 350) SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45) SliderBg.BorderSizePixel = 0 SliderBg.Parent = MainFrame
local SlCorner = Instance.new("UICorner") SlCorner.CornerRadius = UDim.new(1,0) SlCorner.Parent = SliderBg

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 14, 0, 14) SliderButton.Position = UDim2.new(0.32, -7, 0.5, -7) SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) SliderButton.Text = "" SliderButton.Parent = SliderBg
local btnCr = Instance.new("UICorner") btnCr.CornerRadius = UDim.new(1,0) btnCr.Parent = SliderButton

local SpeedValueBox = Instance.new("TextLabel")
SpeedValueBox.Size = UDim2.new(0, 32, 0, 22) SpeedValueBox.Position = UDim2.new(1, -42, 0, 340) SpeedValueBox.BackgroundColor3 = Color3.fromRGB(24, 24, 28) SpeedValueBox.Text = "32" SpeedValueBox.TextColor3 = Color3.fromRGB(150, 150, 155) SpeedValueBox.Font = Enum.Font.GothamMedium SpeedValueBox.TextSize = 12 SpeedValueBox.Parent = MainFrame
local valCr = Instance.new("UICorner") valCr.CornerRadius = UDim.new(0, 4) valCr.Parent = SpeedValueBox

local slDragging = false
SliderButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then slDragging = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then slDragging = false end end)
UserInputService.InputChanged:Connect(function(input)
	if slDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local absPos = SliderBg.AbsolutePosition.X local absSize = SliderBg.AbsoluteSize.X local mouseX = input.Position.X
		local relativeX = math.clamp((mouseX - absPos) / absSize, 0, 1)
		SliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
		local speedVal = math.floor(1 + (relativeX * 99))
		_G.QAZX_SETTINGS.farmSpeed = speedVal SpeedValueBox.Text = tostring(speedVal)
	end
end)

createToggleRow("On Full: Reset", UDim2.new(0, 10, 0, 370), "onFullReset")
createToggleRow("On Full: Fling Murder", UDim2.new(0, 10, 0, 405), "onFullFling")

createSectionTitle("Fling (Trolls)", UDim2.new(0, 15, 0, 450))

local function createFlingButton(text, pos, actionType)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 36) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28) btn.Text = "<   " .. text btn.TextColor3 = Color3.fromRGB(220, 220, 225) btn.Font = Enum.Font.GothamMedium btn.TextSize = 13 btn.TextXAlignment = Enum.TextXAlignment.Left btn.AutoButtonColor = false btn.Parent = MainFrame
	local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0, 6) cr.Parent = btn
	btn.MouseButton1Click:Connect(function()
		_G.QAZX_TRIGGER_FLING = actionType btn.TextColor3 = Color3.fromRGB(255, 100, 100)
		task.delay(1, function() btn.TextColor3 = Color3.fromRGB(220, 220, 225) end)
	end)
end

createFlingButton("Fling Murderer", UDim2.new(0, 10, 0, 480), "murder")
createFlingButton("Fling Sheriff/Hero", UDim2.new(0, 10, 0, 525), "sheriff")
-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 3]
-- ====================================================================

local function createSectionTitle(text, pos)
	local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, -20, 0, 25) lbl.Position = pos lbl.BackgroundTransparency = 1 lbl.Text = text lbl.TextColor3 = Color3.fromRGB(150, 150, 155) lbl.Font = Enum.Font.GothamBold lbl.TextSize = 13 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.Parent = MainFrame
end

-- НОВАЯ КАТЕГОРИЯ: Teleport & Stealth
createSectionTitle("Teleport & Stealth", UDim2.new(0, 15, 0, 570))

local function createActionBtn(text, pos, triggerKey)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 34) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(28, 28, 33) btn.Text = text btn.TextColor3 = Color3.fromRGB(235, 235, 235) btn.Font = Enum.Font.GothamBold btn.TextSize = 12 btn.Parent = MainFrame
	local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0, 6) cr.Parent = btn
	local str = Instance.new("UIStroke") str.Thickness = 1 str.Color = Color3.fromRGB(50, 50, 55) str.Parent = btn
	btn.MouseButton1Click:Connect(function() _G.QAZX_TRIGGER_TELEPORT = triggerKey btn.TextColor3 = Color3.fromRGB(85, 255, 127) task.wait(0.2) btn.TextColor3 = Color3.fromRGB(235, 235, 235) end)
end

createActionBtn("TP to Map", UDim2.new(0, 10, 0, 600), "map")
createActionBtn("TP to Lobby", UDim2.new(0, 10, 0, 640), "lobby")

-- Тумблер невидимости Invisible в классическом стиле переключателей
local InvFrame = Instance.new("Frame") InvFrame.Size = UDim2.new(1, -20, 0, 36) InvFrame.Position = UDim2.new(0, 10, 0, 680) InvFrame.BackgroundTransparency = 1 InvFrame.Parent = MainFrame
local InvLabel = Instance.new("TextLabel") InvLabel.Size = UDim2.new(0.7, 0, 1, 0) InvLabel.BackgroundTransparency = 1 InvLabel.Text = "Invisible" InvLabel.TextColor3 = Color3.fromRGB(220, 220, 225) InvLabel.Font = Enum.Font.GothamMedium InvLabel.TextSize = 13 InvLabel.TextXAlignment = Enum.TextXAlignment.Left InvLabel.Parent = InvFrame
local InvSwitch = Instance.new("TextButton") InvSwitch.Size = UDim2.new(0, 40, 0, 22) InvSwitch.Position = UDim2.new(1, -40, 0.5, -11) InvSwitch.BackgroundColor3 = Color3.fromRGB(40, 40, 45) InvSwitch.Text = "" InvSwitch.AutoButtonColor = false InvSwitch.Parent = InvFrame
local SwCr = Instance.new("UICorner") SwCr.CornerRadius = UDim.new(1, 0) SwCr.Parent = InvSwitch
local TgCirc = Instance.new("Frame") TgCirc.Size = UDim2.new(0, 16, 0, 16) TgCirc.Position = UDim2.new(0, 3, 0.5, -8) TgCirc.BackgroundColor3 = Color3.fromRGB(255, 255, 255) TgCirc.BorderSizePixel = 0 TgCirc.Parent = InvSwitch
local CrCr = Instance.new("UICorner") CrCr.CornerRadius = UDim.new(1, 0) CrCr.Parent = TgCirc

InvSwitch.MouseButton1Click:Connect(function()
	_G.QAZX_SETTINGS.invisibleEnabled = not _G.QAZX_SETTINGS.invisibleEnabled
	if _G.QAZX_SETTINGS.invisibleEnabled then
		TweenService:Create(InvSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 255, 127)}):Play()
		TweenService:Create(TgCirc, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
	else
		TweenService:Create(InvSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
		TweenService:Create(TgCirc, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
	end
end)

-- Базовые утилиты под чертой
local Line = Instance.new("Frame") Line.Size = UDim2.new(1, -20, 0, 1) Line.Position = UDim2.new(0, 10, 0, 725) Line.BackgroundColor3 = Color3.fromRGB(45, 45, 50) Line.BorderSizePixel = 0 Line.Parent = MainFrame

local function createStandardBtn(text, pos, settingKey)
	local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -20, 0, 34) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) btn.Text = text .. ": OFF" btn.TextColor3 = Color3.fromRGB(235, 235, 235) btn.Font = Enum.Font.GothamBold btn.TextSize = 13 btn.Parent = MainFrame
	local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0, 6) cr.Parent = btn
	local str = Instance.new("UIStroke") str.Thickness = 1 str.Color = Color3.fromRGB(55, 55, 60) str.Parent = btn
	btn.MouseButton1Click:Connect(function()
		_G.QAZX_SETTINGS[settingKey] = not _G.QAZX_SETTINGS[settingKey]
		btn.Text = text .. (_G.QAZX_SETTINGS[settingKey] and ": ON" or ": OFF")
		btn.TextColor3 = _G.QAZX_SETTINGS[settingKey] and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(235, 235, 235)
	end)
end

createStandardBtn("SG FIX", UDim2.new(0, 10, 0, 740), "sgEnabled")
createStandardBtn("Bomb Tool", UDim2.new(0, 10, 0, 785), "bombEnabled")

local CooldownInput = Instance.new("TextBox")
CooldownInput.Size = UDim2.new(1, -20, 0, 30) CooldownInput.Position = UDim2.new(0, 10, 0, 830) CooldownInput.BackgroundColor3 = Color3.fromRGB(24, 24, 28) CooldownInput.Text = "2" CooldownInput.PlaceholderText = "C4 Cooldown..." CooldownInput.TextColor3 = Color3.fromRGB(255, 215, 0) CooldownInput.Font = Enum.Font.GothamMedium CooldownInput.TextSize = 12 CooldownInput.Parent = MainFrame
local InCorner = Instance.new("UICorner") InCorner.CornerRadius = UDim.new(0, 6) InCorner.Parent = CooldownInput
CooldownInput.FocusLost:Connect(function() local n = tonumber(CooldownInput.Text) if n then _G.QAZX_SETTINGS.bombCooldown = n else CooldownInput.Text = tostring(_G.QAZX_SETTINGS.bombCooldown) end end)

createStandardBtn("Auto Take Gun", UDim2.new(0, 10, 0, 870), "autoTakeEnabled")

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputBegan:Connect(function(input, processed) if not processed and input.KeyCode == _G.QAZX_SETTINGS.hideBind then _G.QAZX_SETTINGS.guiVisible = not _G.QAZX_SETTINGS.guiVisible MainFrame.Visible = _G.QAZX_SETTINGS.guiVisible end end)
-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 4]
-- ====================================================================

-- [МОДУЛЬ 1: ОРИГИНАЛЬНЫЙ SG FIX]
local v1, v2, v3, v4, v5 = nil, nil, nil, 0, false local lastSGState = false

local function getAveragePosition(p1)
	local sum = Vector3.new(0, 0, 0) local count = 0
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") and (not v.Anchored and v.Name ~= "TrackerPart") and not (v:FindFirstAncestorOfClass("Tool") ~= nil) then sum = sum + v.Position count = count + 1 end
	end
	if count == 0 then return v2.Position end return sum / count
end

local function zeroOutCharacterMass()
	if not v1 then return end
	for _, v in ipairs(v1:GetDescendants()) do if v:IsA("BasePart") and v ~= v3 and v:FindFirstAncestorOfClass("Tool") == nil then v.CustomPhysicalProperties = PhysicalProperties.new(0.2, 0.3, 0.5, 1, 1) end end
end

local v7 = 0
local function safeUpdate()
	if not _G.QAZX_SETTINGS.sgEnabled or not v1 or not v2 then return end
	local v12 = tick() if v12 - v7 < 0.2 then return end v7 = v12
	if not v3 then
		local TrackerPart = Instance.new("Part") TrackerPart.Name = "TrackerPart" TrackerPart.Size = Vector3.new(2, 2, 2) TrackerPart.Transparency = 1 TrackerPart.CanCollide = false TrackerPart.Anchored = false TrackerPart.Parent = v1
		local WeldConstraint = Instance.new("WeldConstraint") WeldConstraint.Part0 = TrackerPart WeldConstraint.Part1 = v2 WeldConstraint.Parent = TrackerPart v3 = TrackerPart
	end
	local v22 = getAveragePosition(v1) v3.Position = v22 + (v22 - v2.Position) * 0.35 zeroOutCharacterMass()
	if not v3 then return end local v32 = v3.Size.X * v3.Size.Y * v3.Size.Z local density = (v32 > 0) and (v4 / v32) or 1
	v3.CustomPhysicalProperties = PhysicalProperties.new(math.clamp(density, 0.1, 35), 0.3, 0.5, 1, 1)
end

RunService.Heartbeat:Connect(function() if _G.QAZX_SETTINGS.sgEnabled then safeUpdate() lastSGState = true elseif not _G.QAZX_SETTINGS.sgEnabled and lastSGState then if v3 then v3:Destroy() v3 = nil end lastSGState = false end end)

local function onCharacter(p1)
	if not p1 then return end v1 = p1 if v3 then v3:Destroy() v3 = nil end
	task.delay(1, function()
		v2 = v1:WaitForChild("HumanoidRootPart", 5) if not v2 then return end v5 = true
		while v2.AssemblyMass < 0.01 do task.wait(0.1) end v4 = v2.AssemblyMass
		v1.DescendantAdded:Connect(function(part) if part:FindFirstAncestorOfClass("Tool") == nil then task.defer(safeUpdate) end end)
		v1.DescendantRemoving:Connect(function(part) if part:FindFirstAncestorOfClass("Tool") == nil then task.defer(safeUpdate) end end)
	end)
end
LocalPlayer.CharacterAdded:Connect(onCharacter) if LocalPlayer.Character then task.spawn(onCharacter, LocalPlayer.Character) end

-- [МОДУЛЬ 2: ВАША ЗОЛОТАЯ C4 БОМБА]
local Mouse = LocalPlayer:GetMouse() local CurrentDroppedBomb = nil local CanUseBomb = true

local function BuildC4()
	local Main = Instance.new("Part") Main.Name = "Handle" Main.Size = Vector3.new(1.8, 0.7, 1.2) Main.BrickColor = BrickColor.new("Bright yellow") Main.Material = Enum.Material.SmoothPlastic Main.CanCollide = true
	local Mesh = Instance.new("SpecialMesh") Mesh.MeshId = "rbxassetid://104516854" Mesh.TextureId = "rbxassetid://104516981" Mesh.Scale = Vector3.new(1.5, 1.2, 1.35) Mesh.VertexColor = Vector3.new(1, 0.84, 0) Mesh.Parent = Main return Main
end

local function CleanOldBombFromInventory()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gold C4 Bomb") then LocalPlayer.Character["Gold C4 Bomb"]:Destroy() end
	if LocalPlayer.Backpack:FindFirstChild("Gold C4 Bomb") then LocalPlayer.Backpack["Gold C4 Bomb"]:Destroy() end
end

local function GiveTool()
	if not _G.QAZX_SETTINGS.bombEnabled then return end CleanOldBombFromInventory()
	local Tool = Instance.new("Tool") Tool.Name = "Gold C4 Bomb" Tool.TextureId = "rbxassetid://1317188024" Tool.RequiresHandle = true Tool.CanBeDropped = false Tool.Grip = CFrame.new(0, -0.2, 0.2) * CFrame.Angles(0, math.rad(180), 0) BuildC4().Parent = Tool
	Tool.Activated:Connect(function()
		if not CanUseBomb or not _G.QAZX_SETTINGS.bombEnabled then return end local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end
		CanUseBomb = false if CurrentDroppedBomb then pcall(function() CurrentDroppedBomb:Destroy() end) end
		local d_handle = BuildC4() d_handle.CFrame = hrp.CFrame * CFrame.new(0, -3.2, 0) d_handle.Parent = Workspace CurrentDroppedBomb = d_handle
		local bv = Instance.new("BodyVelocity", d_handle) bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) bv.Velocity = ((Mouse.Hit.p - hrp.Position).Unit * 25) + Vector3.new(0, 10, 0) game.Debris:AddItem(bv, 0.1)
		local parts = {} for _, p in pairs(Tool:GetChildren()) do if p:IsA("BasePart") then parts[p] = p.Transparency p.Transparency = 1 local m = p:FindFirstChildOfClass("SpecialMesh") if m then m.Scale = Vector3.new(0, 0, 0) end end end
		task.wait(_G.QAZX_SETTINGS.bombCooldown) if CurrentDroppedBomb then pcall(function() CurrentDroppedBomb:Destroy() end) CurrentDroppedBomb = nil end
		for p, trans in pairs(parts) do if p and p.Parent then p.Transparency = trans local m = p:FindFirstChildOfClass("SpecialMesh") if m then m.Scale = Vector3.new(1.5, 1.2, 1.35) end end end CanUseBomb = true
	end)
	Tool.Parent = LocalPlayer.Backpack
end

RunService.Heartbeat:Connect(function()
	if _G.QAZX_SETTINGS.bombEnabled and not LocalPlayer.Backpack:FindFirstChild("Gold C4 Bomb") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gold C4 Bomb")) then GiveTool() elseif not _G.QAZX_SETTINGS.bombEnabled then CleanOldBombFromInventory() end
end)
-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 5]
-- ====================================================================

task.spawn(function()
	local function applyEsp(character)
		if not character then return end if character:FindFirstChild("QAZX_Highlight") then character.QAZX_Highlight:Destroy() end
		local highlight = Instance.new("Highlight") highlight.Name = "QAZX_Highlight" highlight.OutlineColor = Color3.fromRGB(0, 0, 0) highlight.FillTransparency = 0.4 highlight.Enabled = false highlight.Parent = character
	end
	for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then p.CharacterAdded:Connect(applyEsp) if p.Character then applyEsp(p.Character) end end end
	Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then p.CharacterAdded:Connect(applyEsp) end end)

	while task.wait(0.1) do
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("QAZX_Highlight") then
				local high = p.Character.QAZX_Highlight local backpack = p:FindFirstChild("Backpack")
				local isMurder = p.Character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
				local isSheriff = p.Character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
				local isHero = p.Character:FindFirstChild("FakeGun") or (backpack and backpack:FindFirstChild("FakeGun"))
				local isInnocent = not (isMurder or isSheriff or isHero) local render, color = false, Color3.fromRGB(255, 255, 255)

				if _G.QAZX_SETTINGS.espAll then render = true
					if isMurder then color = Color3.fromRGB(255, 0, 0) elseif isSheriff then color = Color3.fromRGB(0, 0, 255) elseif isHero then color = Color3.fromRGB(255, 170, 0) else color = Color3.fromRGB(0, 255, 0) end
				else
					if isMurder and _G.QAZX_SETTINGS.espMurderer then render = true color = Color3.fromRGB(255, 0, 0)
					elseif isSheriff and _G.QAZX_SETTINGS.espSheriff then render = true color = Color3.fromRGB(0, 0, 255)
					elseif isHero and _G.QAZX_SETTINGS.espHero then render = true color = Color3.fromRGB(255, 170, 0)
					elseif isInnocent and _G.QAZX_SETTINGS.espInnocent then render = true color = Color3.fromRGB(0, 255, 0) end
				end
				high.Enabled = render high.FillColor = color
			end
		end
	end
end)

task.spawn(function()
	local lastFarmTime = 0
	local function getDroppedGun()
		local g = Workspace:FindFirstChild("GunDrop") if not g then for _, v in ipairs(Workspace:GetChildren()) do if v:IsA("Tool") and v.Name == "Gun" then g = v break end end end return g
	end

	RunService.Heartbeat:Connect(function()
		local gun = getDroppedGun()
		if gun and _G.QAZX_SETTINGS.autoTakeEnabled and LocalPlayer.Character then
			local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") local part = gun:IsA("BasePart") and gun or gun:FindFirstChild("Handle") if root and part then root.CFrame = part.CFrame end
		end
		if gun and _G.QAZX_SETTINGS.espGun then
			if not gun:FindFirstChild("QAZX_Gun_Esp") then local hl = Instance.new("Highlight") hl.Name = "QAZX_Gun_Esp" hl.FillColor = Color3.fromRGB(0, 255, 255) hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.Parent = gun end
		else if gun and gun:FindFirstChild("QAZX_Gun_Esp") then gun["QAZX_Gun_Esp"]:Destroy() end end

		-- [ОБНОВЛЕНИЕ: КЛИЕНТСКАЯ НЕВИДИМОСТЬ (Invisible)]
		if LocalPlayer.Character then
			for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") or part:IsA("Decal") then
					if part.Name ~= "HumanoidRootPart" then
						part.Transparency = _G.QAZX_SETTINGS.invisibleEnabled and 1 or 0
					end
				end
			end
		end

		-- [ОБНОВЛЕНИЕ: ВЫПОЛНЕНИЕ ТЕЛЕПОРТОВ ПО ТРИГГЕРУ]
		if _G.QAZX_TRIGGER_TELEPORT and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local key = _G.QAZX_TRIGGER_TELEPORT _G.QAZX_TRIGGER_TELEPORT = nil
			local root = LocalPlayer.Character.HumanoidRootPart
			if key == "lobby" then
				local lobbyZone = Workspace:FindFirstChild("Lobby") or Workspace:FindFirstChild("LobbyZone") or Workspace:FindFirstChild("SpawnLocation")
				if lobbyZone then root.CFrame = lobbyZone:IsA("Model") and (lobbyZone.PrimaryPart and lobbyZone.PrimaryPart.CFrame or lobbyZone:FindFirstChildOfClass("BasePart").CFrame) or lobbyZone.CFrame + Vector3.new(0,3,0) end
			elseif key == "map" then
				local normalMap = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("Map")
				if normalMap then local targetSpawn = normalMap:FindFirstChildOfClass("SpawnLocation") or normalMap:FindFirstChildOfClass("Part") or normalMap:FindFirstChildOfClass("MeshPart")
					if targetSpawn then root.CFrame = targetSpawn.CFrame + Vector3.new(0,5,0) end end
			end
		end

		if _G.QAZX_SETTINGS.autoCoinFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local now = tick() if now - lastFarmTime >= (1 / _G.QAZX_SETTINGS.farmSpeed) then lastFarmTime = now local root = LocalPlayer.Character.HumanoidRootPart
				for _, obj in ipairs(Workspace:GetDescendants()) do
					if obj.Name == "Coin_Server" and obj:FindFirstChild("TouchInterest") then
						firetouchinterest(root, obj, 0) task.wait(0.01) firetouchinterest(root, obj, 1)
						local leaderstats = LocalPlayer:FindFirstChild("leaderstats") local coinsStat = leaderstats and (leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Монеты"))
						if coinsStat and coinsStat.Value >= 40 then if _G.QAZX_SETTINGS.onFullReset then LocalPlayer.Character:BreakJoints() elseif _G.QAZX_SETTINGS.onFullFling then _G.QAZX_TRIGGER_FLING = "murder" end end break
					end
				end
			end
		end
		
		if _G.QAZX_TRIGGER_FLING and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetRole = _G.QAZX_TRIGGER_FLING _G.QAZX_TRIGGER_FLING = nil local targetPlayer = nil
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local bp = p:FindFirstChild("Backpack") local isM = p.Character:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) local isS = p.Character:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) or p.Character:FindFirstChild("FakeGun") or (bp and bp:FindFirstChild("FakeGun"))
					if targetRole == "murder" and isM then targetPlayer = p break elseif targetRole == "sheriff" and isS then targetPlayer = p break end
				end
			end
			if targetPlayer and targetPlayer.Character then
				local root = LocalPlayer.Character.HumanoidRootPart local tRoot = targetPlayer.Character.HumanoidRootPart local oldCFrame = root.CFrame
				local bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(1e7, 1e7, 1e7) bv.Velocity = Vector3.new(9e5, 9e5, 9e5) bv.Parent = root
				for i = 1, 30 do root.CFrame = tRoot.CFrame task.wait(0.01) end bv:Destroy() root.CFrame = oldCFrame
			end
		end
	end)
end)

print("[QAZX HUB]: Все функции телепортов и невидимости успешно интегрированы!");
