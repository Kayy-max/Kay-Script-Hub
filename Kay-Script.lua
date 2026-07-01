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
-- LOGIKA UTAMA FITUR TAMBAHAN (INTERACT & PIGGYBACK)
-- =========================================================
-- [ Variabel Fitur 1: Instant Interact ]
local ProximityPromptService = game:GetService("ProximityPromptService")
local isInstantActive = false
local promptConnection = nil

local function makeInstant(prompt)
    if prompt:IsA("ProximityPrompt") then
        if not prompt:GetAttribute("OriginalHold") then prompt:SetAttribute("OriginalHold", prompt.HoldDuration) end
        prompt.HoldDuration = 0
    end
end

local function resetToNormal(prompt)
    if prompt:IsA("ProximityPrompt") then
        local original = prompt:GetAttribute("OriginalHold")
        if original then prompt.HoldDuration = original end
    end
end

-- [ Variabel Fitur 2: Piggyback FE ]
local targetName = ""
local posX, posY, posZ, rotY = 0, 1.5, 0.8, 0
local isAttached = false
local attachmentConnection = nil
local respawnConnection = nil

local function startLoop(targetChar)
    if attachmentConnection then attachmentConnection:Disconnect() end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart", 5)
    
    if myHRP and targetHRP and myHumanoid then
        myHumanoid.PlatformStand = true
        
        -- Menonaktifkan tabrakan fisik agar tidak menghambat target
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        
        -- Loop Utama Menggunakan Trik PhysicsRepRootPart + Offset Navigasi UI
        attachmentConnection = RS.Heartbeat:Connect(function()
            if not isAttached or not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("HumanoidRootPart") then
                if attachmentConnection then attachmentConnection:Disconnect() end
                return
            end
            
            -- Penggabungan Kode: Mengkalkulasi matriks posisi berdasarkan tombol navigasi UI
            local offset = targetHRP.CFrame * CFrame.new(posX, posY, posZ) * CFrame.Angles(0, math.rad(rotY), 0)
            
            -- Memaksa sinkronisasi Network Ownership lewat sethiddenproperty
            pcall(function()
                sethiddenproperty(myHRP, "PhysicsRepRootPart", targetHRP)
            end)
            
            -- Pembersihan instan velocity agar replikasi di POV teman 100% mulus tanpa delay
            myHRP.CFrame = offset
            myHRP.Velocity = Vector3.new()
            myHRP.AssemblyLinearVelocity = Vector3.new()
            myHRP.AssemblyAngularVelocity = Vector3.new()
            myHRP.RotVelocity = Vector3.new()
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
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHumanoid then myHumanoid.PlatformStand = false end
        
        -- Kembalikan PhysicsRepRootPart ke objek aslinya (Nil) saat lepas
        if myHRP then 
            pcall(function()
                sethiddenproperty(myHRP, "PhysicsRepRootPart", nil)
            end)
            myHRP.Velocity = Vector3.new(0, 0, 0) 
            myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myHRP.RotVelocity = Vector3.new(0, 0, 0)
        end
        
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

local function forceUpdatePosition()
    if isAttached then
        local targetPlayer = game.Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character then
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and targetHRP then
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(posX, posY, posZ) * CFrame.Angles(0, math.rad(rotY), 0)
            end
        end
    end
end

local function attachToPlayer()
    local targetPlayer = game.Players:FindFirstChild(targetName)
    if not targetPlayer then return end
    isAttached = true
    if respawnConnection then respawnConnection:Disconnect() end
    if targetPlayer.Character then startLoop(targetPlayer.Character) end
    respawnConnection = targetPlayer.CharacterAdded:Connect(function(newCharacter)
        if isAttached then task.wait(0.5) startLoop(newCharacter) end
    end)
end

-- =========================================================
-- HALAMAN UTAMA & FITUR-FITUR
-- =========================================================
local HomePage = CreateTab("Home")

-- Fitur Tambahan 1: Instant Interact di Tab Home
CreateToggle(HomePage, "Instant Interact", function(state)
    isInstantActive = state
    if isInstantActive then
        for _, prompt in pairs(game.Workspace:GetDescendants()) do makeInstant(prompt) end
        promptConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            if isInstantActive then makeInstant(prompt) end
        end)
    else
        if promptConnection then promptConnection:Disconnect() end
        for _, prompt in pairs(game.Workspace:GetDescendants()) do resetToNormal(prompt) end
    end
end)

-- Garis Pembatas (Sederhana)
local Line = Instance.new("Frame", HomePage)
Line.Size, Line.BackgroundColor3, Line.BorderSizePixel = UDim2.new(1, -10, 0, 2), Color3.fromRGB(40, 40, 40), 0

-- Fitur Tambahan 2: Piggyback FE di Tab Home
local PiggyTitle = Instance.new("TextLabel", HomePage)
PiggyTitle.Size, PiggyTitle.BackgroundTransparency, PiggyTitle.Text, PiggyTitle.TextColor3, PiggyTitle.Font, PiggyTitle.TextSize, PiggyTitle.TextXAlignment = UDim2.new(1, 0, 0, 20), 1, "KAY PIGGYBACK FE SYSTEM", Color3.fromRGB(200, 200, 200), Enum.Font.SourceSansBold, 13, Enum.TextXAlignment.Left

-- TextBox Input Nama Player
local PBTextBox = Instance.new("TextBox", HomePage)
PBTextBox.Size, PBTextBox.BackgroundColor3, PBTextBox.TextColor3, PBTextBox.PlaceholderText, PBTextBox.Text, PBTextBox.TextSize, PBTextBox.Font = UDim2.new(1, -10, 0, 30), Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255), "Nama Player (Case Sensitive)", "", 13, Enum.Font.SourceSans
Instance.new("UICorner", PBTextBox).CornerRadius = UDim.new(0, 6)

-- Container Tombol Tempel & Lepas
local PBActionFrame = Instance.new("Frame", HomePage)
PBActionFrame.Size, PBActionFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 35), 1
Instance.new("UIListLayout", PBActionFrame).FillDirection, Instance.new("UIListLayout", PBActionFrame).Padding = Enum.FillDirection.Horizontal, UDim.new(0, 10)

local AttachBtn = Instance.new("TextButton", PBActionFrame)
AttachBtn.Size, AttachBtn.BackgroundColor3, AttachBtn.Text, AttachBtn.TextColor3, AttachBtn.Font, AttachBtn.TextSize = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(0, 150, 80), "TEMPEL", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
Instance.new("UICorner", AttachBtn).CornerRadius = UDim.new(0, 6)

local DetachBtn = Instance.new("TextButton", PBActionFrame)
DetachBtn.Size, DetachBtn.BackgroundColor3, DetachBtn.Text, DetachBtn.TextColor3, DetachBtn.Font, DetachBtn.TextSize = UDim2.new(0.48, 0, 1, 0), Color3.fromRGB(180, 40, 40), "LEPAS", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
Instance.new("UICorner", DetachBtn).CornerRadius = UDim.new(0, 6)

AttachBtn.MouseButton1Click:Connect(function()
    targetName = PBTextBox.Text
    attachToPlayer()
end)
DetachBtn.MouseButton1Click:Connect(detach)

-- Container Tombol Navigasi Posisi Piggyback + Sinkronisasi Instan
local NavFrame = Instance.new("Frame", HomePage)
NavFrame.Size, NavFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 65), 1
local NavGrid = Instance.new("UIGridLayout", NavFrame)
NavGrid.CellSize, NavGrid.CellPadding = UDim2.new(0.23, 0, 0, 28), UDim2.new(0.02, 0, 0.1, 0)

local function createNav(txt, cb)
    local b = Instance.new("TextButton", NavFrame)
    b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = Color3.fromRGB(40, 40, 45), txt, Color3.fromRGB(220, 220, 220), Enum.Font.SourceSansBold, 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        cb()
        forceUpdatePosition() -- Memaksa posisi langsung update saat tombol ditekan
    end)
end
createNav("NAIK", function() posY = posY + 0.2 end)
createNav("TURUN", function() posY = posY - 0.2 end)
createNav("DEPAN", function() posZ = posZ - 0.2 end)
createNav("BELAKANG", function() posZ = posZ + 0.2 end)
createNav("KIRI", function() posX = posX - 0.2 end)
createNav("KANAN", function() posX = posX + 0.2 end)
createNav("PUTAR", function() rotY = (rotY + 90) % 360 end)

-- =========================================================
-- TAB FEATURES & LOOPS LOGIKA
-- =========================================================
local MainFeaturesPage = CreateTab("Features")
local SpeedValue, SpeedEnabled, InfiniteJumpEnabled, Flying, FlySpeed, AirWalkEnabled, AirWalkPlatform, NoclipEnabled = 16, false, false, false, 60, false, nil, false

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

-- Loops Logika Fitur (Speed Walk & Noclip)
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
CreateToggle(MainFeaturesPage, "Noclip V8", function(state) NoclipEnabled = state end)

-- UPDATE LOGIKA AIR WALK (STABLE & ANTI LAG)
local AirWalkConnection
CreateToggle(MainFeaturesPage, "Air Walk V8", function(state)
    AirWalkEnabled = state
    if AirWalkConnection then AirWalkConnection:Disconnect() end
    if AirWalkPlatform then AirWalkPlatform:Destroy() AirWalkPlatform = nil end
    
    if AirWalkEnabled then
        AirWalkPlatform = Instance.new("Part")
        AirWalkPlatform.Size = Vector3.new(15, 0.5, 15)
        AirWalkPlatform.Transparency = 1
        AirWalkPlatform.Anchored = true
        AirWalkPlatform.CanCollide = true
        AirWalkPlatform.Parent = workspace
        
        AirWalkConnection = RS.Heartbeat:Connect(function()
            local Char = LocalPlayer.Character
            local Root = Char and Char:FindFirstChild("HumanoidRootPart")
            if AirWalkEnabled and Root and AirWalkPlatform then
                AirWalkPlatform.CFrame = CFrame.new(Root.Position.X, Root.Position.Y - 3.1, Root.Position.Z)
            else
                if AirWalkConnection then AirWalkConnection:Disconnect() end
                if AirWalkPlatform then AirWalkPlatform:Destroy() AirWalkPlatform = nil end
            end
        end)
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

print("[SYSTEM] Kay Hub Pro V8 Slim Berhasil Dimuat dengan Modifikasi Anti-Delay.")
