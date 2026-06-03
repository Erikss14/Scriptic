--// Scriptic Hub — Self-Contained, No Dependencies
--// Pure Instance.new() build — no Roact, no HttpGet, no loadstring

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

--// Cleanup
pcall(function()
	if CoreGui:FindFirstChild("ScripticHub") then
		CoreGui.ScripticHub:Destroy()
	end
end)

--// Config
shared.ScripticConfig = {
	AutoFarm  = false,
	PlayerESP = false,
	ChestESP  = false,
	FruitESP  = false,
	AutoSave  = false,
}

--// Theme
local T = {
	BG          = Color3.fromRGB(22, 22, 22),
	Sidebar     = Color3.fromRGB(28, 28, 28),
	Surface     = Color3.fromRGB(35, 35, 35),
	SurfaceHi   = Color3.fromRGB(45, 45, 45),
	Accent      = Color3.fromRGB(0, 170, 255),
	Success     = Color3.fromRGB(0, 200, 120),
	Danger      = Color3.fromRGB(220, 70, 70),
	Text        = Color3.fromRGB(255, 255, 255),
	TextDim     = Color3.fromRGB(160, 160, 160),
}

--//////////////////////////////////////////////
-- SCREEN GUI
--//////////////////////////////////////////////
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScripticHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

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
LoadLabel.Text = "⏳  Loading Scriptic..."
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
Main.Size = UDim2.new(0, 860, 0, 520)
Main.Position = UDim2.new(0.5, -430, 0.5, -260)
Main.BackgroundColor3 = T.BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--// Drag
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

--//////////////////////////////////////////////
-- TOAST NOTIFICATIONS
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
SideLayout.Padding = UDim.new(0, 8)
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
Header.Text = "Scriptic  —  AutoFarm"
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
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.Parent = page

	Pages[name] = page
	return page
end

local PageAutoFarm  = MakePage("AutoFarm")
local PageTeleports = MakePage("Teleports")
local PageFruit     = MakePage("Fruit")
local PageESP       = MakePage("ESP")
local PageSettings  = MakePage("Settings")

--//////////////////////////////////////////////
-- SIDEBAR NAV BUTTONS
--//////////////////////////////////////////////
local NavButtons = {}

local TabData = {
	{ name = "AutoFarm",  icon = "⚔️"  },
	{ name = "Teleports", icon = "🌀"  },
	{ name = "Fruit",     icon = "🍎"  },
	{ name = "ESP",       icon = "👁️"  },
	{ name = "Settings",  icon = "⚙️"  },
}

local function SwitchTab(name)
	Pages[activePage].Visible = false
	NavButtons[activePage].BackgroundColor3 = T.SurfaceHi

	activePage = name
	Pages[name].Visible = true
	NavButtons[name].BackgroundColor3 = T.Accent
	Header.Text = "Scriptic  —  " .. name
	Toast("Switched to " .. name)
end

for _, tab in ipairs(TabData) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 52, 0, 48)
	btn.BackgroundColor3 = tab.name == "AutoFarm" and T.Accent or T.SurfaceHi
	btn.Text = tab.icon
	btn.TextSize = 22
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = T.Text
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	NavButtons[tab.name] = btn

	btn.MouseButton1Click:Connect(function()
		SwitchTab(tab.name)
	end)
end

--//////////////////////////////////////////////
-- WIDGET BUILDERS
--//////////////////////////////////////////////

-- Section label
local function AddSection(page, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 22)
	lbl.BackgroundTransparency = 1
	lbl.Text = "  " .. string.upper(text)
	lbl.TextColor3 = T.Accent
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = page
end

-- Toggle
local function AddToggle(page, label, configKey)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 44)
	btn.BackgroundColor3 = T.SurfaceHi
	btn.Text = "  " .. label .. "   [OFF]"
	btn.TextColor3 = T.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = page
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

	btn.MouseButton1Click:Connect(function()
		shared.ScripticConfig[configKey] = not shared.ScripticConfig[configKey]
		local on = shared.ScripticConfig[configKey]
		btn.BackgroundColor3 = on and T.Success or T.SurfaceHi
		btn.Text = "  " .. label .. (on and "   [ON]" or "   [OFF]")
		Toast(label .. (on and " → ON" or " → OFF"))
	end)
end

-- Action button
local function AddButton(page, label, cb)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 44)
	btn.BackgroundColor3 = T.SurfaceHi
	btn.Text = "  " .. label
	btn.TextColor3 = T.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = page
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

	btn.MouseButton1Click:Connect(cb)
end

-- Info card (for fruit stats etc.)
local function AddCard(page, title, body)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 60)
	frame.BackgroundColor3 = T.SurfaceHi
	frame.BorderSizePixel = 0
	frame.Parent = page
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingTop = UDim.new(0, 8)
	pad.Parent = frame

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -12, 0, 22)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = T.Text
	t.Font = Enum.Font.GothamBold
	t.TextSize = 14
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = frame

	local b = Instance.new("TextLabel")
	b.Size = UDim2.new(1, -12, 0, 18)
	b.Position = UDim2.new(0, 0, 0, 26)
	b.BackgroundTransparency = 1
	b.Text = body
	b.TextColor3 = T.TextDim
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Parent = frame
end

--//////////////////////////////////////////////
-- TAB CONTENT
--//////////////////////////////////////////////

-- ── AUTOFARM ──────────────────────────────
AddSection(PageAutoFarm, "Farm Controls")
AddToggle(PageAutoFarm, "Auto-Farm",   "AutoFarm")
AddToggle(PageAutoFarm, "Auto-Save",   "AutoSave")

AddSection(PageAutoFarm, "Background Loop (read-only status)")
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 32)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "  Loop: Idle"
statusLabel.TextColor3 = T.TextDim
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = PageAutoFarm

-- Background loop updates status label
task.spawn(function()
	while true do
		task.wait(0.5)
		if shared.ScripticConfig.AutoFarm then
			local char = Player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				statusLabel.Text = "  Loop: ✅ Running — Pos: " ..
					math.floor(root.Position.X) .. ", " ..
					math.floor(root.Position.Y) .. ", " ..
					math.floor(root.Position.Z)
				statusLabel.TextColor3 = T.Success
			else
				statusLabel.Text = "  Loop: ⚠️ Waiting for character..."
				statusLabel.TextColor3 = T.Danger
			end
		else
			statusLabel.Text = "  Loop: Idle"
			statusLabel.TextColor3 = T.TextDim
		end
	end
end)

-- ── TELEPORTS ─────────────────────────────
AddSection(PageTeleports, "Starter Sea (Sea 1)")
AddButton(PageTeleports, "📍 Starter Island",     function() Toast("→ Starter Island") end)
AddButton(PageTeleports, "📍 Marine Starter Base", function() Toast("→ Marine Starter Base") end)
AddButton(PageTeleports, "📍 Jungle",              function() Toast("→ Jungle") end)
AddButton(PageTeleports, "📍 Pirate Village",      function() Toast("→ Pirate Village") end)
AddButton(PageTeleports, "📍 Desert",              function() Toast("→ Desert") end)
AddButton(PageTeleports, "📍 Frozen Village",      function() Toast("→ Frozen Village") end)
AddButton(PageTeleports, "📍 Marine Fortress",     function() Toast("→ Marine Fortress") end)
AddButton(PageTeleports, "📍 Skylands",            function() Toast("→ Skylands") end)
AddButton(PageTeleports, "📍 Prison",              function() Toast("→ Prison") end)
AddButton(PageTeleports, "📍 Colosseum",           function() Toast("→ Colosseum") end)
AddButton(PageTeleports, "📍 Magma Village",       function() Toast("→ Magma Village") end)
AddButton(PageTeleports, "📍 Underwater City",     function() Toast("→ Underwater City") end)
AddButton(PageTeleports, "📍 Upper Skylands",      function() Toast("→ Upper Skylands") end)
AddButton(PageTeleports, "📍 Fountain City",       function() Toast("→ Fountain City") end)

AddSection(PageTeleports, "New World (Sea 2)")
AddButton(PageTeleports, "📍 Kingdom of Rose",     function() Toast("→ Kingdom of Rose") end)
AddButton(PageTeleports, "📍 Green Zone",          function() Toast("→ Green Zone") end)
AddButton(PageTeleports, "📍 Graveyard",           function() Toast("→ Graveyard") end)
AddButton(PageTeleports, "📍 Snow Mountain",       function() Toast("→ Snow Mountain") end)
AddButton(PageTeleports, "📍 Hot and Cold",        function() Toast("→ Hot and Cold") end)
AddButton(PageTeleports, "📍 Cursed Ship",         function() Toast("→ Cursed Ship") end)
AddButton(PageTeleports, "📍 Ice Castle",          function() Toast("→ Ice Castle") end)
AddButton(PageTeleports, "📍 Forgotten Island",    function() Toast("→ Forgotten Island") end)
AddButton(PageTeleports, "📍 Flower Hill",         function() Toast("→ Flower Hill") end)

AddSection(PageTeleports, "Third Sea (Sea 3)")
AddButton(PageTeleports, "📍 Port Town",           function() Toast("→ Port Town") end)
AddButton(PageTeleports, "📍 Hydra Island",        function() Toast("→ Hydra Island") end)
AddButton(PageTeleports, "📍 Great Tree",          function() Toast("→ Great Tree") end)
AddButton(PageTeleports, "📍 Floating Turtle",     function() Toast("→ Floating Turtle") end)
AddButton(PageTeleports, "📍 Haunted Castle",      function() Toast("→ Haunted Castle") end)
AddButton(PageTeleports, "📍 Sea of Treats",       function() Toast("→ Sea of Treats") end)
AddButton(PageTeleports, "📍 Tiki Outpost",        function() Toast("→ Tiki Outpost") end)

-- ── FRUIT ─────────────────────────────────
AddSection(PageFruit, "Common Fruits")
AddCard(PageFruit, "🍑 Spin",       "Type: Common  |  Price: $1,000  |  Abilities: Spin attacks")
AddCard(PageFruit, "💧 Chop",       "Type: Common  |  Price: $30,000  |  Abilities: Sword immunity")
AddCard(PageFruit, "🌊 Spike",      "Type: Common  |  Price: $7,500  |  Abilities: Spike projectiles")
AddCard(PageFruit, "🔥 Flame",      "Type: Common  |  Price: $250,000  |  Abilities: Fire attacks")
AddCard(PageFruit, "💨 Smoke",      "Type: Common  |  Price: $100,000  |  Abilities: Smoke cloud")
AddCard(PageFruit, "🍓 Bomb",       "Type: Common  |  Price: $5,000  |  Abilities: Explosion throws")

AddSection(PageFruit, "Uncommon / Rare Fruits")
AddCard(PageFruit, "❄️ Ice",        "Type: Uncommon  |  Price: $350,000  |  Abilities: Freeze enemies")
AddCard(PageFruit, "🌊 Quake",      "Type: Rare  |  Price: $1,000,000  |  Abilities: Shockwave, AoE")
AddCard(PageFruit, "🌑 Dark",       "Type: Rare  |  Price: $500,000  |  Abilities: Black hole pull")
AddCard(PageFruit, "💡 Light",      "Type: Rare  |  Price: $650,000  |  Abilities: Speed, laser beam")
AddCard(PageFruit, "🪨 Sand",       "Type: Uncommon  |  Price: $420,000  |  Abilities: Desert storms")
AddCard(PageFruit, "🍄 Rubber",     "Type: Uncommon  |  Price: $750,000  |  Abilities: Gun immunity")

AddSection(PageFruit, "Legendary / Mythical Fruits")
AddCard(PageFruit, "🌸 Blizzard",   "Type: Legendary  |  Price: $2.5M  |  Abilities: Blizzard AoE")
AddCard(PageFruit, "⚡ Thunder",    "Type: Legendary  |  Price: $2.5M  |  Abilities: Lightning rush")
AddCard(PageFruit, "🌀 Venom",      "Type: Legendary  |  Price: $3M  |  Abilities: Poison mist, DoT")
AddCard(PageFruit, "💎 Dragon",     "Type: Mythical  |  Price: $3.5M  |  Abilities: Dragon transform")
AddCard(PageFruit, "🌊 Leopard",    "Type: Mythical  |  Price: $5M  |  Abilities: Predator form")
AddCard(PageFruit, "⚫ Kitsune",    "Type: Mythical  |  Price: $4M  |  Abilities: Fox spirit form")
AddCard(PageFruit, "🔱 Dough",      "Type: Legendary  |  Price: $2.8M  |  Abilities: Dough shield, DoT")
AddCard(PageFruit, "🕶️ Shadow",    "Type: Legendary  |  Price: $2.9M  |  Abilities: Nightmare mode")
AddCard(PageFruit, "🌟 Mammoth",    "Type: Mythical  |  Price: $5M  |  Abilities: Mammoth transform")

-- ── ESP ───────────────────────────────────
AddSection(PageESP, "Visibility Toggles")
AddToggle(PageESP, "Player ESP",     "PlayerESP")
AddToggle(PageESP, "Chest ESP",      "ChestESP")
AddToggle(PageESP, "Fruit ESP",      "FruitESP")

AddSection(PageESP, "Note")
local espNote = Instance.new("TextLabel")
espNote.Size = UDim2.new(1, 0, 0, 50)
espNote.BackgroundTransparency = 1
espNote.Text = "  ESP toggles are wired to shared.ScripticConfig.\n  Connect your rendering logic to those flags."
espNote.TextColor3 = T.TextDim
espNote.Font = Enum.Font.Gotham
espNote.TextSize = 12
espNote.TextXAlignment = Enum.TextXAlignment.Left
espNote.TextWrapped = true
espNote.Parent = PageESP

-- ── SETTINGS ──────────────────────────────
AddSection(PageSettings, "Configuration")
AddToggle(PageSettings, "Auto-Save Config", "AutoSave")

AddSection(PageSettings, "Keybind")
local keybindLabel = Instance.new("TextLabel")
keybindLabel.Size = UDim2.new(1, 0, 0, 32)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "  Press  [ RightShift ]  to toggle hub visibility"
keybindLabel.TextColor3 = T.TextDim
keybindLabel.Font = Enum.Font.Gotham
keybindLabel.TextSize = 13
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
keybindLabel.Parent = PageSettings

AddSection(PageSettings, "Window")
AddButton(PageSettings, "❌  Close Scriptic Hub", function()
	Toast("Closing hub...")
	task.delay(0.4, function()
		ScreenGui:Destroy()
	end)
end)

--//////////////////////////////////////////////
-- KEYBIND: RightShift toggles hub
--//////////////////////////////////////////////
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		Main.Visible = not Main.Visible
	end
end)

print("[Scriptic]: Hub loaded — RightShift to toggle")
