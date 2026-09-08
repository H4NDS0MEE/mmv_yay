-- Ожидание полной загрузки игры (критично для инжекторов)
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Безопасное ожидание папки PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

-- Удаление старой копии GUI, если скрипт запускается повторно
if PlayerGui:FindFirstChild("TrackerGUI") then
	PlayerGui.TrackerGUI:Destroy()
end

-- Создание GUI
local TrackerGUI = Instance.new("ScreenGui")
TrackerGUI.Name = "TrackerGUI"
TrackerGUI.ResetOnSpawn = false
-- Использование CoreGui (если инжектор поддерживает), либо стандартный PlayerGui
local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
TrackerGUI.Parent = (success and coreGui) and coreGui or PlayerGui

-- Главный фрейм (Контейнер)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 110)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0) -- Дефолтная позиция слева по центру
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = TrackerGUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(60, 60, 60)
MainStroke.Parent = MainFrame

-- Заголовок панели
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SG FIX"
TitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.Parent = MainFrame

-- Кнопка переключения
local TextButton = Instance.new("TextButton")
TextButton.Name = "ToggleButton"
TextButton.Size = UDim2.new(1, -20, 0, 50)
TextButton.Position = UDim2.new(0, 10, 0, 45)
TextButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextButton.Text = "SG OFF"
TextButton.TextColor3 = Color3.fromRGB(235, 235, 235)
TextButton.Font = Enum.Font.GothamMedium
TextButton.TextSize = 16
TextButton.AutoButtonColor = false
TextButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = TextButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Thickness = 1
ButtonStroke.Color = Color3.fromRGB(80, 80, 80)
ButtonStroke.Parent = TextButton

-- Скрипт перемещения (Drag and Drop)
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Эффекты для кнопки (Hover / Click)
TextButton.MouseEnter:Connect(function()
	TweenService:Create(TextButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)

TextButton.MouseLeave:Connect(function()
	TweenService:Create(TextButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
end)

-- Логика самого скрипта
local v1 = nil
local v2 = nil
local v3 = nil
local v4 = 0
local v5 = false
local v6 = false

TextButton.MouseButton1Click:Connect(function()
	v6 = not v6

	if v6 then
		TextButton.Text = "SG ON"
		TextButton.TextColor3 = Color3.fromRGB(85, 255, 127)
		return
	end

	TextButton.Text = "SG OFF"
	TextButton.TextColor3 = Color3.fromRGB(235, 235, 235)

	if not v3 then
		return
	end

	v3:Destroy()
	v3 = nil
end)

local function isToolPart(p1)
	return p1:FindFirstAncestorOfClass("Tool") ~= nil
end

local function getAveragePosition(p1)
	local sum = Vector3.new(0, 0, 0)
	local count = 0

	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") and (not v.Anchored and v.Name ~= "TrackerPart") and not (if v:FindFirstAncestorOfClass("Tool") == nil then false else true) then
			sum = sum + v.Position
			count = count + 1
		end
	end

	if count == 0 then
		return v2.Position
	end

	return sum / count
end

local function zeroOutCharacterMass()
	if not v1 then return end
	for i, v in ipairs(v1:GetDescendants()) do
		if v:IsA("BasePart") and v ~= v3 and v:FindFirstAncestorOfClass("Tool") == nil then
			v.CustomPhysicalProperties = PhysicalProperties.new(0.2, 0.3, 0.5, 1, 1)
		end
	end
end

local v7 = 0

local function safeUpdate()
	if not v6 or not v1 or not v2 then
		return
	end

	local v12 = tick()
	if v12 - v7 < 0.2 then
		return
	end
	v7 = v12

	if not v3 then
		local TrackerPart = Instance.new("Part")
		TrackerPart.Name = "TrackerPart"
		TrackerPart.Size = Vector3.new(2, 2, 2)
		TrackerPart.Transparency = 1
		TrackerPart.CanCollide = false
		TrackerPart.Anchored = false
		TrackerPart.Parent = v1

		local WeldConstraint = Instance.new("WeldConstraint")
		WeldConstraint.Part0 = TrackerPart
		WeldConstraint.Part1 = v2
		WeldConstraint.Parent = TrackerPart
		v3 = TrackerPart
	end

	local v22 = getAveragePosition(v1)
	v3.Position = v22 + (v22 - v2.Position) * 0.35
	zeroOutCharacterMass()

	if not v3 then
		return
	end

	local v32 = v3.Size.X * v3.Size.Y * v3.Size.Z
	v3.CustomPhysicalProperties = PhysicalProperties.new(math.clamp(if v32 > 0 then v4 / v32 or 1 else 1, 0.1, 35), 0.3, 0.5, 1, 1)
end

local function waitForMass(p1)
	local count = 0
	while p1.AssemblyMass < 0.01 and count < 40 do
		task.wait(0.1)
		count = count + 1
	end
	return p1.AssemblyMass
end

local function onCharacter(p1)
	if not p1 then return end
	v1 = p1
	v6 = false
	TextButton.Text = "SG OFF"
	TextButton.TextColor3 = Color3.fromRGB(235, 235, 235)

	if v3 then
		v3:Destroy()
		v3 = nil
	end

	task.delay(1, function()
		v2 = v1:WaitForChild("HumanoidRootPart", 5)
		if not v2 then return end
		v5 = true
		v4 = waitForMass(v2)
		v1.DescendantAdded:Connect(function(p1)
			if p1:FindFirstAncestorOfClass("Tool") == nil then
				task.defer(safeUpdate)
			end
		end)
		v1.DescendantRemoving:Connect(function(p1)
			if p1:FindFirstAncestorOfClass("Tool") == nil then
				task.defer(safeUpdate)
			end
		end)
	end)
end

LocalPlayer.CharacterAdded:Connect(onCharacter)

-- Инициализация для уже существующего персонажа (актуально для инжектов посреди игры)
if LocalPlayer.Character then
	task.spawn(onCharacter, LocalPlayer.Character)
end
