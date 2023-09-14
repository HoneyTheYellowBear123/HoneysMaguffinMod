


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

	playerGroup = []
	if target == 0:
		playerGroup = [playerID]
	if target == 1:
		--get war enemies
	if target == 2:
		-- get everybody except player

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



