

function save_game()
	//if its an html5 build
	if yisHtml5
		upstr as String
		resstr as String
		upstr = upgrades_to_str()
		resstr = res_to_str()
		SaveSharedVariable("yupgrades",upstr)
		SaveSharedVariable("yresources",resstr)
		SaveSharedVariable("ypoints",str(points))
		SaveSharedVariable("yzombie_num",str(zombie_num))
		SaveSharedVariable("yis_auto_clicker_active",str(is_auto_clicker_active))
		SaveSharedVariable("yauto_clicker_time",str(auto_clicker_time))
		exitfunction
	endif
	
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
	//if its an html5 build
	if yisHtml5
		upstr as String
		resstr as String
		upstr = LoadSharedVariable("yupgrades","")
		resstr = LoadSharedVariable("yresources","")
		str_to_upgrades(upstr)
		str_to_res(resstr)
		
		points = val( LoadSharedVariable("ypoints","") )
		zombie_num = val( LoadSharedVariable("yzombie_num","") )
		is_auto_clicker_active = val( LoadSharedVariable("yis_auto_clicker_active","") )
		auto_clicker_time = val( LoadSharedVariable("yauto_clicker_time","") )
		edit_timer("auto_clicker",auto_clicker_time) 
		exitfunction
	endif
	
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
