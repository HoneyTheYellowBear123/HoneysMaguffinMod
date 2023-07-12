-- Honey_Macguffin_Passive_FlatYields
-- Author: HoneyTheBear
-- DateCreated: 7/9/2023 10:08:49 PM
--------------------------------------------------------------

--simplest possible, passive macguffins that just give a nice yield.


-- to do
	-- culture
	-- gold
	-- faith
	-- production
	-- food


INSERT INTO Types 

		(Type, Kind)
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE',          'KIND_BUILDING');



INSERT INTO GreatPersonIndividuals
			(GreatPersonIndividualType,						Name,						GreatPersonClassType,			 eraType,					Gender,		 ActionCharges,            ActionEffectTextOverride)
VALUES ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION');

INSERT INTO GreatWorks
		(GreatWorkType,																										 Name,									      GreatPersonIndividualType,							 GreatWorkObjectType,																			 Quote ,          Tourism )
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 );

--INSERT INTO GreatWork_YieldChanges
--		(GreatWorkType,							 YieldType, YieldChange)
--VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_FLAT_SCIENCE', 'YIELD_SCIENCE', 0);


INSERT INTO Buildings
		(BuildingType,															Name,																Description,									 PrereqDistrict,			 AdvisorType, Cost, InternalOnly)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1); 

INSERT INTO Building_YieldChanges
		(BuildingType,												YieldType,			YieldChange)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_FLAT_SCIENCE', 'YIELD_SCIENCE',              7 );

