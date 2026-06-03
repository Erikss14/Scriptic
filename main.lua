--// Scriptic UI v3 (Roact - INTERNET BOOTSTRAPPED EDITION)
--// Automatically fetches the Roact engine from the cloud to prevent ReplicatedStorage errors.

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- STEP 1: DOWNLOAD ROACT FROM THE INTERNET DYNAMICALLY
local success, RoactSource = pcall(function()
    -- FIXED LINK: Points directly to the actual raw repository source file for Roact
    return game:HttpGet("https://githubusercontent.com")
end)

if not success or not RoactSource then
    error("[Scriptic Error]: Failed to fetch the core Roact engine from the cloud. Execution halted.")
end

-- Translate the plain internet text into a live executable module
local function loadModule(source)
    local func, err = loadstring(source)
    if not func then error("[Scriptic Engine Error]: " .. tostring(err)) end
    return func()
end

local Roact = loadModule(RoactSource)

-- STEP 2: YOUR SCRIPTIC APP LOGIC
local ScripticApp = Roact.Component:extend("ScripticApp")

local Icons = {
	AutoFarm = "⚔️",
	Teleports = "🌀",
	Fruit = "🍎",
	ESP = "👁️",
	Settings = "⚙️"
}

function ScripticApp:init()
	self:setState({
		tab = "AutoFarm",
		loading = true,
		search = "",
		toasts = {},
		hoverTip = nil,
		spinnerAngle = 0,
		autoFarmEnabled = false
	})
end

--// Spinner animation loop
function ScripticApp:didMount()
	task.spawn(function()
		while self.state.loading do
			self:setState({
				spinnerAngle = (self.state.spinnerAngle + 10) % 360
			})
			task.wait(0.03)
		end
	end)

	task.delay(1.5, function()
		self:setState({ loading = false })
	end)
end

--// Toast system
function ScripticApp:pushToast(text)
	local toasts = table.clone(self.state.toasts)

	table.insert(toasts, {
		id = tick(),
		text = text
	})

	self:setState({ toasts = toasts })

	task.delay(2.5, function()
		local new = {}
		for _, t in ipairs(self.state.toasts) do
			if t.id ~= toasts[#toasts].id then
				table.insert(new, t)
			end
		end
		self:setState({ toasts = new })
	end)
end

function ScripticApp:setTab(tab)
	self:setState({ tab = tab })
	self:pushToast("Opened " .. tab)
end

--// SEARCH FILTER
function ScripticApp:isVisible(tab)
	if self.state.search == "" then
		return true
	end
	return string.find(string.lower(tab), string.lower(self.state.search)) ~= nil
end

--// TOOLTIP
function ScripticApp:Tooltip(text)
	if not text then return nil end

	return Roact.createElement("TextLabel", {
		Size = UDim2.new(0, 200, 0, 28),
		Position = UDim2.new(1, 8, 0, 0),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		Text = text,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		BorderSizePixel = 0
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6)
		})
	})
end

--// SIDEBAR BUTTON
function ScripticApp:SidebarButton(tab)
	local active = self.state.tab == tab

	if not self:isVisible(tab) then
		return nil
	end

	return Roact.createElement("TextButton", {
		Size = UDim2.new(1, -10, 0, 40),
		BackgroundColor3 = active and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 35),
		Text = Icons[tab],
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,

		[Roact.Event.MouseEnter] = function()
			self:setState({ hoverTip = tab })
		end,

		[Roact.Event.MouseLeave] = function()
			self:setState({ hoverTip = nil })
		end,

		[Roact.Event.Activated] = function()
			self:setTab(tab)
		end
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6)
		})
	})
end

--// SEARCH BAR
function ScripticApp:SearchBar()
	return Roact.createElement("TextBox", {
		Size = UDim2.new(1, -10, 0, 32),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Text = self.state.search,
		PlaceholderText = "Search...",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		BorderSizePixel = 0,

		[Roact.Change.Text] = function(rbx)
			self:setState({ search = rbx.Text })
		end
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6)
		})
	})
end

--// LOADING SCREEN
function ScripticApp:Loading()
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	}, {
		Spinner = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = "⏳ Loading Scriptic...",
			TextColor3 = Color3.fromRGB(0, 170, 255),
			Font = Enum.Font.GothamBold,
			TextSize = 18,
			BackgroundTransparency = 1,
			Rotation = self.state.spinnerAngle
		})
	})
end

--// TOASTS
function ScripticApp:Toasts()
	local list = {}

	for i, t in ipairs(self.state.toasts) do
		list["Toast" .. i] = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 220, 0, 30),
			Text = t.text,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			TextColor3 = Color3.fromRGB(255, 255, 255),
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
		Size = UDim2.new(0, 240, 1, 0),
		Position = UDim2.new(1, -250, 0, 10),
		BackgroundTransparency = 1
	}, list)
end

--// DYNAMIC PAGE LAYOUT SYSTEM
function ScripticApp:Content()
	local currentTab = self.state.tab
	
	if currentTab == "AutoFarm" then
		return Roact.createElement("TextButton", {
			Size = UDim2.new(0, 220, 0, 45),
			BackgroundColor3 = self.state.autoFarmEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 55),
			Text = self.state.autoFarmEnabled and "Auto-Farm Loop: ON" or "Auto-Farm Loop: OFF",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = function()
				local nextState = not self.state.autoFarmEnabled
				self:setState({ autoFarmEnabled = nextState })
				self:pushToast(nextState and "Activated Tracking State" or "Deactivated Tracking State")
			end
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 6) })
		})
		
	elseif currentTab == "Settings" then
		return Roact.createElement("TextButton", {
			Size = UDim2.new(0, 200, 0, 40),
			BackgroundColor3 = Color3.fromRGB(220, 60, 60),
			Text = "❌ Close Scriptic Screen",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = function()
				self:pushToast("Unmounting layout frame...")
				task.delay(0.4, function()
					local players = game:GetService("Players")
					local localPlayer = players.LocalPlayer
					local hubFrame = localPlayer and localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("ScripticV3")
					if hubFrame then hubFrame:Destroy() end
				end)
			end
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 6) })
		})
	else
		return Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 30),
			Text = "Framework View Layer — Interactive tab configurations are ready.",
			TextColor3 = Color3.fromRGB(140, 140, 140),
			Font = Enum.Font.Gotham,
			TextSize = 13,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end
end

--// RENDER
function ScripticApp:render()
	if self.state.loading then
		return self:Loading()
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 860, 0, 520),
		Position = UDim2.new(0.5, -430, 0.5, -260),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderSizePixel = 0
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 10)
		}),

		Sidebar = Roact.createElement("Frame", {
			Size = UDim2.new(0, 70, 1, 0),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0
		}, {
			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 8)
			}),

			Search = self:SearchBar(),

			AutoFarm = self:SidebarButton("AutoFarm"),
			Teleports = self:SidebarButton("Teleports"),
			Fruit = self:SidebarButton("Fruit"),
			ESP = self:SidebarButton("ESP"),
			Settings = self:SidebarButton("Settings"),
		}),

		Main = Roact.createElement("Frame", {
			Position = UDim2.new(0, 70, 0, 0),
			Size = UDim2.new(1, -70, 1, 0),
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BorderSizePixel = 0
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20)
			}),

			Layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 15)
			}),
			
			HeaderTitle = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 20),
				Text = "Scriptic Hub — Menu Tab: " .. self.state.tab,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			}),

			Content = self:Content()
		}),

		Tooltip = self:Tooltip(self.state.hoverTip),
		Toasts = self:Toasts()
	})
end

-- MOUNT TARGET SAFETY ADJUSTMENT: Directing framework safely into local player's PlayerGui context layer
local localPlayer = game:GetService("Players").LocalPlayer
local targetGui = localPlayer:WaitForChild("PlayerGui")

Roact.mount(
	Roact.createElement(ScripticApp),
	targetGui,
	"ScripticV3"
)

print("[Scriptic]: UI v3 Loaded via Internet Bootstrapper")
