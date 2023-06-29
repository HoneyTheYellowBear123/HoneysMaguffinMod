-- HoneyMacguffin
-- Author: HoneyTheBear
-- DateCreated: 6/28/2023 11:23:29 PM
--------------------------------------------------------------



--give player0 (human) a great person for debugging
local DebugGreatPersonClass = GameInfo.GreatPersonClasses["HONEY_MACGUFFIN_GP"].Index;
local DebugGreatPerson = GameInfo.GreatPeople["HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP"].Index;
local macguffinEra = GameInfo.Eras["HONEY_MACGUFFIN_DUMMY_ERA"].Index;

function grantDebugGreatPerson(playerID, cityID, x, y)

	game.GetGreatPeople:GrantPerson(DebugGreatPerson, DebugGreatPersonClass,macguffinEra,0,playerID,false);

end


Events.CityInitialized.Add(grantDebugGreatPerson)