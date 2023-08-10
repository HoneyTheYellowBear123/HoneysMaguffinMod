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

	--print("handle customgreatworktypes was called");

	local kGreatWorkInfo:table = GameInfo.GreatWorks[greatWorkType];
	local greatWorkType:string = kGreatWorkInfo.GreatWorkType;
	local greatWorkObjectType:string = kGreatWorkInfo.GreatWorkObjectType;

	-- Only Hero great work objects should be by this override
	if ((greatWorkObjectType ~= PASSIVE_MACGUFFIN_TYPE) and (greatWorkObjectType ~= ACTIVE_MACGUFFIN_TYPE)) then
		return BASE_HandleCustomGreatWorkTypes(greatWorkType, greatWorkIndex);
	end

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
		if ((greatWorkType == "GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE") or (greatWorkType == "GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE")) then
			--Controls.CreatedBy:SetText("");
		else
			Controls.CreatedBy:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_BY", tInstInfo.CreatorName));
		end
	end

	return true;
end



function UpdateGalleryData()
	if (m_LocalPlayer == nil) then
		return;
	end

	m_GreatWorks = {};
	m_GalleryIndex = -1;
	local pCities:table = m_LocalPlayer:GetCities();
	for i, pCity in pCities:Members() do
		if pCity ~= nil and pCity:GetOwner() == m_LocalPlayerID then
			local pCityBldgs:table = pCity:GetBuildings();
			for buildingInfo in GameInfo.Buildings() do
				local buildingIndex:number = buildingInfo.Index;
				if(pCityBldgs:HasBuilding(buildingIndex)) then
					local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);

					if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
						numSlots = 1
					end


					for index:number = 0, numSlots - 1 do
						local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
						if greatWorkIndex ~= -1 then
							table.insert(m_GreatWorks, {Index=greatWorkIndex, Building=buildingIndex, City=pCity});
							if greatWorkIndex == m_GreatWorkIndex then
								m_GalleryIndex = table.count(m_GreatWorks);
							end
						end
					end
				end
			end
		end
	end

	local canCycleGreatWorks:boolean = m_GalleryIndex ~= -1 and table.count(m_GreatWorks) > 1;
	Controls.PreviousGreatWork:SetHide(not canCycleGreatWorks);
	Controls.NextGreatWork:SetHide(not canCycleGreatWorks);
end


--[[
function UpdateGreatWork()

	Controls.MusicDetails:SetHide(true);
	Controls.WritingDetails:SetHide(true);
	Controls.GreatWorkBanner:SetHide(true);
	Controls.GalleryBG:SetHide(true);

	local greatWorkInfo:table = GameInfo.GreatWorks[m_GreatWorkType];
	local greatWorkType:string = greatWorkInfo.GreatWorkType;
	local greatWorkCreator:string = Locale.Lookup(m_CityBldgs:GetCreatorNameFromIndex(m_GreatWorkIndex));
	local greatWorkCreationDate:string = Calendar.MakeDateStr(m_CityBldgs:GetTurnFromIndex(m_GreatWorkIndex), GameConfiguration.GetCalendarType(), GameConfiguration.GetGameSpeedType(), false);
	local greatWorkCreationCity:string = m_City:GetName();
	local greatWorkCreationBuilding:string = GameInfo.Buildings[m_BuildingID].Name;
	local greatWorkObjectType:string = greatWorkInfo.GreatWorkObjectType;

	local greatWorkTypeName:string;
	if greatWorkInfo.EraType ~= nil then
		greatWorkTypeName = Locale.Lookup("LOC_" .. greatWorkInfo.GreatWorkObjectType .. "_" .. greatWorkInfo.EraType);
	else
		greatWorkTypeName = Locale.Lookup("LOC_" .. greatWorkInfo.GreatWorkObjectType);
	end

	if greatWorkInfo.Audio then
		UI.PlaySound("Play_" .. greatWorkInfo.Audio );
	end

	local heightAdjustment:number = 0;
	local detailsOffset:number = DETAILS_OFFSET_DEFAULT;
	if greatWorkObjectType == GREAT_WORK_MUSIC_TYPE then
		detailsOffset = DETAILS_OFFSET_MUSIC;
		Controls.GreatWorkImage:SetOffsetY(95);
		Controls.GreatWorkImage:SetTexture(GREAT_WORK_MUSIC_TEXTURE);
		Controls.MusicName:SetText(Locale.ToUpper(Locale.Lookup(greatWorkInfo.Name)));
		Controls.MusicAuthor:SetText("-" .. greatWorkCreator);
		Controls.MusicDetails:SetHide(false);
		Controls.CreatedBy:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_BY", greatWorkCreator));
	elseif greatWorkObjectType == GREAT_WORK_WRITING_TYPE then
		detailsOffset = DETAILS_OFFSET_WRITING;
		Controls.GreatWorkImage:SetOffsetY(0);
		Controls.GreatWorkImage:SetTexture(GREAT_WORK_WRITING_TEXTURE);
		Controls.WritingName:SetText(Locale.ToUpper(Locale.Lookup(greatWorkInfo.Name)));
		local quoteKey:string = greatWorkInfo.Quote;
		if (quoteKey ~= nil) then
			Controls.WritingLine:SetHide(false);
			Controls.WritingQuote:SetText(Locale.Lookup(quoteKey));
			Controls.WritingQuote:SetHide(false);
			Controls.WritingAuthor:SetText("-" .. greatWorkCreator);
			Controls.WritingAuthor:SetHide(false);
			Controls.WritingDeco:SetHide(true);
		else
			local titleOffset:number = -45;
			Controls.WritingName:SetOffsetY(titleOffset);
			Controls.WritingLine:SetHide(true);
			Controls.WritingQuote:SetHide(true);
			Controls.WritingAuthor:SetHide(true);
			Controls.WritingDeco:SetHide(false);
			Controls.WritingDeco:SetOffsetY(Controls.WritingName:GetSizeY() + -20);
		end
		Controls.WritingDetails:SetHide(false);
		Controls.CreatedBy:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_BY", greatWorkCreator));
	elseif greatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE or greatWorkObjectType == GREAT_WORK_RELIC_TYPE then
		if greatWorkObjectType == GREAT_WORK_ARTIFACT_TYPE then
			greatWorkType = greatWorkType:gsub("GREATWORK_ARTIFACT_", "");
			local greatWorkID:number = tonumber(greatWorkType);
			greatWorkID = ((greatWorkID - 1) % NUM_ARIFACT_TEXTURES) + 1;
			Controls.GreatWorkImage:SetOffsetY(0);
			Controls.GreatWorkImage:SetTexture("ARTIFACT_" .. greatWorkID);
			Controls.GreatWorkName:SetText(Locale.ToUpper(Locale.Lookup(greatWorkInfo.Name)));
		elseif greatWorkObjectType == GREAT_WORK_RELIC_TYPE then
			greatWorkType = greatWorkType:gsub("GREATWORK_RELIC_", "");
			local greatWorkID:number = tonumber(greatWorkType);
			local icon:string = "ICON_GREATWORK_RELIC_" .. greatWorkID;
			Controls.GreatWorkImage:SetOffsetY(0);
			Controls.GreatWorkImage:SetIcon(icon, 256);
		end
		Controls.GreatWorkName:SetText(Locale.ToUpper(Locale.Lookup(greatWorkInfo.Name)));
		local nameSize:number = Controls.GreatWorkName:GetSizeX() + PADDING_BANNER;
		local bannerSize:number = math.max(nameSize, SIZE_BANNER_MIN);
		Controls.GreatWorkBanner:SetSizeX(bannerSize);
		Controls.GreatWorkBanner:SetHide(false);
		Controls.CreatedBy:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_BY", greatWorkCreator));
	else
		-- Allow DLCs and mods to handle custom great work types instead of forcing standard behavior
		if not HandleCustomGreatWorkTypes(greatWorkType, m_GreatWorkIndex) then
			local greatWorkTexture:string = greatWorkType:gsub("GREATWORK_", "");
			Controls.GreatWorkImage:SetOffsetY(-40);
			Controls.GreatWorkImage:SetTexture(greatWorkTexture);
			Controls.GreatWorkName:SetText(Locale.ToUpper(Locale.Lookup(greatWorkInfo.Name)));
			local nameSize:number = Controls.GreatWorkName:GetSizeX() + PADDING_BANNER;
			local bannerSize:number = math.max(nameSize, SIZE_BANNER_MIN);
			Controls.GreatWorkBanner:SetSizeX(bannerSize);
			Controls.GreatWorkBanner:SetHide(false);

			local imageHeight:number = Controls.GreatWorkImage:GetSizeY();
			if imageHeight > SIZE_MAX_IMAGE_HEIGHT then
				heightAdjustment = SIZE_MAX_IMAGE_HEIGHT - imageHeight;
			end

			Controls.CreatedBy:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_BY", greatWorkCreator));
		end
	end

	if greatWorkObjectType ~= PASSIVE_MACGUFFIN_TYPE and greatWorkObjectType ~= ACTIVE_MACGUFFIN_TYPE then
		Controls.CreatedDate:SetText("");
		Controls.CreatedPlace:SetText("");
	else
		Controls.CreatedDate:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_TIME", greatWorkTypeName, greatWorkCreationDate));
		Controls.CreatedPlace:SetText(Locale.Lookup("LOC_GREAT_WORKS_CREATED_PLACE", greatWorkCreationBuilding, greatWorkCreationCity));
	end


	Controls.GreatWorkHeader:SetText(m_isGallery and "" or LOC_NEW_GREAT_WORK);
	Controls.ViewGreatWorks:SetText(m_isGallery and LOC_BACK_TO_GREAT_WORKS or LOC_VIEW_GREAT_WORKS);

	-- Ensure image is repositioned in case its size changed
	if not Controls.GreatWorkImage:IsHidden() then
		Controls.GreatWorkImage:ReprocessAnchoring();
		Controls.DetailsContainer:ReprocessAnchoring();
	end

	Controls.DetailsContainer:SetOffsetY(detailsOffset + heightAdjustment);
end
--]]


print("UI showcase script was loaded");