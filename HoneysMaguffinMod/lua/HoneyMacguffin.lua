-- HoneyMacguffin
-- Author: HoneyTheBear
-- DateCreated: 6/28/2023 11:23:29 PM
--------------------------------------------------------------



--give player0 (human) a great person for debugging
local DebugGreatPersonClass = GameInfo.GreatPersonClasses["GREAT_PERSON_HONEY_MACGUFFIN_GP"].Index;
local DebugGreatPerson = GameInfo.GreatPersonIndividuals["GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP"].Index;
local DebugGreatPerson2 = GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_BHASA"].Index;
local richesBuildingIndex = GameInfo.Buildings["BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY"].Index;

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


Events.CityInitialized.Add(grantDebugGreatPerson)