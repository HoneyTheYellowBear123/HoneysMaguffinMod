-- HoneyMacguffin
-- Author: HoneyTheBear
-- DateCreated: 6/28/2023 11:23:29 PM
--------------------------------------------------------------



--give player0 (human) a great person for debugging
local DebugGreatPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_HONEY_MACGUFFIN_GP"].Index;
local DebugGreatPerson = GameInfo.GreatPersonIndividuals["GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP"].Index;
local DebugGreatPerson2 = GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_BHASA"].Index;


local macguffinEra = GameInfo.Eras["HONEY_MACGUFFIN_DUMMY_ERA"].Index;
local justMe = true;

function grantDebugGreatPerson(playerID, cityID, x, y)

	if (justMe) then
		--Game.GetGreatPeople:GrantPerson(DebugGreatPerson, DebugGreatPersonClass,macguffinEra,0,playerID,false);
		Game.GetGreatPeople():CreatePerson(playerID, DebugGreatPerson, x, y);
		Game.GetGreatPeople():CreatePerson(playerID, DebugGreatPerson2, x, y);

		--capital = Players[playerID]:GetCities():GetCapitalCity();
		--if capital ~= nil then
		--	if capital:GetBuildings():HasBuilding(richesBuildingIndex) ~= true then
		--		local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
		--		capital:GetBuildQueue():CreateIncompleteBuilding(richesBuildingIndex, plotCapital:GetIndex(), 100);
		--	end
		--end
		justMe = false;
	end

end




function replaceMacguffinAltar(cityObject, oldBuildingID, newBuildingID)

	
	print("replacing altar function");
	local plotC = Map.GetPlot(cityObject:GetX(), cityObject:GetY());
	cityObject:GetBuildQueue():CreateIncompleteBuilding(newBuildingID, plotC:GetIndex(), 100);
	cityObject:RemoveBuilding(oldBuilding);

end

--instantly transform a new slot
function changeAltarForNewMacguffin(playerID, unitID, cityPlotX, cityPlotY, buildingID, greatWorkID)


	print("new great work was created and change altar was called. The great work ID is "..greatWorkID);
	local greatWorkData = Game.GetGreatWorkDataFromIndex(greatWorkID);
	local greatWorkString = greatWorkData.name;
	local macguffinStringCheck = strsub(greatWorkString, 25, 15);
	print(macguffinStringCheck);
	if macguffinStringCheck == "HONEY_MACGUFFIN" then
		print("we detected a new macguffin being created!");


		local nameWithoutGreatWork = strsub(greatWorkString, 25);
		print(nameWithoutGreatWork);
		local altarWeExpect = "BUILDING_HONEY_MACGUFFIN_HOLDER"..nameWithoutGreatkWork;
		print(altarWeExpect);
		local theCity = Cities.GetCityInPlot(cityPlotX, cityPlotY);
		local indexWeExpect =  GameInfo.Buildings[altarWeExpect].Index;
		replaceMacguffinAltar(       buildingID, indexWeExpect);

	end



end


local artifactSlot = GameInfo.GreatWorkSlotTypes["GREATWORKSLOT_ARTIFACT"].Index;
local emptyMacguffinHolderIndex = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index;

-- check if any altars have had their macguffins shifted, and if so, update them.
function AltarCheck(fromCityPlayerID, fromCityID, toCityPlayerID, toCityID, buildingID, greatWorkTypeIndex)
	for playerid, playerobject in pairs(Players) do

		if playerobject:IsMajor() then
			


			for i, cityObject in playerCityMembers:Members() do
			
    
			 local cityBuildings = cityObject:GetBuildings();
			 
			 for i, buildingObject in cityBuildings do
				
				--surely a macguffin altar of sorts
				if buildingObject:GetNumGreatWorkSlots(i) == 1 and  buildingObject:GetGreatWorkSlotType(i) == artifactSlot then

					local greatWorkIndex = cityBuildings:GetGreatWorkInSlot(i,0)

					-- -1 for empty slot, we want empty altar
					if greatWorkIndex == -1 then
						
						--if the city does NOT have an empty altar, whatever building we are looking at right now should be destroyed and replaced with an empty altar.
						if not cityBuildings:HasBuilding( emptyMacguffinHolderIndex ) then
							print("replacing empty altar");
							replaceMacguffinAltar(cityObject, i, emptyMacguffinHolderIndex);
						end

					else

						--if the city does NOT have the correct altar for the macguffin we detected, whatever building we are looking at right now should be destroyed and replaced with the proper macguffin altar.
						local greatWorkData = Game.GetGreatWorkDataFromIndex(greatWorkIndex);
						local greatWorkString = greatWorkData.name;
						--GreatWorkObjectType if name doesnt work

						local nameWithoutGreatWork = strsub(greatWorkString, 25);
						print(nameWithoutGreatWork);
						local altarWeExpect = "BUILDING_HONEY_MACGUFFIN_HOLDER"..nameWithoutGreatkWork;

						print(altarWeExpect);

						local indexWeExpect =  GameInfo.Buildings[altarWeExpect].Index;

						if not cityBuildings:HasBuilding( indexWeExpect ) then
							print("replacing special altar");
							replaceMacguffinAltar(cityObject, i, indexWeExpect);
						end

					end

					
					--check the artifact type and building type

				end

			 end
			 
		  end

		end
	end
end






--[[ event
CityProjectCompleted	
	playerID
	cityID
	projectID
	buildingIndex
	x
	y
	isCancelled
--]]
Events.GreatWorkCreated.Add(changeAltarForNewMacguffin);
Events.GreatWorkMoved.Add(AltarCheck)
Events.CityInitialized.Add(grantDebugGreatPerson)