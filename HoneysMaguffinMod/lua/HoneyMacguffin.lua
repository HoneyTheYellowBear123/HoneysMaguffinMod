-- HoneyMacguffin
-- Author: HoneyTheBear
-- DateCreated: 6/28/2023 11:23:29 PM
--------------------------------------------------------------



--give player0 (human) a great person for debugging
local DebugGreatPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_HONEY_MACGUFFIN_GP"].Index;
local DebugGreatPerson = GameInfo.GreatPersonIndividuals["GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT_GP"].Index;
local DebugGreatPerson2 = GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_BHASA"].Index;
local altarBuildingIndex = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index


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
			if capital:GetBuildings():HasBuilding(altarBuildingIndex) ~= true then
				local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
				capital:GetBuildQueue():CreateIncompleteBuilding(altarBuildingIndex, plotCapital:GetIndex(), 100);
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
		--tyObject:GetBuildQueue():CreateIncompleteBuilding(altarBuildingIndex, plotC:GetIndex(), 100);
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

	if Game:GetProperty("HoneyMacguffinIndexSystem") == nil then                                    --{      1                     2                            3                            4                                         5                                  6                         7                          8      }
		Game:SetProperty("HoneyMacguffinIndexSystem",{}); --empty table for now. The entries will be { greatworkID, greatworkobjecttypename, buildingIndexThatItIsCurrentlyIn, TypeNameOfTheBonusPseudoBuildingItGrants, cityObjectThatItIsCUrrentlyIn,         activeMacguffinCooldown,     activeMacguffinProjectID,   ownerPlayerID} as great works are created.
	end

	--debt system to allow macguffin trading of active macguffins without allowing collusion or scamming
	if Game:GetProperty("HoneyMacguffinCooldownDebtSystem") == nil then                                    --{      1          2             3           )
		Game:SetProperty("HoneyMacguffinCooldownDebtSystem",{}); --empty table for now. The entries will be { greatworkID,	playerID,  remainingCooldown }
	end

	--each player will have a global cooldown that slowly increases with each macguffin activation so activating slowly becomes more "expensive" via extended cooldowns
	if Game:GetProperty("HoneyMacguffinGlobalCooldownSystem") == nil then                                  
		
		local cooldownTable = {}

		for playerid, playerobject in pairs(Players) do

			if playerobject:IsMajor() then

				cooldownTable[playerid] = 0

			end
		end

		Game:SetProperty("HoneyMacguffinGlobalCooldownSystem",cooldownTable)
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
		local projectIndex = -2

		if string.match(stringTransform, "ACTIVE") then
			local projectname1 = "PROJECT_HONEY_MACGUFFIN_"..stringTransform
			print("projectname1 "..projectname1)
			projectIndex = GameInfo.Projects["PROJECT_HONEY_MACGUFFIN_"..stringTransform].Index
		end


		stringTransform = "BUILDING_HONEY_MACGUFFIN_HOLDER_"..stringTransform

		local macguffinCity = CityManager.GetCityAt(cityPlotX, cityPlotY):GetID() --CityManager.GetCity( playerID, CityID )
		    

		table.insert(MacguffinindexTable , {macguffinThatWasJustMade, greatWorkID, buildingID, stringTransform, macguffinCity, 0, projectIndex, playerID}) --track each individual macguffin and what building it is currently located in, its associated bonus building, and what city it is currently located in for convenient access later.
		
		local trex = {macguffinThatWasJustMade, greatWorkID, buildingID, stringTransform, macguffinCity, 0, projectIndex, playerID}
		print("tableinfo "..trex[1])
		print("tableinfo "..trex[2])
		print("tableinfo "..trex[3])
		print("tableinfo "..trex[4])
		print("tableinfo "..trex[5])
		print("tableinfo "..trex[6])
		print("tableinfo "..trex[7])
		print("tableinfo "..trex[8])
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
				local sName = fromCityObject:GetName()
				fromCityObject:SetName(sName) --forces UI update!

			end
			--fi the building the macguffin is moved TO is an altar, we should create the pseudo building in the city it was moved to
			if buildingID == GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index then

				print("macguffin entry 4: "..MacguffinEntry[4])
				placeMacguffinAltar(toCityObject, associatedAltarIndex)

			end

			-- update the table so we know our macguffin is in a new building
			tempMacguffinEntry[3] = buildingID
			tempMacguffinEntry[5] = toCityID
			tempMacguffinEntry[8] = toCityPlayerID

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



--#####################################################################################################################
----------------------------------------------------- ACTIVE MACGUFFINS ---------------------------------------------
--#####################################################################################################################

include("HoneyMacguffinProjects");

local tActiveMacguffinProjects = {}

function setupActiveMacguffinProjects()


	for i, tRow in ipairs(DB.Query("SELECT * from Projects WHERE ProjectType LIKE 'HONEY_MACGUFFIN_ACTIVE'")) do 
			 tActiveMacguffinProjects[i] = tRow

			print("active macguffin project was discovered");

			print(tRow.ProjectType);
	end
	return tActiveMacguffinProjects

end;


local coolDownAltarIndex = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_COOLDOWN"].Index
local globalCoolDownIncrease = 3 --TO DO make this configurable

function ActivateActiveMacguffin(playerID, cityID, projectID, buildingIndex, x, y, isCancelled)

	
	if (not isCancelled) then
		for i, MacguffinEntry in ipairs(Game:GetProperty("HoneyMacguffinIndexSystem")) do

			if projectID == MacguffinEntry[7] then --an active macguffin project was completed!

				local tempglobalcooldowntable = Game:GetProperty("HoneyMacguffinGlobalCooldownSystem")
				local globalcooldownValue = tempglobalcooldowntable[playerID]
				
				local projectCooldown = grantHoneyMacguffinActiveEffect(MacguffinEntry[7], playerID, x, y)
				
				local associatedAltarIndex = GameInfo.Buildings[MacguffinEntry[4]].Index
				local CityObject = CityManager.GetCity( playerID, cityID )
				CityObject:GetBuildings():RemoveBuilding(associatedAltarIndex);
				CityObject:GetBuildQueue():RemoveBuilding(associatedAltarIndex);
				
				--CityObject:GetX(), CityObject:GetY()

				placeMacguffinAltar(CityObject, coolDownAltarIndex)
				

				MacguffinEntry[6] = projectCooldown + globalcooldownValue
				MacguffinEntry[4] = coolDownAltarIndex
				tempglobalcooldowntable[playerID] = globalcooldownValue + globalCoolDownIncrease
				
				Game:SetProperty("HoneyMacguffinGlobalCooldownSystem",  tempglobalcooldowntable)

				local tempindexsystem= Game:GetProperty("HoneyMacguffinIndexSystem")
				tempindexsystem[i] = MacguffinEntry
				Game:SetProperty("HoneyMacguffinIndexSystem", tempindexsystem)

			end
		end
	end

end



--function that loops through every city at the beggining of the turn to see if it has the cooldown building, if so reduce the cooldown by one. If cooldown is zero, replace the building and change MacguffinEntry[4].
function reduceHoneyMacguffinCooldown()

	local temptable = {}
	for i, MacguffinEntry in ipairs(Game:GetProperty("HoneyMacguffinIndexSystem")) do

		

		if (not( MacguffinEntry[6] == 0 )) then

			MacguffinEntry[6] = MacguffinEntry[6] - 1
			print("cooldown turns left "..MacguffinEntry[6])
			if MacguffinEntry[6] == 0 then

				local CityObject = CityManager.GetCity( MacguffinEntry[8], MacguffinEntry[5]  )

				CityObject :GetBuildings():RemoveBuilding(MacguffinEntry[4])
				CityObject :GetBuildQueue():RemoveBuilding(MacguffinEntry[4])
				
				local stringTransform = string.sub(MacguffinEntry[1],43)  --cut off the GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_
				stringTransform = "BUILDING_HONEY_MACGUFFIN_HOLDER_"..stringTransform
				local altarIndex = GameInfo.Buildings[stringTransform].Index
				placeMacguffinAltar(CityObject , altarIndex )
				
				MacguffinEntry[4] = stringTransform

			end
		end

		temptable[i] = MacguffinEntry

	end

	Game:SetProperty("HoneyMacguffinIndexSystem",temptable)

end
















function grantHoneyMacguffinActiveEffect(projectID, playerID, x, y) --grant each reward and return associated number of cooldown
	--efficiency can increase if I check the name and split it up as much as possible

	print("HoneyDebug active grant effect was called")

	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT'].Index then
	print("HoneyDebug active we did the first builder thing")
		return free_builder_reward(playerID, 1, x, y)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT_TIER2'].Index then
		return free_builder_reward(playerID, 2, x, y)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT_TIER3'].Index then
		return free_builder_reward(playerID, 3, x, y)
	end
	
	

	print("placeholder XD")
	return 1
end


-------------------------------------------------------------------------------------------------------
------------------------------------------ REWARD FUNCTIONS ------------------------------------------
-------------------------------------------------------------------------------------------------------

-- all functions apply some reward and return the BASE cooldown for that macguffin.




function free_builder_reward(playerid, tier, x, y)

	print("HoneyDebug active free builder reward was called")

	--builderID = GameInfo.Units['UNIT_BUILDER'].Index;
	
	--Players[playerid]:GetUnits():Create(UnitID, x , y)
	--UnitManager.InitUnit(playerid, builderID, x, y);

	if tier == 1 then
		return 30
	end
	if tier == 2 then
		return 15
	end
	if tier == 3 then
		return 6
	end
end









--#####################################################################################################################
----------------------------------------------  END ACTIVE MACGUFFINS --------------------------------------
--#####################################################################################################################



--#####################################################################################################################
----------------------------------------------------- GRANTING GREAT PEOPLE ---------------------------------------------
--#####################################################################################################################

--To Do set up config and great people after all the macguffins have been added
--To Do I could check the start era and grant different tiers of great people in later eras if I really feel like it
--To Do I could add an option so only human players get macguffins (or only AI players ooooooo spicy)

function initAvailableHoneyMacguffinGreatPeople()

	if Game:GetProperty("AvailableHoneyMacguffinGreatPeople") == nil then                                 
		Game:SetProperty("AvailableHoneyMacguffinGreatPeople",{});
		local tempTable = {}
		local i=1

		print("DEBUG4 init available called!")
		if GameConfiguration.GetValue('CONFIG_HONEY_MACGUFFIN_PASSIVE_FLAT_YIELD') then

			tempTable[i] = 'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP'
			i = i + 1
			tempTable[i] = 'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_CULTURE_GP'
			i = i + 1
			tempTable[i] = 'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_GOLD_GP'
			i = i + 1
			tempTable[i] = 'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_FAITH_GP'
			i = i + 1
			tempTable[i] = 'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_FOOD_GP'
			i = i + 1
			tempTable[i] = 'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_PRODUCTION_GP'
			i = i + 1

		end

		Game:SetProperty("AvailableHoneyMacguffinGreatPeople",tempTable);
	end

end


--grant a random macguffin. Call this in a different function after some criteria has been fufilled.
function grantMacguffinGreatPerson(playerID)

	print("DEBUG4 grant macguffin great person called!")
	if not ( Game:GetProperty("AvailableHoneyMacguffinGreatPeople")[1] == "all out :(") then

		print("DEBUG4 we have great people to grant")
		local xspot =  Players[playerID]:GetCities():GetCapitalCity():GetPlot():GetX();
		local yspot =  Players[playerID]:GetCities():GetCapitalCity():GetPlot():GetY();

		local temptable = Game:GetProperty("AvailableHoneyMacguffinGreatPeople")

		local count = 0
		for _ in pairs(temptable) do
			count = count + 1
		end


		math.randomseed(os.time())
		math.random(); math.random(); math.random()
		local randomIndex = math.random(1,count)
		local randomMacguffinGreatPerson = temptable[randomIndex] --GameInfo.GreatPersonIndividuals[temptable[randomIndex]].Index

		print("DEBUG4 x: "..xspot)
		print("DEBUG4 y: "..yspot)
		print("DEBUG4 playerID: "..playerID)
		print("DEBUG4 randomIndex: "..randomIndex)
		print("DEBUG4 macguffingreatperson: "..temptable[1])

		Game.GetGreatPeople():CreatePerson(playerID, randomMacguffinGreatPerson, xspot, yspot);

		if count > 1 then
			table.remove(temptable,randomIndex)
		else
			print("DEBUG4 we are all out of great people to grant now")
			temptable[1] = "all out :("
		end

		Game:SetProperty("AvailableHoneyMacguffinGreatPeople", temptable)
	end
end

function grantPantheonMacguffin(playerID)
	grantMacguffinGreatPerson(playerID)
end
function grantPolPhilMacguffin(playerID, civicIndex, isCancelled)
	if civicIndex == GameInfo.Civics['CIVIC_POLITICAL_PHILOSOPHY'].Index then
		grantMacguffinGreatPerson(playerID)
	end
end
function grantEnlightenmentMacguffin(playerID, civicIndex, isCancelled)
	if civicIndex == GameInfo.Civics['CIVIC_THE_ENLIGHTENMENT'].Index then
		grantMacguffinGreatPerson(playerID)
	end
end
function grantEnviornmentalismMacguffin(playerID, civicIndex, isCancelled)
	if civicIndex == GameInfo.Civics['CIVIC_ENVIRONMENTALISM'].Index then
		grantMacguffinGreatPerson(playerID)
	end
end
function grantAstronomyMacguffin(playerID, technologyIndex)
	if technologyIndex == GameInfo.Civics['TECH_ASTRONOMY'].Index then
		grantMacguffinGreatPerson(playerID)
	end
end
function grantAstronomyMacguffin(playerID, technologyIndex)
	if technologyIndex == GameInfo.Technologies['TECH_ASTRONOMY'].Index then
		grantMacguffinGreatPerson(playerID)
	end
end
--function grantWonderMacguffin(x, y, buildingIndex, playerIndex, cityID, percentComplete, unknown)
	
	--just the first one


--end


function initMacguffinGrantingFunctions()

	print("DEBUG4 setting up macguffin granting functions")
	if GameConfiguration.GetValue('CONFIG_HONEY_MACGUFFIN_GRANT_ON_PANTHEON') then
		Events.PantheonFounded.Add(grantPantheonMacguffin) --only happens once!
	end

	--Events.DiplomacyRelationshipChanged --friendship or alliance would be cool
	if GameConfiguration.GetValue('CONFIG_HONEY_MACGUFFIN_GRANT_ON_POLITICAL_PHILOSOPHY') then
		Events.CivicCompleted.Add(grantPolPhilMacguffin) 
	end 
	if GameConfiguration.GetValue('CONFIG_HONEY_MACGUFFIN_GRANT_ON_ENLIGHTENMENT') then
		Events.CivicCompleted.Add(grantPolPhilMacguffin) 
	end 
	if GameConfiguration.GetValue('CCONFIG_HONEY_MACGUFFIN_GRANT_ON_ENVIORNMENTALISM') then
		Events.CivicCompleted.Add(grantPolPhilMacguffin) 
	end 
	if GameConfiguration.GetValue('CONFIG_HONEY_MACGUFFIN_GRANT_ON_ASTRONOMY') then
		Events.ResearchCompleted.Add(grantAstronomyMacguffin) 
	end 
	
	--Events.ReligionFounded --eh

	--to do: come back to these other ones
	--if GameConfiguration.GetValue('CONFIG_HONEY_MACGUFFIN_GRANT_ON_WONDER_COMPLETED') then
	--	Events.ResearchCompleted.Add(grantAstronomyMacguffin) 
	--end 
	--Events.WonderCompleted --probably just first wonder
	--GameEvents.CityBuilt --build x number of cities, probably also first city
	--GameEvents.UnitAddedToMap --for flight and boats
end


--#####################################################################################################################
----------------------------------------------------- END GRANTING GREAT PEOPLE ---------------------------------------------
--#####################################################################################################################


















--function getThoseBuildingsGone()
--	rememberMeBuilding:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
--	rememberMeBuilding:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
--	rememberMeBuilding:GetBuildQueue():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);
--	rememberMeBuilding:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_WALLS"].Index);
--	rememberMeBuilding:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_CASTLE"].Index);
--	rememberMeBuilding:GetBuildings():RemoveBuilding(GameInfo.Buildings["BUILDING_STAR_FORT"].Index);

--end


initMacguffinGrantingFunctions()
initAvailableHoneyMacguffinGreatPeople();
initHoneyMacguffinIndexSystem();
setupMacguffinGreatPeople();
setupActiveMacguffinProjects();



Events.GreatWorkCreated.Add(GreatWorkCreatedCheck)
Events.GreatWorkMoved.Add(GreatWorkMovedCheck)
Events.UnitGreatPersonActivated.Add(GreatPersonActivatedCheck)
Events.CityProjectCompleted.Add(MacguffinImprove)
Events.CityProjectCompleted.Add(ActivateActiveMacguffin)
Events.TurnBegin.Add(reduceHoneyMacguffinCooldown)




--to do: delete debug code
Events.CityInitialized.Add(grantDebugGreatPerson)
