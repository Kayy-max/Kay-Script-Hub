-- [[ KAY HUB PRO V9.6 - CLEAN RE-STRUCTURE & FIXED CORE ]] --
local Players, TS, RS, UIS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Themes = {
    ["Sleek Dark"] = {
        BGColor = Color3.fromRGB(15, 15, 15),
        SidebarColor = Color3.fromRGB(22, 22, 22),
        FrameColor = Color3.fromRGB(25, 25, 25),
        StrokeColor = Color3.fromRGB(40, 40, 40),
        AccentColor = Color3.fromRGB(0, 230, 130),
        TextColor = Color3.fromRGB(240, 240, 240),
        MutedText = Color3.fromRGB(140, 140, 140)
    }
}
local CurrentTheme = Themes["Sleek Dark"]
local Tabs, AllUIElements = {}, {}
local ScriptRunning = true

-- SCREEN GUI CORE
local KayHub = Instance.new("ScreenGui")
pcall(function() KayHub.Parent = game:GetService("CoreGui") end)
if not KayHub.Parent then KayHub.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size, MainFrame.Position, MainFrame.Active, MainFrame.ClipsDescendants, MainFrame.Parent = UDim2.new(0, 450, 0, 320), UDim2.new(0.3, 0, 0.25, 0), true, true, KayHub
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1
table.insert(AllUIElements, {Obj = MainFrame, Prop = "BackgroundColor3", Key = "BGColor"})
table.insert(AllUIElements, {Obj = MainStroke, Prop = "Color", Key = "StrokeColor"})

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

-- SIDEBAR
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
table.insert(AllUIElements, {Obj = Sidebar, Prop = "BackgroundColor3", Key = "SidebarColor"})

local LogoLabel = Instance.new("TextLabel", Sidebar)
LogoLabel.Size, LogoLabel.BackgroundTransparency, LogoLabel.Text, LogoLabel.Font, LogoLabel.TextSize = UDim2.new(1, 0, 0, 45), 1, "KAY HUB V9.6", Enum.Font.GothamBold, 14
table.insert(AllUIElements, {Obj = LogoLabel, Prop = "TextColor3", Key = "AccentColor"})

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder, SidebarList.Padding, SidebarList.HorizontalAlignment = Enum.SortOrder.LayoutOrder, UDim.new(0, 5), Enum.HorizontalAlignment.Center

-- CONTENT AREA
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency = UDim2.new(1, -135, 1, -55), UDim2.new(0, 125, 0, 45), 1

-- TOPBAR CONTROLS
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.Position, TopBar.BackgroundTransparency = UDim2.new(1, -120, 0, 45), UDim2.new(0, 120, 0, 0), 1

local CurrentTabTitle = Instance.new("TextLabel", TopBar)
CurrentTabTitle.Size, CurrentTabTitle.Position, CurrentTabTitle.BackgroundTransparency, CurrentTabTitle.Text, CurrentTabTitle.Font, CurrentTabTitle.TextSize, CurrentTabTitle.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1, "Home", Enum.Font.GothamBold, 14, Enum.TextXAlignment.Left
table.insert(AllUIElements, {Obj = CurrentTabTitle, Prop = "TextColor3", Key = "TextColor"})

local MinButton = Instance.new("TextButton", TopBar)
MinButton.Size, MinButton.Position, MinButton.BackgroundTransparency, MinButton.Text, MinButton.Font, MinButton.TextSize = UDim2.new(0, 25, 0, 30), UDim2.new(1, -60, 0, 7), 1, "—", Enum.Font.GothamBold, 12, TopBar
table.insert(AllUIElements, {Obj = MinButton, Prop = "TextColor3", Key = "MutedText"})

local CloseButton = Instance.new("TextButton", TopBar)
CloseButton.Size, CloseButton.Position, CloseButton.BackgroundTransparency, CloseButton.Text, CloseButton.Font, CloseButton.TextSize, CloseButton.TextColor3 = UDim2.new(0, 25, 0, 30), UDim2.new(1, -30, 0, 7), 1, "✕", Enum.Font.GothamBold, 14, Color3.fromRGB(240, 50, 50)

-- OPEN FLOATING BUTTON
local ToggleButton = Instance.new("TextButton", KayHub)
ToggleButton.Size, ToggleButton.Position, ToggleButton.Text, ToggleButton.Font, ToggleButton.TextSize, ToggleButton.Visible = UDim2.new(0, 80, 0, 32), UDim2.new(0, 15, 0, 50), "Kay Hub", Enum.Font.GothamBold, 12, false
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
local ToggleStroke = Instance.new("UIStroke", ToggleButton)
MakeDraggable(ToggleButton)
table.insert(AllUIElements, {Obj = ToggleButton, Prop = "BackgroundColor3", Key = "SidebarColor"})
table.insert(AllUIElements, {Obj = ToggleButton, Prop = "TextColor3", Key = "AccentColor"})
table.insert(AllUIElements, {Obj = ToggleStroke, Prop = "Color", Key = "StrokeColor"})

local isMinimized = false
local function toggleMenu()
    isMinimized = not isMinimized
    TS:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 450, 0, 0) or UDim2.new(0, 450, 0, 320)}):Play()
    if isMinimized then task.wait(0.15) end
    MainFrame.Visible = not isMinimized
    ToggleButton.Visible = isMinimized
end
MinButton.MouseButton1Click:Connect(toggleMenu)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

-- TAB SYSTEM CREATOR
local FirstTab = true
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame", ContentContainer)
    Page.Size, Page.BackgroundTransparency, Page.BorderSizePixel, Page.ScrollBarThickness, Page.AutomaticCanvasSize, Page.Visible = UDim2.new(1, 0, 1, 0), 1, 0, 2, Enum.AutomaticSize.Y, false
    local PageList = Instance.new("UIListLayout", Page)
    PageList.Padding, PageList.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center
    
    local TabButton = Instance.new("TextButton", Sidebar)
    TabButton.Size, TabButton.BackgroundTransparency, TabButton.Text, TabButton.Font, TabButton.TextSize = UDim2.new(0.9, 0, 0, 32), 1, tabName, Enum.Font.GothamBold, 11
    
    table.insert(AllUIElements, {Obj = TabButton, Prop = "TextColor3", Key = FirstTab and "AccentColor" or "MutedText"})
    if FirstTab then Page.Visible, CurrentTabTitle.Text, FirstTab = true, tabName, false end
    
    TabButton.MouseButton1Click:Connect(function()
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

-- TOGGLE INTERFACE COMPONENT
local function CreateToggle(parent, text, callback)
    local Enabled = false
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    table.insert(AllUIElements, {Obj = Frame, Prop = "BackgroundColor3", Key = "FrameColor"})
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size, Label.Position, Label.BackgroundTransparency, Label.Text, Label.Font, Label.TextSize, Label.TextXAlignment = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1, text, Enum.Font.Gotham, 12, Enum.TextXAlignment.Left
    table.insert(AllUIElements, {Obj = Label, Prop = "TextColor3", Key = "TextColor"})
    
    local Switch = Instance.new("TextButton", Frame)
    Switch.Size, Switch.Position, Switch.Text, Switch.Font, Switch.TextSize = UDim2.new(0, 45, 0, 20), UDim2.new(1, -55, 0, 7.5), "OFF", Enum.Font.GothamBold, 10
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(0, 10)
    table.insert(AllUIElements, {Obj = Switch, Prop = "BackgroundColor3", Key = "StrokeColor"})
    table.insert(AllUIElements, {Obj = Switch, Prop = "TextColor3", Key = "MutedText"})

    Switch.MouseButton1Click:Connect(function()
        if not ScriptRunning then return end
        Enabled = not Enabled
        Switch.Text = Enabled and "ON" or "OFF"
        local targetBG = Enabled and CurrentTheme.AccentColor or CurrentTheme.StrokeColor
        local targetText = Enabled and Color3.fromRGB(15,15,15) or CurrentTheme.MutedText
        TS:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetBG, TextColor3 = targetText}):Play()
        callback(Enabled)
    end)
    return Frame
end

-- =========================================================
-- TAB 1: PIGGYBACK (HOME)
-- =========================================================
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
            myHRP.Velocity = Vector3.new(0, 0, 0)
            myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
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
    if currentEmoteTrack then currentEmoteTrack:Stop() end
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

local Separator1 = Instance.new("Frame", HomePage)
Separator1.Size, Separator1.BorderSizePixel = UDim2.new(1, -10, 0, 1), 0
table.insert(AllUIElements, {Obj = Separator1, Prop = "BackgroundColor3", Key = "StrokeColor"})

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

DropdownBtn.MouseButton1Click:Connect(function() PlayerListFrame.Visible = not PlayerListFrame.Visible end)

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
    b.MouseButton1Click:Connect(cb)
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
ToggleEmoteBtn.BackgroundColor3, ToggleEmoteBtn.Text, ToggleEmoteBtn.TextColor3, ToggleEmoteBtn.Font, ToggleEmoteBtn.TextSize = Color3.fromRGB(20, 140, 80), "EMOTE: ON", Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 9
Instance.new("UICorner", ToggleEmoteBtn).CornerRadius = UDim.new(0, 4)
ToggleEmoteBtn.MouseButton1Click:Connect(function()
    autoEmoteEnabled = not autoEmoteEnabled
    ToggleEmoteBtn.BackgroundColor3 = autoEmoteEnabled and Color3.fromRGB(20, 140, 80) or Color3.fromRGB(160, 40, 40)
    ToggleEmoteBtn.Text = autoEmoteEnabled and "EMOTE: ON" or "EMOTE: OFF"
end)

-- =========================================================
-- TAB 2: ESP SYSTEM & SPECTATE (CLEAN MODULAR SETUP)
-- =========================================================
local EspPage = CreateTab("ESP")
local globalEspActive, targetEspActive, spectateActive = false, false, false

-- SECTION 1: GLOBAL
CreateToggle(EspPage, "Global ESP (Semua Orang)", function(state) globalEspActive = state end)

local LineBreak1 = Instance.new("Frame", EspPage)
LineBreak1.Size, LineBreak1.BorderSizePixel = UDim2.new(1, -10, 0, 1), 0
table.insert(AllUIElements, {Obj = LineBreak1, Prop = "BackgroundColor3", Key = "StrokeColor"})

-- SECTION 2: TARGET 1 ORANG
local TargetSearchBox = Instance.new("TextBox", EspPage)
TargetSearchBox.Size, TargetSearchBox.PlaceholderText, TargetSearchBox.Text, TargetSearchBox.Font, TargetSearchBox.TextSize = UDim2.new(1, -10, 0, 30), "Ketik Nama Target ESP...", "", Enum.Font.Gotham, 11
Instance.new("UICorner", TargetSearchBox).CornerRadius = UDim.new(0, 5)
local TSBStroke = Instance.new("UIStroke", TargetSearchBox)
table.insert(AllUIElements, {Obj = TargetSearchBox, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = TargetSearchBox, Prop = "TextColor3", Key = "TextColor"})
table.insert(AllUIElements, {Obj = TSBStroke, Prop = "Color", Key = "StrokeColor"})

CreateToggle(EspPage, "Aktifkan Target ESP 1 Orang", function(state) targetEspActive = state end)

local LineBreak2 = Instance.new("Frame", EspPage)
LineBreak2.Size, LineBreak2.BorderSizePixel = UDim2.new(1, -10, 0, 1), 0
table.insert(AllUIElements, {Obj = LineBreak2, Prop = "BackgroundColor3", Key = "StrokeColor"})

-- SECTION 3: SPECTATE TARGET
local SpecSearchBox = Instance.new("TextBox", EspPage)
SpecSearchBox.Size, SpecSearchBox.PlaceholderText, SpecSearchBox.Text, SpecSearchBox.Font, SpecSearchBox.TextSize = UDim2.new(1, -10, 0, 30), "Ketik Nama Target Spectate...", "", Enum.Font.Gotham, 11
Instance.new("UICorner", SpecSearchBox).CornerRadius = UDim.new(0, 5)
local SSBStroke = Instance.new("UIStroke", SpecSearchBox)
table.insert(AllUIElements, {Obj = SpecSearchBox, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = SpecSearchBox, Prop = "TextColor3", Key = "TextColor"})
table.insert(AllUIElements, {Obj = SSBStroke, Prop = "Color", Key = "StrokeColor"})

CreateToggle(EspPage, "Aktifkan Kamera Spectate", function(state)
    spectateActive = state
    if not state then
        pcall(function()
            local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if myHum then Camera.CameraSubject = myHum end
        end)
    end
end)

-- RENDERING UTILS
local function clearEsp(character)
    if not character then return end
    for _, child in pairs(character:GetDescendants()) do
        if child.Name == "KayEsp_Bill" or child.Name == "KayEsp_Highlight" then pcall(function() child:Destroy() end) end
    end
end

local function getSafeRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChildOfClass("Part")
end

-- =========================================================
-- SYSTEM DESTRUCTION / CLOSE SCRIPT CONFIRMATION
-- =========================================================
local ConfirmOverlay = Instance.new("Frame", MainFrame)
ConfirmOverlay.Size, ConfirmOverlay.Position, ConfirmOverlay.Visible, ConfirmOverlay.ZIndex = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), false, 10
Instance.new("UICorner", ConfirmOverlay).CornerRadius = UDim.new(0, 10)
table.insert(AllUIElements, {Obj = ConfirmOverlay, Prop = "BackgroundColor3", Key = "BGColor"})

local ConfirmBox = Instance.new("Frame", ConfirmOverlay)
ConfirmBox.Size, ConfirmBox.Position = UDim2.new(0, 260, 0, 110), UDim2.new(0.5, -130, 0.5, -55)
Instance.new("UICorner", ConfirmBox).CornerRadius = UDim.new(0, 8)
local CBSec = Instance.new("UIStroke", ConfirmBox)
table.insert(AllUIElements, {Obj = ConfirmBox, Prop = "BackgroundColor3", Key = "FrameColor"})
table.insert(AllUIElements, {Obj = CBSec, Prop = "Color", Key = "StrokeColor"})

local QTxt = Instance.new("TextLabel", ConfirmBox)
QTxt.Size, QTxt.BackgroundTransparency, QTxt.Text, QTxt.Font, QTxt.TextSize, QTxt.TextWrapped = UDim2.new(1, -20, 0, 40), 1, "Yakin ingin menutup script?", Enum.Font.GothamBold, 12, true
QTxt.Position = UDim2.new(0, 10, 0, 15)
table.insert(AllUIElements, {Obj = QTxt, Prop = "TextColor3", Key = "TextColor"})

createConfirmBtn = function(txt, xOffset, color, cb)
    local b = Instance.new("TextButton", ConfirmBox)
    b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(0, 100, 0, 28), UDim2.new(0.5, xOffset, 0, 65), color, txt, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

createConfirmBtn("IYA", -110, Color3.fromRGB(180, 40, 40), function()
    ScriptRunning = false
    detach()
    if promptConnection then promptConnection:Disconnect() end
    for _, p in pairs(Players:GetPlayers()) do clearEsp(p.Character) end
    pcall(function()
        local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHum then Camera.CameraSubject = myHum end
    end)
    KayHub:Destroy()
end)

createConfirmBtn("BATAL", 10, Color3.fromRGB(60, 60, 60), function()
    ConfirmOverlay.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function() ConfirmOverlay.Visible = true end)

-- =========================================================
-- RUNTIME CORE LOOP (GABUNGAN UTAMA)
-- =========================================================
RS.Stepped:Connect(function()
    if not ScriptRunning then return end
    
    local myChar = LocalPlayer.Character
    local myHrp = getSafeRoot(myChar)
    
    local qTargetEsp = string.lower(TargetSearchBox.Text)
    local qSpectate = string.lower(SpecSearchBox.Text)
    local spectateFound = false

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            pcall(function()
                local tChar = p.Character
                local tHrp = getSafeRoot(tChar)
                local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                
                if tChar and tHrp then
                    local isMatchEsp = (qTargetEsp ~= "" and (string.find(string.lower(p.Name), qTargetEsp) or string.find(string.lower(p.DisplayName), qTargetEsp)))
                    local isMatchSpec = (qSpectate ~= "" and (string.find(string.lower(p.Name), qSpectate) or string.find(string.lower(p.DisplayName), qSpectate)))

                    -- A. SPECTATE CAMERA
                    if spectateActive and isMatchSpec and tHum then
                        Camera.CameraSubject = tHum
                        spectateFound = true
                    end

                    -- B. LOGIKA ESP (GLOBAL ATAU TARGET)
                    if globalEspActive or (targetEspActive and isMatchEsp) then
                        local distance = myHrp and math.round((myHrp.Position - tHrp.Position).Magnitude) or 0
                        
                        local bill = tHrp:FindFirstChild("KayEsp_Bill")
                        if not bill then
                            bill = Instance.new("BillboardGui")
                            bill.Name = "KayEsp_Bill"
                            bill.Size = UDim2.new(0, 130, 0, 35)
                            bill.AlwaysOnTop = true
                            bill.ExtentsOffset = Vector3.new(0, 3, 0)
                            
                            local label = Instance.new("TextLabel", bill)
                            label.Name = "EspLabel"
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 10
                            label.TextStrokeTransparency = 0.5
                            bill.Parent = tHrp
                        end
                        
                        local lbl = bill:FindFirstChild("EspLabel")
                        if lbl then
                            lbl.Text = p.DisplayName .. "\n[" .. distance .. "m]"
                            lbl.TextColor3 = (targetEspActive and isMatchEsp) and CurrentTheme.AccentColor or Color3.fromRGB(255, 255, 255)
                        end

                        if targetEspActive and isMatchEsp then
                            local high = tChar:FindFirstChild("KayEsp_Highlight")
                            if not high then
                                high = Instance.new("Highlight", tChar)
                                high.Name = "KayEsp_Highlight"
                                high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            end
                            high.FillColor = CurrentTheme.AccentColor
                            high.FillTransparency = 0.6
                        else
                            if tChar:FindFirstChild("KayEsp_Highlight") then tChar.KayEsp_Highlight:Destroy() end
                        end
                    else
                        clearEsp(tChar)
                    end
                end
            end)
        end
    end

    if spectateActive and not spectateFound then
        pcall(function()
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myHum then Camera.CameraSubject = myHum end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(p) clearEsp(p.Character) end)

-- SET THEME DEFAULT
for _, item in pairs(AllUIElements) do
    if item.Obj and item.Obj.Parent then item.Obj[item.Prop] = CurrentTheme[item.Key] end
end

print("[SYSTEM] Kay Hub V9.6 Loaded Successfully.")
