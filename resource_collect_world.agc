


////////////////resource class//////////////////////
type resource
	name as String
	amount
	pointval
endtype

global weapons_list as string[]

weapons_list = ["stone hand axe","stone axe","stone hammer","stone pickaxe","bronze pickaxe","bronze sword","bronze axe","bronze shovel"]

global resource_db as resource[]
make_res("twig",0,5)
make_res("stone",5,7)
make_res("stone hand hammer",1,13)
make_res("stone hand axe",1,13)
make_res("stone axe",0,25)
make_res("fiber",0,10)
make_res("wood",1,10)
make_res("wood shovel",0,10)
make_res("wood spear",0,10)
make_res("stone hammer",0,25)
make_res("forge",0,150)
make_res("copper ore",0,10)
make_res("tin ore",0,10)
make_res("bronze",0,25)
make_res("bronze shovel",0,25)
make_res("bronze sword",0,125)
make_res("bronze axe",0,100)
make_res("stone pickaxe",0,25)
make_res("bronze pickaxe",0,90)
make_res("pit trap",10,5)
make_res("spike trap",0,5)
make_res("falling stones trap",0,50)
make_res("hanging log trap",0,50)
make_res("brain",0,30)
make_res("cloth",0,20)
make_res("obsidian",0,40)
make_res("obsidian knife",0,50)
make_res("atlatl",0,80)
make_res("long arrow",0,50)
make_res("sand",0,20)
make_res("glass vial",0,40)
make_res("haste seed",0,30)
make_res("power seed",0,40)
make_res("volcanic flower",0,40)
make_res("black mushroom",0,40)
make_res("pike seed",0,40)
make_res("speed potion",0,50)
make_res("strength potion",0,80)
make_res("fire skin potion",0,60)
make_res("crafting potion",0,110)
make_res("mineral sight potion",0,110)
make_res("net",0,50)
make_res("rope",0,50)
make_res("barrel",0,50)
make_res("sail",0,50)
make_res("long boat",0,0)

function make_res(n as string, a,pval)
	
	res as resource
	res.name = n
	res.amount = a
	res.pointval = pval
	resource_db.insert(res)
endfunction res

//set resource
function set_res(n as string,a)
	
	for i=0 to resource_db.length
		if resource_db[i].name = n then resource_db[i].amount = a
	next i
	
endfunction

//incrament resource
function inc_res(n as string,a)
	
	for i=0 to resource_db.length
		if resource_db[i].name = n then resource_db[i].amount = resource_db[i].amount + a
	next i
	
endfunction
//reduce resource
function red_res(n as string,a)
	
	for i=0 to resource_db.length
		if resource_db[i].name = n then resource_db[i].amount = resource_db[i].amount - a
	next i
	
endfunction

//get resource by name
function get_res(n as string)
	
	res as resource
	for i=0 to resource_db.length
		if resource_db[i].name = n 
			 res =resource_db[i]
			 exitfunction res
		endif
	next i	
endfunction res

//check if has resource by name
function has_res(n as string)
	
	ret = 0
	for i=0 to resource_db.length
		if resource_db[i].name = n and resource_db[i].amount>0 
			 res =1
			 exitfunction res
		endif
	next i	
	
endfunction ret

//check if has resource by an amount
function has_resn(n as string,num)
	
	ret = 0
	for i=0 to resource_db.length
		if resource_db[i].name = n and resource_db[i].amount>=num 
			 res =1
			 exitfunction res
		endif
	next i	
	
endfunction ret

//resource chance to break chack/do, by name and chance to break
function res_chance_to_break(n as string, chance)
	ret = 0
	res as resource
	res = get_res(n)
	rand1 = random(1,200)
	rand2 = random(1,100)
	if isUpgradeActive("master crafter")  and rand2>30 then exitfunction 0 //
	if rand1 <= chance //it broke
		ret = 1
		red_res(n,1)
		//if its a bronze item you have 50% chance to get the bronze back
		if FindStringCount(n,"bronze") and rand2<50 then inc_res("bronze",1)
		//broken log
		if worlds[current_worldi].name="colres"
			amt = res.amount//reduce amount to show
			dec amt
			bokenlogs = bokenlogs+n+" was broken, you have: "+str(amt)+chr(10)+chr(13)
			SetVirtualButtonVisible(broken.id,1)
			SetVirtualButtonActive(broken.id,1)
		endif
	endif //rand1 <= chance 
endfunction ret

////////////////end resource class//////////////////////



////////////////resource world click events//////////////



function resource_world_btns_init()
	//declare btns
	global backcolres as yentity
	global collect_forrest as yentity
	global collect_mine as yentity
	global collect_beach as yentity
	global collect_volcano as yentity
	global graveyardbtn as yentity
	global potionbtn as yentity
	
	//remove old ones 
	remove_by_type("colresbtn","colres")
	//back btn add
	backcolres = ymake_btn2("backbtn.png",backx,35,backImageID,"colresbtn")

	//forrest btn
	collect_forrest = ymake_btn2("visitwoods.png",50,135,visitWoodsImageID,"colresbtn")
	
	//if has mine upgrade add mine btn
	if isUpgradeActive("find mine")
		collect_mine = ymake_btn2("mine.png",490,135,mineImageID,"colresbtn")
		recycle("colres",collect_mine)
	endif
	
	if isUpgradeActive("beach location")
		collect_beach = ymake_btn2("beach.png",490,235,beacImageID,"colresbtn")
		recycle("colres",collect_beach)
	endif
	
	if isUpgradeActive("alchemy")
		potionbtn = ymake_btn2("potions.png",50,435,potionsImageID,"colresbtn")
		recycle("colres",potionbtn)
	endif
	
	
	
	if isUpgradeActive("volcano location")
		collect_volcano = ymake_btn2("volcano.png",50,235,volcanoImageID,"colresbtn")
		recycle("colres",collect_volcano)
	endif
	
	if isUpgradeActive("graveyard")
		graveyardbtn = ymake_btn2("graveyard.png",50,335,graveyardImageID,"colresbtn")
		recycle("colres",graveyardbtn)
	endif
	
	//show log btn
	if len(bokenlogs)>0
			SetVirtualButtonVisible(broken.id,1)
		else
			SetVirtualButtonVisible(broken.id,0)
			SetVirtualButtonActive(broken.id,0)
	endif
	
	
	//add back and forest btns
	recycle("colres",backcolres)
	recycle("colres",collect_forrest)
	
endfunction



function resource_world_click()

	
	clicked_forest()
	mine_clicked()
	beach_clicked()
	volcano_clicked()
	//go to potions
	if is_clicked(potionbtn) 
		 changeworld("potionw") 
		 show_potion_list(50,50)
	endif
	//graveyard click
	if is_clicked(graveyardbtn) 
		if  buy_with_points(10)
			inc zombie_num,random(1,5)
			ydebug = "you found zombies"
		endif
	endif

	//click broken red btn
	btns as ybtn[]
	btns = getYbtnByType("brokenbtn")
	for i=0 to btns.length
		if ybtnReleased(btns[i]) 
			 changeworld("brokenlog") 
			 CreateText(1,bokenlogs)
			 SetTextSize ( 1, 30 )
			 SetTextPosition ( 1, 30, 150 )
			 SetTextColor(1,255,0,0,255)
			 bokenlogs = ""
			 SetVirtualButtonVisible(broken.id,0)
			 SetVirtualButtonActive(broken.id,0)
			
		endif
	next i
endfunction

function clicked_forest()
		
		res as resource
		//if visit forrest clicked
		if is_clicked(collect_forrest) 
			ydebug =""
			//reduce 10 points to visit forrest
			if  buy_with_points(5)
				
				//check if zombies disrupt
				if zombie_disrupt()
					ydebug = "zombies disrupted your resource gathering"
					exitfunction
				endif
				//by defult find nothing
				ydebug = "found nothing in the woods"
				//1- 100 dice throw
				rand1 = random(1,100)
				//try getting a random resource
				get_random_res("you found two sticks!",60,80,rand1,"twig",2)
				get_random_res("you found a rock!",80,95,rand1,"stone",2)
				get_random_res("you found a stick!",90,100,rand1,"twig",1)
				get_random_res("you found a three sticks!",97,100,rand1,"twig",3)
				get_random_res("you found a haste seed!",37,40,rand1,"haste seed",1)
				
				res = get_res("bronze axe")
				if res.amount>0 
					 get_random_res("you choped 4 wood!",60,100,rand1,"wood",4)
					 res_chance_to_break(res.name,5) 
					 exitfunction //use only the best tool
				endif
				
				res = get_res("stone axe")
				if res.amount>0 
					 get_random_res("you choped 2 wood!",60,100,rand1,"wood",2)
					 res_chance_to_break(res.name,9) 
					 exitfunction //use only the best tool
				endif
				
				//if has axes you can chop wood
				res = get_res("stone hand axe")
				if res.amount>0 
					 get_random_res("you choped wood!",80,100,rand1,"wood",1)
					 res_chance_to_break(res.name,10) 
					 exitfunction //use only the best tool
				endif

			else
				ydebug = "you need at least 10 points to collect resources"

			endif

		endif
	
endfunction //clicked_forest

function mine_clicked()
		
		res as resource
		//same as visit forrest click
		if is_clicked(collect_mine) 

			if  buy_with_points(10)
				
				if zombie_disrupt()
					ydebug = "zombies disrupted your resource gathering"
					exitfunction
				endif
				
				
				ydebug = "found nothing in the mine area"
				rand1 = random(1,100)
				get_random_res("you found two rocks!",60,80,rand1,"stone",2)
				get_random_res("you found a rock!",80,100,rand1,"stone",1)
				get_random_res("you found a black mushroom!",37,40,rand1,"black mushroom",1)

				
				//if has stone picke axe mine ores
				res = get_res("bronze pickaxe")
				if res.amount>0 
					get_random_res("you mined 2 copper ore!",40,100,rand1,"copper ore",2)
					 get_random_res("you mined 4 rocks!",80,100,rand1,"stone",4)
					 rand2 = random(1,100)
					 get_random_res("you mined tin ore!",40,100,rand2,"tin ore",2)
					 
					 //if mineral sight potion is active get double the ore
					 if is_potion_activen("mineral sight potion")
						 get_random_res("you mined 2 copper ore!",40,100,rand1,"copper ore",2)
						 get_random_res("you mined tin ore!",40,100,rand2,"tin ore",2) 
					 endif
					 res_chance_to_break(res.name,4) 
					 exitfunction //use only the best tool
				endif
				
				//if has stone picke axe mine ores
				res = get_res("stone pickaxe")
				if res.amount>0 
					
					 get_random_res("you mined copper ore!",40,100,rand1,"copper ore",1)
					 get_random_res("you mined 3 rocks!",80,100,rand1,"stone",3)
					 rand2 = random(1,100)
					 get_random_res("you mined tin ore!",40,100,rand2,"tin ore",1)
					 if is_potion_activen("mineral sight potion")
						get_random_res("you mined copper ore!",40,100,rand1,"copper ore",1)
						get_random_res("you mined tin ore!",40,100,rand2,"tin ore",1)
					 endif
					 res_chance_to_break(res.name,9) 
					 exitfunction //use only the best tool
				endif
				
							
				//if has hammer can try to mine ors
				res = get_res("stone hammer")
				if res.amount>0 
					 get_random_res("you mined copper ore!",60,100,rand1,"copper ore",1)
					 rand2 = random(1,100)
					 get_random_res("you mined tin ore!",60,100,rand2,"tin ore",1)
					 res_chance_to_break(res.name,19) 
				endif
				
							
				//if has hammer can try to mine ors
				res = get_res("stone hand hammer")
				if res.amount>0 
					 get_random_res("you mined copper ore!",60,100,rand1,"copper ore",1)
					 rand2 = random(1,100)
					 get_random_res("you mined tin ore!",60,100,rand2,"tin ore",1)
					 res_chance_to_break(res.name,30) 
				endif
			else
				ydebug = "you need at least 10 points to collect resources"

			endif

		endif
endfunction //mine_clicked

function beach_clicked()
		
		res as resource
		if is_clicked(collect_beach) 
			if  buy_with_points(10)
							
				if zombie_disrupt()
					ydebug = "zombies disrupted your resource gathering"
					exitfunction
				endif
				ydebug = "found nothing in the beach area"
				rand1 = random(1,100)
				get_random_res("you collected alot of sand!(2)",60,80,rand1,"sand",2)
				get_random_res("you collected sand!",80,90,rand1,"sand",1)
				get_random_res("you found a power seed!",37,40,rand1,"power seed",1)
				get_random_res("you found a pike seed!",26,36,rand1,"pike seed",1)
			

				
			
				//if has bronze shovel
				res = get_res("bronze shovel")
				if res.amount>0 
					get_random_res("you collected alot of sand!(3)",10,100,rand1,"sand",3)
					 res_chance_to_break(res.name,10) 
					  exitfunction //use only the best tool
				endif
				
				//if has wood shovel
				res = get_res("wood shovel")
				if res.amount>0 
					get_random_res("you collected alot of sand!(3)",10,100,rand1,"sand",3)
					 res_chance_to_break(res.name,30) 
				endif
			else
				ydebug = "you need at least 10 points to collect resources"
			endif
		endif

endfunction

function volcano_clicked()
		
		res as resource
		if is_clicked(collect_volcano) 
			if  buy_with_points(10)
								
				if zombie_disrupt()
					ydebug = "zombies disrupted your resource gathering"
					exitfunction
				endif
				
				ydebug = "found nothing in the volcano area"
				rand1 = random(1,100)
				get_random_res("you found obsidian!",50,90,rand1,"obsidian",1)
				get_random_res("you found two obsidian!",40,50,rand1,"obsidian",2)
				get_random_res("you found a volcanic flower!",35,40,rand1,"volcanic flower",1)
			else
				ydebug = "you need at least 10 points to collect resources"
			endif
		endif


endfunction


function get_random_res( sr as string,yfrom,yto,rnd,reward as String,amount)
	ret = 0

	if rnd >yfrom and rnd<yto
		ydebug = sr
		inc_res(reward,amount)
		if is_potion_activen("speed potion") 
			 inc_res(reward,amount)
			 ydebug = ydebug+" doubled by speed potion"
		endif
		ret = 1
	endif
	
endfunction ret

global restxtid = 1

function show_resources(x,y)
	restxtid = 1 //resourse text id
	//remove everything
	btn as yentity
	DeleteAllText()
	remove_by_type("sell_res","showres")
	remove_by_type("sell10_res","showres")
	//set top y to resourse scroll top
	top = 50+res_scroll.top
	res as resource
	//loop all resources
	for i=0 to resource_db.length
		//if its active show it
		if resource_db[i].amount>0
			top = top+70
			if top <38 then continue
			res = resource_db[i]
			CreateText(restxtid,str(i+1)+") "+resource_db[i].name+" amount: "+str(res.amount))
			SetTextSize ( restxtid, 30 )
			SetTextPosition ( restxtid, x, y+top )
			inc restxtid
			//sell btn
			if isUpgradeActive("sell resources")
				//src ,x ,y ,id ,ytype
				btn = ymake_btn2("sell.png",x+340,y+top-10,sellImageID,"sell_res")
				btn.ystrings.insert(resource_db[i].name) //res name
				btn.yints.insert(i) //res id (index)
				recycle("showres",btn)
				SetSpriteScale(btn.id,0.4,1)
				//sell 10
				btn = ymake_btn2("sellten.png",x+500,y+top-10,sell10ImageID,"sell10_res")
				btn.ystrings.insert(resource_db[i].name) //res name
				btn.yints.insert(i) //res id (index)
				recycle("showres",btn)
				SetSpriteScale(btn.id,0.4,1)
			endif
		endif
	next i
	
endfunction


function sell_res_click()

	btns as yentity[]	
	btns = get_by_type("sell_res")
	
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i])
			
			sell_points = sell_res_do( btns[i].ystrings[0]) //sell res by name
			ydebug = "sold 1 "+btns[i].ystrings[0]+" for: "+str(sell_points)+" points"
		endif
	next i
	
	//sell 10 click event
	btns = get_by_type("sell10_res")
	
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i])
			
			sell_points = sell_res_don( btns[i].ystrings[0],10) //sell res by name
			if sell_points = 0 then exitfunction
			ydebug = "sold 10 "+btns[i].ystrings[0]+" for: "+str(sell_points)+" points"
		endif
	next i

endfunction

function sell_res_do( n as string )
	res as resource
	res = get_res(n)
	rand = random(1,res.pointval)
	red_res(n,1)
	inc points,rand
	show_resources(30,55)

endfunction rand

function sell_res_don( n as string,num )
	res as resource
	res = get_res(n)
	if res.amount<10 then exitfunction 0
	rand = random(1,res.pointval)*num
	red_res(n,num)
	inc points,rand
	show_resources(30,55)

endfunction rand


////////////////html5 hrlpers///////////
function res_to_str()
	ret as string
		
	for i = 0 to resource_db.length//upgradesDb.length

		ret = ret+str(resource_db[i].amount)+","
	next i

endfunction ret

function str_to_res(s as string)
	splitArray as String[]
	splitArray = split(s,",")
	for i = 0 to resource_db.length//upgradesDb.length

		resource_db[i].amount = val(splitArray[i])
	next i

endfunction 
