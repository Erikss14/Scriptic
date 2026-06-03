--// Scriptic Hub v5 — Self-Contained UI
--// Press "=" to toggle visibility

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local TargetGui = Player:WaitForChild("PlayerGui")

pcall(function()
	if TargetGui:FindFirstChild("ScripticHub") then
		TargetGui.ScripticHub:Destroy()
	end
end)

shared.ScripticConfig = {
	AutoFarmLevel = false, AutoFarmMastery = false, FastAttack = false,
	MobAura = false, AutoNewWorld = false, AutoFarmBones = false,
	SilentAim = false, PlayerAimbot = false, InstantCombo = false,
	GodModeVisual = false, AutoClicker = false,
	FlyEnabled = false, NoclipEnabled = false, SpeedValue = 16,
	JumpValue = 50, InfiniteJump = false, WaterWalk = false,
	FruitSniper = false, FruitBringer = false, AutoBuyFruits = false,
	AutoRandomFruit = false, AutoRaid = false, KillWaves = false,
	AutoBuyChip = false, AutoFarmBosses = false, AutoAwaken = false,
	TweenSpeedValue = 250, PlayerESP = false, ChestESP = false,
	FruitESP = false, NPCESP = false, BossESP = false,
	TraceLines = false, AutoSave = false, AntiLag = false,
}

local T = {
	BG        = Color3.fromRGB(22, 22, 22),
	Sidebar   = Color3.fromRGB(28, 28, 28),
	Surface   = Color3.fromRGB(35, 35, 35),
	SurfaceHi = Color3.fromRGB(45, 45, 45),
	Accent    = Color3.fromRGB(0, 170, 255),
	Success   = Color3.fromRGB(0, 200, 120),
	Danger    = Color3.fromRGB(220, 70, 70),
	Text      = Color3.fromRGB(255, 255, 255),
	TextDim   = Color3.fromRGB(160, 160, 160),
}

--//////////////////////////////////////////////
-- SCREEN GUI
--//////////////////////////////////////////////
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScripticHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetGui

--//////////////////////////////////////////////
-- LOADING SCREEN
--//////////////////////////////////////////////
local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = T.BG
LoadFrame.BorderSizePixel = 0
LoadFrame.Parent = ScreenGui

local LoadLabel = Instance.new("TextLabel")
LoadLabel.Size = UDim2.new(1, 0, 1, 0)
LoadLabel.BackgroundTransparency = 1
LoadLabel.Text = "⏳  Loading Scriptic v5..."
LoadLabel.TextColor3 = T.Accent
LoadLabel.Font = Enum.Font.GothamBold
LoadLabel.TextSize = 22
LoadLabel.Parent = LoadFrame

task.spawn(function()
	while LoadFrame and LoadFrame.Parent do
		LoadLabel.Rotation = (LoadLabel.Rotation + 6) % 360
		task.wait(0.03)
	end
end)
task.wait(1.4)
LoadFrame:Destroy()

--//////////////////////////////////////////////
-- MAIN WINDOW
--//////////////////////////////////////////////
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 880, 0, 540)
Main.Position = UDim2.new(0.5, -440, 0.5, -270)
Main.BackgroundColor3 = T.BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Drag
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
Main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)

-- Hotkey
local menuVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.Equals then
		menuVisible = not menuVisible
		Main.Visible = menuVisible
	end
end)

--//////////////////////////////////////////////
-- TOASTS
--//////////////////////////////////////////////
local ToastHolder = Instance.new("Frame")
ToastHolder.Size = UDim2.new(0, 260, 0, 400)
ToastHolder.Position = UDim2.new(1, -270, 0, 10)
ToastHolder.BackgroundTransparency = 1
ToastHolder.Parent = Main

local ToastLayout = Instance.new("UIListLayout")
ToastLayout.Padding = UDim.new(0, 6)
ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastLayout.Parent = ToastHolder

local function Toast(msg)
	local f = Instance.new("TextLabel")
	f.Size = UDim2.new(0, 240, 0, 32)
	f.BackgroundColor3 = T.SurfaceHi
	f.Text = "  " .. msg
	f.TextColor3 = T.Text
	f.Font = Enum.Font.Gotham
	f.TextSize = 13
	f.TextXAlignment = Enum.TextXAlignment.Left
	f.BorderSizePixel = 0
	f.Parent = ToastHolder
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
	task.delay(3, function()
		TweenService:Create(f, TweenInfo.new(0.3), {
			BackgroundTransparency = 1,
			TextTransparency = 1
		}):Play()
		task.wait(0.35)
		f:Destroy()
	end)
end

--//////////////////////////////////////////////
-- SIDEBAR
--//////////////////////////////////////////////
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 75, 1, 0)
Sidebar.BackgroundColor3 = T.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 14)
SidePad.Parent = Sidebar

--//////////////////////////////////////////////
-- CONTENT AREA
--//////////////////////////////////////////////
local ContentArea = Instance.new("Frame")
ContentArea.Position = UDim2.new(0, 75, 0, 0)
ContentArea.Size = UDim2.new(1, -75, 1, 0)
ContentArea.BackgroundColor3 = T.Surface
ContentArea.BorderSizePixel = 0
ContentArea.Parent = Main
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 10)

local HeaderPad = Instance.new("UIPadding")
HeaderPad.PaddingTop = UDim.new(0, 14)
HeaderPad.PaddingLeft = UDim.new(0, 18)
HeaderPad.PaddingRight = UDim.new(0, 18)
HeaderPad.Parent = ContentArea

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundTransparency = 1
Header.Text = "Scriptic v5  —  AutoFarm"
Header.TextColor3 = T.Text
Header.Font = Enum.Font.GothamBold
Header.TextSize = 17
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = ContentArea

--//////////////////////////////////////////////
-- PAGE SYSTEM
--//////////////////////////////////////////////
local Pages = {}
local activePage = "AutoFarm"

local function MakePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, -18, 1, -50)
	page.Position = UDim2.new(0, 9, 0, 46)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = T.Accent
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = (name == "AutoFarm")
	page.Parent = ContentArea

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.Parent = page

	Pages[name] = page
	return page
end

local PageAutoFarm   = MakePage("AutoFarm")
local PageCombat     = MakePage("Combat & PvP")
local PageMovement   = MakePage("Movement Mods")
local PageFruitShop  = MakePage("Fruit & Store")
local PageRaids      = MakePage("Raids & Bosses")
local PageTeleports  = MakePage("Navigation")
local PageESP        = MakePage("Visual Profiles")
local PageSettings   = MakePage("Settings")

--//////////////////////////////////////////////
-- SIDEBAR NAV
--//////////////////////////////////////////////
local NavButtons = {}
local TabData = {
	{ name = "AutoFarm",       icon = "⚔️" },
	{ name = "Combat & PvP",   icon = "🥊" },
	{ name = "Movement Mods",  icon = "⚡" },
	{ name = "Fruit & Store",  icon = "🍎" },
	{ name = "Raids & Bosses", icon = "🏰" },
	{ name = "Navigation",     icon = "🌀" },
	{ name = "Visual Profiles",icon = "👁️" },
	{ name = "Settings",       icon = "⚙️" },
}

local function SwitchTab(name)
	Pages[activePage].Visible = false
	NavButtons[activePage].BackgroundColor3 = T.SurfaceHi
	activePage = name
	Pages[name].Visible = true
	NavButtons[name].BackgroundColor3 = T.Accent
	Header.Text = "Scriptic v5  —  " .. name
	Toast("Tab: " .. name)
end

for _, tab in ipairs(TabData) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 54, 0, 44)
	btn.BackgroundColor3 = tab.name == "AutoFarm" and T.Accent or T.SurfaceHi
	btn.Text = tab.icon
	btn.TextSize = 20
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = T.Text
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	NavButtons[tab.name] = btn
	btn.MouseButton1Click:Connect(function() SwitchTab(tab.name) end)
end

--//////////////////////////////////////////////
-- WIDGET BUILDERS
--//////////////////////////////////////////////
local function CreateHeader(page, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 0, 22)
	lbl.BackgroundTransparency = 1
	lbl.Text = "  • " .. string.upper(text)
	lbl.TextColor3 = T.Accent
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = page
end

local function CreateToggle(page, label, configKey)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 42)
	btn.BackgroundColor3 = T.SurfaceHi
	btn.Text = "  " .. label .. "  [OFF]"
	btn.TextColor3 = T.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = page
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		shared.ScripticConfig[configKey] = not shared.ScripticConfig[configKey]
		local on = shared.ScripticConfig[configKey]
		btn.BackgroundColor3 = on and T.Success or T.SurfaceHi
		btn.Text = "  " .. label .. (on and "  [ON]" or "  [OFF]")
		Toast(label .. (on and " → ON" or " → OFF"))
	end)
end

local function CreateButton(page, label, cb)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 42)
	btn.BackgroundColor3 = T.SurfaceHi
	btn.Text = "  " .. label
	btn.TextColor3 = T.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = page
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(cb)
end

local function CreateSlider(page, label, min, max, default, configKey)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 56)
	frame.BackgroundColor3 = T.SurfaceHi
	frame.BorderSizePixel = 0
	frame.Parent = page
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -20, 0, 22)
	lbl.Position = UDim2.new(0, 10, 0, 5)
	lbl.BackgroundTransparency = 1
	lbl.Text = label .. ":  " .. tostring(default)
	lbl.TextColor3 = T.Text
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = frame

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -20, 0, 6)
	track.Position = UDim2.new(0, 10, 0, 38)
	track.BackgroundColor3 = T.Surface
	track.BorderSizePixel = 0
	track.Parent = frame
	Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = T.Accent
	fill.BorderSizePixel = 0
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

	-- Draggable slider logic
	local sliding = false

	local function updateSlider(inputX)
		local trackPos = track.AbsolutePosition.X
		local trackWidth = track.AbsoluteSize.X
		local ratio = math.clamp((inputX - trackPos) / trackWidth, 0, 1)
		local value = math.floor(min + (max - min) * ratio)
		shared.ScripticConfig[configKey] = value
		fill.Size = UDim2.new(ratio, 0, 1, 0)
		lbl.Text = label .. ":  " .. tostring(value)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = true
			updateSlider(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = false
		end
	end)
end

--//////////////////////////////////////////////
-- TAB CONTENT
--//////////////////////////////////////////////

-- AUTOFARM
CreateHeader(PageAutoFarm, "Level Progression")
CreateToggle(PageAutoFarm, "Auto-Farm Quest Levels", "AutoFarmLevel")
CreateToggle(PageAutoFarm, "Auto-Farm Mastery (Sword / Fruit / Melee)", "AutoFarmMastery")
CreateToggle(PageAutoFarm, "Fast Attack", "FastAttack")
CreateToggle(PageAutoFarm, "Mob Aura", "MobAura")
CreateToggle(PageAutoFarm, "Auto-Farm Bones & Candy", "AutoFarmBones")
CreateToggle(PageAutoFarm, "Auto-Travel to Next Sea", "AutoNewWorld")

-- COMBAT
CreateHeader(PageCombat, "Combat Assistance")
CreateToggle(PageCombat, "Silent Aim", "SilentAim")
CreateToggle(PageCombat, "Camera Lock-On Aimbot", "PlayerAimbot")
CreateToggle(PageCombat, "Instant Combo Sequencer", "InstantCombo")
CreateToggle(PageCombat, "Auto-Clicker", "AutoClicker")
CreateToggle(PageCombat, "GodMode (Visual)", "GodModeVisual")

-- MOVEMENT
CreateHeader(PageMovement, "Movement Modifiers")
CreateToggle(PageMovement, "Fly", "FlyEnabled")
CreateToggle(PageMovement, "Noclip", "NoclipEnabled")
CreateToggle(PageMovement, "Infinite Jump", "InfiniteJump")
CreateToggle(PageMovement, "Walk on Water", "WaterWalk")
CreateSlider(PageMovement, "Walk Speed", 16, 250, 16, "SpeedValue")
CreateSlider(PageMovement, "Jump Power", 50, 300, 50, "JumpValue")

-- FRUIT & STORE
CreateHeader(PageFruitShop, "Fruit Tools")
CreateToggle(PageFruitShop, "Fruit Sniper (Auto-Grab Spawns)", "FruitSniper")
CreateToggle(PageFruitShop, "Fruit Bringer", "FruitBringer")
CreateToggle(PageFruitShop, "Auto-Buy Store Stock", "AutoBuyFruits")
CreateToggle(PageFruitShop, "Auto-Roll Random Fruit", "AutoRandomFruit")

-- RAIDS & BOSSES
CreateHeader(PageRaids, "Instance Clearing")
CreateToggle(PageRaids, "Auto-Raid Engine", "AutoRaid")
CreateToggle(PageRaids, "Instant Kill Waves", "KillWaves")
CreateToggle(PageRaids, "Auto-Buy Raid Chips", "AutoBuyChip")
CreateToggle(PageRaids, "Auto-Farm Bosses", "AutoFarmBosses")
CreateToggle(PageRaids, "Auto-Awaken Fruit", "AutoAwaken")

-- NAVIGATION
CreateHeader(PageTeleports, "Teleport Locations")
CreateSlider(PageTeleports, "Tween Speed", 100, 350, 250, "TweenSpeedValue")

CreateHeader(PageTeleports, "First Sea")
CreateButton(PageTeleports, "📍 Starter Island",      function() Toast("→ Starter Island") end)
CreateButton(PageTeleports, "📍 Marine Starter Base", function() Toast("→ Marine Starter Base") end)
CreateButton(PageTeleports, "📍 Jungle",              function() Toast("→ Jungle") end)
CreateButton(PageTeleports, "📍 Pirate Village",      function() Toast("→ Pirate Village") end)
CreateButton(PageTeleports, "📍 Desert",              function() Toast("→ Desert") end)
CreateButton(PageTeleports, "📍 Frozen Village",      function() Toast("→ Frozen Village") end)
CreateButton(PageTeleports, "📍 Marine Fortress",     function() Toast("→ Marine Fortress") end)
CreateButton(PageTeleports, "📍 Skylands",            function() Toast("→ Skylands") end)
CreateButton(PageTeleports, "📍 Prison",              function() Toast("→ Prison") end)
CreateButton(PageTeleports, "📍 Colosseum",           function() Toast("→ Colosseum") end)
CreateButton(PageTeleports, "📍 Magma Village",       function() Toast("→ Magma Village") end)
CreateButton(PageTeleports, "📍 Underwater City",     function() Toast("→ Underwater City") end)
CreateButton(PageTeleports, "📍 Upper Skylands",      function() Toast("→ Upper Skylands") end)
CreateButton(PageTeleports, "📍 Fountain City",       function() Toast("→ Fountain City") end)

CreateHeader(PageTeleports, "Second Sea")
CreateButton(PageTeleports, "📍 Kingdom of Rose",     function() Toast("→ Kingdom of Rose") end)
CreateButton(PageTeleports, "📍 Green Zone",          function() Toast("→ Green Zone") end)
CreateButton(PageTeleports, "📍 Graveyard",           function() Toast("→ Graveyard") end)
CreateButton(PageTeleports, "📍 Snow Mountain",       function() Toast("→ Snow Mountain") end)
CreateButton(PageTeleports, "📍 Hot and Cold",        function() Toast("→ Hot and Cold") end)
CreateButton(PageTeleports, "📍 Cursed Ship",         function() Toast("→ Cursed Ship") end)
CreateButton(PageTeleports, "📍 Ice Castle",          function() Toast("→ Ice Castle") end)
CreateButton(PageTeleports, "📍 Forgotten Island",    function() Toast("→ Forgotten Island") end)

CreateHeader(PageTeleports, "Third Sea")
CreateButton(PageTeleports, "📍 Port Town",           function() Toast("→ Port Town") end)
CreateButton(PageTeleports, "📍 Hydra Island",        function() Toast("→ Hydra Island") end)
CreateButton(PageTeleports, "📍 Great Tree",          function() Toast("→ Great Tree") end)
CreateButton(PageTeleports, "📍 Floating Turtle",     function() Toast("→ Floating Turtle") end)
CreateButton(PageTeleports, "📍 Haunted Castle",      function() Toast("→ Haunted Castle") end)
CreateButton(PageTeleports, "📍 Sea of Treats",       function() Toast("→ Sea of Treats") end)

-- VISUAL PROFILES (ESP)
CreateHeader(PageESP, "ESP Toggles")
CreateToggle(PageESP, "Player ESP",    "PlayerESP")
CreateToggle(PageESP, "NPC ESP",       "NPCESP")
CreateToggle(PageESP, "Boss ESP",      "BossESP")
CreateToggle(PageESP, "Fruit ESP",     "FruitESP")
CreateToggle(PageESP, "Chest ESP",     "ChestESP")
CreateToggle(PageESP, "Trace Lines",   "TraceLines")

-- SETTINGS
CreateHeader(PageSettings, "Configuration")
CreateToggle(PageSettings, "Auto-Save Config", "AutoSave")
CreateToggle(PageSettings, "Anti-Lag Mode",    "AntiLag")
CreateButton(PageSettings, "❌  Close Hub", function()
	Toast("Closing...")
	task.delay(0.3, function() ScreenGui:Destroy() end)
end)

print("[Scriptic v5]: UI loaded — Press '=' to toggle")
