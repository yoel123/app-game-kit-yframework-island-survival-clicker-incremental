
type craft_recipe
	name as String
	resources as String[]
	amounts as integer[]
	tools as String[]
	desc as String
endtype


global recipes as craft_recipe[]

global recipesFrom =0
global recipesTo =4


recipes.insert(create_recipe("stone hand hammer","stone","2","stone","its a premtive stone hammer"))
recipes.insert(create_recipe("stone hand axe","stone","3","stone","its a premtive stone axe"))
recipes.insert(create_recipe("stone axe","fiber,wood,stone","1,1,3","stone","its a premtive stone axe with handle"))
recipes.insert(create_recipe("fiber","twig","2","stone hand axe","premtive rope"))
recipes.insert(create_recipe("stone hammer","fiber,wood,stone","1,1,2","","premtive hammer with handle"))
recipes.insert(create_recipe("forg","wood,stone","5,15","stone hammer","used to forge metal tools"))
recipes.insert(create_recipe("bronze","tin ore,copper ore","1,1","forg","strong alloy for making tools"))
recipes.insert(create_recipe("stone pickaxe","fiber,wood,stone","1,1,2","","a tool for mining"))
recipes.insert(create_recipe("wood shovel","fiber,wood","2,3","stone axe","a tool for digging"))
recipes.insert(create_recipe("wood spear","wood","2","stone hand axe","basic but effective weapon"))
recipes.insert(create_recipe("bronze shovel","fiber,wood,bronze","2,2,2","stone hammer,forg","a better tool for digging(for pit traps and collecting sand)"))
recipes.insert(create_recipe("bronze sword","bronze,fiber,stone","4,2,2","stone hammer,forg","a better tool for killing zombies"))
recipes.insert(create_recipe("bronze axe","bronze,fiber,stone","3,2,2","stone hammer,forg","a better tool for choping wood"))
recipes.insert(create_recipe("bronze pickaxe","bronze,fiber,stone","5,2,2","stone hammer,forg","a better tool for mining"))
recipes.insert(create_recipe("atlatl","wood,stone","1,1","forg","a weapon for throwing long arrows"))
recipes.insert(create_recipe("long arrow","wood,obsidian,fiber","1,1,1","","a long arrows for atlatl"))
recipes.insert(create_recipe("obsidian knife","obsidian","2","","10 times sharper then steel but still glass"))
recipes.insert(create_recipe("glass vial","sand","1","forg","a container to hold potions"))
recipes.insert(create_recipe("speed potion","glass vial,haste seed","1,3","","makes you faster"))
recipes.insert(create_recipe("strength potion","glass vial,power seed","1,5","","your strength have doubled"))
recipes.insert(create_recipe("fire skin potion","glass vial,volcanic flower","1,4","","no one can touch you"))
recipes.insert(create_recipe("crafting potion","glass vial,black mushroom","1,6","","double crafting"))
recipes.insert(create_recipe("mineral sight potion","glass vial,pike seed","1,5","","you find more mineral/ores"))
recipes.insert(create_recipe("net","fiber","8","bronze axe","premtive net"))
recipes.insert(create_recipe("rope","fiber","10","bronze axe","an actual rope"))
recipes.insert(create_recipe("sail","fiber,cloth","7,15","bronze axe","an actual rope"))
recipes.insert(create_recipe("barrel","wood,bronze","5,1","bronze axe","a container for stuff you will take on the ship"))
recipes.insert(create_recipe("long boat","wood,bronze,barrel,rope,net,sail","50,10,5,5,3,2","bronze axe,forg,stone hammer,stone hand axe","your way out of the island"))


function create_recipe(n as string,res as string,amountr as string,ts as string,desc as string)
	
	name as String
	resources as String[]
	amounts_s as String[]
	amounts as integer[]
	tools as String[]
	recipe as craft_recipe
	
	
	resources = split(res,",")
	tools = split(ts,",")
	amounts_s = split(amountr,",")
	//convert amounts strig array to amounts int array
	for i=0 to amounts_s.length
		amounts.insert( val( amounts_s[i] ) )
	next i
	
	//set atts
	recipe.name = n
	recipe.resources = resources
	recipe.amounts = amounts
	recipe.tools = tools
	recipe.desc = desc
	
	//recipes.insert(recipe)
	
endfunction recipe //end create_recipe

//get recipe by name
function get_recipe(n as string)
	recipe as craft_recipe
	
	for i=0 to recipes.length
		if recipes[i].name = n then recipe = recipes[i]
	next i
	
endfunction recipe

function can_craft(n as string)
	recipe as craft_recipe
	cr as resource //current resource
	recipe = get_recipe(n)
	ret = 0
	//check if can craft
	for i=0 to recipe.resources.length
		cr = get_res(recipe.resources[i])
		//if no resource or less then amount needed craft faield-----------
		if cr.amount <=0 or cr.amount < recipe.amounts[i] then exitfunction ret 
	next i	
	
	//check if has tools
	for i=0 to recipe.tools.length
		cr = get_res(recipe.tools[i])
		//if no tool  craft faield--------
		if cr.amount <=0 then exitfunction ret 
	next i
	
	ret = 1
	
endfunction ret

//recepie tools requires ad string
function craftRecAsString(c as craft_recipe)
	ret as String
	for i=0 to c.tools.length
		ret = ret+c.tools[i]+", "
	next i
endfunction ret

function craft(n as string)
	success =0
	recipe as craft_recipe
	cr as resource //current resource
	recipe = get_recipe(n)

	if can_craft(n) = 0 then exitfunction success 
	//do sucsess
	//reduce resources
	for i=0 to recipe.resources.length
		red_res(recipe.resources[i],recipe.amounts[i])
	next i	
	//add new item
	inc_res(n,1)
	//craft two if crafting potion is active
	if is_potion_activen("crafting potion") then inc_res(n,1)
	//set success to true
	success = 1
	
endfunction success


function craft_items_view()
	
	btn as yentity
	res as resource
	DeleteAllText()
	remove_by_type("craft_do","craft")
	remove_by_type("dont_craft","craft")
	removeYbtnByType("craft_paginate_btn")
	
	//loop upgrade y from top
	topSpace = 100
	top = 100
	
	for i = recipesFrom to recipesTo
		
		if recipes.length < i then exit
		
		name as string
		name = recipes[i].name
		
		can_craft as String
		can_craft = "craft_do"
		//get resource by name
		res = get_res(recipes[i].name)
		//cant craft dont show
		if not can_craft(recipes[i].name) then can_craft = "dont_craft"
		
		
		//stuff you can craft only if you have the upgrade
		if name = "atlatl" and isUpgradeActive("make atlatl") = 0 then continue
		if name = "long arrow" and isUpgradeActive("make atlatl") = 0 then continue
		if FindStringCount(name,"potion") and isUpgradeActive("alchemy") =0 then continue
		
		//btn position from top
		top = topSpace*(i+1-recipesFrom)
		txtId = i+1
		CreateText(txtId,recipes[i].name+" ("+str(res.amount)+") - "+recipes[i].desc)
		SetTextSize ( txtId, 30 )
		SetTextPosition ( txtId, 30, top )
		
		//create craft btn
		//src ,x ,y ,id ,ytype
		btn = ymake_btn2("craftdo.png",30,top+30,craftDoImageID,can_craft)
		btn.ystrings.insert(recipes[i].name) //upgrade name
		btn.yints.insert(i) //upgrade id
		recycle("craft",btn)
		
		//if cant craft gray out
		if can_craft ="dont_craft" then SetSpriteColor(btn.id,169,169,169,60)
		
	next i
	//(x as float,y as float,perPage,maxEntries,btnType as String, world as String)

	paginationBtnsMake(100,670,5,recipes.length,"craft_paginate_btn","craft")

	
endfunction //end craft_items_view


function clickcraftPagination()

	btns as ybtn[]	
	btns = getYbtnByType("craft_paginate_btn")
	
	
	for i = 0 to btns.length
		if ybtnReleased(btns[i])
			//ydebug = " click "
			pnum = btns[i].yints[0] //page number
			recipesFrom = pnum*5
			recipesTo = recipesFrom+5-1
			craft_items_view()
		endif
	next i
	

endfunction

function clickCraft()
	
	btns as yentity[]	
	btns = get_by_type("craft_do")
	
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i])
			//ydebug = ydebug+btns[i].ystrings[0]
			//try crafting btns first string (holds the craft item name
			if craft(btns[i].ystrings[0]) 
				 ydebug = "crafted: "+btns[i].ystrings[0]
				 craft_items_view()
			else
				ydebug = "crafting failed (not enough resources)"
			endif 
			
		endif
	next i
	
endfunction //end clickUpgrades

function clickCantCraft()
	
	btns as yentity[]	
	btns = get_by_type("dont_craft")
	r as craft_recipe
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i])
				ydebug ="you need "
				//ger recipie
				r = get_recipe(btns[i].ystrings[0])
				for j=0 to r.resources.length
					ydebug = ydebug+" "+r.resources[j]+" ("+str(r.amounts[j])+") ,"
					
				next j
				//print requirments
				if r.tools.length >-1 then ydebug = ydebug+chr(10)+" requires "+ craftRecAsString(r)
				ydebug = ydebug+" to craft "+btns[i].ystrings[0]
			 
			
		endif
	next i
	
endfunction //end clickUpgrades
