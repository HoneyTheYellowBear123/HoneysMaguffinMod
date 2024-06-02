-- HoneyMacguffin
-- Author: HoneyTheBear
-- DateCreated: 6/28/2023 11:23:29 PM
--------------------------------------------------------------



--give player0 (human) a great person for debugging
local DebugGreatPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_HONEY_MACGUFFIN_GP"].Index;
local DebugGreatPerson = GameInfo.GreatPersonIndividuals["GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_GP"].Index;
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


	--reduce each player's global cooldown every couple of turns
	--local modulusValue = math.floor( Game.GetMaxGameTurns() / Macguffin_Global_Cooldown_Reductions_Per_Game ) --Modulus value is how often we will reduce global cooldown values
	--print("MAX TURNS")
	--print(Game.GetMaxGameTurns())
	--print("MODULUS VALUE")
	--print(modulusValue)
	--print("CURRENT TURN")
	--print(Game.GetCurrentGameTurn())

	local baseUpdateRate =  math.floor( 500 / Approx_Global_Cooldown_Updates_Per_Game )
	local scaledUpdateRate = math.ceil(baseUpdateRate / (100 / speedCostMultiplier))


	if (Game.GetCurrentGameTurn() % scaledUpdateRate == 0) then
		print("REDUCING GLOBAL COOLDOWN")
		local temptable2 = {}
		for i, GlobalCooldownEntry in ipairs(Game:GetProperty("HoneyMacguffinGlobalCooldownSystem")) do
			temptable2[i] = GlobalCooldownEntry
			if temptable2[i] > 0 then
				temptable2[i] = temptable2[i] - 1
			end
		end
		Game:SetProperty("HoneyMacguffinGlobalCooldownSystem",temptable2)
	end


end

Macguffin_Cooldown_Multiple = 1 --TO DO add this as a configurable variables
Approx_Global_Cooldown_Updates_Per_Game = 100 --TO DO make this configurable
speedCostMultiplier = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier


	--local spawnChance = math.max(GetBaseSCPChance() + extraChance, 0);
    --local gameSpeed = GameConfiguration.GetGameSpeedType();
    --local speedCostMultiplier = GameInfo.GameSpeeds[gameSpeed].CostMultiplier;
    --Multiply everything by 100 to ensure even a gamespeed multiplier of 1 returns a useable value less than 100%
    --if (math.random(1,(speedCostMultiplier * 100)) <= spawnChance * 100) then
    --    canSpawn = true;
    --end







function intable(table,val)
	
	if (val == -1) or (val == nil) then
		print("honeydebug intable val was -1 so we are returning false")
		return false
	end

	for i=1,#table do
		print("honeydebug intable value: "..val)
		print("honeydebug intable tablevalue: "..table[i])
		if table[i]==val then
			print("honeydebug intable returning true")
			return true
		end
	end
	print("honeydebug intable returning false")
	return false
end


--Thank you Master of the Galaxy
--The Modding discord is a blessing
function GetCityPlots(pCity)
    local tTempTable = {}
    if pCity ~= nil then
        local iCityRadius = 3
        local iTableCount = 1
        local iCityOwner = pCity:GetOwner()
        local iCityX, iCityY = pCity:GetX(), pCity:GetY()
        for dx = (iCityRadius * -1), iCityRadius do
            for dy = (iCityRadius * -1), iCityRadius do
                local pPlotNearCity = Map.GetPlotXYWithRangeCheck(iCityX, iCityY, dx, dy, iCityRadius);
                if pPlotNearCity and (pPlotNearCity:GetOwner() == iCityOwner) then
                    local iPlotIndex, bAddToTable = pPlotNearCity:GetIndex(), false
                    if ((Cities.GetPlotWorkingCity(iPlotIndex) ~= nil) and (pCity == Cities.GetPlotWorkingCity(iPlotIndex))) then
                        bAddToTable = true
                    elseif ((Cities.GetPlotWorkingCity(iPlotIndex) == nil) and (pCity == Cities.GetPlotPurchaseCity(iPlotIndex))) then
                        bAddToTable = true
                    end
                    if (bAddToTable == true) then
                        tTempTable[iTableCount] = pPlotNearCity
                        iTableCount = iTableCount + 1
                    end
                end
            end
        end
    end
    return tTempTable
end



--returns relevent tiles for an effect to be applied to
function chooseRandomTiles( playerID, target, features, terrains, resources, number, DontAllowCities, withImprovementOk, bannedFeatures, bannedTerrains)

	-- whichPlayer
	-- playerID of whoever activated macguffin

	--target
	--0 for self, 1 for war enemies, 2 for random someone else, 3 for random anybody (I don't think I'll ever use 3 )

	-- features
	-- all tiles that contain these features will be considered

	--terrains
	--all tiles with this terrain will be considered

	--resources
	--all tiles with these resources will be considered

	-- number
	-- how many tiles do we want ITS BETTER TO SOLVE THIS LATER DONT WORRY ABOUT IT

	-- withImprovementOk
	-- 0 no improvements on this tile yet please, 1 only tiles with improvements, 2 we dont care

	-- bannedFeatures
	-- features that disqualify this tile

	-- bannedTerrains
	-- terrains that disqualify this tile

	


	--Pseudocode
	--for player index
		-- for cities
			-- check tiles within 3 of city center
			-- make sure to check ownership so that city centers dont get grabbed and close cities dont get doubled up
	--choose a few from this mega list randomly based on number
	--return



	--playerGroup = []
	if target == 0 then
		playerGroupar = {Players[playerID]}
	end
	if target == 1 then
		--get war enemies
	end
	if target == 2 then
		-- get everybody except player
	end

	relevant_tiles = {}
	for i, player in ipairs(playerGroupar) do


		print("honeydebug reward playertype: "..type(player));
		--print("honeydebug reward playervalue: "..player);

		
		--player = playerGroupar[index]
		for cit in player:GetCities():Members() do

			print("honeydebug reward cit type: "..type(cit));
			print("honeydebug reward cit value: "..cit);

			city = CityManager.GetCity(player, cit)

			print("honeydebug reward city type: "..type(city));


			cityTileX = city:GetX()
			cityTileY = city:GetY()
			print("honeydebug reward chose a city for tile searching!")

			cityPlots = GetCityPlots(city)

			--cityPlots = city:GetOwnedPlots()

			for ito, plot in ipairs(cityPlots) do

				continue = false --simple means of speeding it up, since the table search will take longer than a continue check

				add_it = false

				print("honeydebug reward plot X "..plot:GetX());
				print("honeydebug reward plot Y "..plot:GetY());



				--################################## initial checks, lets us skip additive checks possibly #########################

				if (DontAllowCities and plot:IsCity()) then
					print("honeydebug reward tile is considered a city")
					continue = true
				end

				if (not withImprovementOk) and (plot:GetImprovementType() ~= -1) then
					continue = true
				end

				--####################### Additive checks if any of these pass we're good to go ###########################

				--print("honeydebug reward resource type: "..plot:GetResourceType())
				--resources are a special case. Cattle can exist on hills but it is assumed we want a pasture there rather than a mine. However, Macguffin placement is not removing resource, so its fine I guess? You can always remove the improvement if you want something else to be there.
				if ( (plot:GetResourceType() ~= -1 ) and (not continue) ) then
					if ((resources ~= {}) and ( intable(resources, GameInfo.Resources[plot:GetResourceType()].ResourceType) ) ) then
						print("honeydebug reward tile has been selected due to resource") 
						add_it = true
						continue = true
					else
						print("honeydebug reward tile has been SKIPPED due to resource") 
						continue = true
					end
				end


				if ( (plot:GetFeatureType() ~= -1) and (not continue) ) then
					if ( ( features ~= {} ) and ( intable(features, GameInfo.Features[plot:GetFeatureType()].FeatureType) ) ) then
						print("honeydebug reward tile has been selected due to feature")
						add_it = true
						continue = true
					end
				end

				if ( (plot:GetTerrainType() ~= -1) and (not continue) ) then
					if ((terrains ~= {}) and ( intable(terrains, GameInfo.Terrains[plot:GetTerrainType()].TerrainType) ) ) then
						print("honeydebug reward tile has been selected due to terrain")
						add_it = true
						continue = true
					end
				end

				--############################# subtractive checks, if any of these show a bad value, switch add_it back to false ####################################
				--########## makes sure mines dont end up in the water just because we found amber

				if ( (plot:GetFeatureType() ~= -1) and add_it) then
					if ( ( bannedFeatures ~= {} ) and ( intable(bannedFeatures, GameInfo.Features[plot:GetFeatureType()].FeatureType) ) ) then
						print("honeydebug reward tile has been SKIPPED due to feature")
						add_it = false
					end
				end

				if ( (plot:GetTerrainType() ~= -1) and add_it) then
					if ( ( bannedTerrains ~= {} ) and ( intable(bannedTerrains, GameInfo.Features[plot:GetTerrainType()].TerrainType) ) ) then
						print("honeydebug reward tile has been SKIPPED due to terrain")
						add_it = false
					end
				end







				--####################################### add it :)

				if add_it then
					print("honeydebug reward tile we found a plot that works")
					table.insert(relevant_tiles, plot)
				end

				
							 							
			end
		end
	end
		
	--randomly select some number of them
	return relevant_tiles
end



--choose num number things from a list at random
function ChooseNumFromList(listin, num)
	
	local returnlist = {}
	while ( ( #returnlist < num ) and ( #listin > 0 ) ) do
		
		math.randomseed(os.time())
		math.random(); math.random(); math.random()
		randomindex = math.random(1, #listin)
		table.insert(returnlist, listin[randomindex])
		table.remove(listin, randomindex)

	end
	return returnlist
end
	






function grantHoneyMacguffinActiveEffect(projectID, playerID, x, y) --grant each reward and return associated number of cooldown
	--efficiency can increase if I check the name and split it up as much as possible

	print("HoneyDebug active grant effect was called")

	--Motivatinator
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT'].Index then
		return free_builder_reward(playerID, 1, x, y)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT_TIER2'].Index then
		return free_builder_reward(playerID, 2, x, y)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FREE_BUILDER_UNIT_TIER3'].Index then
		return free_builder_reward(playerID, 3, x, y)
	end

	--Notched Pickaxe
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_MINE_QUARRY'].Index then
		return mine_quarry_reward(playerID, 1)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_MINE_QUARRY_TIER2'].Index then
		return mine_quarry_reward(playerID, 2)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_MINE_QUARRY_TIER3'].Index then
		return mine_quarry_reward(playerID, 3)
	end

	--Farm Hand
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_FARM_PLANTATION'].Index then
		return farm_plantation_reward(playerID, 1)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_FARM_PLANTATION_TIER2'].Index then
		return farm_plantation_reward(playerID, 2)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_FARM_PLANTATION_TIER3'].Index then
		return farm_plantation_reward(playerID, 3)
	end

	--Resinator
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_CAMP_MILL'].Index then
		return camp_mill_reward(playerID, 1)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_CAMP_MILL_TIER2'].Index then
		return camp_mill_reward(playerID, 2)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_CAMP_MILL_TIER3'].Index then
		return camp_mill_reward(playerID, 3)
	end

	--live stock
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_PASTURE_FISHING'].Index then
		return pasture_fishing_reward(playerID, 1)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_PASTURE_FISHING_TIER2'].Index then
		return pasture_fishing_reward(playerID, 2)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_BUILD_PASTURE_FISHING_TIER3'].Index then
		return pasture_fishing_reward(playerID, 3)
	end


	--Nexus Of Knowledge
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE'].Index then
		return grant_science_yield_reward(projectID, playerID, 1)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2'].Index then
		return grant_science_yield_reward(projectID, playerID, 2)
	end
	if projectID == GameInfo.Projects['PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3'].Index then
		return grant_science_yield_reward(projectID, playerID, 3)
	end







	
	

	print("placeholder XD")
	return 1
end


-------------------------------------------------------------------------------------------------------
------------------------------------------ REWARD FUNCTIONS ------------------------------------------
-------------------------------------------------------------------------------------------------------

-- all functions apply some reward and return the BASE cooldown for that macguffin.




function free_builder_reward(playerid, tier, x, y)

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


--TO DO I think we need every natural wonder to be a banned feature

function mine_quarry_reward(playerid, tier)

	local minefeatures = {'FEATURE_VOLCANIC_SOIL'}
	local mineterrains = {'TERRAIN_GRASS_HILLS','TERRAIN_PLAINS_HILLS','TERRAIN_DESERT_HILLS','TERRAIN_TUNDRA_HILLS','TERRAIN_SNOW_HILLS'}
	local mineresources = {'RESOURCE_COPPER', 'RESOURCE_IRON', 'RESOURCE_NITER', 'RESOURCE_COAL', 'RESOURCE_ALUMINUM', 'RESOURCE_URANIUM', 'RESOURCE_AMBER', 'RESOURCE_DIAMONDS', 'RESOURCE_JADE', 'RESOURCE_MERCURY', 'RESOURCE_SALT', 'RESOURCE_SILVER'}
	local bannedminefeatures = {}
	local bannedmineterrains = {'TERRAIN_COAST','TERRAIN_OCEAN'} --amber in the ocean gets fishing boats
	
	local quarryfeatures = {}
	local quarryterrains = {}
	local quarryresources = {'RESOURCE_STONE', 'RESOURCE_MARBLE', 'RESOURCE_GYPSUM'}
	local bannedquarryfeatures = {}
	local bannedquarryterrains = {}
	
	local mineplots = chooseRandomTiles(playerid, 0, minefeatures, mineterrains, mineresources, 1, 1, 0, {}, bannedmineterrains)
	local quarryplots = chooseRandomTiles(playerid, 0, quarryfeatures, quarryterrains, quarryresources, 1, 1, 0, {}, {})

	local masterplotlist = {}
	for i, item in ipairs(mineplots) do
		table.insert( masterplotlist , {item, 'mine'} )
	end
	for i, item in ipairs(quarryplots) do	
		table.insert( masterplotlist, {item, 'quarry'} )
	end

	local plots = ChooseNumFromList(masterplotlist, tier)

	mineindex = GameInfo.Improvements['IMPROVEMENT_MINE'].Index;
	quarryindex = GameInfo.Improvements['IMPROVEMENT_QUARRY'].Index;
	print("honeydebug reward total plots chosen: "..#plots)
	if #plots > 0 then
		for i, plot in ipairs(plots) do
			if plot[2] == 'mine' then
				print("honeydebug mine we have plots that could contain mines within the empire")
				ImprovementBuilder.SetImprovementType(plot[1],  mineindex   ,playerid)
			end
			if plot[2] == 'quarry' then
				print("honeydebug mine we have plots that could contain quarries within the empire")
				ImprovementBuilder.SetImprovementType(plot[1],  quarryindex   ,playerid)
			end
		end
	else
		print("honeydebug mine we have found NO plots that could contain quarries or mines within the empire")
		return 1 --no more spots to improve
	end

	if tier == 1 then
		return 10
	end
	if tier == 2 then
		return 15
	end
	if tier == 3 then
		return 20
	end

end





function farm_plantation_reward(playerid, tier)

	local farmfeatures = {'FEATURE_VOLCANIC_SOIL', 'FEATURE_FLOODPLAINS'}
	local farmterrains = {'TERRAIN_GRASS_HILLS','TERRAIN_PLAINS_HILLS','TERRAIN_GRASS','TERRAIN_PLAINS'}
	local farmresources = {'RESOURCE_WHEAT', 'RESOURCE_RICE', 'RESOURCE_CORN'}
	local bannedfarmfeatures = {'FEATURE_JUNGLE','FEATURE_FOREST','FEATURE_BURNING_FOREST','FEATURE_BURNING_JUNGLE','FEATURE_BURNT_JUNGLE','FEATURE_BURNT_FOREST'}
	local bannedfarmterrains = {} 
	
	local plantationfeatures = {}
	local plantationterrains = {}
	local plantationresources = {'RESOURCE_BANANAS', 'RESOURCE_CITRUS', 'RESOURCE_CHOCOLATE', 'RESOURCE_COFFEE', 'RESOURCE_COTTON', 'RESOURCE_DYES', 'RESOURCE_INCENSE', 'RESOURCE_TEA', 'RESOURCE_SILK', 'RESOURCE_SPICES', 'RESOURCE_SUGAR', 'RESOURCE_OLIVES', 'RESOURCE_TOBACCO', 'RESOURCE_WINE'}
	
	local farmplots = chooseRandomTiles(playerid, 0, farmfeatures, farmterrains, farmresources, 1, 1, 0, bannedfarmfeatures, {})
	local plantationplots = chooseRandomTiles(playerid, 0, plantationfeatures, plantationterrains, plantationresources, 1, 1, 0, {}, {})

	local masterplotlist = {}
	for i, item in ipairs(farmplots) do
		table.insert( masterplotlist , {item, 'farm'} )
	end
	for i, item in ipairs(plantationplots) do	
		table.insert( masterplotlist, {item, 'plantation'} )
	end

	local plots = ChooseNumFromList(masterplotlist, tier)

	farmindex = GameInfo.Improvements['IMPROVEMENT_FARM'].Index;
	plantationindex = GameInfo.Improvements['IMPROVEMENT_PLANTATION'].Index;
	if #plots > 0 then
		for i, plot in ipairs(plots) do
			if plot[2] == 'farm' then
				ImprovementBuilder.SetImprovementType(plot[1],  farmindex   ,playerid)
			end
			if plot[2] == 'plantation' then
				ImprovementBuilder.SetImprovementType(plot[1],  plantationindex   ,playerid)
			end
		end
	else
		return 1 --no more spots to improve
	end
	
	--cooldown a little higher for this macguffin because so many tiles can have farms
	if tier == 1 then
		return 15
	end
	if tier == 2 then
		return 20
	end
	if tier == 3 then
		return 25
	end

end






function camp_mill_reward(playerid, tier)


	local campfeatures = {}
	local campterrains = {}
	local campresources = {'RESOURCE_DEER','RESOURCE_FURS','RESOURCE_IVORY','RESOURCE_TRUFFLES','RESOURCE_HONEY'}
	local bannedcampfeatures = {}
	local bannedcampterrains = {} 
	
	local millfeatures = {'FEATURE_JUNGLE','FEATURE_FOREST'}
	local millterrains = {}
	local millresources = {}
	
	local campplots = chooseRandomTiles(playerid, 0, campfeatures, campterrains, campresources, 1, 1, 0, bannedcampfeatures, {})
	local millplots = chooseRandomTiles(playerid, 0, millfeatures, millterrains, millresources, 1, 1, 0, {}, {})

	local masterplotlist = {}
	for i, item in ipairs(campplots) do
		table.insert( masterplotlist , {item, 'camp'} )
	end
	for i, item in ipairs(millplots) do	
		table.insert( masterplotlist, {item, 'mill'} )
	end

	local plots = ChooseNumFromList(masterplotlist, tier)

	campindex = GameInfo.Improvements['IMPROVEMENT_CAMP'].Index;
	millindex = GameInfo.Improvements['IMPROVEMENT_LUMBER_MILL'].Index;
	if #plots > 0 then
		for i, plot in ipairs(plots) do
			if plot[2] == 'camp' then
				ImprovementBuilder.SetImprovementType(plot[1],  campindex   ,playerid)
			end
			if plot[2] == 'mill' then
				ImprovementBuilder.SetImprovementType(plot[1],  millindex   ,playerid)
			end
		end
	else
		return 1 --no more spots to improve
	end
	
	--cooldown a little higher for this macguffin because so many tiles can have mills
	if tier == 1 then
		return 15
	end
	if tier == 2 then
		return 20
	end
	if tier == 3 then
		return 25
	end

end





function pasture_fishing_reward(playerid, tier)


	print("honey debug pasture fishing function was called!")

	local pasturefeatures = {}
	local pastureterrains = {}
	local pastureresources = {'RESOURCE_HORSES','RESOURCE_CATTLE','RESOURCE_SHEEP'}
	local bannedpasturefeatures = {}
	local bannedpastureterrains = {} 
	
	local fishingfeatures = {}
	local fishingterrains = {}
	local fishingresources = {'RESOURCE_FISH','RESOURCE_CRABS','RESOURCE_WHALES','RESOURCE_PEARLS','RESOURCE_AMBER','RESOURCE_TURTLES'}
	local bannedfishingterrains = {'TERRAIN_GRASS','TERRAIN_GRASS_HILLS','TERRAIN_PLAINS','TERRAIN_PLAINS_HILLS','TERRAIN_DESERT','TERRAIN_DESERT_HILLS','TERRAIN_TUNDRA','TERRAIN_TUNDRA_HILLS','TERRAIN_SNOW','TERRAIN_SNOW_HILLS'} --amber dont get boats on land
	
	local pastureplots = chooseRandomTiles(playerid, 0, pasturefeatures, pastureterrains, pastureresources, 1, 1, 0, bannedpasturefeatures, {})
	local fishingplots = chooseRandomTiles(playerid, 0, fishingfeatures, fishingterrains, fishingresources, 1, 1, 0, {}, bannedfishingterrains )

	local masterplotlist = {}
	for i, item in ipairs(pastureplots) do
		table.insert( masterplotlist , {item, 'pasture'} )
	end
	for i, item in ipairs(fishingplots) do	
		table.insert( masterplotlist, {item, 'fishing'} )
	end

	local plots = ChooseNumFromList(masterplotlist, tier)

	pastureindex = GameInfo.Improvements['IMPROVEMENT_PASTURE'].Index;
	fishingindex = GameInfo.Improvements['IMPROVEMENT_FISHING_BOATS'].Index;
	if #plots > 0 then
		for i, plot in ipairs(plots) do
			if plot[2] == 'pasture' then
				ImprovementBuilder.SetImprovementType(plot[1],  pastureindex   ,playerid)
			end
			if plot[2] == 'fishing' then
				ImprovementBuilder.SetImprovementType(plot[1],  fishingindex   ,playerid)
			end
		end
	else
		return 1 --no more spots to improve
	end
	
	
	if tier == 1 then
		return 10
	end
	if tier == 2 then
		return 15
	end
	if tier == 3 then
		return 20
	end

end




function grant_science_yield_reward(projectid, playerid, tier)


	local scienceYield = 0
	for i, MacguffinEntry in ipairs(Game:GetProperty("HoneyMacguffinIndexSystem")) do
		if MacguffinEntry[7] == projectid then
			local CityObject = CityManager.GetCity( MacguffinEntry[8], MacguffinEntry[5]  )
			scienceYield = CityObject:GetYield('YIELD_SCIENCE')

		end
	end

	local playerobject = Players[playerid]

	if tier == 1 then
		scienceYield = scienceYield * 3
		playerobject:GrantYield(GameInfo.Yields['YIELD_SCIENCE'].Index,scienceYield)
		return 10
	end
	if tier == 2 then
		scienceYield = scienceYield * 6
		playerobject:GrantYield(GameInfo.Yields['YIELD_SCIENCE'].Index,scienceYield)
		return 15	
	end
	if tier == 3 then
		scienceYield = scienceYield * 10
		playerobject:GrantYield(GameInfo.Yields['YIELD_SCIENCE'].Index,scienceYield)
		return 20
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













--################################################################################################################
----------------------------------------- Damage Walls -------------------------------------------------------
--#######################################################################################################

local ms_cityCenterDistrict :number		= GameInfo.Districts["DISTRICT_CITY_CENTER"].Index;

function macguffinDamageWalls() --should function even if building is pillaged

	for playerid, playerobject in pairs(Players) do
		if playerobject:IsMajor() then
			playerCityMembers = playerobject:GetCities()
		    for i, cityObject in playerCityMembers:Members() do
				if cityObject:GetBuildings():HasBuilding(altarBuildingIndex) == true then

					local step1 = cityObject:GetDistricts()
					local districtObject = step1:GetDistrict(ms_cityCenterDistrict)

					districtObject:SetDamage(DefenseTypes.DISTRICT_OUTER,9999)

				end
			end
		end
	end
end










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
Events.TurnBegin.Add(macguffinDamageWalls)




--to do: delete debug code
Events.CityInitialized.Add(grantDebugGreatPerson)
