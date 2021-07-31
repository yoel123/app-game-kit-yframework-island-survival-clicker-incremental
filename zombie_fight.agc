
global zombie_num = 0


global backfight as yentity
global fightDoBtn as yentity
global makePitTrapbtn as yentity
global makeSpikeTrapbtn as yentity
global makeStonFallTrapbtn as yentity
global makeLogllTrapbtn as yentity

function fight_world_gui()
	
	DeleteAllText()
	remove_by_type("fight_btns","fight")
	


	
	//fight btn
	fightDoBtn = ymake_btn2("fightdo.png",20,200,fightdoImageID,"fight_btns")
	fightDoBtn.ystrings.insert("fightbtn") //name
	//if has shovel and traper upgrade
	if  has_res("wood shovel") or has_res("bronze shovel")
		//pit trap make (no need for upgrade
		makePitTrapbtn = ymake_btn2("pittrap.png",20,280,pitTrapImageID,"fight_btns")
		makePitTrapbtn.ystrings.insert("pitTrapBtn") //name
		//spike trap make	
		if isUpgradeActive("trapper")	
			makeSpikeTrapbtn = ymake_btn2("spikrtrap.png",20,360,spikeTrapImageID,"fight_btns")
			makeSpikeTrapbtn.ystrings.insert("spikeTrapBtn") //name
			recycle("fight",makeSpikeTrapbtn)
		endif
		
	endif
	
	//the best traps
	if isUpgradeActive("bigger traps")	
		
			makeStonFallTrapbtn = ymake_btn2("stonefalltrap.png",20,450,stonefallImageID,"fight_btns")
			makeStonFallTrapbtn.ystrings.insert("stoneFallTrapBtn") //name
			recycle("fight",makeStonFallTrapbtn)

			makeLogllTrapbtn = ymake_btn2("logtrap.png",20,530,logtrapImageID,"fight_btns")
			makeLogllTrapbtn.ystrings.insert("logTrapBtn") //name
			recycle("fight",makeLogllTrapbtn)
			
	endif 
	
	recycle("fight",fightDoBtn)
	recycle("fight",makePitTrapbtn)
	
	
endfunction

function fight_world_on_click()
	
	
	//onclick fight
	
	//onclick craft trap
	
	btns as yentity[]	
	btns = get_by_type("fight_btns")
	
	name as string
	
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i])
			
			ydebug =""
			
			//check btn name
			name = btns[i].ystrings[0]
			//clicked a make trap btn
		
			if name = "pitTrapBtn" then make_trap("pit trap")
			if name = "spikeTrapBtn" 
				if has_resn("fiber",3) and has_resn("wood",3) 
				 make_trap("spike trap")
				 red_res("fiber",3)
				 red_res("wood",3)
				else
					ydebug = "you need 3 fiber and 3 wood"
				endif
			endif
			//stonfall
			if name = "stoneFallTrapBtn" 
				if has_resn("net",2) and has_resn("stone",10) 
				 make_trap("falling stones trap")
				 red_res("net",2)
				 red_res("stone",10)
				 ydebug = "created a falling stones trap"
				else
					ydebug = "you net 2 nets and 10 stone"
				endif
			endif
			//logtrap
			if name = "logTrapBtn" 
				if has_resn("rope",2) and has_resn("wood",5) 
				 make_trap("hanging log trap")
				 red_res("rope",2)
				 red_res("wood",5)
				 ydebug = "created a hanging log trap"
				else
					ydebug = "you need 3 rope and 5 wood"
				endif
			endif
	
		
			if name = "fightbtn" then zombie_fight()
			
		endif
	next i
	
endfunction


//when collecting resources disrupt
function zombie_disrupt()
	ret = 0
	disrupt_num = 4 //the number of zombies you need to start disrupt
	if isUpgradeActive("stealth") then disrupt_num = 6 //need more to disrupt if has stelth
		
	//if any zombies exists
	if zombie_num>disrupt_num 
		rand = random(1,100)
		//inc rand,zombie_num
		if rand >50 then ret = 1 //zombie manged to disrupt
		zombie_trip_trap()
	endif
	//cant disrupt flaming skin
	if is_potion_activen("fire skin potion")  
		ret = 0 
		if zombie_num>0 then dec zombie_num //kill one
	endif
	//use atlatel
	if zombie_num>0 then dec zombie_num,use_ranged_weapon()
	
	//spawn new zombie
	rand2 = random(1,10)
	rand3 = random(1,10)
	randz = random(1,3)
	if isUpgradeActive("stealth")
		if rand3 <5 then exitfunction ret
		if rand2 >9 then inc zombie_num,1
	else	
		if rand2 >9 then inc zombie_num,randz
	endif
	

endfunction ret //zombie_disrupt//////

function zombie_fight()
	
	kill_zombie = 0
	ydebug = ""
	if zombie_num<=0 then exitfunction kill_zombie
	zombie_trip_trap()
	inc kill_zombie,use_ranged_weapon()
	//player power multiplier
	mult = Random(1,6)
	
	for i=0 to weapons_list.length
		mult = mult + use_weapon(weapons_list[i])
	next i
	//strangth potion active
	if is_potion_activen("strength potion")  then mult = mult*2
	
	//too many zombies
	if zombie_num > 12 then dec mult,10
	if zombie_num > 26 then dec mult,15
	if zombie_num > 30 then dec mult,20
	
	zombie_power = random(1,50)+(zombie_num/2)
	
	//if player win
	if zombie_power < mult
		kill_zombie = random(1,3) //how many zombies you killed
		//if your attack power is bigger kill more
		if zombie_power-mult > 10 then inc kill_zombie,1
		if zombie_power-mult > 20 then inc kill_zombie,3
		if zombie_power-mult > 30 then inc kill_zombie,3
		if zombie_power-mult > 50 then inc kill_zombie,9
		

	endif

	//kill zombies
	dec zombie_num,kill_zombie
	//get loot
	zombie_reward(kill_zombie)
	if zombie_num < 0 then zombie_num=0

	ydebug = "you killed "+str(kill_zombie)+" zombies. "+str(zombie_num)+" left"
	
endfunction kill_zombie //zombie_fight ////

function zombie_reward(amt)
	
	for i=0 to amt
		rnd = random(1,10)
		if rnd > 5 then inc_res("brain",1)
		if rnd > 7 then inc_res("cloth",1)
	next i
	
endfunction

function zombie_trip_trap()
	rand = 0
	if has_res("pit trap")
		rand = random(1,10)
		if rand > 5
			dec zombie_num
			res_chance_to_break("pit trap",40)
		endif
	endif
	
	if has_res("spike trap")
		rand = random(1,10)
		if rand > 3
			dec zombie_num
			res_chance_to_break("spike trap",15)
		endif
	endif
	
	if has_res("falling stones trap")
		rand = random(1,10)
		if rand > 3
			dec zombie_num,10
			if zombie_num < 0 then zombie_num=0
			res_chance_to_break("falling stones trap",70)
		endif
	endif
	
	if has_res("hanging log trap")
		rand = random(1,10)
		if rand > 2
			dec zombie_num,5
			if zombie_num < 0 then zombie_num=0
			res_chance_to_break("hanging log trap",50)
		endif
	endif
	
endfunction

function make_trap(n as string)
	

	//if bigger traps
	if n = "falling stones trap" 
		inc_res(n,1)
		ydebug = "created "+n+" trap"
		exitfunction
	endif
	if n = "hanging log trap" 
		inc_res(n,1)
		ydebug = "created "+n+" trap"
		exitfunction
	endif
	
	//if has bronze use it
	if has_res("bronze shovel")
		inc_res(n,1)
		res_chance_to_break("bronze shovel",8)
		ydebug = "created "+n+" trap"
		exitfunction
	else
		ydebug = "couldent create "+n+" trap"
	endif
	//else use wood
	if has_res("wood shovel") 
		inc_res(n,1)
		res_chance_to_break("wood shovel",20)
		ydebug = "created "+n+" trap"
		exitfunction
	
		
	endif
	ydebug = "couldent create "+n+" trap"
endfunction


function use_ranged_weapon()
	ret = 0 //zombies killed
	//have atlatele and arrows
	if has_res("atlatl") and has_res("long arrow") and random(1,10)>3
		inc ret
		red_res("long arrow",1)
	endif
	
endfunction ret
function use_weapon(n as string)
	ret = 0
	//does player have this weapon
	has_res = has_res(n)
	if has_res
		if FindStringCount(n,"hand") then  dec ret,2
		if FindStringCount(n,"stone") then inc ret,7
		if FindStringCount(n,"bronze") then inc ret,15
		if FindStringCount(n,"axe") then inc ret,12
		if FindStringCount(n,"pickaxe") then inc ret,4
		if FindStringCount(n,"hammer") then inc ret,7
		if FindStringCount(n,"club") then inc ret,15
		if FindStringCount(n,"sword") then inc ret,25
		
		//weapon break chance
		if FindStringCount(n,"stone") then res_chance_to_break(n,10)
		if FindStringCount(n,"bronze") then res_chance_to_break(n,5)
	endif
	
endfunction ret




