local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Переменные состояния
local espEnabled = false
local namesEnabled = false -- Состояние отображения имён
local guiVisible = true
local espBind = Enum.KeyCode.E
local hideBind = Enum.KeyCode.H

-- ================= АВТО-СОЗДАНИЕ GUI =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MMV_ESP_v7"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 235) -- Увеличили высоту под новую кнопку
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -117)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "MMV ESP v7"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = mainFrame

-- Кнопка Вкл/Выкл ESP
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 180, 0, 35)
toggleBtn.Position = UDim2.new(0, 20, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "ESP силуэты: ВЫКЛ"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn)

-- Кнопка Вкл/Выкл Имён
local namesBtn = Instance.new("TextButton")
namesBtn.Size = UDim2.new(0, 180, 0, 35)
namesBtn.Position = UDim2.new(0, 20, 0, 80) -- Новая кнопка
namesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
namesBtn.Text = "Имена над головой: ВЫКЛ"
namesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
namesBtn.Font = Enum.Font.SourceSansBold
namesBtn.TextSize = 14
namesBtn.Parent = mainFrame
Instance.new("UICorner", namesBtn)

-- Поле ввода клавиши для ESP
local espBindInput = Instance.new("TextBox")
espBindInput.Size = UDim2.new(0, 180, 0, 35)
espBindInput.Position = UDim2.new(0, 20, 0, 125)
espBindInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espBindInput.Text = "Бинд ESP: E"
espBindInput.TextColor3 = Color3.fromRGB(255, 255, 255)
espBindInput.Font = Enum.Font.SourceSans
espBindInput.TextSize = 14
espBindInput.ClearTextOnFocus = true
espBindInput.Parent = mainFrame
Instance.new("UICorner", espBindInput)

-- Поле ввода клавиши для скрытия меню
local hideBindInput = Instance.new("TextBox")
hideBindInput.Size = UDim2.new(0, 180, 0, 35)
hideBindInput.Position = UDim2.new(0, 20, 0, 170)
hideBindInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideBindInput.Text = "Бинд GUI: H"
hideBindInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBindInput.Font = Enum.Font.SourceSans
hideBindInput.TextSize = 14
hideBindInput.ClearTextOnFocus = true
hideBindInput.Parent = mainFrame
Instance.new("UICorner", hideBindInput)

-- ================= ФУНКЦИЯ ПЕРЕТАСКИВАНИЯ =================
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- ================= ЛОГИКА ЭЛЕМЕНТОВ ESP И ИМЁН =================
local function applyHighlight(character, color)
	local highlight = character:FindFirstChild("ClientRoleHighlight")
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "ClientRoleHighlight"
		highlight.Parent = character
	end
	highlight.FillColor = color
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.4
	highlight.OutlineTransparency = 0
	highlight.Adornee = character
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function removeHighlight(character)
	local highlight = character:FindFirstChild("ClientRoleHighlight")
	if highlight then highlight:Destroy() end
end

-- Функция создания текста над головой сквозь стены
local function applyNameTag(character, player, color)
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	local tag = head:FindFirstChild("ClientRoleTag")
	if not tag then
		tag = Instance.new("BillboardGui")
		tag.Name = "ClientRoleTag"
		tag.Size = UDim2.new(0, 200, 0, 50)
		tag.StudsOffset = Vector3.new(0, 2.5, 0) -- Высота над головой
		tag.AlwaysOnTop = true -- Видно сквозь стены!
		
		local label = Instance.new("TextLabel")
		label.Name = "TextLabel"
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.SourceSansBold
		label.TextSize = 16
		label.TextStrokeTransparency = 0 -- Черный контур букв
		label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		label.Parent = tag
		
		tag.Parent = head
	end
	
	tag.TextLabel.Text = player.DisplayName or player.Name
	tag.TextLabel.TextColor3 = color
end

local function removeNameTag(character)
	local head = character:FindFirstChild("Head")
	if head then
		local tag = head:FindFirstChild("ClientRoleTag")
		if tag then tag:Destroy() end
	end
end

-- Главный цикл обновлений
RunService.Heartbeat:Connect(function()
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= localPlayer and targetPlayer.Character then
			local char = targetPlayer.Character
			
			-- Логика определения цвета роли по оружию
			local backpack = targetPlayer:FindFirstChild("Backpack")
			local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
			local hasGun = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
			
			local roleColor = Color3.fromRGB(0, 255, 0) -- Дефолт: Мирный (Зеленый)
			if hasKnife then
				roleColor = Color3.fromRGB(255, 0, 0) -- Убийца (Красный)
			elseif hasGun then
				roleColor = Color3.fromRGB(0, 0, 255) -- Шериф (Синий)
			end
			
			-- Обработка силуэтов
			if espEnabled then
				applyHighlight(char, roleColor)
			else
				removeHighlight(char)
			end
			
			-- Обработка имён над головой
			if namesEnabled then
				applyNameTag(char, targetPlayer, roleColor)
			else
				removeNameTag(char)
			end
		end
	end
end)

-- ================= УПРАВЛЕНИЕ ИНТЕРФЕЙСОМ =================
local function updateESPState()
	if espEnabled then
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		toggleBtn.Text = "ESP: ВКЛ"
	else
		toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		toggleBtn.Text = "ESP: ВЫКЛ"
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then removeHighlight(p.Character) end
		end
	end
end

local function updateNamesState()
	if namesEnabled then
		namesBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		namesBtn.Text = "Имена над головой: ВКЛ"
	else
		namesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		namesBtn.Text = "Имена над головой: ВЫКЛ"
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then removeNameTag(p.Character) end
		end
	end
end

local function toggleGuiVisibility()
	guiVisible = not guiVisible
	mainFrame.Visible = guiVisible
end

toggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	updateESPState()
end)

namesBtn.MouseButton1Click:Connect(function()
	namesEnabled = not namesEnabled
	updateNamesState()
end)

-- Функция умного парсинга клавиши из текста
local function tryParseKeyCode(text)
	text = text:upper():gsub("%s+", "")
	if tonumber(text) then text = "NUMPAD" .. text end
	local success, keyCode = pcall(function() return Enum.KeyCode[text] end)
	if success and keyCode and not string.find(keyCode.Name, "MouseButton") then
		return keyCode
	end
	return nil
end

espBindInput.FocusLost:Connect(function()
	local parsedKey = tryParseKeyCode(espBindInput.Text)
	if parsedKey then
		espBind = parsedKey
		espBindInput.Text = "Бинд ESP: " .. parsedKey.Name
	else
		espBindInput.Text = "Неверная клавиша!"
		task.wait(1)
		espBindInput.Text = "Бинд ESP: " .. espBind.Name
	end
end)

hideBindInput.FocusLost:Connect(function()
	local parsedKey = tryParseKeyCode(hideBindInput.Text)
	if parsedKey then
		hideBind = parsedKey
		hideBindInput.Text = "Бинд GUI: " .. parsedKey.Name
	else
		hideBindInput.Text = "Неверная клавиша!"
		task.wait(1)
		hideBindInput.Text = "Бинд GUI: " .. hideBind.Name
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == espBind then
		espEnabled = not espEnabled
		updateESPState()
	elseif input.KeyCode == hideBind then
		toggleGuiVisibility()
	end
end)
