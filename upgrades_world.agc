
type yupgrade

	name as string
	desc as string
	cost
	is_active
endtype

//pagination vars
global upgradesFrom = 0
global upgradesTo = 4



global upgradesDb as yupgrade[] 
global upgradestxts as integer[]

upgradesDb.insert( createUpgrade("click add","adds 1 to your click",30) )
upgradesDb.insert( createUpgrade("click add2","adds 2 to your click",90) )
upgradesDb.insert( createUpgrade("slow auto clicker","auto clicks slowly",50) )
upgradesDb.insert( createUpgrade("find mine","find a place to mine ors and crystals",100) )
upgradesDb.insert( createUpgrade("beach location","another place to gather resources",300) )
upgradesDb.insert( createUpgrade("volcano location","another place to gather resources",150) )
upgradesDb.insert( createUpgrade("sell resources","sell resources for points",100) )
upgradesDb.insert( createUpgrade("trapper","learn to make traps",100) )
upgradesDb.insert( createUpgrade("stealth","less zombies will find you",700) )
upgradesDb.insert( createUpgrade("make atlatl","an ancient weapon from the cavemen days",300) )
upgradesDb.insert( createUpgrade("bigger traps","lure the zombies to thier doom",300) )
upgradesDb.insert( createUpgrade("alchemy","create potions",900) )
upgradesDb.insert( createUpgrade("graveyard","when you want more zombies",100) )
upgradesDb.insert( createUpgrade("fast auto clicker","clicks faster",250) )


function displayUpgrades()
	
	btn as yentity

	DeleteAllText()
	remove_by_type("upgrade_buy","upgrade")
	removeYbtnByType("upgrade_paginate_btn")
	
	//loop upgrade y from top
	topSpace = 100
	top = 100
	
	for i = upgradesFrom to upgradesTo//upgradesDb.length
		
		if upgradesDb.length < i then exit //prevent index out of bounds
		
		//btn position from top
		top = topSpace*(i+1-upgradesFrom)
		txtId = i+1
		CreateText(txtId,upgradesDb[i].name+" - "+upgradesDb[i].desc+" cost: "+str(upgradesDb[i].cost))
		SetTextSize ( txtId, 30 )
		SetTextPosition ( txtId, 30, top )
		
		//if already bought continue
		if isUpgradeActive(upgradesDb[i].name) then continue
		
		//src ,x ,y ,id ,ytype
		btn = ymake_btn2("buybtn.png",30,top+30,buyImageID,"upgrade_buy")
		btn.ystrings.insert(upgradesDb[i].name) //upgrade name
		btn.yints.insert(i) //upgrade id
		recycle("upgrade",btn)
	next i
	//(x as float,y as float,perPage,maxEntries,btnType as String, world as String)

	paginationBtnsMake(100,670,5,upgradesDb.length,"upgrade_paginate_btn","upgrade")
	
endfunction //end displayUpgrades







function clickUpgrades()
	
	btns as yentity[]	
	btns = get_by_type("upgrade_buy")
	
	//remove btn entities
	for i = 0 to btns.length
		if is_clicked(btns[i])
			//ydebug = btns[i].ystrings[0]
			if canBuyUpgrade(btns[i].ystrings[0]) = 0
				continue
			endif
			doUpgrade(btns[i].ystrings[0])
			displayUpgrades()
		endif
	next i
	
endfunction //end clickUpgrades

function clickUpgradesPagination()

	btns as ybtn[]	
	btns = getYbtnByType("upgrade_paginate_btn")
	
	
	for i = 0 to btns.length
		if ybtnReleased(btns[i])
			//ydebug = " click "
			pnum = btns[i].yints[0] //page number
			upgradesFrom = pnum*5
			upgradesTo = upgradesFrom+5-1
			displayUpgrades()
		endif
	next i
	

endfunction

function canBuyUpgrade(name as string)
	ret = 0
	btn as yupgrade
	btn = getUpgradeTypeByName(name)
	if btn.cost <= points then ret = 1
endfunction ret

function createUpgrade(name as string,desc as string,cost)
	
	u as yupgrade
	u.name = name
	u.desc = desc
	u.cost = cost
	u.is_active = 0
	
endfunction u //end createUpgrade

function doUpgrade(name as string)
	
	
	//if upgrade already active exit
	if isUpgradeActive(name) then exitfunction
	
	u as yupgrade
	u =getUpgradeTypeByName(name)
	
	if name = "click add" 
		inc clickMultiplier
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	if name = "click add2" 
		inc clickMultiplier,2
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	if name = "slow auto clicker"
		is_auto_clicker_active = 1
		setUpgradeActive(name)
		edit_timer("auto_clicker",auto_clicker_time) 
		points = points-u.cost
	endif
	if name = "fast auto clicker"
		is_auto_clicker_active = 1
		setUpgradeActive(name)
		edit_timer("auto_clicker",1) 
		auto_clicker_time = 1
		points = points-u.cost
	endif
	
	if name = "find mine" 
		makeYlocationActive("mine")
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	if name = "sell resources" 
		
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	if name = "trapper" 
		
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	
	
	
	if name = "stealth" 
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	
	if name = "make atlatl" 
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	if name = "alchemy" 
		setUpgradeActive(name)
		points = points-u.cost
	endif
	
	if name = "bigger traps" 
		setUpgradeActive(name)
		points = points-u.cost
	endif
	if name = "beach location" 
		setUpgradeActive(name)
		makeYlocationActive("beach")
		points = points-u.cost
	endif
	if name = "volcano location" 
		setUpgradeActive(name)
		makeYlocationActive("volcano")
		points = points-u.cost
	endif
	if name = "graveyard" 
		setUpgradeActive(name)
		makeYlocationActive("graveyard")
		points = points-u.cost
	endif
	
	
	
	
endfunction

function setUpgradeActive(name as string)
	
	for i = 0 to upgradesDb.length
		if upgradesDb[i].name = name then upgradesDb[i].is_active = 1
	next i
	
endfunction

function isUpgradeActive(name as string)
	
	ret = 0
	
	for i = 0 to upgradesDb.length
		if upgradesDb[i].name = name and upgradesDb[i].is_active then ret = 1
	next i
	
endfunction ret

function getUpgradeTypeByName(name as string)
	ret as yupgrade
	for i = 0 to upgradesDb.length
		if upgradesDb[i].name = name then ret = upgradesDb[i]
	next i
endfunction ret
