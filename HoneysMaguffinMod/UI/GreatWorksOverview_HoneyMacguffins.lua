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
	
	--print("get great work tool tip was called");

	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];

	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE" then
		--print("danger point 1");
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end
	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE" then
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end

	return BASE_GetGreatWorkTooltip(pCityBldgs, greatWorkIndex, greatWorkType, pBuildingInfo);
end

function GetGreatWorkIcon(greatWorkInfo:table)

	--print("Get Great Work Icon was called");

	local greatWorkIcon:string;

	if greatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE" then
		local greatWorkType:string = greatWorkInfo.GreatWorkType;
		--greatWorkType = greatWorkType:gsub("GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_", "");
		--local greatWorkTrunc:string = greatWorkType:sub(1, #greatWorkType - 2);	-- remove the _1/_2/_3/_4/_5 from the end
		--greatWorkIcon =  "ICON_GREATWORKOBJECT_ARTIFACT_ERA_ANCIENT";  --TO DO: replace this with proper naming convention                       --"ICON_MONOPOLIES_AND_CORPS_RESOURCE_" .. greatWorkTrunc;
		greatWorkIcon = "ICON_" .. greatWorkInfo.GreatWorkType; 

		--print("great work icon "..greatWorkIcon);

		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(greatWorkIcon, SIZE_GREAT_WORK_ICON);
		if(textureSheet == nil or textureSheet == "") then
			--print("danger point 2");
			UI.DataError("Could not find slot type icon in GetGreatWorkIcon: icon=\""..greatWorkIcon.."\", iconSize="..tostring(SIZE_GREAT_WORK_ICON));
		end

		return textureOffsetX, textureOffsetY, textureSheet;
	end

	return BASE_GetGreatWorkIcon(greatWorkInfo);
end






--THIS FUNCTION IS CRUCIAL IF YOU ARE ADDING NEW GREAT WORK SLOT TYPES AND THEY SAY THAT IN THE CODE BUT ITS SO SMALL
function GetGreatWorkSlotTypeIcon(slotType:string)

	--print("honeydebug2 get great works slot type icon was called");

	for v1, v2 in pairs(g_DEFAULT_GREAT_WORKS_ICONS) do
		--print("showingtable"..tostring(v1).."   "..tostring(v2));
	end

	--print("honeydebug2 made it past the table which will return "..g_DEFAULT_GREAT_WORKS_ICONS[slotType].." because of "..slotType);
	
	
	return g_DEFAULT_GREAT_WORKS_ICONS[slotType];
end



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









--taken care of by expansion 2 
--[[
function PopulateGreatWorkSlot(instance:table, pCity:table, pCityBldgs:table, pBuildingInfo:table)

	--print("PopulateGreatWorkSlot was called");
	if (pBuildingInfo.BuildyingType ~= 'BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY') then
		BASE_PopulateGreatWorkSlot(instance,pCity,pCityBlgs,pBuildingInfo)
	end
	--print("PopulateGreatWorkSlot thinks this building is a macguffin holder!");

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

		--print("HoneyDebug a");
		if firstGreatWork ~= nil and themeDescription ~= nil then
			--print("HoneyDebug b");
			local slotTypeIcon:string = "ICON_" .. firstGreatWork.GreatWorkObjectType;
			--print("HoneyDebug "..slotTypeIcon);
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

	--print("HoneyDebug c");
	return numGreatWorks;
end
--]]

print("UI overview script was loaded");

--Initialize();