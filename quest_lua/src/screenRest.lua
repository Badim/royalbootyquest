module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "rest";
	
	local background = display.newImage(localGroup, "image/background/tavern.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	localGroup.buttons = {};
	facemc.buttons = localGroup.buttons;
	
	gamemc.dead = false;
	
	addTopBar(facemc, localGroup.buttons);
	
	if(login_obj.resthealper5cards)then
		if(login_obj.resthealper5cards>0)then
			local val = math.floor(#login_obj.deck/5)*login_obj.resthealper5cards;
			login_obj.hp = math.min(login_obj.hp+val, login_obj.hpmax);
		end
	end
	
	handleEvent("rest", facemc);
	
	local optionsmc = newGroup(facemc);
	local function addOption(otype, tx, ty, act)
		local mc = newGroup(optionsmc);
		-- mc.x, mc.y = tx, ty;
		local ico = display.newImage(mc, "image/rest/"..otype..".png");
		if(ico==nil)then
			ico = display.newImage(mc, "image/rest/_noico.png");
		end
		ico:scale(scaleGraphics/4, scaleGraphics/4);
		
		local label = get_txt("rest_"..otype);
		local dtxt = newOutlinedText(mc, label, 0, 40*scaleGraphics, fontMain, 16*scaleGraphics, 1, 0, 1);
		
		mc.act = function(e)
			gamemc.dead = true;
			if(act)then
				sound_play("rest_"..otype);
				act(mc.x, mc.y);
			end
		end
		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = ico.contentWidth, ico.contentHeight;
		
		function mc:disabled()
			return gamemc.dead;
		end
		
		local hint = get_txt("rest_"..otype.."_hint");
		hint = hint:gsub("VAL", math.ceil(login_obj.hpmax*0.3));
		mc.hint = hint;

		function mc:onOver()
			dtxt:setText("-"..label.."-");
		end
		function mc:onOut()
			dtxt:setText(" "..label.." ");
		end

		return mc;
	end
	if(login_obj.norest~=true)then
		addOption('sleep',	_W/2-100*scaleGraphics, 100*scaleGraphics, function()
			if(login_obj.restheal==nil)then login_obj.restheal=0; end
			login_obj.hp = math.min(login_obj.hp + math.ceil(login_obj.hpmax*0.3) + login_obj.restheal, login_obj.hpmax);
			facemc:blinkRelicByAttr("login", "restheal");
			handleEvent("sleep", facemc);
			show_map();
		end);
	end
	
	local smithmc;
	if(login_obj.nosmith~=true)then
		smithmc = addOption('smith',_W/2+100*scaleGraphics, 100*scaleGraphics, function()
			local r = showCardPick(facemc, localGroup.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, true, function(card_obj, mc)
				upgradeCard(card_obj, mc);
				show_map();
			end);
			if(r)then
				-- print("r:", r, type(r));
				if(type(r) == "table")then
					if(r.addOption)then
						r:addOption(get_txt('cancel'), function()
							gamemc.dead = false;
						end);
					end
				end
			end
		end);
	end
	
	if(smithmc)then
		local temp = {};
		local list = login_obj.deck;
		for i=1,#list do
			local card = list[i];
			if(card.lvl==nil)then card.lvl=1; end
			if(card.lvl<2 or card.unlimited)then
				table.insert(temp, card);
			end
		end
		list = temp;
		if(#list<1)then
			smithmc.act = nil;
			smithmc.alpha = 0.5;
			smithmc.hint = get_txt("no_card_to_upgrade");
		end
	end
	
	
	addOption('brew',_W/2-100*scaleGraphics, 240*scaleGraphics, function(sx, sy)
		local animations = 0;
		local function check()
			if(animations<1)then
				show_map();
			end
		end
		for i=1,2 do
			if(#login_obj.potions < login_obj.potions_max)then
				local potion_obj = table.random(_G.potions);
				local potion_id = potion_obj.tag;
				table.insert(login_obj.potions, potion_id);

				local ico = display.newImage(facemc, "image/potions/"..get_name_id(potion_id)..".png", sx, sy);
				if(ico==nil)then
					ico = display.newImage(facemc, "image/potions/_unknow.png", sx, sy);
				end
				ico:scale(2/scaleGraphics, 2/scaleGraphics);
				
				animations = animations+1;
				local nx, ny = 150*scaleGraphics + #login_obj.potions*24*scaleGraphics, topY;
				transition.to(ico, {time=500, x=nx, y=ny, transition=easing.inQuad, onComplete=function(obj)
					refreshPotions(facemc, localGroup.buttons);
					transitionRemoveSelfHandler(obj);
					
					animations = animations-1;
					check();
				end});
			end
		end
		check();
	end);
	
	if(login_obj.removeatrest)then
		addOption('remove',_W/2+100*scaleGraphics, 240*scaleGraphics, function()
			showCardPick(facemc, localGroup.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, false, function(card_obj, mc)
				for i=#login_obj.deck,1,-1 do
					local temp = login_obj.deck[i];
					if(temp==card_obj)then
						table.remove(login_obj.deck, i);
						break;
					end
				end
				show_map();
			end);
		end);
	end
	
	for rid, bol in pairs(login_obj.relics) do
		local robj = relics_indexes[rid];
		if(bol)then
			if(robj.rest)then
				if(robj.max==nil or getRunStat("_"..robj.rest)<robj.max)then
					addOption(robj.rest, _W/2+100*scaleGraphics, 240*scaleGraphics, function()
						addRunStat("_"..robj.rest, 1);
						handleEvent(robj.rest, facemc);
						show_map();
					end);
				end
			end
		end
	end
	if(login_obj.forgerest)then
		addOption('forge', 0, 0, function()
			show_forge();
		end);
	end
	
	if(save_obj.act4 and login_obj.relics["Skull Red"]~=true)then
		addOption('skull', _W/2+100*scaleGraphics, 240*scaleGraphics, function()
			login_obj.relics["Skull Red"]=true;
			show_map();
		end);
	end
	
	
	local cols = math.min(optionsmc.numChildren, 4);
	cols = math.max(cols, 1);
	local rows = math.ceil(optionsmc.numChildren/cols);
	
	local bg = add_bg_title("bg_3", _W-100*scaleGraphics, (rows*80 + 20)*scaleGraphics, get_txt('tavern'));
	bg.x, bg.y = _W/2, 90*scaleGraphics + bg.h/2;
	gamemc:insert(bg);
	
	for i=1,optionsmc.numChildren do
		local mc = optionsmc[i];
		mc.x = bg.x + ((i-1)%cols-cols/2+0.5)*100*scaleGraphics;
		mc.y = bg.y + ((math.floor((i-1)/cols))-rows/2+0.5)*80*scaleGraphics - 10*scaleGraphics;
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end