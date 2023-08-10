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
function UpdateGreatWorks()
	
	m_FirstGreatWork = nil;
	m_GreatWorkSelected = nil;
	m_GreatWorkSlotsIM:ResetInstances();
	Controls.PlacingContainer:SetHide(true);
	Controls.HeaderStatsContainer:SetHide(false);

	if (m_LocalPlayer == nil) then
		return;
	end

	m_GreatWorkYields = {};
	m_GreatWorkBuildings = {};
	local numGreatWorks:number = 0;
	local numDisplaySpaces:number = 0;

	local pCities:table = m_LocalPlayer:GetCities();
	for i, pCity in pCities:Members() do
		if pCity ~= nil and pCity:GetOwner() == m_LocalPlayerID then
			local pCityBldgs:table = pCity:GetBuildings();
			for buildingInfo in GameInfo.Buildings() do
				local buildingIndex:number = buildingInfo.Index;
				local buildingType:string = buildingInfo.BuildingType;
				if(pCityBldgs:HasBuilding(buildingIndex)) then
					local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);

					if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
						numSlots = 1
					end


					if (numSlots ~= nil and numSlots > 0) then
						local instance:table = m_GreatWorkSlotsIM:GetInstance();
						local greatWorks:number = PopulateGreatWorkSlot(instance, pCity, pCityBldgs, buildingInfo);
						table.insert(m_GreatWorkBuildings, {Instance=instance, Type=buildingType, Index=buildingIndex, CityBldgs=pCityBldgs});
						numDisplaySpaces = numDisplaySpaces + pCityBldgs:GetNumGreatWorkSlots(buildingIndex);
						if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
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
end






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


function GetFirstGreatWorkInBuilding(pCityBldgs:table, pBuildingInfo:table)
	local index:number = 0;
	local buildingIndex:number = pBuildingInfo.Index;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);

	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		numSlots = 1
	end


	for _:number=0, numSlots - 1 do
		local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
		if greatWorkIndex ~= -1 then
			return greatWorkIndex;
		end
		index = index + 1;
	end
	return -1;
end


function GetGreatWorksInBuilding(pCityBldgs:table, pBuildingInfo:table)
	local index:number = 0;
	local results:table = {};
	local buildingIndex:number = pBuildingInfo.Index;
	local numSlots:number = pCityBldgs:GetNumGreatWorkSlots(buildingIndex);

	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		numSlots = 1
	end

	for _:number=0, numSlots - 1 do
		local greatWorkIndex:number = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index);
		if greatWorkIndex ~= -1 then
			table.insert(results, greatWorkIndex);
		end
		index = index + 1;
	end
	return results;
end





function OnClickGreatWork(kDragStruct:table, pCityBldgs:table, buildingIndex:number, greatWorkIndex:number, slotIndex:number)

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
		local firstValidSlot:number = -1;
		local instance:table = destination.Instance;
		local dstBuilding:number = destination.Index;
		local dstBldgs:table = destination.CityBldgs;
		local slotCache:table = instance[DATA_FIELD_SLOT_CACHE];
		local numSlots:number = dstBldgs:GetNumGreatWorkSlots(dstBuilding);

		if dstBuilding == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
			numSlots = 1
		end


		for index:number = 0, numSlots - 1 do
			if CanMoveGreatWork(pCityBldgs, buildingIndex, slotIndex, dstBldgs, dstBuilding, index) then
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
end



function IsBuildingFull( pBuildings:table, buildingIndex:number )
	local numSlots:number = pBuildings:GetNumGreatWorkSlots(buildingIndex);

	if buildingIndex == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		numSlots = 1
	end


	for index:number = 0, numSlots - 1 do
		local greatWorkIndex:number = pBuildings:GetGreatWorkInSlot(buildingIndex, index);
		if (greatWorkIndex == -1) then
			return false;
		end
	end

	return true;
end



function CanMoveToSlot(destBldgs:table, destBuilding:number)

	-- Don't allow moving artifacts if the museum is not full
	local srcGreatWorkType:number = m_GreatWorkSelected.CityBldgs:GetGreatWorkTypeFromIndex(m_GreatWorkSelected.Index);
	local srcGreatWorkObjectType:string = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType;
	if (srcGreatWorkObjectType ~= GREAT_WORK_ARTIFACT_TYPE) then
	    return true;
	end

	-- Don't allow moving artifacts if the museum is not full
	local numSlots:number = destBldgs:GetNumGreatWorkSlots(destBuilding);

	if destBuilding == GameInfo.Buildings['BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'].Index then
		numSlots = 1
	end

	for index:number = 0, numSlots - 1 do
		local greatWorkIndex:number = destBldgs:GetGreatWorkInSlot(destBuilding, index);
		if (greatWorkIndex == -1) then
			return false;
		end
	end

	return true;
end


print("UI showcase script was loaded");

