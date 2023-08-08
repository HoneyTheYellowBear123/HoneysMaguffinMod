-- Honey_Macguffin_Passive_Military
-- Author: HoneyTheBear
-- DateCreated: 7/17/2023 6:26:16 PM
--------------------------------------------------------------

--passive combat bonuses and stuff

-- building grants ability which has a modifier that gives the combat strength so I can pick and choose classes


INSERT INTO Types
		(Type,													Kind)
VALUES  ('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF', 'KIND_ABILITY'),
		('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2', 'KIND_ABILITY'),
		('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3', 'KIND_ABILITY'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER2',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER3',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF',          'KIND_BUILDING');

INSERT INTO TypeTags
		(Type,														Tag)
VALUES  ('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',   'CLASS_MELEE'),
		('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',   'CLASS_MELEE'),
		('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',   'CLASS_MELEE');


INSERT INTO Modifiers
		(ModifierId,														ModifierType,						 Permanent) --, SubjectRequirementSetdId)
VALUES  ( 'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_ABILITY_GRANTER', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',        0),
		( 'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',				 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',        0),
		( 'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_ABILITY_GRANTER', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',        0),
		( 'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',				 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',        0),
		( 'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_ABILITY_GRANTER', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',        0),
		( 'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',				 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',        0);


INSERT INTO UnitAbilities
		( UnitAbilityType,									Name,																	 Description,  Inactive )
VALUES  (  'ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',  'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_NAME', 'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_DESC', 1 ),
		(  'ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',  'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_NAME', 'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_DESC', 1 ),
		(  'ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',  'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_NAME', 'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_DESC', 1 );

INSERT INTO UnitAbilityModifiers
		(UnitAbilityType, ModifierId)
VALUES  ('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',  'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF'),
		('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',  'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2'),
		('ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',  'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3');


INSERT INTO GreatPersonIndividuals
			(GreatPersonIndividualType,						Name,						GreatPersonClassType,			 eraType,					Gender,		 ActionCharges,            ActionEffectTextOverride)
VALUES ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION');

INSERT INTO GreatWorks
		(GreatWorkType,																										 Name,									      GreatPersonIndividualType,							 GreatWorkObjectType,																			 Quote ,          Tourism )
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 );

INSERT INTO Buildings
		(BuildingType,															Name,																Description,									 PrereqDistrict,			 AdvisorType, Cost, InternalOnly)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_NAME',				'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER2', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER2_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER3', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER3_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1);

INSERT INTO BuildingModifiers
		(BuildingType,											 ModifierId)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF',  'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_ABILITY_GRANTER'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER2',  'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_ABILITY_GRANTER'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MELEE_BUFF_TIER3',  'MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_ABILITY_GRANTER');

INSERT INTO ModifierArguments
		(ModifierId,														Name,		Value)
VALUES  ('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_ABILITY_GRANTER',  'AbilityType', 'ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF'),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF',                   'Amount',           4                                     ),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_ABILITY_GRANTER',  'AbilityType', 'ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2'),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2',                   'Amount',           6                                     ),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_ABILITY_GRANTER',  'AbilityType', 'ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3'),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3',                   'Amount',           9                            );

INSERT INTO ModifierStrings
		(ModifierId,									Context,			 Text)
VALUES ('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF', 'Preview', 'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_DESC' ),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2', 'Preview', 'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER2_DESC' ),
		('MODIFIER_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3', 'Preview', 'LOC_ABILITY_HONEY_MACGUFFIN_PASSIVE_MELEE_BUFF_TIER3_DESC' );