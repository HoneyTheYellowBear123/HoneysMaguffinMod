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


-- we need a system to tie GreatWorkID (from greatworkcreated and greatworkmoved events) to the actual macguffin that it is.
-- for some reason GreatWorkID is the order that the great works were created in this specific game, as opposed to a unique index for each greatworkobject.
-- fine, whatever, we can be clever and link the order to an actual greatworkobject ourselves.
function initHoneyMacguffinIndexSystem()

	if Game:GetProperty("HoneyMacguffinIndexSystem") == nil then
		Game:SetProperty("HoneyMacguffinIndexSystem",{}); --empty table for now. The entries will be { greatworkID, greatworkobject } as great works are created.
	end
end


local tMacguffinGreatPeople = {}
--add all the macguffin great people to a list that we can quickly index
function setupMacguffinGreatPeople()

	--local tMacguffinGreatPeople = {}
	for i, tRow in ipairs(DB.Query("SELECT * from GreatPersonIndividuals WHERE GreatPersonClassType='GREAT_PERSON_HONEY_MACGUFFIN_GP'")) do -- WHERE GreatPersonClassType IN (GREAT_PERSON_HONEY_MACGUFFIN_GP)")) do
			tMacguffinGreatPeople[i] = tRow

			print("macguffin great person discovered");

			print(tRow.GreatPersonClassType);
	end
	return tMacguffinGreatPeople

end;


















--[[
function replaceMacguffinAltar(cityObject, oldBuildingID, newBuildingID)

	
	print("replacing altar function");
	local plotC = Map.GetPlot(cityObject:GetX(), cityObject:GetY());
	cityObject:GetBuildQueue():CreateIncompleteBuilding(newBuildingID, plotC:GetIndex(), 100);
	cityObject:RemoveBuilding(oldBuilding);

end



local macguffinIndex = GameInfo.GreatWorks['GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE'].Index;
local emptyMacguffinHolderIndex = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index;
	

--instantly transform a new slot
function changeAltarForNewMacguffin(playerID, unitID, cityPlotX, cityPlotY, buildingID, greatWorkID)

	print(" qbug great work created!");


	print(" nbug change altar dump, playerID: "..playerID.." unitID: "..unitID.." cityPlotX "..cityPlotX.." cityPlotY "..cityPlotY.." buildingID "..buildingID.." greatWorkID "..greatWorkID);
	print(" nbug macguffin index: "..macguffinIndex);
	print(" nbug "..emptyMacguffinHolderIndex);

	--local typel = Game.GetGreatWorkTypeFromIndex(greatWorkID);
	--print(" nbug great worktype from index"..tostring(typel));


	--local keyset={};
	--local n=0;

	--for k,v in pairs(tab) do
	--	n=n+1
	 --   keyset[n]=k
	--end

	for i in GameInfo.Buildings do
		print("nbug type of the original "..type(GameInfo.Buildings));
		print("nbug type of the entry "..type(i));
		--local buildingType = i.BuildingType; --attempt to index a function value
		print("nbug entry in buildings table "..tostring(i));
		--print("nbug i which I think is key"..(i.BuildingType));
		
	end

	print(" nbug empty macguffin index: "..emptyMacguffinHolderIndex);


	--AltarCheck();
	--local greaty = GameInfo.GreatWorks[greatWorkID];
	--print("this works: ");
	--print("printing greaty type: "..type(greaty));
	--print("printing greaty great work type: "..greaty.GreatWorkType);
	--print("printing greaty name : "..greaty.Name);
	--print("new great work was created and change altar was called. The great work ID is "..greatWorkID);
	--local theCity = Cities.GetCityInPlot(cityPlotX, cityPlotY);
	--if buildingObject:GetNumGreatWorkSlots(buildingID) == 1 and  buildingObject:GetGreatWorkSlotType(i) == artifactSlot then

	--end


	--theCity:GetBuildings().GetGreatWorkInSlot(buildingID, 0);
	--local greatWorkData = Game.GetGreatWorkDataFromIndex(greatWorkID);
	--local greatWorkString = greatWorkData.name;
	--local macguffinStringCheck = strsub(greatWorkString, 25, 15);
	--print(macguffinStringCheck);
	--if macguffinStringCheck == "HONEY_MACGUFFIN" then
	--	print("we detected a new macguffin being created!");


	--	local nameWithoutGreatWork = strsub(greatWorkString, 25);
	--	print(nameWithoutGreatWork);
	--	local altarWeExpect = "BUILDING_HONEY_MACGUFFIN_HOLDER"..nameWithoutGreatkWork;
	--	print(altarWeExpect);
		
	--	local indexWeExpect =  GameInfo.Buildings[altarWeExpect].Index;
	--	replaceMacguffinAltar(       buildingID, indexWeExpect);

	--end



end


local artifactSlot = GameInfo.GreatWorkSlotTypes["GREATWORKSLOT_ARTIFACT"].Index;


-- check if any altars have had their macguffins shifted, and if so, update them.
function AltarCheck() --fromCityPlayerID, fromCityID, toCityPlayerID, toCityID, buildingID, greatWorkTypeIndex
	print("altar check was called!");
	for playerid, playerobject in pairs(Players) do

		if playerobject:IsMajor() then
			
			
			--playerCityMembers = playerobject:GetCities()
			for i, cityObject in playerobject:GetCities():Members() do--playerCityMembers:Members() do
			
    
			 local cityBuildings = cityObject:GetBuildings();

			 print("city buildings type: "..type(cityBuildings));

			 local size1 = 0
			 for i,v in pairs(cityBuildings) do size1 = size1 + 1 end
			 print("size of first table is ::" , size1)

			-- local buildingNameOverride = cityBuildings:GetBuildingNameOverride(0);
			 --print("building name override: "..buildingNameOverride);
			-- local typeNameO = cityBuildings:GetType();
			 --print("typenameo: "..type(typeNameO));
			 --local greatWorkIndo= cityBuildings:GetGreatWorkInSlot(0,0);
			 --local greatWorkIndo2 = cityBuildings:GetGreatWorkInSlot(1,0);

			 
			 for buildingObject in cityBuildings do
				
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
--]]

function GreatPersonActivatedCheck(unitPlayerID, unitID, greatPersonClassID, greatPersonIndividualID, a, b, c, d)

	print(" qbug great person activated!");
	print(" qbug index of the macguffin great person "..DebugGreatPerson);
	print(" qbug ndividual id from the great person activated function! "..greatPersonIndividualID);
	--print(" qbug also d! "..d);



	for i, trow in ipairs(tMacguffinGreatPeople) do
		print(" right before the check: "..trow.GreatPersonClassType);

		if  GameInfo.GreatPersonIndividuals[tostring(trow.GreatPersonIndividualType)].Index ==  greatPersonIndividualID then
			print("the following great macguffin person was activated: "..trow.Name);
			local stringTransform = string.sub(trow.GreatPersonIndividualType, 14) --cut off the GREAT_PERSON_ part of the string
			stringTransform = string.sub(stringTransform, 0, -4) --cut of the _GP part at the end
			print("string transform: "..stringTransform);

		end
	end


end

function testo(playerID, unitID, cityPlotX, cityPlotY, buildingID, greatWorkID)

	print(" qbug great work created!");
end

function presto(fromCityPlayerID, fromCityID, toCityPlayerID, toCityID, buildingID, greatWorkTypeIndex)

	print("presto dump fromcityplayerid "..fromCityPlayerID.." fromcityid "..fromCityID.." tocityplayerid "..toCityPlayerID.." tocityid "..toCityID.." buildingID "..buildingID.." greatworktypeindex "..greatWorkTypeIndex);

end







initHoneyMacguffinIndexSystem();
setupMacguffinGreatPeople();


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
--Events.GreatWorkCreated.Add(changeAltarForNewMacguffin)
Events.GreatWorkCreated.Add(testo)
Events.GreatWorkMoved.Add(presto)
Events.UnitGreatPersonActivated.Add(GreatPersonActivatedCheck)
--Events.GreatWorkMoved.Add(AltarCheck)
Events.CityInitialized.Add(grantDebugGreatPerson)