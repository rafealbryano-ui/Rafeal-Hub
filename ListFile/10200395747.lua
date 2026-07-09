local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[Rafael Studio] : Really? Your account is now at risk for the next ban wave."); end;

local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local HttpService = GG.HttpService;
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
local Destroy = game.Destroy;
local TwInfo = TweenInfo.new;
local GetPlayers = P.GetPlayers;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local GetDescendants = game.GetDescendants;
local FindFirstChild = game.FindFirstChild;
local GenerateGUID = HttpService.GenerateGUID;
local GetPlayerByUserId = P.GetPlayerByUserId;
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
local FindFirstAncestorOfClass = game.FindFirstAncestorOfClass;

local LOWESTNUM = 0.000000032;

local RED = Col3.new(1,0,0);
local GREEN = Col3.new(0, 1, 0);
local BLUE = Col3.new(0, 0, 1);
local WHITE = Col3.new(1, 1, 1);

local DISABLELOD = Enum.ModelLevelOfDetail.Disabled;

local EMPTYF = function() end;

local MUTCOLOR = {
    Gold = "#FFD700",
    Rainbow = "#FF69FF",
    Electric = "#00FFFF",
    Frozen = "#80DFFF",
    Starstruck = "#FFFACD",
    Bloodlit = "#AA0000",
    Chained = "#808080",
    Solarflare = "#FF6600",
    Pizza = "#FFCC66",
}

local EXPANDCOST = {500, 40000, 1000000, 40000000, 200000000};

local ScriptData = {
    AutoData = {};
};

GG.Configs = GG.Configs or {
    ["Garden"] = {};
    ["Plant"] = {
        ["SelectPlant"] = {};
        ["SavedSpots"] = {};
        ["SelectSpot"] = "Random Both Area";
        ["CircleSize"] = 1;
        ["SelectPlantShovel"] = {};
        ["ShovelDistance"] = 20;
    };
    ["Harvest"] = {
        ["SelectPlant"] = "Acorn";
        ["Schemas"] = {};
    };
    ["Sell"] = {
        ["SelectFruit"] = "Acorn";
        ["Schemas"] = {};
    };
    ["Steal"] = {
        ["Select Player Shovel"] = {};
        ["Select Player"] = {};
    };
    ["Shop"] = {
        ["Seeds"] = {};
        ["Gears"] = {};
        ["Pets"] = {};
    };
    ["Client"] = {
        ["Client"] = {
            ["FPSCap"] = 60;
            ["TeleportWalk Speed"] = 1;
        };
    };
    ["Events"] = {
        ["Seeds"] = {
            ["Gold"] = false;
            ["Rainbow"] = false;
        };
    };
};

GG.Configs.Events = GG.Configs.Events or {
    ["Seeds"] = {
        ["Gold"] = false;
        ["Rainbow"] = false;
    };
};
GG.Configs.Shop.Pets = GG.Configs.Shop.Pets or {};
GG.Configs.Steal = GG.Configs.Steal or {["Select Player"] = {}};

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
    Version = "GAG2_V3.15";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, CoruTask, ESPF, CommonF)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;
        local GalaxyF           = nil;

        local AllGardens        = nil;
        local AllProps          = nil;
        local GVC               = nil;
        local PVC               = nil;
        local TVC               = nil;
        local CurrentPage       = 0;
        local CurrentPage2      = 0;
        local PurchaseData      = nil;
        local Seat              = nil;
        local Cam               = W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf           = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf.RootPart;
        local PSS               = selff.PlayerScripts;
        local Suid              = selff.UserId;

        local cmdm              = selff:GetMouse();
        local GardenCon         = GG.Configs.Garden;
        local PlantCon          = GG.Configs.Plant;
        local HarvestCon        = GG.Configs.Harvest;
        local SellCon           = GG.Configs.Sell;
        local StealCon          = GG.Configs.Steal;
        local ShopCon           = GG.Configs.Shop;
        local EventsCon         = GG.Configs.Events;
        local ClientCon         = GG.Configs.Client.Client;
        local GPGuids           = {GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService)};
        local GTGuids           = {GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService), GenerateGUID(HttpService)};

        local Map               = WaitForChild(W, "Map", 9e9);
        local SeedPackSpawn     = WaitForChild(Map, "SeedPackSpawnServerLocations", 9e9);

        local SharedData        = WaitForChild(R, "SharedData", 9e9);
        local SharedModules     = WaitForChild(R, "SharedModules", 9e9);
        local SController       = WaitForChild(PSS, "Controllers", 9e9); 

        local GSController      = require(WaitForChild(SController, "GardenSyncController", 9e9));
        local FVC               = require(WaitForChild(SController, "FruitVisualizerController", 9e9));
        local FruitValueCalc    = require(WaitForChild(SharedModules, "FruitValueCalc", 9e9));
        local Networking        = require(WaitForChild(SharedModules, "Networking", 9e9));
        local SeedData          = require(WaitForChild(SharedModules, "SeedData", 9e9));
        local PetData           = require(WaitForChild(SharedData, "PetData", 9e9));
        local GearData          = require(WaitForChild(SharedModules, "GearShopData", 9e9)).Data;
        local Mutations         = {"Gold", "Rainbow", "Electric", "Frozen", "Bloodlit", "Chained", "Starstruck"};

        local Garden            = WaitForChild(W, "Gardens", 9e9);
        local Plot              = WaitForChild(Garden, "Plot"..GetAttribute(selff, "PlotId"), 9e9);

        local dist              = CommonF.dist;
        
        local Functions         = {};
        local RE                = {
            SellAll             = Networking.NPCS.SellAll;
            CollectFruit        = Networking.Garden.CollectFruit;
            SellFruit           = Networking.NPCS.SellFruit;
            PurchaseSeed        = Networking.SeedShop.PurchaseSeed;
            PurchaseGear        = Networking.GearShop.PurchaseGear;
            BeginSteal          = Networking.Steal.BeginSteal;
            CompleteSteal       = Networking.Steal.CompleteSteal;
            WildPetTame         = Networking.Pets.WildPetTame;
            ExpandGarden        = Networking.Actions.ExpandGarden;
            UseShovel           = Networking.Shovel.UseShovel;
            SwingShovel         = Networking.Shovel.SwingShovel;
            HitPlayer           = Networking.Shovel.HitPlayer;
            PlantSeed           = Networking.Plant.PlantSeed;
        };

        local function ColorMutation(Mutation)
            local Color = MUTCOLOR[Mutation];
            if Color then
                return string.format(
                    '<font color="%s">%s</font>',
                    Color,
                    Mutation
                );
            end; return tostring(Mutation or "None");
        end;
        local function FormatEntry(Entry)
            local Price = Entry.Price;
            local PriceText = tostring(Price);
            if Price >= 5000 then
                PriceText = str.format(
                    '<font color="#FF4444">%s</font>',
                    PriceText
                );
            end;
            local Title = str.format(
                "%s [$%s]",
                Entry.PlantName or "Unknown",
                PriceText
            );
            local Desc = str.format(
                "Mutation: %s, Weight: %.2fkg\nAge: %s/%s",
                ColorMutation(Entry.Mutation),
                tonumber(Entry.Weight) or 0,
                tostring(Entry.Age),
                tostring(Entry.MaxAge)
            ); return Title, Desc;
        end;
        local function UpdateDesc(btn, ESP, Destroyed)
            btn:SetDesc(str.format(
                'ESP: <font color="%s">%s</font> ; Destroyed: <font color="%s">%s</font>',
                ESP and "#00FF00" or "#FF0000",
                ESP and "Enabled" or "Disabled",
                Destroyed and "#00FF00" or "#FF0000",
                Destroyed and "Yes" or "No"
            ));
        end;

        Functions.PairData = function(tab, goal, values)
            local tblx = {{type="Group", dats={
                {dat={}, Title=goal}
            }}, {type="Space"}, {type="Space"}};

            if goal == "Seeds" then
                for i=1, #values do
                    local v=values[i]; if type(v) ~= "table" or not v.PurchasePrice or not v.RestockShop then
                        continue;
                    end;

                    local Price = tostring(v.PurchasePrice);
                    tble.insert(tblx[1].dats[1].dat, {
                        type="Toggle";
                        EN=v.SeedName;
                        EN2="Cost: "..Price.. " ; Available: No";
                        TH1=v.SeedName;
                        TH2="ราคา: "..Price .. " ; ขายอยู่: No";
                        Path=goal.."/"..v.SeedName;
                    });
                end
            elseif goal == "Gears" then
                for i=1, #values do
                    local v=values[i]; if type(v) ~= "table" or not v.RestockChance or not v.Cost or not v.ItemName or not v.ItemType then
                        continue;
                    end;

                    local Price = tostring(v.Cost);
                    tble.insert(tblx[1].dats[1].dat, {
                        type="Toggle";
                        EN=v.ItemName;
                        EN2="Cost: "..Price.. " ; Available: No";
                        TH1=v.ItemName;
                        TH2="ราคา: "..Price .. " ; ขายอยู่: No";
                        Path=goal.."/"..v.ItemName;
                    });
                end;
            elseif goal == "Pets" then
                for i,v in values do
                    if type(v) ~= 'table' then continue; end;
                    local Price = tostring(v.BasePrice);
                    tble.insert(tblx[1].dats[1].dat, {
                        type="Toggle";
                        EN=i;
                        EN2="Cost: "..Price;
                        TH1=i;
                        TH2="ราคา: "..Price;
                        Path=goal.."/"..i;
                    });
                end;
            end;

            return Windy:CreateComponent(tab, tblx, "Shop");
        end;
        Functions.PairHarvest = IB_NO_VIRTUALIZE(function(i, ina)
            local TargetSeed = i or HarvestCon.SelectPlant;
            if not TargetSeed then return; end;

            local GUIDs = {GenerateGUID(HttpService), GenerateGUID(HttpService)};
            local Schema = ina or {
                Mutations = {};
                Weight = nil;
            };
            
            local RWeight = nil;
            if Schema.Weight then
                RWeight = str.format("%s-%s", tostring(Schema.Weight.MinWeight or ""), tostring(Schema.Weight.MaxWeight or ""));
            else
                RWeight = "";
            end;

            Windy:CreateComponent(ScriptCache.HarvestTab, {
                {type="Group", dats={
                    {dat={
                        {type="Space"}; {type="Dropdown", Title="Select Mutation", TH1="เลือก Mutation", Multi=true, AllowNone=true, Value=Schema.Mutations, Values=Mutations, Callback=function(...)
                            Schema.Mutations = ...;
                        end};
                        {type="Input", Title="Weight Pool", TH1="ช่วงน้ำหนัก", Placeholder="Ex. 100-2000", Value=RWeight, Callback=function(val)
                            local Split = str.split(val, "-");
                            if #Split == 2 then
                                local Min = tonumber(Split[1]);
                                local Max = tonumber(Split[2]);
                                Schema.Weight = {MinWeight=Min, MaxWeight=Max};
                                return;
                            end; Schema.Weight = nil;
                        end};
                        {type="Button", Title="Delete This Schema", TH1="ลบตารางนี้", Callback=function()
                            tble.remove(HarvestCon.Schemas[TargetSeed], tble.find(HarvestCon.Schemas[TargetSeed], Schema));
                            ScriptCache[Schema].ElementFrame.Parent:Destroy();
                            ScriptCache[GUIDs[1]].ElementFrame:Destroy();
                            ScriptCache[GUIDs[2]].ElementFrame:Destroy();
                        end}; {type="Space"};
                    }, Title=TargetSeed, Global=Schema};
                }}; {type="Space", Global=GUIDs[1]}; {type="Space", Global=GUIDs[2]};
            }, "Harvest");

            if not ina then
                HarvestCon.Schemas[TargetSeed] = HarvestCon.Schemas[TargetSeed] or {};
                tble.insert(HarvestCon.Schemas[TargetSeed], Schema);
            end;
        end);
        Functions.PairSell = IB_NO_VIRTUALIZE(function(i, ina)
            local TargetSeed = i or SellCon.SelectFruit;
            if not TargetSeed then return; end;
            
            local GUIDs = {GenerateGUID(HttpService), GenerateGUID(HttpService)};
            local Schema = ina or {
                Price = nil;
            };

            local RPrice = nil;
            if Schema.Price then
                RPrice = str.format("%s-%s", tostring(Schema.Price.MinPrice or ""), tostring(Schema.Price.MaxPrice or ""));
            else
                RPrice = "";
            end;

            Windy:CreateComponent(ScriptCache.SellTab, {
                {type="Group", dats={
                    {dat={
                        {type="Input", Title="Price", TH1="ช่วงราคา", Placeholder="Ex. 100-2000", Value=RPrice, Callback=function(val)
                            local Split = str.split(val, "-");
                            if #Split == 2 then
                                local Min = tonumber(Split[1]);
                                local Max = tonumber(Split[2]);
                                Schema.Price = {MinPrice=Min, MaxPrice=Max};
                                return;
                            end; Schema.Price = nil;
                        end};
                        {type="Button", Title="Delete This Schema", TH1="ลบตารางนี้", Callback=function()
                            tble.remove(SellCon.Schemas[TargetSeed], tble.find(SellCon.Schemas[TargetSeed], Schema));
                            ScriptCache[Schema].ElementFrame.Parent:Destroy();
                            ScriptCache[GUIDs[1]].ElementFrame:Destroy();
                            ScriptCache[GUIDs[2]].ElementFrame:Destroy();
                        end}; {type="Space"};
                    }, Title=TargetSeed, Global=Schema};
                }}; {type="Space", Global=GUIDs[1]}; {type="Space", Global=GUIDs[2]};
            }, "Sell");

            if not ina then
                SellCon.Schemas[TargetSeed] = SellCon.Schemas[TargetSeed] or {};
                tble.insert(SellCon.Schemas[TargetSeed], Schema);
            end;
        end);
        Functions.GRebuild = function(self, Plants, isPrice, isWeight, uid)
            local Sorted = {}; for i, Data in Plants do
                if self.IsOnlyOne(Data) then
                    local Price = isPrice and FruitValueCalc(Data.PlantName, Data.SizeMultiplier, Data.Mutation, selff, false);
                    local Weight = isWeight and Data.Weight;
                    Sorted[#Sorted + 1] = {
                        Weight = if isWeight then Weight else nil;
                        Price = if isPrice then Price else nil;
                        PlantName = Data.PlantName;
                        Mutation = Data.Mutation;
                        MaxAge = Data.MaxAge;
                        Age = Data.Age;
                        PlantId = i;
                    };
                else
                    for fid, fd in Data.Fruits do
                        local Price = isPrice and FruitValueCalc(Data.PlantName, fd.SizeMultiplier, fd.Mutation, selff, false);
                        local DataEntry = {
                            Price = if isPrice then Price else nil,
                            PlantName = Data.PlantName,
                            Mutation = fd.Mutation,
                            MaxAge = fd.MaxAge,
                            Age = fd.Age,
                            FruitId = fid,
                            PlantId = i
                        };

                        if isWeight then
                            local Obj = self:GetFruit(DataEntry, uid)
                            if not Obj then continue; end;
                            
                            DataEntry.Obj = Obj;
                            DataEntry.Weight = FVC:CalculateFruitWeight(Obj);
                        end;

                        Sorted[#Sorted + 1] = DataEntry;
                    end;
                end;
            end; if isPrice then
                tble.sort(Sorted, function(a, b)
                    return a.Price > b.Price;
                end);
            end; return Sorted;
        end;
        Functions.PRebuild = function(self, Props, isTrap)
            local Sorted = {}; for i, Data in Props do
                Sorted[#Sorted + 1] = {
                    PropId = i;
                    Name = Data.PropName;
                };
            end; tble.sort(Sorted, function(a, b)
                local aTrap = str.find(a.Name, "Trap", 1, true) ~= nil;
                local bTrap = str.find(b.Name, "Trap", 1, true) ~= nil;
                if aTrap ~= bTrap then
                    return aTrap;
                end; return a.Name < b.Name;
            end); return Sorted;
        end;
        Functions.GetSortPage = function(Sorted, Page)
            local Start = ((Page - 1) * 10) + 1;
            local End = math.min(Start + 9, #Sorted);
            local Result = {};
            for i = Start, End do
                Result[#Result + 1] = Sorted[i]
            end; return Result;
        end;
        Functions.PairGarden = function(useCache)
            local TargetPlayer = GardenCon["Select Player"];
            TargetPlayer = TargetPlayer and FindFirstChild(P, TargetPlayer);
            if not TargetPlayer then return; end;
            local self, Plants, Rebuild = Functions, nil, nil;

            if not useCache then
                Plants = self.GetGarden(TargetPlayer);
                Rebuild = self:GRebuild(Plants, true, true, TargetPlayer.UserId);
            else
                Rebuild = ScriptCache.Rebuilt;
            end;

            CurrentPage = math.clamp(CurrentPage, 1, math.max(1, math.ceil(#Rebuild / 10)));

            local PageData = Functions.GetSortPage(Rebuild, CurrentPage);
            if #PageData == 0 then return; end;

            tk.defer(function()
                for i=1, #GPGuids do
                    local btn = ScriptCache[GPGuids[i]];
                    local LastClick, Data, ISVALID = 0, PageData[i], false;
                    if Data then
                        local Title, Desc = FormatEntry(Data);
                        btn:SetTitle(Title); btn:SetDesc(Desc);
                        btn.Callback = function()
                            local Fruit, IsOne = Data.Obj or self:GetFruit(Data, TargetPlayer.UserId);
                            if not Fruit then return; end; if LastClick > tick() then
                                if TargetPlayer ~= selff then
                                    if Functions.IsGardenLock(TargetPlayer) then
                                        ISVALID = false; return;
                                    end;
                                    repeat twait(); until ISVALID; ISVALID = false;
                                    return Functions.StealAFruit(Fruit, Data.PlantId, Data.FruitId, TargetPlayer.UserId, true);
                                else
                                    RE.CollectFruit:Fire(Data.PlantId, IsOne and "" or Data.FruitId);
                                    WindUI:Notify({
                                        Title = "<font color='rgb(0, 255, 0)'>Success</font>",
                                        Content = Title,
                                        Icon = "circle-alert",
                                        Duration = 5,
                                    });
                                end;
                            else
                                ISVALID = false;
                            end;
                            LastClick = tick() + 1;
                            Functions:LocalTp(HumRSelf, GetPivot(Fruit), 0);
                            ISVALID = true;
                        end;
                    else
                        btn:SetTitle("-"); btn:SetDesc("-"); btn.Callback = EMPTYF;
                    end;
                end;
            end);

            ScriptCache.Rebuilt = Rebuild;

            self.PairTraps();
        end;
        Functions.PairTraps = function(useCache)
            local TargetPlayer = GardenCon["Select Player"];
            TargetPlayer = TargetPlayer and FindFirstChild(P, TargetPlayer);
            if not TargetPlayer then return; end;
            local self, Props, Rebuild = Functions, nil, nil;

            if not useCache then
                Props = self.GetProps(TargetPlayer);
                Rebuild = self:PRebuild(Props);
            else
                Rebuild = ScriptCache.PRebuilt;
            end;

            CurrentPage2 = math.clamp(CurrentPage2, 1, math.max(1, math.ceil(#Rebuild / 10)));

            local PageData = Functions.GetSortPage(Rebuild, CurrentPage2);
            if #PageData == 0 then return; end;

            tk.defer(function()
                for i=1, #GTGuids do
                    local btn = ScriptCache[GTGuids[i]];
                    local LastClick, Data = 0, PageData[i];
                    local Highlight = nil;
                    if Data then
                        local ESP, Destroyed = false, false;
                        UpdateDesc(btn, ESP, Destroyed);

                        btn:SetTitle(Data.Name); btn.Callback = function()
                            local Object = TVC:GetSpawnedProp(TargetPlayer.UserId, Data.PropId);
                            local Now = os.clock();
                            if Object and Now - LastClick < 0.3 then
                                Object:Destroy();
                                Destroyed = true;
                                return UpdateDesc(btn, ESP, Destroyed);
                            end;

                            LastClick = Now;
                            ESP = not ESP;

                            if ESP and Object then
                                Highlight = Instance.new("Highlight", Object);
                                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                Highlight.FillColor = RED;
                                Highlight.Enabled = true;
                            elseif Highlight then
                                Highlight:Destroy();
                            end;

                            UpdateDesc(btn, ESP, Destroyed);
                        end;
                    else
                        btn:SetTitle("-"); btn:SetDesc("-"); btn.Callback = EMPTYF;
                    end;
                end;
            end);

            ScriptCache.PRebuilt = Rebuild;
        end;
        Functions.LocalTp = function(self, HumRSelf, cf, time, force)
            if not HumRSelf then return; end;
            if not LoaderSettings.GAG2Loader.Allow_TPBypass and not force then
                return self.LocalTween(HumRSelf, cf);
            end;
            for i=1, 50 do
                HumRSelf.CFrame = cf; wait(time);
            end;
        end;
        Functions.LocalTween = function(HumRSelf, cf)
            local distance = dist(cf.Position);
            local tween = TweenService:Create(
                HumRSelf,
                TwInfo(distance / 30, Enum.EasingStyle.Linear),
                {CFrame = cf}
            ); tween:Play();
            return tween.Completed:Wait();
        end;
        Functions.IsGardenLock = function(target)
            return target and GetAttribute(target, "IsInOwnGarden");
        end;
        Functions.GetGarden = function(target)
            if not AllGardens then return {}; end;
            return AllGardens[target.UserId];
        end
        Functions.GetProps = function(target)
            return AllProps[target.UserId];
        end;
        Functions.IsOnlyOne = function(data)
            return if not data.MaxFruitSpawnLocations or data.MaxFruitSpawnLocations <= 0 then true else false;
        end;
        Functions.GetPlot = function(uid)
            local TPlot = if uid == Suid then Plot else nil;
            if TPlot then return TPlot end;
            local pl = GetPlayerByUserId(P, uid); 
            local plot = pl and GetAttribute(pl, "PlotId");
            if not pl then return; end;
            TPlot = FindFirstChild(Garden, "Plot"..plot);
            return TPlot;
        end;
        Functions.GetFruit = function(self, data, uid)
            if not self.IsOnlyOne(data) or data.FruitId then
                local Obj = data.PlantId and data.FruitId and FVC:GetSpawnedFruit(uid, data.PlantId, data.FruitId);
                if not Obj then
                    local TPlot = self.GetPlot(uid);
                    if not TPlot then return; end;
                    Obj = FindFirstChild(TPlot.Plants[uid .. "_" .. data.PlantId].Fruits, uid .. "_" .. data.PlantId .. "_" .. data.FruitId);
                end; return Obj, false;
            end; return data.PlantId and PVC:GetSpawnedPlant(uid, data.PlantId), true;
        end;
        Functions.GetRandomPointInPart = function(Part)
            local Offset = Vec3((math.random() - 0.5) * Part.Size.X, 0, (math.random() - 0.5) * Part.Size.Z);
            local Pos = (Part.CFrame * CFr(Offset)).Position;
            return Vec3(Pos.X, 142.35, Pos.Z);
        end;
        Functions.GetPlantSpot = function(self)
            local Selected = PlantCon.SelectSpot;
            local Handler = self[Selected];
            if Handler then return Handler(self); end;
            local SavedSpot = PlantCon.SavedSpots[Selected];
            if SavedSpot then
                local Radius = PlantCon.CircleSize;
                local Angle = math.random() * math.pi * 2;
                local Distance = math.sqrt(math.random()) * Radius;
                return Vec3(
                    SavedSpot.X + math.cos(Angle) * Distance,
                    142.35,
                    SavedSpot.Z + math.sin(Angle) * Distance
                );
            end;
        end;
        Functions.Plant = function(self)
            local BPCs = GetChildren(Backpack);

            local SafeRead = {};
            local SelectedPlants = PlantCon.SelectPlant;

            for i = 1, #SelectedPlants do
                local Name = SelectedPlants[i];
                if Name then
                    SafeRead[Name] = true;
                end;
            end;

            for i = 1, #BPCs do
                local Obj = BPCs[i];

                if Obj and SafeRead[Obj.Name] then
                    local SeedTool = GetAttribute(Obj, "SeedTool");
                    local Count = GetAttribute(Obj, "Count");

                    if SeedTool and Count and Count > 0 then
                        for _ = 1, Count do
                            local Spot = self:GetPlantSpot();

                            if not Spot then
                                break;
                            end;

                            RE.PlantSeed:Fire(Spot, SeedTool, Obj);
                        end;
                    end;
                end;
            end;
        end;
        Functions.AddNewSpot = function()
            PlantCon.SavedSpots[PlantCon.SpotName or "New Spot"] = HumRSelf.Position;
        end;
        Functions.Shovel = function(self)
            local Plants = self.GetGarden(selff);
            local Shovel = selc and FindFirstChild(selc, "Shovel");
            if not Shovel then return; end;
            for i,v in Plants do
                if not PlantCon.AutoShovel then return; end;
                if v and tble.find(PlantCon.SelectPlantShovel, v.PlantName) then
                    local Obj = PVC:GetSpawnedPlant(Suid, i);
                    if Obj and dist(GetPivot(Obj).Position) <= PlantCon.ShovelDistance then
                        RE.UseShovel:Fire(i, "", "Shovel", Shovel);
                    end;
                end;
            end;
        end;
        Functions.ShouldHarvest = function(plantid, fruitid, data, HarvestSH)
            local Object=nil; if fruitid then
                Object = FVC:GetSpawnedFruit(Suid, plantid, fruitid);
            else
                Object = PVC and PVC:GetSpawnedPlant(Suid, plantid) or nil;
            end;

            local Age, MaxAge = data.Age, data.MaxAge;
            if Object then
                local objAge = Object:GetAttribute("Age");
                if objAge then Age = objAge; end;
            end;

            if Age and MaxAge and Age < MaxAge then return false; end;

            local Mutation = data.Mutation;
            local Weight = data.Weight;

            if not Weight then
                if not Object then return false; end;
                if fruitid then
                    Weight = FVC:CalculateFruitWeight(Object);
                else
                    Weight = FVC and FVC.CalculatePlantWeight and FVC:CalculatePlantWeight(Object) or 0;
                end;
            end;

            for i=1, #HarvestSH do
                local Schema = HarvestSH[i]; if not Schema then continue; end;
                local Passed = true; if #Schema.Mutations > 0 then
                    if not tble.find(Schema.Mutations, Mutation) then
                        Passed = false;
                    end;
                end;

                if Passed and Schema.Weight then
                    local Min = Schema.Weight.MinWeight;
                    local Max = Schema.Weight.MaxWeight;
                    if Min and Max and Weight then
                        if Weight < Min or Weight > Max then
                            Passed = false;
                        end;
                    end;
                end; if Passed then
                    return true;
                end;
            end;
        end;
        Functions.Harvest = function(self)
            local Plants = self.GetGarden(selff);
            for i,v in Plants do
                if not HarvestCon.Auto then return; end;
                if v then
                    local HarvestSH = HarvestCon.Schemas[v.PlantName];
                    if not HarvestSH or #HarvestSH <= 0 then continue; end;

                    local OnlyOne = self.IsOnlyOne(v);
                    
                    if not OnlyOne then
                        for f,j in v.Fruits do
                            if self.ShouldHarvest(i, f, j, HarvestSH) then
                                RE.CollectFruit:Fire(i, f); H.RenderStepped:Wait();
                            end;
                        end;
                    elseif self.ShouldHarvest(i, nil, v, HarvestSH) then
                        RE.CollectFruit:Fire(i, "");
                    end;
                end;
            end;
        end;
        Functions.ShouldSell = function(v)
            local Fruit = GetAttribute(v, "FruitName");
            if not Fruit then return false; end;

            local TargetSC = SellCon.Schemas[Fruit];
            if not TargetSC or #TargetSC <= 0 then return false; end;

            local Mut = GetAttribute(v, "Mutation");
            local SizeMulti = GetAttribute(v, "SizeMultiplier");
            local Value = FruitValueCalc(
                Fruit,
                SizeMulti,
                Mut,
                selff,
                false
            );

            for i = 1, #TargetSC do
                local Schema = TargetSC[i];
                if not Schema.Price then continue; end;
                local Min = Schema.Price.MinPrice or 0;
                local Max = Schema.Price.MaxPrice or 999999;
                if Min and Max then
                    if Value >= Min and Value <= Max then
                        return true;
                    end;
                end;
            end; return false;
        end;
        Functions.Sell = function(self)
            if SellCon.SellAll then
                return RE.SellAll:Fire();
            end;

            local Inv = GetChildren(Backpack); for i=1, #Inv do
                if not SellCon.Auto then return; end;
                local v = Inv[i]; if v then
                    if not GetAttribute(v, "IsFavorite") then
                        if self.ShouldSell(v) then
                            RE.SellFruit:Fire(GetAttribute(v, "Id"));
                        end;
                    end;
                end;
            end;
        end;
        Functions.ShovelAura = function()
            if not HumRSelf then return; end;

            local self = Functions;

            local NearestRoot, NearestDistance, NearP = nil, 20, nil;
            local Position, allP = HumRSelf.Position, GetPlayers(P);

            for i=1, #allP do
                local plr = allP[i]; if plr and plr ~= selff then
                    if tble.find(StealCon["Select Player Shovel"], plr) then continue; end;

                    local Char = plr.Character;
                    local HRP = Char and FindFirstChild(Char, "HumanoidRootPart");

                    if HRP then
                        local Distance = dist(HRP.Position);
                        if Distance < NearestDistance then
                            NearestDistance = Distance;
                            NearestRoot = HRP;
                            NearP = plr;
                        end;
                    end;
                end;
            end;

            if NearestRoot then
                local Shovel = selc and FindFirstChild(selc, "Shovel");
                if not Shovel then return; end;
                local TargetPos = NearestRoot.Position;
                HumRSelf.CFrame = CF.lookAt(Position, Vec3(TargetPos.X, Position.Y, TargetPos.Z));
                RE.SwingShovel:Fire();
                RE.HitPlayer:Fire(NearP.UserId);
            end;
        end;
        Functions.BindShovel = function(self, boolean)
            if boolean and not self.IsBindShovel then
                self.IsBindShovel = true;
                H:BindToRenderStep(
                    "ShovelAura",
                    Enum.RenderPriority.Character.Value + 1,
                    self.ShovelAura
                );
            elseif not boolean and self.IsBindShovel then
                self.IsBindShovel = nil;
                H:UnbindFromRenderStep("ShovelAura");
            end;
        end;
        Functions.StealAFruit = function(Obj, pid, fid, uid, ignore)
            if not Obj then return; end;
            local Pivot = GetPivot(Obj);
            local Home = Plot.Visual.PRIM.CFrame;
            local HarvestPart = Obj and FindFirstChild(Obj, "HarvestPart");
            local StealPrompt = HarvestPart and FindFirstChild(HarvestPart, "StealPrompt");
            if not StealPrompt then return; end;
            local DURA = StealPrompt.HoldDuration;
            if not ignore then
                Functions:LocalTp(HumRSelf, Pivot, 0);
                if LoaderSettings.GAG2Loader.Allow_TPBypass then
                    twait(2);
                end;
            end;
            RE.BeginSteal:Fire(uid, pid, fid or "");
            twait(StealPrompt.HoldDuration);
            RE.CompleteSteal:Fire();
            Functions:LocalTp(HumRSelf, Home, 0, true); twait(2);
        end;
        Functions.Steal = function(self)
            local Targets, allP = {}, GetPlayers(P); for i=1, #allP do
                if not StealCon.Auto then return; end;

                local plr = allP[i]; if plr and not tble.find(StealCon["Select Player"], plr.Name) then
                    if self.IsGardenLock(plr) then continue; end;

                    local Plants = self.GetGarden(plr);
                    local Sorted = self:GRebuild(Plants, true, false, plr.UserId);

                    for x=1, #Sorted do
                        local v = Sorted[x];
                        Targets[#Targets + 1] = {
                            Data = v,
                            Player = plr
                        };
                    end;
                end;
            end;

            tble.sort(Targets, function(a, b)
                return (a.Data.Price or 0) > (b.Data.Price or 0);
            end);

            for i=1, #Targets do
                if not StealCon.Auto then
                    return;
                end;

                local v = Targets[i].Data;
                local plr = Targets[i].Player;

                if v.Age and v.MaxAge and v.Age < v.MaxAge then
                    continue;
                end;

                local Obj = v.Obj or self:GetFruit(v, plr.UserId);
                if Obj then
                    Functions.StealAFruit(Obj, v.PlantId, v.FruitId, plr.UserId, false);
                end;
            end;
        end;
        Functions.ShouldExpand = function()
            local Expansion = GetAttribute(Plot, "GardenExpansion");
            if Expansion >= 5 then return false; end;
            if selff.leaderstats.Sheckles.Value < EXPANDCOST[Expansion] then
                return false;
            end; return true;
        end;
        Functions.BuyExpand = function(self)
            if not self.ShouldExpand() then return; end;
            return RE.ExpandGarden:Fire();
        end;
        Functions.ShopSeed = function()
            if not PurchaseData then return; end;
            for i,v in ShopCon.Seeds do
                if v then
                    local Item = FindFirstChild(R.StockValues.SeedShop.Items, i);
                    if Item and Item.Value then
                        local Bought = PurchaseData.Seeds[i] or 0;
                        while Bought < Item.Value do
                            RE.PurchaseSeed:Fire(i);
                            Bought += 1;
                            twait(0.1);
                        end;
                    end;
                end;
            end;
        end;
        Functions.ShopGear = IB_NO_VIRTUALIZE(function()
            if not PurchaseData then return; end;
            for i,v in ShopCon.Gears do
                if v then
                    local Item = FindFirstChild(R.StockValues.GearShop.Items, i);
                    if Item and Item.Value then
                        local Bought = PurchaseData.Gears[i] or 0;
                        while Bought < Item.Value do
                            RE.PurchaseGear:Fire(i);
                            Bought += 1;
                            twait(0.1);
                        end;
                    end;
                end;
            end;
        end);
        Functions.ShopPet = IB_NO_VIRTUALIZE(function(self)
            local Childs = GetChildren(W.Map.WildPetRef);
            for i=1, #Childs do
                local v=Childs[i]; if v and v.Parent then
                    local Price = GetAttribute(v, "Price"); if Price and Price >= selff.leaderstats.Sheckles.Value then continue; end;
                    if GetAttribute(v, "OwnerName") ~= selff.Name and ShopCon.Pets[GetAttribute(v, "PetName")] then
                        self:LocalTp(HumRSelf, v.CFrame, 0);
                        RE.WildPetTame:Fire(v);
                        twait(0.1);
                    end;
                end;
            end;
        end);
        Functions.AutoCollectSeeds = IB_NO_VIRTUALIZE(function(self)
            local SeedPacks = GetChildren(SeedPackSpawn);
            local WantGold = EventsCon.Seeds.Gold;
            local WantRainbow = EventsCon.Seeds.Rainbow;
            for i = 1, #SeedPacks do
                local v = SeedPacks[i]; if v and v.Parent then
                    local Match = (WantGold and GetAttribute(v, "GoldSeed")) or (WantRainbow and GetAttribute(v, "RainbowSeed"));
                    if Match then
                        local Prompt = FindFirstChild(v, "ProximityPrompt");
                        self:LocalTp(HumRSelf, v.CFrame, 0);
                        fireproximityprompt(Prompt);
                    end;
                end;
            end;
        end);
        Functions.ProcessModel = function(Obj, TARGET, isFruit)
            if not Obj then return; end;
            if Obj.LevelOfDetail ~= DISABLELOD then
                Obj.LevelOfDetail = DISABLELOD;
            end;

            local FruitsFolder = not isFruit and FindFirstChild(Obj, "Fruits");
            local Descendants = isFruit and GetChildren(Obj) or GetDescendants(Obj);
            
            for i = 1, #Descendants do
                local v = Descendants[i];
                if FruitsFolder and v:IsDescendantOf(FruitsFolder) then
                    continue;
                end;
                
                local ClassName = v.ClassName;
                if ClassName == "Model" then
                    local Name = v.Name;
                    if Name == "Dragon" or Name == "Model" then
                        Destroy(v);
                    elseif v.LevelOfDetail ~= DISABLELOD then
                        v.LevelOfDetail = DISABLELOD;
                    end;
                elseif ClassName == "ParticleEmitter" then
                    if v.Enabled then
                        v.Enabled = if TARGET == 0 then true else false;
                    end;
                elseif IsA(v, "BasePart") then
                    local Name = v.Name;
                    if Name ~= "HarvestPart"
                        and Name ~= "Base"
                        and Name ~= "CollisionBlock"
                        and Name ~= "Truss"
                        and not str.find(Name, "VFX", 1, true)
                    then
                        if v.CastShadow then
                            v.CastShadow = false;
                        end; if v.Transparency ~= TARGET then
                            v.Transparency = TARGET;
                        end; if v.EnableFluidForces then
                            v.EnableFluidForces = false;
                        end; if Name == "FrozenFX" then
                            local FrozenTransparency = (TARGET == 0) and 0.5 or 1;
                            if v.Transparency ~= FrozenTransparency then
                                v.Transparency = FrozenTransparency;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        Functions.HidePlants = function(self, state)
            local TARGET = if state then 1 else 0;
            local Players = GetPlayers(P);
            for i = 1, #Players do
                local Plr = Players[i];
                local Plants = self.GetGarden(Plr);
                for PlantId in next, Plants do
                    self.ProcessModel(PVC:GetSpawnedPlant(Plr.UserId, PlantId), TARGET, false);
                end;
            end;
        end;
        Functions.HideFruits = function(self, state)
            local TARGET = if state then 1 else 0;
            local Targets, Players = {}, GetPlayers(P);
            for i = 1, #Players do
                local Plr = Players[i]

                local Plants = self.GetGarden(Plr);
                local Sorted = self:GRebuild(Plants, false, false, Plr.UserId);

                for x = 1, #Sorted do
                    Targets[#Targets + 1] = {
                        Data = Sorted[x],
                        UserId = Plr.UserId;
                    };
                end;
            end;

            for i = 1, #Targets do
                local Entry = Targets[i];
                local Data = Entry.Data;
                if Data.FruitId then
                    Functions.ProcessModel(Data.Obj or self:GetFruit(Data, Entry.UserId), TARGET, true);
                end;
            end;
        end;

        ScriptData.AutoData = {
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Hide All Plants", EN2="Hide all plants from every garden in game.", TH1="ปิดการมองเห็นพืช", TH2="ปิดการมองเห็นพืชทั้งหมดจากทุกสวน", Bindable="+", Path="Client/HidePlants", Callback=function(state)
                            if not ScriptCache.AlreadySkipHP then
                                ScriptCache.AlreadySkipHP = true;
                                return;
                            end;
                            ClientCon.HidePlants = state;
                            Functions:HidePlants(state);
                        end},
                        {type="Toggle", EN="Hide All Fruits", EN2="Hide all fruits from every garden.", TH1="ปิดการมองเห็นผลไม้", TH2="ปิดการมองเห็นผลไม้ทั้งหมดจากทุกสวน", Bindable="+", Path="Client/HideFruits", Callback=function(state)
                            if not ScriptCache.AlreadySkipHF then
                                ScriptCache.AlreadySkipHF = true;
                                return;
                            end;
                            ClientCon.HideFruits = state;
                            Functions:HideFruits(state);
                        end},
                        {type="Toggle", EN="Go Underground", EN2="Temporary remove the floor", TH1="ลงใต้ดิน", TH2="เอาพื้นออกชั่วคราว", Bindable="+", Path="Client/GoUnderground", Callback=function(state)
                            ClientCon.GoUnderground = state;
                            W.Baseplate.TopLayer.CanCollide = not state;
                        end},
                        {type="Toggle", EN="No Render", EN2="Disable Roblox's rendering.", TH1="ปิด Render", TH2="จอขาว", Path="Client/NoRender", Callback=function(state)
                            ClientCon.NoRender = state;
                            H:Set3dRenderingEnabled(not state);
                        end},
                        {type="Slider", EN="FPS Cap", EN2="Limit your FPS.", TH1="จำกัด FPS", TH2="ประหยัดพลังงานและพื้นที่เครื่อง", Value={Min=1, Max=300}, Path="Client/FPSCap", Callback=function(value)
                            ClientCon.FPSCap = value;
                            setfpscap(tonumber(value));
                        end},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                        {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=0, Max=2}, Step=0.1, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                    }, Title="Client", Open=true};
                }};
            };
            GardenTab = {
                {type="Dropdown", Title="Select Player", TH1="เลือกผู้เล่น", AllowNone=true, Values={}, Path="Select Player", RECall={
                    Title = "Refresh Players",
                    RECall = function()
                        local Players, tbl = GetPlayers(P), {};
                        for i=1, #Players do
                            tble.insert(tbl, Players[i].Name);
                        end; return tbl;
                    end;
                }},
                {type="Button", EN="Get Garden Info", EN2="Show player's best fruit and their garden informations.",TH1="รับข้อมูลสวน",TH2="แสดงข้อมูลสวนของผู้เล่นคนนั้น", Callback=Functions.PairGarden}, {type="Space"}, {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Button", Title="-", Desc="-", Global=GPGuids[1]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[2]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[3]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[4]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[5]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[6]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[7]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[8]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[9]};
                        {type="Button", Title="-", Desc="-", Global=GPGuids[10]};
                        {type="Button", Title="Previous Page", Callback=function()
                            CurrentPage = CurrentPage - 1;
                            CurrentPage = if CurrentPage < 1 then CurrentPage else CurrentPage;
                            Functions.PairGarden(true);
                        end};
                        {type="Button", Title="Next Page", Callback=function()
                            CurrentPage = CurrentPage + 1;
                            Functions.PairGarden(true);
                        end};
                    }, Title="Plant/Fruit Data", Global="PFD"},
                }}, {type="Space"}, {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Button", Title="-", Desc="-", Global=GTGuids[1]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[2]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[3]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[4]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[5]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[6]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[7]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[8]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[9]};
                        {type="Button", Title="-", Desc="-", Global=GTGuids[10]};
                        {type="Button", Title="Previous Page", Callback=function()
                            CurrentPage2 = CurrentPage2 - 1;
                            CurrentPage2 = if CurrentPage2 < 1 then CurrentPage2 else CurrentPage2;
                            Functions.PairTraps(true);
                        end};
                        {type="Button", Title="Next Page", Callback=function()
                            CurrentPage2 = CurrentPage2 + 1;
                            Functions.PairTraps(true);
                        end};
                    }, Title="Traps/Props", Global="TPD"},
                }},
            };
            PlantTab = {
                {type="Dropdown", EN="Select Plant", EN2="Select plant to auto plant", TH1="เลือกผลไม้", TH2="เลือกผลไม้ที่จะปลูก", AllowNone=true, Multi=true, AllowNone=true, Values=(function()
                    local tbl, NewS={}, tble.clone(SeedData);
                    tble.sort(NewS, function(a,b)
                        return str.lower(a.SeedName) < str.lower(b.SeedName)
                    end); for i=1, #NewS do
                        if type(NewS[i]) == "table" and NewS[i].SeedName then
                            tble.insert(tbl, NewS[i].SeedName);
                        end;
                    end; return tbl;
                end)(), Path="SelectPlant"},
                {type="Dropdown", EN="Select Spot", EN2="Random plant spot or add your own.", TH1="เลือกตำแหน่ง", TH2="เลือกว่าจะสุ่มหรือเพิ่มตำแหน่งเอง", Values={"Random Left Area", "Random Right Area", "Random Both Area"}, RECall={
                    Title="Refresh Spots",
                    RECall = function()
                        local tbl = {"Random Left Area", "Random Right Area", "Random Both Area"};
                        for i,v in PlantCon.SavedSpots do
                            tble.insert(tbl, i);
                        end; return tbl;
                    end;
                }, Path="SelectSpot"},
                {type="Slider", EN="Circle Size", EN2="Randomize planting positions around your saved spot.", TH1="ขนาดวงกลม", TH2="สุ่มตำแหน่งปลูกรอบจุดที่บันทึกไว้เป็นวงกลม", Value={Min=1, Max=50}, Path="CircleSize"},
                {type="Toggle", EN="Auto Plant", EN2="Automatically plants seeds.", TH1="ออโต้ปลูก", TH2="ออโต้ปลูกพืช", Path="Auto"}; {type="Space"}; {type="Space"};

                {type="Input", Title="Spot Name", TH1="ชื่อของตำแหน่ง", Placeholder="...", Path="SpotName"};
                {type="Button", Title="Add Spot", TH1="เพิ่มตำแหน่ง", Callback=Functions.AddNewSpot}; {type="Space"}; {type="Space"};

                {type="Dropdown", EN="Select Plant To Shovel", EN2="Select plant to add to schema", TH1="เลือกผลไม้", TH2="เลือกผลไม้ที่จะขุด", AllowNone=true, Multi=true, AllowNone=true, Values=(function()
                    local tbl, NewS={}, tble.clone(SeedData);
                    tble.sort(NewS, function(a,b)
                        return str.lower(a.SeedName) < str.lower(b.SeedName)
                    end); for i=1, #NewS do
                        if type(NewS[i]) == "table" and NewS[i].SeedName then
                            tble.insert(tbl, NewS[i].SeedName);
                        end;
                    end; return tbl;
                end)(), Path="SelectPlantShovel"},
                {type="Slider", EN="Shovel Distance", EN2="Maximum shovel distance for plants.", TH1="ระยะ Shovel", TH2="ระยะสูงสุดในการขุดพืช", Value={Min=1, Max=100}, Path="ShovelDistance"},
                {type="Toggle", EN="Auto Shovel", EN2="Auto destroy the plant", TH1="ออโต้ Shovel", TH2="ออโต้ขุด/ลบพืช", Path="AutoShovel"},
            };
            HarvestTab = {
                {type="Dropdown", EN="Select Plant", EN2="Select plant to add to schema", TH1="เลือกผลไม้", TH2="เลือกผลไม้ที่จะเพิ่มลงใน Schema", AllowNone=true, Values=(function()
                    local tbl, NewS={}, tble.clone(SeedData);
                    tble.sort(NewS, function(a,b)
                        return str.lower(a.SeedName) < str.lower(b.SeedName)
                    end); for i=1, #NewS do
                        if type(NewS[i]) == "table" and NewS[i].SeedName then
                            tble.insert(tbl, NewS[i].SeedName);
                        end;
                    end; return tbl;
                end)(), Path="SelectPlant"},
                {type="Button", EN="Add Schema", EN2="Add schema to auto harvest", TH1="เพิ่ม", TH2="เพิ่ม Schema", Callback=Functions.PairHarvest};
                {type="Toggle", EN="Auto Harvest", EN2="Auto harvest selected plant using long distance harvesting.", TH1="ออโต้เก็บผลไม้", TH2="ออโต้เก็บผลไม้ที่เลือกแบบระยะไกล", Path="Auto"}, {type="Space"}, {type="Space"},
            };
            SellTab = {
                {type="Dropdown", EN="Select fruit", EN2="Select fruit to add to schema", TH1="เลือกผลไม้", TH2="เลือกผลไม้ที่จะเพิ่มลงใน Schema", AllowNone=true, Values=(function()
                    local tbl, NewS={}, tble.clone(SeedData);
                    tble.sort(NewS, function(a,b)
                        return str.lower(a.SeedName) < str.lower(b.SeedName)
                    end); for i=1, #NewS do
                        if type(NewS[i]) == "table" and NewS[i].SeedName then
                            tble.insert(tbl, NewS[i].SeedName);
                        end;
                    end; return tbl;
                end)(), Path="SelectFruit"},
                {type="Button", EN="Add Schema", EN2="Add schema to auto harvest", TH1="เพิ่ม", TH2="เพิ่ม Schema", Callback=Functions.PairSell};
                {type="Toggle", EN="Use Sell All", EN2="This will make Auto Sell sell all fruits", TH1="ขายทั้งหมด", TH2="ขายผลไม้ทั้งหมดตอนเปิด ออโต้ขาย", Path="SellAll"},
                {type="Toggle", EN="Auto Sell", EN2="Auto sell selected fruit using long distance selling.", TH1="ออโต้ขายผลไม้", TH2="ออโต้ขายผลไม้ที่เลือกแบบระยะไกล", Path="Auto"}, {type="Space"}, {type="Space"},
            };
            StealTab = {
                {type="Dropdown", EN="Whitelist Player", EN2="Player that you won't hit in shovel aura.", TH1="whitelist ผู้เล่น", TH2="คนที่เราจะไม่ตีเวลาเข้าใกล้", Multi=true, AllowNone=true, Values={}, Path="Select Player Shovel", RECall={
                    Title = "Refresh Players",
                    RECall = function()
                        local Players, tbl = GetPlayers(P), {};
                        for i=1, #Players do
                            tble.insert(tbl, Players[i].Name);
                        end; return tbl;
                    end;
                }};
                {type="Toggle", EN="Shovel Aura", EN2="Hit anyone who is near you", TH1="ตีคนใกล้ตัว", TH2="ออโต้ตีคนที่มาใกล้ตัว", Path="ShovelAura"}, {type="Space"}, {type="Space"},
                {type="Toggle", EN="Auto Protect", EN2="Hit anyone who attempt to steal from you.", TH1="ออโต้ป้องกัน", TH2="ออโต้ตีคนที่มาปล้นผลไม้", Path="Notify"},
                {type="Toggle", EN="Player Nearby", EN2="Send notification when someone is near your garden.", TH1="ผู้เล่นเข้าใกล้", TH2="แจ้งเตือนเวลามาคนเข้ามาใกล้", Path="Notify"}, {type="Space"}, {type="Space"},
                {type="Dropdown", EN="Whitelist Player", EN2="Player that you won't steal", TH1="whitelist ผู้เล่น", TH2="คนที่เราจะไม่ขโมย", Multi=true, AllowNone=true, Values={}, Path="Select Player", RECall={
                    Title = "Refresh Players",
                    RECall = function()
                        local Players, tbl = GetPlayers(P), {};
                        for i=1, #Players do
                            tble.insert(tbl, Players[i].Name);
                        end; return tbl;
                    end;
                }};
                {type="Button", Title="Target", TH1="เป้าหมาย", Global="TargetStealPlant", Callback=EMPTYF};
                {type="Toggle", EN="Auto Steal", EN2="Teleport & steal fruits.", TH1="ออโต้ขโมย", TH2="วาปและขโมยผลไม้", Path="Auto"};
            };
            ShopTab = {
                {type="Toggle", EN="Auto Expand Area", EN2="Auto buy 'Expand Area' to expand the garden area.", TH1="ออโต้ขยายพื้นที่", TH2="ออโต้ซื้อ 'ขยายพื้นที่' เพื่อขยายพื้นที่ในสวน", Path="AutoExpandArea"}, {type="Space"},
            };
            EventsTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Gold Seed", EN2="Teleport & collect gold seeds", TH1="เมล็ดทอง", TH2="วาปเก็บเมล็ดทอง", Path="Seeds/Gold"},
                        {type="Toggle", EN="Rainbow Seed", EN2="Teleport & collect rainbow seeds.", TH1="เมล็ดรุ้ง", TH2="วาปเก็บเมล็ดรุ้ง", Path="Seeds/Rainbow"},
                    }, Title="Seeds"};
                }};
            };
        };

        CoruTask.New("Plant", function()
            while true do
                if not PlantCon.Auto or CoreDestroyed then
                    CoruTask.Close("Plant");
                end; Functions:Plant();
                twait(0.1);
            end;
        end);
        CoruTask.New("Shovel", function()
            print(pcall(function() while true do
                if not PlantCon.AutoShovel or CoreDestroyed then
                    CoruTask.Close("Shovel");
                end; Functions:Shovel();
                twait(0.1);
            end; end));
        end);
        CoruTask.New("Harvest", function()
            while true do
                if not HarvestCon.Auto or CoreDestroyed then
                    CoruTask.Close("Harvest");
                end; Functions:Harvest();
                twait(0.1);
            end;
        end);
        CoruTask.New("Sell", function()
            while true do
                if not SellCon.Auto or CoreDestroyed then
                    CoruTask.Close("Sell");
                end; Functions:Sell();
                twait(0.1);
            end;
        end);
        CoruTask.New("Steal", function()
            print(pcall(function() while true do
                if not StealCon.Auto or CoreDestroyed then
                    CoruTask.Close("Steal");
                end; Functions:Steal();
                twait(0.5);
            end; end));
        end);
        CoruTask.New("Shop", function()
            while true do
                if CoreDestroyed then
                    CoruTask.Close("Shop");
                end; if ShopCon.AutoExpandArea then
                    Functions:BuyExpand();
                end;
                Functions.ShopSeed();
                Functions.ShopGear();
                Functions:ShopPet();
                twait(0.1);
            end;
        end);
        CoruTask.New("Events", function()
            while true do
                if (not EventsCon.Seeds.Gold and not EventsCon.Seeds.Rainbow) or CoreDestroyed then
                    CoruTask.Close("Events");
                end; Functions:AutoCollectSeeds(); twait(0.1);
            end;
        end);

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "Grow A Garden 2",
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
                Garden = Window:Tab({Title="Garden", Icon="house"}),
                Plant = Window:Tab({Title="Plant", Icon="leaf"}),
                Harvest = Window:Tab({Title="Harvest", Icon="apple"}),
                Sell = Window:Tab({Title="Sell", Icon="bitcoin"}),
                Steal = Window:Tab({Title="Steal", Icon="hat-glasses"}),
                Shop = Window:Tab({Title="Shop", Icon="hand-coins"}),
                Events = Window:Tab({Title="Events", Icon="party-popper"}),
                
                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            }; IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);
            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.Garden, ScriptData.AutoData.GardenTab, "Garden");
            Windy:CreateComponent(Tabs.Plant, ScriptData.AutoData.PlantTab, "Plant");
            Windy:CreateComponent(Tabs.Harvest, ScriptData.AutoData.HarvestTab, "Harvest");
            Windy:CreateComponent(Tabs.Steal, ScriptData.AutoData.StealTab, "Steal");
            Windy:CreateComponent(Tabs.Sell, ScriptData.AutoData.SellTab, "Sell");
            Windy:CreateComponent(Tabs.Shop, ScriptData.AutoData.ShopTab, "Shop");
            Windy:CreateComponent(Tabs.Events, ScriptData.AutoData.EventsTab, "Events");

            Functions.PairData(Tabs.Shop, "Seeds", SeedData);
            Functions.PairData(Tabs.Shop, "Gears", GearData);
            Functions.PairData(Tabs.Shop, "Pets", PetData);

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
            ScriptCache.HarvestTab = Tabs.Harvest;
            ScriptCache.SellTab = Tabs.Sell;
            ScriptCache.GardenTab = Tabs.Garden;
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
                CoreDestroyed = false;
                
                LSecureUI();

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if PlantCon.Auto then
                            CoruTask.Handle("Plant");
                        end;
                        if PlantCon.AutoShovel then
                            CoruTask.Handle("Shovel");
                        end;
                        if HarvestCon.Auto then
                            CoruTask.Handle("Harvest");
                        end;
                        if SellCon.Auto then
                            CoruTask.Handle("Sell");
                        end;
                        if StealCon.Auto then
                            CoruTask.Handle("Steal");
                        end;
                        if EventsCon.Seeds.Gold or EventsCon.Seeds.Rainbow then
                            CoruTask.Handle("Events");
                        end;
                        Functions:BindShovel(StealCon.ShovelAura);
                        twait(0.1);
                    end;
                end));

                CoreConnection[1] = H.Stepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect(); CoreConnection[1] = nil;
                        return;
                    end;

                    Backpack = selff.Backpack;
                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;
                    Seat = CommonF.GetSeat(HumSelf);

                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
                end));
                CoreConnection[2] = H.Heartbeat:Connect(IB_NO_VIRTUALIZE(function(delta)
                    if CoreDestroyed and CoreConnection[2] then
                        CoreConnection[2]:Disconnect(); CoreConnection[2] = nil;
                        return;
                    end;

                    if ClientCon["Enable TeleportWalk"] and selc and HumSelf and HumSelf.MoveDirection.Magnitude > 0 then
                        selc:TranslateBy(HumSelf.MoveDirection * ClientCon["TeleportWalk Speed"] * delta * 10);
                    end;
                end));

                for i,tbls in HarvestCon.Schemas do
                    for _, v in tbls do
                        Functions.PairHarvest(i, v);
                    end;
                end;
                for i,tbls in SellCon.Schemas do
                    for _, v in tbls do
                        Functions.PairSell(i, v);
                    end;
                end;

                if not CoruTask.Intialized then
                    CoruTask.Init(WindUI);
                    CoruTask.Intialized = true;

                    while not (AllGardens and PurchaseData and PVC and GVC and TVC) do
                        local gcc = getgc(true); for i=1, #gcc do
                            if AllGardens and PurchaseData and PVC and GVC and TVC then break; end;
                            local v = gcc[i]; if typeof(v) == 'table' then
                                if rawget(v, "PurchasedThisRestock") then
                                    PurchaseData = v.PurchasedThisRestock;
                                elseif rawget(v, "GetAllGardens") then
                                    AllGardens = v:GetAllGardens();
                                    AllProps = v:GetAllProps();
                                    GVC = v;
                                elseif rawget(v, "GetSpawnedPlant") then
                                    PVC = v;
                                elseif rawget(v, "GetSpawnedProp") then
                                    TVC = v;
                                end;
                            end;
                        end; twait(0.5);
                    end;

                    local LeftArea = Plot.Visual.PlantAreaColumn1;
                    local RightArea = Plot.Visual.PlantAreaColumn2;
                    Functions["Random Left Area"] = function(self)
                        return self.GetRandomPointInPart(LeftArea);
                    end; Functions["Random Right Area"] = function(self)
                        return self.GetRandomPointInPart(RightArea);
                    end; Functions["Random Both Area"] = function(self)
                        return self.GetRandomPointInPart(math.random(1, 2) == 1 and LeftArea or RightArea);
                    end;

                    ScriptCache.AlreadySkipHP = true;
                    ScriptCache.AlreadySkipHF = true;

                    WindUI:Notify({
                        Title = "<font color='rgb(255, 255, 0)'>MUST READ</font>",
                        Content = "You can turn on TP Bypass in Core Settings.",
                        Icon = "circle-alert",
                        Duration = 5,
                    });
                    WindUI:Notify({
                        Title = "<font color='rgb(255, 255, 0)'>MUST READ</font>",
                        Content = "You can save/export config in Core Settings.",
                        Icon = "circle-alert",
                        Duration = 5,
                    });
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
