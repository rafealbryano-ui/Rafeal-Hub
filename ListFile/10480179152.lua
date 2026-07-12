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
    ShowFOVCircle = false;
};
Config.ESP = Config.ESP or {
    Enabled = false;
    Boxes = false;
    HealthBars = false;
    Tracers = false;
    Names = false;
    BoxColor = "White";
    TracerColor = "White";
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
        local espSetupDone = false;

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
            circle.Visible = false;
            return circle;
        end;

        local function CreateBox(color, thickness, filled)
            if not Drawing then return nil; end
            local box = Drawing.new("Square");
            box.Visible = false;
            box.Color = color;
            box.Thickness = thickness;
            box.Filled = filled;
            return box;
        end;

        local function CreateTracer(color, thickness)
            if not Drawing then return nil; end
            local tracer = Drawing.new("Line");
            tracer.Visible = false;
            tracer.Color = color;
            tracer.Thickness = thickness or 1;
            tracer.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y);
            tracer.To = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y);
            return tracer;
        end;

        local function CreateNameLabel()
            if not Drawing then return nil; end
            local label = Drawing.new("Text");
            label.Visible = false;
            label.Color = WHITE;
            label.Size = 14;
            label.Center = true;
            label.Outline = true;
            label.OutlineColor = Col3.new(0, 0, 0);
            label.Font = 3;
            return label;
        end;

        local function SetupESP()
            if espSetupDone then return end
            
            for _, player in ipairs(GetPlayers(P)) do
                if player ~= selff then
                    espBoxes[player] = CreateBox(WHITE, 1, false);
                    espHealthBars[player] = CreateBox(GREEN, 1, true);
                    espTracers[player] = CreateTracer(WHITE, 1);
                    espNames[player] = CreateNameLabel();
                end;
            end;

            P.PlayerAdded:Connect(function(player)
                if player ~= selff then
                    espBoxes[player] = CreateBox(WHITE, 1, false);
                    espHealthBars[player] = CreateBox(GREEN, 1, true);
                    espTracers[player] = CreateTracer(WHITE, 1);
                    espNames[player] = CreateNameLabel();
                end;
            end);

            P.PlayerRemoving:Connect(function(player)
                if espBoxes[player] then
                    pcall(function() espBoxes[player]:Remove() end);
                    pcall(function() espHealthBars[player]:Remove() end);
                    pcall(function() espTracers[player]:Remove() end);
                    pcall(function() espNames[player]:Remove() end);
                    espBoxes[player] = nil;
                    espHealthBars[player] = nil;
                    espTracers[player] = nil;
                    espNames[player] = nil;
                end;
            end);

            espSetupDone = true;
        end;

        local function UpdateESP()
            local currentCamera = Cam;
            if not currentCamera then return end
            
            local boxColor = GetColorFromString(ESPCon.BoxColor);
            local tracerColor = GetColorFromString(ESPCon.TracerColor);
            local espEnabled = ESPCon.Enabled;
            
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
                        
                        if success1 and success2 and topOnScreen and bottomOnScreen and topPos and bottomPos and topPos.Z > 0 and bottomPos.Z > 0 then
                            local topVec = Vector2.new(topPos.X, topPos.Y);
                            local bottomVec = Vector2.new(bottomPos.X - topPos.X, bottomPos.Y - topPos.Y);
                            
                            if espEnabled and ESPCon.Boxes and espBoxes[player] then
                                local box = espBoxes[player];
                                if box then
                                    box.Color = boxColor;
                                    box.Size = bottomVec;
                                    box.Position = topVec;
                                    box.Visible = true;
                                end;
                            elseif espBoxes[player] then
                                espBoxes[player].Visible = false;
                            end;
                            
                            if espEnabled and ESPCon.HealthBars and espHealthBars[player] then
                                local healthPercent = humanoid.Health / humanoid.MaxHealth;
                                local healthHeight = bottomVec.Y * healthPercent;
                                healthHeight = math.clamp(healthHeight, 0, bottomVec.Y);
                                
                                local healthBar = espHealthBars[player];
                                if healthBar then
                                    healthBar.Size = Vector2.new(5, healthHeight);
                                    healthBar.Position = Vector2.new(topVec.X - 6, (topVec.Y + bottomVec.Y) - healthHeight);
                                    healthBar.Visible = true;
                                end;
                            elseif espHealthBars[player] then
                                espHealthBars[player].Visible = false;
                            end;
                            
                            if espEnabled and ESPCon.Tracers and espTracers[player] then
                                local tracer = espTracers[player];
                                if tracer then
                                    tracer.Color = tracerColor;
                                    tracer.From = Vector2.new(currentCamera.ViewportSize.X/2, currentCamera.ViewportSize.Y);
                                    tracer.To = Vector2.new(topVec.X + (bottomVec.X/2), topVec.Y);
                                    tracer.Visible = true;
                                end;
                            elseif espTracers[player] then
                                espTracers[player].Visible = false;
                            end;
                            
                            if espEnabled and ESPCon.Names and espNames[player] then
                                local nameLabel = espNames[player];
                                if nameLabel then
                                    nameLabel.Text = player.Name;
                                    nameLabel.Position = Vector2.new(topVec.X + (bottomVec.X/2), topVec.Y - 20);
                                    nameLabel.Visible = true;
                                end;
                            elseif espNames[player] then
                                espNames[player].Visible = false;
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
                    espTracers[player].Visible = false;
                    espNames[player].Visible = false;
                end;
            end;
            
            if circleDrawing then
                circleDrawing.Visible = AimlockCon.ShowFOVCircle and AimlockCon.Enabled;
                circleDrawing.Radius = AimlockCon.FOV;
            end;
        end;

        RunService.Heartbeat:Connect(function()
            if AimlockCon.Enabled and isAiming and targetPart then
                local success = pcall(function()
                    Cam.CFrame = CF.new(Cam.CFrame.p, targetPart.Position + (targetPart.Velocity * AimlockCon.Prediction))
                end)
            end;
            
            UpdateESP();
        end);

        selff:GetMouse().KeyDown:Connect(function(key)
            if key == AimlockCon.Keybind then
                AimlockCon.Enabled = not AimlockCon.Enabled;
                if AimlockCon.Enabled then
                    targetPart = FindNearestEnemy();
                    isAiming = true;
                else
                    targetPart = nil;
                    isAiming = false;
                end;
            end;
        end);

        local ScriptData = {
            AutoData = {
                AimlockTab = {
                    {type="Group", dats={
                        {dat={
                            {type="Toggle", EN="Enable Aimlock", EN2="Lock onto nearest enemy player.", TH1="เปิด Aimlock", TH2="ล็อคไปยังผู้เล่นที่ใกล้ที่สุด", Path="Aimlock/Enabled"},
                            {type="Slider", EN="FOV", EN2="Field of view for aimlock.", TH1="มุมมอง Aimlock", TH2="ระยะการมองเห็น", Value={Min=1, Max=360, Default=360}, Path="Aimlock/FOV"},
                            {type="Slider", EN="Prediction", EN2="Prediction for moving targets.", TH1="การทำนาย", TH2="ทำนายตำแหน่งเป้าหมายที่เคลื่อนที่", Value={Min=0, Max=1, Default=0.1377}, Step=0.001, Path="Aimlock/Prediction"},
                            {type="Input", EN="Keybind", EN2="Key to toggle aimlock.", TH1="ปุ่มเปิด/ปิด", TH2="ปุ่มเปิด/ปิด Aimlock", Path="Aimlock/Keybind"},
                            {type="Toggle", EN="Show FOV Circle", EN2="Show the FOV circle on screen.", TH1="แสดงวง FOV", TH2="แสดงวงกลมมุมมองบนหน้าจอ", Path="Aimlock/ShowFOVCircle"},
                        }, Title="Aimlock", Open=true};
                    }};
                    {type="Group", dats={
                        {dat={
                            {type="Toggle", EN="Enable ESP", EN2="Show ESP for all players.", TH1="เปิด ESP", TH2="เปิด ESP สำหรับผู้เล่นทั้งหมด", Path="ESP/Enabled"},
                            {type="Toggle", EN="Boxes", EN2="Show bounding boxes.", TH1="กล่อง", TH2="แสดงกล่องรอบตัวผู้เล่น", Path="ESP/Boxes"},
                            {type="Toggle", EN="Health Bars", EN2="Show health bars.", TH1="แถบพลังชีวิต", TH2="แสดงแถบพลังชีวิต", Path="ESP/HealthBars"},
                            {type="Toggle", EN="Tracers", EN2="Show tracer lines to players.", TH1="เส้นนำทาง", TH2="แสดงเส้นเชื่อมไปยังผู้เล่น", Path="ESP/Tracers"},
                            {type="Toggle", EN="Names", EN2="Show player names.", TH1="ชื่อผู้เล่น", TH2="แสดงชื่อผู้เล่น", Path="ESP/Names"},
                            {type="Dropdown", EN="Box Color", EN2="Color of the ESP boxes.", TH1="สีกล่อง", TH2="สีของกล่อง ESP", Values={"Red", "Green", "Blue", "White", "Yellow", "Orange", "Purple", "Cyan"}, Path="ESP/BoxColor"},
                            {type="Dropdown", EN="Tracer Color", EN2="Color of the tracer lines.", TH1="สีเส้นนำทาง", TH2="สีของเส้นนำทาง", Values={"Red", "Green", "Blue", "White", "Yellow", "Orange", "Purple", "Cyan"}, Path="ESP/TracerColor"},
                        }, Title="ESP"};
                    }};
                };
            };
        };

        local LSecureUI = function()
            if type(WindLib) ~= "function" then
                warn("WindLib is not a function");
                return;
            end
            
            WindUI = WindLib();
            if type(WindUI) ~= "table" then
                warn("WindUI library failed to load properly");
                return;
            end
            
            if type(WindUI.CreateWindow) ~= "function" then
                warn("WindUI.CreateWindow is not a function");
                return;
            end
            
            local Window = WindUI:CreateWindow({
                Title = "Rafael Hub DAUP",
                Folder = "RafaelStudio",
                Transparent = true,
                Theme = "Dark",
                SideBarWidth = 200,
                HasOutline = true,
                NewElements = true,
                OpenButton = {
                    Title = "Rafael Hub",
                    CornerRadius = UDim.new(1,0),
                    StrokeThickness = 3,
                    Enabled = true,
                    Draggable = true,
                    OnlyMobile = false,
                    Color = ColorSequence.new(Col3.fromHex("#30FF6A"), Col3.fromHex("#e7ff2f"))
                }, 
                Topbar = {
                    Height = 44,
                    ButtonsType = "Mac",
                },
            });
            
            if type(Window) ~= "table" then
                warn("Failed to create WindUI window");
                return;
            end
            
            local Tabs = {
                Welcome = Window:Tab({Title="Welcome", Icon="smile"}),
                Aimlock = Window:Tab({Title="Aimlock", Icon="crosshair"}),
            };
            
            if IntroLib and type(IntroLib.Init) == "function" then
                IntroLib.Init(WindUI, Tabs.Welcome);
            end
            if IntroLib and type(IntroLib.Tutorial) == "function" then
                IntroLib.Tutorial(WindUI);
            end
            
            if Windy and type(Windy.CreateComponent) == "function" then
                Windy:CreateComponent(Tabs.Aimlock, ScriptData.AutoData.AimlockTab, "Aimlock");
            end

            if Window and type(Window.SelectTab) == "function" then
                Window:SelectTab(1);
            end
            
            if Window and type(Window.OnDestroy) == "function" then
                Window:OnDestroy(function()
                    CoreDestroyed = true;
                    if PromptPackage and type(PromptPackage.UpdateState) == "function" then
                        PromptPackage.UpdateState(true);
                    end
                end);
            end

            ScriptCache.WindUI = WindUI; 
            ScriptCache.Window = Window;
        end;

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
            end;

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

                task.wait(1);
                SetupESP();
                circleDrawing = CreateCircle();

                if not CoruTask.Intialized then
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
