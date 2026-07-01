-- [[ KAY HUB PRO V8 - SLIM EDITION ]] --
local Players, TS, RS, UIS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Themes = {["Neon Green"] = Color3.fromRGB(0, 255, 150), ["Aqua Blue"] = Color3.fromRGB(0, 210, 255), ["Ruby Red"] = Color3.fromRGB(255, 50, 70), ["Purple Cyber"] = Color3.fromRGB(180, 0, 255)}
local ActiveThemeColor, ActiveToggles, Tabs = Themes["Neon Green"], {}, {}

-- Inisialisasi GUI Utama
local KayHub = Instance.new("ScreenGui")
pcall(function() KayHub.Parent = game:GetService("CoreGui") end)
if not KayHub.Parent then KayHub.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.Active, MainFrame.ClipsDescendants, MainFrame.Parent = UDim2.new(0, 420, 0, 280), UDim2.new(0.3, 0, 0.25, 0), Color3.fromRGB(20, 20, 20), true, true, KayHub
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Fungsi Drag & Drop Otomatis (Aman & Ringkas)
local function MakeDraggable(gui)
    local dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragging = true
            dragStart, startPos = input.Position, gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            UIS.InputChanged:Connect(function(inp)
                if inp == dragInput and dragging then
                    local delta = inp.Position - dragStart
                    gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
end
MakeDraggable(MainFrame)

-- Sidebar & Container Halaman
local Sidebar = Instance.new("Frame")
Sidebar.Size, Sidebar.BackgroundColor3, Sidebar.Parent = UDim2.new(0, 110, 1, 0), Color3.fromRGB(28, 28, 28), MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size, LogoLabel.BackgroundTransparency, LogoLabel.Text, LogoLabel.TextColor3, LogoLabel.Font, LogoLabel.TextSize, LogoLabel.Parent = UDim2.new(1, 0, 0, 45), 1, "KAY HUB", ActiveThemeColor, Enum.Font.SourceSansBold, 18, Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder, SidebarList.Padding, SidebarList.Parent = Enum.SortOrder.LayoutOrder, UDim.new(0, 5), Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency, ContentContainer.Parent = UDim2.new(1, -125, 1, -55), UDim2.new(0, 115, 0, 45), 1, MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size, TopBar.Position, TopBar.BackgroundTransparency, TopBar.Parent = UDim2.new(1, -110, 0, 45), UDim2.new(0, 110, 0, 0), 1, MainFrame

local CurrentTabTitle = Instance.new("TextLabel")
CurrentTabTitle.Size, CurrentTabTitle.Position, CurrentTabTitle.BackgroundTransparency, CurrentTabTitle.Text, CurrentTabTitle.TextColor3, CurrentTabTitle.Font, CurrentTabTitle.TextSize, CurrentTabTitle.TextXAlignment, CurrentTabTitle.Parent = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1, "Home", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16, Enum.TextXAlignment.Left, TopBar

-- Sistem Minimize / Toggle Menu
local MinButton = Instance.new("TextButton")
MinButton.Size, MinButton.Position, MinButton.BackgroundColor3, MinButton.Text, MinButton.TextColor3, MinButton.Font, MinButton.TextSize, MinButton.Parent = UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 7), Color3.fromRGB(35, 35, 35), "-", Color3.fromRGB(200, 200, 200), Enum.Font.SourceSansBold, 16, TopBar
Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 6)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size, ToggleButton.Position, ToggleButton.BackgroundColor3, ToggleButton.Text, ToggleButton.TextColor3, ToggleButton.Font, ToggleButton.TextSize, ToggleButton.Visible, ToggleButton.Parent = UDim2.new(0, 90, 0, 35), UDim2.new(0, 10, 0, 50), Color3.fromRGB(25, 25, 25), "Kay Hub", ActiveThemeColor, Enum.Font.SourceSansBold, 14, false, KayHub
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)
MakeDraggable(ToggleButton)

local isMinimized = false
local function toggleMenu()
    isMinimized = not isMinimized
    TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 420, 0, 0) or UDim2.new(0, 420, 0, 280)}):Play()
    if isMinimized then task.wait(0.3) end
    MainFrame.Visible = not isMinimized
    ToggleButton.Visible = isMinimized
end
MinButton.MouseButton1Click:Connect(toggleMenu)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

-- Pembuatan Fungsi Tab & Toggle Otomatis
local FirstTab = true
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame")
    Page.Size, Page.BackgroundTransparency, Page.BorderSizePixel, Page.ScrollBarThickness, Page.AutomaticCanvasSize, Page.Visible, Page.Parent = UDim2.new(1, 0, 1, 0), 1, 0, 3, Enum.AutomaticSize.Y, false, ContentContainer
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size, TabButton.BackgroundColor3, TabButton.BackgroundTransparency, TabButton.Text, TabButton.TextColor3, TabButton.Font, TabButton.TextSize, TabButton.TextXAlignment, TabButton.Parent = UDim2.new(0.9, 0, 0, 35), Color3.fromRGB(35, 35, 35), 1, "  " .. tabName, Color3.fromRGB(150, 150, 150), Enum.Font.SourceSansBold, 14, Enum.TextXAlignment.Left, Sidebar
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
    
    if FirstTab then Page.Visible, TabButton.BackgroundTransparency, TabButton.TextColor3, CurrentTabTitle.Text, FirstTab = true, 0, ActiveThemeColor, tabName, false end
    
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible, t.Btn.BackgroundTransparency, t.Btn.TextColor3 = false, 1, Color3.fromRGB(150, 150, 150) end
        Page.Visible, TabButton.BackgroundTransparency, TabButton.TextColor3, CurrentTabTitle.Text = true, 0, ActiveThemeColor, tabName
    end)
    table.insert(Tabs, {Page = Page, Btn = TabButton, Name = tabName})
    return Page
end

local function CreateToggle(parent, text, callback)
    local Enabled = false
    local Btn = Instance.new("TextButton")
    Btn.Size, Btn.BackgroundColor3, Btn.Text, Btn.TextColor3, Btn.Font, Btn.TextSize, Btn.Parent = UDim2.new(1, -10, 0, 35), Color3.fromRGB(30, 30, 30), text .. " : OFF", Color3.fromRGB(255, 100, 100), Enum.Font.SourceSansBold, 14, parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local data = {Instance = Btn, IsEnabled = false, BaseText = text}
    table.insert(ActiveToggles, data)

    Btn.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        data.IsEnabled = Enabled
        Btn.Text = text .. (Enabled and " : ON" or " : OFF")
        TS:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Enabled and ActiveThemeColor or Color3.fromRGB(255, 100, 100)}):Play()
        callback(Enabled)
    end)
    return Btn
end

-- =========================================================
-- HALAMAN UTAMA & FITUR-FITUR
-- =========================================================
local HomePage = CreateTab("Home")
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size, WelcomeLabel.BackgroundTransparency, WelcomeLabel.Text, WelcomeLabel.TextColor3, WelcomeLabel.Font, WelcomeLabel.TextSize, WelcomeLabel.Parent = UDim2.new(1, 0, 0, 45), 1, "Kay Hub V8 (Theme Engine)\nFitur Lengkap, Kode Ringkas & No Delay!", Color3.fromRGB(180, 180, 180), Enum.Font.SourceSans, 14, HomePage

-- 1. -- Ini Pokonya Buat Instan Interect
local oldGui = game.CoreGui:FindFirstChild("KayInstantInteractGUI") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("KayInstantInteractGUI")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KayInstantInteractGUI"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local isInstantActive = false
local promptConnection = nil

-- Fungsi Mekanisme Interaksi Instan
local function makeInstant(prompt)
    if prompt:IsA("ProximityPrompt") then
        if not prompt:GetAttribute("OriginalHold") then
            prompt:SetAttribute("OriginalHold", prompt.HoldDuration)
        end
        prompt.HoldDuration = 0
    end
end

local function resetToNormal(prompt)
    if prompt:IsA("ProximityPrompt") then
        local original = prompt:GetAttribute("OriginalHold")
        if original then prompt.HoldDuration = original end
    end
end

local function activateInstant()
    isInstantActive = true
    for _, prompt in pairs(game.Workspace:GetDescendants()) do makeInstant(prompt) end
    promptConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if isInstantActive then makeInstant(prompt) end
    end)
end

local function deactivateInstant()
    isInstantActive = false
    if promptConnection then promptConnection:Disconnect() end
    for _, prompt in pairs(game.Workspace:GetDescendants()) do resetToNormal(prompt) end
end

-- ================= GUI DESIGN =================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 110)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Aktifkan drag bawaan

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "KAY INSTANT INTERACT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local Padding = Instance.new("UIPadding", Title)
Padding.PaddingLeft = UDim.new(0, 10)

-- TOMBOL OPEN (BISA DIGESER JUGA PAS DI-MINIMIZE)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.Text = "📜 Open Interact"
OpenBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 12
OpenBtn.BorderSizePixel = 0
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true -- MEMBUAT POP-UP MINIMIZE BISA DIATUR KEMANA AJA

local MiniBtn = Instance.new("TextButton", MainFrame)
MiniBtn.Size = UDim2.new(0, 25, 0, 25)
MiniBtn.Position = UDim2.new(1, -55, 0, 2.5)
MiniBtn.Text = "_"
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.BorderSizePixel = 0

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -27, 0, 2.5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BorderSizePixel = 0

local BtnToggle = Instance.new("TextButton", MainFrame)
BtnToggle.Size = UDim2.new(0.9, 0, 0, 45)
BtnToggle.Position = UDim2.new(0.05, 0, 0.45, 0)
BtnToggle.Text = "STATUS: OFF"
BtnToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
BtnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggle.Font = Enum.Font.SourceSansBold
BtnToggle.TextSize = 14

-- ================= SYSTEM SMOOTH DRAG (MOBILE BYPASS) =================
local function setupSmoothDrag(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Pasang fitur geser mulus ke Menu Utama & Tombol Pop-up Minimize
setupSmoothDrag(MainFrame)
setupSmoothDrag(OpenBtn)

-- ================= EVENT HANDLING =================
BtnToggle.MouseButton1Click:Connect(function()
    if not isInstantActive then
        activateInstant()
        BtnToggle.Text = "STATUS: INSTAN ON"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        deactivateInstant()
        BtnToggle.Text = "STATUS: OFF"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end
end)

-- Pas di-minimize, posisi tombol "Open" disamakan dengan posisi menu terakhir biar rapi, tapi tetap bisa kamu geser setelahnya
MiniBtn.MouseButton1Click:Connect(function()
    OpenBtn.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    -- Memastikan klik biasa membuka menu, bukan sekadar mendeteksi geseran tangan
    MainFrame.Position = UDim2.new(OpenBtn.Position.X.Scale, OpenBtn.Position.X.Offset, OpenBtn.Position.Y.Scale, OpenBtn.Position.Y.Offset)
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    deactivateInstant()
    ScreenGui:Destroy()
end)

-- 2. -- Hapus GUI lama agar tidak menumpuk
local oldGui = game.CoreGui:FindFirstChild("PiggybackFEGUI") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("PiggybackFEGUI")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PiggybackFEGUI"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

-- Konfigurasi Posisi Default
local targetName = ""
local posX, posY, posZ, rotY = 0, 1.5, 0.8, 0
local isAttached = false

local localPlayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local attachmentConnection = nil
local respawnConnection = nil

-- Fungsi Loop Posisi (Bypass FE)
local function startLoop(targetChar)
    if attachmentConnection then attachmentConnection:Disconnect() end
    
    local myChar = localPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart", 5)
    
    if myHRP and targetHRP and myHumanoid then
        myHumanoid.PlatformStand = true
        
        attachmentConnection = RunService.Heartbeat:Connect(function()
            if not isAttached or not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("HumanoidRootPart") then
                if attachmentConnection then attachmentConnection:Disconnect() end
                return
            end
            
            myHRP.Velocity = Vector3.new(0, 0, 0)
            myHRP.RotVelocity = Vector3.new(0, 0, 0)
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(posX, posY, posZ) * CFrame.Angles(0, math.rad(rotY), 0)
        end)
        
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end

-- Fungsi Mulai Nempel & Pantau Respawn
local function attachToPlayer()
    local targetPlayer = game.Players:FindFirstChild(targetName)
    if not targetPlayer then return end
    
    isAttached = true
    if respawnConnection then respawnConnection:Disconnect() end
    
    if targetPlayer.Character then
        startLoop(targetPlayer.Character)
    end
    
    respawnConnection = targetPlayer.CharacterAdded:Connect(function(newCharacter)
        if isAttached then
            task.wait(0.5) 
            startLoop(newCharacter)
        end
    end)
end

-- Fungsi Lepas Total
local function detach()
    isAttached = false
    if attachmentConnection then attachmentConnection:Disconnect() end
    if respawnConnection then respawnConnection:Disconnect() end
    
    local myChar = localPlayer.Character
    if myChar then
        local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHumanoid then myHumanoid.PlatformStand = false end
        if myHRP then myHRP.Velocity = Vector3.new(0, 0, 0) end
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ================= GUI DESIGN =================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- SUDAH DIGANTI JADI KAY PIGGYBACK
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "KAY PIGGYBACK FE BYPASS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

-- Tombol Kecil buat Buka Kembali (Awalnya Sembunyi)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 110, 0, 30)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.Text = "KAY PIGGYBACK"
OpenBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 12
OpenBtn.Visible = false

-- Tombol Minimize di Dalam MainFrame (Pojok Kanan Atas)
local MiniBtn = Instance.new("TextButton", MainFrame)
MiniBtn.Size = UDim2.new(0, 25, 0, 25)
MiniBtn.Position = UDim2.new(1, -30, 0, 2.5)
MiniBtn.Text = "_"
MiniBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 14

local TextBox = Instance.new("TextBox", MainFrame)
TextBox.Size = UDim2.new(0.9, 0, 0, 35)
TextBox.Position = UDim2.new(0.05, 0, 0.15, 0)
TextBox.PlaceholderText = "Nama Player (Sensitif Kapital)"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextSize = 14

local BtnAttach = Instance.new("TextButton", MainFrame)
BtnAttach.Size = UDim2.new(0.42, 0, 0, 35)
BtnAttach.Position = UDim2.new(0.05, 0, 0.3, 0)
BtnAttach.Text = "TEMPEL"
BtnAttach.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
BtnAttach.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAttach.Font = Enum.Font.SourceSansBold

local BtnDetach = Instance.new("TextButton", MainFrame)
BtnDetach.Size = UDim2.new(0.42, 0, 0, 35)
BtnDetach.Position = UDim2.new(0.53, 0, 0.3, 0)
BtnDetach.Text = "LEPAS"
BtnDetach.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
BtnDetach.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnDetach.Font = Enum.Font.SourceSansBold

local LabelCtrl = Instance.new("TextLabel", MainFrame)
LabelCtrl.Size = UDim2.new(1, 0, 0, 20)
LabelCtrl.Position = UDim2.new(0, 0, 0.45, 0)
LabelCtrl.Text = "--- NAVIGASI POSISI ---"
LabelCtrl.TextColor3 = Color3.fromRGB(200, 200, 200)
LabelCtrl.BackgroundTransparency = 1
LabelCtrl.TextSize = 11

local function createNavBtn(text, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.25, 0, 0, 30)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 75, 90)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createNavBtn("NAIK", UDim2.new(0.05, 0, 0.55, 0), function() posY = posY + 0.2 end)
createNavBtn("TURUN", UDim2.new(0.05, 0, 0.68, 0), function() posY = posY - 0.2 end)

createNavBtn("DEPAN", UDim2.new(0.375, 0, 0.55, 0), function() posZ = posZ - 0.2 end)
createNavBtn("BELAKANG", UDim2.new(0.375, 0, 0.68, 0), function() posZ = posZ + 0.2 end)

createNavBtn("KIRI", UDim2.new(0.7, 0, 0.55, 0), function() posX = posX - 0.2 end)
createNavBtn("KANAN", UDim2.new(0.7, 0, 0.68, 0), function() posX = posX + 0.2 end)

createNavBtn("PUTAR", UDim2.new(0.05, 0, 0.82, 0), function() rotY = (rotY + 90) % 360 end)

local BtnClose = Instance.new("TextButton", MainFrame)
BtnClose.Size = UDim2.new(0.42, 0, 0, 30)
BtnClose.Position = UDim2.new(0.53, 0, 0.82, 0)
BtnClose.Text = "TUTUP GUI"
BtnClose.BackgroundColor3 = Color3.fromRGB(110, 110, 120)
BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Event Handling Aksi
BtnAttach.MouseButton1Click:Connect(function()
    targetName = TextBox.Text
    attachToPlayer()
end)

BtnDetach.MouseButton1Click:Connect(function()
    detach()
end)

BtnClose.MouseButton1Click:Connect(function()
    detach()
    ScreenGui:Destroy()
end)

-- Event Handling Minimize / Maximize
MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

local MainFeaturesPage = CreateTab("Features")
local SpeedValue, SpeedEnabled, InfiniteJumpEnabled, Flying, FlySpeed, AirWalkEnabled, AirWalkPlatform, NoclipEnabled = 16, false, false, false, 60, false, nil, false

-- 1. Speed Walk Frame & Slider
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size, SpeedFrame.BackgroundColor3, SpeedFrame.Parent = UDim2.new(1, -10, 0, 75), Color3.fromRGB(30, 30, 30), MainFeaturesPage
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 6)

local SpeedToggleBtn = Instance.new("TextButton")
SpeedToggleBtn.Size, SpeedToggleBtn.BackgroundTransparency, SpeedToggleBtn.Text, SpeedToggleBtn.TextColor3, SpeedToggleBtn.Font, SpeedToggleBtn.TextSize, SpeedToggleBtn.Parent = UDim2.new(1, 0, 0, 35), 1, "Speed Walk : OFF", Color3.fromRGB(255, 100, 100), Enum.Font.SourceSansBold, 14, SpeedFrame
table.insert(ActiveToggles, {Instance = SpeedToggleBtn, IsEnabled = false, BaseText = "Speed Walk"})

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size, SliderLabel.Position, SliderLabel.BackgroundTransparency, SliderLabel.Text, SliderLabel.TextColor3, SliderLabel.Font, SliderLabel.TextSize, SliderLabel.Parent = UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 35), 1, "Atur Kecepatan: < " .. SpeedValue .. " >", Color3.fromRGB(200, 200, 200), Enum.Font.SourceSans, 13, SpeedFrame

local function createChangeSpeedBtn(text, pos, offset)
    local b = Instance.new("TextButton")
    b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.Parent = UDim2.new(0, 35, 0, 25), pos, Color3.fromRGB(45, 45, 45), text, Color3.fromRGB(255, 255, 255), SpeedFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        SpeedValue = math.max(16, SpeedValue + offset)
        SliderLabel.Text = "Atur Kecepatan: < " .. SpeedValue .. " >"
    end)
end
createChangeSpeedBtn("-", UDim2.new(0, 10, 0, 40), -10)
createChangeSpeedBtn("+", UDim2.new(1, -45, 0, 40), 10)

SpeedToggleBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    for _, t in pairs(ActiveToggles) do if t.Instance == SpeedToggleBtn then t.IsEnabled = SpeedEnabled end end
    SpeedToggleBtn.Text = SpeedEnabled and "Speed Walk : ON" or "Speed Walk : OFF"
    SpeedToggleBtn.TextColor3 = SpeedEnabled and ActiveThemeColor or Color3.fromRGB(255, 100, 100)
    if not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
end)

-- Loops Logika Fitur
RS.Stepped:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = SpeedValue end
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
end)

-- 2. Fitur Fly
local bV, bG
CreateToggle(MainFeaturesPage, "Fly", function(state)
    Flying = state
    local Char = LocalPlayer.Character
    local Root, Hum, Anim = Char and Char:FindFirstChild("HumanoidRootPart"), Char and Char:FindFirstChildOfClass("Humanoid"), Char and Char:FindFirstChild("Animate")
    if Flying and Root and Hum then
        if Anim then Anim.Enabled = false end
        bV, bG = Instance.new("BodyVelocity"), Instance.new("BodyGyro")
        bV.MaxForce, bV.Velocity, bV.Parent = Vector3.new(1e9, 1e9, 1e9), Vector3.new(0,0,0), Root
        bG.MaxTorque, bG.CFrame, bG.Parent = Vector3.new(1e9, 1e9, 1e9), Root.CFrame, Root
        task.spawn(function()
            while Flying and task.wait() do
                local Cam = workspace.CurrentCamera
                if Root and Hum and Cam and bV and bG then
                    bG.CFrame = Cam.CFrame
                    local move = Hum.MoveDirection
                    bV.Velocity = move.Magnitude > 0 and ((Cam.CFrame.LookVector * move:Dot(Cam.CFrame.LookVector) * FlySpeed) + (Cam.CFrame.RightVector * move:Dot(Cam.CFrame.RightVector) * FlySpeed)) or Vector3.new(0,0,0)
                end
            end
            if bV then bV:Destroy() end if bG then bG:Destroy() end if Anim then Anim.Enabled = true end
        end)
    else
        if bV then bV:Destroy() end if bG then bG:Destroy() end if Anim then Anim.Enabled = true end
    end
end)

-- 3. Fitur Noclip, Airwalk & Inf Jump
CreateToggle(MainFeaturesPage, "Noclip", function(state) NoclipEnabled = state end)

local AirWalkConnection
CreateToggle(MainFeaturesPage, "Air Walk", function(state)
    AirWalkEnabled = state
    if AirWalkEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        AirWalkPlatform = AirWalkPlatform or Instance.new("Part", workspace)
        AirWalkPlatform.Size, AirWalkPlatform.Transparency, AirWalkPlatform.Anchored = Vector3.new(35, 2, 35), 1, true
        AirWalkConnection = RS.PreSimulation:Connect(function()
            local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Root and AirWalkPlatform then
                AirWalkPlatform.CFrame = CFrame.new(Root.Position.X, AirWalkPlatform.Position.Y, Root.Position.Z)
                if Root.Position.Y < AirWalkPlatform.Position.Y + 2.5 then Root.CFrame = CFrame.new(Root.Position.X, AirWalkPlatform.Position.Y + 2.5, Root.Position.Z) end
            end
        end)
    else
        if AirWalkConnection then AirWalkConnection:Disconnect() end if AirWalkPlatform then AirWalkPlatform:Destroy() AirWalkPlatform = nil end
    end
end)

CreateToggle(MainFeaturesPage, "Infinite Jump", function(state) InfiniteJumpEnabled = state end)
UIS.JumpRequest:Connect(function() if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-- =========================================================
-- SETTINGS & THEME ENGINE
-- =========================================================
local SettingsPage = CreateTab("Settings")
local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Size, ThemeLabel.BackgroundTransparency, ThemeLabel.Text, ThemeLabel.TextColor3, ThemeLabel.Font, ThemeLabel.TextSize, ThemeLabel.TextXAlignment, ThemeLabel.Parent = UDim2.new(1, -10, 0, 30), 1, "PILIH TEMA WARNA UI:", Color3.fromRGB(200, 200, 200), Enum.Font.SourceSansBold, 14, Enum.TextXAlignment.Left, SettingsPage

for Name, Color in pairs(Themes) do
    local ThemeBtn = Instance.new("TextButton")
    ThemeBtn.Size, ThemeBtn.BackgroundColor3, ThemeBtn.Text, ThemeBtn.TextColor3, ThemeBtn.Font, ThemeBtn.TextSize, ThemeBtn.TextXAlignment, ThemeBtn.Parent = UDim2.new(1, -10, 0, 35), Color3.fromRGB(32, 32, 32), "• " .. Name, Color, Enum.Font.SourceSansBold, 14, Enum.TextXAlignment.Left, SettingsPage
    Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 6)
    ThemeBtn.MouseButton1Click:Connect(function()
        ActiveThemeColor = Color
        TS:Create(LogoLabel, TweenInfo.new(0.3), {TextColor3 = Color}):Play()
        TS:Create(ToggleButton, TweenInfo.new(0.3), {TextColor3 = Color}):Play()
        for _, t in pairs(Tabs) do if t.Page.Visible then TS:Create(t.Btn, TweenInfo.new(0.3), {TextColor3 = Color}):Play() end end
        for _, tg in pairs(ActiveToggles) do if tg.IsEnabled then TS:Create(tg.Instance, TweenInfo.new(0.3), {TextColor3 = Color}):Play() end end
    end)
end

local CreditsPage = CreateTab("Credits")
local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size, AuthorLabel.BackgroundTransparency, AuthorLabel.Text, AuthorLabel.TextColor3, AuthorLabel.Font, AuthorLabel.TextSize, AuthorLabel.Parent = UDim2.new(1, 0, 0, 30), 1, "UI Framework ini didesain khusus untuk Kay.", Color3.fromRGB(150, 150, 150), Enum.Font.SourceSansItalic, 14, CreditsPage

print("[SYSTEM] Kay Hub Pro V8 Slim Dimuat.")
