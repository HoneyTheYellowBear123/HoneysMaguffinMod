-- Copyright 2018-2020, Firaxis Games

-- This file is being included into the base GreatWorksOverview file using the wildcard include setup in GreatWorksOverview.lua
-- Refer to the bottom of GreatWorksOverview.lua to see how that's happening
-- DO NOT include any GreatWorksOverview files here or it will cause problems
include("GreatWorksOverview");

include("InstanceManager");
include("PopupDialog");
include("GameCapabilities");
include("GreatWorksSupport");

g_DEFAULT_GREAT_WORKS_ICONS["GREATWORKSLOT_HONEY_MACGUFFIN"] = "ICON_GREATWORKOBJECT_ARTIFACT_ERA_ANCIENT"; --TO DO: replace this right side of this

-- ===========================================================================
--	CONSTANTS Shoul probably switch the base game to just use globals.
-- ===========================================================================

local NUM_RELIC_TEXTURES:number = 48;
local NUM_ARIFACT_TEXTURES:number = 25;
local GREAT_WORK_RELIC_TYPE:string = "GREATWORKOBJECT_RELIC";
local GREAT_WORK_ARTIFACT_TYPE:string = "GREATWORKOBJECT_ARTIFACT";


local SIZE_SLOT_TYPE_ICON:number = 40;
local SIZE_GREAT_WORK_ICON:number = 64;
local PADDING_PROVIDING_LABEL:number = 10;
local MIN_PADDING_SLOTS:number = 2;
local MAX_PADDING_SLOTS:number = 30;
local MAX_NUM_SLOTS:number = 6;
local DEFAULT_LOCK_TURNS:number = 10;

local LOC_TOURISM:string = Locale.Lookup("LOC_GREAT_WORKS_TOURISM");
local LOC_THEME_BONUS:string = Locale.Lookup("LOC_GREAT_WORKS_THEMED_BONUS");
local LOC_SCREEN_TITLE:string = Locale.Lookup("LOC_GREAT_WORKS_SCREEN_TITLE");

local DATA_FIELD_SLOT_CACHE:string = "SlotCache";
local DATA_FIELD_GREAT_WORK_IM:string = "GreatWorkIM";
local DATA_FIELD_TOURISM_YIELD:string = "TourismYield";
local DATA_FIELD_THEME_BONUS_IM:string = "ThemeBonusIM";

local DATA_FIELD_CITY_ID			:string = "DataField_CityID";
local DATA_FIELD_BUILDING_ID		:string = "DataField_BuildingID";
local DATA_FIELD_GREAT_WORK_INDEX	:string = "DataField_GreatWorkIndex";
local DATA_FIELD_SLOT_INDEX			:string = "DataField_SlotIndex";
local DATA_FIELD_GREAT_WORK_TYPE	:string = "DataField_GreatWorkType";

local YIELD_FONT_ICONS:table = {
	YIELD_FOOD				= "[ICON_FoodLarge]",
	YIELD_PRODUCTION		= "[ICON_ProductionLarge]",
	YIELD_GOLD				= "[ICON_GoldLarge]",
	YIELD_SCIENCE			= "[ICON_ScienceLarge]",
	YIELD_CULTURE			= "[ICON_CultureLarge]",
	YIELD_FAITH				= "[ICON_FaithLarge]",
	TourismYield			= "[ICON_TourismLarge]"
};

g_DEFAULT_GREAT_WORKS_ICONS = {
	GREATWORKSLOT_WRITING	= "ICON_GREATWORKOBJECT_WRITING",
	GREATWORKSLOT_PALACE	= "ICON_GREATWORKOBJECT_SCULPTURE",
	GREATWORKSLOT_ART		= "ICON_GREATWORKOBJECT_PORTRAIT",
	GREATWORKSLOT_CATHEDRAL	= "ICON_GREATWORKOBJECT_RELIGIOUS",
	GREATWORKSLOT_ARTIFACT	= "ICON_GREATWORKOBJECT_ARTIFACT_ERA_ANCIENT",
	GREATWORKSLOT_MUSIC		= "ICON_GREATWORKOBJECT_MUSIC",
	GREATWORKSLOT_RELIC		= "ICON_GREATWORKOBJECT_RELIC",
	GREATWORKSLOT_HONEY_MACGUFFIN = "ICON_GREATWORKOBJECT_RELIC",
};

local BASE_GetGreatWorkTooltip = GetGreatWorkTooltip;



-- ===========================================================================
--	SCREEN VARIABLES
-- ===========================================================================
local m_FirstGreatWork:table = nil;
local m_GreatWorkYields:table = nil;
local m_GreatWorkSelected:table = nil;
local m_GreatWorkBuildings:table = nil;
local m_GreatWorkSlotsIM:table = InstanceManager:new("GreatWorkSlot", "TopControl", Controls.GreatWorksStack);
local m_TotalResourcesIM:table = InstanceManager:new("AgregateResource", "Resource", Controls.TotalResources);

local m_kViableDropTargets:table = {};
local m_kControlToInstanceMap:table = {};
local m_uiSelectedDropTarget:table = nil;

-- ===========================================================================
--	PLAYER VARIABLES
-- ===========================================================================
local m_LocalPlayer:table;
local m_LocalPlayerID:number;

local m_during_move:boolean = false;
local m_dest_building:number = 0;
local m_dest_city;
local m_isLocalPlayerTurn:boolean = true;



-- ===========================================================================
function megaCheck()

	local index = 1
	for building in GameInfo.Buildings() do

		for buildinggreatworkslots in GameInfo.Building_GreatWorks() do

			if building.BuildingType == buildinggreatworkslots.BuildingType then

				print("Honeydebug wow BuildingType "..building.BuildingType)
				print("Honeydebug wow Slottype "..buildinggreatworkslots.GreatWorkSlotType)
				print("Honeydebug wow number of slots "..buildinggreatworkslots.NumSlots)

			end

		end

	end

end

function UpdatePlayerData()
	print("honeydebugdebug 0");
	m_LocalPlayerID = Game.GetLocalPlayer();
	if m_LocalPlayerID ~= -1 then
		m_LocalPlayer = Players[m_LocalPlayerID];
	end
	print("honeydebugdebug 0 END");
end

-- ===========================================================================

function UpdateGreatWorks()

	--megaCheck()
	
	print("honeydebugdebug a1");
	m_FirstGreatWork = nil;
	print("honeydebugdebug a2");
	m_GreatWorkSelected = nil;
	print("honeydebugdebug a3");
	m_GreatWorkSlotsIM:ResetInstances();
	print("honeydebugdebug a4");
	Controls.PlacingContainer:SetHide(true);
	print("honeydebugdebug a5");
	Controls.HeaderStatsContainer:SetHide(false);
	print("honeydebugdebug a6");

	if (m_LocalPlayer == nil) then
		return;
	end
	print("honeydebugdebug a7");

	m_GreatWorkYields = {};
	m_GreatWorkBuildings = {};
	local numGreatWorks:number = 0;
	local numDisplaySpaces:number = 0;

	print("honeydebugdebug a8");

	local pCities:table = m_LocalPlayer:GetCities();
	for i, pCity in pCities:Members() do
		if pCity ~= nil and pCity:GetOwner() == m_LocalPlayerID then
			local pCityBldgs:table = pCity:GetBuildings();
			for buildingInfo in GameInfo.Buildings() do
				print("honeydebugdebug a9");
				local buildingIndex:number = buildingInfo.Index;
				local buildingType:string = buildingInfo.BuildingType;
				if(pCityBldgs:HasBuilding(buildingIndex)) then

					print("honeydebugdebug a building found");
					print("honeydebugdebug a building is "..Locale.ToUpper(Locale.Lookup(buildingInfo.Name)));

					--IMPORTANT working theory is that get numgreatworkslots does not work, may possibly be hardcoded. Its possible that there may be modifiers that it looks for that could be abused.
					local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
					print("honeydebugdebug a greatworkslot returned is "..numSlots);

					--if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
					--	print("honeydebugdebug a artificially increasing macguffin holder slots");
					--	numSlots = 1
					--end

					if (numSlots ~= nil and numSlots > 0) then
						print("honeydebugdebug a AT LEAST ONE GREAT WORK SLOT FOUND");
						local instance:table = m_GreatWorkSlotsIM:GetInstance();
						local greatWorks:number = PopulateGreatWorkSlot(instance, pCity, pCityBldgs, buildingInfo);
						table.insert(m_GreatWorkBuildings, {Instance=instance, Type=buildingType, Index=buildingIndex, CityBldgs=pCityBldgs});
						numDisplaySpaces = numDisplaySpaces + pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
						--if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
						--	print("honeydebugdebug a artificially increasing macguffin holder slots a second time");
						--	numDisplaySpaces = numDisplaySpaces + 1
						--end
						numGreatWorks = numGreatWorks + greatWorks;
					end
				end
			end
		end
	end

	Controls.NumGreatWorks:SetText(numGreatWorks);
	Controls.NumDisplaySpaces:SetText(numDisplaySpaces);

	-- Realize stack and scrollbar
	Controls.GreatWorksStack:CalculateSize();
	Controls.GreatWorksStack:ReprocessAnchoring();
	Controls.GreatWorksScrollPanel:CalculateInternalSize();
	Controls.GreatWorksScrollPanel:ReprocessAnchoring();

	m_TotalResourcesIM:ResetInstances();

	if table.count(m_GreatWorkYields) > 0 then
		table.sort(m_GreatWorkYields, function(a,b) return a.Name < b.Name; end);

		for _, data in ipairs(m_GreatWorkYields) do
			local instance:table = m_TotalResourcesIM:GetInstance();
			instance.Resource:SetText(data.Icon .. data.Value);
			instance.Resource:SetToolTipString(data.Name);
		end

		Controls.TotalResources:CalculateSize();
		Controls.TotalResources:ReprocessAnchoring();
		Controls.ProvidingLabel:SetOffsetX(Controls.TotalResources:GetOffsetX() + Controls.TotalResources:GetSizeX() + PADDING_PROVIDING_LABEL);
		Controls.ProvidingLabel:SetHide(false);
	else
		Controls.ProvidingLabel:SetHide(true);
	end

	-- Hide "View Gallery" button if we don't have a single great work
	Controls.ViewGallery:SetHide(m_FirstGreatWork == nil);
	print("honeydebugdebug a END");
end


function PopulateGreatWorkSlot(instance:table, pCity:table, pCityBldgs:table, pBuildingInfo:table)

	print("honeydebugdebug b")
	
	instance.DefaultBG:SetHide(false);
	instance.DisabledBG:SetHide(true);
	instance.HighlightedBG:SetHide(true);
	instance.DefaultBG:RegisterCallback(Mouse.eLClick, function() end); -- clear callback
	instance.HighlightedBG:RegisterCallback(Mouse.eLClick, function() end); -- clear callback

	local buildingType:string = pBuildingInfo.BuildingType;
	local buildingIndex:number = pBuildingInfo.Index;
	local themeDescription = GetThemeDescription(buildingType);
	instance.CityName:SetText(Locale.Lookup(pCity:GetName()));
	instance.BuildingName:SetText(Locale.ToUpper(Locale.Lookup(pBuildingInfo.Name)));

	-- Ensure we have Instance Managers for the great works
	local greatWorkIM:table = instance[DATA_FIELD_GREAT_WORK_IM];
	if(greatWorkIM == nil) then
		greatWorkIM = InstanceManager:new("GreatWork", "TopControl", instance.GreatWorks);
		instance[DATA_FIELD_GREAT_WORK_IM] = greatWorkIM;
	else
		greatWorkIM:ResetInstances();
	end

	local index:number = 0;
	local numGreatWorks:number = 0;
	local numThemedGreatWorks:number = 0;
	local instanceCache:table = {};
	local firstGreatWork:table = nil;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);

	print("HoneyDebug Q PopulateGreatWorkSlot BuildingType "..buildingType)
	print("HoneyDebug Q PopulateGreatWorkSlot numslots before artificial increase "..numSlots)
	--if (buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index ) then
	--	numSlots = 1
	--end

	local localPlayerID = Game.GetLocalPlayer();
	local localPlayer = Players[localPlayerID];

	if(localPlayer == nil) then
		return nil;
	end

	local bAutoTheme = localPlayer:GetCulture():IsAutoThemedEligible();

	if (numSlots ~= nil and numSlots > 0) then
		for _:number=0, numSlots - 1 do
			local instance:table = greatWorkIM:GetInstance();
			local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
			local greatWorkSlotType:number = pCityBldgs:GetGreatWorkSlotType(buildingIndex, index);

			--if (buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index ) then
			--	greatWorkSlotType = GameInfo.GreatWorkSlotTypes['GREATWORKSLOT_HONEY_MACGUFFIN'].Index
			--end



			if greatWorkSlotType >= 0 then
				local greatWorkSlotString:string = GameInfo.GreatWorkSlotTypes[greatWorkSlotType].GreatWorkSlotType;

				PopulateGreatWork(instance, pCityBldgs, pBuildingInfo, index, greatWorkIndex, greatWorkSlotString);
				index = index + 1;
				instanceCache[index] = instance;
				if greatWorkIndex ~= -1 then
					numGreatWorks = numGreatWorks + 1;
					local greatWorkType:number = pCityBldgs:GetGreatWorkTypeFromIndex(greatWorkIndex);
					local greatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];
					if firstGreatWork == nil then
						firstGreatWork = greatWorkInfo;
					end
					if greatWorkInfo ~= nil and GreatWorkFitsTheme(pCityBldgs, pBuildingInfo, greatWorkIndex, greatWorkInfo) then
						numThemedGreatWorks = numThemedGreatWorks + 1;
					end
				end
			end
		end                            

		if firstGreatWork ~= nil and themeDescription ~= nil and buildingType ~= "BUILDING_QUEENS_BIBLIOTHEQUE" then
			local slotTypeIcon:string = "ICON_" .. firstGreatWork.GreatWorkObjectType;
			if firstGreatWork.GreatWorkObjectType == "GREATWORKOBJECT_ARTIFACT" then
				slotTypeIcon = slotTypeIcon .. "_" .. firstGreatWork.EraType;
			end

			local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(slotTypeIcon, SIZE_SLOT_TYPE_ICON);
			if(textureSheet == nil or textureSheet == "") then
				UI.DataError("Could not find slot type icon in PopulateGreatWorkSlot: icon=\""..slotTypeIcon.."\", iconSize="..tostring(SIZE_SLOT_TYPE_ICON));
			else
				for i:number=0, numSlots - 1 do
					local slotIndex:number = index - i;
					instanceCache[slotIndex].SlotTypeIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
				end
			end
		end
	end

	instance[DATA_FIELD_SLOT_CACHE] = instanceCache;

	local numSlots:number = table.count(instanceCache);
	if(numSlots > 1) then
		local slotRange:number = MAX_NUM_SLOTS - 2;
		local paddingRange:number = MAX_PADDING_SLOTS - MIN_PADDING_SLOTS;
		local finalPadding:number = ((MAX_NUM_SLOTS - numSlots) * paddingRange / slotRange) + MIN_PADDING_SLOTS;
		instance.GreatWorks:SetStackPadding(finalPadding);
	else
		instance.GreatWorks:SetStackPadding(0);
	end

	-- Ensure we have Instance Managers for the theme bonuses
	local themeBonusIM:table = instance[DATA_FIELD_THEME_BONUS_IM];
	if(themeBonusIM == nil) then
		themeBonusIM = InstanceManager:new("Resource", "Resource", instance.ThemeBonuses);
		instance[DATA_FIELD_THEME_BONUS_IM] = themeBonusIM;
	else
		themeBonusIM:ResetInstances();
	end

	if numGreatWorks == 0 then
		if themeDescription ~= nil then
			instance.ThemingLabel:SetText(Locale.Lookup("LOC_GREAT_WORKS_THEME_BONUS_PROGRESS", numThemedGreatWorks, numSlots));
			instance.ThemingLabel:SetToolTipString(themeDescription);
		end
	else
		instance.ThemingLabel:SetText("");
		instance.ThemingLabel:SetToolTipString("");
		if pCityBldgs:IsBuildingThemedCorrectly(buildingIndex) then
			instance.ThemingLabel:SetText(LOC_THEME_BONUS);
			if IsDuringMove() then
				if buildingIndex == GetDestBuilding() then
                    if (GetDestCity() == pCityBldgs:GetCity():GetID()) then
                        UI.PlaySound("UI_GREAT_WORKS_BONUS_ACHIEVED");
                    end
				end
			end
		else
			if themeDescription ~= nil then
                -- if we're being called due to moving a work
				if numSlots > 1 then
					if(bAutoTheme == true) then
						instance.ThemingLabel:SetText(Locale.Lookup("LOC_GREAT_WORKS_THEME_BONUS_PROGRESS", numGreatWorks, numSlots));
					else
						instance.ThemingLabel:SetText(Locale.Lookup("LOC_GREAT_WORKS_THEME_BONUS_PROGRESS", numThemedGreatWorks, numSlots));
					end

					if IsDuringMove() then
						if buildingIndex == GetDestBuilding() then
                            if (GetDestCity() == pCityBldgs:GetCity():GetID()) then
                                if numThemedGreatWorks == 2 then
                                    UI.PlaySound("UI_GreatWorks_Bonus_Increased");
                                end
                            end
						end
					end
				end

				if instance.ThemingLabel:GetText() ~= "" then
					instance.ThemingLabel:SetToolTipString(themeDescription);
				end
			end
		end
	end

	for row in GameInfo.Yields() do
		local yieldValue:number = pCityBldgs:GetBuildingYieldFromGreatWorks(row.Index, buildingIndex);
		if yieldValue > 0 then
			AddYield(themeBonusIM:GetInstance(), Locale.Lookup(row.Name), YIELD_FONT_ICONS[row.YieldType], yieldValue);
		end
	end

	local regularTourism:number = pCityBldgs:GetBuildingTourismFromGreatWorks(false, buildingIndex);
	local religionTourism:number = pCityBldgs:GetBuildingTourismFromGreatWorks(true, buildingIndex);
	local totalTourism:number = regularTourism + religionTourism;

	if totalTourism > 0 then
		AddYield(themeBonusIM:GetInstance(), LOC_TOURISM, YIELD_FONT_ICONS[DATA_FIELD_TOURISM_YIELD], totalTourism);
	end

	instance.ThemeBonuses:CalculateSize();
	instance.ThemeBonuses:ReprocessAnchoring();

	print("honeydebugdebug b END")
	return numGreatWorks;
end


-- IMPORTANT: This logic is largely derived from GetGreatWorkTooltip() - if you make an update here, make sure to update that function as well
function GreatWorkFitsTheme(pCityBldgs:table, pBuildingInfo:table, greatWorkIndex:number, greatWorkInfo:table)
	print("honeydebugdebug c");
	local firstGreatWork:number = GetFirstGreatWorkInBuilding(pCityBldgs, pBuildingInfo);
	if firstGreatWork < 0 then
		return false;
	end

	local firstGreatWorkObjectTypeID:number = pCityBldgs:GetGreatWorkTypeFromIndex(firstGreatWork);
	local firstGreatWorkObjectType:string = GameInfo.GreatWorks[firstGreatWorkObjectTypeID].GreatWorkObjectType;
	
	if pCityBldgs:IsBuildingThemedCorrectly(GameInfo.Buildings[pBuildingInfo.BuildingType].Index) then
		return true;
	else
		if pBuildingInfo.BuildingType == "BUILDING_MUSEUM_ART" then

			if firstGreatWork == greatWorkIndex then
				return true;
			elseif not IsFirstGreatWorkByArtist(greatWorkIndex, pCityBldgs, pBuildingInfo) then
				return false;
			else
				return firstGreatWorkObjectType == greatWorkInfo.GreatWorkObjectType;
			end
		elseif pBuildingInfo.BuildingType == "BUILDING_MUSEUM_ARTIFACT" then

			if firstGreatWork == greatWorkIndex then
				return true;
			else
				if greatWorkInfo.EraType ~= GameInfo.GreatWorks[firstGreatWorkObjectTypeID].EraType then
					return false;
				else
					local greatWorkPlayer:number = Game.GetGreatWorkPlayer(greatWorkIndex);
					local greatWorks:table = GetGreatWorksInBuilding(pCityBldgs, pBuildingInfo);
					
					-- Find duplicates for theming description
					local hash:table = {}
					local duplicates:table = {}
					for _,index in ipairs(greatWorks) do
						local gwPlayer:number = Game.GetGreatWorkPlayer(index);
						if (not hash[gwPlayer]) then
							hash[gwPlayer] = true;
						else
							table.insert(duplicates, gwPlayer);
						end
					end

					return table.count(duplicates) == 0;
				end
			end
		end
	end
	print("honeydebugdebug c END");
end


function GetGreatWorkIcon(greatWorkInfo:table)
	print("honeydebugdebug d");

	local greatWorkIcon:string;
	
	if greatWorkInfo.GreatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE then
		local greatWorkType:string = greatWorkInfo.GreatWorkType;
		greatWorkType = greatWorkType:gsub("GREATWORK_ARTIFACT_", "");
		local greatWorkID:number = tonumber(greatWorkType);
		greatWorkID = ((greatWorkID - 1) % NUM_ARIFACT_TEXTURES) + 1;
		greatWorkIcon = "ICON_GREATWORK_ARTIFACT_" .. greatWorkID;
	elseif greatWorkInfo.GreatWorkObjectType == GREAT_WORK_RELIC_TYPE then
		local greatWorkType:string = greatWorkInfo.GreatWorkType;
		greatWorkType = greatWorkType:gsub("GREATWORK_RELIC_", "");
		local greatWorkID:number = tonumber(greatWorkType);
		greatWorkID =  ((greatWorkID - 1) % NUM_RELIC_TEXTURES) + 1;
		greatWorkIcon = "ICON_GREATWORK_RELIC_" .. greatWorkID;
	else
		greatWorkIcon = "ICON_" .. greatWorkInfo.GreatWorkType;
	end

	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(greatWorkIcon, SIZE_GREAT_WORK_ICON);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find slot type icon in GetGreatWorkIcon: icon=\""..greatWorkIcon.."\", iconSize="..tostring(SIZE_GREAT_WORK_ICON));
	end
	print("honeydebugdebug d END");
	return textureOffsetX, textureOffsetY, textureSheet;
end


function GetThemeDescription(buildingType:string)
	print("honeydebugdebug e");
	local localPlayerID = Game.GetLocalPlayer();
	local localPlayer = Players[localPlayerID];

	if(localPlayer == nil) then
		return nil;
	end

    local eBuilding = localPlayer:GetCulture():GetAutoThemedBuilding();
	local bAutoTheme = localPlayer:GetCulture():IsAutoThemedEligible(GameInfo.Buildings[buildingType].Hash);

	if (GameInfo.Buildings[buildingType].Index == eBuilding) then
		return Locale.Lookup("LOC_BUILDING_THEMINGBONUS_FULL_MUSEUM");
	elseif(bAutoTheme == true) then
		return Locale.Lookup("LOC_BUILDING_THEMINGBONUS_FULL_MUSEUM");
	else
		for row in GameInfo.Building_GreatWorks() do
			if row.BuildingType == buildingType then
				if row.ThemingBonusDescription ~= nil then
					print("honeydebugdebug e END A");
					return Locale.Lookup(row.ThemingBonusDescription);
				end		
			end
		end
	end
	print("honeydebugdebug e END b");
	return nil;
end

--THIS FUNCTION IS CRUCIAL IF YOU ARE ADDING NEW GREAT WORK SLOT TYPES AND THEY SAY THAT IN THE CODE BUT ITS SO SMALL
function GetGreatWorkSlotTypeIcon(slotType:string)
	print("honeydebugdebug f");
	print("honeydebugdebug f END");
	return g_DEFAULT_GREAT_WORKS_ICONS[slotType];
end


function PopulateGreatWork(instance:table, pCityBldgs:table, pBuildingInfo:table, slotIndex:number, greatWorkIndex:number, slotType:string)
	print("honeydebugdebug g");
	local buildingIndex:number = pBuildingInfo.Index;
	local slotTypeIcon:string = GetGreatWorkSlotTypeIcon(slotType);

	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(slotTypeIcon, SIZE_SLOT_TYPE_ICON);
	if(textureSheet == nil or textureSheet == "") then
		print("honeydebugdebug g no slot type icon found for "..slotType);
		UI.DataError("Could not find slot type icon in PopulateGreatWork: icon=\""..slotTypeIcon.."\", iconSize="..tostring(SIZE_SLOT_TYPE_ICON));
	else
		print("honeydebugdebug g  slot type icon WAS found for "..slotType);
		instance.SlotTypeIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	end

	instance[DATA_FIELD_CITY_ID] = pCityBldgs:GetCity():GetID();
	instance[DATA_FIELD_BUILDING_ID] = buildingIndex;
	instance[DATA_FIELD_SLOT_INDEX]	= slotIndex;
	instance[DATA_FIELD_GREAT_WORK_INDEX] = greatWorkIndex;
	instance[DATA_FIELD_GREAT_WORK_TYPE] = -1;
	
	if greatWorkIndex == -1 then
		print("honeydebugdebug g great work index is -1 which I think means no great work");
		instance.GreatWorkIcon:SetHide(true);

		local validWorks:string = "";
		for row in GameInfo.GreatWork_ValidSubTypes() do
			if slotType == row.GreatWorkSlotType then
				if validWorks ~= "" then
					validWorks = validWorks .. "[NEWLINE]";
				end
				validWorks = validWorks .. Locale.Lookup("LOC_" .. row.GreatWorkObjectType);
			end
		end

		instance.EmptySlot:ClearCallback(Mouse.eLClick);
		instance.EmptySlot:SetToolTipString(Locale.Lookup("LOC_GREAT_WORKS_EMPTY_TOOLTIP", validWorks));
	else
		print("honeydebugdebug g great work index is NOT -1");
		instance.GreatWorkIcon:SetHide(false);

		local srcGreatWork:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, slotIndex);
		local srcGreatWorkType:number = pCityBldgs:GetGreatWorkTypeFromIndex(srcGreatWork);
		local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;

		instance[DATA_FIELD_GREAT_WORK_TYPE] = srcGreatWorkType;

		local greatWorkType:number = pCityBldgs:GetGreatWorkTypeFromIndex(greatWorkIndex);
		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = GetGreatWorkIcon(GameInfo.GreatWorks[greatWorkType]);
		instance.GreatWorkIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);

		instance.EmptySlot:SetToolTipString(GetGreatWorkTooltip(pCityBldgs, greatWorkIndex, greatWorkType, pBuildingInfo));
		
		local bAllowMove:boolean = true;

		-- Don't allow moving artifacts if the museum is not full
		if bAllowMove and srcGreatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE then
			if not IsBuildingFull(pCityBldgs, buildingIndex) then
				instance.GreatWorkDraggable:RegisterCallback(Drag.eDragDisabled, function() ShowCannotMoveMessage(Locale.Lookup("LOC_GREAT_WORKS_ARTIFACT_LOCKED_FROM_MOVE")); end);
				bAllowMove = false;
			end
		end

		-- Don't allow moving art that has been recently created
		if bAllowMove and srcGreatWorkObjectType == "GREATWORKOBJECT_SCULPTURE" or
			srcGreatWorkObjectType == "GREATWORKOBJECT_LANDSCAPE" or
			srcGreatWorkObjectType == "GREATWORKOBJECT_PORTRAIT" or
			srcGreatWorkObjectType == "GREATWORKOBJECT_RELIGIOUS" then

			local iTurnCreated:number = pCityBldgs:GetTurnFromIndex(greatWorkIndex);
			local iCurrentTurn:number = Game.GetCurrentGameTurn();
			local iTurnsBeforeMove:number = GlobalParameters.GREATWORK_ART_LOCK_TIME or DEFAULT_LOCK_TURNS;
			local iTurnsToWait = iTurnCreated + iTurnsBeforeMove - iCurrentTurn;
			if iTurnsToWait > 0 then
				instance.GreatWorkDraggable:RegisterCallback(Drag.eDragDisabled, function() ShowCannotMoveMessage(Locale.Lookup("LOC_GREAT_WORKS_LOCKED_FROM_MOVE", iTurnsToWait)); end);
				bAllowMove = false;
			end
		end

		if bAllowMove then
			instance.GreatWorkDraggable:SetDisabled(false);
			instance.GreatWorkDraggable:RegisterCallback(Drag.eDown, function(kDragStruct) OnClickGreatWork( kDragStruct,pCityBldgs, buildingIndex, greatWorkIndex, slotIndex ); end);
			instance.GreatWorkDraggable:RegisterCallback(Drag.eDrop, function(kDragStruct) OnGreatWorkDrop( kDragStruct, instance ); end);
			instance.GreatWorkDraggable:RegisterCallback(Drag.eDrag, function(kDragStruct) OnGreatWorkDrag( kDragStruct, instance ); end);
		else
			instance.GreatWorkDraggable:SetDisabled(true);
		end

		if m_FirstGreatWork == nil then
			m_FirstGreatWork = {Index=greatWorkIndex, Building=buildingIndex, CityBldgs=pCityBldgs};
		end
	end
	
	instance.EmptySlotHighlight:SetHide(true);
	print("honeydebugdebug g END");
end


-- ===========================================================================
function OnGreatWorkDrop( kDragStruct:table, kInstance:table )
	print("honeydebugdebug h");
	if m_uiSelectedDropTarget ~= nil then
		print("honeydebugdebug h drop target was nonzero");
		if m_uiSelectedDropTarget == Controls.ViewGreatWork then
			print("honeydebugdebug h drop target was view greatwork");
			OnViewGreatWork()
		else
			print("honeydebugdebug h drop target was NOT nonzero");
			local kSelectedDropInstance = m_kControlToInstanceMap[m_uiSelectedDropTarget];
			if kSelectedDropInstance then
				print("honeydebugdebug h calling movegreatwork");
				MoveGreatWork(kInstance, kSelectedDropInstance);
			end
		end
	end
	
	ClearGreatWorkTransfer();
	print("honeydebugdebug h END");
end


-- ===========================================================================
function OnGreatWorkDrag( kDragStruct:table, kInstance:table )
	print("honeydebugdebug i");
	local uiDragControl:table = kDragStruct:GetControl();
	local uiBestDropTarget = uiDragControl:GetBestOverlappingControl( m_kViableDropTargets );
	
	if uiBestDropTarget then
		HighlightDropTarget(uiBestDropTarget);
		m_uiSelectedDropTarget = uiBestDropTarget;
	else
		HighlightDropTarget();
		m_uiSelectedDropTarget = nil;
	end
	print("honeydebugdebug i END");
end

-- ===========================================================================
function HighlightDropTarget( uiBestDropTarget:table )
	print("honeydebugdebug j");
	for _,uiDropTarget in ipairs(m_kViableDropTargets) do
		if uiDropTarget == Controls.ViewGreatWork then
			Controls.ViewGreatWork:SetSelected(uiBestDropTarget == Controls.ViewGreatWork);
		else
			local pDropInstance = m_kControlToInstanceMap[uiDropTarget];
			if pDropInstance ~= nil then
				pDropInstance.EmptySlotHighlight:SetHide(uiDropTarget ~= uiBestDropTarget);
			end
		end
	end
	print("honeydebugdebug j END");
end

--TO DO edit this to show the different tiers of macguffins
function GetGreatWorkTooltip(pCityBldgs:table, greatWorkIndex:number, greatWorkType:number, pBuildingInfo:table)
	print("honeydebugdebug k");
	--print("get great work tool tip was called");

	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];

	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE" then
		--print("danger point 1");
		print("honeydebugdebug k END a");
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end
	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE" then
		print("honeydebugdebug k END b");
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end

	print("honeydebugdebug k END c");
	return BASE_GetGreatWorkTooltip(pCityBldgs, greatWorkIndex, greatWorkType, pBuildingInfo);
end



function GetFirstGreatWorkInBuilding(pCityBldgs:table, pBuildingInfo:table)
	print("honeydebugdebug l");
	local index:number = 0;
	local buildingIndex:number = pBuildingInfo.Index;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
	--if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
	--	print("honeydebugdebug l artificially increasing macguffin holder slots");
	--	numSlots = 1
	--end
	for _:number=0, numSlots - 1 do
		local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
		if greatWorkIndex ~= -1 then
			print("honeydebugdebug l END a");
			return greatWorkIndex;
		end
		index = index + 1;
	end
	print("honeydebugdebug l END b");
	return -1;
end


function GetGreatWorksInBuilding(pCityBldgs:table, pBuildingInfo:table)	
	print("honeydebugdebug m");
	local index:number = 0;
	local results:table = {};
	local buildingIndex:number = pBuildingInfo.Index;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
	--if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
	--	print("honeydebugdebug m artificially increasing macguffin holder slots");
	--	numSlots = 1
	--end
	for _:number=0, numSlots - 1 do
		local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
		if greatWorkIndex ~= -1 then
			table.insert(results, greatWorkIndex);
		end
		index = index + 1;
	end
	print("honeydebugdebug m END");
	return results;
end

function IsFirstGreatWorkByArtist(greatWorkIndex, pCityBldgs, pBuildingInfo)
	print("honeydebugdebug n");
	local greatWorks:table = GetGreatWorksInBuilding(pCityBldgs, pBuildingInfo);
	local artist = pCityBldgs:GetCreatorNameFromIndex(greatWorkIndex); -- no need to localize

	-- Find duplicates for theming description
	for _,index in ipairs(greatWorks) do
		if (index == greatWorkIndex) then
			-- Didn't find a duplicate before the specified great work
			print("honeydebugdebug n END");
			return true; 
		end

		local creator = pCityBldgs:GetCreatorNameFromIndex(index); -- no need to localize
		if (creator == artist) then
			-- Found a duplicate before the specified great work
			print("honeydebugdebug n END");
			return false;
		end
	end

	print("honeydebugdebug n END");
	-- The specified great work isn't in this building, if it was added it would be unique
	return true;
end

function AddYield(instance:table, yieldName:string, yieldIcon:string, yieldValue:number)
	print("honeydebugdebug O");
	local bFoundYield:boolean = false;
	for _,data in ipairs(m_GreatWorkYields) do
		if data.Name == yieldName then
			data.Value = data.Value + yieldValue;
			bFoundYield = true;
			break;
		end
	end
	if bFoundYield == false then
		table.insert(m_GreatWorkYields, {Name=yieldName, Icon=yieldIcon, Value=yieldValue});
	end
	instance.Resource:SetText(yieldIcon .. yieldValue);
	instance.Resource:SetToolTipString(yieldName);
	print("honeydebugdebug O END");
end

function OnClickGreatWork(kDragStruct:table, pCityBldgs:table, buildingIndex:number, greatWorkIndex:number, slotIndex:number)
	print("honeydebugdebug p");

	-- Don't allow moving great works unless it's the local player's turn
	if not m_isLocalPlayerTurn then return; end

	-- Don't allow moving artifacts if the museum is not full
	if not CanMoveWorkAtAll(pCityBldgs, buildingIndex, slotIndex) then
		return;
	end
	
	local greatWorkType:number = pCityBldgs:GetGreatWorkTypeFromIndex(greatWorkIndex);

	-- Subscribe to updates to keep great work icon attached to mouse
	m_GreatWorkSelected = {Index=greatWorkIndex, Slot=slotIndex, Building=buildingIndex, CityBldgs=pCityBldgs};

	-- Set placing label and details
	Controls.PlacingContainer:SetHide(false);
	Controls.HeaderStatsContainer:SetHide(true);
	Controls.PlacingName:SetText(Locale.ToUpper(Locale.Lookup(GameInfo.GreatWorks[greatWorkType].Name)));
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = GetGreatWorkIcon(GameInfo.GreatWorks[greatWorkType]);
	Controls.PlacingIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);

	for _:number, destination:table in ipairs(m_GreatWorkBuildings) do
		print("honeydebugdebug p==========================================================================================================================")
		local firstValidSlot:number = -1;
		local instance:table = destination.Instance;
		local dstBuilding:number = destination.Index;
		local dstBldgs:table = destination.CityBldgs;
		local slotCache:table = instance[DATA_FIELD_SLOT_CACHE];
		local numSlots:number = dstBldgs:GetNumGreatWorkSlots(dstBuilding);
		print("honeydebugdebug p looping great work destination buildings! this building index is "..dstBuilding);
		print("honeydebugdebug p looping macguffin holder index is "..GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index);
		--if dstBuilding == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		--	print("honeydebugdebug p artificially increasing macguffin holder slots");
		--	numSlots = 1
		--end
		for index:number = 0, numSlots - 1 do
			if CanMoveGreatWork(pCityBldgs, buildingIndex, slotIndex, dstBldgs, dstBuilding, index) then -- u
				print("honeydebugdebug p we can move to the destination building");
				if firstValidSlot == -1 then
					firstValidSlot = index;
				end

				local slotInstance:table = slotCache[index + 1];
				if slotInstance then
					table.insert(m_kViableDropTargets, slotInstance.TopControl);
					m_kControlToInstanceMap[slotInstance.TopControl] = slotInstance;
				end
			end
		end

		if firstValidSlot ~= -1 then
            UI.PlaySound("UI_GreatWorks_Pick_Up");
		end

		instance.HighlightedBG:SetHide(firstValidSlot == -1);
		instance.DefaultBG:SetHide(firstValidSlot == -1);
		instance.DisabledBG:SetHide(firstValidSlot ~= -1);
	end

	-- Add ViewGreatWorks button to drop targets so we can view specific works
	table.insert(m_kViableDropTargets, Controls.ViewGreatWork);
	print("honeydebugdebug p END");
end


function CanMoveWorkAtAll(srcBldgs:table, srcBuilding:number, srcSlot:number)
	print("honeydebugdebug q");
	local srcGreatWork:number = srcBldgs:GetGreatWorkInSlot(srcBuilding, srcSlot);
	local srcGreatWorkType:number = srcBldgs:GetGreatWorkTypeFromIndex(srcGreatWork);
	local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;

	-- Don't allow moving artifacts if the museum is not full
	if (srcGreatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE) then
		if not IsBuildingFull(srcBldgs, srcBuilding) then
			print("honeydebugdebug q END a");
			return false;
		end
	end

	-- Don't allow moving art that has been recently created
	if (srcGreatWorkObjectType == "GREATWORKOBJECT_SCULPTURE" or
	    srcGreatWorkObjectType == "GREATWORKOBJECT_LANDSCAPE" or
		srcGreatWorkObjectType == "GREATWORKOBJECT_PORTRAIT" or
		srcGreatWorkObjectType == "GREATWORKOBJECT_RELIGIOUS") then

		local iTurnCreated:number = srcBldgs:GetTurnFromIndex(srcGreatWork);
		local iCurrentTurn:number = Game.GetCurrentGameTurn();
		local iTurnsBeforeMove:number = GlobalParameters.GREATWORK_ART_LOCK_TIME or DEFAULT_LOCK_TURNS;
		local iTurnsToWait = iTurnCreated + iTurnsBeforeMove - iCurrentTurn;
		if iTurnsToWait > 0 then
			print("honeydebugdebug q END b");
			return false;
		end
	end

	print("honeydebugdebug q END c");
	return true;
end


function IsBuildingFull( pBuildings:table, buildingIndex:number )
	print("honeydebugdebug r");
	local numSlots:number = pBuildings:GetNumGreatWorkSlots(buildingIndex);
	--if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
	--	print("honeydebugdebug r artificially increasing macguffin holder slots");
	--	numSlots = 1
	--end
	for index:number = 0, numSlots - 1 do
		local greatWorkIndex:number = pBuildings:GetGreatWorkInSlot(buildingIndex, index);
		if (greatWorkIndex == -1) then
			print("honeydebugdebug r END");
			return false;
		end
	end
	print("honeydebugdebug r END");
	return true;
end


-- ===========================================================================
function ShowCannotMoveMessage(sMessage:string)
	print("honeydebugdebug s");
	local cannotMoveWorkDialog = PopupDialogInGame:new("CannotMoveWork");
	cannotMoveWorkDialog:ShowOkDialog(sMessage);
	print("honeydebugdebug s END");
end


function CanMoveToSlot(destBldgs:table, destBuilding:number)
	print("honeydebugdebug t");

	-- Don't allow moving artifacts if the museum is not full
	local srcGreatWorkType:number = m_GreatWorkSelected.CityBldgs:GetGreatWorkTypeFromIndex(m_GreatWorkSelected.Index);
	local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;
	if (srcGreatWorkObjectType ~= GREAT_WORK_ARTIFACT_TYPE) then
		print("honeydebugdebug t END");
	    return true;
	end

	-- Don't allow moving artifacts if the museum is not full
	local numSlots:number = destBldgs:GetNumGreatWorkSlots(destBuilding);
	--if destBuilding == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
	--	print("honeydebugdebug t artificially increasing macguffin holder slots");
	--	numSlots = 1
	--end
	for index:number = 0, numSlots - 1 do
		local greatWorkIndex:number = destBldgs:GetGreatWorkInSlot(destBuilding, index);
		if (greatWorkIndex == -1) then
			print("honeydebugdebug t END a");
			return false;
		end
	end
	print("honeydebugdebug t END b");
	return true;
end


function CanMoveGreatWork(srcBldgs:table, srcBuilding:number, srcSlot:number, dstBldgs:table, dstBuilding:number, dstSlot:number)
	print("honeydebugdebug u");

	local srcGreatWork:number = srcBldgs:GetGreatWorkInSlot(srcBuilding, srcSlot);
	local srcGreatWorkType:number = srcBldgs:GetGreatWorkTypeFromIndex(srcGreatWork);
	local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;

	local dstGreatWork:number = dstBldgs:GetGreatWorkInSlot(dstBuilding, dstSlot);
	local dstSlotType:number = dstBldgs:GetGreatWorkSlotType(dstBuilding, dstSlot);

	if dstBuilding ==GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
			dstSlotType = GameInfo.GreatWorkSlotTypes['GREATWORKSLOT_HONEY_MACGUFFIN'].Index
	end



	local dstSlotTypeString:string = GameInfo.GreatWorkSlotTypes[dstSlotType].GreatWorkSlotType;

	for row in GameInfo.GreatWork_ValidSubTypes() do
		-- Ensure source great work can be placed into destination slot
		if dstSlotTypeString == row.GreatWorkSlotType and srcGreatWorkObjectType == row.GreatWorkObjectType then
			if dstGreatWork == -1 then
				-- Artifacts can never be moved to an empty slot as
				-- they can only be swapped between other full museums
				print("honeydebugdebug u END a");
				print("honeydebugdebug great work slot type of destination "..dstSlotTypeString)
				print("honeydebugdebug great work object type? "..row.GreatWorkObjectType)
				print("honeydebugdebug artifact type "..GREAT_WORK_ARTIFACT_TYPE)

				local middleman1 = tostring( row.GreatWorkObjectType )
				local middleman2 = tostring( GREAT_WORK_ARTIFACT_TYPE )

				local thebool = not (middleman1 == middleman2)
				thebool = tostring( thebool )
				print("honeydebugdebug strings converted")
				print("honeydebugdebug u value being returned "..thebool)
				return tostring(row.GreatWorkObjectType) ~= tostring(GREAT_WORK_ARTIFACT_TYPE);
			else -- If destination slot has a great work, ensure it can be swapped to the source slot
				local srcSlotType:number = srcBldgs:GetGreatWorkSlotType(srcBuilding, srcSlot);

				if srcBuilding ==GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
					srcSlotType = GameInfo.GreatWorkSlotTypes['GREATWORKSLOT_HONEY_MACGUFFIN'].Index
				end



				local srcSlotTypeString:string = GameInfo.GreatWorkSlotTypes[srcSlotType].GreatWorkSlotType;

				local dstGreatWorkType:number = dstBldgs:GetGreatWorkTypeFromIndex(dstGreatWork);
				local dstGreatWorkObjectType:string = GameInfo.GreatWorks[dstGreatWorkType].GreatWorkObjectType;
				
				for row in GameInfo.GreatWork_ValidSubTypes() do
					if srcSlotTypeString == row.GreatWorkSlotType and dstGreatWorkObjectType == row.GreatWorkObjectType then
						print("honeydebugdebug u END b");
						return CanMoveWorkAtAll(dstBldgs, dstBuilding, dstSlot);
					end
				end
			end
		end
	end
	print("honeydebugdebug u END c");
	return false;
end



-- ===========================================================================
function MoveGreatWork( kSrcInstance:table, kDestInstance:table )
	print("honeydebugdebug v");
	if kSrcInstance ~= nil and kDestInstance ~= nil then
		-- Don't try to move the great work if it was dropped on the slot it was already in
		if kSrcInstance[DATA_FIELD_CITY_ID] == kDestInstance[DATA_FIELD_CITY_ID] and
			kSrcInstance[DATA_FIELD_BUILDING_ID] == kDestInstance[DATA_FIELD_BUILDING_ID] and
			kSrcInstance[DATA_FIELD_SLOT_INDEX] == kDestInstance[DATA_FIELD_SLOT_INDEX] then
			
			kSrcInstance.EmptySlotHighlight:SetHide(true);
			return;
		end

		-- Swap instance great work icons while we wait for the game core to update
		local sourceGreatWorkType:number = kSrcInstance[DATA_FIELD_GREAT_WORK_TYPE];
		local destGreatWorkType:number = kDestInstance[DATA_FIELD_GREAT_WORK_TYPE];
		
		if destGreatWorkType == -1 then
			kSrcInstance.GreatWorkIcon:SetHide(true);
		else
			local textureOffsetX:number, textureOffsetY:number, textureSheet:string = GetGreatWorkIcon(GameInfo.GreatWorks[destGreatWorkType]);
			kSrcInstance.GreatWorkIcon:SetHide(false);
			kSrcInstance.GreatWorkIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		end

		if sourceGreatWorkType == -1 then
			kDestInstance.GreatWorkIcon:SetHide(true);
		else
			local textureOffsetX:number, textureOffsetY:number, textureSheet:string = GetGreatWorkIcon(GameInfo.GreatWorks[sourceGreatWorkType]);
			kDestInstance.GreatWorkIcon:SetHide(false);
			kDestInstance.GreatWorkIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		end
		
		m_dest_building = kDestInstance[DATA_FIELD_BUILDING_ID];
		m_dest_city = kDestInstance[DATA_FIELD_CITY_ID];
	
		local tParameters = {};
		tParameters[PlayerOperations.PARAM_PLAYER_ONE] = Game.GetLocalPlayer();
		tParameters[PlayerOperations.PARAM_CITY_SRC] = kSrcInstance[DATA_FIELD_CITY_ID];
		print("honeydebugdebug v source city "..kSrcInstance[DATA_FIELD_CITY_ID]);
		tParameters[PlayerOperations.PARAM_CITY_DEST] = kDestInstance[DATA_FIELD_CITY_ID];
		print("honeydebugdebug v dest city "..kDestInstance[DATA_FIELD_CITY_ID]);
		tParameters[PlayerOperations.PARAM_BUILDING_SRC] = kSrcInstance[DATA_FIELD_BUILDING_ID];
		print("honeydebugdebug v source building "..kSrcInstance[DATA_FIELD_BUILDING_ID]);
		tParameters[PlayerOperations.PARAM_BUILDING_DEST] = kDestInstance[DATA_FIELD_BUILDING_ID];
		print("honeydebugdebug v dest building "..kDestInstance[DATA_FIELD_BUILDING_ID]);
		tParameters[PlayerOperations.PARAM_GREAT_WORK_INDEX] = kSrcInstance[DATA_FIELD_GREAT_WORK_INDEX];
		print("honeydebugdebug v source great work index "..kSrcInstance[DATA_FIELD_GREAT_WORK_INDEX]);
		tParameters[PlayerOperations.PARAM_SLOT] = kDestInstance[DATA_FIELD_SLOT_INDEX];
		print("honeydebugdebug v dest great slot index "..kDestInstance[DATA_FIELD_SLOT_INDEX]);
		print("honeydebugdebug v doing a ui request to move the greatwork");
		UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.MOVE_GREAT_WORK, tParameters);

		UI.PlaySound("UI_GreatWorks_Put_Down");
	end
	ContextPtr:ClearUpdate();
	print("honeydebugdebug v END");
end

-- ===========================================================================
function GetDestBuilding()
	print("honeydebugdebug w");
	print("honeydebugdebug w END");
	return m_dest_building;
end

-- ===========================================================================
function GetDestCity()
	print("honeydebugdebug x");
	print("honeydebugdebug x END");
	return m_dest_city;
end

-- ===========================================================================
function ClearGreatWorkTransfer()
	print("honeydebugdebug y");
	m_GreatWorkSelected = nil;
	m_kViableDropTargets = {};
	m_kControlToInstanceMap = {};

	for _:number, destination:table in ipairs(m_GreatWorkBuildings) do
		local instance:table = destination.Instance;
		instance.HighlightedBG:SetHide(true);
		instance.DefaultBG:SetHide(false);
		instance.DisabledBG:SetHide(true);
	end

	Controls.PlacingContainer:SetHide(true);
	Controls.HeaderStatsContainer:SetHide(false);

	ContextPtr:ClearUpdate();
	print("honeydebugdebug y END");
end

-- ===========================================================================
--	Update player data and refresh the display state
-- ===========================================================================
function UpdateData()
	print("honeydebugdebug z");
	UpdatePlayerData();
	UpdateGreatWorks();
	print("honeydebugdebug z END");
end

-- ===========================================================================
--	Show / Hide
-- ===========================================================================
function Open()
	print("honeydebugdebug 1");
	if (Game.GetLocalPlayer() == -1) then
		return
	end

	UpdateData();
	ContextPtr:SetHide(false);

	-- From Civ6_styles: FullScreenVignetteConsumer
	Controls.ScreenAnimIn:SetToBeginning();
	Controls.ScreenAnimIn:Play();
	LuaEvents.GreatWorks_OpenGreatWorks();
	print("honeydebugdebug 1 END");
end

function Close()
	print("honeydebugdebug 2");
	ContextPtr:SetHide(true);
	ContextPtr:ClearUpdate();
	print("honeydebugdebug 2 END");
end
function ViewGreatWork(greatWorkData:table)
	print("honeydebugdebug 3");
	local city:table = greatWorkData.CityBldgs:GetCity();
	local buildingID:number = greatWorkData.Building;
	local greatWorkIndex:number = greatWorkData.Index;
	LuaEvents.GreatWorksOverview_ViewGreatWork(city, buildingID, greatWorkIndex);
	print("honeydebugdebug 3 END");
end

-- ===========================================================================
--	Game Event Callbacks
-- ===========================================================================
function OnShowScreen()
	print("honeydebugdebug 4");
	if (Game.GetLocalPlayer() == -1) then
		return
	end

	Open();
	UI.PlaySound("UI_Screen_Open");
	print("honeydebugdebug 4 END");
end

-- ===========================================================================
function OnHideScreen()
	print("honeydebugdebug 5");
	if not ContextPtr:IsHidden() then
		UI.PlaySound("UI_Screen_Close");
	end

	Close();
	LuaEvents.GreatWorks_CloseGreatWorks();
	print("honeydebugdebug 5 END");
end

-- ===========================================================================
function OnInputHandler(pInputStruct:table)
	print("honeydebugdebug 6");
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then
		if m_GreatWorkSelected ~= nil then
			ClearGreatWorkTransfer();
		else
			OnHideScreen();
		end
		print("honeydebugdebug 6 END a");
		return true;
	end
	print("honeydebugdebug 6 END b");
	return false;
end

-- ===========================================================================
function OnViewGallery()
	print("honeydebugdebug 7");
	if m_FirstGreatWork ~= nil then
		ViewGreatWork(m_FirstGreatWork);
		if m_GreatWorkSelected ~= nil then
			ClearGreatWorkTransfer();
		end
        UI.PlaySound("Play_GreatWorks_Gallery_Ambience");
	end
	print("honeydebugdebug 7 END");
end

-- ===========================================================================
function OnViewGreatWork()
	print("honeydebugdebug 8");
	if m_GreatWorkSelected ~= nil then
		ViewGreatWork(m_GreatWorkSelected);
		ClearGreatWorkTransfer();
		UpdateData();
        UI.PlaySound("Play_GreatWorks_Gallery_Ambience");
	end
	print("honeydebugdebug 8 END");
end

------------------------------------------------------------------------------
-- A great work was moved.
function OnGreatWorkMoved(fromCityOwner, fromCityID, toCityOwner, toCityID, buildingID, greatWorkType)
	print("honeydebugdebug 9");
	if (not ContextPtr:IsHidden() and (fromCityOwner == Game.GetLocalPlayer() or toCityOwner == Game.GetLocalPlayer())) then
        m_during_move = true;
		UpdateData();
        m_during_move = false;
	end
	print("honeydebugdebug 9 END");
end

-- ===========================================================================
function IsDuringMove()
	print("honeydebugdebug 10");
	print("honeydebugdebug 10 END");
	return m_during_move;
end

-- ===========================================================================
--	Hot Reload Related Events
-- ===========================================================================
function OnInit(isReload:boolean)
	print("honeydebugdebug 11");
	if isReload then
		LuaEvents.GameDebug_GetValues(RELOAD_CACHE_ID);
	end
	print("honeydebugdebug 11 END");
end
function OnShutdown()
	print("honeydebugdebug 12");
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isHidden", ContextPtr:IsHidden());

	LuaEvents.GameDebug_Return.Remove(OnGameDebugReturn);
	LuaEvents.LaunchBar_OpenGreatWorksOverview.Remove(OnShowScreen);
	LuaEvents.GreatWorkCreated_OpenGreatWorksOverview.Remove(OnShowScreen);
	LuaEvents.LaunchBar_CloseGreatWorksOverview.Remove(OnHideScreen);

	Events.GreatWorkMoved.Remove(OnGreatWorkMoved);
	Events.LocalPlayerTurnBegin.Remove(OnLocalPlayerTurnBegin);
	Events.LocalPlayerTurnEnd.Remove(OnLocalPlayerTurnEnd);
	print("honeydebugdebug 12 END");
end
function OnGameDebugReturn(context:string, contextTable:table)
	print("honeydebugdebug 13");
	if context == RELOAD_CACHE_ID and contextTable["isHidden"] ~= nil and not contextTable["isHidden"] then
		Open();
	end
	print("honeydebugdebug 13 END");
end

-- ===========================================================================
--	Player Turn Events
-- ===========================================================================
function OnLocalPlayerTurnBegin()
	print("honeydebugdebug 14");
	m_isLocalPlayerTurn = true;
	print("honeydebugdebug 14 END");
end
function OnLocalPlayerTurnEnd()
	print("honeydebugdebug 15");
	m_isLocalPlayerTurn = false;
	if(GameConfiguration.IsHotseat()) then
		OnHideScreen();
	end
	print("honeydebugdebug 15 END");
end

-- ===========================================================================
--	INIT
-- ===========================================================================
function Initialize()
	print("honeydebugdebug 16");

	if (not HasCapability("CAPABILITY_GREAT_WORKS_VIEW")) then
		-- Viewing Great Works is off, just exit
		return;
	end
	
	ContextPtr:SetInitHandler(OnInit);
	ContextPtr:SetShutdown(OnShutdown);
	ContextPtr:SetInputHandler(OnInputHandler, true);

	Controls.ModalBG:SetTexture("GreatWorks_Background");
	Controls.ModalScreenTitle:SetText(Locale.ToUpper(LOC_SCREEN_TITLE));
	Controls.ModalScreenClose:RegisterCallback(Mouse.eLClick, OnHideScreen);
	Controls.ModalScreenClose:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ViewGallery:RegisterCallback(Mouse.eLClick, OnViewGallery);
	Controls.ViewGallery:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ViewGreatWork:RegisterCallback(Mouse.eLClick, OnViewGreatWork);
	Controls.ViewGreatWork:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	LuaEvents.GameDebug_Return.Add(OnGameDebugReturn);
	LuaEvents.LaunchBar_OpenGreatWorksOverview.Add(OnShowScreen);
	LuaEvents.GreatWorkCreated_OpenGreatWorksOverview.Add(OnShowScreen);
	LuaEvents.LaunchBar_CloseGreatWorksOverview.Add(OnHideScreen);

	Events.GreatWorkMoved.Add(OnGreatWorkMoved);
	Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin);
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
	print("honeydebugdebug 16 END");

end

-- This wildcard include will include all loaded files beginning with "GreatWorksOverview_"
-- This method replaces the uses of include("GreatWorksOverview") in files that want to override 
-- functions from this file. If you're implementing a new "GreatWorksOverview_" file DO NOT include this file.
--include("GreatWorksOverview_", true);

Initialize();