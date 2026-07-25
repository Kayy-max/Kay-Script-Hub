-- [[ KAY HUB PRO V9.3 - SERVER BROWSER & FRIEND TRACKER INTEGRATED ]] --
local Players, TS, RS, UIS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- LOGIKA AUTO TELEPORT & AUTO VERIFY SETELAH REJOIN
task.spawn(function()
    pcall(function()
        if getgenv then
            if getgenv().KayHub_AutoVerified then
                getgenv().KayHub_Verified = true
            end

            if getgenv().KayHub_SavedPos then
                local pos = getgenv().KayHub_SavedPos
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart", 10)
                if hrp and pos then
                    task.wait(1.5)
                    hrp.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
                    getgenv().KayHub_SavedPos = nil
                end
            end
        end
    end)
end)

-- DAFTAR PRESET TEMA LENGKAP
local Themes = {
    ["Sleek Dark"] = {
        BGColor = Color3.fromRGB(15, 15, 15),
        SidebarColor = Color3.fromRGB(22, 22, 22),
        FrameColor = Color3.fromRGB(25, 25, 25),
        StrokeColor = Color3.fromRGB(40, 40, 40),
        AccentColor = Color3.fromRGB(0, 230, 130),
        TextColor = Color3.fromRGB(240, 240, 240),
        MutedText = Color3.fromRGB(140, 140, 140)
    },
    ["Cyber Neon"] = {
        BGColor = Color3.fromRGB(10, 8, 15),
        SidebarColor = Color3.fromRGB(16, 12, 24),
        FrameColor = Color3.fromRGB(22, 18, 32),
        StrokeColor = Color3.fromRGB(55, 30, 80),
        AccentColor = Color3.fromRGB(255, 0, 127),
        TextColor = Color3.fromRGB(250, 240, 255),
        MutedText = Color3.fromRGB(150, 130, 170)
    },
    ["Ruby Premium"] = {
        BGColor = Color3.fromRGB(16, 10, 10),
        SidebarColor = Color3.fromRGB(24, 14, 14),
        FrameColor = Color3.fromRGB(32, 18, 18),
        StrokeColor = Color3.fromRGB(65, 30, 30),
        AccentColor = Color3.fromRGB(230, 30, 30),
        TextColor = Color3.fromRGB(255, 240, 240),
        MutedText = Color3.fromRGB(170, 130, 130)
    },
    ["Light Elegant"] = {
        BGColor = Color3.fromRGB(240, 240, 245),
        SidebarColor = Color3.fromRGB(225, 225, 230),
        FrameColor = Color3.fromRGB(255, 255, 255),
        StrokeColor = Color3.fromRGB(200, 200, 205),
        AccentColor = Color3.fromRGB(0, 120, 255),
        TextColor = Color3.fromRGB(30, 30, 30),
        MutedText = Color3.fromRGB(120, 120, 130)
    }
}

local CurrentTheme = Themes["Sleek Dark"]
local ActiveToggles, Tabs = {}, {}
local AllUIElements = {} 
local ScriptRunning = true 

if game:GetService("CoreGui"):FindFirstChild("KayHub_Main") then
    game:GetService("CoreGui").KayHub_Main:Destroy()
end

local KayHub = Instance.new("ScreenGui")
KayHub.Name = "KayHub_Main"
KayHub.ResetOnSpawn = false

pcall(function() 
    if gethui then
        KayHub.Parent = gethui()
    else
        KayHub.Parent = game:GetService("CoreGui")
    end
end)
if not KayHub.Parent then KayHub.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function MakeDraggable(guiFrame)
    guiFrame.Active = true
    guiFrame.Selectable = true
    
    local dragging = false
    local dragInput, dragStart, startPos

    guiFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiFrame.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end)

    guiFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size, MainFrame.Position, MainFrame.Active, MainFrame.Selectable, MainFrame.ClipsDescendants, MainFrame.Parent = UDim2.new(0, 450, 0, 320), UDim2.new(0.3, 0, 0.25, 0), true, true, true, KayHub
MainFrame.Visible = false 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1

table.insert(AllUIElements, {Obj = MainFrame, Prop = "BackgroundColor3", Key = "BGColor"})
table.insert(AllUIElements, {Obj = MainStroke, Prop = "Color", Key = "StrokeColor"})

MakeDraggable(MainFrame)

-- SYSTEM VERIFIKASI
local CorrectPassword = "kay602122"
local WrongAttempts = 0
local MaxAttempts = 3

local AuthFrame = Instance.new("Frame")
AuthFrame.Size, AuthFrame.Position, AuthFrame.Active, AuthFrame.Selectable, AuthFrame.Parent = UDim2.new(0, 320, 0, 180), UDim2.new(0.4, 0, 0.35, 0), true, true, KayHub
AuthFrame.Visible = true
Instance.new("UICorner", AuthFrame).CornerRadius = UDim.new(0, 12)
local AuthStroke = Instance.new("UIStroke", AuthFrame)
AuthStroke.Thickness = 1

table.insert(AllUIElements, {Obj = AuthFrame, Prop = "BackgroundColor3", Key = "BGColor"})
table.insert(AllUIElements, {Obj = AuthStroke, Prop = "Color", Key = "StrokeColor"})
MakeDraggable(AuthFrame)

local AuthTitle = Instance.new("TextLabel", AuthFrame)
AuthTitle.Size, AuthTitle.BackgroundTransparency, AuthTitle.Text, AuthTitle.Font, AuthTitle.TextSize = UDim2.new(1, 0, 0, 45), 1, "KAY HUB - VERIFICATION", Enum.Font.GothamBold, 14
table.insert(AllUIElements, {Obj = AuthTitle, Prop = "TextColor3", Key = "AccentColor"})

local PasswordInput = Instance.new("TextBox", AuthFrame)
PasswordInput.Size, PasswordInput.Position, PasswordInput.PlaceholderText, PasswordInput.Text, PasswordInput.Font, PasswordInput.TextSize, PasswordInput.ClearTextOnFocus = UDim2.new(0.85, 0, 0, 35), UDim2.new(0.075, 0, 0, 55), "Masukkan Password...", "", Enum.Font.Gotham, 12, false
Instance.new("UICorner", PasswordInput).CornerRadius = UDim.new(0, 6)
local PwdStroke = Instance.new("UIStroke", PasswordInput)
table.insert(AllUIElements, {Obj = PasswordInput, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = PasswordInput, Prop = "TextColor3", Key = "TextColor"})
table.insert(AllUIElements, {Obj = PwdStroke, Prop = "Color", Key = "StrokeColor"})

local InfoLabel = Instance.new("TextLabel", AuthFrame)
InfoLabel.Size, InfoLabel.Position, InfoLabel.BackgroundTransparency, InfoLabel.Text, InfoLabel.Font, InfoLabel.TextSize = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 95), 1, "Sisa percobaan: " .. (MaxAttempts - WrongAttempts), Enum.Font.Gotham, 11
table.insert(AllUIElements, {Obj = InfoLabel, Prop = "TextColor3", Key = "MutedText"})

local VerifyBtn = Instance.new("TextButton", AuthFrame)
VerifyBtn.Size, VerifyBtn.Position, VerifyBtn.Text, VerifyBtn.Font, VerifyBtn.TextSize, VerifyBtn.TextColor3 = UDim2.new(0.85, 0, 0, 35), UDim2.new(0.075, 0, 0, 125), "VERIFIKASI", Enum.Font.GothamBold, 12, Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = VerifyBtn, Prop = "BackgroundColor3", Key = "AccentColor"})

local function UnlockHub()
    pcall(function()
        if getgenv then getgenv().KayHub_Verified = true end
    end)
    if AuthFrame and AuthFrame.Parent then
        AuthFrame.Visible = false
        AuthFrame:Destroy()
    end
    MainFrame.Visible = true
end

VerifyBtn.MouseButton1Click:Connect(function()
    if PasswordInput.Text == CorrectPassword then
        InfoLabel.Text = "Akses Diterima! Memuat script..."
        InfoLabel.TextColor3 = Color3.fromRGB(0, 230, 130)
        task.wait(0.3)
        UnlockHub()
    else
        WrongAttempts = WrongAttempts + 1
        InfoLabel.Text = "Password Salah! Sisa percobaan: " .. (MaxAttempts - WrongAttempts)
        InfoLabel.TextColor3 = Color3.fromRGB(240, 50, 50)
        PasswordInput.Text = ""
        
        if WrongAttempts >= MaxAttempts then
            InfoLabel.Text = "Terlalu banyak kesalahan. Menutup..."
            task.wait(1.5)
            KayHub:Destroy()
            ScriptRunning = false
        end
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size, Sidebar.Parent = UDim2.new(0, 120, 1, 0), MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
table.insert(AllUIElements, {Obj = Sidebar, Prop = "BackgroundColor3", Key = "SidebarColor"})

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size, LogoLabel.BackgroundTransparency, LogoLabel.Text, LogoLabel.Font, LogoLabel.TextSize, LogoLabel.Parent = UDim2.new(1, 0, 0, 40), 1, "KAY HUB V9.3", Enum.Font.GothamBold, 13, Sidebar
table.insert(AllUIElements, {Obj = LogoLabel, Prop = "TextColor3", Key = "AccentColor"})

local SidebarContainer = Instance.new("ScrollingFrame", Sidebar)
SidebarContainer.Size, SidebarContainer.Position, SidebarContainer.BackgroundTransparency, SidebarContainer.BorderSizePixel, SidebarContainer.ScrollBarThickness, SidebarContainer.AutomaticCanvasSize = UDim2.new(1, 0, 1, -40), UDim2.new(0, 0, 0, 40), 1, 0, 0, Enum.AutomaticSize.Y
local SidebarList = Instance.new("UIListLayout", SidebarContainer)
SidebarList.SortOrder, SidebarList.Padding, SidebarList.HorizontalAlignment = Enum.SortOrder.LayoutOrder, UDim.new(0, 4), Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame")
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency, ContentContainer.Parent = UDim2.new(1, -135, 1, -55), UDim2.new(0, 125, 0, 45), 1, MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size, TopBar.Position, TopBar.BackgroundTransparency, TopBar.Parent = UDim2.new(1, -120, 0, 45), UDim2.new(0, 120, 0, 0), 1, MainFrame

local CurrentTabTitle = Instance.new("TextLabel")
CurrentTabTitle.Size, CurrentTabTitle.Position, CurrentTabTitle.BackgroundTransparency, CurrentTabTitle.Text, CurrentTabTitle.Font, CurrentTabTitle.TextSize, CurrentTabTitle.TextXAlignment, CurrentTabTitle.Parent = UDim2.new(0.35, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1, "Home", Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, TopBar
table.insert(AllUIElements, {Obj = CurrentTabTitle, Prop = "TextColor3", Key = "TextColor"})

local PlayerCountTopBar = Instance.new("TextLabel")
PlayerCountTopBar.Size, PlayerCountTopBar.Position, PlayerCountTopBar.BackgroundTransparency, PlayerCountTopBar.Text, PlayerCountTopBar.Font, PlayerCountTopBar.TextSize, PlayerCountTopBar.TextXAlignment, PlayerCountTopBar.Parent = UDim2.new(0.4, 0, 1, 0), UDim2.new(0.32, 0, 0, 0), 1, "👥 0/0", Enum.Font.Gotham, 11, Enum.TextXAlignment.Right, TopBar
table.insert(AllUIElements, {Obj = PlayerCountTopBar, Prop = "TextColor3", Key = "MutedText"})

local function updatePlayerCount()
    local currentPlayers = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers
    PlayerCountTopBar.Text = string.format("👥 %d/%d Players", currentPlayers, maxPlayers)
end
Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)
updatePlayerCount()

local MinButton = Instance.new("TextButton")
MinButton.Size, MinButton.Position, MinButton.BackgroundTransparency, MinButton.Text, MinButton.Font, MinButton.TextSize, MinButton.Parent = UDim2.new(0, 30, 0, 30), UDim2.new(1, -65, 0, 7), 1, "—", Enum.Font.GothamBold, 12, TopBar
table.insert(AllUIElements, {Obj = MinButton, Prop = "TextColor3", Key = "MutedText"})

local CloseButton = Instance.new("TextButton")
CloseButton.Size, CloseButton.Position, CloseButton.BackgroundTransparency, CloseButton.Text, CloseButton.Font, CloseButton.TextSize, CloseButton.TextColor3, CloseButton.Parent = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 7), 1, "✕", Enum.Font.GothamBold, 14, Color3.fromRGB(240, 50, 50), TopBar

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 15, 0, 120)
ToggleButton.Image = "rbxassetid://102532136962074"
ToggleButton.BackgroundTransparency = 1
ToggleButton.BorderSizePixel = 0
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Visible = false
ToggleButton.Parent = KayHub
MakeDraggable(ToggleButton)

local isMinimized = false
local function toggleMenu()
    if not ScriptRunning then return end
    isMinimized = not isMinimized
    TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 450, 0, 0) or UDim2.new(0, 450, 0, 320)}):Play()
    if isMinimized then task.wait(0.2) end
    MainFrame.Visible = not isMinimized
    ToggleButton.Visible = isMinimized
end
MinButton.MouseButton1Click:Connect(toggleMenu)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Size, ConfirmOverlay.Position, ConfirmOverlay.BackgroundTransparency, ConfirmOverlay.Visible, ConfirmOverlay.ZIndex, ConfirmOverlay.Parent = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), 0.4, false, 10, MainFrame
table.insert(AllUIElements, {Obj = ConfirmOverlay, Prop = "BackgroundColor3", Key = "BGColor"})

local ConfirmBox = Instance.new("Frame", ConfirmOverlay)
ConfirmBox.Size, ConfirmBox.Position, ConfirmBox.ZIndex = UDim2.new(0, 260, 0, 130), UDim2.new(0.5, -130, 0.5, -65), 11
Instance.new("UICorner", ConfirmBox).CornerRadius = UDim.new(0, 10)
local ConfirmStroke = Instance.new("UIStroke", ConfirmBox)
table.insert(AllUIElements, {Obj = ConfirmBox, Prop = "BackgroundColor3", Key = "SidebarColor"})
table.insert(AllUIElements, {Obj = ConfirmStroke, Prop = "Color", Key = "StrokeColor"})

local ConfirmTitle = Instance.new("TextLabel", ConfirmBox)
ConfirmTitle.Size, ConfirmTitle.Position, ConfirmTitle.BackgroundTransparency, ConfirmTitle.Text, ConfirmTitle.Font, ConfirmTitle.TextSize, ConfirmTitle.ZIndex = UDim2.new(1, 0, 0, 55), UDim2.new(0, 0, 0, 5), 1, "Apakah kamu yakin ingin\nmenutup script ini?", Enum.Font.GothamBold, 12, 12
table.insert(AllUIElements, {Obj = ConfirmTitle, Prop = "TextColor3", Key = "TextColor"})

local YesButton = Instance.new("TextButton", ConfirmBox)
YesButton.Size, YesButton.Position, YesButton.Text, YesButton.Font, YesButton.TextSize, YesButton.TextColor3, YesButton.ZIndex = UDim2.new(0, 105, 0, 32), UDim2.new(0, 18, 0, 75), "YA", Enum.Font.GothamBold, 12, Color3.fromRGB(255, 255, 255), 12
YesButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 6)

local NoButton = Instance.new("TextButton", ConfirmBox)
NoButton.Size, NoButton.Position, NoButton.Text, NoButton.Font, NoButton.TextSize, NoButton.TextColor3, NoButton.ZIndex = UDim2.new(0, 105, 0, 32), UDim2.new(1, -123, 0, 75), "TIDAK", Enum.Font.GothamBold, 12, Color3.fromRGB(255, 255, 255), 12
Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = NoButton, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = NoButton, Prop = "TextColor3", Key = "MutedText"})

local function ApplyTheme(themeName)
    CurrentTheme = Themes[themeName]
    for _, item in pairs(AllUIElements) do
        local targetColor = CurrentTheme[item.Key]
        if item.Obj and item.Obj.Parent then
            pcall(function()
                TS:Create(item.Obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[item.Prop] = targetColor}):Play()
            end)
        end
    end
    for _, tab in pairs(Tabs) do
        tab.Btn.TextColor3 = tab.Page.Visible and CurrentTheme.AccentColor or CurrentTheme.MutedText
    end
end

local FirstTab = true
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame")
    Page.Size, Page.BackgroundTransparency, Page.BorderSizePixel, Page.ScrollBarThickness, Page.AutomaticCanvasSize, Page.Visible, Page.Parent = UDim2.new(1, 0, 1, 0), 1, 0, 2, Enum.AutomaticSize.Y, false, ContentContainer
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding, PageList.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center
    
    local TabButton = Instance.new("TextButton", SidebarContainer)
    TabButton.Size, TabButton.BackgroundTransparency, TabButton.Text, TabButton.Font, TabButton.TextSize = UDim2.new(0.9, 0, 0, 28), 1, tabName, Enum.Font.GothamBold, 11
    
    table.insert(AllUIElements, {Obj = TabButton, Prop = "TextColor3", Key = FirstTab and "AccentColor" or "MutedText"})
    if FirstTab then Page.Visible, CurrentTabTitle.Text, FirstTab = true, tabName, false end
    
    TabButton.MouseButton1Click:Connect(function()
        if ConfirmOverlay.Visible then return end
        for _, t in pairs(Tabs) do 
            t.Page.Visible = false 
            t.Btn.TextColor3 = CurrentTheme.MutedText
        end
        Page.Visible = true
        TabButton.TextColor3 = CurrentTheme.AccentColor
        CurrentTabTitle.Text = tabName
    end)
    table.insert(Tabs, {Page = Page, Btn = TabButton, Name = tabName})
    return Page
end

local function CreateToggle(parent, text, callback)
    local Enabled = false
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    table.insert(AllUIElements, {Obj = Frame, Prop = "BackgroundColor3", Key = "FrameColor"})
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size, Label.Position, Label.BackgroundTransparency, Label.Text, Label.Font, Label.TextSize, Label.TextXAlignment = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1, text, Enum.Font.Gotham, 13, Enum.TextXAlignment.Left
    table.insert(AllUIElements, {Obj = Label, Prop = "TextColor3", Key = "TextColor"})
    
    local Switch = Instance.new("TextButton", Frame)
    Switch.Size, Switch.Position, Switch.Text, Switch.Font, Switch.TextSize = UDim2.new(0, 45, 0, 20), UDim2.new(1, -55, 0, 7.5), "OFF", Enum.Font.GothamBold, 10
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 10)

    table.insert(AllUIElements, {Obj = Switch, Prop = "BackgroundColor3", Key = "StrokeColor"})
    table.insert(AllUIElements, {Obj = Switch, Prop = "TextColor3", Key = "MutedText"})

    local data = {Instance = Switch, IsEnabled = false}
    table.insert(ActiveToggles, data)

    Switch.MouseButton1Click:Connect(function()
        if not ScriptRunning or ConfirmOverlay.Visible then return end
        Enabled = not Enabled
        data.IsEnabled = Enabled
        Switch.Text = Enabled and "ON" or "OFF"
        
        local targetBG = Enabled and CurrentTheme.AccentColor or CurrentTheme.StrokeColor
        local targetText = Enabled and Color3.fromRGB(15,15,15) or CurrentTheme.MutedText
        TS:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetBG, TextColor3 = targetText}):Play()
        
        callback(Enabled)
    end)
    return Frame
end

-- TAB 1: HOME PAGE
local HomePage = CreateTab("Home")
local targetPlayerName = nil 
local posX, posY, posZ, rotY = 0, 1.5, 0.8, 0
local isAttached, autoEmoteEnabled = false, true
local attachmentConnection, currentEmoteTrack
local targetCharAddedConnection = nil

local function removeWelds()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("Weld") or part:IsA("WeldConstraint") or part:IsA("AlignPosition") then pcall(function() part:Destroy() end) end
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
        
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        
        attachmentConnection = RS.Heartbeat:Connect(function()
            if not isAttached or not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("HumanoidRootPart") then
                if attachmentConnection then attachmentConnection:Disconnect() end
                return
            end
            
            local offset = targetHRP.CFrame * CFrame.new(posX, posY, posZ) * CFrame.Angles(0, math.rad(rotY), 0)
            
            pcall(function()
                sethiddenproperty(myHRP, "PhysicsRepRootPart", targetHRP)
                sethiddenproperty(LocalPlayer, "SimulationRadius", 1000)
            end)
            
            myHRP.CFrame = offset
            myHRP.Velocity = Vector3.new()
            myHRP.AssemblyLinearVelocity = Vector3.new()
            myHRP.AssemblyAngularVelocity = Vector3.new()
            myHRP.RotVelocity = Vector3.new()
        end)
    end
end

local function checkAndAttach()
    if not isAttached or not targetPlayerName then return end
    
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
        removeWelds()
        startLoop(targetPlayer.Character)
        
        if autoEmoteEnabled then
            local char = LocalPlayer.Character
            if currentEmoteTrack then currentEmoteTrack:Stop() end
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://107480602323379"
            pcall(function()
                currentEmoteTrack = char:WaitForChild("Humanoid"):LoadAnimation(anim)
                currentEmoteTrack:Play()
            end)
        end
    end
end

local function runAttachLogic()
    local selectedPlayer = Players:FindFirstChild(targetPlayerName or "")
    if not selectedPlayer or ConfirmOverlay.Visible then return end
    
    isAttached = true
    if targetCharAddedConnection then targetCharAddedConnection:Disconnect() end
    
    targetCharAddedConnection = selectedPlayer.CharacterAdded:Connect(function()
        if isAttached then task.wait(0.5) checkAndAttach() end
    end)
    
    checkAndAttach()
end

local function detach()
    isAttached = false
    targetPlayerName = nil
    if attachmentConnection then attachmentConnection:Disconnect() end
    if targetCharAddedConnection then targetCharAddedConnection:Disconnect() end
    
    local myChar = LocalPlayer.Character
    if myChar then
        local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHumanoid then myHumanoid.PlatformStand = false end
        if myHRP then 
            pcall(function() sethiddenproperty(myHRP, "PhysicsRepRootPart", nil) end)
            myHRP.Velocity = Vector3.new(0, 0, 0) 
            myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myHRP.RotVelocity = Vector3.new(0, 0, 0)
        end
        for _, part in pairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    if currentEmoteTrack then currentEmoteTrack:Stop() end
end

-- TAB 2: ANIMATIONS PAGE
local AnimPage = CreateTab("Animations")

-- TAB 3: FUN / UTILITIES PAGE
local FunPage = CreateTab("Fun")

-- TAB 4: ESP PAGE
local EspPage = CreateTab("ESP")

-- =========================================================
-- TAB 5: SERVER PAGE (SERVER BROWSER + FRIEND TRACKER)
-- =========================================================
local ServerPage = CreateTab("Server")

local ServerInfoBox = Instance.new("Frame", ServerPage)
ServerInfoBox.Size = UDim2.new(1, -10, 0, 45)
Instance.new("UICorner", ServerInfoBox).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = ServerInfoBox, Prop = "BackgroundColor3", Key = "FrameColor"})

local ServerInfoLabel = Instance.new("TextLabel", ServerInfoBox)
ServerInfoLabel.Size, ServerInfoLabel.Position, ServerInfoLabel.BackgroundTransparency, ServerInfoLabel.Font, ServerInfoLabel.TextSize = UDim2.new(1, -10, 1, 0), UDim2.new(0, 10, 0, 0), 1, Enum.Font.Gotham, 11
ServerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
table.insert(AllUIElements, {Obj = ServerInfoLabel, Prop = "TextColor3", Key = "TextColor"})

local function refreshServerTabInfo()
    local currentCount = #Players:GetPlayers()
    local maxCount = Players.MaxPlayers
    ServerInfoLabel.Text = string.format("📊 Status Server Saat Ini:\n• Total Player: %d / %d | JobID: %s...", currentCount, maxCount, string.sub(game.JobId, 1, 8))
end
Players.PlayerAdded:Connect(refreshServerTabInfo)
Players.PlayerRemoving:Connect(refreshServerTabInfo)
refreshServerTabInfo()

local RejoinBtnContainer = Instance.new("Frame", ServerPage)
RejoinBtnContainer.Size, RejoinBtnContainer.BackgroundTransparency = UDim2.new(1, -10, 0, 32), 1
local RJLayout = Instance.new("UIListLayout", RejoinBtnContainer)
RJLayout.FillDirection, RJLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)

local function createRejoinBtn(txt, color, cb)
    local b = Instance.new("TextButton", RejoinBtnContainer)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.49, 0, 1, 0), color, txt, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() if ConfirmOverlay.Visible then return end cb() end)
end

local function setRejoinBypassQueue(posVector)
    local queueCode = "getgenv().KayHub_AutoVerified = true\n"
    if posVector then
        queueCode = queueCode .. string.format("getgenv().KayHub_SavedPos = Vector3.new(%f, %f, %f)\n", posVector.X, posVector.Y, posVector.Z)
    end
    pcall(function()
        if queue_on_teleport then
            queue_on_teleport(queueCode)
        elseif syn and syn.queue_on_teleport then
            syn.queue_on_teleport(queueCode)
        end
    end)
end

createRejoinBtn("🔄 Rejoin Biasa", Color3.fromRGB(40, 40, 50), function()
    setRejoinBypassQueue(nil)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createRejoinBtn("📍 Rejoin + Auto TP", Color3.fromRGB(0, 160, 100), function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    setRejoinBypassQueue(hrp and hrp.Position or nil)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

local SrvDivider = Instance.new("Frame", ServerPage)
SrvDivider.Size, SrvDivider.BorderSizePixel = UDim2.new(1, -10, 0, 1), 0
table.insert(AllUIElements, {Obj = SrvDivider, Prop = "BackgroundColor3", Key = "StrokeColor"})

-- FILTER MODE (SERVER SEPI / RAMAI / FRIENDS)
local FilterFrame = Instance.new("Frame", ServerPage)
FilterFrame.Size, FilterFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 28), 1
local FilterLayout = Instance.new("UIListLayout", FilterFrame)
FilterLayout.FillDirection, FilterLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 4)

local currentSortMode = "Ascending" -- Ascending = Sepi ke Ramai, Descending = Ramai ke Sepi
local isFriendMode = false

local BtnSepi = Instance.new("TextButton", FilterFrame)
BtnSepi.Size, BtnSepi.Text, BtnSepi.Font, BtnSepi.TextSize = UDim2.new(0.32, 0, 1, 0), "📉 Sepi", Enum.Font.GothamBold, 10
Instance.new("UICorner", BtnSepi).CornerRadius = UDim.new(0, 6)

local BtnRamai = Instance.new("TextButton", FilterFrame)
BtnRamai.Size, BtnRamai.Text, BtnRamai.Font, BtnRamai.TextSize = UDim2.new(0.32, 0, 1, 0), "📈 Ramai", Enum.Font.GothamBold, 10
Instance.new("UICorner", BtnRamai).CornerRadius = UDim.new(0, 6)

local BtnTeman = Instance.new("TextButton", FilterFrame)
BtnTeman.Size, BtnTeman.Text, BtnTeman.Font, BtnTeman.TextSize = UDim2.new(0.32, 0, 1, 0), "👥 Teman", Enum.Font.GothamBold, 10
Instance.new("UICorner", BtnTeman).CornerRadius = UDim.new(0, 6)

table.insert(AllUIElements, {Obj = BtnSepi, Prop = "BackgroundColor3", Key = "AccentColor"})
table.insert(AllUIElements, {Obj = BtnSepi, Prop = "TextColor3", Key = "BGColor"})

table.insert(AllUIElements, {Obj = BtnRamai, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = BtnRamai, Prop = "TextColor3", Key = "MutedText"})

table.insert(AllUIElements, {Obj = BtnTeman, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = BtnTeman, Prop = "TextColor3", Key = "MutedText"})

-- SERVER CONTAINER (SCROLLING LIST)
local ServerListContainer = Instance.new("ScrollingFrame", ServerPage)
ServerListContainer.Size, ServerListContainer.BorderSizePixel, ServerListContainer.ScrollBarThickness = UDim2.new(1, -10, 0, 130), 0, 2
Instance.new("UICorner", ServerListContainer).CornerRadius = UDim.new(0, 6)
local ServerListLayout = Instance.new("UIListLayout", ServerListContainer)
ServerListLayout.Padding = UDim.new(0, 4)
table.insert(AllUIElements, {Obj = ServerListContainer, Prop = "BackgroundColor3", Key = "SidebarColor"})

local StatusFetchLabel = Instance.new("TextLabel", ServerListContainer)
StatusFetchLabel.Size, StatusFetchLabel.BackgroundTransparency, StatusFetchLabel.Text, StatusFetchLabel.Font, StatusFetchLabel.TextSize = UDim2.new(1, 0, 1, 0), 1, "Tekan 'Muat Ulang Server'...", Enum.Font.Gotham, 11
table.insert(AllUIElements, {Obj = StatusFetchLabel, Prop = "TextColor3", Key = "MutedText"})

local function updateFilterStyle()
    BtnSepi.BackgroundColor3 = (not isFriendMode and currentSortMode == "Ascending") and CurrentTheme.AccentColor or CurrentTheme.FrameColor
    BtnSepi.TextColor3 = (not isFriendMode and currentSortMode == "Ascending") and Color3.fromRGB(15,15,15) or CurrentTheme.MutedText

    BtnRamai.BackgroundColor3 = (not isFriendMode and currentSortMode == "Descending") and CurrentTheme.AccentColor or CurrentTheme.FrameColor
    BtnRamai.TextColor3 = (not isFriendMode and currentSortMode == "Descending") and Color3.fromRGB(15,15,15) or CurrentTheme.MutedText

    BtnTeman.BackgroundColor3 = isFriendMode and CurrentTheme.AccentColor or CurrentTheme.FrameColor
    BtnTeman.TextColor3 = isFriendMode and Color3.fromRGB(15,15,15) or CurrentTheme.MutedText
end

-- LOGIKA BROWSER PUBLIC SERVER VIA HTTP API
local function FetchPublicServers()
    for _, child in pairs(ServerListContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end

    local loader = Instance.new("TextLabel", ServerListContainer)
    loader.Size, loader.BackgroundTransparency, loader.Text, loader.Font, loader.TextSize = UDim2.new(1, 0, 1, 0), 1, "🔍 Mencari server...", Enum.Font.Gotham, 11
    table.insert(AllUIElements, {Obj = loader, Prop = "TextColor3", Key = "AccentColor"})

    task.spawn(function()
        local success, result = pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100", tostring(game.PlaceId), currentSortMode)
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        loader:Destroy()

        if success and result and result.data then
            local validCount = 0
            for _, srv in pairs(result.data) do
                if type(srv) == "table" and srv.id and srv.id ~= game.JobId and srv.playing and srv.maxPlayers then
                    validCount = validCount + 1
                    
                    local ItemFrame = Instance.new("Frame", ServerListContainer)
                    ItemFrame.Size = UDim2.new(1, -6, 0, 32)
                    Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 4)
                    table.insert(AllUIElements, {Obj = ItemFrame, Prop = "BackgroundColor3", Key = "FrameColor"})

                    local Info = Instance.new("TextLabel", ItemFrame)
                    Info.Size, Info.Position, Info.BackgroundTransparency, Info.Font, Info.TextSize, Info.TextXAlignment = UDim2.new(0.65, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, Enum.Font.Gotham, 10, Enum.TextXAlignment.Left
                    Info.Text = string.format("👥 %d/%d Players | Ping: %dms", srv.playing, srv.maxPlayers, srv.ping or 0)
                    table.insert(AllUIElements, {Obj = Info, Prop = "TextColor3", Key = "TextColor"})

                    local JoinBtn = Instance.new("TextButton", ItemFrame)
                    JoinBtn.Size, JoinBtn.Position, JoinBtn.Text, JoinBtn.Font, JoinBtn.TextSize = UDim2.new(0, 65, 0, 22), UDim2.new(1, -70, 0, 5), "JOIN", Enum.Font.GothamBold, 10
                    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 4)
                    table.insert(AllUIElements, {Obj = JoinBtn, Prop = "BackgroundColor3", Key = "AccentColor"})
                    JoinBtn.TextColor3 = Color3.fromRGB(15, 15, 15)

                    JoinBtn.MouseButton1Click:Connect(function()
                        if ConfirmOverlay.Visible then return end
                        setRejoinBypassQueue(nil)
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    end)
                end
            end

            if validCount == 0 then
                local emptyLbl = Instance.new("TextLabel", ServerListContainer)
                emptyLbl.Size, emptyLbl.BackgroundTransparency, emptyLbl.Text, emptyLbl.Font, emptyLbl.TextSize = UDim2.new(1, 0, 1, 0), 1, "Tidak ada server lain ditemukan.", Enum.Font.Gotham, 11
                table.insert(AllUIElements, {Obj = emptyLbl, Prop = "TextColor3", Key = "MutedText"})
            end
        else
            local errLbl = Instance.new("TextLabel", ServerListContainer)
            errLbl.Size, errLbl.BackgroundTransparency, errLbl.Text, errLbl.Font, errLbl.TextSize = UDim2.new(1, 0, 1, 0), 1, "⚠️ Gagal mengambil daftar server.", Enum.Font.Gotham, 11
            errLbl.TextColor3 = Color3.fromRGB(240, 50, 50)
        end
    end)
end

-- LOGIKA LACAK TEMAN & JOIN SERVER TEMAN
local function FetchFriendsServers()
    for _, child in pairs(ServerListContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end

    local loader = Instance.new("TextLabel", ServerListContainer)
    loader.Size, loader.BackgroundTransparency, loader.Text, loader.Font, loader.TextSize = UDim2.new(1, 0, 1, 0), 1, "👥 Mencari teman online...", Enum.Font.Gotham, 11
    table.insert(AllUIElements, {Obj = loader, Prop = "TextColor3", Key = "AccentColor"})

    task.spawn(function()
        local friendsOnline = {}
        pcall(function()
            local friendPages = Players:GetFriendsAsync(LocalPlayer.UserId)
            while true do
                for _, item in ipairs(friendPages:GetCurrentPage()) do
                    if item.IsOnline then
                        table.insert(friendsOnline, item)
                    end
                end
                if friendPages.IsFinished then break end
                friendPages:AdvanceToNextPageAsync()
            end
        end)

        loader:Destroy()

        local foundFriends = 0
        for _, friend in pairs(friendsOnline) do
            pcall(function()
                local currentPlaceId, currentJobId = TeleportService:GetPlayerPlaceInstanceAsync(friend.Id)
                if currentPlaceId and currentJobId then
                    foundFriends = foundFriends + 1

                    local ItemFrame = Instance.new("Frame", ServerListContainer)
                    ItemFrame.Size = UDim2.new(1, -6, 0, 32)
                    Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 4)
                    table.insert(AllUIElements, {Obj = ItemFrame, Prop = "BackgroundColor3", Key = "FrameColor"})

                    local Info = Instance.new("TextLabel", ItemFrame)
                    Info.Size, Info.Position, Info.BackgroundTransparency, Info.Font, Info.TextSize, Info.TextXAlignment = UDim2.new(0.65, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1, Enum.Font.Gotham, 10, Enum.TextXAlignment.Left
                    Info.Text = string.format("👤 %s", friend.Username)
                    table.insert(AllUIElements, {Obj = Info, Prop = "TextColor3", Key = "TextColor"})

                    local JoinBtn = Instance.new("TextButton", ItemFrame)
                    JoinBtn.Size, JoinBtn.Position, JoinBtn.Text, JoinBtn.Font, JoinBtn.TextSize = UDim2.new(0, 65, 0, 22), UDim2.new(1, -70, 0, 5), "JOIN", Enum.Font.GothamBold, 10
                    Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 4)
                    table.insert(AllUIElements, {Obj = JoinBtn, Prop = "BackgroundColor3", Key = "AccentColor"})
                    JoinBtn.TextColor3 = Color3.fromRGB(15, 15, 15)

                    JoinBtn.MouseButton1Click:Connect(function()
                        if ConfirmOverlay.Visible then return end
                        setRejoinBypassQueue(nil)
                        TeleportService:TeleportToPlaceInstance(currentPlaceId, currentJobId, LocalPlayer)
                    end)
                end
            end)
        end

        if foundFriends == 0 then
            local emptyLbl = Instance.new("TextLabel", ServerListContainer)
            emptyLbl.Size, emptyLbl.BackgroundTransparency, emptyLbl.Text, emptyLbl.Font, emptyLbl.TextSize = UDim2.new(1, 0, 1, 0), 1, "Tidak ada teman aktif di game/server.", Enum.Font.Gotham, 11
            table.insert(AllUIElements, {Obj = emptyLbl, Prop = "TextColor3", Key = "MutedText"})
        end
    end)
end

BtnSepi.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    isFriendMode = false
    currentSortMode = "Ascending"
    updateFilterStyle()
    FetchPublicServers()
end)

BtnRamai.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    isFriendMode = false
    currentSortMode = "Descending"
    updateFilterStyle()
    FetchPublicServers()
end)

BtnTeman.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    isFriendMode = true
    updateFilterStyle()
    FetchFriendsServers()
end)

local RefreshServerListBtn = Instance.new("TextButton", ServerPage)
RefreshServerListBtn.Size, RefreshServerListBtn.Text, RefreshServerListBtn.Font, RefreshServerListBtn.TextSize = UDim2.new(1, -10, 0, 30), "🔄 Muat Ulang Daftar Server", Enum.Font.GothamBold, 11
Instance.new("UICorner", RefreshServerListBtn).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = RefreshServerListBtn, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = RefreshServerListBtn, Prop = "TextColor3", Key = "TextColor"})

RefreshServerListBtn.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    if isFriendMode then
        FetchFriendsServers()
    else
        FetchPublicServers()
    end
end)

-- TAB 6: VOICE PAGE
local VoicePage = CreateTab("Voice")

-- TAB 7: THEMES PAGE
local ThemesPage = CreateTab("Themes")

for themeName, data in pairs(Themes) do
    local ThemeBtn = Instance.new("TextButton", ThemesPage)
    ThemeBtn.Size, ThemeBtn.Text, ThemeBtn.Font, ThemeBtn.TextSize = UDim2.new(1, -10, 0, 36), themeName, Enum.Font.GothamBold, 13
    Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 6)
    local TBtnStroke = Instance.new("UIStroke", ThemeBtn)
    TBtnStroke.Thickness = 1
    
    table.insert(AllUIElements, {Obj = ThemeBtn, Prop = "BackgroundColor3", Key = "FrameColor"})
    table.insert(AllUIElements, {Obj = ThemeBtn, Prop = "TextColor3", Key = "TextColor"})
    table.insert(AllUIElements, {Obj = TBtnStroke, Prop = "Color", Key = "StrokeColor"})
    
    ThemeBtn.MouseButton1Click:Connect(function()
        if ConfirmOverlay.Visible then return end
        ApplyTheme(themeName)
        updateFilterStyle()
    end)
end

CloseButton.MouseButton1Click:Connect(function() if not ScriptRunning then return end ConfirmOverlay.Visible = true end)
NoButton.MouseButton1Click:Connect(function() ConfirmOverlay.Visible = false end)

YesButton.MouseButton1Click:Connect(function()
    ScriptRunning = false
    detach()
    KayHub:Destroy()
end)

ApplyTheme("Sleek Dark")

pcall(function()
    if getgenv and (getgenv().KayHub_Verified or getgenv().KayHub_AutoVerified) then
        UnlockHub()
    end
end)

print("[SYSTEM] Kay Hub V9.3 Server Browser & Friend Tracker Loaded.")
