-- MacguffinBase
-- Author: HoneyTheBear
-- DateCreated: 6/24/2023 7:38:23 PM
--------------------------------------------------------------

--Base file for the kinds and such that I don't want to deal with elsewhere.
--should be loaded before all the other database files in the mod, which should just include macguffin specific information.
-- TO DO require the monopoly dlc too just to avoid any gray areas (kublikhan and vietnam)




--      -------------------------- HEAVY FEATURES ---------------------------------
	-- game starts, everybody gets free storage? (just add a bunch to palace). 
	-- actual custom great slot 
	-- turn individual macguffins on/off
	-- great people granted events via lua and too expensive otherwise
	-- override for greatworksoverview
	-- project handling for active macguffins in lua
	-- single use mega macguffins
	-- District for epic macguffins
	-- Macguffin Ahnilator for victory




INSERT INTO Types 

		(Type, Kind)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY',						'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2',						'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3',						'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_ACTIVE_MACGUFFIN',						'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_STORAGE_PSEUDOBUILDING',			    'KIND_BUILDING'),
		('HONEY_MACGUFFIN_DUMMY_ERA',                           'KIND_ERA'),
		('GREAT_PERSON_HONEY_MACGUFFIN_GP',                                  'KIND_GREAT_PERSON_CLASS'),
		('UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP',                             'KIND_UNIT'),
		('PSEUDOYIELD_GPP_GREAT_PERSON_HONEY_MACGUFFIN_GP',					'KIND_PSEUDOYIELD'),
		('PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2',                    'KIND_PROJECT'),
		('PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3',                    'KIND_PROJECT'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVATE_MACGUFFIN',                    'KIND_PROJECT');





--Really expensive dummy era so the great people cannot be bought
INSERT INTO Eras
		(EraType,							 Name,								Description,							ChronologyIndex, WarmongerPoints,   GreatPersonBaseCost,	 EraTechBackgroundTexture, EraCivicBackgroundTexture, WarmongerLevelDescription, EmbarkedUnitStrength, EraTechBackgroundTextureOffsetX, EraCivicBackgroundTextureOffsetX, TechTreeLayoutMethod)
VALUES  ('HONEY_MACGUFFIN_DUMMY_ERA', 'LOC_HONEY_MACGUFFIN_DUMMY_ERA_NAME', 'LOC_HONEY_MACGUFFIN_DUMMY_ERA_DESC',       42069,				    0,                  99999999,            'TechTree_BGModern',    'TechTree_BGFuture',      'LOC_WARMONGER_LEVEL_NONE',		 69,                     0,                                  0,                            'Cost' );

INSERT INTO TypeTags
		(Type, Tag)
VALUES  ('UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP', 'CLASS_LANDCIVILIAN');

INSERT INTO Units
		(UnitType,						Cost, BaseMoves, BaseSightRange, ZoneOfControl,			Domain,			FormationClass,				Name,								Description,							CanCapture, CanRetreatWhenCaptured, CanTrain)
VALUES  ('UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP',		1,		4,			2,				0, '			DOMAIN_LAND', 'FORMATION_CLASS_CIVILIAN', 'LOC_UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME', 'LOC_UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP_DESCRIPTION',			0,		 1,						 0);

INSERT INTO UnitAiInfos
		(UnitType, AiType)
VALUES  ('UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP', 'UNITTYPE_CIVILIAN'),
		('UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP', 'UNITAI_LEADER');

INSERT INTO PseudoYields
		(PseudoYieldType, DefaultValue)
VALUES  ('PSEUDOYIELD_GPP_GREAT_PERSON_HONEY_MACGUFFIN_GP', 0.5); --TO DO a pseudoyield for the macguffin itself. AI doesn't need to know how to use them but they should value them regardless.

INSERT INTO GreatWorkObjectTypes
		(GreatWorkObjectType,						Value,		PseudoYieldType,											 Name,									IconString)
VALUES  ('GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',	 69420, 'PSEUDOYIELD_GPP_GREAT_PERSON_HONEY_MACGUFFIN_GP', 'LOC_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_NAME',  '[ICON_Honey_Passive_Macguffin]'), --TO DO change iconstring
		('GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE',   69421, 'PSEUDOYIELD_GPP_GREAT_PERSON_HONEY_MACGUFFIN_GP', 'LOC_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_NAME',    '[ICON_Honey_Active_Macguffin]'); --TO DO change iconstring

--unobtainable great person for giving out macguffins. I can't great macguffins via lua script, but I can grant great people who grant macguffins so whatever I guess
INSERT INTO GreatPersonClasses
		(GreatPersonClassType,			 Name,									 UnitType,					   DistrictType,			PseudoYieldType,							 IconString                    ,				ActionIcon        )
VALUES  ('GREAT_PERSON_HONEY_MACGUFFIN_GP',           'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',           'UNIT_GREAT_PERSON_HONEY_MACGUFFIN_GP',    'DISTRICT_CITY_CENTER', 'PSEUDOYIELD_GPP_GREAT_PERSON_HONEY_MACGUFFIN_GP',       '[ICON_GreatEngineer]',       'ICON_UNITOPERATION_ENGINEER_ACTION'); --TO DO Icons

INSERT INTO Buildings
		(BuildingType,									Name,														Description,							  PrereqDistrict,		PurchaseYield,		        Cost,	AdvisorType  , InternalOnly  )  
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY_DESC',    'DISTRICT_CITY_CENTER',         'YIELD_GOLD',			 4,    'ADVISOR_GENERIC', 0), --TO DO make it scale heavily? --TO DO add back in a prereq tech probably astrology --TO DO prevent steel
		('BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2', 'LOC_BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2_DESC',    'DISTRICT_CITY_CENTER',         'YIELD_GOLD',			 4,    'ADVISOR_GENERIC', 0),
		('BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3', 'LOC_BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3_DESC',    'DISTRICT_CITY_CENTER',         'YIELD_GOLD',			 4,    'ADVISOR_GENERIC', 0),
		('BUILDING_HONEY_MACGUFFIN_ACTIVE_MACGUFFIN', 'LOC_BUILDING_HONEY_MACGUFFIN_ACTIVE_MACGUFFINY_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_ACTIVE_MACGUFFIN_DESC',    'DISTRICT_CITY_CENTER',         'YIELD_GOLD',			 4,    'ADVISOR_GENERIC', 1); 


--TO DO add appropriate prereq tech or civics, consider a cost progression model and proper cost
--TO DO Projects_XP2 has more fields we might want to abuse 
--TO DO scaling cost for activate macguffin
INSERT INTO Projects
		(ProjectType,										Name,												 ShortName,													 Description,					Cost, AdvisorType,        RequiredBuilding)
VALUES  ('PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2', 'PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2_NAME', 'PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2_SHORTNAME', 'PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2_DESC',         2,  'ADVISOR_GENERIC', 'BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2'),
		('PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3', 'PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3_NAME', 'PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3_SHORTNAME', 'PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3_DESC',         2,  'ADVISOR_GENERIC', 'BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVATE_MACGUFFIN', 'PROJECT_HONEY_MACGUFFIN_ACTIVATE_MACGUFFIN_NAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVATE_MACGUFFIN_SHORTNAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVATE_MACGUFFIN_DESC',         20,  'ADVISOR_GENERIC', NULL);

INSERT INTO Projects_XP2
		(ProjectType,								 RequiredBuilding)
VALUES  ('PROJECT_HONEY_MACGUFFIN_TIER1_TO_TIER2', 'BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2'),
		('PROJECT_HONEY_MACGUFFIN_TIER2_TO_TIER3', 'BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVATE_MACGUFFIN', 'BUILDING_HONEY_MACGUFFIN_ACTIVE_MACGUFFIN');





-- TO PREVENT STEEL URBAN DEFENSES 
-- add a requirement to the modifier that the city does NOT have the macguffin altar :)
--Modifiers where ModifierID is STEEL_UNLOCK_URBAN_DEFENSES add SubjectRequirementSetId
INSERT INTO Requirements
		(RequirementId,										RequirementType,				Reverse)
VALUES  ('REQUIREMENT_CITY_DOES_NOT_HAVE_MACGUFFIN_ALTAR', 'REQUIREMENT_CITY_HAS_BUILDING',       1 );

INSERT INTO RequirementArguments
		(RequirementId,										Name,			Value)
VALUES  ('REQUIREMENT_CITY_DOES_NOT_HAVE_MACGUFFIN_ALTAR', 'BuildingType', 'BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY');

INSERT INTO RequirementSets
		(RequirementSetId,							 RequirementSetType)
VALUES  ('REQUIREMENTSET_STEEL_NO_MACGUFFIN_ALTAR', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId, RequirementId)
VALUES  ('REQUIREMENTSET_STEEL_NO_MACGUFFIN_ALTAR', 'REQUIREMENT_CITY_DOES_NOT_HAVE_MACGUFFIN_ALTAR');

UPDATE Modifiers
SET SubjectRequirementSetId = 'REQUIREMENTSET_STEEL_NO_MACGUFFIN_ALTAR'
WHERE ModifierID = 'STEEL_UNLOCK_URBAN_DEFENSES';




INSERT INTO GreatWorkSlotTypes
		(GreatWorkSlotType)
VALUES  ('GREATWORKSLOT_HONEY_MACGUFFIN');

--for some reason UI/lua code has slots hardcoded and its causing problems. Using the artifact slot for now since my game logic will be determined in lua (ironically, also with hardcoded values).
INSERT INTO GreatWork_ValidSubTypes
		(GreatWorkSlotType,					 GreatWorkObjectType)
VALUES  ('GREATWORKSLOT_ARTIFACT',	'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE'),
		('GREATWORKSLOT_ARTIFACT',	'GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE'),
		--('GREATWORKSLOT_HONEY_MACGUFFIN',	'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE'),
		--('GREATWORKSLOT_HONEY_MACGUFFIN',	'GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE');
		--('GREATWORKSLOT_HONEY_MACGUFFIN',	'GREATWORKOBJECT_WRITING'),
		('GREATWORKSLOT_PALACE',            'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE'),
		('GREATWORKSLOT_PALACE',	'GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE');

		--TO DO: make sure steel doesn't cause problems. Probably some modifier can be used to reduce the strength of the defenses.
INSERT INTO MutuallyExclusiveBuildings
		(Building,							 MutuallyExclusiveBuilding)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY',     'BUILDING_WALLS'),
		('BUILDING_WALLS',   'BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY'  );

--TO DO: switch back to artifact slot after testing is done
INSERT INTO Building_GreatWorks
		(BuildingType,								GreatWorkSlotType,				NumSlots)
VALUES	('BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY',  'GREATWORKSLOT_ARTIFACT',      1 ),--('BUILDING_HONEY_MACGUFFIN_HOLDER_EMPTY',  'GREATWORKSLOT_HONEY_MACGUFFIN',      1 );
		('BUILDING_HONEY_MACGUFFIN_TIER1_TO_TIER2',  'GREATWORKSLOT_ARTIFACT',      1 ),
		('BUILDING_HONEY_MACGUFFIN_TIER2_TO_TIER3',  'GREATWORKSLOT_ARTIFACT',      1 );

--INSERT INTO Building_GreatWorks
--		(BuildingType,			GreatWorkSlotType,				NumSlots)
--VALUES  ('BUILDING_PALACE',		'GREATWORKSLOT_HONEY_MACGUFFIN',      1 );
--INSERT INTO Building_GreatWorks
--		(BuildingType,								GreatWorkSlotType,				NumSlots)
--VALUES  ('BUILDING_HONEY_MACGUFFIN_STORAGE_PSEUDOBUILDING',  'GREATWORKSLOT_HONEY_MACGUFFIN',      1 );


