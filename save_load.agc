

function save_game()
	upgradesDb.save( "upgrades.json" )
	resource_db.save( "resources.json" )
	ylocations.save( "locations.json" )
	//save points and points timer zombies
	game_data as integer[]
	game_dataf as float[]
	game_data.insert(points)
	game_data.insert(zombie_num)
	game_data.insert(is_auto_clicker_active)
	game_dataf.insert(auto_clicker_time)
	game_data.save( "game_data.json" )
	game_dataf.save( "game_dataf.json" )
endfunction

function load_game()
	
	if GetFileExists( "upgrades.json" ) = 0 then exitfunction
	upgradesDb.load( "upgrades.json" )
	resource_db.load( "resources.json" )
	ylocations.load( "locations.json" )
	//load points and points timer and zombies
	game_data as integer[]
	game_dataf as float[]
	game_data.load( "game_data.json" )
	game_dataf.load( "game_dataf.json" )
	
	points = game_data[0]
	zombie_num = game_data[1]
	is_auto_clicker_active = game_data[2]
	auto_clicker_time = game_dataf[0]
	edit_timer("auto_clicker",auto_clicker_time) 
	
endfunction
