-- [[ KAY HUB PRO V8 - SLEEK & ELEGANT EDITION ]] --
local Players, TS, RS, UIS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Tema Warna Elegan (Aksen Premium Neon Green / Dark Slate)
local AccentColor = Color3.fromRGB(0, 230, 130)
local BGColor = Color3.fromRGB(15, 15, 15)
local FrameColor = Color3.fromRGB(22, 22, 22)
local TextColor = Color3.fromRGB(240, 240, 240)
local MutedText = Color3.fromRGB(140, 140, 140)

local ActiveToggles, Tabs = {}, {}

-- UI Utama (ScreenGui)
local KayHub = Instance.new("ScreenGui")
pcall(function() KayHub.Parent = game:GetService("CoreGui") end)
if not KayHub.Parent then KayHub.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.Active, MainFrame.ClipsDescendants, MainFrame.Parent = UDim2.new(0, 440, 0, 300), UDim2.new(0.3, 0, 0.25, 0), BGColor, true, true, KayHub
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(35, 35, 35), 1

-- Fungsi Drag & Drop Ringkas
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

-- Sidebar Minimalis
local Sidebar = Instance.new("Frame")
Sidebar.Size, Sidebar.BackgroundColor3, Sidebar.Parent = UDim2.new(0, 120, 1, 0), FrameColor, MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size, LogoLabel.BackgroundTransparency, LogoLabel.Text, LogoLabel.TextColor3, LogoLabel.Font, LogoLabel.TextSize, LogoLabel.Parent = UDim2.new(1, 0, 0, 50), 1, "KAY HUB V8", AccentColor, Enum.Font.GothamBold, 15, Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder, SidebarList.Padding, SidebarList.HorizontalAlignment, SidebarList.Parent = Enum.SortOrder.LayoutOrder, UDim.new(0, 4), Enum.HorizontalAlignment.Center, Sidebar

-- Container Konten
local ContentContainer = Instance.new("Frame")
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency, ContentContainer.Parent = UDim2.new(1, -135, 1, -55), UDim2.new(0, 125, 0, 45), 1, MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size, TopBar.Position, TopBar.BackgroundTransparency, TopBar.Parent = UDim2.new(1, -120, 0, 45), UDim2.new(0, 120, 0, 0), 1, MainFrame

local CurrentTabTitle = Instance.new("TextLabel")
CurrentTabTitle.Size, CurrentTabTitle.Position, CurrentTabTitle.BackgroundTransparency, CurrentTabTitle.Text, CurrentTabTitle.TextColor3, CurrentTabTitle.Font, CurrentTabTitle.TextSize, CurrentTabTitle.TextXAlignment, CurrentTabTitle.Parent = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1, "Home", TextColor, Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, TopBar

-- Minimize Button Elegan
local MinButton = Instance.new("TextButton")
MinButton.Size, MinButton.Position, MinButton.BackgroundTransparency, MinButton.Text, MinButton.TextColor3, MinButton.Font, MinButton.TextSize, MinButton.Parent = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 7), 1, "—", MutedText, Enum.Font.GothamBold, 12, TopBar

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size, ToggleButton.Position, ToggleButton.BackgroundColor3, ToggleButton.Text, ToggleButton.TextColor3, ToggleButton.Font, ToggleButton.TextSize, ToggleButton.Visible, ToggleButton.Parent = UDim2.new(0, 80, 0, 32), UDim2.new(0, 15, 0, 50), FrameColor, "Kay Hub", AccentColor, Enum.Font.GothamBold, 12, false, KayHub
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ToggleButton).Color = Color3.fromRGB(40, 40, 40)
MakeDraggable(ToggleButton)

local isMinimized = false
local function toggleMenu()
    isMinimized = not isMinimized
    TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 440, 0, 0) or UDim2.new(0, 440, 0, 300)}):Play()
    if isMinimized then task.wait(0.2) end
    MainFrame.Visible = not isMinimized
    ToggleButton.Visible = isMinimized
end
MinButton.MouseButton1Click:Connect(toggleMenu)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

-- Pembuat Tab & Toggle Simpel
local FirstTab = true
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame")
    Page.Size, Page.BackgroundTransparency, Page.BorderSizePixel, Page.ScrollBarThickness, Page.AutomaticCanvasSize, Page.Visible, Page.Parent = UDim2.new(1, 0, 1, 0), 1, 0, 2, Enum.AutomaticSize.Y, false, ContentContainer
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding, PageList.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size, TabButton.BackgroundTransparency, TabButton.Text, TabButton.TextColor3, TabButton.Font, TabButton.TextSize, TabButton.Parent = UDim2.new(0.9, 0, 0, 32), 1, tabName, MutedText, Enum.Font.GothamBold, 12, Sidebar
    
    if FirstTab then Page.Visible, TabButton.TextColor3, CurrentTabTitle.Text, FirstTab = true, AccentColor, tabName, false end
    
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible, t.Btn.TextColor3 = false, MutedText end
        Page.Visible, TabButton.TextColor3, CurrentTabTitle.Text = true, AccentColor, tabName
    end)
    table.insert(Tabs, {Page = Page, Btn = TabButton, Name = tabName})
    return Page
end

local function CreateToggle(parent, text, callback)
    local Enabled = false
    local Frame = Instance.new("Frame", parent)
    Frame.Size, Frame.BackgroundColor3 = UDim2.new(1, -10, 0, 35), FrameColor
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size, Label.Position, Label.BackgroundTransparency, Label.Text, Label.TextColor3, Label.Font, Label.TextSize, Label.TextXAlignment = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1, text, TextColor, Enum.Font.Gotham, 13, Enum.TextXAlignment.Left
    
    local Switch = Instance.new("TextButton", Frame)
    Switch.Size, Switch.Position, Switch.BackgroundColor3, Switch.Text, Switch.TextColor3, Switch.Font, Switch.TextSize = UDim2.new(0, 45, 0, 20), UDim2.new(1, -55, 0, 7.5), Color3.fromRGB(40, 40, 40), "OFF", MutedText, Enum.Font.GothamBold, 10
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 10)

    local data = {Instance = Switch, IsEnabled = false}
    table.insert(ActiveToggles, data)

    Switch.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        data.IsEnabled = Enabled
        Switch.Text = Enabled and "ON" or "OFF"
        TS:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Enabled and AccentColor or Color3.fromRGB(40, 40, 40), TextColor3 = Enabled and Color3.fromRGB(10,10,10) or MutedText}):Play()
        callback(Enabled)
    end)
    return Frame
end

-- =========================================================
-- LOGIKA UTAMA: PIGGYBACK (MENGGUNAKAN DISPLAY NAME / NAMA KEPALA)
-- =========================================================
local targetPlayerObj = nil -- Menyimpan objek player target secara langsung
local posX, posY, posZ, rotY = 0, 1.5, 0.8, 0
local isAttached, autoEmoteEnabled = false, true
local attachmentConnection, respawnConnection, currentEmoteTrack, lockLoop

local function removeWelds()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("Weld") or part:IsA("WeldConstraint") or part:IsA("AlignPosition") then part:Destroy() end
        end
    end
end

local function startLoop(targetChar)
    if attachmentConnection then attachmentConnection:Disconnect() end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart", 5)
    
    if myHRP and targetHRP and myHumanoid then
        myHumanoid.PlatformStand = true
        for _, part in pairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
        
        attachmentConnection = RS.Heartbeat:Connect(function()
            if not isAttached or not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("HumanoidRootPart") then
                if attachmentConnection then attachmentConnection:Disconnect() end
                return
            end
            local offset = targetHRP.CFrame * CFrame.new(posX, posY, posZ) * CFrame.Angles(0, math.rad(rotY), 0)
            pcall(function() sethiddenproperty(myHRP, "PhysicsRepRootPart", targetHRP) end)
            myHRP.CFrame = offset
            myHRP.Velocity, myHRP.AssemblyLinearVelocity, myHRP.AssemblyAngularVelocity = Vector3.new(), Vector3.new(), Vector3.new()
        end)
    end
end

local function detach()
    isAttached = false
    if attachmentConnection then attachmentConnection:Disconnect() end
    if respawnConnection then respawnConnection:Disconnect() end
    local myChar = LocalPlayer.Character
    if myChar then
        local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
        if myHumanoid then myHumanoid.PlatformStand = false end
        for _, part in pairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end
end

-- =========================================================
-- HALAMAN UTAMA (HOME TABS)
-- =========================================================
local HomePage = CreateTab("Home")

-- Fitur Instant Interact
local ProximityPromptService = game:GetService("ProximityPromptService")
local isInstantActive = false
local promptConnection = nil

CreateToggle(HomePage, "Instant Interact", function(state)
    isInstantActive = state
    if isInstantActive then
        for _, prompt in pairs(workspace:GetDescendants()) do if prompt:IsA("ProximityPrompt") then prompt:SetAttribute("OriginalHold", prompt.HoldDuration) prompt.HoldDuration = 0 end end
        promptConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt) if isInstantActive then prompt.HoldDuration = 0 end end)
    else
        if promptConnection then promptConnection:Disconnect() end
        for _, prompt in pairs(workspace:GetDescendants()) do if prompt:IsA("ProximityPrompt") then local orig = prompt:GetAttribute("OriginalHold") if orig then prompt.HoldDuration = orig end end end
    end
end)

-- SEPARATOR LINE SLICK
local Line = Instance.new("Frame", HomePage)
Line.Size, Line.BackgroundColor3, Line.BorderSizePixel = UDim2.new(1, -10, 0, 1), Color3.fromRGB(35, 35, 35), 0

-- UI SELECTION PLAYER BARU (SIMPLE & ELEGAN)
local SearchBox = Instance.new("TextBox", HomePage)
SearchBox.Size, SearchBox.BackgroundColor3, SearchBox.TextColor3, SearchBox.PlaceholderText, SearchBox.Font, SearchBox.TextSize = UDim2.new(1, -10, 0, 32), FrameColor, TextColor, "Cari nama player (Nama di atas kepala)...", Enum.Font.Gotham, 12
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SearchBox).Color = Color3.fromRGB(35, 35, 35)

local DropdownBtn = Instance.new("TextButton", HomePage)
DropdownBtn.Size, DropdownBtn.BackgroundColor3, DropdownBtn.TextColor3, DropdownBtn.Text, DropdownBtn.Font, DropdownBtn.TextSize = UDim2.new(1, -10, 0, 32), FrameColor, MutedText, "▼ Pilih Player Target ▼", Enum.Font.GothamBold, 12
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

local PlayerListFrame = Instance.new("ScrollingFrame", HomePage)
PlayerListFrame.Size, PlayerListFrame.Visible, PlayerListFrame.BackgroundColor3, PlayerListFrame.ScrollBarThickness, PlayerListFrame.BorderSizePixel = UDim2.new(1, -10, 0, 100), false, Color3.fromRGB(18, 18, 18), 2, 0
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 6)
local ListLayout = Instance.new("UIListLayout", PlayerListFrame)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

DropdownBtn.MouseButton1Click:Connect(function() PlayerListFrame.Visible = not PlayerListFrame.Visible end)

-- Fungsi Refresh List Menggunakan DISPLAY NAME (Nama Atas Kepala)
local function refreshPlayerList(filter)
    for _, child in pairs(PlayerListFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Mengecek kecocokan teks filter dengan nama asli (Name) maupun nama di atas kepala (DisplayName)
            if not filter or filter == "" or string.find(string.lower(player.DisplayName), string.lower(filter)) or string.find(string.lower(player.Name), string.lower(filter)) then
                local btn = Instance.new("TextButton", PlayerListFrame)
                btn.Size, btn.BackgroundColor3, btn.TextColor3, btn.Text, btn.Font, btn.TextSize = UDim2.new(1, 0, 0, 28), Color3.fromRGB(24, 24, 24), TextColor, player.DisplayName, Enum.Font.Gotham, 11
                btn.BorderSizePixel = 0
                btn.MouseButton1Click:Connect(function()
                    targetPlayerObj = player -- Simpan objek player langsung
                    DropdownBtn.Text = "Selected: " .. player.DisplayName
                    PlayerListFrame.Visible = false
                end)
            end
        end
    end
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() refreshPlayerList(SearchBox.Text) PlayerListFrame.Visible = true end)
refreshPlayerList()

-- Eksekusi Tempel / Lepas Piggyback
local function runAttachLogic()
    if not targetPlayerObj then return end
    isAttached = true
    removeWelds()
    if respawnConnection then respawnConnection:Disconnect() end
    if targetPlayerObj.Character then startLoop(targetPlayerObj.Character) end
    respawnConnection = targetPlayerObj.CharacterAdded:Connect(function(char) if isAttached then task.wait(0.5) startLoop(char) end end)
    
    if autoEmoteEnabled and targetPlayerObj.Character and LocalPlayer.Character then
        local char = LocalPlayer.Character
        if currentEmoteTrack then currentEmoteTrack:Stop() end
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://107480602323379"
        currentEmoteTrack = char:WaitForChild("Humanoid"):LoadAnimation(anim)
        currentEmoteTrack:Play()
        
        if lockLoop then lockLoop:Disconnect() end
        lockLoop = RS.RenderStepped:Connect(function()
            local tRoot = targetPlayerObj.Character and targetPlayerObj.Character:FindFirstChild("HumanoidRootPart")
            local cRoot = char and char:FindFirstChild("HumanoidRootPart")
            if tRoot and cRoot then
                cRoot.CFrame = tRoot.CFrame * CFrame.new(0, -25, 3) * CFrame.Angles(0, math.rad(180), 0)
            else if lockLoop then lockLoop:Disconnect() end end
        end)
    end
end

local function runDetachLogic()
    detach()
    if currentEmoteTrack then currentEmoteTrack:Stop() end
    if lockLoop then lockLoop:Disconnect() end
end

-- Tombol Tempel & Lepas Simpel
local ActionFrame = Instance.new("Frame", HomePage)
ActionFrame.Size, ActionFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 32), 1
local ActionLayout = Instance.new("UIListLayout", ActionFrame)
ActionLayout.FillDirection, ActionLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)

local function createActionBtn(txt, color, cb)
    local b = Instance.new("TextButton", ActionFrame)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.49, 0, 1, 0), color, txt, Color3.fromRGB(240,240,240), Enum.Font.GothamBold, 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end
createActionBtn("TEMPEL", Color3.fromRGB(20, 140, 80), runAttachLogic)
createActionBtn("LEPAS", Color3.fromRGB(150, 40, 40), runDetachLogic)

-- Navigasi Posisi Mini-Grid
local NavFrame = Instance.new("Frame", HomePage)
NavFrame.Size, NavFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 65), 1
local NavGrid = Instance.new("UIGridLayout", NavFrame)
NavGrid.CellSize, NavGrid.CellPadding = UDim2.new(0.235, 0, 0, 26), UDim2.new(0, 4, 0, 4)

local function createNav(txt, cb)
    local b = Instance.new("TextButton", NavFrame)
    b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = FrameColor, txt, TextColor, Enum.Font.GothamBold, 9
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(cb)
end
createNav("NAIK", function() posY = posY + 0.2 end)
createNav("TURUN", function() posY = posY - 0.2 end)
createNav("DEPAN", function() posZ = posZ - 0.2 end)
createNav("BELAKANG", function() posZ = posZ + 0.2 end)
createNav("KIRI", function() posX = posX - 0.2 end)
createNav("KANAN", function() posX = posX + 0.2 end)
createNav("PUTAR", function() rotY = (rotY + 90) % 360 end)

local ToggleEmoteBtn = Instance.new("TextButton", NavFrame)
ToggleEmoteBtn.BackgroundColor3, ToggleEmoteBtn.Text, ToggleEmoteBtn.TextColor3, ToggleEmoteBtn.Font, ToggleEmoteBtn.TextSize = Color3.fromRGB(20, 140, 80), "EMOTE: ON", Color3.fromRGB(240,240,240), Enum.Font.GothamBold, 9
Instance.new("UICorner", ToggleEmoteBtn).CornerRadius = UDim.new(0, 4)
ToggleEmoteBtn.MouseButton1Click:Connect(function()
    autoEmoteEnabled = not autoEmoteEnabled
    ToggleEmoteBtn.BackgroundColor3 = autoEmoteEnabled and Color3.fromRGB(20, 140, 80) or Color3.fromRGB(150, 40, 40)
    ToggleEmoteBtn.Text = autoEmoteEnabled and "EMOTE: ON" or "EMOTE: OFF"
end)

-- =========================================================
-- FUN & CHEATS FEATURES (FLY, SPEED, ETC.)
-- =========================================================
local FunPage = CreateTab("Fun")
local SpeedValue, SpeedEnabled, InfiniteJumpEnabled, Flying, FlySpeed, NoclipEnabled = 16, false, false, false, 60, false

-- Panel Speed Walk Modern
local SpeedFrame = Instance.new("Frame", FunPage)
SpeedFrame.Size, SpeedFrame.BackgroundColor3 = UDim2.new(1, -10, 0, 40), FrameColor
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 6)

local SpeedToggle = Instance.new("TextButton", SpeedFrame)
SpeedToggle.Size, SpeedToggle.Position, SpeedToggle.BackgroundColor3, SpeedToggle.Text, SpeedToggle.TextColor3, SpeedToggle.Font, SpeedToggle.TextSize = UDim2.new(0, 80, 0, 24), UDim2.new(0, 8, 0, 8), Color3.fromRGB(40, 40, 40), "Speed: OFF", MutedText, Enum.Font.GothamBold, 11
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(0, 6)

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Size, SpeedLabel.Position, SpeedLabel.BackgroundTransparency, SpeedLabel.Text, SpeedLabel.TextColor3, SpeedLabel.Font, SpeedLabel.TextSize = UDim2.new(0, 120, 1, 0), UDim2.new(0, 95, 0, 0), 1, "Value: < " .. SpeedValue .. " >", TextColor, Enum.Font.Gotham, 11

local function createChangeSpeed(txt, x, offset)
    local b = Instance.new("TextButton", SpeedFrame)
    b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, x, 0, 8), Color3.fromRGB(32,32,32), txt, TextColor, Enum.Font.GothamBold, 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() SpeedValue = math.max(16, SpeedValue + offset) SpeedLabel.Text = "Value: < " .. SpeedValue .. " >" end)
end
createChangeSpeed("-", -60, -10)
createChangeSpeed("+", -32, 10)

SpeedToggle.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    SpeedToggle.Text = SpeedEnabled and "Speed: ON" or "Speed: OFF"
    TS:Create(SpeedToggle, TweenInfo.new(0.2), {BackgroundColor3 = SpeedEnabled and AccentColor or Color3.fromRGB(40, 40, 40), TextColor3 = SpeedEnabled and Color3.fromRGB(10,10,10) or MutedText}):Play()
    if not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
end)

-- Panel Fly Speed Modern
local FlySpeedFrame = Instance.new("Frame", FunPage)
FlySpeedFrame.Size, FlySpeedFrame.BackgroundColor3 = UDim2.new(1, -10, 0, 40), FrameColor
Instance.new("UICorner", FlySpeedFrame).CornerRadius = UDim.new(0, 6)

local FlyLabel = Instance.new("TextLabel", FlySpeedFrame)
FlyLabel.Size, FlyLabel.Position, FlyLabel.BackgroundTransparency, FlyLabel.Text, FlyLabel.TextColor3, FlyLabel.Font, FlyLabel.TextSize = UDim2.new(0, 150, 1, 0), UDim2.new(0, 12, 0, 0), 1, "Kecepatan Terbang: [ " .. FlySpeed .. " ]", TextColor, Enum.Font.Gotham, 12

local function createChangeFly(txt, x, offset)
    local b = Instance.new("TextButton", FlySpeedFrame)
    b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, x, 0, 8), Color3.fromRGB(32,32,32), txt, TextColor, Enum.Font.GothamBold, 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() FlySpeed = math.max(10, FlySpeed + offset) FlyLabel.Text = "Kecepatan Terbang: [ " .. FlySpeed .. " ]" end)
end
createChangeFly("-", -60, -10)
createChangeFly("+", -32, 10)

-- Loop Utama Stepped (Speed & Noclip)
RS.Stepped:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = SpeedValue end
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
end)

-- Fitur Terbang Stabil Klasik
local bV, bG
CreateToggle(FunPage, "Fly Engine V8", function(state)
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

CreateToggle(FunPage, "Noclip Matrix", function(state) NoclipEnabled = state end)

CreateToggle(FunPage, "Infinite Jump", function(state) InfiniteJumpEnabled = state end)
UIS.JumpRequest:Connect(function() if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-- Tab Credit Simpel
local CreditsPage = CreateTab("Credits")
local CreditLabel = Instance.new("TextLabel", CreditsPage)
CreditLabel.Size, CreditLabel.BackgroundTransparency, CreditLabel.Text, CreditLabel.TextColor3, CreditLabel.Font, CreditLabel.TextSize = UDim2.new(1, 0, 0, 40), 1, "Dibuat khusus dengan UI Elegan & Fleksibel untuk Kay.", MutedText, Enum.Font.GothamItalic, 11

print("[SYSTEM] Kay Hub V8 Sleek Edition loaded successfully.")
