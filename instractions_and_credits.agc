
global insractionBtnC=0//instractions btns count
global ins_scroll as yscrollt
ins_scroll.top = 0

function instractionsBtns()
	
	removeYbtnByType("instraction_btn")
	removeYbtnByType("scroll_instractions")
	insractionBtnC=0
	btn as ybtn
	/*btn = recYbtn(700,60,"resource gathering",90,"instractions","instraction btn")
	SetVirtualButtonSize(btn.id,600,90)
	ybtns_ins(btn,"resource gathering")
	*/
	btn = instractionsBtnMake("points")
	btn = instractionsBtnMake("resource gathering")
	btn = instractionsBtnMake("crafting")
	btn = instractionsBtnMake("upgrades")
	btn = instractionsBtnMake("fight")
	btn = instractionsBtnMake("potions")
	btn = instractionsBtnMake("tips")
	btn = instractionsBtnMake("winning the game")

	
	scroll_btns_add(870,190,"instractions","scroll_instractions")
	if GetTextExists(1) then SetTextPosition ( 1, 30, 50+ ins_scroll.top)
endfunction


function scroll_btns_instractions_click(t as string,  yscroll ref as  yscrollt)
	
	btns as ybtn[]
	btns = getYbtnByType(t)
	for i=0 to btns.length
		if ybtnReleased(btns[i])
			if btns[i].ystrings[0] = "up" 
				 inc yscroll.top,50
				instractionsBtns()
			endif
			if btns[i].ystrings[0] = "down" 
				 dec yscroll.top,50
				 instractionsBtns()
			endif
		endif
	next i
endfunction

function instractionsBtnMake(name as string)
	btn as ybtn
	inc insractionBtnC
	y = 90*insractionBtnC+ins_scroll.top
	btn = recYbtn(600,y+30,name,90,"instractions","instraction_btn")
	SetVirtualButtonSize(btn.id,400,80)
	ybtns_ins(btn,name) //add name to btn strings array
	
endfunction btn

function instractionsBtnsClick()
	btns as ybtn[]
	btns = getYbtnByType("instraction_btn")
	for i=0 to btns.length
		if ybtnReleased(btns[i])		
				createAnyText("instractionstxt/"+btns[i].ystrings[0]+".txt")
		endif
	next i
endfunction



//create introduction text
function createIntriText()
		DeleteAllText()
		txt as String
		txt = yfiles("instractions.txt")
		CreateText(1,txt)
		SetTextSize ( 1, 30 )
		SetTextPosition ( 1, 30, 50 )
		WordWrap(1, 350)
endfunction


//create credits text
function createCreditsText()
		DeleteAllText()
		txt as String
		txt = yfiles("credits.txt")
		CreateText(1,txt)
		SetTextSize ( 1, 30 )
		SetTextPosition ( 1, 30, 50 )
		WordWrap(1, 350)
endfunction

function createAnyText(fname as string)
		DeleteAllText()
		txt as String
		txt = yfiles(fname)
		CreateText(1,txt)
		SetTextSize ( 1, 30 )
		SetTextPosition ( 1, 30, 20 )
		WordWrap(1, 350)
endfunction
