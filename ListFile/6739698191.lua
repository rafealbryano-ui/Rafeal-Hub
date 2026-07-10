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
local GetPlayers = P.GetPlayers;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local FindFirstChild = game.FindFirstChild
local FindFirstChildOfClass = game.FindFirstChildOfClass;

local WHITE = Col3.new(1, 1, 1);
local PURPLE = Col3.new(1, 0, 1);
local GREEN = Col3.new(0, 1, 0);
local YELLOW = Col3.new(1, 1, 0);
local ORANGE = Col3.new(1, 0.647, 0);

local VEC5 = Vec3(5,5,5);
local VEC343 = Vec3(3,4,3);

local ScriptData = {AutoData = {}};

GG.Configs = GG.Configs or {
    ["Generator"] = {};
    ["Gate"] = {};
    ["Surivor"] = {};
    ["Client"] = {
        ["Client"] = {};
    };
};

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
    Version = "VD_V3.00";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, PromptPackage, CoruTask, ESPF, CommonF)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;
        local GalaxyF           = nil;

        local lastPosition      = Vector3.zero;
        local isMoving          = false
        local threshold         = 0.05;
        local Seat              = nil;
        local Cam               = W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf           = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf.RootPart;

        local cmdm              = selff:GetMouse();
        local ClientCon         = GG.Configs.Client.Client;
        local GenCon            = GG.Configs.Generator;
        local GateCon           = GG.Configs.Gate;
        local SurCon            = GG.Configs.Surivor;

        local dist              = CommonF.dist;

        local GMap              = WaitForChild(W, "Map", 9e9);

        local RRemotes          = WaitForChild(R, "Remotes", 9e9);
        local RGenerator        = WaitForChild(RRemotes, "Generator", 9e9);
        local RExit             = WaitForChild(RRemotes, "Exit", 9e9);
        local RHealing          = WaitForChild(RRemotes, "Healing", 9e9);
        local RCarry            = WaitForChild(RRemotes, "Carry", 9e9);
        
        local Functions         = {};

        local RE = {
            RepairEvent = WaitForChild(RGenerator, "RepairEvent");
            LeverEvent = WaitForChild(RExit, "LeverEvent");
            HealEvent = WaitForChild(RHealing, "HealEvent");
            UnHookEvent = WaitForChild(RCarry, "UnHookEvent");
        };

        Functions.IsOnInteraction = function()
            return (GetAttribute(selc, "repairing") or 0) > 0
                or GetAttribute(selc, "isUnhooking")
                or GetAttribute(selc, "isHealing")
                or GetAttribute(selc, "Knocked")
                or GetAttribute(selc, "IsHooked")
                or GetAttribute(selc, "IsCarried");
        end;
        Functions.GetKiller = function()
            local aPS = GetPlayers(P);
            for i=1, #aPS do
                local v = aPS[i]; if v and v.Character then
                    if GetAttribute(v.Character, "Chasemusic") then
                        return v.Character;
                    end;
                end;
            end; return nil;
        end;
        Functions.IsNearKiller = function(self, genp)
            local GetKiller = self.GetKiller();
            if not GetKiller or not FindFirstChild(GetKiller, "Head") then return false; end;
            if (genp.Position - GetKiller.Head.Position).Magnitude <= 30 then
                return true;
            end; return false;
        end;
        Functions.GetResueBlock = function()
            if not GAntifling or not GAntifling.Parent then
                GAntifling = FindFirstChild(GMap, "Antifling");
            end; return GAntifling and FindFirstChild(GAntifling, "RescueTp");
        end;
        Functions.GetExit = function()
            local Exit1 = FindFirstChild(GMap, "Exit1");
            if Exit1 then
                local Line = FindFirstChild(Exit1, "Fininshline", true);
                if Line then
                    return {Line};
                end;
            end;

            local FinishLines, GMapC = {}, GetChildren(GMap);
            for i=1, #GMapC do
                local v = GMapC[i]; if v.Parent and v.Name == "Fininshline" then
                    if IsA(v, "BasePart") and v.CanTouch then
                        tble.insert(FinishLines, v);
                    end;
                end;
            end; return FinishLines;
        end;
        Functions.Exit = function(self)
            local Exits = self.GetExit();
            if #Exits == 0 then return; end;

            for i=1, #Exits do
                local v = Exits[i]; if v.Parent then
                    if not HumRSelf or not HumRSelf.Parent then return; end;
                    CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                end;
            end;
        end;
        Functions.GetGenerators = function()
            local tbl = {};

            local NGs = FindFirstChild(GMap, "newGenerators") and GetChildren(GMap.newGenerators);
            local GEs = FindFirstChild(GMap, "Gens") and GetChildren(GMap.Gens) or {};
            local Gs = FindFirstChild(GMap, "Generators") and GetChildren(GMap.Generators) or {};

            NGs = NGs or FindFirstChild(GMap, "new Generators") and GetChildren(GMap["new Generators"]) or {};

            for i=1, #NGs do
                local v=NGs[i]; if v.Parent then
                    tble.insert(tbl, v);
                end;
            end; if #tbl > 0 then return tbl; end;

            for i=1, #GEs do
                local v=GEs[i]; if v.Parent then
                    tble.insert(tbl, v);
                end;
            end; if #tbl > 0 then return tbl; end;

            for i=1, #Gs do
                local v=Gs[i]; if v.Parent then
                    tble.insert(tbl, v);
                end;
            end; return tbl;
        end;
        Functions.FireGenerator = function(self, Gen)
            if not HumRSelf or not HumRSelf.Parent or not Gen or not Gen.Parent then return; end;
            if self.IsOnInteraction() or self.IsGateReady() then return false; end;
            local GeneratorPoint = FindFirstChild(Gen, "GeneratorPoint1") or FindFirstChild(Gen, "GeneratorPoint2");
            if not GeneratorPoint or self:IsNearKiller(GeneratorPoint) then return false; end;

            CommonF.Tp(HumRSelf, GeneratorPoint.CFrame, 0.5);
            return true, RE.RepairEvent:FireServer(GeneratorPoint, true), twait(1), tk.spawn(function()
                while true do
                    if not GenCon.Auto or (not GenCon.DisableMovement and isMoving) or (GetAttribute(Gen, "RepairProgress") or 0) >= 100 or Functions:IsNearKiller(GeneratorPoint) or CoreDestroyed then
                        RE.RepairEvent:FireServer(GeneratorPoint, false);
                        break;
                    end; twait(0.05);
                end;
            end);
        end;
        Functions.ESPGenerator = function(Gens)
            if not GenCon.ESP or not Gens or #Gens == 0 then return; end;
            for i=1, #Gens do
                local v=Gens[i]; if v.Parent then
                    if GenCon.ESP then
                        local PrimPart = FindFirstChild(v, "HitBox");
                        if not PrimPart then continue; end;
                        local Bill = FindFirstChild(PrimPart, "BillboardGui");
                        if Bill then
                            local Text = FindFirstChild(Bill, "TextLabel"); if Text then
                                Text.Text = str.format("Generator\n%d%%", GetAttribute(v, "RepairProgress") or 0);
                            end;
                        else
                            ESPF.ESP("Gens", PrimPart, PURPLE, VEC5, false, false, nil, nil);
                        end;
                    end;
                end;
            end;
        end;
        Functions.AutoGenerators = function(self, Gens)
            if not GenCon.Auto or not Gens or #Gens == 0 then return; end;
            for i=1, #Gens do
                local v=Gens[i]; if v.Parent then
                    local RepairProgress = GetAttribute(v, "RepairProgress") or 0;
                    if RepairProgress >= 100 then continue; end;

                    if GenCon.Auto then
                        self:FireGenerator(v);
                    end;
                end;
            end;
        end;
        Functions.IsGateReady = function()
            local PGSurvivor = FindFirstChild(PSG, "Survivor");
            if not PGSurvivor then return false; end;
            local PGGen = FindFirstChild(PGSurvivor, "Gen");
            if not PGGen or not FindFirstChild(PGGen, "Gencount") then return false; end;
            return PGGen.Gencount.Text == "0";
        end;
        Functions.GetGates = function()
            local tbl, GMapC = {}, GetChildren(GMap);
            for i=1, #GMapC do
                local v = GMapC[i]; if v.Name == "Gate" and v.ClassName == "Model" and v.Parent then
                    local ExitLever = FindFirstChild(v, "ExitLever");
                    local Main = ExitLever and FindFirstChild(ExitLever, "Main");
                    local Highlight = Main and FindFirstChild(Main, "Highlight");
                    if not Highlight then continue; end;
                    tble.insert(tbl, Main);
                end;
            end;
            
            if #tbl == 0 then
                local Exit1 = FindFirstChild(GMap, "Exit1");
                local Exit2 = FindFirstChild(GMap, "Exit2");

                local Gate1 = Exit1 and FindFirstChild(Exit1, "Main");
                local Gate2 = Exit2 and FindFirstChild(Exit2, "Main");

                if Gate1 and Gate1.Parent then
                    local ExitLever = FindFirstChild(Gate1, "ExitLever");
                    local Main = ExitLever and FindFirstChild(ExitLever, "Main");
                    local Highlight = Main and FindFirstChild(Main, "Highlight");
                    if Highlight then
                        tble.insert(tbl, Main);
                    end;
                end;
                if Gate2 and Gate2.Parent then
                    local ExitLever = FindFirstChild(Gate2, "ExitLever");
                    local Main = ExitLever and FindFirstChild(ExitLever, "Main");
                    local Highlight = Main and FindFirstChild(Main, "Highlight");
                    if Highlight then
                        tble.insert(tbl, Main);
                    end;
                end;
            end;
            
            return tbl;
        end;
        Functions.FireGate = function(self, Gate, Interaction)
            if not HumRSelf or not HumRSelf.Parent or not Gate or not Gate.Parent then return; end;
            if not Interaction or GetAttribute(Interaction, "isExiting") or GetAttribute(Interaction, "isRepairing") then return; end;

            CommonF.Tp(HumRSelf, Gate.CFrame, 0.5);
            return true, RE.LeverEvent:FireServer(Gate, true), twait(1), tk.spawn(function()
                while true do
                    if not GateCon.Auto or not GetAttribute(Interaction, "isExiting") or (not GateCon.DisableMovement and isMoving) or (GetAttribute(Gate, "ActivationProgress") or 0) >= 100 or self:IsNearKiller(Gate) or CoreDestroyed then
                        RE.LeverEvent:FireServer(Gate, false);
                        break;
                    end; twait(0.05);
                end;
            end);
        end;
        Functions.ESPGates = function(Gates)
            if not GateCon.ESP or not Gates or #Gates == 0 then return; end;
            for i=1, #Gates do
                local v=Gates[i]; if v.Parent then
                    if GateCon.ESP then
                        local Bill = FindFirstChild(v, "BillboardGui");
                        if Bill then
                            local Text = FindFirstChild(Bill, "TextLabel"); if Text then
                                Text.Text = str.format("Gate\n%d%%", GetAttribute(v, "ActivationProgress") or 0);
                            end;
                        else
                            ESPF.ESP("Gates", v, WHITE, VEC5, false, false, nil, nil);
                        end;
                    end;
                end;
            end;
        end;
        Functions.AutoGate = function(self, Gates)
            if (not GateCon.Auto and not GateCon.Exit) or not Gates or #Gates == 0 then
                if GateCon.Auto and GateCon.JustExit then
                    return self:Exit();
                end; return;
            end;

            local Interaction = selc and FindFirstChild(selc, "CheckInterractable");
            if not Interaction or GetAttribute(Interaction, "isExiting") then return; end;

            if GateCon.Exit then
                if not GateCon.Auto then
                    return self:Exit();
                end;
                for i=1, #Gates do
                    local v=Gates[i]; if v.Parent then
                        local Progress = GetAttribute(v, "ActivationProgress") or 0;
                        if Progress >= 100 then
                            return self:Exit(), twait(5);
                        end;
                    end;
                end;
            end;

            for i=1, #Gates do
                local v=Gates[i]; if v.Parent then
                    local Progress = GetAttribute(v, "ActivationProgress") or 0;
                    local IsBusy = GetAttribute(v, "IsBeingActivated");

                    if not IsBusy and Progress < 100 then
                        self:FireGate(v, Interaction);
                    end;
                end;
            end;
        end;
        Functions.STeleportTo = function(where)
            if where == "Gen" then
                local Gens = Functions.GetGenerators();
                for i=1, #Gens do
                    local v=Gens[i]; if v.Parent then
                        local RepairProgress = GetAttribute(v, "RepairProgress") or 0;
                        if RepairProgress >= 100 then continue; end;
                        local GeneratorPoint = FindFirstChild(v, "GeneratorPoint1") or FindFirstChild(v, "GeneratorPoint2");
                        if not GeneratorPoint then return false; end;
                        return CommonF.Tp(HumRSelf, GeneratorPoint.CFrame, 0.5);
                    end; return;
                end;
            elseif where == "Gate" then
                local Gates = Functions.GetGates();
                for i=1, #Gates do
                    local v=Gates[i]; if v.Parent then
                        return CommonF.Tp(HumRSelf, v.CFrame, 0.5);
                    end;
                end; return;
            else
                local aPS = GetPlayers(P);
                local validTargets = {};

                for i=1, #aPS do
                    local v = aPS[i];
                    if v == selff then continue; end;
                    local char = v.Character;
                    if not char then continue; end;
                    
                    if not GetAttribute(char, "Chasemusic") then
                        if where == "Random" then
                            tble.insert(validTargets, char);
                        elseif where == "Knocked" and GetAttribute(char, "Knocked") then
                            tble.insert(validTargets, char);
                        elseif where == "Hooked" and GetAttribute(char, "IsHooked") then
                            tble.insert(validTargets, char);
                        end;
                    end;
                end;

                if #validTargets > 0 then
                    local targetChar = validTargets[math.random(1, #validTargets)];
                    local targetHRP = FindFirstChild(targetChar, "HumanoidRootPart") or FindFirstChild(targetChar, "Head");
                    if targetHRP and HumRSelf then
                        return CommonF.Tp(HumRSelf, targetHRP.CFrame, 0.5);
                    end;
                end;
            end;
        end;
        Functions.ESPSurvivors = function(Chars)
            if not SurCon.ESP or #Chars == 0 then return; end;
            local validTargets = {}; for i=1, #Chars do
                if not SurCon.ESP then return; end;
                local char = Chars[i]; if char.Parent and char ~= selc then
                    local ChaseM = GetAttribute(char, "Chasemusic");
                    if not ChaseM then
                        local IsKnocked = GetAttribute(char, "Knocked");
                        local IsHooked = GetAttribute(char, "IsHooked");
                        
                        local TColor = if IsKnocked then YELLOW elseif IsHooked then ORANGE else GREEN;
                        local box = FindFirstChild(char, "BoxHandleAdornment");
                        local bill = FindFirstChild(char, "BillboardGui");
                        
                        if not box then
                            ESPF.ESP("Survivors", char, TColor, VEC343, false, false, nil, nil);
                        else
                            box.Color3 = TColor;
                            if bill then
                                local text = FindFirstChild(bill, "TextLabel");
                                if text then
                                    text.TextColor3 = TColor;
                                end;
                            end;
                        end;
                    elseif ChaseM then
                        if FindFirstChild(char, "BoxHandleAdornment") then
                            ESPF.Destroy("Survivors");
                        end;
                    end;
                end;
            end;
        end;
        Functions.Revive = function(self, HumR)
            if not HumR or not HumR.Parent then return; end;

            local Interaction = selc and FindFirstChild(selc, "CheckInterractable");
            if not Interaction or GetAttribute(Interaction, "isHealing") then return; end;
            if self:IsOnInteraction() then return; end;

            CommonF.Tp(HumRSelf, HumR.CFrame, 1);
            return RE.HealEvent:FireServer(HumR, true), tk.spawn(function()
                while true do
                    if not SurCon.AutoRevive or CoreDestroyed or not HumR.Parent or not GetAttribute(Interaction, "isHealing") then
                        return RE.HealEvent:FireServer(HumR, false);
                    end; twait(0.05);
                end;
            end);
        end;
        Functions.Unhook = function()
            return nil;
        end;
        Functions.CharsActions = function(self, chars)
            if not SurCon.AutoRevive or not SurCon.AutoUnhook or #chars == 0 then return; end;
            
            for i=1, #chars do
                local v=chars[i]; if v.Parent then
                    if GetAttribute(v, "Chasemusic") then
                        continue;
                    end;

                    local IsKnocked = GetAttribute(v, "Knocked");
                    local IsHooked = GetAttribute(v, "IsHooked");

                    local HumR = FindFirstChild(v, "HumanoidRootPart");

                    if IsKnocked and SurCon.AutoRevive then
                        self:Revive(HumR);
                    elseif IsHooked and SurCon.AutoUnhook then
                        self:Unhook(v);
                    end;
                end;
            end;
        end;

        ScriptData.AutoData = {
            ClientTab = {
                {type="Toggle", EN="Self-Revive", EN2="Make interactions possible again but your health still drain.", TH1="ชุบตัวเอง", TH2="ทำให้สามารถเล่นเกมได้ปกติ แต่เลือดจะลดเหมือนเดิมจะกว่าจะมีคนมาชุบให้", Bindable="+", Path="SelfRevive", Callback=function(state)
                    ClientCon.SelfRevive = state;
                    if not CoruTask.Intialized then return; end;
                    if HumSelf.Health <= 20 then
                        HumSelf.Health = 100;
                    else
                        HumSelf.Health = 20;
                    end;
                end}, {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                        {type="Toggle", EN="Instant Prompt", EN2="On some prompt/maps, this can flag anti cheat so remember to turn it off when you have to.", TH1="กด Prompt เร็วขึ้น", TH2="กดพวกปุ่มที่มันขึ้นมาให้กดเร็วขึ้น (Class:Prompt)", Path="Client/Instant Prompt"},
                        {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                        {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                        {type="Slider", EN="Walk Speed", EN2="Change the speed of your walk.", TH1="ความเร็วในการเดิน", TH2="ปรับความเร็วการเดิน", Value={Min=1, Max=100}, Path="Client/WalkSpeed"},
                        {type="Toggle", EN="Enable Walk Speed", EN2="Enable walk speed modification.", TH1="เปิดใช้งานความเร็วในการเดิน", TH2="ปรับความเร็วในการเดิน", Path="Client/Enable WalkSpeed"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                        {type="Slider", EN="Jump Power", EN2="Change the power of your jump.", TH1="ความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Value={Min=1, Max=300}, Path="Client/JumpPower"},
                        {type="Toggle", EN="Enable Jump Power", EN2="Enable jump power modification.", TH1="เปิดใช้งานความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Path="Client/Enable JumpPower"}, {type="Space"},
                    }, Title="Client", Open=true};
                }};
            };
            GeneratorTab = {
                {type="Button", EN="Teleport To Generator", EN2="Teleport to incompleted generators.", TH1="วาปไปหาเครื่องปั่นไฟ", TH2="วาปไปหาเครื่องปั่นไฟที่ยังไม่เสร็จ", Callback=function()
                    Functions.STeleportTo("Gen");
                end}, {type="Space"}; {type="Space"};
                {type="Toggle", EN="Auto Generators", EN2="Teleport & fix generators with Killer Distance Detection", TH1="ออโต้ปั่นไฟ", TH2="วาปไปปั่นไฟให้ครบ", Path="Auto"},
                {type="Toggle", EN="Disable Movement Detection", EN2="Allows you to use Teleport Walk without canceling the repair progression.", TH1="ระงับการตรวจจับการเคลื่อนที่", TH2="เวลาใช้เดินแบบวาปจะไม่หลุดออกจากเครื่องปั่นไฟ", Path="DisableMovement"}, {type="Space"}; {type="Space"};
                {type="Toggle", EN="ESP Generators", EN2="Show generator boxes & status", TH1="ESP เครื่องปั่นไฟ", TH2="มองเห็นเครื่องปั่นไฟ", Path="ESP"},
            };
            GateTab = {
                {type="Button", EN="Teleport To Gate", EN2="Teleport to any gate as long as you already completed generators.", TH1="วาปไปทางออก", TH2="วาปไปที่ทางออกสักอัน", Callback=function()
                    Function.STeleportTo("Gate");
                end}, {type="Space"}; {type="Space"};
                {type="Toggle", EN="Auto Open Gate", EN2="Open gates automatically.", TH1="เปิดทางออกอัตโนมัติ", TH2="เปิดทางออกให้เอง", Path="Auto"},
                {type="Toggle", EN="Auto Exit Gates", EN2="If you disabled 'Auto Open Gate', this will instant escape.", TH1="ออโต้ออก", TH2="ถ้าไม่ได้เปิดออโต้เปิดทางออก จะวาปออกทันที", Path="Exit"},
                {type="Toggle", EN="Just Exit", EN2="Allow you to exit the match without complete anything BRUH.. You gain point btw. You have to enable 'Auto Exit Gates' for this to work.", TH1="ออกดีกว่าช่างแม่ง", TH2="วาปออกไปเลย โดยที่ไม่ต้องปั่นไฟ แต่ต้องเปิด 'ออโต้ออก'", Path="JustExit"},
                {type="Toggle", EN="Disable Movement Detection", EN2="Allows you to use Teleport Walk without canceling the gate progression.", TH1="ระงับการตรวจจับการเคลื่อนที่", TH2="เวลาใช้เดินแบบวาปจะไม่หลุดออกจากคันโยก", Path="DisableMovement"}, {type="Space"}; {type="Space"};
                {type="Toggle", EN="ESP Gates", EN2="Show gate boxes & status. Only work if you completed all generators", TH1="ESP ทางออก", TH2="มองเห็นทางออก", Path="ESP"},
            };
            SurivorTab = {
                {type="Button", EN="Teleport To Survivor", EN2="Teleport to any survivor randomly", TH1="วาปไปหาผู้รอดชีวิต", TH2="วาปไปหาผู้รอดชีวิตแบบสุ่มๆ", Callback=function()
                    Functions.STeleportTo("Random");
                end},
                {type="Button", EN="Teleport To Knocked", EN2="Teleport to any knocked survivor.", TH1="วาปไปหาผู้ที่ล้ม", TH2="วาปไปหาผู้รอดชีวิตที่ล้มอยู่", Callback=function()
                    Functions.STeleportTo("Knocked");
                end},
                {type="Button", EN="Teleport To Hooked", EN2="Teleport to any hooked survivor.", TH1="วาปไปหาผู้ที่โดนแขวน", TH2="วาปไปหาผู้รอดชีวิตที่โดนแขวนอยู่", Callback=function()
                    Functions.STeleportTo("Hooked");
                end}, {type="Space"}; {type="Space"};
                {type="Toggle", EN="Auto Revive Survivors", EN2="Teleport & revive survivors", TH1="ออโต้ชุบผู้รอดชีวิต", TH2="วาปไปชุบผู้รอดชีวิต", Locked=true, Path="AutoRevive"},
                {type="Toggle", EN="Auto Unhook Survivors", EN2="Teleport & unhook survivors", TH1="ออโต้ปลดผู้รอดชีวิต", TH2="วาปไปปลดผู้รอดชีวิต", Locked=true, Path="AutoUnhook"}, {type="Space"}; {type="Space"};
                {type="Toggle", EN="ESP Survivors", EN2="Show survivor boxes & status", TH1="ESP ผู้รอดชีวิต", TH2="มองเห็นผู้รอดชีวิต", Path="ESP"},
            };
        };

        CoruTask.New("Generator Action", function()
            while true do
                if (not GenCon.Auto and not GenCon.ESP) or CoreDestroyed then
                    ESPF.Destroy("Gens");
                    CoruTask.Close("Generator Action");
                end;

                local Gens = Functions.GetGenerators();
                Functions:AutoGenerators(Gens);
                Functions.ESPGenerator(Gens);
                
                twait(0.1);
            end;
        end);
        CoruTask.New("Gate Action", function()
            while true do
                if (not GateCon.Auto and not GateCon.ESP) or CoreDestroyed then
                    ESPF.Destroy("Gates");
                    CoruTask.Close("Gate Action");
                end;

                local Gates = Functions.GetGates();
                Functions:AutoGate(Gates);
                Functions.ESPGates(Gates);
                
                twait(0.1);
            end;
        end);
        CoruTask.New("Player Action", function()
            while true do
                if (not SurCon.ESP and not SurCon.AutoRevive and not SurCon.AutoUnhook) or CoreDestroyed then
                    ESPF.Destroy("Survivors");
                    CoruTask.Close("Player Action");
                end;

                local Chars, Players = {}, GetPlayers(P);
                for i=1, #Players do
                    local v=Players[i]; if v.Parent and v.Character then
                        tble.insert(Chars, v.Character);
                    end;
                end;
                
                Functions.ESPSurvivors(Chars);
                Functions:CharsActions(Chars);

                twait(0.1);
            end;
        end);

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Violence District",
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
                }, Topbar = {
                    Height = 44,
                    ButtonsType = "Mac",
                },
            });
            local Tabs = {
                Welcome = Window:Tab({Title="Welcome", Icon="smile"}),
                Client = LoaderSettings.AllowClientTab and Window:Tab({Title="Client", Icon="user"}),

                Div1 = Window:Divider(),
                Generator = Window:Tab({Title="Generator", Icon="wrench"}),
                Gate = Window:Tab({Title="Gate", Icon="door-closed-locked"}),
                Surivor = Window:Tab({Title="Surivor", Icon="person-standing"}),

                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);

            Window:SetToggleKey((LoaderSettings.UIKeybind and Enum.KeyCode[LoaderSettings.UIKeybind]) or Enum.KeyCode["V"]);
            
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.Generator, ScriptData.AutoData.GeneratorTab, "Generator");
            Windy:CreateComponent(Tabs.Gate, ScriptData.AutoData.GateTab, "Gate");
            Windy:CreateComponent(Tabs.Surivor, ScriptData.AutoData.SurivorTab, "Surivor");

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
                PromptPackage.UpdateState(true);
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function(AUTH_KEY)
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
            end; local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false; PromptPackage.UpdateState(false);
                ClientCon.WalkSpeed = HumSelf and HumSelf.WalkSpeed or 16;
                ClientCon.JumpPower = HumSelf and HumSelf.JumpPower or 50;
                
                LSecureUI();

                tk.spawn(function()
                    while not CoreDestroyed do
                        if GenCon.Auto or GenCon.ESP then
                            CoruTask.Handle("Generator Action");
                        end;
                        if GateCon.Auto or GateCon.Exit or GateCon.ESP then
                            CoruTask.Handle("Gate Action");
                        end;
                        if SurCon.ESP or SurCon.AutoRevive or SurCon.AutoUnhook then
                            CoruTask.Handle("Player Action");
                        end;
                        twait(0.1);
                    end;
                end);

                CoreConnection[1] = H.Stepped:Connect(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect(); CoreConnection[1] = nil;
                        return;
                    end;

                    Backpack = selff.Backpack;
                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
                    ClientPackage.WalkSpeedC(ClientCon["Enable WalkSpeed"], ClientCon.WalkSpeed, HumSelf);
                    ClientPackage.JumpPower(ClientCon["Enable JumpPower"], ClientCon.JumpPower, HumSelf);
                end);
                CoreConnection[2] = H.Heartbeat:Connect(function(delta)
                    if CoreDestroyed and CoreConnection[2] then
                        CoreConnection[2]:Disconnect(); CoreConnection[2] = nil;
                        return;
                    end;

                    if ClientCon["Enable TeleportWalk"] and selc and HumSelf and HumSelf.MoveDirection.Magnitude > 0 then
                        selc:TranslateBy(HumSelf.MoveDirection * ClientCon["TeleportWalk Speed"] * delta * 10);
                    end;
                end);
                CoreConnection[3] = H.RenderStepped:Connect(function()
                    if not HumRSelf or not HumRSelf.Parent then return; end;
                    local currentPosition = HumRSelf.Position;
                    local delta = currentPosition - lastPosition;
                    local horizontalSpeed = Vec3(delta.X, 0, delta.Z).Magnitude;
                    isMoving = horizontalSpeed > threshold;
                    lastPosition = currentPosition;
                end);

                if not CoruTask.Intialized then
                    CoruTask.Init(WindUI);
                    CoruTask.Intialized = true;
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
