
// Project: clicker game AGK yframework 
// Created: 2021-05-20

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "clicker game AGK yframework" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

#insert "yengine2d.agc"
#insert "upgrades_world.agc"
#insert "resource_collect_world.agc"
#insert "crafting_world.agc"
#insert "zombie_fight.agc"
#insert "potions.agc"
#insert "loader.agc"
#insert "save_load.agc"
#insert "instractions_and_credits.agc"



global virtualBtnId = 1

global points = 0

global yisHtml5 = 0

global bokenlogs as string
global broken as ybtn

//init vars
gamew as yworld
menuw as yworld
instractionsw as yworld
creditsw as yworld
upgradew as yworld
colresw as yworld //collect resources world
showresw as yworld //show resources world
craftw as yworld 
fightw as yworld 
potionsw as yworld 
winw as yworld 
brokelogw as yworld 
//worlds
gamew = newyworld("game")
menuw = newyworld("menu")
creditsw = newyworld("credits")
instractionsw = newyworld("instractions")
upgradew = newyworld("upgrade")
colresw = newyworld("colres")
showresw = newyworld("showres")
craftw = newyworld("craft")
fightw = newyworld("fight")
potionsw = newyworld("potionw")
winw = newyworld("win")
brokelogw = newyworld("brokenlog")

///////////////////////////buttons///////////////

//entities

//menu world btns
global startGameBtn as yentity
global creditsBtn as yentity
global instractionsBtn as yentity


//credits
global startGameCreditsBtn as yentity
global contactmeCreditsBtn as yentity
//instractions
global startGameinstructBtn as yentity

//game world btns
global button as yentity
global upgradesBtn as yentity
global collectResourses as yentity
global showResourses as yentity
global craftItem as yentity
global fightwbtn as yentity
global savebtn as yentity
global loadbtn as yentity
global GameinstructBtn as yentity
global gameCreditsBtn as yentity
//back btns
global backUpgrades as yentity
global backShowres as yentity
global backCraft as yentity
global backpotion as yentity
global backbroken as yentity


global clickMultiplier = 1 //the amount of points add for each click

//get middle of the screen
x as float
x = getWindowWidth()/2 - getImageWidth(buttonImageID)/2
y as float
y = getWindowHeight()/2 - getImageHeight(buttonImageID)/2

//main click btn
button = newyentity(820, 350, 9999999999999999999, buttonImageID)


//menu btns


startGameBtn = ymake_btn("startgame.png",200,200,startGameImageID,"menu") 
instractionsBtn = ymake_btn("instractions.png",210,300,instractionsImageID,"menu") 
creditsBtn = ymake_btn("credits.png",200,400,creditsImageID,"menu") 

//credits btns
startGameCreditsBtn = ymake_btn("startgame.png",400,300,startGameImageID,"credits") 
contactmeCreditsBtn = ymake_btn("contactme.png",400,400,contactmeImageID,"credits") 

//instractions
startGameinstructBtn = ymake_btn("backbtn.png",790,0,backImageID,"instractions") 

// src,x ,y ,id,world 
//world btns
upgradesBtn = ymake_btn("upgradebtn.png",20,120,upgrdeButtonImageID,"game")
collectResourses = ymake_btn("colres.png",20,195,colResImageID,"game")
showResourses = ymake_btn("showres.png",20,275,showResImageID,"game")
craftItem = ymake_btn("craftitems.png",20,360,craftImageID,"game")
fightwbtn = ymake_btn("fightzs.png",20,445,fightImageID,"game")
savebtn = ymake_btn("save.png",20,535,saveImageID,"game")
loadbtn = ymake_btn("load.png",20,655,loadImageID,"game")
GameinstructBtn = ymake_btn("instractions.png",300,535,instractionsImageID,"game")
gameCreditsBtn = ymake_btn("credits.png",300,655,creditsImageID,"game") 


//back btns
global backx = 450
backUpgrades = ymake_btn("backbtn.png",backx,35,backImageID,"upgrade")
backShowres = ymake_btn("backbtn.png",backx,35,backImageID,"showres")
backCraft = ymake_btn("backbtn.png",backx+150,47,backImageID,"craft")
backfight = ymake_btn("backbtn.png",backx,35,backImageID,"fight")
backpotion = ymake_btn("backbtn.png",backx,35,backImageID,"potionw")
backbroken = ymake_btn("backbtn.png",backx,35,backImageID,"brokenlog")


//scroll resourses list
global res_scroll as yscrollt
res_scroll.top = 0

scroll_btns_add(790,190,"showres","scroll_res")

instractionsBtns()

make_broken_btn()

yaddw("game",button)
///////////////////////////end buttons///////////////


changeworld("menu")

//craft("stone hand hammer")
//zombie_fight()
/////////////////auto clicker stuff////

global auto_clicker_time as float
auto_clicker_time = 3
add_ytimer("auto_clicker",auto_clicker_time) 
//add_ytimer("release_click",0.2) 
	
global is_auto_clicker_active = 0


//game loop
	
do
	//display points and other data
    if worlds[current_worldi].name<>"menu" and worlds[current_worldi].name<>"credits" and worlds[current_worldi].name<>"instractions"
		Print( ydebug ) 
	   // Print( GetDeviceLanguage( ) ) 
		Print("Points: " + str(points)+" zombies: "+str(zombie_num)) 
		//if a potion is active show its name and duration left
		if is_potion_active() and worlds[current_worldi].name<>"craft" then print(current_potion+" active("+str(potion_counter_max-potion_counter)+")")
    endif
    yengineupdate()
     
    Sync()
loop

function myupdate()
	
	if worlds[current_worldi].name="menu"
		if is_clicked(startGameBtn) then changeworld("game")
		
		if is_clicked(instractionsBtn) 
			changeworld("instractions")
			createIntriText()
	
		endif
		if is_clicked(creditsBtn) 
			changeworld("credits")
		endif
	endif//main menu world
	
	if worlds[current_worldi].name="credits"
		print("created by yoel fisher")
		createCreditsText()
		if is_clicked(startGameCreditsBtn) 
			 changeworld("game")
			 DeleteAllText()
		endif
		if is_clicked(contactmeCreditsBtn) 
			OpenBrowser("https://ytutor.wordpress.com/contact/")
		endif
	endif //credits world
	
	if worlds[current_worldi].name="instractions"
		
		
		scroll_btns_instractions_click("scroll_instractions",ins_scroll)
		instractionsBtnsClick()
		if is_clicked(startGameinstructBtn) 
			 changeworld("game")
			 DeleteAllText()
		endif
	endif // instraction world
	
	if worlds[current_worldi].name="game"
		
		//all the main games btn click handle
		
		//main points btn
		if is_clicked(button) 
			 inc points,clickMultiplier
			 if is_potion_activen("speed potion") then inc points,clickMultiplier+4
			 
		endif
		//click upgrade
		if is_clicked(upgradesBtn) 
			 changeworld("upgrade")
			 displayUpgrades()
		endif
		
		//click collect resources//////////
		if is_clicked(collectResourses) 
			 changeworld("colres")
			 resource_world_btns_init()
		endif
		
		//click collect resources//////////
		if is_clicked(showResourses) 
			 changeworld("showres")
			 res_scroll.top = 0
			 show_resources(30,55)

		endif
		
		//click craft item///////////////////////
		if is_clicked(craftItem) 
			 changeworld("craft")
			 recipesFrom =0
			 recipesTo =4
			 craft_items_view()
		endif
		//click fight world///////////////////////
		if is_clicked(fightwbtn) 
			 changeworld("fight")
			 fight_world_gui()
		endif
		
		
		//click save game///////////////////////
		if is_clicked(savebtn) 
			ydebug = "game saved"
			save_game()
		endif
		
		
		//click load game///////////////////////
		if is_clicked(loadbtn) 
			ydebug = "game loaded"
			load_game()
		endif
		
		
		//click instractions in game screen game///////////////////////
		if is_clicked(GameinstructBtn) 
			ins_scroll.top = 0 //reset instractions scroll top
			instractionsBtns()
			changeworld("instractions")
		endif
		
		
		
		//click credits in game screen game///////////////////////
		if is_clicked(gameCreditsBtn) 
			changeworld("credits")
		endif
		
		
	endif //end game world update//////////
	
	//win game world////////////////
	if worlds[current_worldi].name="win"
		print("you won the game yay!")
	endif
	
	//collect resources world////////////////
	if worlds[current_worldi].name="showres"
		//click back
		backBtnDo(backShowres) 
		
		sell_res_click()
		
		scroll_btns_click("scroll_res",res_scroll)

	endif
	
	
	//collect resources world////////////////
	if worlds[current_worldi].name="colres"
		//click back
		backBtnDo(backcolres) 
		
		 resource_world_click()
		
	endif
	///end collect resourses world
	
	////upgrades world/////
	if worlds[current_worldi].name="upgrade"
		
		backBtnDo(backUpgrades) 

		
		clickUpgrades()
		clickUpgradesPagination()
		
	endif
	///////end upgrade world/////////
	
	
	////craft world/////
	if worlds[current_worldi].name="craft"
		backBtnDo(backCraft) 
		clickCraft()
		clickCantCraft()
		clickcraftPagination()

	endif
	///////end craft world/////////
	
	
	////fight world/////
	if worlds[current_worldi].name="fight"
		backBtnDo(backfight) 
		fight_world_on_click()

	endif
	///////end fight world/////////
	
	////potions world/////
	if worlds[current_worldi].name="potionw"
		backBtnDo(backpotion) 
		click_potion_list()

	endif
	///////end potions world/////////
	
	////broken item log screen world/////
	if worlds[current_worldi].name="brokenlog"
		if is_clicked(backbroken) 
			DeleteAllText()
			ydebug = ""
			changeworld("colres")
			resource_world_btns_init()
		endif
		

	endif
	///////end broken item log screen world/////////
	
	
	
	if is_auto_clicker_active
		if is_done_ytimer("auto_clicker",1) then inc points
	endif
	
	//win game
	if won=0 and has_res("long boat")
		won = 1
		//go to win screen
		DeleteAllText()
		changeworld("win")
	endif

endfunction	//end myupdate//////////////

function update_yentity_custom(e as yentity)
	
endfunction //endd update_yentity_custom


function ymake_btn(src as string,x as float,y as float,id,world as string)
	
	btn as yentity
	
	if GetImageExists( id ) = 0 then loadImage(id,src)
	
	
	btn = newyentity(x, y, 0, id)

	recycle(world,btn)
	SetSpriteSize(btn.id,600,80)
	if id = backImageID then SetSpriteSize(btn.id,300,90)
	if id = saveImageID then SetSpriteSize(btn.id,300,90)
	if id = loadImageID then SetSpriteSize(btn.id,300,90)
	
//	SetSpriteColor(btn.id,147,192,158,255)
	
endfunction btn

function ymake_btn2(src as string,x as float,y as float,id,ytype as string)
	
	btn as yentity
	if GetImageExists( id ) = 0 then loadImage(id,src)
	
	btn = newyentity(x, y, 0, id)
	btn.ytype = ytype
	SetSpriteSize(btn.id,400,80)
	
endfunction btn


function paginationBtnsMake(x as float,y as float,perPage,maxEntries,btnType as String, world as String)

	btnsNum = maxEntries/perPage
	
	btnSpace = 90 //space btween btns
	btnsLeft = 80 //count space from left
	
	btn as ybtn
	
	for i=0 to btnsNum
		btnsLeft = btnSpace *(i+1)

		btn = recYbtn(x+btnsLeft,y,str(i+1),90,world,btnType)
		//add the page num to ybtn at pos 0 in ybtns
		if(btn.yints.length =-1)
			ybtni_ins(btn,i) //insert page num
		else
			ybtni_set(btn,0,i) //update page num at pos 0 in yints array
		endif 
		//ydebug = ydebug +str(btn.id)
		//set btn color
		SetVirtualButtonColor(btn.id,50,50,200)
		
	next i

endfunction


function scroll_btns_add(x as float,y as float,w as string,t as string)
	
	up as ybtn
	down as ybtn
	up = recYbtn(x,y,"scroll up",100,w,t)
	ybtns_ins(up,"up")//insert string
	down = recYbtn(x,y+150,"scroll down",100,w,t)
	ybtns_ins(down,"down")
endfunction

function scroll_btns_click(t as string,  yscroll ref as  yscrollt)
	
	btns as ybtn[]
	btns = getYbtnByType(t)
	for i=0 to btns.length
		if ybtnReleased(btns[i])
			if btns[i].ystrings[0] = "up" 
				 inc yscroll.top,50
				show_resources(30,55)
			endif
			if btns[i].ystrings[0] = "down" 
				 dec yscroll.top,50
				 show_resources(30,55)
			endif
		endif
	next i
endfunction

function buy_with_points(ps)
	ret = 0
	if points >= ps
		ret = 1
		points = points-ps
	endif
endfunction ret


function backBtnDo(btn as yentity)
	
		if is_clicked(btn) 
			DeleteAllText()
			ydebug = ""
			changeworld("game")
		endif
	
endfunction

function backBtnDow(btn as yentity,w as string)
	
		if is_clicked(btn) 
			DeleteAllText()
			ydebug = ""
			changeworld(w)
		endif
	
endfunction





/*

genral plan:

-click for points
-upgrades:
	*more points per click v
	*auto clicker v
	*forester (more forrest items)
	*find mine v
	*find beach
-gather resources:
	*gather stuff from forest v
	*mine: need pickaxe to get good stuff v
-craft resources: v
	*
-sell resources v
-equip resources (canceled)
-zombie disrupt resource collection:
	*you need a weapon equiped to fight zombies
	*the more zombies the more its hard to collect
	*trap have a chance to kill zombie
	*falling stones trap
	*hanging log trap
	*fighting zombies can make you loss points(nope)
-potions
	*potions that temporery buff stats like click points
	*power potion to fight zombies

-explor to find new locations(in upgrades)

-achivments:
-for collecting resources, crafting and fighting, the reward is points

-garveyard fight zombies for cloth

-dank ruins: found randomly by gathering resources. find artifacts that do stuff:
	*zombie ward: makes the chance of zombie disraption lower
	*rune axe: auto chops wood (get one more wood for each forest visit)
	*sword of flames : the best weapon in game
	*alchemy book: potions cost less to craft
	going to dank ruins costs 30 points

-save/load game:
	*save points
	*save upgrades
	*save auto timer and click multiplier
	*save resources
	*save locations array

win game:
build ship



devlog:
*new weapons:spear,obsidian knife
*new upgrades: even faster auto clicker, maste crafter
*lowe price for click upgrades
*html version
-------
*broken item alert and log screen
*sell 10 items and craft 5 at a time btns

*/
