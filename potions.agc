
//potion counter (to count its duration)
global potion_counter = 2 //usually starts at 0
//max use (maximup potion duration)
global potion_counter_max = 1


//current/active potion name
global current_potion as String
current_potion = "none"

//show pothions
function show_potion_list(x,y)
	restxtid = 1
	
	btn as yentity
	DeleteAllText()
	remove_by_type("use_potion","potionw")
	top = 50
	res as resource
	for i=0 to resource_db.length
		res = resource_db[i]
		
		//show only potions
		if FindStringCount(res.name,"potion") = 0 then continue
		
		top = top+100
		
		CreateText(restxtid," "+resource_db[i].name+" amount: "+str(res.amount))
		SetTextSize ( restxtid, 30 )
		SetTextPosition ( restxtid, x, y+top )
		inc restxtid
		
		//no potion dont create use btn
		if has_res(resource_db[i].name) =0 then continue
		//src ,x ,y ,id ,ytype
		btn = ymake_btn2("use.png",x+340,y+top-10,useImageID,"use_potion")
		btn.ystrings.insert(resource_db[i].name) //res name
		btn.yints.insert(i) //res id (index)
		recycle("potionw",btn)
		
	next i
endfunction

//click potion to use it
function click_potion_list()
	
	btns as yentity[]	
	btns = get_by_type("use_potion")
	potionName as string
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i]) //use clicked
			//if has potion name in resource db
			potionName = btns[i].ystrings[0]
			if has_res(potionName) 
				//reduce potion amount
				red_res(potionName,1)
				//set as new potion effect
				current_potion = potionName
				//reset counter
				potion_counter = 0
				//max use (maximup potion duration)
				potion_counter_max = 14
				show_potion_list(50,50)
				ydebug ="you drank "+potionName
			endif
		endif
	next i
	
endfunction

//incrament potion counter and reset it
function inc_potion()
	
	if is_potion_active() = 0  
		current_potion = "none"
		exitfunction
	endif
	
	inc potion_counter
	
endfunction

//is potion active
function is_potion_active()
	ret = 0
	if potion_counter <= potion_counter_max then ret = 1
endfunction ret

//is potion active with name
function is_potion_activen(name as string)
	ret = 0

	if potion_counter<= potion_counter_max and name = current_potion  
		 ret = 1
		 inc_potion()
	endif
endfunction ret
