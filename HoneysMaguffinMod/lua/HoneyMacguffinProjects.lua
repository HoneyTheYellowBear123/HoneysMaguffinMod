


Macguffin_Cooldown_Multiple = 1 --TO DO add this as a configurable variables


---------------------------------------------------------------------------------------------------------------------
------------------------------------ HELPERS ------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

--[[
--returns relevent tiles for an effect to be applied to
function chooseRandomTiles( playerID, target, feature, terrains, resources, number, allowCities, withImprovement )

	-- whichPlayer
	-- playerID of whoever activated macguffin

	--target
	--0 for self, 1 for war enemies, 2 for random someone else, 3 for random anybody (I don't think I'll ever use 3 )

	-- whichFeature
	-- If our effect should be limited to tiles with a certain feature, make note of it here. Otherwise, be zero.

	-- number
	-- how many tiles do we want

	-- withImprovement
	-- 0 no improvements on this tile yet please, 1 only tiles with improvements, 2 we dont care


	--Pseudocode
	--for player index
		-- for cities
			-- check tiles within 3 of city center
			-- make sure to check ownership so that city centers dont get grabbed and close cities dont get doubled up
	--choose a few from this mega list randomly based on number
	--return



	--playerGroup = []
	if target == 0 then
		playerGroup = [playerID]
	end
	if target == 1 then
		--get war enemies
	end
	if target == 2 then
		-- get everybody except player
	end

	relevant_tiles = []
	for player in playerGroup do
		for city in player:GetCities()
			cityTileX = city:GetX()
			cityTileY = city:GetY()

			for X in (cityTileX - 3, cityTileX + 3) do
				for Y in (cityTileY - 3, cityTileY + 3) do
					plot = Map.GetPlot(X,Y)
					if plot then

						if not (Cities.GetCityInPlot(X,Y):GetID() == city:GetID()) then
						  break
						end

						if features != [] then --floodplains, forest, jungle, reef, marsh (in xp2 there is also flooplains grassland and floodplains plains, volcanic soil, burning forest, burnt forest)
						  if not (plot:GetFeatureType() in features) then
						    break
						  end
						end

						if terrains != [] then  --grass, desert tundra
							if not (plot:GetTerrainType() in terrains) then
							  break
							end
						end

						if resources != [] then --strategic, luxuries, bonus resources
							if not (plot:GetResourceType() in resources) then
							  break
							end
						end

						if withImprovement == 0 and plot:GetImprovementType() then  --farm, mines, quarries
						  break
						end
						if withImprovement == 1 and not plot:GetImprovementType() then
						  break
						end
						plot:GetFeatureType() 

						if allowCities and not plot:IsCity() then
						  break
						end
						
						relevant_tiles = [relevant_tiles[:] plot]
						  

					end
				end
			end
		end
	end
		
	
	return relevant_tiles
end
--]]






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




function free_builder_reward(player, tier, x, y)

	print("HoneyDebug active free builder reward was called")

	builderID = GameInfo.Units['UNIT_BUILDER'].Index;
	
	player:GetUnits():Create(UnitID, x , y)

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




