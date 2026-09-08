local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")


local localPlayer = Players.LocalPlayer

local playerGui = localPlayer:WaitForChild("PlayerGui")


-- ================= НАСТРОЙКИ И СОСТОЯНИЕ =================

local espEnabled = false

local namesEnabled = false

local gunEspEnabled = false

local heroEspEnabled = false

local autoTakeEnabled = false -- Состояние автоматического подбора


local espBind = Enum.KeyCode.E

local hideBind = Enum.KeyCode.H

local takeGunBind = Enum.KeyCode.T -- Клавиша для ручного подбора пушки по умолчанию


local guiVisible = true

local originalSheriff = nil


-- ================= АВТО-СОЗДАНИЕ ИНТЕРФЕЙСА (GUI) =================

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "MMV_ESP_v10_Final"

screenGui.ResetOnSpawn = false

screenGui.Parent = playerGui


local mainFrame = Instance.new("Frame")

mainFrame.Size = UDim2.new(0, 220, 0, 440) -- Увеличили высоту под новые элементы

mainFrame.Position = UDim2.new(0.5, -110, 0.5, -220)

mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

mainFrame.BorderSizePixel = 0

mainFrame.Active = true

mainFrame.Parent = screenGui


local corner = Instance.new("UICorner")

corner.CornerRadius = UDim.new(0, 8)

corner.Parent = mainFrame


local title = Instance.new("TextLabel")

title.Size = UDim2.new(1, 0, 0, 30)

title.Text = "MMV ESP v10"

title.TextColor3 = Color3.fromRGB(255, 255, 255)

title.BackgroundTransparency = 1

title.Font = Enum.Font.SourceSansBold

title.TextSize = 14

title.Parent = mainFrame
-- --- Старые кнопки переключения функций ---

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


local namesBtn = Instance.new("TextButton")

namesBtn.Size = UDim2.new(0, 180, 0, 35)

namesBtn.Position = UDim2.new(0, 20, 0, 80)

namesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

namesBtn.Text = "Имена над головой: ВЫКЛ"

namesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

namesBtn.Font = Enum.Font.SourceSansBold

namesBtn.TextSize = 14

namesBtn.Parent = mainFrame

Instance.new("UICorner", namesBtn)


local gunEspBtn = Instance.new("TextButton")

gunEspBtn.Size = UDim2.new(0, 180, 0, 35)

gunEspBtn.Position = UDim2.new(0, 20, 0, 120)

gunEspBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

gunEspBtn.Text = "Gun ESP (Пест на полу): ВЫКЛ"

gunEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

gunEspBtn.Font = Enum.Font.SourceSansBold

gunEspBtn.TextSize = 12

gunEspBtn.Parent = mainFrame

Instance.new("UICorner", gunEspBtn)


local heroEspBtn = Instance.new("TextButton")

heroEspBtn.Size = UDim2.new(0, 180, 0, 35)

heroEspBtn.Position = UDim2.new(0, 20, 0, 160)

heroEspBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

heroEspBtn.Text = "Yellow Hero ESP: ВЫКЛ"

heroEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

heroEspBtn.Font = Enum.Font.SourceSansBold

heroEspBtn.TextSize = 13

heroEspBtn.Parent = mainFrame

Instance.new("UICorner", heroEspBtn)


-- --- НОВЫЕ ЭЛЕМЕНТЫ (Auto Take & Take Gun) ---

local autoTakeBtn = Instance.new("TextButton")

autoTakeBtn.Size = UDim2.new(0, 180, 0, 35)

autoTakeBtn.Position = UDim2.new(0, 20, 0, 200) -- Переключатель автоматического подбора

autoTakeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

autoTakeBtn.Text = "Auto Take Gun: ВЫКЛ"

autoTakeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

autoTakeBtn.Font = Enum.Font.SourceSansBold

autoTakeBtn.TextSize = 13

autoTakeBtn.Parent = mainFrame

Instance.new("UICorner", autoTakeBtn)


local teleGunBtn = Instance.new("TextButton")

teleGunBtn.Size = UDim2.new(0, 180, 0, 35)

teleGunBtn.Position = UDim2.new(0, 20, 0, 240) -- Кнопка мгновенного ручного подбора

teleGunBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

teleGunBtn.Text = "⚡ ЗАБРАТЬ ПИСТОЛЕТ ⚡"

teleGunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

teleGunBtn.Font = Enum.Font.SourceSansBold

teleGunBtn.TextSize = 13

teleGunBtn.Parent = mainFrame

Instance.new("UICorner", teleGunBtn)


-- --- Поля ввода клавиш ---

local espBindInput = Instance.new("TextBox")

espBindInput.Size = UDim2.new(0, 180, 0, 35)

espBindInput.Position = UDim2.new(0, 20, 0, 290)

espBindInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

espBindInput.Text = "Бинд ESP: E"

espBindInput.TextColor3 = Color3.fromRGB(255, 255, 255)

espBindInput.Font = Enum.Font.SourceSans

espBindInput.TextSize = 14

espBindInput.ClearTextOnFocus = true

espBindInput.Parent = mainFrame

Instance.new("UICorner", espBindInput)


local takeGunBindInput = Instance.new("TextBox")

takeGunBindInput.Size = UDim2.new(0, 180, 0, 35)

takeGunBindInput.Position = UDim2.new(0, 20, 0, 335) -- Настройка бинда для подбора пушки

takeGunBindInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

takeGunBindInput.Text = "Бинд Take Gun: T"

takeGunBindInput.TextColor3 = Color3.fromRGB(255, 255, 255)

takeGunBindInput.Font = Enum.Font.SourceSans

takeGunBindInput.TextSize = 14

takeGunBindInput.ClearTextOnFocus = true

takeGunBindInput.Parent = mainFrame

Instance.new("UICorner", takeGunBindInput)


local hideBindInput = Instance.new("TextBox")

hideBindInput.Size = UDim2.new(0, 180, 0, 35)

hideBindInput.Position = UDim2.new(0, 20, 0, 380)

hideBindInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

hideBindInput.Text = "Бинд GUI: H"

hideBindInput.TextColor3 = Color3.fromRGB(255, 255, 255)

hideBindInput.Font = Enum.Font.SourceSans

hideBindInput.TextSize = 14

hideBindInput.ClearTextOnFocus = true

hideBindInput.Parent = mainFrame

Instance.new("UICorner", hideBindInput)


-- Скрипт перетаскивания (Drag & Drop)

local dragging, dragInput, dragStart, startPos

local function updateDrag(input)

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

	if input == dragInput and dragging then updateDrag(input) end

end)
local function applyHighlight(object, color, isGun)

	local name = isGun and "ClientGunHighlight" or "ClientRoleHighlight"

	local highlight = object:FindFirstChild(name)

	if not highlight then

		highlight = Instance.new("Highlight")

		highlight.Name = name

		highlight.Parent = object

	end

	highlight.FillColor = color

	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

	highlight.FillTransparency = 0.4

	highlight.Adornee = object

	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

end


local function removeHighlight(object, isGun)

	local name = isGun and "ClientGunHighlight" or "ClientRoleHighlight"

	local highlight = object:FindFirstChild(name)

	if highlight then highlight:Destroy() end

end


local function applyNameTag(character, player, color)

	local head = character:FindFirstChild("Head")

	if not head then return end

	local tag = head:FindFirstChild("ClientRoleTag")

	if not tag then

		tag = Instance.new("BillboardGui")

		tag.Name = "ClientRoleTag"

		tag.Size = UDim2.new(0, 200, 0, 50)

		tag.StudsOffset = Vector3.new(0, 2.5, 0)

		tag.AlwaysOnTop = true

		local label = Instance.new("TextLabel")

		label.Size = UDim2.new(1, 0, 1, 0)

		label.BackgroundTransparency = 1

		label.Font = Enum.Font.SourceSansBold

		label.TextSize = 16

		label.TextStrokeTransparency = 0

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


-- Логика телепортации к пистолету (Take Gun)

local function collectGun()

	local droppedGun = Workspace:FindFirstChild("GunDrop")

	if droppedGun and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then

		-- Перемещаем персонажа точно на координаты лежащего пистолета

		localPlayer.Character.HumanoidRootPart.CFrame = droppedGun.CFrame

	end

end


-- Главный игровой цикл

RunService.Heartbeat:Connect(function()

	local droppedGun = Workspace:FindFirstChild("GunDrop")

	
	-- Проверка наличия пистолета на полу

	if droppedGun then

		if gunEspEnabled and espEnabled then

			applyHighlight(droppedGun, Color3.fromRGB(0, 255, 0), true)

		end

		
		-- Функция АВТОПОДБОРА (если включена, персонаж мгновенно летит к пушке)

		if autoTakeEnabled then

			collectGun()

		end

	elseif droppedGun == nil then

		-- Очистка старой подсветки, если пушку подняли

		for _, obj in ipairs(Workspace:GetChildren()) do

			if obj.Name == "GunDrop" then removeHighlight(obj, true) end

		end

	end


	-- Проверка ролей игроков

	for _, targetPlayer in ipairs(Players:GetPlayers()) do

		if targetPlayer ~= localPlayer and targetPlayer.Character then

			local char = targetPlayer.Character

			local backpack = targetPlayer:FindFirstChild("Backpack")

			local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")

			local hasGun = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")

			local roleColor = Color3.fromRGB(0, 255, 0)

			if hasKnife then

				roleColor = Color3.fromRGB(255, 0, 0)

			elseif hasGun then

				if not originalSheriff or originalSheriff == targetPlayer then

					originalSheriff = targetPlayer

					roleColor = Color3.fromRGB(0, 0, 255)

				else

					if heroEspEnabled then roleColor = Color3.fromRGB(255, 255, 0) else roleColor = Color3.fromRGB(0, 255, 0) end

				end

			end

			if espEnabled then applyHighlight(char, roleColor, false) else removeHighlight(char, false) end

			if namesEnabled then applyNameTag(char, targetPlayer, roleColor) else removeNameTag(char) end

		end

	end

end)


-- Сброс памяти о шерифе между раундами

task.spawn(function()

	while true do

		local gunFound = false

		for _, p in ipairs(Players:GetPlayers()) do

			if p.Character and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then gunFound = true end

		end

		if not gunFound then originalSheriff = nil end

		task.wait(5)

	end

end)


-- Функции обновления визуального состояния кнопок

local function updateESPState()

	toggleBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	toggleBtn.Text = espEnabled and "ESP силуэты: ВКЛ" or "ESP силуэты: ВЫКЛ"

	if not espEnabled then

		for _, p in ipairs(Players:GetPlayers()) do if p.Character then removeHighlight(p.Character, false) end end

		local droppedGun = Workspace:FindFirstChild("GunDrop")

		if droppedGun then removeHighlight(droppedGun, true) end

	end

end


local function updateNamesState()

	namesBtn.BackgroundColor3 = namesEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	namesBtn.Text = namesEnabled and "Имена над головой: ВКЛ" or "Имена над головой: ВЫКЛ"

	if not namesEnabled then

		for _, p in ipairs(Players:GetPlayers()) do if p.Character then removeNameTag(p.Character) end end

	end

end


local function updateGunEspState()

	gunEspBtn.BackgroundColor3 = gunEspEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	gunEspBtn.Text = gunEspEnabled and "Gun ESP (Пест на полу): ВКЛ" or "Gun ESP (Пест на полу): ВЫКЛ"

	if not gunEspEnabled then

		local droppedGun = Workspace:FindFirstChild("GunDrop")

		if droppedGun then removeHighlight(droppedGun, true) end

	end

end


local function updateHeroEspState()

	heroEspBtn.BackgroundColor3 = heroEspEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	heroEspBtn.Text = heroEspEnabled and "Yellow Hero ESP: ВКЛ" or "Yellow Hero ESP: ВЫКЛ"

end


local function updateAutoTakeState()

	autoTakeBtn.BackgroundColor3 = autoTakeEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	autoTakeBtn.Text = autoTakeEnabled and "Auto Take Gun: ВКЛ" or "Auto Take Gun: ВЫКЛ"

end


local function toggleGuiVisibility()

	guiVisible = not guiVisible

	mainFrame.Visible = guiVisible

end


-- Подключение кликов

toggleBtn.MouseButton1Click:Connect(function() espEnabled = not espEnabled updateESPState() end)

namesBtn.MouseButton1Click:Connect(function() namesEnabled = not namesEnabled updateNamesState() end)

gunEspBtn.MouseButton1Click:Connect(function() gunEspEnabled = not gunEspEnabled updateGunEspState() end)

heroEspBtn.MouseButton1Click:Connect(function() heroEspEnabled = not heroEspEnabled updateHeroEspState() end)

autoTakeBtn.MouseButton1Click:Connect(function() autoTakeEnabled = not autoTakeEnabled updateAutoTakeState() end)

teleGunBtn.MouseButton1Click:Connect(collectGun)


-- Парсинг клавиш

local function tryParseKeyCode(text)

	text = text:upper():gsub("%s+", "")

	if tonumber(text) then text = "NUMPAD" .. text end

	local success, keyCode = pcall(function() return Enum.KeyCode[text] end)

	if success and keyCode and not string.find(keyCode.Name, "MouseButton") then return keyCode end

	return nil

end


espBindInput.FocusLost:Connect(function()

	local parsedKey = tryParseKeyCode(espBindInput.Text)

	if parsedKey then espBind = parsedKey espBindInput.Text = "Бинд ESP: " .. parsedKey.Name

	else espBindInput.Text = "Бинд ESP: " .. espBind.Name end

end)


takeGunBindInput.FocusLost:Connect(function()

	local parsedKey = tryParseKeyCode(takeGunBindInput.Text)

	if parsedKey then takeGunBind = parsedKey takeGunBindInput.Text = "Бинд Take Gun: " .. parsedKey.Name

	else takeGunBindInput.Text = "Бинд Take Gun: " .. takeGunBind.Name end

end)


hideBindInput.FocusLost:Connect(function()

	local parsedKey = tryParseKeyCode(hideBindInput.Text)

	if parsedKey then hideBind = parsedKey hideBindInput.Text = "Бинд GUI: " .. parsedKey.Name

	else hideBindInput.Text = "Бинд GUI: " .. hideBind.Name end

end)


-- Обработка физических нажатий кнопок на клавиатуре

UserInputService.InputBegan:Connect(function(input, gameProcessed)

	if gameProcessed then return end

	if input.KeyCode == espBind then

		espEnabled = not espEnabled

		updateESPState()

	elseif input.KeyCode == takeGunBind then

		collectGun()

	elseif input.KeyCode == hideBind then

		toggleGuiVisibility()

	end

end)
