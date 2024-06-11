-- GreatWorksOverview_HoneyMacguffins
-- Author: HoneyTheBear
-- DateCreated: 6/29/2023 3:42:38 PM
--------------------------------------------------------------


-- Stolen from the babylon pack code because it seemed simpler than the monopoly mode

-- Copyright 2020, Firaxis Games

-- This file is being included into the base GreatWorksOverview file using the wildcard include setup in GreatWorksOverview.lua
-- Refer to the bottom of GreatWorksOverview.lua to see how that's happening
-- DO NOT include any GreatWorksOverview files here or it will cause problems
-- include("GreatWorksOverview");

g_DEFAULT_GREAT_WORKS_ICONS["GREATWORKSLOT_HONEY_MACGUFFIN"] = "ICON_GREATWORKOBJECT_ARTIFACT_ERA_ANCIENT"; --TO DO: replace this right side of this

local SIZE_GREAT_WORK_ICON:number = 64;

-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
local BASE_GetGreatWorkTooltip = GetGreatWorkTooltip;
local BASE_GetGreatWorkIcon = GetGreatWorkIcon;
local BASE_PopulateGreatWorkSlot = PopulateGreatWorkSlot
local BASE_Initialize = Initialize;


-- ===========================================================================


--TO DO edit this to show the different tiers of macguffins
function GetGreatWorkTooltip(pCityBldgs:table, greatWorkIndex:number, greatWorkType:number, pBuildingInfo:table)
	
	----print("get great work tool tip was called");

	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];

	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE" then
		----print("danger point 1");
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end
	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE" then
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end

	return BASE_GetGreatWorkTooltip(pCityBldgs, greatWorkIndex, greatWorkType, pBuildingInfo);
end

function GetGreatWorkIcon(greatWorkInfo:table)

	----print("Get Great Work Icon was called");

	local greatWorkIcon:string;

	if greatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE" then
		local greatWorkType:string = greatWorkInfo.GreatWorkType;
		--greatWorkType = greatWorkType:gsub("GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_", "");
		--local greatWorkTrunc:string = greatWorkType:sub(1, #greatWorkType - 2);	-- remove the _1/_2/_3/_4/_5 from the end
		--greatWorkIcon =  "ICON_GREATWORKOBJECT_ARTIFACT_ERA_ANCIENT";  --TO DO: replace this with proper naming convention                       --"ICON_MONOPOLIES_AND_CORPS_RESOURCE_" .. greatWorkTrunc;
		greatWorkIcon = "ICON_" .. greatWorkInfo.GreatWorkType; 

		----print("great work icon "..greatWorkIcon);

		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(greatWorkIcon, SIZE_GREAT_WORK_ICON);
		if(textureSheet == nil or textureSheet == "") then
			----print("danger point 2");
			UI.DataError("Could not find slot type icon in GetGreatWorkIcon: icon=\""..greatWorkIcon.."\", iconSize="..tostring(SIZE_GREAT_WORK_ICON));
		end

		return textureOffsetX, textureOffsetY, textureSheet;
	end

	return BASE_GetGreatWorkIcon(greatWorkInfo);
end






--THIS FUNCTION IS CRUCIAL IF YOU ARE ADDING NEW GREAT WORK SLOT TYPES AND THEY SAY THAT IN THE CODE BUT ITS SO SMALL
--function GetGreatWorkSlotTypeIcon(slotType:string)

	----print("honeydebug2 get great works slot type icon was called");

--	for v1, v2 in pairs(g_DEFAULT_GREAT_WORKS_ICONS) do
		----print("showingtable"..tostring(v1).."   "..tostring(v2));
--	end

	----print("honeydebug2 made it past the table which will return "..g_DEFAULT_GREAT_WORKS_ICONS[slotType].." because of "..slotType);
	
	
--	return g_DEFAULT_GREAT_WORKS_ICONS[slotType];
--end



function CanMoveGreatWork(srcBldgs:table, srcBuilding:number, srcSlot:number, dstBldgs:table, dstBuilding:number, dstSlot:number)

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
				return row.GreatWorkObjectType ~= GREAT_WORK_ARTIFACT_TYPE;
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
						return CanMoveWorkAtAll(dstBldgs, dstBuilding, dstSlot);
					end
				end
			end
		end
	end
	return false;
end


function GetThemeDescription(buildingType:string)
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
					return Locale.Lookup(row.ThemingBonusDescription);
				end		
			end
		end
	end
	return nil;
end


function UpdatePlayerData()
	--print("honeydebugdebug 0");
	m_LocalPlayerID = Game.GetLocalPlayer();
	if m_LocalPlayerID ~= -1 then
		m_LocalPlayer = Players[m_LocalPlayerID];
	end
	--print("honeydebugdebug 0 END");
end



function PopulateGreatWorkSlot(instance:table, pCity:table, pCityBldgs:table, pBuildingInfo:table)
	
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

	--print("HoneyDebug Q PopulateGreatWorkSlot BuildingType "..buildingType)
	--print("HoneyDebug Q PopulateGreatWorkSlot numslots before artificial increase "..numSlots)
	if (buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index ) then
		numSlots = 1
	end

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

			if (buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index ) then
				greatWorkSlotType = GameInfo.GreatWorkSlotTypes['GREATWORKSLOT_HONEY_MACGUFFIN'].Index
			end



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

	return numGreatWorks;
end


--TO DO edit this to show the different tiers of macguffins
function GetGreatWorkTooltip(pCityBldgs:table, greatWorkIndex:number, greatWorkType:number, pBuildingInfo:table)
	
	----print("get great work tool tip was called");

	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];

	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE" then
		----print("danger point 1");
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end
	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE" then
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end

	return BASE_GetGreatWorkTooltip(pCityBldgs, greatWorkIndex, greatWorkType, pBuildingInfo);
end





--THIS FUNCTION IS CRUCIAL IF YOU ARE ADDING NEW GREAT WORK SLOT TYPES AND THEY SAY THAT IN THE CODE BUT ITS SO SMALL
function GetGreatWorkSlotTypeIcon(slotType:string)
	
	return g_DEFAULT_GREAT_WORKS_ICONS[slotType];
end




function megaCheck()

	local index = 1
	for building in GameInfo.Buildings() do

		for buildinggreatworkslots in GameInfo.Building_GreatWorks() do

			if building.BuildingType == buildinggreatworkslots.BuildingType then

				--print("Honeydebug wow BuildingType "..building.BuildingType)
				--print("Honeydebug wow Slottype "..buildinggreatworkslots.GreatWorkSlotType)
				--print("Honeydebug wow number of slots "..buildinggreatworkslots.NumSlots)

			end

		end

	end

end


function UpdateGreatWorks()

	--megaCheck()
	
	--print("honeydebugdebug a1");
	m_FirstGreatWork = nil;
	--print("honeydebugdebug a2");
	m_GreatWorkSelected = nil;
	--print("honeydebugdebug a3");
	m_GreatWorkSlotsIM:ResetInstances();
	--print("honeydebugdebug a4");
	Controls.PlacingContainer:SetHide(true);
	--print("honeydebugdebug a5");
	Controls.HeaderStatsContainer:SetHide(false);
	--print("honeydebugdebug a6");

	if (m_LocalPlayer == nil) then
		return;
	end
	--print("honeydebugdebug a7");

	m_GreatWorkYields = {};
	m_GreatWorkBuildings = {};
	local numGreatWorks:number = 0;
	local numDisplaySpaces:number = 0;

	--print("honeydebugdebug a8");

	local pCities:table = m_LocalPlayer:GetCities();
	for i, pCity in pCities:Members() do
		if pCity ~= nil and pCity:GetOwner() == m_LocalPlayerID then
			local pCityBldgs:table = pCity:GetBuildings();
			for buildingInfo in GameInfo.Buildings() do
				--print("honeydebugdebug a9");
				local buildingIndex:number = buildingInfo.Index;
				local buildingType:string = buildingInfo.BuildingType;
				if(pCityBldgs:HasBuilding(buildingIndex)) then

					--print("honeydebugdebug a building found");
					--print("honeydebugdebug a building is "..Locale.ToUpper(Locale.Lookup(buildingInfo.Name)));

					--IMPORTANT working theory is that get numgreatworkslots does not work, may possibly be hardcoded. Its possible that there may be modifiers that it looks for that could be abused.
					local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
					--print("honeydebugdebug a greatworkslot returned is "..numSlots);

					if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
						--print("honeydebugdebug a artificially increasing macguffin holder slots");
						numSlots = 1
					end

					if (numSlots ~= nil and numSlots > 0) then
						--print("honeydebugdebug a AT LEAST ONE GREAT WORK SLOT FOUND");
						local instance:table = m_GreatWorkSlotsIM:GetInstance();
						local greatWorks:number = PopulateGreatWorkSlot(instance, pCity, pCityBldgs, buildingInfo);
						table.insert(m_GreatWorkBuildings, {Instance=instance, Type=buildingType, Index=buildingIndex, CityBldgs=pCityBldgs});
						numDisplaySpaces = numDisplaySpaces + pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
						if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
							--print("honeydebugdebug a artificially increasing macguffin holder slots a second time");
							numDisplaySpaces = numDisplaySpaces + 1
						end
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
	--print("honeydebugdebug a END");
end

function PopulateGreatWorkSlot(instance:table, pCity:table, pCityBldgs:table, pBuildingInfo:table)

	--print("honeydebugdebug b");
	
	instance.DefaultBG:SetHide(false);
	instance.DisabledBG:SetHide(true);
	instance.HighlightedBG:SetHide(true);

	local buildingType:string = pBuildingInfo.BuildingType;
	local buildingIndex:number = pBuildingInfo.Index;
	local themeDescription = GetThemeDescription(buildingType);
	instance.CityName:SetText(Locale.Lookup(pCity:GetName()));
	instance.BuildingName:SetText(Locale.ToUpper(Locale.Lookup(pBuildingInfo.Name)));
	--print("honeydebugdebug b building is"..Locale.ToUpper(Locale.Lookup(pBuildingInfo.Name)));

	-- Ensure we have Instance Managers for the great works
	--print("honeydebugdebug b problem?");
	local greatWorkIM:table = instance[DATA_FIELD_GREAT_WORK_IM];
	--print("honeydebugdebug b problem!");
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
	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		--print("honeydebugdebug b artificially increasing macguffin holder slots");
		numSlots = 1
	end

	if (numSlots ~= nil and numSlots > 0) then
		--print("honeydebugdebug b looping through slots");
		for _:number=0, numSlots - 1 do
			--print("honeydebugdebug b slot loop started");
			local instance:table = greatWorkIM:GetInstance();
			local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
			--print("honeydebugdebug b great work index "..greatWorkIndex);

			--IMPORTANT GetGreatWorkSlotType also does not work
			local greatWorkSlotType:number = pCityBldgs:GetGreatWorkSlotType(buildingIndex, index);

			
			if buildingIndex ==GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
				greatWorkSlotType = GameInfo.GreatWorkSlotTypes['GREATWORKSLOT_HONEY_MACGUFFIN'].Index
			end


			--print("honeydebugdebug b slottypenumber "..greatWorkSlotType);
			local greatWorkSlotString:string = GameInfo.GreatWorkSlotTypes[greatWorkSlotType].GreatWorkSlotType;



			--print("honeydebugdebug b slotstring "..greatWorkSlotString);

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

		if firstGreatWork ~= nil and themeDescription ~= nil then
			local slotTypeIcon:string = "ICON_" .. firstGreatWork.GreatWorkObjectType;
			if firstGreatWork.GreatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE then
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
		--print("honeydebugdebug b there is at least one great work here");
		if themeDescription ~= nil then
			instance.ThemingLabel:SetText(Locale.Lookup("LOC_GREAT_WORKS_THEME_BONUS_PROGRESS", numThemedGreatWorks, numSlots));
			instance.ThemingLabel:SetToolTipString(themeDescription);
		end
	else
		instance.ThemingLabel:SetText("");
		instance.ThemingLabel:SetToolTipString("");
		if pCityBldgs:IsBuildingThemedCorrectly(buildingIndex) then
			instance.ThemingLabel:SetText(LOC_THEME_BONUS);
			if m_during_move then
				if buildingIndex == m_dest_building then
                    if (m_dest_city == pCityBldgs:GetCity():GetID()) then
                        UI.PlaySound("UI_GREAT_WORKS_BONUS_ACHIEVED");
                    end
				end
			end
		else
			if themeDescription ~= nil then
                -- if we're being called due to moving a work
				if numSlots > 1 then
					instance.ThemingLabel:SetText(Locale.Lookup("LOC_GREAT_WORKS_THEME_BONUS_PROGRESS", numThemedGreatWorks, numSlots));
					if m_during_move then
						if buildingIndex == m_dest_building then
                            if (m_dest_city == pCityBldgs:GetCity():GetID()) then
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

	--print("honeydebugdebug b END");
	return numGreatWorks;
end


function GetFirstGreatWorkInBuilding(pCityBldgs:table, pBuildingInfo:table)
	--print("honeydebugdebug l");
	local index:number = 0;
	local buildingIndex:number = pBuildingInfo.Index;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		--print("honeydebugdebug l artificially increasing macguffin holder slots");
		numSlots = 1
	end
	for _:number=0, numSlots - 1 do
		local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
		if greatWorkIndex ~= -1 then
			--print("honeydebugdebug l END a");
			return greatWorkIndex;
		end
		index = index + 1;
	end
	--print("honeydebugdebug l END b");
	return -1;
end


function GetGreatWorksInBuilding(pCityBldgs:table, pBuildingInfo:table)	
	--print("honeydebugdebug m");
	local index:number = 0;
	local results:table = {};
	local buildingIndex:number = pBuildingInfo.Index;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		--print("honeydebugdebug m artificially increasing macguffin holder slots");
		numSlots = 1
	end
	for _:number=0, numSlots - 1 do
		local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
		if greatWorkIndex ~= -1 then
			table.insert(results, greatWorkIndex);
		end
		index = index + 1;
	end
	--print("honeydebugdebug m END");
	return results;
end


function OnClickGreatWork(kDragStruct:table, pCityBldgs:table, buildingIndex:number, greatWorkIndex:number, slotIndex:number)
	--print("honeydebugdebug p");

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
		--print("honeydebugdebug p==========================================================================================================================")
		local firstValidSlot:number = -1;
		local instance:table = destination.Instance;
		local dstBuilding:number = destination.Index;
		local dstBldgs:table = destination.CityBldgs;
		local slotCache:table = instance[DATA_FIELD_SLOT_CACHE];
		local numSlots:number = dstBldgs:GetNumGreatWorkSlots(dstBuilding);
		--print("honeydebugdebug p looping great work destination buildings! this building index is "..dstBuilding);
		--print("honeydebugdebug p looping macguffin holder index is "..GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index);
		if dstBuilding == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
			--print("honeydebugdebug p artificially increasing macguffin holder slots");
			numSlots = 1
		end
		for index:number = 0, numSlots - 1 do
			if CanMoveGreatWork(pCityBldgs, buildingIndex, slotIndex, dstBldgs, dstBuilding, index) then -- u
				--print("honeydebugdebug p we can move to the destination building");
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
	--print("honeydebugdebug p END");
end


function CanMoveWorkAtAll(srcBldgs:table, srcBuilding:number, srcSlot:number)
	--print("honeydebugdebug q");
	local srcGreatWork:number = srcBldgs:GetGreatWorkInSlot(srcBuilding, srcSlot);
	local srcGreatWorkType:number = srcBldgs:GetGreatWorkTypeFromIndex(srcGreatWork);
	local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;

	-- Don't allow moving artifacts if the museum is not full
	if (srcGreatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE) then
		if not IsBuildingFull(srcBldgs, srcBuilding) then
			--print("honeydebugdebug q END a");
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
			--print("honeydebugdebug q END b");
			return false;
		end
	end

	--print("honeydebugdebug q END c");
	return true;
end


function IsBuildingFull( pBuildings:table, buildingIndex:number )
	--print("honeydebugdebug r");
	local numSlots:number = pBuildings:GetNumGreatWorkSlots(buildingIndex);
	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		--print("honeydebugdebug r artificially increasing macguffin holder slots");
		numSlots = 1
	end
	for index:number = 0, numSlots - 1 do
		local greatWorkIndex:number = pBuildings:GetGreatWorkInSlot(buildingIndex, index);
		if (greatWorkIndex == -1) then
			--print("honeydebugdebug r END");
			return false;
		end
	end
	--print("honeydebugdebug r END");
	return true;
end


function CanMoveToSlot(destBldgs:table, destBuilding:number)
	--print("honeydebugdebug t");

	-- Don't allow moving artifacts if the museum is not full
	local srcGreatWorkType:number = m_GreatWorkSelected.CityBldgs:GetGreatWorkTypeFromIndex(m_GreatWorkSelected.Index);
	local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;
	if (srcGreatWorkObjectType ~= GREAT_WORK_ARTIFACT_TYPE) then
		--print("honeydebugdebug t END");
	    return true;
	end

	-- Don't allow moving artifacts if the museum is not full
	local numSlots:number = destBldgs:GetNumGreatWorkSlots(destBuilding);
	if destBuilding == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		--print("honeydebugdebug t artificially increasing macguffin holder slots");
		numSlots = 1
	end
	for index:number = 0, numSlots - 1 do
		local greatWorkIndex:number = destBldgs:GetGreatWorkInSlot(destBuilding, index);
		if (greatWorkIndex == -1) then
			--print("honeydebugdebug t END a");
			return false;
		end
	end
	--print("honeydebugdebug t END b");
	return true;
end


function CanMoveGreatWork(srcBldgs:table, srcBuilding:number, srcSlot:number, dstBldgs:table, dstBuilding:number, dstSlot:number)
	--print("honeydebugdebug u");

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
				--print("honeydebugdebug u END a");
				--print("honeydebugdebug great work slot type of destination "..dstSlotTypeString)
				--print("honeydebugdebug great work object type? "..row.GreatWorkObjectType)
				--print("honeydebugdebug artifact type "..GREAT_WORK_ARTIFACT_TYPE)

				local middleman1 = tostring( row.GreatWorkObjectType )
				local middleman2 = tostring( GREAT_WORK_ARTIFACT_TYPE )

				local thebool = not (middleman1 == middleman2)
				thebool = tostring( thebool )
				--print("honeydebugdebug strings converted")
				--print("honeydebugdebug u value being returned "..thebool)
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
						--print("honeydebugdebug u END b");
						return CanMoveWorkAtAll(dstBldgs, dstBuilding, dstSlot);
					end
				end
			end
		end
	end
	--print("honeydebugdebug u END c");
	return false;
end




--taken care of by expansion 2 
--[[
function PopulateGreatWorkSlot(instance:table, pCity:table, pCityBldgs:table, pBuildingInfo:table)

	----print("PopulateGreatWorkSlot was called");
	if (pBuildingInfo.BuildyingType ~= 'BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY') then
		BASE_PopulateGreatWorkSlot(instance,pCity,pCityBlgs,pBuildingInfo)
	end
	----print("PopulateGreatWorkSlot thinks this building is a macguffin holder!");

	instance.DefaultBG:SetHide(false);
	instance.DisabledBG:SetHide(true);
	instance.HighlightedBG:SetHide(true);

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

	if (numSlots ~= nil and numSlots > 0) then
		for _:number=0, numSlots - 1 do
			local instance:table = greatWorkIM:GetInstance();
			local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
			local greatWorkSlotType:number = pCityBldgs:GetGreatWorkSlotType(buildingIndex, index);
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

		----print("HoneyDebug a");
		if firstGreatWork ~= nil and themeDescription ~= nil then
			----print("HoneyDebug b");
			local slotTypeIcon:string = "ICON_" .. firstGreatWork.GreatWorkObjectType;
			----print("HoneyDebug "..slotTypeIcon);
			if firstGreatWork.GreatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE then
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
			if m_during_move then
				if buildingIndex == m_dest_building then
                    if (m_dest_city == pCityBldgs:GetCity():GetID()) then
                        UI.PlaySound("UI_GREAT_WORKS_BONUS_ACHIEVED");
                    end
				end
			end
		else
			if themeDescription ~= nil then
                -- if we're being called due to moving a work
				if numSlots > 1 then
					instance.ThemingLabel:SetText(Locale.Lookup("LOC_GREAT_WORKS_THEME_BONUS_PROGRESS", numThemedGreatWorks, numSlots));
					if m_during_move then
						if buildingIndex == m_dest_building then
                            if (m_dest_city == pCityBldgs:GetCity():GetID()) then
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

	----print("HoneyDebug c");
	return numGreatWorks;
end
--]]

--print("UI overview script was loaded");

--Initialize();