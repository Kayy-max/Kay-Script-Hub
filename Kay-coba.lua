-- [[ KAY HUB PRO V8.7 - PIGGYBACK ADVANCED PHYSICS REPLICATION UPDATE ]] --
local Players, TS, RS, UIS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

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

-- UI Utama (ScreenGui)
local KayHub = Instance.new("ScreenGui")
KayHub.Name = "KayHub_Main"
KayHub.ResetOnSpawn = false
pcall(function() KayHub.Parent = game:GetService("CoreGui") end)
if not KayHub.Parent then KayHub.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size, MainFrame.Position, MainFrame.Active, MainFrame.Selectable, MainFrame.ClipsDescendants, MainFrame.Parent = UDim2.new(0, 440, 0, 300), UDim2.new(0.3, 0, 0.25, 0), true, true, true, KayHub
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1

table.insert(AllUIElements, {Obj = MainFrame, Prop = "BackgroundColor3", Key = "BGColor"})
table.insert(AllUIElements, {Obj = MainStroke, Prop = "Color", Key = "StrokeColor"})

-- =========================================================
-- DRAG FUNCTION ENGINE
-- =========================================================
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

MakeDraggable(MainFrame)

-- Sidebar Minimalis
local Sidebar = Instance.new("Frame")
Sidebar.Size, Sidebar.Parent = UDim2.new(0, 120, 1, 0), MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
table.insert(AllUIElements, {Obj = Sidebar, Prop = "BackgroundColor3", Key = "SidebarColor"})

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size, LogoLabel.BackgroundTransparency, LogoLabel.Text, LogoLabel.Font, LogoLabel.TextSize, LogoLabel.Parent = UDim2.new(1, 0, 0, 50), 1, "KAY HUB V8", Enum.Font.GothamBold, 15, Sidebar
table.insert(AllUIElements, {Obj = LogoLabel, Prop = "TextColor3", Key = "AccentColor"})

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder, SidebarList.Padding, SidebarList.HorizontalAlignment, SidebarList.Parent = Enum.SortOrder.LayoutOrder, UDim.new(0, 4), Enum.HorizontalAlignment.Center, Sidebar

-- Container Konten
local ContentContainer = Instance.new("Frame")
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency, ContentContainer.Parent = UDim2.new(1, -135, 1, -55), UDim2.new(0, 125, 0, 45), 1, MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size, TopBar.Position, TopBar.BackgroundTransparency, TopBar.Parent = UDim2.new(1, -120, 0, 45), UDim2.new(0, 120, 0, 0), 1, MainFrame

local CurrentTabTitle = Instance.new("TextLabel")
CurrentTabTitle.Size, CurrentTabTitle.Position, CurrentTabTitle.BackgroundTransparency, CurrentTabTitle.Text, CurrentTabTitle.Font, CurrentTabTitle.TextSize, CurrentTabTitle.TextXAlignment, CurrentTabTitle.Parent = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1, "Home", Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, TopBar
table.insert(AllUIElements, {Obj = CurrentTabTitle, Prop = "TextColor3", Key = "TextColor"})

-- Minimize Button Elegan
local MinButton = Instance.new("TextButton")
MinButton.Size, MinButton.Position, MinButton.BackgroundTransparency, MinButton.Text, MinButton.Font, MinButton.TextSize, MinButton.Parent = UDim2.new(0, 30, 0, 30), UDim2.new(1, -65, 0, 7), 1, "—", Enum.Font.GothamBold, 12, TopBar
table.insert(AllUIElements, {Obj = MinButton, Prop = "TextColor3", Key = "MutedText"})

-- Tombol Close Script [X]
local CloseButton = Instance.new("TextButton")
CloseButton.Size, CloseButton.Position, CloseButton.BackgroundTransparency, CloseButton.Text, CloseButton.Font, CloseButton.TextSize, CloseButton.TextColor3, CloseButton.Parent = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 7), 1, "✕", Enum.Font.GothamBold, 14, Color3.fromRGB(240, 50, 50), TopBar

-- Tombol Toggle Menu saat Minimized
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size, ToggleButton.Position, ToggleButton.Text, ToggleButton.Font, ToggleButton.TextSize, ToggleButton.Active, ToggleButton.Visible, ToggleButton.Parent = UDim2.new(0, 80, 0, 32), UDim2.new(0, 15, 0, 120), "Kay Hub", Enum.Font.GothamBold, 12, true, false, KayHub
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
local ToggleStroke = Instance.new("UIStroke", ToggleButton)
MakeDraggable(ToggleButton)

table.insert(AllUIElements, {Obj = ToggleButton, Prop = "BackgroundColor3", Key = "SidebarColor"})
table.insert(AllUIElements, {Obj = ToggleButton, Prop = "TextColor3", Key = "AccentColor"})
table.insert(AllUIElements, {Obj = ToggleStroke, Prop = "Color", Key = "StrokeColor"})

local isMinimized = false
local function toggleMenu()
    if not ScriptRunning then return end
    isMinimized = not isMinimized
    TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 440, 0, 0) or UDim2.new(0, 440, 0, 300)}):Play()
    if isMinimized then task.wait(0.2) end
    MainFrame.Visible = not isMinimized
    ToggleButton.Visible = isMinimized
end
MinButton.MouseButton1Click:Connect(toggleMenu)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

-- POP-UP KONFIRMASI CLOSE
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
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size, TabButton.BackgroundTransparency, TabButton.Text, TabButton.Font, TabButton.TextSize, TabButton.Parent = UDim2.new(0.9, 0, 0, 32), 1, tabName, Enum.Font.GothamBold, 12, Sidebar
    
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

-- VOICE CHAT SYSTEM CORE
local VoiceChatService = cloneref(game:GetService("VoiceChatService"))
local VoiceChatInternal = cloneref(game:GetService("VoiceChatInternal"))

local function initVoiceBypass()
    pcall(function()
        VoiceChatService:leaveVoice()
        task.wait(1.5)
        local conn = getconnections(VoiceChatInternal.StateChanged)
        local vcConnectionCount = #conn
        if vcConnectionCount > 0 and conn[vcConnectionCount] then
            conn[vcConnectionCount]:Disable()
        end
        task.wait(2.5)
        VoiceChatService:joinVoice()
    end)
end

-- FLOATING MIC CONTROLLER OVERLAY
local PopUpFrame = Instance.new("Frame")
PopUpFrame.Name = "KayHub_MicIcon"
PopUpFrame.Size = UDim2.new(0, 46, 0, 46)
PopUpFrame.Position = UDim2.new(0.85, 0, 0.2, 0) 
PopUpFrame.Active = true
PopUpFrame.Selectable = true
PopUpFrame.Visible = false
PopUpFrame.ZIndex = 5        
PopUpFrame.Parent = KayHub

local PopUpCorner = Instance.new("UICorner", PopUpFrame)
PopUpCorner.CornerRadius = UDim.new(1, 0)
local PopUpStroke = Instance.new("UIStroke", PopUpFrame)
PopUpStroke.Thickness = 2

table.insert(AllUIElements, {Obj = PopUpFrame, Prop = "BackgroundColor3", Key = "SidebarColor"})
table.insert(AllUIElements, {Obj = PopUpStroke, Prop = "Color", Key = "StrokeColor"})

MakeDraggable(PopUpFrame)

local PopUpBtn = Instance.new("TextButton", PopUpFrame)
PopUpBtn.Size = UDim2.new(1, 0, 1, 0)
PopUpBtn.BackgroundTransparency = 1
PopUpBtn.Text = "🎙️"
PopUpBtn.TextSize = 18
PopUpBtn.Font = Enum.Font.GothamBold
PopUpBtn.ZIndex = 6                 
PopUpBtn.Active = false             

local voiceMutedState = false
local clickStartPos = Vector3.new()

PopUpFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        clickStartPos = input.Position
    end
end)

PopUpFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local deltaMove = (input.Position - clickStartPos).Magnitude
        if deltaMove < 5 then 
            if not ScriptRunning then return end
            voiceMutedState = not voiceMutedState
            pcall(function() VoiceChatInternal:PublishPause(voiceMutedState) end)
            
            if voiceMutedState then
                PopUpBtn.Text = "🔇"
                TS:Create(PopUpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(240, 50, 50)}):Play()
            else
                PopUpBtn.Text = "🎙️"
                TS:Create(PopUpStroke, TweenInfo.new(0.2), {Color = CurrentTheme.AccentColor}):Play()
            end
        end
    end
end)

-- LOGIKA HALAMAN UTAMA (HOME PAGE)
local HomePage = CreateTab("Home")
local targetPlayerObj = nil 
local posX, posY, posZ, rotY = 0, 1.5, 0.8, 0
local isAttached, autoEmoteEnabled = false, true
local attachmentConnection, respawnConnection, currentEmoteTrack

local function removeWelds()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("Weld") or part:IsA("WeldConstraint") or part:IsA("AlignPosition") then pcall(function() part:Destroy() end) end
        end
    end
end

-- =========================================================
-- VARIABEL FITUR 2: PIGGYBACK FE (UPDATED ENGINE IMPLEMENTATION)
-- =========================================================
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

local function detach()
    isAttached = false
    if attachmentConnection then attachmentConnection:Disconnect() end
    if respawnConnection then respawnConnection:Disconnect() end
    local myChar = LocalPlayer.Character
    if myChar then
        local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHumanoid then myHumanoid.PlatformStand = false end
        
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
    if currentEmoteTrack then currentEmoteTrack:Stop() end
end

local function forceUpdatePosition()
    if isAttached and targetPlayerObj and targetPlayerObj.Character then
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = targetPlayerObj.Character:FindFirstChild("HumanoidRootPart")
        if myHRP and targetHRP then
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(posX, posY, posZ) * CFrame.Angles(0, math.rad(rotY), 0)
        end
    end
end

-- Instant Interact
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

local Line = Instance.new("Frame", HomePage)
Line.Size, Line.BorderSizePixel = UDim2.new(1, -10, 0, 1), 0
table.insert(AllUIElements, {Obj = Line, Prop = "BackgroundColor3", Key = "StrokeColor"})

-- DROPDOWN MENU TARGET PLAYER
local SearchBox = Instance.new("TextBox", HomePage)
SearchBox.Size, SearchBox.PlaceholderText, SearchBox.Font, SearchBox.TextSize = UDim2.new(1, -10, 0, 32), "Cari nama player...", Enum.Font.Gotham, 12
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
local SBS = Instance.new("UIStroke", SearchBox)
table.insert(AllUIElements, {Obj = SearchBox, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = SearchBox, Prop = "TextColor3", Key = "TextColor"})
table.insert(AllUIElements, {Obj = SBS, Prop = "Color", Key = "StrokeColor"})

local DropdownBtn = Instance.new("TextButton", HomePage)
DropdownBtn.Size, DropdownBtn.Text, DropdownBtn.Font, DropdownBtn.TextSize = UDim2.new(1, -10, 0, 32), "▼ Pilih Player Target ▼", Enum.Font.GothamBold, 12
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = DropdownBtn, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = DropdownBtn, Prop = "TextColor3", Key = "MutedText"})

local PlayerListFrame = Instance.new("ScrollingFrame", HomePage)
PlayerListFrame.Size, PlayerListFrame.Visible, PlayerListFrame.ScrollBarThickness, PlayerListFrame.BorderSizePixel = UDim2.new(1, -10, 0, 80), false, 2, 0
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 6)
local ListLayout = Instance.new("UIListLayout", PlayerListFrame)
table.insert(AllUIElements, {Obj = PlayerListFrame, Prop = "BackgroundColor3", Key = "SidebarColor"})

DropdownBtn.MouseButton1Click:Connect(function() if ConfirmOverlay.Visible then return end PlayerListFrame.Visible = not PlayerListFrame.Visible end)

local function refreshPlayerList(filter)
    for _, child in pairs(PlayerListFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not filter or filter == "" or string.find(string.lower(player.DisplayName), string.lower(filter)) or string.find(string.lower(player.Name), string.lower(filter)) then
                local btn = Instance.new("TextButton", PlayerListFrame)
                btn.Size, btn.Text, btn.Font, btn.TextSize = UDim2.new(1, 0, 0, 26), player.DisplayName, Enum.Font.Gotham, 11
                btn.BorderSizePixel = 0
                table.insert(AllUIElements, {Obj = btn, Prop = "BackgroundColor3", Key = "FrameColor"})
                table.insert(AllUIElements, {Obj = btn, Prop = "TextColor3", Key = "TextColor"})
                btn.MouseButton1Click:Connect(function()
                    if ConfirmOverlay.Visible then return end
                    targetPlayerObj = player 
                    DropdownBtn.Text = "Selected: " .. player.DisplayName
                    PlayerListFrame.Visible = false
                end)
            end
        end
    end
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() refreshPlayerList(SearchBox.Text) PlayerListFrame.Visible = true end)
refreshPlayerList()

local function runAttachLogic()
    if not targetPlayerObj or ConfirmOverlay.Visible then return end
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
        pcall(function()
            currentEmoteTrack = char:WaitForChild("Humanoid"):LoadAnimation(anim)
            currentEmoteTrack:Play()
        end)
    end
end

local ActionFrame = Instance.new("Frame", HomePage)
ActionFrame.Size, ActionFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 32), 1
local ActionLayout = Instance.new("UIListLayout", ActionFrame)
ActionLayout.FillDirection, ActionLayout.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)

local function createActionBtn(txt, color, cb)
    local b = Instance.new("TextButton", ActionFrame)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.49, 0, 1, 0), color, txt, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() if ConfirmOverlay.Visible then return end cb() end)
end
createActionBtn("TEMPEL", Color3.fromRGB(20, 140, 80), runAttachLogic)
createActionBtn("LEPAS", Color3.fromRGB(160, 40, 40), detach)

local NavFrame = Instance.new("Frame", HomePage)
NavFrame.Size, NavFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 65), 1
local NavGrid = Instance.new("UIGridLayout", NavFrame)
NavGrid.CellSize, NavGrid.CellPadding = UDim2.new(0.235, 0, 0, 26), UDim2.new(0, 4, 0, 4)

local function createNav(txt, cb)
    local b = Instance.new("TextButton", NavFrame)
    b.Text, b.Font, b.TextSize = txt, Enum.Font.GothamBold, 9
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    table.insert(AllUIElements, {Obj = b, Prop = "BackgroundColor3", Key = "FrameColor"})
    table.insert(AllUIElements, {Obj = b, Prop = "TextColor3", Key = "TextColor"})
    b.MouseButton1Click:Connect(function() if ConfirmOverlay.Visible then return end cb() forceUpdatePosition() end)
end
createNav("NAIK", function() posY = posY + 0.2 end)
createNav("TURUN", function() posY = posY - 0.2 end)
createNav("DEPAN", function() posZ = posZ - 0.2 end)
createNav("BELAKANG", function() posZ = posZ + 0.2 end)
createNav("KIRI", function() posX = posX - 0.2 end)
createNav("KANAN", function() posX = posX + 0.2 end)
createNav("PUTAR", function() rotY = (rotY + 90) % 360 end)

local ToggleEmoteBtn = Instance.new("TextButton", NavFrame)
ToggleEmoteBtn.BackgroundColor3, ToggleEmoteBtn.Text, ToggleEmoteBtn.TextColor3, ToggleEmoteBtn.Font, ToggleEmoteBtn.TextSize = Color3.fromRGB(20, 140, 80), "EMOTE: ON", Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 9
Instance.new("UICorner", ToggleEmoteBtn).CornerRadius = UDim.new(0, 4)
ToggleEmoteBtn.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    autoEmoteEnabled = not autoEmoteEnabled
    ToggleEmoteBtn.BackgroundColor3 = autoEmoteEnabled and Color3.fromRGB(20, 140, 80) or Color3.fromRGB(160, 40, 40)
    ToggleEmoteBtn.Text = autoEmoteEnabled and "EMOTE: ON" or "EMOTE: OFF"
end)

-- CUSTOM ANIMATION PAGE
local AnimPage = CreateTab("Animations")
local animMode = "NONE"
local kayAnimTrack = nil

local btnPreset = Instance.new("TextButton", AnimPage)
btnPreset.Size, btnPreset.Text, btnPreset.Font, btnPreset.TextSize = UDim2.new(1, -10, 0, 35), "Preset Kay", Enum.Font.Gotham, 12
Instance.new("UICorner", btnPreset).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = btnPreset, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = btnPreset, Prop = "TextColor3", Key = "TextColor"})

local inIdle = Instance.new("TextBox", AnimPage)
inIdle.Size, inIdle.PlaceholderText, inIdle.Text, inIdle.Font, inIdle.TextSize = UDim2.new(1, -10, 0, 35), "Custom Idle (ID)", "", Enum.Font.Gotham, 12
Instance.new("UICorner", inIdle).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = inIdle, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = inIdle, Prop = "TextColor3", Key = "TextColor"})

local inWalk = Instance.new("TextBox", AnimPage)
inWalk.Size, inWalk.PlaceholderText, inWalk.Text, inWalk.Font, inWalk.TextSize = UDim2.new(1, -10, 0, 35), "Custom Walk (ID)", "", Enum.Font.Gotham, 12
Instance.new("UICorner", inWalk).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = inWalk, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = inWalk, Prop = "TextColor3", Key = "TextColor"})

local btnToggleAnim = Instance.new("TextButton", AnimPage)
btnToggleAnim.Size, btnToggleAnim.Text, btnToggleAnim.BackgroundColor3, btnToggleAnim.TextColor3, btnToggleAnim.Font, btnToggleAnim.TextSize = UDim2.new(1, -10, 0, 35), "STATUS: OFF", Color3.fromRGB(160, 40, 40), Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
Instance.new("UICorner", btnToggleAnim).CornerRadius = UDim.new(0, 6)

local function playKayAnim(id)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and hum and hum.Health > 0 then
        if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
        if not kayAnimTrack or kayAnimTrack.Animation.AnimationId ~= "rbxassetid://" .. id then
            if kayAnimTrack then kayAnimTrack:Stop() end
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. id
            pcall(function()
                kayAnimTrack = hum:LoadAnimation(anim)
                kayAnimTrack:Play()
            end)
        end
    end
end

btnPreset.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    animMode = (animMode == "PRESET" and "NONE" or "PRESET")
    btnPreset.TextColor3 = (animMode == "PRESET" and CurrentTheme.AccentColor or CurrentTheme.TextColor)
    if animMode ~= "CUSTOM" then
        btnToggleAnim.Text = "STATUS: OFF"
        btnToggleAnim.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
    end
end)

btnToggleAnim.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    animMode = (animMode == "CUSTOM" and "NONE" or "CUSTOM")
    btnToggleAnim.Text = (animMode == "CUSTOM" and "STATUS: ON" or "STATUS: OFF")
    btnToggleAnim.BackgroundColor3 = (animMode == "CUSTOM" and Color3.fromRGB(20, 140, 80) or Color3.fromRGB(160, 40, 40))
    if animMode ~= "PRESET" then btnPreset.TextColor3 = CurrentTheme.TextColor end
end)

-- FUN / UTILITIES PAGE
local FunPage = CreateTab("Fun")
local SpeedValue, SpeedEnabled, InfiniteJumpEnabled, Flying, FlySpeed, NoclipEnabled = 16, false, false, false, 60, false

local SpeedFrame = Instance.new("Frame", FunPage)
SpeedFrame.Size = UDim2.new(1, -10, 0, 40)
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = SpeedFrame, Prop = "BackgroundColor3", Key = "FrameColor"})

local SpeedToggle = Instance.new("TextButton", SpeedFrame)
SpeedToggle.Size, SpeedToggle.Position, SpeedToggle.Text, SpeedToggle.Font, SpeedToggle.TextSize = UDim2.new(0, 80, 0, 24), UDim2.new(0, 8, 0, 8), "Speed: OFF", Enum.Font.GothamBold, 11
Instance.new("UICorner", SpeedToggle).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = SpeedToggle, Prop = "BackgroundColor3", Key = "StrokeColor"})
table.insert(AllUIElements, {Obj = SpeedToggle, Prop = "TextColor3", Key = "MutedText"})

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Size, SpeedLabel.Position, SpeedLabel.BackgroundTransparency, SpeedLabel.Text, SpeedLabel.Font, SpeedLabel.TextSize = UDim2.new(0, 120, 1, 0), UDim2.new(0, 95, 0, 0), 1, "Value: < " .. SpeedValue .. " >", Enum.Font.Gotham, 11
table.insert(AllUIElements, {Obj = SpeedLabel, Prop = "TextColor3", Key = "TextColor"})

local function createChangeSpeed(txt, x, offset)
    local b = Instance.new("TextButton", SpeedFrame)
    b.Size, b.Position, b.Text, b.Font, b.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, x, 0, 8), txt, Enum.Font.GothamBold, 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    table.insert(AllUIElements, {Obj = b, Prop = "BackgroundColor3", Key = "SidebarColor"})
    table.insert(AllUIElements, {Obj = b, Prop = "TextColor3", Key = "TextColor"})
    b.MouseButton1Click:Connect(function() if ConfirmOverlay.Visible then return end SpeedValue = math.max(16, SpeedValue + offset) SpeedLabel.Text = "Value: < " .. SpeedValue .. " >" end)
end
createChangeSpeed("-", -60, -10)
createChangeSpeed("+", -32, 10)

SpeedToggle.MouseButton1Click:Connect(function()
    if ConfirmOverlay.Visible then return end
    SpeedEnabled = not SpeedEnabled
    SpeedToggle.Text = SpeedEnabled and "Speed: ON" or "Speed: OFF"
    local tBG = SpeedEnabled and CurrentTheme.AccentColor or CurrentTheme.StrokeColor
    local tTX = SpeedEnabled and Color3.fromRGB(15,15,15) or CurrentTheme.MutedText
    TS:Create(SpeedToggle, TweenInfo.new(0.2), {BackgroundColor3 = tBG, TextColor3 = tTX}):Play()
    if not SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end
end)

local FlySpeedFrame = Instance.new("Frame", FunPage)
FlySpeedFrame.Size = UDim2.new(1, -10, 0, 40)
Instance.new("UICorner", FlySpeedFrame).CornerRadius = UDim.new(0, 6)
table.insert(AllUIElements, {Obj = FlySpeedFrame, Prop = "BackgroundColor3", Key = "FrameColor"})

local FlyLabel = Instance.new("TextLabel", FlySpeedFrame)
FlyLabel.Size, FlyLabel.Position, FlyLabel.BackgroundTransparency, FlyLabel.Text, FlyLabel.Font, FlyLabel.TextSize = UDim2.new(0, 150, 1, 0), UDim2.new(0, 12, 0, 0), 1, "Kecepatan Terbang: [ " .. FlySpeed .. " ]", Enum.Font.Gotham, 12
table.insert(AllUIElements, {Obj = FlyLabel, Prop = "TextColor3", Key = "TextColor"})

local function createChangeFly(txt, x, offset)
    local b = Instance.new("TextButton", FlySpeedFrame)
    b.Size, b.Position, b.Text, b.Font, b.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, x, 0, 8), txt, Enum.Font.GothamBold, 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    table.insert(AllUIElements, {Obj = b, Prop = "BackgroundColor3", Key = "SidebarColor"})
    table.insert(AllUIElements, {Obj = b, Prop = "TextColor3", Key = "TextColor"})
    b.MouseButton1Click:Connect(function() if ConfirmOverlay.Visible then return end FlySpeed = math.max(10, FlySpeed + offset) FlyLabel.Text = "Kecepatan Terbang: [ " .. FlySpeed .. " ]" end)
end
createChangeFly("-", -60, -10)
createChangeFly("+", -32, 10)

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

-- ESP PAGE
local EspPage = CreateTab("ESP")
local globalEspActive, targetEspActive = false, false

CreateToggle(EspPage, "Global ESP (Semua Orang)", function(state) globalEspActive = state end)

local EspLine = Instance.new("Frame", EspPage)
EspLine.Size, EspLine.BorderSizePixel = UDim2.new(1, -10, 0, 1), 0
table.insert(AllUIElements, {Obj = EspLine, Prop = "BackgroundColor3", Key = "StrokeColor"})

local TargetSearchBox = Instance.new("TextBox", EspPage)
TargetSearchBox.Size, TargetSearchBox.PlaceholderText, TargetSearchBox.Text, TargetSearchBox.Font, TargetSearchBox.TextSize = UDim2.new(1, -10, 0, 35), "Ketik nama/display target...", "", Enum.Font.Gotham, 12
Instance.new("UICorner", TargetSearchBox).CornerRadius = UDim.new(0, 6)
local TargetSearchStroke = Instance.new("UIStroke", TargetSearchBox)
table.insert(AllUIElements, {Obj = TargetSearchBox, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = TargetSearchBox, Prop = "TextColor3", Key = "TextColor"})
table.insert(AllUIElements, {Obj = TargetSearchStroke, Prop = "Color", Key = "StrokeColor"})

CreateToggle(EspPage, "Target ESP (Satu Orang)", function(state) targetEspActive = state end)

local function clearEspElements(p)
    if p:FindFirstChild("KayEsp_Bill") then p.KayEsp_Bill:Destroy() end
    if p:FindFirstChild("KayEsp_Highlight") then p.KayEsp_Highlight:Destroy() end
end

-- VOICE TAB
local VoicePage = CreateTab("Voice")

CreateToggle(VoicePage, "Kay voice antiban", function(state)
    if state then
        initVoiceBypass()
        PopUpFrame.Visible = true
        TS:Create(PopUpStroke, TweenInfo.new(0.2), {Color = CurrentTheme.AccentColor}):Play()
    else
        PopUpFrame.Visible = false
        pcall(function() VoiceChatInternal:PublishPause(false) end)
    end
end)

-- THEMES PAGE
local ThemesPage = CreateTab("Themes")

local InfoThemeLabel = Instance.new("TextLabel", ThemesPage)
InfoThemeLabel.Size, InfoThemeLabel.BackgroundTransparency, InfoThemeLabel.Text, InfoThemeLabel.Font, InfoThemeLabel.TextSize = UDim2.new(1, -10, 0, 25), 1, "Pilih warna & suasana tema Kay Hub favoritmu:", Enum.Font.Gotham, 12
table.insert(AllUIElements, {Obj = InfoThemeLabel, Prop = "TextColor3", Key = "TextColor"})

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
        if animMode ~= "PRESET" then btnPreset.TextColor3 = CurrentTheme.TextColor end
        if PopUpFrame.Visible and not voiceMutedState then PopUpStroke.Color = CurrentTheme.AccentColor end
    end)
end

-- CLOSE ACTION WINDOWS
CloseButton.MouseButton1Click:Connect(function() if not ScriptRunning then return end ConfirmOverlay.Visible = true end)
NoButton.MouseButton1Click:Connect(function() ConfirmOverlay.Visible = false end)

YesButton.MouseButton1Click:Connect(function()
    ScriptRunning = false
    detach()
    if promptConnection then promptConnection:Disconnect() end
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        if char and char:FindFirstChild("Animate") then char.Animate.Enabled = true end
    end)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("HumanoidRootPart") then clearEspElements(p.Character.HumanoidRootPart) end
            if p.Character:FindFirstChild("KayEsp_Highlight") then p.Character.KayEsp_Highlight:Destroy() end
        end
    end
    KayHub:Destroy()
end)

-- ENGINE LOOP JALUR CORE REPLICATOR (RUNSERVICE STEPPED)
RS.Stepped:Connect(function()
    if not ScriptRunning then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if SpeedEnabled and hum then hum.WalkSpeed = SpeedValue end
    if NoclipEnabled and char then
        for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
    
    if hum then
        if animMode == "PRESET" then
            playKayAnim(hum.MoveDirection.Magnitude > 0 and "130072963359721" or "96961377796798")
        elseif animMode == "CUSTOM" then
            local id = (hum.MoveDirection.Magnitude > 0 and inWalk.Text:gsub("%D","") or inIdle.Text:gsub("%D",""))
            if id ~= "" then playKayAnim(id) end
        else
            if char and char:FindFirstChild("Animate") and char.Animate.Enabled == false then char.Animate.Enabled = true end
            if kayAnimTrack then kayAnimTrack:Stop() kayAnimTrack = nil end
        end
    end

    local queryTarget = string.lower(TargetSearchBox.Text)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local tChar = p.Character
            local tHrp = tChar.HumanoidRootPart
            local isMatchTarget = (queryTarget ~= "" and (string.find(string.lower(p.Name), queryTarget) or string.find(string.lower(p.DisplayName), queryTarget)))

            if (globalEspActive) or (targetEspActive and isMatchTarget) then
                local distance = myHrp and math.round((myHrp.Position - tHrp.Position).Magnitude) or 0
                local bill = tHrp:FindFirstChild("KayEsp_Bill")
                if not bill then
                    bill = Instance.new("BillboardGui", tHrp)
                    bill.Name = "KayEsp_Bill"
                    bill.Size = UDim2.new(0, 200, 0, 50)
                    bill.AlwaysOnTop = true
                    bill.ExtentsOffset = Vector3.new(0, 3, 0)
                    
                    local txt = Instance.new("TextLabel", bill)
                    txt.Name = "EspLabel"
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 12
                    txt.TextStrokeTransparency = 0.5
                end
                local label = bill:FindFirstChild("EspLabel")
                if label then
                    label.Text = p.DisplayName .. " (@" .. p.Name .. ")\n[" .. distance .. "m]"
                    label.TextColor3 = CurrentTheme.AccentColor
                end
                if targetEspActive and isMatchTarget then
                    local high = tChar:FindFirstChild("KayEsp_Highlight")
                    if not high then
                        high = Instance.new("Highlight", tChar)
                        high.Name = "KayEsp_Highlight"
                        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    high.FillColor = CurrentTheme.AccentColor
                    high.OutlineColor = Color3.fromRGB(255,255,255)
                    high.FillTransparency = 0.6
                else
                    if tChar:FindFirstChild("KayEsp_Highlight") then tChar.KayEsp_Highlight:Destroy() end
                end
            else
                clearEspElements(tHrp)
                if tChar:FindFirstChild("KayEsp_Highlight") then tChar.KayEsp_Highlight:Destroy() end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then clearEspElements(p.Character.HumanoidRootPart) end
end)

ApplyTheme("Sleek Dark")
print("[SYSTEM] Kay Hub V8.7: Advanced Physics Replicator Applied.")
