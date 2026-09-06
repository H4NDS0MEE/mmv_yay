local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {
    Cooldown = 2, -- Время перезарядки (меняется в меню)
    CanUse = true
}

local CurrentDroppedBomb = nil -- Управление бомбой на земле из твоего скрипта

-- Функция создания модели с твоими размерами, но моим детальным 3D дизайном
local function BuildC4()
    local Main = Instance.new("Part")
    Main.Name = "Handle"
    Main.Size = Vector3.new(1.8, 0.7, 1.2) -- Твой точный размер для физики
    Main.BrickColor = BrickColor.new("Bright yellow")
    Main.Material = Enum.Material.SmoothPlastic
    Main.CanCollide = true -- Включена коллизия из твоего скрипта

    -- Мой 3D дизайн оригинальной C4 (экран, кнопки, провода)
    local Mesh = Instance.new("SpecialMesh")
    Mesh.MeshId = "rbxassetid://104516854"   
    Mesh.TextureId = "rbxassetid://104516981" 
    Mesh.Scale = Vector3.new(1.5, 1.2, 1.35) -- Масштабирование меша под размер твоего парта
    Mesh.VertexColor = Vector3.new(1, 0.84, 0) -- Чистое золото
    Mesh.Parent = Main

    return Main
end

-- ТВОЁ МЕНЮ GUI ДЛЯ ВВОДА СЕКУНД (ПОЛНОСТЬЮ СОХРАНЕНО)
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "C4_Final_Menu"
sg.ResetOnSpawn = false

local toggle = Instance.new("TextButton", sg)
toggle.Size = UDim2.new(0, 60, 0, 40)
toggle.Position = UDim2.new(0, 10, 0.5, 0)
toggle.Text = "MENU"
toggle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
toggle.Draggable = true

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0.5, -90, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.8, 0, 0, 30)
input.Position = UDim2.new(0.1, 0, 0.2, 0)
input.Text = tostring(Config.Cooldown)
input.PlaceholderText = "Giây hồi..."

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8, 0, 0, 30)
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.Text = "LƯU"
btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

toggle.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
btn.MouseButton1Click:Connect(function() 
    Config.Cooldown = tonumber(input.Text) or 0
    frame.Visible = false
end)

-- ФУНКЦИЯ КУЛДАУНА, ОТОБРАЖЕНИЯ И ЧЕСТНОЙ ТВОЕЙ ФИЗИКИ
local function GiveTool()
    local Tool = Instance.new("Tool")
    Tool.Name = "Gold C4 Bomb"
    Tool.TextureId = "rbxassetid://1317188024" -- Иконка
    Tool.RequiresHandle = true
    Tool.CanBeDropped = false
    
    -- Твой идеальный поворот (горизонтально, рисунком строго к небу)
    Tool.Grip = CFrame.new(0, -0.2, 0.2) * CFrame.Angles(0, math.rad(180), 0)
    
    local C4Part = BuildC4()
    C4Part.Parent = Tool
    
    Tool.Activated:Connect(function()
        if not Config.CanUse then return end
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        Config.CanUse = false
        
        -- Удаление старой бомбы с земли перед новым броском
        if CurrentDroppedBomb then CurrentDroppedBomb:Destroy() end
        
        -- Спавн летящей бомбы с моим дизайном по твоим координатам
        local d_handle = BuildC4()
        d_handle.CFrame = hrp.CFrame * CFrame.new(0, -3.2, 0)
        d_handle.Parent = game.Workspace
        
        CurrentDroppedBomb = d_handle

        -- Точная настройка физики полета за мышкой из твоего скрипта
        local bv = Instance.new("BodyVelocity", d_handle)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = ((Mouse.Hit.p - hrp.Position).Unit * 25) + Vector3.new(0, 10, 0)
        
        game.Debris:AddItem(bv, 0.1)
        
        -- Скрываем бомбу и её меш в руках на время Кулдауна
        local parts = {}
        for _, p in pairs(Tool:GetChildren()) do
            if p:IsA("BasePart") then 
                parts[p] = p.Transparency 
                p.Transparency = 1 
                local m = p:FindFirstChildOfClass("SpecialMesh")
                if m then m.Scale = Vector3.new(0, 0, 0) end
            end
        end
        
        task.wait(Config.Cooldown)
        
        -- Конец кулдауна: очистка и возвращение видимости в руках
        if CurrentDroppedBomb then 
            CurrentDroppedBomb:Destroy() 
            CurrentDroppedBomb = nil
        end
        
        for p, trans in pairs(parts) do 
            if p then 
                p.Transparency = trans 
                local m = p:FindFirstChildOfClass("SpecialMesh")
                if m then m.Scale = Vector3.new(1.5, 1.2, 1.35) end
            end 
        end
        Config.CanUse = true
    end)
    
    Tool.Parent = Player.Backpack
end

-- Автоматический респавн предмета после смерти/ресета (из твоего скрипта)
Player.CharacterAdded:Connect(function() 
    task.wait(1) 
    GiveTool() 
end)

-- Первый запуск при инжекте
GiveTool()
