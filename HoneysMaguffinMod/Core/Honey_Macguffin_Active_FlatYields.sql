-- Honey_Macguffin_Active_FlatYields
-- Author: Honey The Bear
-- DateCreated: 7/17/2023 6:29:11 PM
--------------------------------------------------------------


INSERT INTO Types 

		(Type, Kind)
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE',				'KIND_GREATWORK'), --7
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER2',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER3',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE',          'KIND_BUILDING'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE',                    'KIND_PROJECT'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2',                    'KIND_PROJECT'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3',                    'KIND_PROJECT');



INSERT INTO GreatPersonIndividuals
			(GreatPersonIndividualType,						Name,						GreatPersonClassType,			 eraType,					Gender,		 ActionCharges,            ActionEffectTextOverride)
VALUES ('GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION');

INSERT INTO GreatWorks
		(GreatWorkType,																										 Name,									      GreatPersonIndividualType,							 GreatWorkObjectType,																			 Quote ,          Tourism )
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE',			'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_NAME',		  'GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 );

INSERT INTO Buildings
		(BuildingType,															Name,																Description,									 PrereqDistrict,			 AdvisorType, Cost, InternalOnly)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER2', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER2_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER3', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER3_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1);  


INSERT INTO Projects
		(ProjectType,										Name,												 ShortName,													 Description,					Cost, AdvisorType,        RequiredBuilding)
VALUES  ('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE',		  'PROJECT_HONEY_MACGUFFIN_ACTIVE_NAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_SHORTNAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_DESC',         2,  'ADVISOR_GENERIC', 'BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_NAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_SHORTNAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2_DESC',         2,  'ADVISOR_GENERIC', 'BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER2'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_NAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_SHORTNAME', 'PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3_DESC',         2,  'ADVISOR_GENERIC', 'BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER3');
	

INSERT INTO Projects_XP2
		(ProjectType,								 RequiredBuilding)
VALUES  ('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE', 'BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER2', 'BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER2'),
		('PROJECT_HONEY_MACGUFFIN_ACTIVE_FLAT_SCIENCE_TIER3', 'BUILDING_HONEY_MACGUFFIN_HOLDER_ACTIVE_FLAT_SCIENCE_TIER3');