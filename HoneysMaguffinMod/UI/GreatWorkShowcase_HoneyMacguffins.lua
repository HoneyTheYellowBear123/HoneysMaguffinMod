-- Copyright 2020, Firaxis Games

-- This file is being included into the base GreatWorkShowcase file using the wildcard include setup in GreatWorkShowcase.lua
-- Refer to the bottom of GreatWorkShowcase.lua to see how that's happening
-- DO NOT include any GreatWorkShowcase files here or it will cause problems

-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
local BASE_HandleCustomGreatWorkTypes = HandleCustomGreatWorkTypes;

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

local PASSIVE_MACGUFFIN_TYPE:string = "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE";
local ACTIVE_MACGUFFIN_TYPE:string = "GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE";

local PADDING_BANNER:number = 120;
local SIZE_BANNER_MIN:number = 506;

-- ===========================================================================
function HandleCustomGreatWorkTypes( greatWorkType:string, greatWorkIndex:number )

	print("handle customgreatworktypes was called");

	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];
	local greatWorkType:string = kGreatWorkInfo.GreatWorkType;
	local greatWorkObjectType:string = kGreatWorkInfo.GreatWorkObjectType;

	-- Only Hero great work objects should be by this override
	--if ((greatWorkObjectType ~= PASSIVE_MACGUFFIN_TYPE) and (greatWorkObjectType ~= ACTIVE_MACGUFFIN_TYPE)) then
	--	return BASE_HandleCustomGreatWorkTypes(greatWorkType);
	--end

	local icon:string = "ICON_" .. greatWorkType;
	Controls.GreatWorkImage:SetOffsetY(0);
	Controls.GreatWorkImage:SetIcon(icon, 256);

	Controls.GreatWorkName:SetText(Locale.ToUpper(kGreatWorkInfo.Name));
	local nameSize:number = Controls.GreatWorkName:GetSizeX() + PADDING_BANNER;
	local bannerSize:number = math.max(nameSize, SIZE_BANNER_MIN);
	Controls.GreatWorkBanner:SetSizeX(bannerSize);
	Controls.GreatWorkBanner:SetHide(false);

	--to do: I think if the input to this function is "" we won't have a created by name on our artifacts
	local tInstInfo:table = Game.GetGreatWorkDataFromIndex(greatWorkIndex);
	if (tInstInfo ~= nil) then
		Controls.CreatedBy:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_BY", tInstInfo.CreatorName));
	end

	return true;
end

print("UI showcase script was loaded");