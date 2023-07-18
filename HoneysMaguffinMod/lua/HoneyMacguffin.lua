-- HoneyMacguffin
-- Author: HoneyTheBear
-- DateCreated: 6/28/2023 11:23:29 PM
--------------------------------------------------------------



--give player0 (human) a great person for debugging
local DebugGreatPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_HONEY_MACGUFFIN_GP"].Index;
local DebugGreatPerson = GameInfo.GreatPersonIndividuals["GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_GP"].Index;
local DebugGreatPerson2 = GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_BHASA"].Index;
local richesBuildingIndex = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index


--TO DO: macguffin awakening could be performed via optional technology that changes the pseudobuilding list. We can worry about this later.


local macguffinEra = GameInfo.Eras["HONEY_MACGUFFIN_DUMMY_ERA"].Index;
local justMe = true;
--local rememberMeBuilding = ""

function grantDebugGreatPerson(playerID, cityID, x, y)

	print("playerID "..playerID)
	print("cityID "..cityID)
	print("plot x "..x)
	print("plot y "..y)

	if (justMe) then
		--Game.GetGreatPeople:GrantPerson(DebugGreatPerson, DebugGreatPersonClass,macguffinEra,0,playerID,false);
		Game.GetGreatPeople():CreatePerson(playerID, DebugGreatPerson, x, y);
		Game.GetGreatPeople():CreatePerson(playerID, DebugGreatPerson2, x, y);

		capital = Players[playerID]:GetCities():GetCapitalCity();
		if capital ~= nil then
			if capital:GetBuildings():HasBuilding(richesBuildingIndex) ~= true then
				local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
				capital:GetBuildQueue():CreateIncompleteBuilding(richesBuildingIndex, plotCapital:GetIndex(), 100);
				capital:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
				capital:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
				capital:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);
				capital:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
				capital:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
				capital:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);
			end
		end
		justMe = false;
	end

	local rememberMeBuilding = CityManager.GetCity( playerID, CityID )
	local thename = rememberMeBuilding:GetName()
	


	local playerCityMembers = Players[playerID]:GetCities()
	for i, cityObject in playerCityMembers:Members() do
		print("the name of the city "..cityObject:GetName());
		local plotC = Map.GetPlot(cityObject:GetX(), cityObject:GetY());
		--tyObject:GetBuildQueue():CreateIncompleteBuilding(richesBuildingIndex, plotC:GetIndex(), 100);
		cityObject:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
		cityObject:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
		--cityObject:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);
		cityObject:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
		cityObject:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
		--cityObject:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);
	end

	

end


-- we need a system to tie GreatWorkID (from greatworkcreated and greatworkmoved events) to the actual macguffin that it is.
-- for some reason GreatWorkID is the order that the great works were created in this specific game, as opposed to a unique index for each greatworkobject.
-- fine, whatever, we can be clever and link the order to an actual greatworkobject ourselves.
function initHoneyMacguffinIndexSystem()

	if Game:GetProperty("HoneyMacguffinIndexSystem") == nil then                                    --{      1                     2                            3                            4                                         5             }
		Game:SetProperty("HoneyMacguffinIndexSystem",{}); --empty table for now. The entries will be { greatworkID, greatworkobjecttypename, buildingIndexThatItIsCurrentlyIn, TypeNameOfTheBonusPseudoBuildingItGrants, cityIndexThatItIsCUrrentlyIn } as great works are created.
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



function placeMacguffinAltar(cityObject, newBuildingID)

	print("replacing altar function");
	local plotC = Map.GetPlot(cityObject:GetX(), cityObject:GetY());
	cityObject:GetBuildQueue():CreateIncompleteBuilding(newBuildingID, plotC:GetIndex(), 100); --create the new one and destroy the old one. 

end


local macguffinThatWasJustMade = ""
local macguffinWasMade = false

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
			stringTransform = string.sub(stringTransform, 0, -4) --cut off the _GP part at the end
			stringTransform = "GREATWORK_GREATWORKOBJECT_"..stringTransform;

			macguffinThatWasJustMade = stringTransform --to be used by great work created
			macguffinWasMade = true

			print("string transform: "..stringTransform);

		end
	end

end

function GreatWorkCreatedCheck(playerID, unitID, cityPlotX, cityPlotY, buildingID, greatWorkID)

	if macguffinWasMade then --great person activated will always activate before this function, we can use that info to determine if this should be run.
	   
		local MacguffinindexTable = Game:GetProperty("HoneyMacguffinIndexSystem")
		local stringTransform = string.sub(macguffinThatWasJustMade,43) --cut off the GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_
		stringTransform = "BUILDING_HONEY_MACGUFFIN_HOLDER_"..stringTransform

		local macguffinCity = CityManager.GetCityAt(cityPlotX, cityPlotY):GetID() --CityManager.GetCity( playerID, CityID )
		
		--all active macguffins should use the same building TO DO: maybe a different building for each tier?
		if string.match(stringTransform,"ACTIVE") then
			stringTransform = "BUILDING_HONEY_MACGUFFIN_ACTIVE_MACGUFFIN"
		end
		    

		table.insert(MacguffinindexTable , {macguffinThatWasJustMade, greatWorkID, buildingID, stringTransform, macguffinCity}) --track each individual macguffin and what building it is currently located in, its associated bonus building, and what city it is currently located in for convenient access later.
		
		local trex = {macguffinThatWasJustMade, greatWorkID, buildingID, stringTransform, macguffinCity}
		print("tableinfo "..trex[1])
		print("tableinfo "..trex[2])
		print("tableinfo "..trex[3])
		print("tableinfo "..trex[4])
		print("tableinfo "..trex[5])
		Game:SetProperty("HoneyMacguffinIndexSystem",MacguffinindexTable)
		print("The great work ID "..greatWorkID.." is now associated with the macguffin "..macguffinThatWasJustMade)

		--if this was created INTO an empty altar we should grant the pseudobuilding in that city
		if buildingID == GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index then

			print("we will try to make the building "..stringTransform)
			local buildingToMake = GameInfo.Buildings[stringTransform].Index 
			local cityToEdit = CityManager.GetCityAt(cityPlotX, cityPlotY)

			placeMacguffinAltar(cityToEdit, buildingToMake)
		end
		macguffinWasMade = false --don't do any of this logic again until the next macguffin is created.
	end

	print(" qbug great work created!");
end

--in the case of a swap this should be called twice and it should be fine TO DO get this working
function GreatWorkMovedCheck(fromCityPlayerID, fromCityID, toCityPlayerID, toCityID, buildingID, greatWorkTypeIndex)

	for i, MacguffinEntry in ipairs(Game:GetProperty("HoneyMacguffinIndexSystem")) do
		print("macguffin entry! if you see three rework the temp table system!")

		--the great work that just moved was previously registered as a macguffin
		if MacguffinEntry[2] == greatWorkTypeIndex then

			local tempTable = Game:GetProperty("HoneyMacguffinIndexSystem")
			local tempMacguffinEntry = MacguffinEntry
			local fromCityObject = CityManager.GetCity( fromCityPlayerID, fromCityID )
			local toCityObject = CityManager.GetCity( toCityPlayerID, toCityID )
			local associatedAltarIndex = GameInfo.Buildings[MacguffinEntry[4]].Index

			--if the building the macguffin was moved FROM was an altar (as opposed to palace, storage, or museum) we should destroy the pseudobuilding in the city it was moved from
			if MacguffinEntry[3] == GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index then

				print("we removed a macguffin from an altar!");
				fromCityObject:GetBuildings():RemoveBuilding(associatedAltarIndex);
				fromCityObject:GetBuildQueue():RemoveBuilding(associatedAltarIndex);

			end
			--fi the building the macguffin is moved TO is an altar, we should create the pseudo building in the city it was moved to
			if buildingID == GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index then

				print("macguffin entry 4: "..MacguffinEntry[4])
				placeMacguffinAltar(toCityObject, associatedAltarIndex)

			end

			-- update the table so we know our macguffin is in a new building
			tempMacguffinEntry[3] = buildingID
			tempMacguffinEntry[5] = toCityID

			print("macguffin moved 3 "..buildingID)
			print("macguffin moved 5 "..toCityID)

			tempTable[i] = tempMacguffinEntry
			

			Game:SetProperty("HoneyMacguffinIndexSystem", tempTable)
		end
	end

end




local tier1totier2project = GameInfo.Projects["PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2"].Index
local tier2totier3project = GameInfo.Projects["PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3"].Index
local tier1totier2building = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2"].Index
local tier2totier3building = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3"].Index

--to do: add a check to make sure the macguffins inside are the correct tier before moving them up
function MacguffinImprove(playerID, cityID, projectID, buildingIndex, x, y, isCancelled)

	if (not isCancelled) and (projectID == tier1totier2project) then
		for i, MacguffinEntry in ipairs(Game:GetProperty("HoneyMacguffinIndexSystem")) do
			if MacguffinEntry[5] == cityID and MacguffinEntry[3] == tier1totier2building and (not string.match(MacguffinEntry[1],"TIER2")) and (not string.match(MacguffinEntry[1],"TIER3")) then

				local CityObject = CityManager.GetCity( fromCityPlayerID, fromCityID )
				CityObject:GetBuildings():RemoveBuilding(tier1totier2building);
				CityObject:GetBuildQueue():RemoveBuilding(tier1totier2building);
				
				local stringTransform = string.sub(MacguffinEntry[1],43) --cut off the GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_
				stringTransform = "GREAT_PERSON_HONEY_MACGUFFIN_"..stringTransform.."_TIER2_GP"
				local tier2GreatPerson = GameInfo.GreatPersonIndividuals[stringTransform].Index;

				Game.GetGreatPeople():CreatePerson(playerID, tier2GreatPerson, CityObject:GetX(), CityObject:GetY());
				
				local tempTable = Game:GetProperty("HoneyMacguffinIndexSystem")
				tempTable[i] = tempMacguffinEntry
				MacguffinEntry[3] = GameInfo.Buildings["BUILDING_HANGAR"].Index --some building that we know will never house a macguffin.
				Game:SetProperty("HoneyMacguffinIndexSystem", tempTable)
				--change entry buildingID to something impossible so we never consider this macguffin again.
			
			end 		
		end
	end


	if (not isCancelled) and (projectID == tier2totier3project) then
		
		for i, MacguffinEntry in ipairs(Game:GetProperty("HoneyMacguffinIndexSystem")) do

			if MacguffinEntry[5] == cityID and MacguffinEntry[3] == tier2totier3building and string.match(MacguffinEntry[1],"TIER2") then

				local CityObject = CityManager.GetCity( fromCityPlayerID, fromCityID )
				CityObject:GetBuildings():RemoveBuilding(tier2totier3building);
				CityObject:GetBuildQueue():RemoveBuilding(tier2totier3building);
				
				local stringTransform = string.sub(MacguffinEntry[1],43) --cut off the GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_
				local stringTransform = string.sub(stringTransform,0,-6) --cut off the _TIER2
				stringTransform = "GREAT_PERSON_HONEY_MACGUFFIN_"..stringTransform.."TIER3_GP"

				local tier3GreatPerson = GameInfo.GreatPersonIndividuals[stringTransform].Index;
				Game.GetGreatPeople():CreatePerson(playerID, tier3GreatPerson, CityObject:GetX(), CityObject:GetY());
				
				local tempTable = Game:GetProperty("HoneyMacguffinIndexSystem")
				tempTable[i] = tempMacguffinEntry
				MacguffinEntry[3] = GameInfo.Buildings["BUILDING_HANGAR"].Index --some building that we know will never house a macguffin.
				Game:SetProperty("HoneyMacguffinIndexSystem", tempTable)
				--change entry buildingID to something impossible so we never consider this macguffin again.
			
			end 		
		end
	end


end





















initHoneyMacguffinIndexSystem();
setupMacguffinGreatPeople();




--function getThoseBuildingsGone()
--	rememberMeBuilding:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
--	rememberMeBuilding:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
--	rememberMeBuilding:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);
--	rememberMeBuilding:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
--	rememberMeBuilding:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
--	rememberMeBuilding:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);

--end

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

Events.GreatWorkCreated.Add(GreatWorkCreatedCheck)
Events.GreatWorkMoved.Add(GreatWorkMovedCheck)
Events.UnitGreatPersonActivated.Add(GreatPersonActivatedCheck)
Events.CityProjectCompleted.Add(MacguffinImprove)


--new plan: delete the shrine with turn end by looping through players


--to do: delete debug code
Events.CityInitialized.Add(grantDebugGreatPerson)
--Events.TurnEnd.Add(getThoseBuildingsGone)