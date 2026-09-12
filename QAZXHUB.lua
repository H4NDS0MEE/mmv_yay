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

-- Глобальные настройки хаба
_G.QAZX_SETTINGS = {
	espEnabled = false,
	namesEnabled = false,
	gunEspEnabled = false,
	heroEspEnabled = false,
	autoTakeEnabled = false,
	bombEnabled = false,          
	bombCooldown = 2,             
	guiVisible = true,
	hideBind = Enum.KeyCode.H,    
	espBind = Enum.KeyCode.E      
}

local QAZX_HUB = Instance.new("ScreenGui")
QAZX_HUB.Name = "QAZX_HUB"
QAZX_HUB.ResetOnSpawn = false

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
QAZX_HUB.Parent = (success and coreGui) and coreGui or PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 475)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = QAZX_HUB

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(60, 60, 60)
MainStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "QAZX HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = MainFrame

local function createButton(name, text, pos, sizeY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -20, 0, sizeY or 35)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(235, 235, 235)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.Parent = MainFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(60, 60, 60)
	stroke.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
	end)

	return btn
end

local SGButton = createButton("SGButton", "SG OFF", UDim2.new(0, 10, 0, 45), 40)
SGButton.Font = Enum.Font.GothamBold

local BombButton = createButton("BombButton", "Bomb Tool: OFF", UDim2.new(0, 10, 0, 95), 40)
BombButton.Font = Enum.Font.GothamBold

local CooldownInput = Instance.new("TextBox")
CooldownInput.Name = "CooldownInput"
CooldownInput.Size = UDim2.new(1, -20, 0, 30)
CooldownInput.Position = UDim2.new(0, 10, 0, 145)
CooldownInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CooldownInput.Text = tostring(_G.QAZX_SETTINGS.bombCooldown)
CooldownInput.PlaceholderText = "C4 Cooldown (sec)..."
CooldownInput.TextColor3 = Color3.fromRGB(255, 215, 0)
CooldownInput.Font = Enum.Font.GothamMedium
CooldownInput.TextSize = 13
CooldownInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = CooldownInput

local InputStroke = Instance.new("UIStroke")
InputStroke.Thickness = 1
InputStroke.Color = Color3.fromRGB(80, 80, 80)
InputStroke.Parent = CooldownInput

CooldownInput.FocusLost:Connect(function()
	local num = tonumber(CooldownInput.Text)
	if num then _G.QAZX_SETTINGS.bombCooldown = num else CooldownInput.Text = tostring(_G.QAZX_SETTINGS.bombCooldown) end
end)

local ESPButton = createButton("ESPButton", "ESP: OFF", UDim2.new(0, 10, 0, 185))
local ESPBindButton = createButton("ESPBindButton", "Bind: " .. _G.QAZX_SETTINGS.espBind.Name, UDim2.new(0, 10, 0, 230))
ESPBindButton.TextColor3 = Color3.fromRGB(180, 180, 255)

local NamesButton = createButton("NamesButton", "Names: OFF", UDim2.new(0, 10, 0, 275))
local GunESPButton = createButton("GunESPButton", "Gun ESP: OFF", UDim2.new(0, 10, 0, 320))
local HeroESPButton = createButton("HeroESPButton", "Hero ESP: OFF", UDim2.new(0, 10, 0, 365))
local AutoTakeButton = createButton("AutoTakeButton", "Auto Take Gun: OFF", UDim2.new(0, 10, 0, 410))

local function refreshVisualESP()
	if _G.QAZX_SETTINGS.espEnabled then
		ESPButton.Text = "ESP: ON"
		ESPButton.TextColor3 = Color3.fromRGB(85, 255, 127)
	else
		ESPButton.Text = "ESP: OFF"
		ESPButton.TextColor3 = Color3.fromRGB(235, 235, 235)
	end
end

ESPButton.MouseButton1Click:Connect(function()
	_G.QAZX_SETTINGS.espEnabled = not _G.QAZX_SETTINGS.espEnabled
	refreshVisualESP()
end)

local isChangingBind = false
ESPBindButton.MouseButton1Click:Connect(function()
	if isChangingBind then return end
	isChangingBind = true
	ESPBindButton.Text = "..."
	ESPBindButton.TextColor3 = Color3.fromRGB(255, 255, 127)
	
	local connection
	connection = UserInputService.InputBegan:Connect(function(input, processed)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			_G.QAZX_SETTINGS.espBind = input.KeyCode
			ESPBindButton.Text = "Bind: " .. input.KeyCode.Name
			ESPBindButton.TextColor3 = Color3.fromRGB(180, 180, 255)
			isChangingBind = false
			connection:Disconnect()
		end
	end)
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == _G.QAZX_SETTINGS.espBind and not isChangingBind then
		_G.QAZX_SETTINGS.espEnabled = not _G.QAZX_SETTINGS.espEnabled
		refreshVisualESP()
	end
	if input.KeyCode == _G.QAZX_SETTINGS.hideBind then
		_G.QAZX_SETTINGS.guiVisible = not _G.QAZX_SETTINGS.guiVisible
		MainFrame.Visible = _G.QAZX_SETTINGS.guiVisible
	end
end)

local function toggleUIState(btn, settingKey, prefix)
	btn.MouseButton1Click:Connect(function()
		_G.QAZX_SETTINGS[settingKey] = not _G.QAZX_SETTINGS[settingKey]
		if _G.QAZX_SETTINGS[settingKey] then
			btn.Text = prefix .. ": ON"
			btn.TextColor3 = Color3.fromRGB(85, 255, 127)
		else
			btn.Text = prefix .. ": OFF"
			btn.TextColor3 = Color3.fromRGB(235, 235, 235)
		end
	end)
end

toggleUIState(NamesButton, "namesEnabled", "Names")
toggleUIState(GunESPButton, "gunEspEnabled", "Gun ESP")
toggleUIState(HeroESPButton, "heroEspEnabled", "Hero ESP")
toggleUIState(AutoTakeButton, "autoTakeEnabled", "Auto Take Gun")

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	end
end)
-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 2]
-- ====================================================================

-- [МОДУЛЬ 1: ОРИГИНАЛЬНЫЙ SG FIX]
local v1, v2, v3, v4, v5, v6 = nil, nil, nil, 0, false, false

SGButton.MouseButton1Click:Connect(function()
	v6 = not v6
	if v6 then
		SGButton.Text = "SG ON"
		SGButton.TextColor3 = Color3.fromRGB(85, 255, 127)
		return
	end
	SGButton.Text = "SG OFF"
	SGButton.TextColor3 = Color3.fromRGB(235, 235, 235)
	if not v3 then return end
	v3:Destroy()
	v3 = nil
end)

local function getAveragePosition(p1)
	local sum = Vector3.new(0, 0, 0)
	local count = 0
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") and (not v.Anchored and v.Name ~= "TrackerPart") and not (v:FindFirstAncestorOfClass("Tool") ~= nil) then
			sum = sum + v.Position
			count = count + 1
		end
	end
	if count == 0 then return v2.Position end
	return sum / count
end

local function zeroOutCharacterMass()
	if not v1 then return end
	for _, v in ipairs(v1:GetDescendants()) do
		if v:IsA("BasePart") and v ~= v3 and v:FindFirstAncestorOfClass("Tool") == nil then
			v.CustomPhysicalProperties = PhysicalProperties.new(0.2, 0.3, 0.5, 1, 1)
		end
	end
end

local v7 = 0
local function safeUpdate()
	if not v6 or not v1 or not v2 then return end
	local v12 = tick()
	if v12 - v7 < 0.2 then return end
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

	if not v3 then return end
	local v32 = v3.Size.X * v3.Size.Y * v3.Size.Z
	local density = (v32 > 0) and (v4 / v32) or 1
	v3.CustomPhysicalProperties = PhysicalProperties.new(math.clamp(density, 0.1, 35), 0.3, 0.5, 1, 1)
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
	SGButton.Text = "SG OFF"
	SGButton.TextColor3 = Color3.fromRGB(235, 235, 235)
	if v3 then v3:Destroy() v3 = nil end

	task.delay(1, function()
		v2 = v1:WaitForChild("HumanoidRootPart", 5)
		if not v2 then return end
		v5 = true
		v4 = waitForMass(v2)
		v1.DescendantAdded:Connect(function(part) if part:FindFirstAncestorOfClass("Tool") == nil then task.defer(safeUpdate) end end)
		v1.DescendantRemoving:Connect(function(part) if part:FindFirstAncestorOfClass("Tool") == nil then task.defer(safeUpdate) end end)
	end)
end

LocalPlayer.CharacterAdded:Connect(onCharacter)
if LocalPlayer.Character then task.spawn(onCharacter, LocalPlayer.Character) end


-- [МОДУЛЬ 2: ЗОЛОТАЯ C4 БОМБА С ФИЗИКОЙ ПОЛЕТА]
local Mouse = LocalPlayer:GetMouse()
local CurrentDroppedBomb = nil
local CanUseBomb = true

local function BuildC4()
	local Main = Instance.new("Part")
	Main.Name = "Handle"
	Main.Size = Vector3.new(1.8, 0.7, 1.2)
	Main.BrickColor = BrickColor.new("Bright yellow")
	Main.Material = Enum.Material.SmoothPlastic
	Main.CanCollide = true

	local Mesh = Instance.new("SpecialMesh")
	Mesh.MeshId = "rbxassetid://104516854"   
	Mesh.TextureId = "rbxassetid://104516981" 
	Mesh.Scale = Vector3.new(1.5, 1.2, 1.35) 
	Mesh.VertexColor = Vector3.new(1, 0.84, 0)
	Mesh.Parent = Main
	return Main
end

local function CleanOldBombFromInventory()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gold C4 Bomb") then LocalPlayer.Character["Gold C4 Bomb"]:Destroy() end
	if LocalPlayer.Backpack:FindFirstChild("Gold C4 Bomb") then LocalPlayer.Backpack["Gold C4 Bomb"]:Destroy() end
end

local function GiveTool()
	if not _G.QAZX_SETTINGS.bombEnabled then return end
	CleanOldBombFromInventory()

	local Tool = Instance.new("Tool")
	Tool.Name = "Gold C4 Bomb"
	Tool.TextureId = "rbxassetid://1317188024"
	Tool.RequiresHandle = true
	Tool.CanBeDropped = false
	Tool.Grip = CFrame.new(0, -0.2, 0.2) * CFrame.Angles(0, math.rad(180), 0)
	
	local C4Part = BuildC4()
	C4Part.Parent = Tool
	
	Tool.Activated:Connect(function()
		if not CanUseBomb or not _G.QAZX_SETTINGS.bombEnabled then return end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		
		CanUseBomb = false
		if CurrentDroppedBomb then pcall(function() CurrentDroppedBomb:Destroy() end) end
		
		local d_handle = BuildC4()
		d_handle.CFrame = hrp.CFrame * CFrame.new(0, -3.2, 0)
		d_handle.Parent = Workspace
		CurrentDroppedBomb = d_handle

		local bv = Instance.new("BodyVelocity", d_handle)
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = ((Mouse.Hit.p - hrp.Position).Unit * 25) + Vector3.new(0, 10, 0)
		game.Debris:AddItem(bv, 0.1)
		
		local parts = {}
		for _, p in pairs(Tool:GetChildren()) do
			if p:IsA("BasePart") then 
				parts[p] = p.Transparency 
				p.Transparency = 1 
				local m = p:FindFirstChildOfClass("SpecialMesh")
				if m then m.Scale = Vector3.new(0, 0, 0) end
			end
		end
		
		task.wait(_G.QAZX_SETTINGS.bombCooldown)
		
		if CurrentDroppedBomb then pcall(function() CurrentDroppedBomb:Destroy() end) CurrentDroppedBomb = nil end
		for p, trans in pairs(parts) do 
			if p and p.Parent then 
				p.Transparency = trans 
				local m = p:FindFirstChildOfClass("SpecialMesh")
				if m then m.Scale = Vector3.new(1.5, 1.2, 1.35) end
			end 
		end
		CanUseBomb = true
	end)
	Tool.Parent = LocalPlayer.Backpack
end

BombButton.MouseButton1Click:Connect(function()
	_G.QAZX_SETTINGS.bombEnabled = not _G.QAZX_SETTINGS.bombEnabled
	if _G.QAZX_SETTINGS.bombEnabled then
		BombButton.Text = "Bomb Tool: ON"
		BombButton.TextColor3 = Color3.fromRGB(85, 255, 127)
		GiveTool()
	else
		BombButton.Text = "Bomb Tool: OFF"
		BombButton.TextColor3 = Color3.fromRGB(235, 235, 235)
		CleanOldBombFromInventory()
	end
end)

LocalPlayer.CharacterAdded:Connect(function() if _G.QAZX_SETTINGS.bombEnabled then task.wait(1) GiveTool() end end)
-- ====================================================================
--                         QAZX HUB v1.0 [ЧАСТЬ 3]
-- ====================================================================

-- [МОДУЛЬ 3: РОЛЕВОЙ ESP И НИКИ С ЦВЕТАМИ MM2]
task.spawn(function()
	local function createEspElements(player)
		if player == LocalPlayer then return end
		local function applyEsp(character)
			if not character then return end
			if character:FindFirstChild("QAZX_Highlight") then character.QAZX_Highlight:Destroy() end
			if character:FindFirstChild("QAZX_Billboard") then character.QAZX_Billboard:Destroy() end

			local highlight = Instance.new("Highlight")
			highlight.Name = "QAZX_Highlight"
			highlight.FillColor = Color3.fromRGB(0, 255, 0)
			highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
			highlight.FillTransparency = 0.5
			highlight.Enabled = false
			highlight.Parent = character

			local billboard = Instance.new("BillboardGui")
			billboard.Name = "QAZX_Billboard"
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 3, 0)
			billboard.AlwaysOnTop = true
			billboard.Enabled = false
			billboard.Parent = character

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.fromRGB(0, 255, 0)
			label.TextStrokeTransparency = 0
			label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 14
			label.Text = player.Name
			label.Parent = billboard
		end
		player.CharacterAdded:Connect(applyEsp)
		if player.Character then applyEsp(player.Character) end
	end

	Players.PlayerAdded:Connect(createEspElements)
	for _, p in ipairs(Players:GetPlayers()) do createEspElements(p) end

	while task.wait(0.1) do
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local char = p.Character
				local high = char:FindFirstChild("QAZX_Highlight")
				local bill = char:FindFirstChild("QAZX_Billboard")

				local backpack = p:FindFirstChild("Backpack")
				local hasKnife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
				local hasGun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))

				local targetColor = Color3.fromRGB(0, 255, 0)
				local roleText = "[INNOCENT] " .. p.Name

				if hasKnife then
					targetColor = Color3.fromRGB(255, 0, 0)
					roleText = "[MURDER] " .. p.Name
				elseif hasGun then
					targetColor = Color3.fromRGB(0, 0, 255)
					roleText = "[SHERIFF] " .. p.Name
				end

				if high then
					high.Enabled = _G.QAZX_SETTINGS.espEnabled
					high.FillColor = _G.QAZX_SETTINGS.heroEspEnabled and targetColor or Color3.fromRGB(255, 255, 255)
				end

				if bill and bill:FindFirstChildOfClass("TextLabel") then
					local lbl = bill:FindFirstChildOfClass("TextLabel")
					bill.Enabled = _G.QAZX_SETTINGS.namesEnabled
					if _G.QAZX_SETTINGS.heroEspEnabled then
						lbl.Text = roleText
						lbl.TextColor3 = targetColor
					else
						lbl.Text = p.Name
						lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end
end)

-- [МОДУЛЬ 4: GUN ESP, ИСПРАВЛЕННЫЙ АВТОПОДБОР И ОЧИСТКА ПАМЯТИ]
task.spawn(function()
	local activeGunHighlights = {}
	
	local function findDroppedGun()
		local gun = Workspace:FindFirstChild("GunDrop")
		if not gun then
			for _, obj in ipairs(Workspace:GetChildren()) do
				if obj:IsA("Tool") and obj.Name == "Gun" and obj:FindFirstChild("Handle") then gun = obj break end
			end
		end
		return gun
	end

	local function teleportToGun(gunObject)
		if not _G.QAZX_SETTINGS.autoTakeEnabled or not LocalPlayer.Character then return end
		local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local targetPart = gunObject:IsA("BasePart") and gunObject or gunObject:FindFirstChild("Handle")
		if root and targetPart then
			root.CFrame = targetPart.CFrame
		end
	end

	-- Полностью зафиксированный и исправленный Workspace Listener (без багов синтаксиса)
	Workspace.ChildAdded:Connect(function(child)
		if child.Name == "GunDrop" or (child:IsA("Tool") and child.Name == "Gun") then
			task.wait(0.01)
			teleportToGun(child)
		end
	end)

	RunService.Heartbeat:Connect(function()
		local droppedGun = findDroppedGun()
		if droppedGun then
			if _G.QAZX_SETTINGS.gunEspEnabled then
				if not activeGunHighlights[droppedGun] then
					local gunHighlight = Instance.new("Highlight")
					gunHighlight.Name = "QAZX_Gun_Esp"
					gunHighlight.FillColor = Color3.fromRGB(0, 255, 255)
					gunHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					gunHighlight.FillTransparency = 0.2
					gunHighlight.Parent = droppedGun
					activeGunHighlights[droppedGun] = gunHighlight
				end
			else
				if activeGunHighlights[droppedGun] then pcall(function() activeGunHighlights[droppedGun]:Destroy() end) activeGunHighlights[droppedGun] = nil end
			end
			if _G.QAZX_SETTINGS.autoTakeEnabled then teleportToGun(droppedGun) end
		else
			for gun, hl in pairs(activeGunHighlights) do pcall(function() hl:Destroy() end) end
			table.clear(activeGunHighlights)
		end
	end)

	Workspace.ChildRemoved:Connect(function(child)
		if child.Name == "GunDrop" or (child:IsA("Tool") and child.Name == "Gun") then
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("QAZX_Gun_Esp") then pcall(function() p.Character["QAZX_Gun_Esp"]:Destroy() end) end
			end
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		if player.Character then
			if player.Character:FindFirstChild("QAZX_Billboard") then pcall(function() player.Character["QAZX_Billboard"]:Destroy() end) end
			if player.Character:FindFirstChild("QAZX_Highlight") then pcall(function() player.Character["QAZX_Highlight"]:Destroy() end) end
		end
	end)
end)

print("[QAZX HUB]: Монолитная сборка по частям успешно инициализирована!")
