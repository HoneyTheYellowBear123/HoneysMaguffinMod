-- Honey_Macguffin_Passive_Government_Policies
-- Author: mitch
-- DateCreated: 8/19/2023 9:01:17 AM
--------------------------------------------------------------

-- + military slots # Trumpain (because its trump cards... get it?)
-- + economic slots # Pot of greed (because it lets you draw more cards... get it?)
-- + diplomatic slots # All Love Branch (like OLIVE BRANCH??? DO YOU GET IT???????)
-- + wildcard slots # Wildest Card (there is no joke here)


--future maybe?
-- nice military policy 1 -- bonus damage to barbarians and city states, gain lots of prizes for raiding encampment
-- nice military policy 2
-- nice economic policy 1 -- more trade routes, trade routes offer more gold
-- nice economic policy 2 -- all districts 100%, 125%, 150% adjacency bonus
-- nice diplomatic policy 1 -- spy bonus
-- nice diplomatic policy 2
-- nice wildcard 1 -- every great person points
-- nice wildcard 2 -- border growth?

--I could have these as policies or I could just have them as building bonuses



INSERT INTO Types 

		(Type, Kind)
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS',          'KIND_BUILDING'),
		
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS',          'KIND_BUILDING'),
		
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS',          'KIND_BUILDING'),
		
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2',				'KIND_GREATWORK'),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3',				'KIND_GREATWORK'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3_GP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3',          'KIND_BUILDING'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS',          'KIND_BUILDING');
		




INSERT INTO GreatPersonIndividuals
			(GreatPersonIndividualType,						Name,						GreatPersonClassType,			 eraType,					Gender,		 ActionCharges,            ActionEffectTextOverride)
VALUES ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION'),
	   ('GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3_GP', 'LOC_GREAT_PERSON_HONEY_MACGUFFIN_GP_NAME',  'GREAT_PERSON_HONEY_MACGUFFIN_GP' ,     'HONEY_MACGUFFIN_DUMMY_ERA',        'M',            0,					'LOC_GREAT_PERSON_HONEY_MACGUFFIN_ACTION');
	    


INSERT INTO GreatWorks
		(GreatWorkType,																										 Name,									      GreatPersonIndividualType,							 GreatWorkObjectType,																			 Quote ,          Tourism )
VALUES  ('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),

		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),

		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 ),
		('GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3',     'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3_NAME',   'GREAT_PERSON_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3_GP',			'GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE',										'LOC_GREATWORK_HOMER_2_QUOTE',           0 );







INSERT INTO Buildings
		(BuildingType,															Name,																Description,									 PrereqDistrict,			 AdvisorType, Cost, InternalOnly)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_MILITARY_CARD_SLOTS_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1), 

		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER2_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3', 'LOC_GREATWORK_GREATWORKOBJECT_HONEY_MACGUFFIN_PASSIVE_WILDCARD_CARD_SLOTS_TIER3_NAME', 'LOC_BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3_DESC',    'DISTRICT_CITY_CENTER',      'ADVISOR_GENERIC', 200, 1);
		






INSERT INTO Modifiers
		(ModifierId, ModifierType)
VALUES  ('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER' ),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),

		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER' ),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER' ),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3', 'MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER' );

INSERT INTO BuildingModifiers
		(BuildingType, ModifierId)
VALUES  ('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS' ),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2' ),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3'),

		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3'),
		
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3'),
		
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS'),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS' ),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2' ),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS' ),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2' ),
		('BUILDING_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3', 'MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3' );

INSERT INTO ModifierArguments
		(ModifierId, Name, Value)
VALUES  ('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS', 'GovernmentSlotType', 'SLOT_MILITARY'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER2', 'GovernmentSlotType', 'SLOT_MILITARY' ),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_MILITARY_CARD_SLOTS_TIER3', 'GovernmentSlotType', 'SLOT_MILITARY'),

		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS', 'GovernmentSlotType', 'SLOT_ECONOMIC'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER2', 'GovernmentSlotType', 'SLOT_ECONOMIC' ),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_ECONOMIC_CARD_SLOTS_TIER3', 'GovernmentSlotType', 'SLOT_ECONOMIC'),
		
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS', 'GovernmentSlotType',  'SLOT_DIPLOMATIC'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER2', 'GovernmentSlotType',  'SLOT_DIPLOMATIC'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_DIPLOMATIC_CARD_SLOTS_TIER3', 'GovernmentSlotType',  'SLOT_DIPLOMATIC'),
		
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS', 'GovernmentSlotType', 'SLOT_WILDCARD'),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER2', 'GovernmentSlotType',  'SLOT_WILDCARD' ),
		('MODIFIER_HONEY_MACGUFFIN_HOLDER_PASSIVE_WILDCARD_CARD_SLOTS_TIER3', 'GovernmentSlotType',  'SLOT_WILDCARD' );
		


