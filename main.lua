```lua
--// Scriptic Hub (SELF-CONTAINED / NO ROACT / FULLY FIXED)
--// Clean Modern Roblox UI Framework
--// UI ONLY

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

--////////////////////////////////////////////////////////
-- CLEANUP
--////////////////////////////////////////////////////////

pcall(function()
	if CoreGui:FindFirstChild("ScripticHub") then
		CoreGui.ScripticHub:Destroy()
	end
end)

--////////////////////////////////////////////////////////
-- THEME
--////////////////////////////////////////////////////////

local Theme = {
	Background = Color3.fromRGB(22,22,22),
	Sidebar = Color3.fromRGB(28,28,28),
	Surface = Color3.fromRGB(35,35,35),
	SurfaceLight = Color3.fromRGB(45,45,45),

	Accent = Color3.fromRGB(0,170,255),
	Text = Color3.fromRGB(255,255,255),
	TextDim = Color3.fromRGB(180,180,180),

	Danger = Color3.fromRGB(220,70,70),
	Success = Color3.fromRGB(0,200,120)
}

--////////////////////////////////////////////////////////
-- SCREEN GUI
--////////////////////////////////////////////////////////

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScripticHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

--////////////////////////////////////////////////////////
-- LOADING SCREEN
--////////////////////////////////////////////////////////

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1,0,1,0)
LoadingFrame.BackgroundColor3 = Theme.Background
LoadingFrame.Parent = ScreenGui

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1,0,1,0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "⏳ Loading Scriptic..."
LoadingLabel.TextColor3 = Theme.Accent
LoadingLabel.Font = Enum.Font.GothamBold
LoadingLabel.TextSize = 22
LoadingLabel.Parent = LoadingFrame

task.spawn(function()
	while LoadingFrame.Parent do
		LoadingLabel.Rotation += 5
		task.wait(0.03)
	end
end)

task.wait(1.2)

LoadingFrame:Destroy()

--////////////////////////////////////////////////////////
-- MAIN WINDOW
--////////////////////////////////////////////////////////

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0,900,0,540)
Main.Position = UDim2.new(0.5,-450,0.5,-270)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

--////////////////////////////////////////////////////////
-- DRAGGING
--////////////////////////////////////////////////////////

local dragging = false
local dragStart
local startPos

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

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--////////////////////////////////////////////////////////
-- SIDEBAR
--////////////////////////////////////////////////////////

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,90,1,0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,10)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0,8)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0,10)
SidebarPadding.Parent = Sidebar

--////////////////////////////////////////////////////////
-- SEARCH BAR
--////////////////////////////////////////////////////////

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1,-12,0,34)
Search.BackgroundColor3 = Theme.Surface
Search.PlaceholderText = "Search..."
Search.Text = ""
Search.TextColor3 = Theme.Text
Search.PlaceholderColor3 = Theme.TextDim
Search.Font = Enum.Font.Gotham
Search.TextSize = 13
Search.BorderSizePixel = 0
Search.Parent = Sidebar

Instance.new("UICorner", Search).CornerRadius = UDim.new(0,8)

--////////////////////////////////////////////////////////
-- MAIN CONTENT
--////////////////////////////////////////////////////////

local ContentFrame = Instance.new("Frame")
ContentFrame.Position = UDim2.new(0,90,0,0)
ContentFrame.Size = UDim2.new(1,-90,1,0)
ContentFrame.BackgroundColor3 = Theme.Surface
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = Main

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0,20)
ContentPadding.PaddingLeft = UDim.new(0,20)
ContentPadding.PaddingRight = UDim.new(0,20)
ContentPadding.Parent = ContentFrame

Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Scriptic Hub"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = ContentFrame

--////////////////////////////////////////////////////////
-- PAGES
--////////////////////////////////////////////////////////

local Pages = {}

local function CreatePage(name)

	local Page = Instance.new("ScrollingFrame")
	Page.Name = name
	Page.Size = UDim2.new(1,0,1,-50)
	Page.Position = UDim2.new(0,0,0,50)
	Page.CanvasSize = UDim2.new(0,0,0,800)
	Page.ScrollBarThickness = 4
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = ContentFrame

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0,10)
	Layout.Parent = Page

	Pages[name] = Page

	return Page
end

local AutoFarmPage = CreatePage("AutoFarm")
local TeleportsPage = CreatePage("Teleports")
local FruitPage = CreatePage("Fruit")
local ESPPage = CreatePage("ESP")
local SettingsPage = CreatePage("Settings")

Pages.AutoFarm.Visible = true

--////////////////////////////////////////////////////////
-- TOASTS
--////////////////////////////////////////////////////////

local ToastHolder = Instance.new("Frame")
ToastHolder.Size = UDim2.new(0,260,1,-20)
ToastHolder.Position = UDim2.new(1,-270,0,10)
ToastHolder.BackgroundTransparency = 1
ToastHolder.Parent = Main

local ToastLayout = Instance.new("UIListLayout")
ToastLayout.Padding = UDim.new(0,6)
ToastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ToastLayout.Parent = ToastHolder

local function Toast(text)

	local ToastFrame = Instance.new("TextLabel")
	ToastFrame.Size = UDim2.new(0,240,0,34)
	ToastFrame.BackgroundColor3 = Theme.SurfaceLight
	ToastFrame.Text = text
	ToastFrame.TextColor3 = Theme.Text
	ToastFrame.Font = Enum.Font.Gotham
	ToastFrame.TextSize = 13
	ToastFrame.BorderSizePixel = 0
	ToastFrame.Parent = ToastHolder

	Instance.new("UICorner", ToastFrame).CornerRadius = UDim.new(0,6)

	TweenService:Create(
		ToastFrame,
		TweenInfo.new(0.2),
		{BackgroundTransparency = 0}
	):Play()

	task.delay(3,function()

		local tween = TweenService:Create(
			ToastFrame,
			TweenInfo.new(0.2),
			{
				BackgroundTransparency = 1,
				TextTransparency = 1
			}
		)

		tween:Play()

		tween.Completed:Wait()

		ToastFrame:Destroy()
	end)
end

--////////////////////////////////////////////////////////
-- UI COMPONENTS
--////////////////////////////////////////////////////////

local function CreateToggle(parent,text)

	local State = false

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-10,0,44)
	Button.BackgroundColor3 = Theme.SurfaceLight
	Button.Text = text .. " : OFF"
	Button.TextColor3 = Theme.Text
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.BorderSizePixel = 0
	Button.Parent = parent

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,8)

	Button.MouseButton1Click:Connect(function()

		State = not State

		Button.Text = text .. " : " .. (State and "ON" or "OFF")

		Button.BackgroundColor3 = State and Theme.Accent or Theme.SurfaceLight

		print("[Scriptic]: " .. text .. " toggled")

		Toast(text .. " -> " .. (State and "Enabled" or "Disabled"))
	end)

	return Button
end

local function CreateButton(parent,text,color,callback)

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-10,0,42)
	Button.BackgroundColor3 = color or Theme.Accent
	Button.Text = text
	Button.TextColor3 = Theme.Text
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.BorderSizePixel = 0
	Button.Parent = parent

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,8)

	Button.MouseButton1Click:Connect(function()
		print("[Scriptic]: " .. text)
		Toast(text)

		if callback then
			callback()
		end
	end)

	return Button
end

--////////////////////////////////////////////////////////
-- CONTENT
--////////////////////////////////////////////////////////

CreateToggle(AutoFarmPage,"Auto Farm")
CreateToggle(AutoFarmPage,"Quest Farm")
CreateToggle(AutoFarmPage,"Boss Farm")
CreateToggle(AutoFarmPage,"Mastery Farm")

CreateButton(TeleportsPage,"Teleport: Starter Island")
CreateButton(TeleportsPage,"Teleport: Jungle")
CreateButton(TeleportsPage,"Teleport: Desert")

CreateToggle(FruitPage,"Fruit Notifier")
CreateToggle(FruitPage,"Fruit Sniper")

CreateToggle(ESPPage,"Player ESP")
CreateToggle(ESPPage,"Chest ESP")
CreateToggle(ESPPage,"NPC ESP")

CreateButton(
	SettingsPage,
	"Close Scriptic",
	Theme.Danger,
	function()
		ScreenGui:Destroy()
	end
)

--////////////////////////////////////////////////////////
-- TAB BUTTONS
--////////////////////////////////////////////////////////

local Tabs = {
	{ Name = "AutoFarm", Icon = "⚔️" },
	{ Name = "Teleports", Icon = "🌀" },
	{ Name = "Fruit", Icon = "🍎" },
	{ Name = "ESP", Icon = "👁️" },
	{ Name = "Settings", Icon = "⚙️" }
}

local function SwitchTab(name)

	for PageName, Page in pairs(Pages) do
		Page.Visible = (PageName == name)
	end

	Title.Text = "Scriptic Hub — " .. name

	Toast("Opened " .. name)
end

for _,Tab in ipairs(Tabs) do

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1,-12,0,42)
	Button.BackgroundColor3 = Theme.Surface
	Button.Text = Tab.Icon
	Button.TextColor3 = Theme.Text
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 20
	Button.BorderSizePixel = 0
	Button.Parent = Sidebar

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,8)

	Button.MouseButton1Click:Connect(function()
		SwitchTab(Tab.Name)
	end)
end

--////////////////////////////////////////////////////////
-- SEARCH FILTER
--////////////////////////////////////////////////////////

Search:GetPropertyChangedSignal("Text"):Connect(function()

	local Query = string.lower(Search.Text)

	for _,Child in ipairs(Sidebar:GetChildren()) do

		if Child:IsA("TextButton") then

			local Match = false

			for _,Tab in ipairs(Tabs) do
				if Child.Text == Tab.Icon then
					if string.find(string.lower(Tab.Name), Query) then
						Match = true
					end
				end
			end

			Child.Visible = Match or Query == ""
		end
	end
end)

print("[Scriptic]: Fully Loaded")
```
