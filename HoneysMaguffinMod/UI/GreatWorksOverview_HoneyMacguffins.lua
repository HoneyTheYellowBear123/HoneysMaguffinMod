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
local BASE_Initialize = Initialize;

-- ===========================================================================
function GetGreatWorkTooltip(pCityBldgs:table, greatWorkIndex:number, greatWorkType:number, pBuildingInfo:table)
	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];

	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "HONEY_MACGUFFIN_PASSIVE" then
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end
	-- Return the basic tooltip for Hero relics because the theming code in the base game can cause errors with them
	if kGreatWorkInfo.GreatWorkObjectType == "HONEY_MACGUFFIN_ACTIVE" then
		return GreatWorksSupport_GetBasicTooltip( greatWorkIndex, false );
	end

	return BASE_GetGreatWorkTooltip(pCityBldgs, greatWorkIndex, greatWorkType, pBuildingInfo);
end

function GetGreatWorkIcon(greatWorkInfo:table)

	local greatWorkIcon:string;

	if greatWorkInfo.GreatWorkObjectType == "GREATWORKOBJECT_PRODUCT" then
		local greatWorkType:string = greatWorkInfo.GreatWorkType;
		greatWorkType = greatWorkType:gsub("GREATWORK_PRODUCT_", "");
		local greatWorkTrunc:string = greatWorkType:sub(1, #greatWorkType - 2);	-- remove the _1/_2/_3/_4/_5 from the end
		greatWorkIcon = "ICON_MONOPOLIES_AND_CORPS_RESOURCE_" .. greatWorkTrunc;

		local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(greatWorkIcon, SIZE_GREAT_WORK_ICON);
		if(textureSheet == nil or textureSheet == "") then
			UI.DataError("Could not find slot type icon in GetGreatWorkIcon: icon=\""..greatWorkIcon.."\", iconSize="..tostring(SIZE_GREAT_WORK_ICON));
		end

		return textureOffsetX, textureOffsetY, textureSheet;
	end

	return BASE_GetGreatWorkIcon(greatWorkInfo);
end

Initialize();