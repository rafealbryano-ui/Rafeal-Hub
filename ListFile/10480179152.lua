local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Rafael Studio] : Really? Your account is now at risk for the next ban wave."); end;

local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local Instancen = Instance.new;
local Vec3 = Vector3.new;
local Col3 = Color3;
local tble = table;
local str = string;
local math = math;
local CF = CFrame;
local tk = task;
local H = GG.H;
local W = GG.W;
local P = GG.P;

local PlaceId = game.PlaceId;

local CFr = CF.new;
local IsA = game.IsA;
local twait = tk.wait;
local GetPivot = W.GetPivot;
local TwInfo = TweenInfo.new;
local GetPlayers = P.GetPlayers;
local VIM = GG.VirtualInputManager;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local FindFirstChild = game.FindFirstChild
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;
local RunService = game:GetService("RunService");

local RED = Col3.new(1,0,0);
local GREEN = Col3.new(0, 1, 0);
local BLUE = Col3.new(0, 0, 1);
local WHITE = Col3.new(1, 1, 1);
local YELLOW = Col3.new(1, 1, 0);
local ORANGE = Col3.fromRGB(255, 165, 0);
local PURPLE = Col3.fromRGB(128, 0, 255);
local CYAN = Col3.fromRGB(0, 255, 255);

local VEC4 = Vec3(4,4,4);

local Config = GG.Configs or {};
Config.Aimlock = Config.Aimlock or {
    Enabled = false;
    Prediction = 0.1377;
    FOV = 360;
    Keybind = "q";
    ShowFOVCircle = true;
};
Config.ESP = Config.ESP or {
    Enabled = true;
    Boxes = true;
    HealthBars = true;
    Tracers = true;
    Names = true;
    BoxColor = "White";
    TracerColor = "Red";
};
GG.Configs = Config;

local Storing_AUTHENTICATION, PremiumCheck = nil, false;
local encrypt = function(text, key)
    local encryptedText = ""; for i = 1, #text do
        local char = str.byte(text, i);
        local encryptedChar = (char + key) % 256;
        encryptedText = encryptedText .. str.char(encryptedChar);
    end; return encryptedText;
end;
local decrypt = function(encryptedText ,key)
	local decryptedText = ""; for i = 1, #encryptedText do
		local char = str.byte(encryptedText, i);
		local decryptedChar = (char - key) % 256;
		if decryptedChar < 0 then
			decryptedChar = decryptedChar + 256;
		end; decryptedText = decryptedText .. str.char(decryptedChar);
	end; return decryptedText;
end;

return {
    Version = "DAUP_V1.0";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, PromptPackage, CoruTask, ESPF, CommonF, DAPackage)
        local CoreConnection = {};
        local CoreDestroyed = false;
        local WindUI = nil;

        local Seat = nil;
        local Cam = W.CurrentCamera;
        local selff = GG.P.LocalPlayer;
        local PSG = selff.PlayerGui;
        local selc = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf = HumSelf and HumSelf.RootPart;

        local targetPart = nil;
        local isAiming = false;
        local circleDrawing = nil;
        local espBoxes = {};
        local espHealthBars = {};
        local espTracers = {};
        local espNames = {};

        local AimlockCon = Config.Aimlock;
        local ESPCon = Config.ESP;

        local function GetColorFromString(colorName)
            local colors = {
                Red = RED,
                Green = GREEN,
                Blue = BLUE,
                White = WHITE,
                Yellow = YELLOW,
                Orange = ORANGE,
                Purple = PURPLE,
                Cyan = CYAN
            };
            return colors[colorName] or WHITE;
        end

        local function FindNearestEnemy()
            local nearestDist = math.huge;
            local nearestPart = nil;
            local screenCenter = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2);
            
            for _, player in ipairs(GetPlayers(P)) do
                if player ~= selff then
                    local character = player.Character;
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                        local rootPart = character.HumanoidRootPart;
                        local success, screenPos, onScreen = pcall(function()
                            return Cam:WorldToViewportPoint(rootPart.Position)
                        end)
                        if success and onScreen then
                            local dist = (screenCenter - Vector2.new(screenPos.X, screenPos.Y)).Magnitude;
                            if dist < nearestDist and dist < AimlockCon.FOV then
                                nearestPart = rootPart;
                                nearestDist = dist;
                            end;
                        end;
                    end;
                end;
            end;
            return nearestPart;
        end;

        local function CreateCircle()
            if not Drawing then return nil; end
            local circle = Drawing.new("Circle");
            circle.Position = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2);
            circle.Radius = AimlockCon.FOV;
            circle.Color = Col3.fromRGB(255, 0, 0);
            circle.Thickness = 2;
            circle.Filled = false;
            circle.Visible = AimlockCon.ShowFOVCircle;
            return circle;
        end;

        local function CreateBox(color, thickness, filled)
            if not Drawing then return nil; end
            local box = Drawing.new("Square");
            box.Visible = true;
            box.Color = color;
            box.Thickness = thickness;
            box.Filled = filled;
            return box;
        end;

        local function CreateTracer(color, thickness)
            if not Drawing then return nil; end
            local tracer = Drawing.new("Line");
            tracer.Visible = true;
            tracer.Color = color;
            tracer.Thickness = thickness or 1;
            tracer.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y);
            tracer.To = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y);
            return tracer;
        end;

        local function CreateNameLabel()
            if not Drawing then return nil; end
            local label = Drawing.new("Text");
            label.Visible = true;
            label.Color = WHITE;
            label.Size = 14;
            label.Center = true;
            label.Outline = true;
            label.OutlineColor = Col3.new(0, 0, 0);
            label.Font = 3;
            return label;
        end;

        local function SetupESP()
            local currentCamera = Cam;
            if not currentCamera then return end
            
            local boxColor = GetColorFromString(ESPCon.BoxColor);
            local tracerColor = GetColorFromString(ESPCon.TracerColor);

            for _, player in ipairs(GetPlayers(P)) do
                if player ~= selff then
                    if espBoxes[player] then 
                        pcall(function() espBoxes[player]:Remove() end)
                        espBoxes[player] = nil
                    end
                    if espHealthBars[player] then 
                        pcall(function() espHealthBars[player]:Remove() end)
                        espHealthBars[player] = nil
                    end
                    if espTracers[player] then 
                        pcall(function() espTracers[player]:Remove() end)
                        espTracers[player] = nil
                    end
                    if espNames[player] then 
                        pcall(function() espNames[player]:Remove() end)
                        espNames[player] = nil
                    end
                end
            end

            for _, player in ipairs(GetPlayers(P)) do
                if player ~= selff then
                    espBoxes[player] = CreateBox(boxColor, 1, false);
                    espHealthBars[player] = CreateBox(GREEN, 1, true);
                    if ESPCon.Tracers then
                        espTracers[player] = CreateTracer(tracerColor, 1);
                    end;
                    if ESPCon.Names then
                        espNames[player] = CreateNameLabel();
                    end;
                end;
            end;

            P.PlayerAdded:Connect(function(player)
                if player ~= selff then
                    espBoxes[player] = CreateBox(boxColor, 1, false);
                    espHealthBars[player] = CreateBox(GREEN, 1, true);
                    if ESPCon.Tracers then
                        espTracers[player] = CreateTracer(tracerColor, 1);
                    end;
                    if ESPCon.Names then
                        espNames[player] = CreateNameLabel();
                    end;
                end;
            end);

            P.PlayerRemoving:Connect(function(player)
                if espBoxes[player] then
                    pcall(function() espBoxes[player]:Remove() end);
                    pcall(function() espHealthBars[player]:Remove() end);
                    if espTracers[player] then pcall(function() espTracers[player]:Remove() end); end;
                    if espNames[player] then pcall(function() espNames[player]:Remove() end); end;
                    espBoxes[player] = nil;
                    espHealthBars[player] = nil;
                    espTracers[player] = nil;
                    espNames[player] = nil;
                end;
            end);

            RunService.RenderStepped:Connect(function()
                if not currentCamera then return end
                
                for _, player in ipairs(GetPlayers(P)) do
                    if player ~= selff and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local character = player.Character;
                        local humanoid = character:FindFirstChild("Humanoid");
                        local rootPart = character.HumanoidRootPart;
                        
                        if humanoid and humanoid.Health > 0 and rootPart then
                            local size = character:GetExtentsSize();
                            local position = rootPart.Position;
                            
                            local success1, topPos, topOnScreen = pcall(function()
                                return currentCamera:WorldToViewportPoint(position + Vec3.new(-size.X/2, size.Y/2, 0))
                            end)
                            
                            local success2, bottomPos, bottomOnScreen = pcall(function()
                                return currentCamera:WorldToViewportPoint(position + Vec3.new(size.X/2, -size.Y/2, 0))
                            end)
                            
                            if success1 and success2 and topOnScreen and bottomOnScreen and topPos.Z > 0 and bottomPos.Z > 0 then
                                local topVec = Vector2.new(topPos.X, topPos.Y);
                                local bottomVec = Vector2.new(bottomPos.X - topPos.X, bottomPos.Y - topPos.Y);
                                
                                if ESPCon.Boxes and espBoxes[player] then
                                    local box = espBoxes[player];
                                    if box then
                                        box.Color = boxColor;
                                        box.Size = bottomVec;
                                        box.Position = topVec;
                                        box.Visible = true;
                                    end;
                                end;
                                
                                if ESPCon.HealthBars and espHealthBars[player] then
                                    local healthPercent = humanoid.Health / humanoid.MaxHealth;
                                    local healthHeight = bottomVec.Y * healthPercent;
                                    healthHeight = math.clamp(healthHeight, 0, bottomVec.Y);
                                    
                                    local healthBar = espHealthBars[player];
                                    if healthBar then
                                        healthBar.Size = Vector2.new(5, healthHeight);
                                        healthBar.Position = Vector2.new(topVec.X - 6, (topVec.Y + bottomVec.Y) - healthHeight);
                                        healthBar.Visible = true;
                                    end;
                                end;
                                
                                if ESPCon.Tracers and espTracers[player] then
                                    local tracer = espTracers[player];
                                    if tracer then
                                        tracer.Color = tracerColor;
                                        tracer.From = Vector2.new(currentCamera.ViewportSize.X/2, currentCamera.ViewportSize.Y);
                                        tracer.To = Vector2.new(topVec.X + (bottomVec.X/2), topVec.Y);
                                        tracer.Visible = true;
                                    end;
                                end;
                                
                                if ESPCon.Names and espNames[player] then
                                    local nameLabel = espNames[player];
                                    if nameLabel then
                                        nameLabel.Text = player.Name;
                                        nameLabel.Position = Vector2.new(topVec.X + (bottomVec.X/2), topVec.Y - 20);
                                        nameLabel.Visible = true;
                                    end;
                                end;
                            else
                                if espBoxes[player] then espBoxes[player].Visible = false; end;
                                if espHealthBars[player] then espHealthBars[player].Visible = false; end;
                                if espTracers[player] then espTracers[player].Visible = false; end;
                                if espNames[player] then espNames[player].Visible = false; end;
                            end;
                        else
                            if espBoxes[player] then espBoxes[player].Visible = false; end;
                            if espHealthBars[player] then espHealthBars[player].Visible = false; end;
                            if espTracers[player] then espTracers[player].Visible = false; end;
                            if espNames[player] then espNames[player].Visible = false; end;
                        end;
                    elseif espBoxes[player] then
                        espBoxes[player].Visible = false;
                        espHealthBars[player].Visible = false;
                        if espTracers[player] then espTracers[player].Visible = false; end;
                        if espNames[player] then espNames[player].Visible = false; end;
                    end;
                end;
            end);
        end;

        RunService.Heartbeat:Connect(function()
            if isAiming and targetPart and AimlockCon.Enabled then
                local success, newCF = pcall(function()
                    return CF.new(Cam.CFrame.p, targetPart.Position + (targetPart.Velocity * AimlockCon.Prediction))
                end)
                if success then
                    Cam.CFrame = newCF;
                end
            end;
            
            if AimlockCon.Enabled and circleDrawing then
                circleDrawing.Radius = AimlockCon.FOV;
                circleDrawing.Visible = AimlockCon.ShowFOVCircle;
            end;
        end);

        selff:GetMouse().KeyDown:Connect(function(key)
            if key == AimlockCon.Keybind then
                AimlockCon.Enabled = not AimlockCon.Enabled;
                if AimlockCon.Enabled then
                    targetPart = FindNearestEnemy();
                    isAiming = true;
                elseif targetPart ~= nil then
                    targetPart = nil;
                    isAiming = false;
                end;
            end;
        end);

        local function CreateSimpleUI()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "DAUP_UI"
            screenGui.Parent = game.CoreGui
            screenGui.ResetOnSpawn = false

            local mainFrame = Instance.new("Frame")
            mainFrame.Parent = screenGui
            mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            mainFrame.BorderSizePixel = 0
            mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
            mainFrame.Size = UDim2.new(0, 400, 0, 400)
            mainFrame.Active = true
            mainFrame.Draggable = true

            local uiCorner = Instance.new("UICorner")
            uiCorner.Parent = mainFrame
            uiCorner.CornerRadius = UDim.new(0, 8)

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Parent = mainFrame
            titleLabel.Size = UDim2.new(1, 0, 0, 40)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            titleLabel.Text = "Rafael Hub DAUP"
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 18
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.BorderSizePixel = 0

            local titleCorner = Instance.new("UICorner")
            titleCorner.Parent = titleLabel
            titleCorner.CornerRadius = UDim.new(0, 8)

            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Parent = mainFrame
            scrollFrame.Size = UDim2.new(1, -10, 1, -50)
            scrollFrame.Position = UDim2.new(0, 5, 0, 45)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.ScrollBarThickness = 4
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

            local uiList = Instance.new("UIListLayout")
            uiList.Parent = scrollFrame
            uiList.Padding = UDim.new(0, 8)
            uiList.SortOrder = Enum.SortOrder.LayoutOrder

            local function CreateToggle(labelText, configPath, defaultVal)
                local frame = Instance.new("Frame")
                frame.Parent = scrollFrame
                frame.Size = UDim2.new(1, 0, 0, 30)
                frame.BackgroundTransparency = 1

                local label = Instance.new("TextLabel")
                label.Parent = frame
                label.Size = UDim2.new(0.7, 0, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = labelText
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham

                local toggle = Instance.new("TextButton")
                toggle.Parent = frame
                toggle.Size = UDim2.new(0, 50, 0, 25)
                toggle.Position = UDim2.new(0.85, 0, 0.5, -12.5)
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                toggle.Text = "OFF"
                toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggle.TextSize = 12
                toggle.Font = Enum.Font.GothamBold
                toggle.BorderSizePixel = 0

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.Parent = toggle
                toggleCorner.CornerRadius = UDim.new(0, 4)

                local state = defaultVal
                if state then
                    toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    toggle.Text = "ON"
                end

                toggle.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                        toggle.Text = "ON"
                    else
                        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        toggle.Text = "OFF"
                    end
                    
                    local pathParts = {}
                    for part in string.gmatch(configPath, "[^/]+") do
                        table.insert(pathParts, part)
                    end
                    local current = Config
                    for i = 1, #pathParts - 1 do
                        current = current[pathParts[i]]
                        if not current then break end
                    end
                    if current then
                        current[pathParts[#pathParts]] = state
                    end
                end)

                return frame
            end

            local function CreateSlider(labelText, configPath, minVal, maxVal, defaultVal)
                local frame = Instance.new("Frame")
                frame.Parent = scrollFrame
                frame.Size = UDim2.new(1, 0, 0, 40)
                frame.BackgroundTransparency = 1

                local label = Instance.new("TextLabel")
                label.Parent = frame
                label.Size = UDim2.new(0.5, 0, 0.5, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = labelText
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Parent = frame
                valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
                valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
                valueLabel.Text = tostring(defaultVal)
                valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.BackgroundTransparency = 1
                valueLabel.Font = Enum.Font.Gotham

                local slider = Instance.new("Frame")
                slider.Parent = frame
                slider.Size = UDim2.new(0.7, 0, 0, 4)
                slider.Position = UDim2.new(0.05, 0, 0.75, 0)
                slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                slider.BorderSizePixel = 0

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.Parent = slider

                local fill = Instance.new("Frame")
                fill.Parent = slider
                fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                fill.BorderSizePixel = 0

                local fillCorner = Instance.new("UICorner")
                fillCorner.Parent = fill

                local dragging = false
                local currentValue = defaultVal

                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)

                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouseX = input.Position.X
                        local sliderPos = slider.AbsolutePosition.X
                        local sliderWidth = slider.AbsoluteSize.X
                        if sliderWidth > 0 then
                            local percent = math.clamp((mouseX - sliderPos) / sliderWidth, 0, 1)
                            currentValue = minVal + (maxVal - minVal) * percent
                            currentValue = math.round(currentValue)
                            fill.Size = UDim2.new(percent, 0, 1, 0)
                            valueLabel.Text = tostring(currentValue)
                            
                            local pathParts = {}
                            for part in string.gmatch(configPath, "[^/]+") do
                                table.insert(pathParts, part)
                            end
                            local current = Config
                            for i = 1, #pathParts - 1 do
                                current = current[pathParts[i]]
                                if not current then break end
                            end
                            if current then
                                current[pathParts[#pathParts]] = currentValue
                            end
                        end
                    end
                end)

                return frame
            end

            local function CreateDropdown(labelText, configPath, options, defaultVal)
                local frame = Instance.new("Frame")
                frame.Parent = scrollFrame
                frame.Size = UDim2.new(1, 0, 0, 30)
                frame.BackgroundTransparency = 1

                local label = Instance.new("TextLabel")
                label.Parent = frame
                label.Size = UDim2.new(0.5, 0, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.Text = labelText
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham

                local dropdown = Instance.new("TextButton")
                dropdown.Parent = frame
                dropdown.Size = UDim2.new(0.35, 0, 0.8, 0)
                dropdown.Position = UDim2.new(0.6, 0, 0.1, 0)
                dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdown.Text = defaultVal
                dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdown.TextSize = 12
                dropdown.Font = Enum.Font.Gotham
                dropdown.BorderSizePixel = 0

                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.Parent = dropdown

                local isOpen = false
                local currentValue = defaultVal

                dropdown.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        local menu = Instance.new("Frame")
                        menu.Parent = frame
                        menu.Name = "DropdownMenu"
                        menu.Size = UDim2.new(0.35, 0, 0, 0)
                        menu.Position = UDim2.new(0.6, 0, 1, 2)
                        menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        menu.BorderSizePixel = 0
                        menu.AutomaticSize = Enum.AutomaticSize.Y
                        menu.ClipsDescendants = true
                        menu.ZIndex = 10

                        local menuCorner = Instance.new("UICorner")
                        menuCorner.Parent = menu

                        local menuList = Instance.new("UIListLayout")
                        menuList.Parent = menu
                        menuList.Padding = UDim.new(0, 2)

                        for _, option in ipairs(options) do
                            local optBtn = Instance.new("TextButton")
                            optBtn.Parent = menu
                            optBtn.Size = UDim2.new(1, 0, 0, 25)
                            optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                            optBtn.Text = option
                            optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            optBtn.TextSize = 12
                            optBtn.Font = Enum.Font.Gotham
                            optBtn.BorderSizePixel = 0

                            local optCorner = Instance.new("UICorner")
                            optCorner.Parent = optBtn

                            optBtn.MouseButton1Click:Connect(function()
                                currentValue = option
                                dropdown.Text = option
                                menu:Destroy()
                                isOpen = false
                                
                                local pathParts = {}
                                for part in string.gmatch(configPath, "[^/]+") do
                                    table.insert(pathParts, part)
                                end
                                local current = Config
                                for i = 1, #pathParts - 1 do
                                    current = current[pathParts[i]]
                                    if not current then break end
                                end
                                if current then
                                    current[pathParts[#pathParts]] = option
                                end
                            end)
                        end
                    else
                        local menu = frame:FindFirstChild("DropdownMenu")
                        if menu then menu:Destroy() end
                    end
                end)

                return frame
            end

            CreateToggle("Enable Aimlock", "Aimlock/Enabled", false)
            CreateSlider("FOV", "Aimlock/FOV", 1, 360, 360)
            CreateSlider("Prediction", "Aimlock/Prediction", 0, 1, 0.1377)
            CreateToggle("Show FOV Circle", "Aimlock/ShowFOVCircle", true)
            
            local spacer1 = Instance.new("Frame")
            spacer1.Parent = scrollFrame
            spacer1.Size = UDim2.new(1, 0, 0, 10)
            spacer1.BackgroundTransparency = 1
            
            CreateToggle("Enable ESP", "ESP/Enabled", true)
            CreateToggle("Boxes", "ESP/Boxes", true)
            CreateToggle("Health Bars", "ESP/HealthBars", true)
            CreateToggle("Tracers", "ESP/Tracers", true)
            CreateToggle("Names", "ESP/Names", true)
            
            local spacer2 = Instance.new("Frame")
            spacer2.Parent = scrollFrame
            spacer2.Size = UDim2.new(1, 0, 0, 5)
            spacer2.BackgroundTransparency = 1
            
            CreateDropdown("Box Color", "ESP/BoxColor", {"Red", "Green", "Blue", "White", "Yellow", "Orange", "Purple", "Cyan"}, "White")
            CreateDropdown("Tracer Color", "ESP/TracerColor", {"Red", "Green", "Blue", "White", "Yellow", "Orange", "Purple", "Cyan"}, "Red")

            return screenGui
        end

        local LSecureUI = function()
            WindUI = CreateSimpleUI()
        end

        local LSecureLoad = function(AUTH_KEY)
            Storing_AUTHENTICATION = Storing_AUTHENTICATION or AUTH_KEY;
            if not Storing_AUTHENTICATION then return selff:Kick("Invalid Authentication 1PAC"); end;
            local Splited1 = str.split(Storing_AUTHENTICATION, "+++os()");
            local Splited2 = str.split(decrypt(Splited1[2], 3), "+++os()");
            local D1Auth = decrypt(Splited2[2], 3);
            local D2Auth = decrypt(Splited2[3], 2);
            D1Auth = D1Auth:gsub("emptyspace", "");
            D2Auth = D2Auth:gsub("emptyspace", "");
            if D1Auth == "200" then
                PremiumCheck = false;
            elseif D1Auth == "201" then
                PremiumCheck = true;
            else
                return selff:Kick("Invalid Authentication 2PAC");
            end

            local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false;
                if PromptPackage and type(PromptPackage.UpdateState) == "function" then
                    PromptPackage.UpdateState(false);
                end
                
                LSecureUI();

                CoreConnection[1] = H.Stepped:Connect(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect();
                        CoreConnection[1] = nil;
                        return;
                    end

                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;
                    if CommonF and type(CommonF.GetSeat) == "function" then
                        Seat = CommonF.GetSeat(HumSelf);
                    end
                end);

                task.wait(2);
                if ESPCon.Enabled and not CoreDestroyed then
                    SetupESP();
                end

                if not CoruTask.Intialized then
                    circleDrawing = CreateCircle();
                    
                    if CoruTask and type(CoruTask.Init) == "function" then
                        CoruTask.Init(WindUI);
                    end
                    CoruTask.Intialized = true;

                    GG.Configs = Config;
                end
            end)
            
            if OneRunCallMain then
                return true, GG.LoadingSignal and GG.LoadingSignal:Fire(100) or nil;
            end
            return false, warn(OneRunErrorMain);
        end
        
        GG.LSecureLoad = LSecureLoad;
        return LSecureLoad;
    end
}
