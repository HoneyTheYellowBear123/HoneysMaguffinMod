-- MacguffinBase
-- Author: HoneyTheBear
-- DateCreated: 6/24/2023 7:38:23 PM
--------------------------------------------------------------

--Base file for the kinds and such that I don't want to deal with elsewhere
-- TO DO require the monopoly dlc too just to avoid any gray areas (kublikhan and vietnam)




--      -------------------------- HEAVY FEATURES ---------------------------------
	-- game starts, everybody gets free storage (just add a bunch to palace). 
	-- turn individual artifacts on/off
	-- great people granted via lua and too expensive otherwise
	-- building that transforms
	-- 
















INSERT INTO Types --TO DO this will be seperated for each category for easiness

		(Type, Kind)
VALUES  ('HONEY_MACGUFFIN_HOLDER_EMPTY',						'KIND_BUILDING'),
		('HONEY_MACGUFFIN_STORAGE_PSEUDOBUILDING',			    'KIND_BUILDING'),
		('HONEY_MACGUFFIN_DUMMY_ERA',                           'KIND_ERA'),
		('HONEY_MACGUFFIN_GP',                                  'KIND_GREAT_PERSON_CLASS'),
		('UNIT_HONEY_MACGUFFIN_GP',                             'KIND_UNIT'),
		('PSEUDOYIELD_GPP_HONEY_MACGUFFIN_GP',					'KIND_PSEUDOYIELD'),




		('HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE',				'KIND_GREATWORK'),
		('HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('HONEY_MAGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE',          'KIND_BUILDING');


--Really expensive dummy era so the great people cannot be bought
INSERT INTO Eras
		(EraType,							 Name,								Description,							ChronologyIndex, WarmongerPoints,   GreatPersonBaseCost,	 EraTechBackgroundTexture, EraCivicBackgroundTexture, WarmongerLevelDescription, EmbarkedUnitStrength, EraTechBackgroundTextureOffsetX, EraCivicBackgroundTextureOffsetX, TechTreeLayoutMethod)
VALUES  ('HONEY_MACGUFFIN_DUMMY_ERA', 'LOC_HONEY_MACGUFFIN_DUMMY_ERA_NAME', 'LOC_HONEY_MACGUFFIN_DUMMY_ERA_DESC',       42069,				    0,                  99999999,            'TechTree_BGModern',    'TechTree_BGFuture',      'LOC_WARMONGER_LEVEL_NONE',		 69,                     0,                                  0,                            'Cost' ),

INSERT INTO TypeTags
		(Type, Tag)
VALUES  ('UNIT_HONEY_MACGUFFIN_GP', 'CLASS_LANDCIVILIAN');

INSERT INTO Units
		(UnitType,						Cost, BaseMoves, BaseSightRange, ZoneOfControl,			Domain,			FormationClass,				Name,								Description,							CanCapture, CanRetreatWhenCaptured, CanTrain)
VALUES  ('UNIT_HONEY_MACGUFFIN_GP',		1,		4,			2,				0, '			DOMAIN_LAND', 'FORMATION_CLASS_CIVILIAN', 'LOC_UNIT_HONEY_MACGUFFIN_GP_NAME', 'LOC_UNIT_HONEY_MACGUFFIN_GP_DESCRIPTION',			0,		 1,						 0);

INSERT INTO UnitAiInfos
		(UnitType, AiType)
VALUES  ('UNIT_HONEY_MACGUFFIN_GP', 'UNITTYPE_CIVILIAN'),
		('UNIT_HONEY_MACGUFFIN_GP', 'UNITAI_LEADER');

INSERT INTO GreatWorkObjectTypes
		(GreatWorkObjectType,		Value,		PseudoYieldType,						 Name,									IconString)
VALUES  ('HONEY_MACGUFFIN',			 69420, 'PSEUDOYIELD_HONEY_MACGUFFIN_PASSIVE', 'LOC_HONEY_MACGUFFIN_PASSIVE_NAME',  '[ICON_GreatWork_Relic]'), --TO DO change iconstring
		('HONEY_MACGUFFIN_ACTIVE',   69421, 'PSEUDOYIELD_HONEY_MACGUFFIN_ACTIVE', 'LOC_HONEY_MACGUFFIN_ACTIVE_NAME',    '[ICON_GreatWork_Relic]'); --TO DO change iconstring

INSERT INTO GreatWorkSlotTypes
		(GreatWorkSlotType)
VALUES  ('GREATWORKSLOT_HONEY_MACGUFFIN');

INSERT INTO GreatWork_ValidSubTypes
		(GreatWorkSlotType,					 GreatWorkObjectType)
VALUES  ('GREATWORKSLOT_HONEY_MACGUFFIN',	'HONEY_MACGUFFIN_PASSIVE'),
		('GREATWORKSLOT_HONEY_MACGUFFIN',	'HONEY_MACGUFFIN_ACTIVE');

INSERT INTO PseudoYieldType
		(PseudoYieldType, DefaultValue)
VALUES  ('PSEUDOYIELD_GPP_HONEY_MACGUFFIN_GP', 0.5); --TO DO a pseudoyield for the macguffin itself. AI doesn't need to know how to use them but they should value them regardless.

--unobtainable great person for giving out macguffins. I can't great macguffins via lua script, but I can grant great people who grant macguffins so whatever I guess
INSERT INTO GreatPersonClasses
		(GreatPersonClassType,			 Name,									 UnitType,					   DistrictType,			PseudoYieldType,							 IconString,				ActionIcon                      )
VALUES  ('HONEY_MACGUFFIN_GP'           'LOC_HONEY_MACGUFFIN_GP_NAME',           'UNIT_HONEY_MACGUFFIN_GP',    'DISTRICT_CITY_CENTER', 'PSEUDOYIELD_GPP_HONEY_MACGUFFIN_GP',       '[ICON_HONEY_MACGUFFIN_GP]',   'ICON_HONEY_MACGUFFIN_GP_ACTION'); --TO DO Icons

INSERT INTO Buildings
		(BuildingType,									Name,						Description,							  PrereqDistrict,				PrereqTech,			PurchaseYield,		Cost, AdvisorType)
VALUES  ('HONEY_MACGUFFIN_HOLDER_EMPTY', 'LOC_HONEY_MACGUFFIN_HOLDER_EMPTY_NAME', 'LOC_HONEY_MACGUFFIN_HOLDER_EMPTY_DESC',    'DISTRICT_CITY_CENTER',    'TECH_ASTRONOMY',         'YIELD_FAITH',    20,    'ADVISOR_GENERIC'); --TO DO make it only purchaseable with faith?
--TO DO the small medium and large rockets have a field called internal only, could be useful for macguffin storage.



INSERT INTO MutuallyExclusiveBuildings
		(Building,							 MutuallyExclusiveBuilding)
VALUES  ('HONEY_MACGUFFIN_HOLDER_EMPTY',     'BUILDING_WALLS');

INSERT INTO Building_GreatWorks
		(BuildingType,			GreatWorkSlotType,				NumSlots)
VALUES  ('BUILDING_PALACE',		'GREATWORKSLOT_HONEY_MACGUFFIN',      10 );















----------------------------------------------------------------------------------------------------------------------------- INDIVIDUAL BREAKOUT --------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO GreatPersonIndividuals
			(GreatPersonIndividualType,						Name,						GreatPersonClassType,			 eraType,					Gender,		 ActionCharges,            ActionEffectTextOverride)
VALUES     ('HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP', 'LOC_HONEY_MACGUFFIN_GP_NAME',  'HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_AVIATOR_SIR_GEORGE_CAYLEY_ACTION');

INSERT INTO GreatWorks
		(GreatWorkType,										 Name,									      GreatPersonIndividualType,							 GreatWorkObjectType )
VALUES  ('HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE',     'LOC_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_NAME',   'HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP'			'HONEY_MACGUFFIN_PASSIVE',);

INSERT INTO GreatWork_YieldChanges
		(GreatWorkType,							 YieldType, YieldChange)
VALUES  ('HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE', 'YIELD_GOLD', 1);



INSERT INTO Building_GreatWorks
		(BuildingType,								GreatWorkSlotType,				NumSlots)
VALUES  ('HONEY_MAGUFFIN_STORAGE_PSEUDOBUILDING',  'GREATWORKSLOT_HONEY_MACGUFFIN',      1 );


INSERT INTO MutuallyExclusiveBuildings
		(Building,									MutuallyExclusiveBuilding)
VALUES  ('HONEY_MAGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE', 'BUILDING_WALLS');