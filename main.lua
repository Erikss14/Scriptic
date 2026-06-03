```lua
--// Scriptic UI v4 (Roact - Fully Fixed UI Framework)
--// UI ONLY - No gameplay automation or exploit systems

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Roact Loader
local RoactSource = game:HttpGet(
	"https://raw.githubusercontent.com/Roblox/roact/master/src/init.lua"
)

local Roact = loadstring(RoactSource)()

--// Cleanup old UI
local old = PlayerGui:FindFirstChild("ScripticV4")
if old then
	old:Destroy()
end

--// Theme
local Theme = {
	Background = Color3.fromRGB(22, 22, 22),
	Sidebar = Color3.fromRGB(28, 28, 28),
	Surface = Color3.fromRGB(35, 35, 35),
	SurfaceLight = Color3.fromRGB(45, 45, 45),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(180, 180, 180),
	Danger = Color3.fromRGB(220, 70, 70)
}

local Icons = {
	AutoFarm = "⚔️",
	Teleports = "🌀",
	Fruit = "🍎",
	ESP = "👁️",
	Settings = "⚙️"
}

--////////////////////////////////////////////////////////

local ScripticApp = Roact.Component:extend("ScripticApp")

function ScripticApp:init()
	self.mainRef = Roact.createRef()

	self:setState({
		tab = "AutoFarm",
		search = "",
		loading = true,
		spinner = 0,
		toasts = {},
		tooltip = nil,

		autoFarm = false,
		slider = 50,
		dropdown = "Default",
		dropdownOpen = false
	})
end

--////////////////////////////////////////////////////////
-- Toasts
--////////////////////////////////////////////////////////

function ScripticApp:pushToast(text)
	local id = tick()

	local toasts = table.clone(self.state.toasts)

	table.insert(toasts, {
		id = id,
		text = text
	})

	self:setState({
		toasts = toasts
	})

	task.delay(3, function()
		local filtered = {}

		for _, toast in ipairs(self.state.toasts) do
			if toast.id ~= id then
				table.insert(filtered, toast)
			end
		end

		self:setState({
			toasts = filtered
		})
	end)
end

--////////////////////////////////////////////////////////
-- Loading Spinner
--////////////////////////////////////////////////////////

function ScripticApp:didMount()

	-- Loading Animation
	task.spawn(function()
		while self.state.loading do
			self:setState({
				spinner = (self.state.spinner + 12) % 360
			})

			task.wait(0.03)
		end
	end)

	task.delay(1.5, function()
		self:setState({
			loading = false
		})
	end)

	-- Draggable
	local frame = self.mainRef:getValue()

	if frame then
		local dragging = false
		local dragStart
		local startPos

		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
			end
		end)

		frame.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart

				frame.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)
	end
end

--////////////////////////////////////////////////////////
-- Helpers
--////////////////////////////////////////////////////////

function ScripticApp:setTab(tab)
	self:setState({
		tab = tab
	})

	self:pushToast("Opened " .. tab)
end

function ScripticApp:isVisible(tab)
	if self.state.search == "" then
		return true
	end

	return string.find(
		string.lower(tab),
		string.lower(self.state.search)
	) ~= nil
end

--////////////////////////////////////////////////////////
-- Components
--////////////////////////////////////////////////////////

function ScripticApp:SidebarButton(tab)

	if not self:isVisible(tab) then
		return nil
	end

	local active = self.state.tab == tab

	return Roact.createElement("TextButton", {
		Size = UDim2.new(1, -12, 0, 42),
		BackgroundColor3 = active and Theme.Accent or Theme.Surface,
		Text = Icons[tab],
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		BorderSizePixel = 0,

		[Roact.Event.Activated] = function()
			self:setTab(tab)
		end,

		[Roact.Event.MouseEnter] = function()
			self:setState({
				tooltip = tab
			})
		end,

		[Roact.Event.MouseLeave] = function()
			self:setState({
				tooltip = nil
			})
		end

	}, {

		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		})
	})
end

function ScripticApp:SearchBar()
	return Roact.createElement("TextBox", {
		Size = UDim2.new(1, -12, 0, 34),
		BackgroundColor3 = Theme.Surface,
		Text = self.state.search,
		PlaceholderText = "Search...",
		TextColor3 = Theme.Text,
		PlaceholderColor3 = Theme.TextDim,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		BorderSizePixel = 0,

		[Roact.Change.Text] = function(rbx)
			self:setState({
				search = rbx.Text
			})
		end

	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		})
	})
end

function ScripticApp:Toggle(label, stateKey)

	local enabled = self.state[stateKey]

	return Roact.createElement("TextButton", {
		Size = UDim2.new(1, -10, 0, 44),
		BackgroundColor3 = enabled and Theme.Accent or Theme.Surface,
		Text = label .. " : " .. (enabled and "ON" or "OFF"),
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		BorderSizePixel = 0,

		[Roact.Event.Activated] = function()

			local newState = not enabled

			self:setState({
				[stateKey] = newState
			})

			self:pushToast(label .. " -> " .. (newState and "Enabled" or "Disabled"))
		end

	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		})
	})
end

function ScripticApp:Slider()

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, -10, 0, 60),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0
	}, {

		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),

		Label = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 25),
			Text = "Slider Value : " .. self.state.slider,
			BackgroundTransparency = 1,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13
		}),

		Bar = Roact.createElement("Frame", {
			Size = UDim2.new(0.9, 0, 0, 6),
			Position = UDim2.new(0.05, 0, 0.65, 0),
			BackgroundColor3 = Theme.SurfaceLight,
			BorderSizePixel = 0
		}, {

			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),

			Fill = Roact.createElement("Frame", {
				Size = UDim2.new(self.state.slider / 100, 0, 1, 0),
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0
			}, {

				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				})
			})
		})
	})
end

function ScripticApp:Dropdown()

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, -10, 0, self.state.dropdownOpen and 110 or 42),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0
	}, {

		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),

		Button = Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 42),
			Text = "Dropdown : " .. self.state.dropdown,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			BackgroundTransparency = 1,

			[Roact.Event.Activated] = function()
				self:setState({
					dropdownOpen = not self.state.dropdownOpen
				})
			end

		}),

		Options = self.state.dropdownOpen and Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 60),
			Position = UDim2.new(0, 0, 0, 45),
			BackgroundTransparency = 1
		}, {

			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 4)
			}),

			Default = Roact.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, 26),
				Text = "Default",
				TextColor3 = Theme.Text,
				BackgroundColor3 = Theme.SurfaceLight,
				BorderSizePixel = 0,

				[Roact.Event.Activated] = function()
					self:setState({
						dropdown = "Default",
						dropdownOpen = false
					})
				end

			}),

			Advanced = Roact.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, 26),
				Text = "Advanced",
				TextColor3 = Theme.Text,
				BackgroundColor3 = Theme.SurfaceLight,
				BorderSizePixel = 0,

				[Roact.Event.Activated] = function()
					self:setState({
						dropdown = "Advanced",
						dropdownOpen = false
					})
				end

			})
		})
	})
end

function ScripticApp:Tooltip()

	if not self.state.tooltip then
		return nil
	end

	return Roact.createElement("TextLabel", {
		Size = UDim2.new(0, 140, 0, 28),
		Position = UDim2.new(0, 85, 0, 10),
		BackgroundColor3 = Theme.Surface,
		Text = self.state.tooltip,
		TextColor3 = Theme.Text,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		BorderSizePixel = 0
	}, {

		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6)
		})
	})
end

function ScripticApp:Toasts()

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 6),
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}

	for i, toast in ipairs(self.state.toasts) do

		children["Toast_" .. i] = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 240, 0, 34),
			BackgroundColor3 = Theme.Surface,
			Text = toast.text,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			BorderSizePixel = 0
		}, {

			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6)
			})
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 260, 1, -20),
		Position = UDim2.new(1, -270, 0, 10),
		BackgroundTransparency = 1
	}, children)
end

--////////////////////////////////////////////////////////
-- Pages
--////////////////////////////////////////////////////////

function ScripticApp:Content()

	if self.state.tab == "AutoFarm" then

		return Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, -10, 1, -10),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 300),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 4
		}, {

			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 10)
			}),

			Toggle = self:Toggle("Auto Farm", "autoFarm"),
			Slider = self:Slider(),
			Dropdown = self:Dropdown()
		})
	end

	if self.state.tab == "Settings" then

		return Roact.createElement("TextButton", {
			Size = UDim2.new(0, 220, 0, 42),
			BackgroundColor3 = Theme.Danger,
			Text = "Close Scriptic",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			BorderSizePixel = 0,

			[Roact.Event.Activated] = function()

				self:pushToast("Closing UI...")

				task.delay(0.3, function()
					if self._handle then
						Roact.unmount(self._handle)
					end
				end)
			end

		}, {

			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		})
	end

	return Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 30),
		Text = self.state.tab .. " Page",
		TextColor3 = Theme.TextDim,
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})
end

--////////////////////////////////////////////////////////
-- Loading
--////////////////////////////////////////////////////////

function ScripticApp:Loading()

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Theme.Background
	}, {

		Spinner = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = "⏳ Loading Scriptic...",
			Rotation = self.state.spinner,
			BackgroundTransparency = 1,
			TextColor3 = Theme.Accent,
			Font = Enum.Font.GothamBold,
			TextSize = 20
		})
	})
end

--////////////////////////////////////////////////////////
-- Render
--////////////////////////////////////////////////////////

function ScripticApp:render()

	if self.state.loading then
		return self:Loading()
	end

	return Roact.createElement("Frame", {

		[Roact.Ref] = self.mainRef,

		Size = UDim2.new(0, 900, 0, 540),
		Position = UDim2.new(0.5, -450, 0.5, -270),

		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Active = true

	}, {

		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 10)
		}),

		Sidebar = Roact.createElement("Frame", {
			Size = UDim2.new(0, 90, 1, 0),
			BackgroundColor3 = Theme.Sidebar,
			BorderSizePixel = 0
		}, {

			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 8),
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),

			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10)
			}),

			Search = self:SearchBar(),

			AutoFarm = self:SidebarButton("AutoFarm"),
			Teleports = self:SidebarButton("Teleports"),
			Fruit = self:SidebarButton("Fruit"),
			ESP = self:SidebarButton("ESP"),
			Settings = self:SidebarButton("Settings")
		}),

		Main = Roact.createElement("Frame", {
			Position = UDim2.new(0, 90, 0, 0),
			Size = UDim2.new(1, -90, 1, 0),
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0
		}, {

			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20)
			}),

			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 12)
			}),

			Title = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 24),
				Text = "Scriptic Hub — " .. self.state.tab,
				TextColor3 = Theme.Text,
				Font = Enum.Font.GothamBold,
				TextSize = 18,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			}),

			Content = self:Content()
		}),

		Tooltip = self:Tooltip(),
		Toasts = self:Toasts()
	})
end

--////////////////////////////////////////////////////////
-- Mount
--////////////////////////////////////////////////////////

local handle = Roact.mount(
	Roact.createElement(ScripticApp),
	PlayerGui,
	"ScripticV4"
)

print("[Scriptic]: UI v4 Loaded")
```
