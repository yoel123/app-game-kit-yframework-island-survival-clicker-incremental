


global buttonImageID = 1
global upgrdeButtonImageID = 2
global backImageID = 3
global buyImageID = 4
global colResImageID = 5
global showResImageID = 6
global visitWoodsImageID = 7
global craftImageID = 8
global craftDoImageID = 9
global mineImageID = 10
global sellImageID = 11
global fightImageID = 12
global fightdoImageID = 13
global pitTrapImageID = 14
global spikeTrapImageID = 15
global beachpImageID = 16
global saveImageID = 17
global loadImageID = 18
global beacImageID = 19
global volcanoImageID = 20
global potionsImageID = 21
global useImageID = 22
global stonefallImageID = 23
global logtrapImageID = 24
global startGameImageID = 25
global creditsImageID = 26
global instractionsImageID = 27
global graveyardImageID = 28
global contactmeImageID = 29

loadImage(buttonImageID,"button.png")

type yscrollt
	top as float
endtype


////////////////

type ylocation
	name as String
	isactive
endtype

global ylocations as ylocation[]

addYlocation("mine")
addYlocation("beach")
addYlocation("volcano")
addYlocation("graveyard")

function addYlocation(n as string)
	
	loc as ylocation
	loc.name = n
	loc.isactive = 0
	ylocations.insert(loc)
	
endfunction

function makeYlocationActive(n as string)
	
	for i = 0 to ylocations.length
		if ylocations[i].name = n then ylocations[i].isactive = 1
	next i 
	
endfunction

function isYlocationActive(n as string)
	ret = 0
	for i = 0 to ylocations.length
		if ylocations[i].isactive then ret = 1
	next i 
	
endfunction ret
