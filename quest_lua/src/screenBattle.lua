module(..., package.seeall);

function new(battle_prms)	
	local localGroup = display.newGroup();
	localGroup.name = "battle";
	_G.card_counter = 1;
	
	local player_gid = 1;
	local enemy_gid = 2;
	
	local mRandom=math.random;
	local mFloor=math.floor;
	local mSqrt=math.sqrt;
	local mCos=math.cos;
	local mSin=math.sin;
	local mAtan2=math.atan2;
	local mPI=math.pi;
	local tInsert=table.insert;
	local tRemove=table.remove;
	
	localGroup.handling = 0;
	local loading_steps_arr = {};
	
	local terrain = newGroup(localGroup);
	local gfxbackmc = require("src.gfxGroup").new(localGroup);
	local gamemc = newGroup(localGroup);
	gamemc.ended = false;
	gamemc.x, gamemc.y = _W/2, _H/2;
	gamemc:scale(scaleGraphics, scaleGraphics);
	terrain.xScale, terrain.yScale = gamemc.xScale/2, gamemc.yScale/2;
	local facemc = newGroup(localGroup);
	
	
	local gfxmc = require("src.gfxGroup").new(localGroup);
	
	localGroup.buttons = {};
	facemc.buttons = localGroup.buttons;
	
	login_obj.game.deck = {};
	login_obj.game.stats = {};
	login_obj.game.draw = {};
	login_obj.game.trash = {};
	login_obj.game.permanent = login_obj.deck;
	local stats = login_obj.game.stats;
	
	stats.turn = 1;
	stats.turn_gid = player_gid;

	local gameobj = login_obj.game;
	local deck = login_obj.game.deck;
	local hand = login_obj.game.hand;
	local draw = login_obj.game.draw;
	local trash=login_obj.game.trash; 
	local lists = {deck, draw, hand, trash};
	local listsX = {deck, draw, hand};
	
	local chests = {};
	local units = {};
	local deaths = {};
	local enemies_xy = {{60, 50}, {110, -50}, {170, 40}, {230, -40}, {280, 50}};
	
	-- local extras = {}; -- green bricks black
	-- extras.bricks = "black";
	-- extras.dirt = "bricks";
	-- extras.earth = "bricks";
	-- extras.grass = "green";
	local ttypes = {"stones", "clay", "grass", "sand"};
	local ttype = table.random(ttypes);
	local terrnd = math.random(1, 3);
	
	if(login_obj.energymax==nil)then login_obj.energymax=3; end
	-- gameobj.energymax = login_obj.energymax;
	gameobj.energy = login_obj.energymax;
	
	localGroup.conditions = 0;
	localGroup.animations = 0;
	
	for i=1,#login_obj.deck do
		local card_prms = login_obj.deck[i];
		card_prms.tempID = i;
		if(card_prms.times==nil)then card_prms.times=1; end
		
		local obj = table.cloneByAttr(card_prms);
		obj.id = obj.tag;
		table.insert(deck, obj);
	end
	local function getOriginalCardObj(tempID)
		for i=1,#login_obj.deck do
			local card_prms = login_obj.deck[i];
			if(card_prms.tempID == tempID)then
				return card_prms;
			end
		end
	end

	addTopBar(facemc, localGroup.buttons, settings.manaTop);
	
	-- table.insert(localGroup.buttons, btn);
	-- btn.w, btn.h = btnbg.width, btnbg.height;
	-- function btn:onOver()
		-- dtxt:setTextColor(5/6);
	-- end
	-- function btn:onOut()
		-- dtxt:setTextColor(1);
	-- end
	local function addDeckMC(dtype, tx, ty, colors)
		local mc = newGroup(facemc);
		facemc[dtype] = mc;
		mc.x, mc.y = tx, ty;
		local body = display.newImage(mc, "image/deck.png");
		body:scale(scaleGraphics/6, scaleGraphics/6);
		mc.dtxt = newOutlinedText(mc, #login_obj.game[dtype], 0, 0, fontMain, 24*scaleGraphics, 1, 0, 1);
		
		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = 30*scaleGraphics, 40*scaleGraphics;
		mc.hint = get_txt(dtype.."_hint");
		function mc:onOver()
			if(colors)then
				mc.dtxt:setTextColor(colors[1], colors[2], colors[3]);
			else
				mc.dtxt:setTextColor(0, 1, 0);
			end
		end
		function mc:onOut()
			mc.dtxt:setTextColor(1, 1, 1);
		end
		function mc:act()
			showCardPick(facemc, localGroup.buttons, mc.x, mc.y, login_obj.game[dtype], nil, nil, nil, nil);
		end
		function mc:disabled()
			return facemc.wnd~=nil;
		end
		function mc:refresh()
			body.xScale, body.yScale = scaleGraphics/6, scaleGraphics/6;
			mc.w, mc.h = 30*scaleGraphics, 40*scaleGraphics;
		end
		
		return mc;
	end
	
	local deck_x = 30*scaleGraphics;
	facemc.deck = addDeckMC("deck", deck_x - 6*scaleGraphics, _H - 40*scaleGraphics, {0, 1, 0});
	facemc.draw = addDeckMC("draw", _W - deck_x - 44*scaleGraphics, facemc.deck.y, {0, 0, 1});
	facemc.trash = addDeckMC("trash", _W - deck_x, facemc.deck.y, {1, 0, 0});
	
	
	local mask = graphics.newMask("image/masks/bite_4.png");
	facemc.trash:setMask(mask);
	facemc.trash.maskScaleX = 1.2;
	facemc.trash.maskScaleY = facemc.trash.maskScaleX;
	
	local hero;
	local handmc = newGroup(facemc);
	-- handmc.x, handmc.y = _W/2, _H - 50*scaleGraphics;
	
	
	function facemc:addBtn(txt, tx, ty, act)
		-- return addBtn(facemc, localGroup.buttons, txt, tx, ty, act);
		local btn = add_bar("black_bar3", 52*scaleGraphics);
		local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		-- dtxt:setFillColor(237/255, 198/255, 80/255);
		facemc:insert(btn);
		btn.x, btn.y = tx, ty;
		btn.act = act;
		table.insert(localGroup.buttons, btn);
		elite.addOverOutBrightness(btn);
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		return btn;
	end
	function gamemc:turnGame()
		-- print("_gameobj.energy:", gameobj.energy);
		if(hero.energysave==0 or hero.energysave==nil)then
			gameobj.energy = 0;
		end
		if(hero.retaincards>0)then
			showCardPick(facemc, localGroup.buttons, _W/2, 0, hand, hero.retaincards, false, function(new_card, mc)
				new_card.hold = true;
			end, nil, false);
		end
		gamemc:turnEnd(); 
		-- print("__gameobj.energy:", gameobj.energy);
	end
	facemc.turnBtn = facemc:addBtn(get_txt('turn'), _W - deck_x, _H - 90*scaleGraphics, function() --stats.turn_gid
		-- print("turn1:", facemc.turnBtn.turn, stats.turn);
		-- print("turn2:", localGroup.hosting, localGroup.gameId);
		if(facemc.turnBtn.turn ~= stats.turn)then
			facemc.turnBtn.turn = stats.turn;
			-- if(localGroup.hosting)then
				if(localGroup.gameId)then
					local turn_obj = localGroup:getTurnObj();
					turn_obj.finished = localGroup.userId;
					-- turn_obj.turned = true;
					turn_obj.gid = stats.turn_gid;
					localGroup:handleTurnObj(turn_obj);
				else
					gamemc:turnGame();
				end
			-- end
		end
	end);
	-- function facemc.turnBtn:disabled()
		-- return localGroup.hosting~=true;
	-- end
	
	if(settings.manaTop~=true)then
		local btn = newGroup(facemc);
		btn.x, btn.y = deck_x, _H - 90*scaleGraphics;
		local btnbg = add_bar("black_bar3", 52*scaleGraphics);
		btn:insert(btnbg);
		local energyico = display.newImage(btn, "image/mini/energy.png");
		energyico.x, energyico.y = - btnbg.w/2 + 12*_G.scaleGraphics, 0;
		energyico:scale(scaleGraphics/2, scaleGraphics/2);
		local dtxt = display.newText(btn, "1/3", 8*scaleGraphics, 0, fontMain, 14*scaleGraphics);
		btn.act = function(e)
			
		end
		table.insert(localGroup.buttons, btn);
		btn.w, btn.h = btnbg.width, btnbg.height;
		facemc.energyBtn = btn;
		
		facemc.etxt = dtxt;
	end
	function facemc:refreshEnergy()
		if(facemc.etxt)then
			facemc.etxt.text = gameobj.energy.."/"..(login_obj.energymax + hero.energymax);
		end
		if(facemc.mpRefresh)then
			facemc:mpRefresh();
		end
	end
	
	localGroup.handX = _W/2;
	localGroup.handXmin = localGroup.handX;
	localGroup.handXmax = localGroup.handX;
	localGroup.handXbol = false;
	if(settings.fitAllCards)then
		local sx,sy,bol= 0,0,false;
		localGroup:addEventListener("touch", function(e)
			if(e.phase=="began")then
				sx,sy = e.x,e.y;
				bol = localGroup.handXbol and e.y>facemc.eymin and e.y<facemc.eymax;
			elseif(e.phase=="moved")then
				if(bol)then
					local dx,dy = e.x-sx,e.y-sy;
					local nx = localGroup.handX+dx;
					nx = math.max(nx, localGroup.handXmin);
					nx = math.min(nx, localGroup.handXmax);
					if(nx~=localGroup.handX)then
						localGroup.handX = nx;
						facemc:refreshHandXY(true);
					end
					sx,sy = e.x,e.y;
				end
			else
				bol = false;
			end
		end);
	end
	-- function btn:onOver()
		-- dtxt:setTextColor(5/6);
	-- end
	-- function btn:onOut()
		-- dtxt:setTextColor(1);
	-- end
	
	
	function facemc:refreshDeksNumbers()
		facemc.deck.dtxt:setText(#deck);
		facemc.draw.dtxt:setText(#draw);
		facemc.trash.dtxt:setText(#trash);
		
		-- facemc.draw = addDeckMC("draw", _W - deck_x - 44*scaleGraphics, facemc.deck.y, {0, 0, 1});
		-- facemc.trash = addDeckMC("trash", _W - deck_x, facemc.deck.y, {1, 0, 0});
		if(#trash==0)then
			facemc.trash.isVisible = false;
			facemc.draw.x = _W - deck_x;
		elseif(facemc.trash.isVisible==false)then
			facemc.trash.isVisible = true;
			-- facemc.trash.x = _W - deck_x + 44*scaleGraphics;
			transition.to(facemc.draw, {time=500, x=_W - deck_x, transition=easing.outQuad});
			transition.to(facemc.trash, {time=500, x=_W - deck_x - 44*scaleGraphics, transition=easing.outQuad});
		end
	end
	

	local debugmc = newGroup(facemc);
	function localGroup:regroup(walking)
		local borderX = 10*scaleGraphics;
		local maxY = 40*scaleGraphics;
		if(settings.hideRelics~=true)then
			maxY = maxY + 36*scaleGraphics;
		end
		cleanGroup(debugmc);
		
		local function fitList(ulist, exmin, exmax, eymin, eymax, prefix)
			local dx, dy = exmax-exmin, eymax-eymin;
			local iw = dx/#ulist;
			iw = math.max(iw, 160*scaleGraphics/2);
			iw = math.min(iw, 200*scaleGraphics/2);
			for i=1,#ulist do
				local unit = ulist[i];
				unit[prefix.."x"] = ((exmin+exmax)/2 + (i-#ulist/2-0.5)*iw)/gamemc.xScale;
				unit[prefix.."y"] = (eymin+eymax)/2/gamemc.yScale + math.ceil((i-1)/2)*6*math.cos((i)*(math.pi)) + 6;
				if(unit._h)then
					if((unit[prefix.."y"] - unit._h)*gamemc.yScale<maxY)then
						unit[prefix.."y"] = maxY/gamemc.yScale + unit._h+20;
					end
				end
				if(unit.adjustXY)then
					unit:adjustXY();
				end
				
				if(prefix=="t")then
					local dd = get_dd_ex(unit.x, unit.y, unit.tx, unit.ty);
					if(dd>10)then
						unit:setAct('go');
					end
				end
			end
		end
		local function fitEnemies(gid, exmin, exmax, eymin, eymax)
			local ulist = {};
			for i=1,#units do
				local unit = units[i];
				if(unit.gid==gid and unit._utype=='unit' and unit.dead~=true and unit.suicide~=true)then
					table.insert(ulist, unit);
				end
			end
			print("_ulist:", gid==enemy_gid, #ulist);
			if(walking)then
				fitList(ulist, exmin, exmax, eymin, eymax, "t");
			else
				fitList(ulist, exmin, exmax, eymin, eymax, "");
			end
			
		end
		
		local exmin, exmax = _W*1/3, _W-borderX;
		local eymin, eymax = maxY, facemc.turnBtn.y;
		facemc.eymin, facemc.eymax = eymin, eymax;
		if(options_debug)then
			local erect = display.newRect(debugmc, (exmin+exmax)/2, (eymin+eymax)/2, exmax-exmin, eymax-eymin);
			erect:setFillColor(1, 0, 0, 1/2);
		end
		fitEnemies(2, exmin, exmax, eymin, eymax);
		fitList(chests, exmin, exmax, eymin, eymax, "");
		
		local exmin, exmax = borderX, _W*1/3;
		local eymin, eymax = (56 + 20)*scaleGraphics, facemc.turnBtn.y;
		if(options_debug)then
			local erect = display.newRect(debugmc, (exmin+exmax)/2, (eymin+eymax)/2, exmax-exmin, eymax-eymin);
			erect:setFillColor(0, 0, 1, 1/2);
		end
		fitEnemies(1, exmin, exmax, eymin, eymax);
	end

	
	
	function gamemc:addChest(lvl, tx, ty)
		local mc = newGroup(gamemc);
		table.insert(chests, mc);
		mc.x, mc.y = tx, ty;

		display.setDefault("magTextureFilter", "nearest");
		display.setDefault("minTextureFilter", "nearest");
		local bot = display.newImage(mc, "image/chests/storage"..lvl.."_bot.png");
		local top = display.newImage(mc, "image/chests/storage"..lvl.."_top.png");
		display.setDefault("magTextureFilter", "linear");
		display.setDefault("minTextureFilter", "linear");
		
		mc._hint = get_txt('loot');
		mc.hint = mc._hint;
		
		function mc:closeMe()
			top:removeSelf();
			pixelArtOn();
			top = display.newImage(mc, "image/chests/storage"..lvl.."_top.png");
			pixelArtOff();
			mc.opened = false;
			mc.hint = mc._hint;
		end
		
		mc.opened = false;
		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = mc.contentWidth*1.5, mc.contentHeight*1.5;
		elite.addOverOutBrightness(mc);
		function mc.disabled()
			return facemc.wnd~=nil;
		end
		mc.act = function()
			if(mc.opened)then return; end
			top:removeSelf();
			display.setDefault("magTextureFilter", "nearest");
			display.setDefault("minTextureFilter", "nearest");
			top = display.newImage(mc, "image/chests/storage"..lvl.."_top_.png");
			mc:insert(1, top);
			display.setDefault("magTextureFilter", "linear");
			display.setDefault("minTextureFilter", "linear");
			
			if(mc.onOpen)then
				mc:onOpen();
			end
			mc.opened = true;
			mc.hint = nil;
		end
		
		if(options_debug)then
			local d = display.newRect(mc, 0, 0, mc.w, mc.h);
			d.alpha = 1/2;
			d:scale(1/gamemc.xScale, 1/gamemc.yScale);
			d:toBack();
		end
		return mc
	end
	-- local loot_chests = {};
	function gamemc:addCardReward(lvl, tx, ty, rarity)
		local mc = gamemc:addChest(lvl, tx, ty);
		if(login_obj.cardsreward==nil)then login_obj.cardsreward=3; end
		mc.ltype = "card";
		mc.list = getCardLoot(login_obj.cardsreward, rarity);
		
		if(login_obj.sandbox~=true)then
			for i=1,#mc.list do
				local card_obj = mc.list[i];
				save_obj.unlocks['card_'..get_name_id(card_obj.tag)] = 2;
			end
		end
		
		mc.rarity = rarity;
		-- table.insert(loot_chests, mc);--mc.opened = false;
		mc.onOpen=function()
			local sx, sy = mc:localToContent(0, 0);
			-- facemc:showCardLoot(sx, sy, mc, list);--mc:closeMe()
			-- mc.onOpen = nil;
			
			local wnd = showCardPick(facemc, localGroup.buttons, sx, sy, mc.list, false, false, function(card_obj, mc)
				addCardObj(card_obj);
				facemc.book.dtxt:setText(#login_obj.deck);
				
				if(facemc and facemc.insert)then
					facemc:insert(mc);
				end
				if(facemc.book)then
					transition.to(mc, {time=500, x=facemc.book.x, y=facemc.book.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
				else
					transitionRemoveSelfHandler(mc);
				end
			end);
			if(login_obj.consume)then
				wnd:addOption(get_txt('consume'), function()
					handleEvent('consume', facemc);
				end);
			end
			wnd:addOption(get_txt('cancel'), function()
				mc:closeMe();
			end);
			wnd.onCloseExt = function()
				mc:closeMe();
			end
		end
	end
	function gamemc:addLoot(lvl, tx, ty, ltype, picks)
		print('addLoot:', ltype);
		local mc = gamemc:addChest(lvl, tx, ty);

		local loot_list = {};
		if(ltype=="relic" or ltype=="relics")then
			for i=1,picks do
				local rid = getRelicLoot(lvl, lvl==4);
				-- if(options_debug)then
					-- rid = "Orichalcum";--"Bottled Tornado"
				-- end
				
				local ok = true;
				local robj = relics_indexes[rid];
				if(robj)then
					if(robj.quest)then
						if(robj.quest.change)then
							if(robj.quest.change.filter)then
								ok = false;
								local filter = robj.quest.change.filter;
								for i=1,#login_obj.deck do
									local this_card_obj = login_obj.deck[i];
									if((this_card_obj[filter[1]]==filter[2]) == filter[3])then
										ok = true;
										break;
									end
								end
							end
						end
					end
				end
				if(not ok)then
					rid = getRelicLoot(lvl, lvl==4);
				end
				
				local tryes = 10;
				while(login_obj.relics[rid]==true and tryes>0)do
					rid = getRelicLoot(lvl, lvl==4);
					tryes = tryes-1;
				end
				if(tryes<1)then
					show_msg('all relics taken');
				end
				
				if(rid)then
					table.insert(loot_list, rid);
				else
					show_msg('no new relics');
				end
			end

			if(battle_prms.map_point.ptype=="treasure")then -- point.skull
				-- print("Skull Blue", login_obj.relics["Skull Blue"]);
				if(save_obj.act4 and login_obj.relics["Skull Blue"]~=true)then
					table.insert(loot_list, "Skull Blue");
				end
			end
		end
		if(ltype=="skull")then
			table.insert(loot_list, "Skull Green");
		end
		
		for i=#loot_list,1,-1 do
			for j=#loot_list,1,-1 do
				if(loot_list[j] == loot_list[i] and i~=j)then
					table.remove(loot_list, j);
				end
			end
		end
		
		mc.onOpen = function()
			local sx, sy = mc:localToContent(0, 0);
			-- mc.onOpen = nil;
			mc.opened = true;
			
			if(ltype=="debug")then
				local dlist = {"Bottled Flame", "Bottled Lightning", "Bottled Tornado"};
				local tlist = {};
				for i=1,#dlist do
					local rid = dlist[i];
					-- if(rid)then
						local robj = relics_indexes[rid];
						-- print("rarity:", robj.rarity, lvl, lvl==4);
						local scin = robj.scin or 100;
						local rmc = newGroup(facemc);
						table.insert(tlist, rmc);
						rmc.x, rmc.y = sx + (i-picks/2 - 0.5)*54*scaleGraphics, sy-54*scaleGraphics;
						transition.from(rmc, {time=500, x=sx, y=sy, transition=easing.outQuad});
						local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
						ico:scale(scaleGraphics/2, scaleGraphics/2);
						
						local relic1txt = newOutlinedText(facemc, "", 0, 100*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
						relic1txt:setTextColor(237/255, 198/255, 80/255);
						local relic2txt = newOutlinedText(facemc, "", 0, 116*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
						
						table.insert(localGroup.buttons, rmc);
						rmc.w, rmc.h = 30*scaleGraphics, 30*scaleGraphics;
						
						local hint = getRelicDesc(robj);
						function rmc:onOver()
							relic1txt:setText(get_name(robj.tag));
							relic2txt:setText(hint);
							
							relic1txt.x, relic1txt.y = rmc.x, rmc.y+20*scaleGraphics;
							relic2txt.x, relic2txt.y = rmc.x, rmc.y+36*scaleGraphics;
							facemc:insert(relic1txt);
							facemc:insert(relic2txt);
							relic1txt.x = math.min(math.max(rmc.x, relic1txt.width/2), _W-relic1txt.width/2);
							relic2txt.x = math.min(math.max(rmc.x, relic2txt.width/2), _W-relic2txt.width/2);
						end
						function rmc:onOut()
							relic1txt:setText("");
							relic2txt:setText("");
						end
						
						function rmc:act()
							addRelic(rid, facemc);

							rmc:removeSelf();
							facemc:refreshRelics(hero);
							
							for j=#tlist,1,-1 do
								local tmc = tlist[j];
								tmc.act = nil;
								if(tmc.removeSelf)then
									transition.to(tmc, {time=500, alpha=0, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
								end
							end
						end
					-- end
				end
			end
			if(ltype=="relic" or ltype=="relics" or ltype=="skull")then
				if(#loot_list>1 or login_obj.relicstoheal or login_obj.consume)then
					local selmc;
					local itemsmc = newGroup(facemc);
					local longest_w = 0;
					for i=1,#loot_list do
						local rid = loot_list[i];
						local robj = relics_indexes[rid];
						local scin = robj.scin or 100;
						local rmc = newGroup(itemsmc);
						-- rmc.x, rmc.y = 0, 40*scaleGraphics*(i-#loot_list/2-0.5);
						
						local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
						ico:scale(scaleGraphics/2, scaleGraphics/2);
						ico:translate(-16*scaleGraphics, 0);
						
						
						local art_xml = get_xml_by_attr(arts_xml, 'type', tostring(scin));
						
						local relic1txt = newOutlinedText(rmc, get_name(robj.tag).." / "..get_name(art_xml.properties.tag), 0, -6*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
						relic1txt:translate(relic1txt:getWidth()/2, 0);
						relic1txt:setTextColor(237/255, 198/255, 80/255);
						longest_w = math.max(longest_w, relic1txt:getWidth());
						local relic2txt = newOutlinedText(rmc, getRelicDesc(robj), 0, 10*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
						relic2txt:translate(relic2txt:getWidth()/2, 0);
						longest_w = math.max(longest_w, relic2txt:getWidth());
						
						table.insert(localGroup.buttons, rmc);
						rmc.w, rmc.h = longest_w*2, 36*scaleGraphics;
						
						function rmc:act()
							itemsmc.rid = rid;
							selmc.x, selmc.y = 0, rmc.y;
							selmc.isVisible = true;
						end
					end
					
					if(login_obj.relicstoheal)then
						-- if no relics avaible - give a option to heal?
						local rid = "heal";
						local rmc = newGroup(itemsmc);

						local ico = display.newImage(rmc, "image/button/heal.png");
						ico:scale(scaleGraphics/2, scaleGraphics/2);
						ico:translate(-16*scaleGraphics, 0);
						
						local relic1txt = newOutlinedText(rmc, get_txt('rest_sleep'), 0, -6*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
						relic1txt:translate(relic1txt:getWidth()/2, 0);
						relic1txt:setTextColor(237/255, 198/255, 80/255);
						longest_w = math.max(longest_w, relic1txt:getWidth());
						local hint = get_txt('rest_sleep_hint');
						rmc.heal = math.ceil(login_obj.hpmax*0.3);
						hint = hint:gsub("VAL", rmc.heal);
						local relic2txt = newOutlinedText(rmc, hint, 0, 10*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
						relic2txt:translate(relic2txt:getWidth()/2, 0);
						longest_w = math.max(longest_w, relic2txt:getWidth());
						
						table.insert(localGroup.buttons, rmc);
						rmc.w, rmc.h = longest_w, 36*scaleGraphics;
						
						function rmc:act()
							itemsmc.rid = rid;
							selmc.x, selmc.y = 0, rmc.y;
							selmc.isVisible = true;
						end
					end
					
					if(login_obj.consume)then
						local rid = "consume";
						local rmc = newGroup(itemsmc);

						local ico = display.newImage(rmc, "image/button/consume.png");
						ico:scale(scaleGraphics/2, scaleGraphics/2);
						ico:translate(-16*scaleGraphics, 0);
						
						local arr = {tag='Consume'};
						-- arr.login = {hpmax=2};
						-- arr.quest = {potion=1, proceed=false};
						-- table.insert(arr, );
						
						-- relics
						-- login_obj.relics
						
						local hint = royal:getConsumeHint();--getRelicDesc(arr);
						
						local relic1txt = newOutlinedText(rmc, get_txt('consume'), 0, -6*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
						relic1txt:translate(relic1txt:getWidth()/2, 0);
						relic1txt:setTextColor(237/255, 198/255, 80/255);
						longest_w = math.max(longest_w, relic1txt:getWidth());
						local relic2txt = newOutlinedText(rmc, hint, 0, 10*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
						relic2txt:translate(relic2txt:getWidth()/2, 0);
						longest_w = math.max(longest_w, relic2txt:getWidth());
						
						table.insert(localGroup.buttons, rmc);
						rmc.w, rmc.h = longest_w, 36*scaleGraphics;
						
						function rmc:act()
							itemsmc.rid = rid;
							selmc.x, selmc.y = 0, rmc.y;
							selmc.isVisible = true;
						end
					end
					
					for i=1,itemsmc.numChildren do
						local rmc = itemsmc[i];
						rmc.x, rmc.y = 0, 40*scaleGraphics*(i-itemsmc.numChildren/2-0.5);
					end
					
					selmc = display.newRect(facemc, 0, 0, longest_w+36*scaleGraphics, 36*scaleGraphics);
					selmc.alpha = 0.4;
					selmc.isVisible = false;
					
					local cnfr_bg = display.newRect(facemc, _W/2, _H/2, _W, _H);
					cnfr_bg:setFillColor(0, 0, 0, 0.7);
					local cnfr_mc = add_bg_title("bg_3", longest_w+42*scaleGraphics, itemsmc.numChildren*40*scaleGraphics + 60*scaleGraphics, get_txt('loot'));
					facemc:insert(cnfr_mc);
					cnfr_mc.x, cnfr_mc.y = _W/2, _H/2;
					cnfr_mc:insert(selmc);
					cnfr_mc:insert(itemsmc);
					function cnfr_mc:closeMe()
						cnfr_bg:removeSelf();
						cnfr_mc:removeSelf();
						facemc.wnd = nil;
					end
					
					local hint = newOutlinedText(cnfr_mc, get_txt('pick_one_hint'), 0, -cnfr_mc.h/2 + 20*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
					
					for i=1,itemsmc.numChildren do
						local rmc = itemsmc[i];
						rmc.x = -longest_w/2 + 16*scaleGraphics;
						rmc.w, rmc.h = longest_w*2, 36*scaleGraphics;
					end
					
					local function addOption(id, tx, ty)
						local btn1_mc = display.newImage(cnfr_mc, "image/button/"..id..".png", tx, ty);
						btn1_mc.hint = get_txt(id);
						elite.addOverOutBrightness(btn1_mc);
						table.insert(localGroup.buttons, btn1_mc);
						btn1_mc.w, btn1_mc.h = 30*scaleGraphics, 30*scaleGraphics;
						return btn1_mc;
					end
					
					local btn1_mc = addOption("ok", -50*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
					-- local btn1_mc = display.newImage(cnfr_mc, "image/button/ok.png", -50*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
					-- elite.addOverOutBrightness(btn1_mc);
					-- table.insert(localGroup.buttons, btn1_mc);
					-- btn1_mc.w, btn1_mc.h = 30*scaleGraphics, 30*scaleGraphics;
					function btn1_mc:disabled()
						return itemsmc.rid==nil;
					end
					btn1_mc.act = function()
						if(itemsmc.rid=="consume")then
							handleEvent('consume', facemc);
							cnfr_mc:closeMe();
						elseif(itemsmc.rid=="heal")then
							-- login_obj.hp = math.min(login_obj.hp + math.ceil(login_obj.hpmax*0.3) + login_obj.restheal, login_obj.hpmax);
							hero:heal(math.ceil(login_obj.hpmax*0.3));
							cnfr_mc:closeMe();
						elseif(itemsmc.rid)then
							addRelic(itemsmc.rid, facemc);
							cnfr_mc:closeMe();
						end
					end
					
					local btn2_mc = addOption("cancel", 50*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
					-- local btn2_mc = display.newImage(cnfr_mc, "image/button/cancel.png", 50*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
					-- elite.addOverOutBrightness(btn2_mc);
					-- table.insert(localGroup.buttons, btn2_mc);
					-- btn2_mc.w, btn2_mc.h = 30*scaleGraphics, 30*scaleGraphics;
					btn2_mc.act=function()
						mc:closeMe();
						cnfr_mc:closeMe();
					end
					
					-- if(login_obj.consume)then
						-- local btnmc = addOption("consume", 0*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
						-- btnmc.act = function()
							-- handleEvent('consume', facemc);
							-- cnfr_mc:closeMe();
						-- end
					-- end
					
					facemc.wnd = cnfr_mc;
				else
					local tlist = {};
					for i=1,#loot_list do
						local rid = loot_list[i];
						-- if(rid)then
							local robj = relics_indexes[rid];
							-- print("loot relic rarity:", robj.tag, robj.rarity, lvl, lvl==4);
							local scin = robj.scin or 100;
							local rmc = newGroup(facemc);
							table.insert(tlist, rmc);
							rmc.x, rmc.y = sx + (i-#loot_list/2 - 0.5)*54*scaleGraphics, sy-54*scaleGraphics;
							transition.from(rmc, {time=500, x=sx, y=sy, transition=easing.outQuad});
							local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
							ico:scale(scaleGraphics/2, scaleGraphics/2);
							
							local relic1txt = newOutlinedText(facemc, "", 0, 100*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
							relic1txt:setTextColor(237/255, 198/255, 80/255);
							local relic2txt = newOutlinedText(facemc, "", 0, 116*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
							
							table.insert(localGroup.buttons, rmc);
							rmc.w, rmc.h = 30*scaleGraphics, 30*scaleGraphics;
							
							local hint = getRelicDesc(robj);
							
							if(options_mobile)then
								-- addHint(hint);
								rmc.hint = hint;
							end
							
							function rmc:onOver()
								relic1txt:setText(get_name(robj.tag));
								relic2txt:setText(hint);
								
								relic1txt.x, relic1txt.y = rmc.x, rmc.y+20*scaleGraphics;
								relic2txt.x, relic2txt.y = rmc.x, rmc.y+36*scaleGraphics;
							end
							function rmc:onOut()
								relic1txt:setText("");
								relic2txt:setText("");
							end
							
							function rmc:act()
								addRelic(rid, facemc);

								rmc:removeSelf();
								facemc:refreshRelics(hero);
								
								for j=#tlist,1,-1 do
									local tmc = tlist[j];
									tmc.act = nil;
									if(tmc.removeSelf)then
										transition.to(tmc, {time=500, alpha=0, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
									end
								end
							end
						-- else
							-- show_msg('no new relics =(')
						-- end
					end
				end
			end
			
			local money = 0;
			if(ltype=="boss")then
				money = math.random(95,105);
			end
			if(ltype=="standart")then
				money = math.random(15,20);
				if(math.random()<0.3)then
					money = money-5;
					ltype = "potion";
				end
			end
			
			if(money>0)then
				if(login_obj.money_bonus)then
					money = math.ceil(money*(100 + login_obj.money_bonus)/100);
				end
				login_obj.money = login_obj.money + money;
				if(login_obj.money_heals)then
					login_obj.hp = login_obj.hp + login_obj.money_heals;
					facemc:hpRefresh();
				end
				
				for i=1,money do
					local coin = display.newImage(facemc, "image/money_.png", sx, sy);
					coin:scale(scaleGraphics/2, scaleGraphics/2);
					-- easings
					-- facemc.moneyico
					local t = math.random(1100, 1500);
					local tar = facemc.moneyico;
					transition.to(coin, {time=t, x=tar.x, transition=table.random(easings)});
					transition.to(coin, {time=t, y=tar.y, transition=table.random(easings), onComplete=function(tmc)
						facemc:moneyRefresh();
						transitionRemoveSelfHandler(tmc);
					end});
				end
			end
			
			if(ltype=="potion")then
				if(login_obj.potionless)then
					gfxmc:addMiniTxt(sx, sy, get_txt('potionless'));
				elseif(#login_obj.potions>=login_obj.potions_max)then
					gfxmc:addMiniTxt(sx, sy, get_txt('too_much_potions'));
				else
					local potion_obj = table.random(_G.potions);
					local potion_id = potion_obj.tag;
					table.insert(login_obj.potions, potion_id);-- refreshPotions(facemc, localGroup.buttons);
					
					local ico = display.newImage(facemc, "image/potions/"..get_name_id(potion_id)..".png", sx, sy);
					if(ico==nil)then
						ico = display.newImage(facemc, "image/potions/_unknow.png", sx, sy);
					end
					ico:scale(2/scaleGraphics, 2/scaleGraphics);
					
					local nx, ny = 150*scaleGraphics + #login_obj.potions*24*scaleGraphics, topY;
					transition.to(ico, {time=500, x=nx, y=ny, transition=easing.inQuad, onComplete=function(obj)
						refreshPotions(facemc, localGroup.buttons);
						transitionRemoveSelfHandler(obj);
					end});
				end
			end
			
			
		end
	end
	
	function gamemc:getEnemiesList(gid)
		local list = {};
		for i=1,#units do
			local unit = units[i];
			if(unit.gid~=gid)then
				table.insert(list, unit);
			end
		end
		return list;
	end
	function gamemc:getUnitsList(gid)
		local list = {};
		for i=1,#units do
			local unit = units[i];
			if(unit.gid==gid)then
				table.insert(list, unit);
			end
		end
		return list;
	end
	function gamemc:getMinionsList(gid)
		local list = {};
		for i=1,#units do
			local unit = units[i];
			if(unit.gid==gid and unit.minion>0)then
				table.insert(list, unit);
			end
		end
		return list;
	end
	function gamemc:getNearestFreePlace(fx, fy)
		if(fx==nil or fy==nil)then
			fx, fy = _W*3/4/gamemc.xScale, _H/2/gamemc.yScale;
		end
		
		local enemies_xy = {};
		table.insert(enemies_xy, {fx+80, fy});
		table.insert(enemies_xy, {fx-80, fy});
		table.insert(enemies_xy, {fx+160, fy});
		table.insert(enemies_xy, {fx-160, fy});
		table.insert(enemies_xy, {fx+240, fy});
		table.insert(enemies_xy, {fx-240, fy});
		
		for j=1,#enemies_xy do
			local xy = enemies_xy[j];
			local ok = xy.taken~=true;
			for i=1,#units do
				local unit = units[i];
				local dd1 = get_dd_ex(xy[1], xy[2], unit.x, unit.y);
				if(dd1<200)then
					ok = false;
					break;
				end
				
				if(unit.tx)then
					local dd2 = get_dd_ex(xy[1], xy[2], unit.tx, unit.ty);
					if(dd2<200)then
						ok = false;
						break;
					end
				end
			end
			if(ok)then
				xy.taken = true;
				return xy;
			end
		end
	end
	
	function localGroup:refreshPets()
		for i=1,#units do
			local unit = units[i];
			if(unit.checkPetsMax)then
				unit:checkPetsMax();
			end
			if(unit.pets)then
				for j=1,#unit.pets do
					local pet = unit.pets[j];
					local petmc = pet.mc;
					if(petmc.refresh)then
						petmc:refresh();
					end
				end
			end
		end
	end
	
	local function addUnit(utype, tx, ty, sx, sy, gid, unit_obj)
		print("addUnit:", unit_obj.tag, utype);
		local unit = require("objUnit").new(utype, gid, unit_obj, localGroup.buttons);
		unit.gid = gid;

		local topH = 66*scaleGraphics;
	
		if((ty- unit._h - 16)*gamemc.yScale + gamemc.y < topH)then
			local dy = topH - ((ty- unit._h - 16)*gamemc.yScale + gamemc.y);
			ty = ty + dy/gamemc.yScale;
		end
	
		
		unit.x, unit.y = tx, ty;
		gamemc:insert(unit);
		
		local hpbar = display.newRect(unit, -unit.hpbarW/2 + 4, 16, unit.hpbarW-8, 2);
		hpbar.anchorX = 0;
		
		local hpmc = add_bar("bar_hp1", unit.hpbarW, 1/2);
		hpmc.x, hpmc.y = 0, 16;
		unit:insert(hpmc);
		
		-- local hptxt = display.newText(unit, "hp", hpmc.x, hpmc.y, fontMain, 14);
		local hptxt = newOutlinedText(unit, "hp", hpmc.x, hpmc.y, fontMain, 14, 1, 0, 1);
		hptxt:scale(1/2, 1/2);
		
		local tagtxt = newOutlinedText(unit, unit_obj.tag, hpmc.x, hpmc.y-9, fontMain, 16, 1, 0, 1);
		if(_G.settings.relicNames)then
			if(get_txt_force(utype))then
				tagtxt:setText(get_txt(utype));
			end
		end
		if(save_obj['hero_nick_'..unit_obj.tag])then
			tagtxt:setText(save_obj['hero_nick_'..unit_obj.tag]);
		end
		function unit:setTag(txt)
			tagtxt:setText(txt);
		end
		function unit:getNick()
			return tagtxt.text;
		end
		tagtxt:scale(1/2, 1/2);
		if(unit_obj.revive==nil)then unit_obj.revive=0; end;
		if(unit_obj.lives==nil)then unit_obj.lives=0; end;
		
		unit.pain = unit_obj.hpmax - unit_obj.hp;
		
		function unit:handleDamage(dmg)
			for attr,obj in pairs(conditions) do
				if(obj.damageable)then
					if(unit[attr]~=0)then
						unit[attr] = math.max(0, unit[attr]-dmg);
						-- print(attr, unit[attr], unit_obj[obj.callback]);
						if(unit[attr]==0)then
							if(obj.callback)then
								if(unit_obj[obj.callback])then
									-- unit_obj[obj.callback]();
									gamemc:playCard(unit_obj[obj.callback], unit, unit);
								end
							end
						end
					end
				end
			end
		end
		
		-- royal.cashedItemsPerEvents = {};
		-- royal.cashedConsPerEvents = {};
		-- do
			-- for attr,obj in pairs(conditions) do
				-- if(obj.event==etype or obj.event2==etype)then
					-- royal.cashedConsPerEvents[etype] = true;
				-- end
			-- end
			-- for robj,rid in pairs() do
				-- if(robj.condition)then
					-- if(robj.condition.event==etype)then
						
					-- end
				-- end
			-- end
		-- end
		
		function unit:eventHandler(etype, target)
			-- print("eventHandler", etype, target==hero, target);
			local function doThis(robj)
				elite.cashedItemsPerEvents[etype] = true;
				if(robj.condition.play)then
					local card_obj = robj.condition.play;
					if(robj.condition.once==nil or robj.condition.once==true)then
						if(card_obj.range=='self')then
							target = unit;
						end
						gamemc:playCard(card_obj, target, unit, false);--facemc:getRelicMC(tag)
						if(robj.condition.once==true)then
							robj.condition.once=false;
						end
					end
				end

				if(robj.condition.transfer)then
					local attr = robj.condition.transfer;
					local val = target[attr];
					local new_card = {range=robj.condition.range};
					new_card[attr] = val;
					if(val~=0)then
						if(unit.gid == stats.turn_gid)then
							gamemc:playCard(new_card, target, unit);
						else
							unit:addNextCard(new_card);
						end
					end
				end
			end
			
			-- event="turnEnd", play={range='self', ifEnemy={czero="armor"
			if(etype == "exhausted")then
				elite.addVal(unit, "exhausted_turn", 1);
				elite.addVal(unit, "exhausted_battle", 1);
			end
			
			
			if(unit_obj.relics and elite.cashedItemsPerEvents[etype]~=false)then
				for rid, bol in pairs(unit_obj.relics) do
					local robj = relics_indexes[rid];
					local innate = robj.condition and robj.condition.event == "turnEnd" and robj.condition.play and robj.condition.play.ifEnemy;
					-- print("1", rid, innate)
					if(robj.condition and innate)then
						if(robj.condition.event==etype)then
							doThis(robj)
						end
					end
				end
			end
			
			if(elite.cashedConsPerEvents[etype]~=false)then
				for attr,obj in pairs(conditions) do
					if(obj.event==etype or obj.event2==etype)then
						elite.cashedConsPerEvents[etype] = true;
						if(unit[attr]~=0)then
							local card_obj = obj.play;
							if(card_obj)then
								if(card_obj.range=='revive')then
									local list = {};
									for i=#deaths,1,-1 do
										local nxt = deaths[i];
										if(nxt.removeSelf)then
											if(nxt.dead and nxt.lifelink)then
												table.insert(list, nxt);
											end
										else
											table.remove(deaths, i);
										end
									end
									for i=1,#list do
										local nxt = list[i];
										if(nxt.lifeLinkAtTurn==nil)then
											nxt.lifeLinkAtTurn = stats.turn;
										elseif(nxt.lifeLinkAtTurn < stats.turn)then
											local enemy_id = nxt:getTag();
											local enemy_obj = table.cloneByAttr(getEnemyObjByTag(enemy_id));
											local hp, hpmax = nxt:getHP();
											-- enemy_obj.hpmax = hpmax;
											-- enemy_obj.hp = math.floor(enemy_obj.hp*unit[attr]/100);
											local new = gamemc:addEnemyUnit(enemy_obj, nxt.x, nxt.y);
											enemy_obj.hp = math.floor(hpmax/2);
											enemy_obj.hpmax = hpmax;
											new:addStat("sleep", 1);
											
											if(new)then
												new:refreshHP();
											end
											
											nxt.lifelink = nil;
											nxt:removeSelf();
											nxt.removeSelf = nil;

											unit:setAct("attack");
										end
									end
									-- print("_deaths:", #list);
								-- elseif(card_obj.range=='source')then
									-- gamemc:playCard(card_obj, target, unit, false, false, math.abs(unit[attr]));
								else
									if(card_obj.range=='self')then
										target = unit;
									end
									if(unit[attr]<0)then
										print('AHTUNG#ERROR:', attr, unit[attr]);
									end
									-- print('event:', etype, target, unit);
									gamemc:playCard(card_obj, target, unit, false, false, math.abs(unit[attr])); -- math.abs(unit[attr]) - amount of times to play - so rnd targets will be same for same condition.
								end
								-- if(obj.expire)then
									-- gamemc:playCard(card_obj, target, unit, false);
								-- else
									-- for i=1,math.abs(unit[attr]) do
										
									-- end
									
									-- gamemc:useCard(card_obj, target, unit, false);
								-- end
							end
							if(obj.once)then
								unit[attr] = 0;
								unit:refreshHP();
							end
						end
					end
				end
			end

			if(unit_obj.relics and elite.cashedItemsPerEvents[etype]~=false)then
				for rid, bol in pairs(unit_obj.relics) do
					local robj = relics_indexes[rid];
					local innate = robj.condition and robj.condition.event == "turnEnd" and robj.condition.play and robj.condition.play.ifEnemy;
					-- print("2", rid, innate)
					if(robj.condition and not(innate))then
						if(robj.condition.event==etype)then
							doThis(robj)
						end
					end
				end
			end
			
			unit:turnPets(etype);
			
			if(unit==hero)then
				for i=1,#hand do
					local card_obj = hand[i];
					-- print("_card_obj:", i, card_obj.onEvent);
					if(card_obj.onEvent and card_obj.onEvent.event==etype)then
						gamemc:playCard(card_obj.onEvent.play, target, unit, false);--facemc:getRelicMC(tag)
					end
				end
			end
			
			if(unit.gid~=player_gid)then
				unit:showNextMove();
			end

			return false
		end
		
		function unit:cleanse(val)
			for attr,obj in pairs(conditions) do
				if(obj.debuff and (val==true or val==attr))then
					if(unit[attr]>0)then
						unit[attr] = 0;
					end
				end
			end
			local function cleanStat(attr)
				if(unit[attr]<0 and (val==true or val==attr))then
					unit[attr] = 0;
				end
			end
			cleanStat("str");
			cleanStat("dex");
		end
		
		function unit:stolen(val)
			val = math.min(val, unit_obj.money);
			unit_obj.money = unit_obj.money-val;
			return val;
		end
		
		local next_card, next_ico;
		function unit:prepareCard()
			if(unit_obj.specialAction)then -- next_card = {range="self", escaping=true}; unit:setNextCard({range="self", escaping=true});
				if(unit:getHPper()<unit_obj.specialAction.hp/100)then
					next_card = table.cloneByAttr(unit_obj.specialAction.card);
					unit_obj.specialAction = nil;
					return;
				end
			end
			if(unit.shifted~=0)then
				if(unit_obj.shiftCards)then
					if(unit_obj.shiftCardsTemp==nil)then
						unit_obj.shiftCardsTemp = table.clone(unit_obj.shiftCards);
					end
					if(unit_obj.order==false)then
						next_card = table.random(unit_obj.shiftCardsTemp);
					else
						next_card = table.remove(unit_obj.shiftCardsTemp, 1);
						table.insert(unit_obj.shiftCardsTemp, next_card);
					end
					return true;
				end
			end
			
			-- stats.turn
			-- unit.stealmoney
			if(unit.stealmoney~=0)then
				if(unit._escaping)then
					next_card = {range="self", escaping=true};
					return true
				end
				-- print("stealmoney:", stats.turn, stats.turn/4, stats.turn/4 - 0.5);
				if(math.random() < stats.turn/4 - 0.5)then
					unit._escaping = true;
					if(unit_obj.escape)then
						if(#unit_obj.escape>0)then
							next_card = table.cloneByAttr(table.random(unit_obj.escape));
							
						else
							next_card = {range="self", escaping=true};
						end
						return true;
					end
				end
			end
			
			if(unit_obj.ini)then
				if(#unit_obj.ini<1)then
					unit_obj.ini = nil;
				end
			end
			
			if(unit_obj.ini)then
				local card = table.remove(unit_obj.ini, 1);
				next_card = table.cloneByAttr(card);
				if(#unit_obj.ini<1)then
					unit_obj.ini = nil;
				end
			elseif(unit_obj.cards)then
				local card;
				if(unit_obj.order==false)then
					local reroll, tryes = true, 100;
					local summons_count = gamemc:getMinionsList(unit.gid);
					-- print("_summons_count:", #summons_count);
					while(reroll)do
						reroll = false;
						
						card = table.random(unit_obj.cards);
						-- print('next tag:', card.tag)
						if(card.summon)then
							if(#summons_count>card.summon.min)then
								reroll = true;
							end
						end
						if(next_card)then
							if(card.tag==next_card.tag)then
								reroll=true;
							end
						end
						
						tryes = tryes-1;
						-- print("reroll:", reroll, tryes);
						if(tryes<0)then
							break;
						end
					end
				else
					local function shuffleEnemyDeck()
						unit_obj._swapped = 1;
						if(unit_obj.shuffleCards)then
							table.superrandomswap(unit_obj.cards, "tag", unit_obj.shuffleCards);
						end
					end
				
					if(unit_obj._swapped==nil)then
						shuffleEnemyDeck();
					else
						unit_obj._swapped = unit_obj._swapped+1;
					end
					
					-- print('enemy move1', unit_obj._swapped, unit_obj._swapped>#unit_obj.cards);
					if(unit_obj._swapped>#unit_obj.cards)then -- enemy shuffled his deck!
						shuffleEnemyDeck();
					end
				
					card = table.remove(unit_obj.cards, 1);
					table.insert(unit_obj.cards, card);
					
					-- print('enemy move2', card.card);
				end
				next_card = table.cloneByAttr(card);
			end
			
			if(next_card)then
				if(next_card.rndCards)then
					next_card = table.cloneByAttr(table.random(next_card.rndCards));
				end
				
				if(next_card.range==nil)then next_card.range='enemy'; end
				if(next_card.dmg and next_card.ctype==nil)then next_card.ctype=CTYPE_ATTACK; end
			end
		end
		function unit:showNextMove()
			if(unit.dead)then 
				unit:clear();
				return;
			end
			if(next_card==nil)then
				unit:prepareCard();
			end
			
			if(next_ico)then
				if(next_ico.removeSelf)then
					next_ico:removeSelf();
				end
				next_ico = nil;
			end
			unit.intends = {};
			if(next_card)then
				next_ico = newGroup(unit);
				if(next_card.range=="enemy")then
					if(next_card.weak or next_card.frail or next_card.vulnerable or (next_card.str and next_card.str<0))then
						local ico = display.newImage(next_ico, "image/moves/curse.png");
						unit.intends.curse = true;
					end
					if(next_card.addCards)then
						local ico = display.newImage(next_ico, "image/moves/statuses.png");
						unit.intends.statuses = true;
					end
				end
				if(next_card.dmg)then
					local ico = newGroup(next_ico);
					local hint = next_card.dmg+unit.str+unit.demon;
					
					if(unit.weak>0)then
						hint = math.floor(hint*0.75);
					end
					if(hero and hero.wrath>0)then
						hint = hint*2;
					end
					
					if(hint>=30)then
						local i1 = display.newImage(ico, "image/moves/dmg3.png");
					elseif(hint>=20)then
						local i1 = display.newImage(ico, "image/moves/dmg2.png");
					else
						local i1 = display.newImage(ico, "image/moves/dmg1.png");
					end
					-- i1.x = -4;
					
					
					if(next_card.times)then
						if(next_card.times~=1)then
							hint = hint.."x"..next_card.times;
						end
					end
					local i2 = newOutlinedText(ico, hint, 0, 0, fontMain, 28, 1, 0, 1);
					i2:setFillColor(0.1, 0.1, 0.1);
					i2:setTextColor(1, 0.2, 0.1);
					unit.intends.dmg = true;
				end
				if(next_card.armor)then
					local ico = display.newImage(next_ico, "image/moves/armor.png");
					unit.intends.armor = true;
				end
				if(next_card.str)then
					if(next_card.str>0)then
						local ico = display.newImage(next_ico, "image/moves/buff.png");
						unit.intends.buff = true;
					end
				end
				-- if(next_card.str and next_card.range=="enemy")then
					-- local ico = display.newImage(next_ico, "image/moves/buff.png");
					-- unit.intends.buff = true;
				-- end
				if(next_card.escaping)then
					local ico = display.newImage(next_ico, "image/moves/exit.png");
					unit.intends.exit = true;
				end
				if(next_ico.numChildren<1 or hero.blinded>0 or unit.sleep>0 or unit.wakingup)then
					cleanGroup(next_ico);
					local ico = display.newImage(next_ico, "image/moves/unknow.png");
				end
				
				next_ico:scale(1/2, 1/2);
				next_ico.y = - unit._h - 16;
				for i=1,next_ico.numChildren do
					local ico = next_ico[i];
					ico.x = 32*(i-next_ico.numChildren/2-0.5);
				end
			end
		end
		function unit:drawCard()
			if(next_card==nil)then
				unit:prepareCard();
			end
			local copy = next_card;
			next_card = nil;
			if(next_ico)then
				next_ico:removeSelf();
				next_ico = nil;
			end
			return copy;
		end
		function unit:getNextCard()
			return next_card;
		end
		function unit:setNextCard(obj)
			next_card = obj;
			unit:showNextMove();
		end
		
		local next_cards = {};
		function unit:addNextCard(card)
			table.insert(next_cards, card);
			unit.nextCards = #next_cards;
			unit:refreshHP();
		end
		function unit:playNextCard()
			while(#next_cards>0)do
				local card = table.remove(next_cards, 1);
				gamemc:playCard(card, unit, unit, false);
			end
			unit.nextCards = #next_cards;
			unit:refreshHP();
		end
		function unit:getClass()
			return unit_obj.class;
		end
		function unit:getHPper()
			return unit_obj.hp/unit_obj.hpmax;
		end
		function unit:getTag()
			return unit_obj.tag;
		end
		function unit:getHP()
			return unit_obj.hp, unit_obj.hpmax;
		end
		function unit:feed(val)
			unit_obj.hp = unit_obj.hp + val;
			unit_obj.hpmax = unit_obj.hpmax + val;
			unit:refreshHP();
			
			if(unit==hero)then
				if(login_obj.hpmaxex==nil)then
					login_obj.hpmaxex = login_obj.hpmax;
				end
				login_obj.hpmaxex = login_obj.hpmaxex + val;
			end

			unit:addMsg("+"..val.." "..get_txt('hpmax'), {0, 1, 0});
			facemc:hpRefresh();
		end
		function unit:countCurces()
			local count = 0;
			if(unit_obj.deck)then
				for i=1,#unit_obj.deck do
					if(unit_obj.deck[i].ctype==CTYPE_CURSE)then
						count = count+1;
					end
				end
			end
			return count;
		end
		
		function unit:clear()
			if(next_ico)then
				next_ico:removeSelf();
				next_ico = nil;
			end
			hpbar.isVisible = false;
			hpmc.isVisible = false;
			hptxt.isVisible = false;
			
			unit:clearStatuses();
		end
		function unit:refreshHP()
			if(unit.dead)then 
				unit:clear();
				return 0;
			end
			if(unit_obj.hp<1 and unit.revive>0)then
				unit_obj.hp = unit.revive;
				unit.revive = 0;
				unit:eventHandler("revived", unit);
			end
			-- print("hp/revive:", unit_obj.hp, unit_obj.revive, unit_obj.lives);
			if(unit_obj.hp<1 and unit_obj.lives>0)then
				facemc:blinkRelicByAttr("login", "lives");
				unit_obj.hp = math.floor(unit_obj.hpmax/2);
				unit:addMsg(unit_obj.hp, {0, 1, 0}, "heal".._G.card_counter, "hp");
				unit_obj.lives = unit_obj.lives-1;
				unit:eventHandler("revived", unit);
				if(unit==hero)then
					facemc:refreshRelics(hero);
				end
			end
			if(unit_obj.hp<1)then
				unit_obj.hp = 0;
				unit:eventHandler("death", unit); -- death should proc at same time, not a frame after
				unit._deathstranding = true;
				-- print('eventHandler:death');
				if(unit_obj.hp<1)then
					unit:setAct('death');
					-- print('dead', unit_obj.hp, unit._act);
					unit.dead = true;
					hpbar.xScale = 0.0001;
					hptxt:setText(get_txt('dead'));
					
					unit:clear();
					
					if(unit.money)then
						login_obj.money = login_obj.money + unit.money;
						facemc:moneyRefresh();
					end
					
					if(unit_obj.onDead)then
						gamemc:playCard(unit_obj.onDead, unit, unit);
					end
					
					if(unit.corpseexplosion>0)then
						local list = gamemc:getEnemiesList(unit.gid);
						if(#list>0)then
							-- print("_unit_obj.hpmax:", unit_obj.hpmax);
							local corpse_card = {dmg=unit_obj.hpmax, range="enemies", strX=0};
							local source = list[1];
							-- if(stats.turn_gid==unit.gid)then
								-- source:addNextCard(corpse_card);
							-- else
								gamemc:playCard(corpse_card, unit, source, false);
							-- end
							unit:addMsg(get_txt('corpseexplosion'), {1, 1, 0});
						end
					end
					
					-- unit.master = source
					-- unit:setNextCard({range="self", escaping=true}); escaping
					for i=1,#units do
						local minion = units[i];
						-- print(i, minion.master==unit, minion.master, unit);
						if(minion.master==unit)then
							minion:setNextCard({range="self", escaping=true});
						end
					end
					
					if(unit.gid~=player_gid)then
						if(unit.minion==0)then
							addLoginStat("kills");
							addRunStat("kills");
						end
					end
					
					return
				end
			end
			if(hpbar.setFillColor)then
				if(unit.armor>0)then
					hpbar:setFillColor(0, 1/2, 1);
				else
					hpbar:setFillColor(1, 1/10, 1/10);
				end
			end
			
			if(unit.untargetable and unit.untargetable>0)then
				hpbar.isVisible = false;
				hpmc.isVisible = false;
				hptxt.isVisible = false;
			else
				hpbar.isVisible = true;
				hpmc.isVisible = true;
				hptxt.isVisible = true;
			end
			
			local p = unit_obj.hp/unit_obj.hpmax;
			hpbar.xScale = unit_obj.hp/unit_obj.hpmax;
			-- hptxt.text = unit._hp.."/"..unit._hp_max; dead
			hptxt:setText(unit_obj.hp.."/"..unit_obj.hpmax);
			
			if(unit_obj.onHalf)then
				if(p <= 1/2)then
					next_card = unit_obj.onHalf;
					unit:showNextMove();
					unit.energy = 0;
					unit_obj.onHalf = nil;
					unit:addMsg(get_txt('interrupted'), {1, 1, 1});
				end
			end
			
			if(unit==hero)then
				facemc:hpRefresh();
			end
			
			unit:refreshStatuses();
		end
		
		unit.msgTimer = getTimer();
		local texts = {}
		function unit:addMsg(text, color, cid, attr)
			for i=#texts,1,-1 do
				local nxt = texts[i];
				if(cid)then
					if(nxt.cid == cid)then
						if(type(text)=="number")then
							nxt.text = nxt.text + text;
							return
						end
					end
				end
			end
			table.insert(texts, {text=text, color=color, cid=cid, attr=attr});
		end
		function unit:checkMsgs()
			if(#texts>0)then
				if(getTimer()-unit.msgTimer < 300)then
					return false
				end
				
				local obj = table.remove(texts, 1);
				local cx, cy = unit:localToContent(0, -unit._h);
				if(obj.attr)then
					if(obj.text>0)then
						obj.text = get_txt(obj.attr).." +"..obj.text;
					else
						obj.text = get_txt(obj.attr).." "..obj.text;
					end
				end
				local etxt = gfxmc:addMiniTxt(cx, cy, obj.text);
				if(obj.color)then etxt:setTextColor(obj.color[1], obj.color[2], obj.color[3]); end
				unit.msgTimer = getTimer();
				return false
			end
			return true
		end
		function unit:clearMsgs()
			while(#texts>0)do
				table.remove(texts, 1);
			end
		end
		function unit:getMsgsCount()
			return #texts;
		end
		
		function unit:calcDmg(dmg, strX, dtype, source)			
			if(unit.intangible~=0)then
				dmg = 1;
			end
			if(strX==nil)then strX=1; end
			if(dtype==DTYPE_TRUE or dtype==DTYPE_DIRECT)then
				if(source)then
					if(source.dmgmultiply>0)then
						dmg = dmg * source.dmgmultiply;
					end
				end
				return dmg;
			end
			if(source)then
				dmg = dmg + source.str*strX;
				if(dmg<0)then
					dmg = 0;
				end
				if(source.dmgOnce)then
					dmg = dmg + source.dmgOnce;
				end
				if(source.weak>0)then
					dmg = dmg*0.75;
				end
			end
			if(unit.vulnerable>0)then
				dmg = dmg*1.5;
			end
			if(unit.vulnerability~=0)then
				dmg = dmg*(100 + unit.vulnerability)/100;
			end
			if(source)then
				if(source.dmgmultiply>0)then
					dmg = dmg * source.dmgmultiply;
				end
				if(source.armorpiercing>0 and unit.armor>0)then
					dmg = math.floor(dmg * (100+source.armorpiercing)/100);
				end
			end
			if(unit.intangible~=0)then
				dmg = 1;
			end
			if(source)then
				if(source.ignoring.dmg)then 
					source:addMsg(get_txt('miss'), {1, 0, 0});
					dmg = 0;
				end
			end
			return math.floor(dmg);
		end
		
		function unit:handleDmg(dmg)
			-- conditions.maximumpain
			-- conditions.invincible
			if(conditions.maximumpain)then
				if(unit.maximumpain~=0)then
					dmg = math.min(dmg, unit.invincible);
					unit:addStat("invincible", -dmg, unit);
				end
			end
			if(unit.untargetable>0 or unit._deathstranding)then
				return 0;
			end
			unit_obj.hp = unit_obj.hp-dmg;
			return dmg;
		end

		function unit:doPoison(dmg)
			if(unit.dead)then return; end
			-- unit:eventHandler('harm', unit);
			if(unit.intangible~=0)then
				dmg = 1;
			end
			-- unit_obj.hp = unit_obj.hp-dmg;
			dmg = unit:handleDmg(dmg);
			unit:refreshHP();
			unit:addMsg(-dmg, {0, 1, 0}, "poison".._G.card_counter);
			
			if(unit.dead)then
				-- print('poison_kills', unit, unit.poison_source);
				if(unit.poison_source)then
					unit.poison_source:eventHandler("kill", unit);
				end
			end
			
			unit:addGfx("magic_poison_cast");
			unit:handleDamage(dmg);
			return dmg;
		end
		function unit:harm(dmg)
			if(unit.dead)then return; end
			if(unit.ignoreHarm>0)then unit:addMsg(get_txt('ignored'), {1, 0, 1}); return; end
			if(unit.intangible~=0)then
				dmg = 1;
			end
			if(dmg>0)then
				if(unit.preventdmg>0)then
					unit.preventdmg = unit.preventdmg-1;
					return 0;
				end
			end
			unit:eventHandler('harm', unit);
			dmg = unit:handleDmg(dmg);
			unit:refreshHP();
			unit:addMsg(-dmg, {1, 0, 1}, "harm".._G.card_counter);
			unit.harmed = unit.harmed+dmg;
			unit.pain = unit.pain + dmg; -- for cards with consumePain
			if(hero.onHarmed)then
				hero:onHarmed();
			end
			unit:handleDamage(dmg);
			return dmg;
		end
		function unit:heal(val)
			if(unit.dead)then return; end
			-- unit:eventHandler('heal', unit);
			
			val = math.floor(val*(100+unit.healing)/100);
			
			if(unit_obj.hp+val>unit_obj.hpmax)then
				val = unit_obj.hpmax - unit_obj.hp;
			end
			
			unit:addStat('healed', val);
			unit_obj.hp = unit_obj.hp+val;
			unit:refreshHP();
			
			unit:addMsg(val, {0, 1, 0}, "heal".._G.card_counter, "hp");

			unit:addGfx("magic_blessing_hero_front");
		end
		function unit:addGfx(id)
			-- magic_blessing_hero_front
			local cx, cy = gamemc:localToContent(unit.x, unit.y);
			local mc = addGfxByID(gfxmc, cx, cy, id, 1);
			
			local item_obj = game_art.byids[id];
			if(item_obj.back)then
				gfxbackmc:insert(mc);
			end
			
			if(id=="blood_spray1" or id=="blood_spray2")then
				if(cx<_W/2)then
					mc.xScale = -mc.xScale;
					mc:translate(-50*gamemc.xScale/2, -10*gamemc.xScale);
				else
					mc:translate(50*gamemc.xScale/2, -10*gamemc.xScale);
				end
			end
		end
		function unit:takeDmg(dmg, strX, dtype, source, eventable)
			if(unit.dead)then return 0; end
			-- add_item("armor");
			-- add_item("vulnerable");
			-- add_item("weak");
			-- add_item("str");
			
			dmg = unit:calcDmg(dmg, strX, dtype, source);
			if(dmg>0)then
				if(unit.preventdmg>0)then
					dmg = 0;
					unit.preventdmg = unit.preventdmg-1;
				end
			end
		
			if(unit.armor>0 and dtype~=DTYPE_TRUE)then
				if(unit.armor>dmg)then
					unit.armor = unit.armor-dmg;
					dmg = 0;
				else
					dmg = dmg - unit.armor;
					unit.armor = 0;
				end
			end

			dmg = math.min(dmg, unit_obj.hp);
			if(dmg>0)then
				unit.attacked = unit.attacked+1;
				unit.damaged = unit.damaged + dmg;
				unit.pain = unit.pain + dmg; -- for cards with consumePain
				if(unit.onDamaged)then
					unit:onDamaged();
				end
				if(unit.shield>0)then
					unit.shield = unit.shield-1;
				end
				if(unit.sleep>0)then
					unit.sleep = 0;
					unit.wakingup = true;
				end
				
				unit:addGfx("blood_spray"..math.random(1,2));
				unit:handleDamage(dmg);
			end
			
			dmg = unit:handleDmg(dmg);
			unit:refreshHP();
			if(unit.dead)then
				source:eventHandler("kill", unit);
				unit:eventHandler("killed", source);
			end
			
			if(eventable)then
				unit:eventHandler('dmg', source);-- dmg - unit attacked by source
				if(dmg>0)then
					unit:eventHandler('udmg', source);-- dmg - unit damaged by source
				end
			end
			
			unit:addMsg(-dmg, {1, 0, 0}, "dmg".._G.card_counter);
			
			return dmg;
		end
		
		-- local ii = string.format("%02d", math.random(0,5));
		
		
		-- function unit:addArmor(armor)
			-- unit.armor = unit.armor+armor;
			-- unit:refreshHP();
			
			-- local cx, cy = unit:localToContent(0, -unit._h);
			-- gfxmc:addMiniTxt(cx, cy, armor);
		-- end
		
		
		
		unit.pets = {};
		-- conditions.petsmax unit.petsmax
		-- unit.petsmax = 3;
		function unit:refreshPetsXY()
			local r = 70;
			local w = math.pi;
			local j = 1;
			-- print("<refreshPetsXY>");
			for i=1,#unit.pets do
				local petobj = unit.pets[i];
				local petmc = petobj.mc;
				-- print(i, j, petobj.dead);
				-- if(petobj.dead~=true)then
					local a = -w*(j-1)/unit.petsmax;
					if(petmc.x and unit.x)then
						petmc.x, petmc.y = unit.x + r*math.cos(a), unit.y + r*math.sin(a)-8;
					end
					j = j+1;
				-- end
			end
			-- print("</refreshPetsXY>");
			-- for i=#unit.pets+1,unit.petsmax do
				-- local a = -w*(i-1)/unit.petsmax;
				-- local mc = addGfxByID(gfxmc, 0, 0, "magic_blessing_hero_front", 1);
			-- end
		end
		function unit:checkPetsMax()
			if(#unit.pets==0)then return; end
			while(#unit.pets > unit.petsmax)do
				if(unit.pets[1] and unit.pets[1].dead)then
					return
				end
				local petobj = table.remove(unit.pets, 1);
				if(petobj)then
					local petmc = petobj.mc;
					petmc.sctxt:setText("");
					petmc:setAct("go");
					petobj.dead = true;
					
					local dx, dy = petmc.x-unit.x, petmc.y-unit.y;
					petmc:setDir(dx, dy);
					transition.to(petmc, {time=4500, x=dx*8, y=dy*8, onComplete=transitionRemoveSelfHandler});
					transition.to(petmc, {delay=500, time=1500, alpha=0, onComplete=transitionRemoveSelfHandler});
				else
					break;
				end
			end
			unit:refreshPetsXY();
		end
		unit.__pets = {};
		function unit:addPet(tag)
			table.insert(unit.__pets, tag);
			Runtime:removeEventListener('enterFrame', unit.addPetEx);
			Runtime:addEventListener('enterFrame', unit.addPetEx);
		end
		local function getAlivePets()
			local c = 0;
			for i=1,#unit.pets do
				local petobj = unit.pets[i];
				if(petobj.dead~=true)then
					c = c+1;
				end
			end
			return c;
		end
		function unit:addPetEx()
			local petobj;
			local tag = table.remove(unit.__pets, 1);
			if(tag=="random")then
				petobj = table.cloneByAttr(table.randomByIndex(pets));
			else
				petobj = table.cloneByAttr(pets[tag]);
			end
			
			if(#unit.__pets<1)then
				Runtime:removeEventListener('enterFrame', unit.addPetEx);
			end
			if(localGroup.dead==true or gamemc.insert==nil)then
				return
			end
			
			if(unit.petsmax<1)then
				local cx, cy = unit:localToContent(0, -30*scaleGraphics);
				gfxmc:addMiniTxt(cx, cy, get_txt('petsmax_zero_msg'));
				return
			end
			
			table.insert(unit.pets, petobj); -- pet:refresh();
			petobj.dead = nil;
			petobj.owner = unit;
			unit:eventHandler("add_pet", unit);
			unit:addStat("summoned_"..petobj.tag, 1, unit);

			petobj.evoke = 0;
			petobj.evokePassive = 0;
			local st = getTimer();
			petobj.mc = require("objUnit").new(petobj.scin, unit.gid, petobj, localGroup.buttons);
			print('addpet:', (getTimer() - st));
			local pet = petobj.mc;
			local body = pet:getBody();
			pet._utype = 'pet';
			
			body:scale(1/2, 1/2);
			pet.zScale = 1/2;
			
			if(petobj.active.dmgByAttrFromSource)then
				local attr = petobj.active.dmgByAttrFromSource;
				if(petobj[attr])then
					pet:addStat(attr, petobj[attr]);
				end
			end
			
			pet.owner = unit;
			-- pet:scale(1/2, 1/2);
			pet:setAct("idle");
			pet:setDir(100, 1);
			pet:refreshStatuses();
			-- gamemc:insert(1, pet);
			gamemc:insert(pet);
			gamemc:insert(unit);
			-- pet.x, pet.y = unit.x+30*scaleGraphics, unit.y;
			
			local sctxt = newOutlinedText(pet, "", 0, -24*pet.zScale, fontMain, 24, 1, 0, 1);
			sctxt:scale(1/pet.zScale/4, 1/pet.zScale/4);
			sctxt:setTextColor(1, 0, 0);
			pet.sctxt = sctxt;
			local function _refresh(e)
				Runtime:removeEventListener('enterFrame', _refresh);
				if(sctxt.parent)then
					if(petobj.active.dmgByAttrFromSource)then
						local attr = petobj.active.dmgByAttrFromSource;
						if(pet[attr])then
							sctxt:setText(pet[attr]);
							sctxt:setTextColor(1, 0.6, 0.3);
						end
					elseif(petobj.passive.dmg)then
						sctxt:setText(petobj.passive.dmg + unit.focus);
					elseif(petobj.passive.armorToTarget)then
						sctxt:setText(petobj.passive.armorToTarget + unit.focus);
						sctxt:setTextColor(0, 1/2, 1);
					end
				end
			end
			function pet:refresh()
				Runtime:addEventListener('enterFrame', _refresh);
			end
			pet:refresh();
			
			for i=1,#unit.pets do
				local obj = unit.pets[i];
				if(obj.dead~=true and getAlivePets()>unit.petsmax)then
					obj.evoke = obj.evoke + 1;
					obj.dead = true;
				end
			end

			unit:startEvoking();
			unit:refreshPetsXY();--pet._utype = 'pet';
		end
		local function turnPet(petobj, action)
			local petmc = petobj.mc;
				
			if(petmc.localToContent)then
				local cx, cy = petmc:localToContent(0, 0);
				addGfxByID(gfxmc, cx, cy, petobj.gfx, 1);
			
				petmc:setAct("attack");
				
				if(petobj[action])then
					petmc.electrodynamics = unit.electrodynamics;
					gamemc:useCardViaOwnTargets(petobj[action], petmc, false);
					petmc:refresh();
				end
			end
		end
		function unit:startEvoking()
			Runtime:removeEventListener('enterFrame', unit.doEvoking);
			Runtime:addEventListener('enterFrame', unit.doEvoking);
		end
		function unit:doEvoking(e)
			if(localGroup.dead or localGroup.parent==nil)then
				Runtime:removeEventListener('enterFrame', unit.doEvoking);
				return
			end
			local finished = true;
			for i=#unit.pets,1,-1 do
				local petobj = unit.pets[i];
				if(petobj.evokePassive>0)then
					finished = false;
					petobj.evokePassive = petobj.evokePassive-1;
					turnPet(petobj, "passive");
					return true
				elseif(petobj.evoke>0)then
					finished = false;
					petobj.evoke = petobj.evoke-1;
					turnPet(petobj, "active");
					return true
				elseif(petobj.dead)then
					finished = false;
					if(petobj.mc.sctxt)then
						if(petobj.mc.sctxt.removeSelf)then
							petobj.mc.sctxt:removeSelf();
						end
					end
					
					petobj.mc:setAct("death");
					table.remove(unit.pets, i);
					
					if(petobj.reAdd)then
						unit:addPet(petobj.tag);
					end
					transition.to(petobj.mc, {delay=3000, time=1000, alpha=0, onComplete=transitionRemoveSelfHandler});
					unit:refreshPetsXY();
					return true
				end
			end

			if(finished or unit.parent==nil)then
				Runtime:removeEventListener('enterFrame', unit.doEvoking);
			end
		end
		function unit:evokePassive(times)
			if(#unit.pets>0)then
				local petobj = unit.pets[1];

				petobj.evokePassive = petobj.evokePassive + times;
				
				-- Runtime:removeEventListener('enterFrame', unit.doEvoking);
				-- Runtime:addEventListener('enterFrame', unit.doEvoking);
				unit:startEvoking();
			end
		end
		function unit:evokeActive(times, reAdd)
			if(#unit.pets>0)then
				local petobj = unit.pets[1];

				-- if(petobj.evoke==nil)then petobj.evoke=0; end
				petobj.evoke = petobj.evoke + times;
				petobj.dead = true;
				petobj.reAdd = reAdd;
				
				-- Runtime:removeEventListener('enterFrame', unit.doEvoking);
				-- Runtime:addEventListener('enterFrame', unit.doEvoking);
				unit:startEvoking();
			end
		end
		function unit:turnPets(event)
			for i=1,#unit.pets do
				local petobj = unit.pets[i];
				if(petobj.event == event)then
					turnPet(petobj, "passive");
				end
			end
		end
		
		tagtxt.isVisible = false;
		table.insert(localGroup.buttons, unit);
		-- unit.w, unit.h = 50*scaleGraphics, 100*scaleGraphics;
		unit.w, unit.h = 100*gamemc.xScale, 180*gamemc.yScale;
		function unit:adjustXY()
			if((unit.y+20)*gamemc.yScale>facemc.turnBtn.y)then
				hpmc.y = facemc.turnBtn.y/gamemc.yScale - unit.y-20;
				unit.stsmc.y = hpmc.y + 12;
			else
				hpmc.y = 16;
				unit.stsmc.y = 28;
			end
			hpbar.y = hpmc.y;
			hptxt.y = hpmc.y;
			tagtxt.y = hpmc.y-9;
		end
		function unit:onOver()
			if(unit.stsmc)then unit.stsmc:toFront();end
			tagtxt.isVisible = true;
			
			if(unit.gid~=player_gid)then
				hero:updateAllCards(unit);
			end
		end
		function unit:onOut()
			tagtxt.isVisible = false;
			hero:updateAllCards();
		end
		function unit:disabled()
			return facemc.wnd~=nil or facemc.popup~=nil or gamemc.ended;
		end
		function unit:act()
			-- facemc.holded = mc;
					-- mc:showExtraHints();
				-- else
					-- mc:onDropEx();
					
			if(facemc.holded)then
				-- if(unit.localToContent)then
				local cardmc = facemc.holded;
				local tx, ty = unit:localToContent(0, 0);
				transition.to(cardmc, {time=200, x=tx, y=ty, onComplete=function()
					cardmc:onMove();
					cardmc:onDropEx();
					facemc.holded = nil;
				end});
			elseif(options_mobile or options_cheats)then
				facemc:showPopupUnitInfo(unit);
			end
		end
		
		-- testing conditions
		-- unit.frail = 10;
		-- unit.armor = 10;
		-- unit.voodoo = 10;
		
		unit:setDir(sx, sy);
		unit:setAct("idle");
		table.insert(units, unit);
		
		unit:refreshHP();
		-- unit:showNextMove();
		
		return unit;
	end
	
	function facemc:showPopupUnitInfo(unit)
		if(facemc.popup)then
			facemc.popup:removeSelf();
		end
		local dy = 80*scaleGraphics;
		-- local size = math.min(_W, _H) - dy - 20*scaleGraphics;
		local wnd = add_bg_title("bg_3", _W - 120*scaleGraphics, _H - dy - 20*scaleGraphics, unit:getNick());
		wnd.x, wnd.y = _W/2, _H/2 + dy/2;
		facemc:insert(wnd);
		facemc.popup = wnd;
		function wnd:act()
		-- wnd:addEventListener('touch', function(e)
			-- if(e.phase=="began")then
				facemc.popup = nil;
				if(wnd.parent)then
					wnd:removeSelf();
				end
			-- end
		-- end);
		end
		table.insert(localGroup.buttons, wnd);
		
		local body = elite.newPixelart(wnd, "image/unitsIco/"..unit._type..".png");
		if(body==nil)then
			body = elite.newPixelart(wnd, "image/unitsIco/_noico.png");
		end
		body.alpha = 0.2;
		body:scale(scaleGraphics*4, scaleGraphics*4);
		while(body.xScale>0.1 and body.contentHeight>wnd.h)do
			body:scale(0.9, 0.9);
		end
		
		local htxt = display.newText(wnd, get_txt(get_txt(unit._type.."_hint")), 0, -wnd.h/2 + 20*scaleGraphics, wnd.w-10*scaleGraphics, 0, fontMain, 10*scaleGraphics);
		if(get_txt_force(unit._type.."_hint")==nil)then
			if(get_txt_force(get_name_id("hero_"..unit:getTag().."_hint")))then
				htxt.text = get_txt(get_name_id("hero_"..unit:getTag().."_hint"));
			elseif(get_txt_force("hero_"..unit._type.."_hint"))then
				htxt.text = get_txt("hero_"..unit._type.."_hint");
			end
		end
		
		local i = 0;
		
		if(unit.intends)then
			local function addIntend(intend, attr, pico, force)
				if(intend==attr)then
					local hint = get_txt(intend);
					local htxt = display.newText(wnd, hint, 0, -wnd.h/2 + 50*scaleGraphics + 18*i*scaleGraphics, fontMain, 10*scaleGraphics);
					local ico = display.newImage(wnd, pico);
					ico.x, ico.y = -htxt.width/2 - 12*scaleGraphics, htxt.y;
					ico:scale(scaleGraphics/2, scaleGraphics/2);
					i = i+1;
				end
			end
			for intend, val in pairs(unit.intends) do
				addIntend(intend, "dmg", "image/moves/dmg1.png");
				addIntend(intend, "statuses", "image/moves/statuses.png");
				addIntend(intend, "curse", "image/moves/curse.png");
				addIntend(intend, "buff", "image/moves/buff.png");
				addIntend(intend, "exit", "image/moves/exit.png");
			end
			if(i==0)then
				addIntend(nil, "unknow", "image/moves/unknow.png");
			end
		end		
		
		for attr,obj in pairs(conditions) do
			local val = unit[attr];
			if(val~=0 and val~=nil and obj.hidden~=true)then
				local hint;
				if(obj.number==false)then
					hint = get_txt(attr);
				else
					hint = val.." "..get_txt(attr);
				end

				if(get_txt_force(attr.."_hint"))then
					local hint2 = get_txt(attr.."_hint");
					hint2 = hint2:gsub("VAL", getConditionDesc(attr, val, obj, nil, true));
					hint = hint.." - "..hint2;
					-- local htxt = display.newText(wnd, hint, 0, -wnd.h/2 + 50*scaleGraphics + 14*i*scaleGraphics, fontMain, 10*scaleGraphics);
					-- i = i+1;
				else
					local hint2 = getConditionDesc(attr, val, obj);
					hint = hint.." - "..hint2;
					-- local htxt = display.newText(wnd, hint, 0, -wnd.h/2 + 50*scaleGraphics + 14*i*scaleGraphics, fontMain, 10*scaleGraphics);
					-- i = i+1;
				end
				local htxt = display.newText(wnd, hint, 0, -wnd.h/2 + 50*scaleGraphics + 18*i*scaleGraphics, fontMain, 10*scaleGraphics);
				local ico = display.newImage(wnd, "image/mini/_"..attr..".png");
				if(ico==nil)then
					ico = display.newImage(wnd, "image/mini/__noico.png");
				end
				ico.x, ico.y = -htxt.width/2 - 12*scaleGraphics, htxt.y;
				ico:scale(scaleGraphics/2, scaleGraphics/2);
				i = i+1;
			end
		end
	end
	
	local turning;
	localGroup.hosting = true;
	function localGroup:playCard(card_obj, target, source, interruptable, eventable, times)
	
		-- if(source.doubletap>0 and card_obj.ctype==CTYPE_ATTACK)then
			-- source.doubletap = source.doubletap-1;
			-- localGroup:playCard(card_obj, target, source, true, true);
		-- end
	
		gamemc:playCard(card_obj, target, source, interruptable, eventable, times);
	end
	function gamemc:useCard(card_obj, target, source, eventable)
		return gamemc:useCardEx(card_obj, target, source, eventable);
	end
	
	local scin = login_obj.scin;
	local set_id = save_obj['custom_scin_'..login_obj.class.."_set"];
	if(set_id and save_obj.unlocks['scin_'..scin] and save_obj['custom_scin_'..login_obj.class.."_val"..set_id])then
		scin = save_obj['custom_scin_'..login_obj.class.."_val"..set_id];
	end
	hero = addUnit(scin, -140, 0, 10, 10, player_gid, login_obj);
	hero.energymax = 0;
	if(set_id and save_obj.unlocks['scin_'..scin] and save_obj['custom_scin_'..login_obj.class.."_filters"..set_id])then
		hero:applyFilters(save_obj['custom_scin_'..login_obj.class.."_filters"..set_id]);
	end
	if(login_obj.herobonus)then
		for attr,val in pairs(login_obj.herobonus) do
			hero:addStat(attr, val);
		end
	end
	
	if(battle_prms.map_point.game)then
		local lobbyGame = battle_prms.map_point.game;
		local gameId = lobbyGame.gameId;
		local myUserEntry = battle_prms.map_point.myUserEntry;
		localGroup.hosting = lobbyGame.hostID==myUserEntry.userId;
		localGroup.gameId = gameId;
		localGroup.userId = myUserEntry.userId;
		
		function royal.coop:updateAttr(attr, val)
			royal.coop:patch("games/"..gameId, json.encode({[attr]=val}), nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					
				end
			end);
		end
		
		if(myUserEntry)then
			hero:setTag(myUserEntry.nick)
			hero.userId = myUserEntry.userId;
			royal.coop:put("games/"..gameId.."/units/"..myUserEntry.userId, json.encode({hp=login_obj.hp, hpmax=login_obj.hpmax, scin=login_obj.scin, gid=player_gid, userId=myUserEntry.userId, energy=gameobj.energy}), nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					-- mc:updateState();
				end
			end);
			
			royal.coop:updateAttr("state", "loading");
			
			function localGroup:loadDeck(response)
				if(response)then
					if(#response>0)then
						while(#hand>0)do table.remove(hand, 1); end
						while(#deck>0)do table.remove(deck, 1); end
						while(#login_obj.deck>0)do table.remove(login_obj.deck, 1); end
						while(handmc.numChildren>0)do handmc[1]:removeSelf(); end
						
						for i=1,#response do
							local card_prms = response[i];
							card_prms.tempID = i;
							if(card_prms.times==nil)then card_prms.times=1; end
							
							local obj = table.cloneByAttr(card_prms);
							obj.id = obj.tag;
							table.insert(login_obj.deck, obj);
							
							local obj = table.cloneByAttr(card_prms);
							obj.id = obj.tag;
							table.insert(deck, obj);
						end
						
						gamemc:shuffleDeck();
						gamemc:drawCards(nil, true);
						
						facemc:refreshHand(true);
						facemc:refreshDeksNumbers();
						facemc:bookRefresh();
					end
				end
			end
			localGroup.coop_save_file = options_save_fname.."_coop_"..login_obj.class..".json";
		end

		local lobbyData = royal.lobbyData;
		local lobbyPlayers = lobbyData.players;
		
		localGroup.handling = #lobbyGame.enemies;
		
		-- print();
		-- save_obj.lobbyId
		-- battle_prms
		-- game=game_obj, lobbyData=lobbyData, myUserEntry=myUserEntry
		for arrI,obj in pairs(lobbyGame.players) do
			if(arrI~=myUserEntry.userId)then
				local playerObj = lobbyPlayers[arrI];
				local heroObj = getHeroObjByAttr("tag", playerObj.hero);
				if(heroObj)then
					local unit_obj = {hp=heroObj.hp/1, hpmax=heroObj.hp/1, scin=heroObj.scin, tag=playerObj.nick, class=heroObj.class};
					local unitmc = addUnit(unit_obj.scin, -140, 0, 10, 10, player_gid, unit_obj);
					unitmc.userId = arrI;
				end
			end
		end

		local function getUnitByUserId(userId)
			for i=1,#units do
				local unit = units[i];
				if(unit.userId==userId)then
					return unit;
				end
			end
		end
		
		for arrI,obj in pairs(lobbyGame.players) do
			local unitmc = getUnitByUserId(arrI);
			unitmc._p = obj._p;
			function unitmc:getI()
				return unitmc._p;
			end
			if(arrI==myUserEntry.userId)then
				myUserEntry._p = obj._p;
			end
		end
		
		local playedCards = {};
		local function confirmTurn(attr)
			royal.coop:patch("games/"..gameId.."/cards/"..attr.."/", json.encode({["_p"..myUserEntry._p]=1}), nil, function(event)

			end);
		end
		
		local timestamp = 0;
		localGroup.unhandledCards = {};
		function localGroup:unhandledCardsHandler()
			if(#localGroup.unhandledCards>0)then
				for j=#units,1,-1 do
					local unit = units[j];
					if(unit._act~='idle')then
						return
					end
				end
				
				table.sort(localGroup.unhandledCards, function(a, b)
					return a.timestamp < b.timestamp;
				end);
				
				local obj = table.remove(localGroup.unhandledCards, 1);
				localGroup:handleCard(obj.id, obj);
			end
		end
					
		function localGroup:handleCard(cardId, obj)
			if(obj.timestamp==nil)then return false; end
			if(playedCards[cardId])then return true; end
			if(obj.loaded)then
				if(getUnitByUserId(obj.loaded)==nil)then
					return
				end
			end
			confirmTurn(cardId);
			
			for j=#units,1,-1 do
				local unit = units[j];
				if(unit._act~='idle')then
					obj.id = cardId;
					table.insert(localGroup.unhandledCards, obj);
					return true
				end
			end
			
			playedCards[cardId] = true;
			
			print("handleCard:", cardId, obj.timestamp, obj.timestamp>timestamp, obj.turned, obj.gid);
			timestamp = obj.timestamp;
			if(obj.turned)then
				if(obj.gid==player_gid)then
					gamemc:turnGame();
				else
					gamemc:turnEnd();
				end
			elseif(obj.finished)then
				local unit = getUnitByUserId(obj.finished);
				if(unit)then
					local finished = true;
					unit:addStat("finished", 1);
					for i=1,#units do
						local unit = units[i];
						if(unit.finished~=1 and unit.gid==player_gid)then
							finished = false;
							break;
						end
					end
					if(finished)then
						for i=1,#units do
							local unit = units[i];
							unit.finished = 0;
							unit:refreshStatuses();
						end
						if(localGroup.hosting)then
							local turn_obj = localGroup:getTurnObj();
							turn_obj.turned = true;
							turn_obj.gid = stats.turn_gid;
							localGroup:handleTurnObj(turn_obj);
						end
					end
				end
			elseif(obj.loaded)then
				local unit = getUnitByUserId(obj.loaded);
				unit._loaded = true;
				if(localGroup.handling==0)then
					local loaded = true;
					for i=1,#units do
						local unit = units[i];
						-- print(i, unit._loaded, unit.gid, unit.gid==player_gid);
						if(unit._loaded~=true and unit.gid==player_gid)then
							loaded = false;
							break;
						end
					end
					if(loaded)then
						royal.coop:updateAttr("state", "fighting");
						royal.coop:delete("lobby/"..gameId, nil, function(event)
							if(event.isError)then
								print("Network error!");
							else
								
							end
						end);
					end
				end
			elseif(obj.unit)then
				-- local turn_obj = {unit=enemy_obj, bonus=login_obj.enemiesbonus};
				-- localGroup:getTurnObj(turn_obj);
				-- localGroup:handleTurnObj(turn_obj);
				localGroup.handling = localGroup.handling-1;
				local enemy_obj = obj.unit;
				local unit = addUnit(enemy_obj.scin or "warrior", 0, 0, -10, 10, enemy_gid, enemy_obj);
				unit.userId = enemy_obj.userId;
				
				local attr = "armor";
				unit:addStat(attr, enemy_obj[attr]);
				for attr,con in pairs(conditions) do
					if(enemy_obj[attr])then
						unit:addStat(attr, enemy_obj[attr]);
					end
				end
				
				if(obj.bonus)then
					for attr,val in pairs(obj.bonus) do
						unit:addStat(attr, val);
					end
				end
				unit:refreshHP();
				unit:showNextMove();
				localGroup:regroup();
				
				print("adding_enemy:", localGroup.handling, localGroup.loaded);
				if(localGroup.handling==0 and localGroup.loaded~=true)then
					localGroup.loaded = true;
					local turn_obj = {loaded=hero.userId};
					localGroup:getTurnObj(turn_obj);
					localGroup:handleTurnObj(turn_obj);
				end
			elseif(obj.target and obj.source and obj.use)then
				local target = getUnitByUserId(obj.target);
				local source = getUnitByUserId(obj.source);
				local card_obj = obj.use;
				gamemc:useCardEx(card_obj, target, source, obj.eventable);
			elseif(obj.target and obj.source and obj.play)then
				local target = getUnitByUserId(obj.target);
				local source = getUnitByUserId(obj.source);
				local card_obj = obj.play;
				if(localGroup.hosting)then
					gamemc:playCard(card_obj, target, source, obj.interruptable, obj.eventable, obj.times);
				end
				
				if(card_obj.class and source)then
					local cardmc, body, ntxt = createCardMC(facemc, card_obj, source, source:getClass());

					function cardmc:animateSelfOut(delay)
						local mc = cardmc;
						mc.x, mc.y = mc.x+mc.parent.x, mc.y+mc.parent.y;
						transition.to(mc, {delay=delay, time=500, alpha=0, y=mc.y-50, xScale=1/4, yScale=1/4, transition=easing.outQuad, onComplete=function(obj)
							transitionRemoveSelfHandler(mc);
						end});
					end

					cardmc.x, cardmc.y = _W/2, _H/2;
					cardmc:animateSelfOut(1000);
				end
				
				if(source.setAct and playedCards['attack'..cardId]==nil)then
					source:setAct('attack');
				end
			end
			
			return true
		end
		
		function localGroup:checkCards()
			localGroup.checkCardsTimer = 2000;
			royal.coop:get("games/"..gameId.."/cards/", '?orderBy="_p'..myUserEntry._p..'"&equalTo=0', function(event)
				if(turning)then
					return;
				end
				if(event.isError)then
					print("Network error!");
				else
					-- mc:updateState(); card_prms.tempID - unique card id for this battle! =)
					local response_obj = json.decode(event.response);
					-- print("playedCards", event.response, response_obj);
					local count = 0;
					if(response_obj)then
						local turns = table.resortEx(response_obj, "timestamp", false);
						-- for cardId, obj in pairs(response_obj) do
						for i=1,#turns do
							local tobj = turns[i];
							localGroup:handleCard(tobj.id, tobj);
							count = count+1;
						end
					end
					if(count>0)then
						print("checkCards:", count);
					end
				end
			end);	
		end
		
		function localGroup:getTurnObj(turn_obj)
			-- local turn_obj = {};
			if(turn_obj==nil)then turn_obj = {}; end
			turn_obj.turn=stats.turn;
			
			for arrI,obj in pairs(lobbyGame.players) do
				if(arrI==myUserEntry.userId)then
					turn_obj["_p"..obj._p] = 1;
				else
					turn_obj["_p"..obj._p] = 0;
				end
			end
			return turn_obj;
		end
		
		function localGroup:handleTurnObj(turn_obj)
			localGroup.handling = localGroup.handling+1;
			royal.coop:post("games/"..gameId.."/cards/", json.encode(turn_obj), nil, function(event)
				localGroup.handling = localGroup.handling-1;
				print('turnObj:', localGroup.handling);
				if(event.isError)then
					print("Network error!");
				else
					local response = json.decode(event.response);
					local cardId = response.name;
					royal.coop:put("games/"..gameId.."/cards/"..cardId.."/timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
						if(event.isError)then
							print("Network error!");
						else
							print("turned:", event.response);
						end
					end);
					
					turn_obj.timestamp = 0;
					playedCards['attack'..cardId] = true;
					localGroup:handleCard(cardId, turn_obj);
				end
			end);
		end
		
		function localGroup:playCard(card_obj, target, source, interruptable, eventable, times)
			local turn_obj = {play=card_obj, target=target.userId, source=source.userId, interruptable=interruptable, eventable=eventable, times=times};
			localGroup:getTurnObj(turn_obj);
			localGroup:handleTurnObj(turn_obj);
		end
		
		function gamemc:useCard(card_obj, target, source, eventable)
			if(localGroup.hosting)then
				local turn_obj = {use=card_obj, target=target.userId, source=source.userId, eventable=eventable};
				localGroup:getTurnObj(turn_obj);
				localGroup:handleTurnObj(turn_obj);
			end
			return 0;
		end
	end
	
	
	for rid, bol in pairs(login_obj.relics) do
		local robj = relics_indexes[rid];
		if(bol)then
			if(robj.rest)then
				if(robj.condition)then
					if(robj.condition.login)then
						for attr,val in pairs(robj.condition.login) do
							hero:addStat(attr, login_obj[attr]);
						end
					end
				end
			end
		end
	end
	
	local function updateAllCards()
		local enemy;
		if(type(localGroup.updateAllCards) == 'table')then
			enemy = localGroup.updateAllCards;
		end

		for i=1,#hand do
			local card_obj = hand[i];
			if(card_obj.dead~=true)then
				local mc = handmc:getMCbyCardObj(card_obj);
				if(mc)then
					mc:update(enemy);
				end
			end
		end
		localGroup.updateAllCards = nil;
	end
	function hero:updateAllCards(enemy)
		localGroup.updateAllCards = enemy or true;
	end
	
	for i=1,#heroes do
		local hero_obj = heroes[i];
		if(hero_obj.tag==login_obj.tag)then
			if(hero_obj.conditions)then
				for attr,val in pairs(hero_obj.conditions) do
					hero:addStat(attr, val);
				end
			end
		end
	end
	
	
	if(options_cheats)then
		-- local i=1;
		-- for attr,obj in pairs(conditions) do
			-- if(math.random()>0.5)then
				-- hero[attr] = math.random(1, 3);
				-- i = i-1;
			-- end
			-- if(i<0)then
				-- break;
			-- end
		-- end
		-- hero.armor = 1000;
		-- hero.regen = 100;
		-- hero.str = 400;
		-- hero.frail = 10;
		hero:refreshHP();
		
		-- login_obj.relics[rid]
		
		-- for i=1,#relics do
			-- local robj = relics[i];
			-- login_obj.relics[robj.tag] = true;
		-- end
		-- facemc:refreshRelics(hero);
	end
	hero:refreshHP();
	
	function hero:onHarmed()
		for l=1,#lists do
			local list = lists[l];
			for i=#list,1,-1 do
				local card_obj = list[i];
				if(card_obj.discount=="harmed")then
					card_obj.energy = math.max(card_obj.energy-1, 0);
					local mc = handmc:getMCbyCardObj(card_obj);
					if(mc)then
						mc:update();
					end
				end
			end
		end
	end
	function hero:onDamaged()
		for l=1,#lists do
			local list = lists[l];
			for i=#list,1,-1 do
				local card_obj = list[i];
				if(card_obj.discount=="attacked")then
					card_obj.energy = math.max(card_obj.energy-1, 0);
					local mc = handmc:getMCbyCardObj(card_obj);
					if(mc)then
						mc:update();
					end
				end
			end
		end
	end
	function hero:onDiscard()
		for l=1,#lists do
			local list = lists[l];
			for i=#list,1,-1 do
				local card_obj = list[i];
				if(card_obj.discount=="discard")then
					if(card_obj.energyTemp==nil)then
						card_obj.energyTemp = card_obj.energy;
					end
					card_obj.energyTemp = math.max(card_obj.energyTemp-1, 0);
					local mc = handmc:getMCbyCardObj(card_obj);
					if(mc)then
						mc:update();
					end
				end
			end
		end
	end
	function hero:onCtypePlayed(ctype)
		for l=1,#lists do
			local list = lists[l];
			for i=#list,1,-1 do
				local card_obj = list[i];
				if(card_obj.discount=="played_ctype3" and ctype==CTYPE_POWER)then
					card_obj.energy = math.max(card_obj.energy-1, 0);
					local mc = handmc:getMCbyCardObj(card_obj);
					if(mc)then
						mc:update();
					end
				end
			end
		end
	end
	
	function gamemc:lootHandler(loot)
		local tx, ty = 0, 0;
		-- for i=1,#loot do
		while(#loot>0)do
			-- local obj = loot[i];
			local obj = table.remove(loot, 1);
			local ltype = obj[1];
			local rarity = obj[2];
			local picks = obj[3];
			if(ltype=="card")then
				gamemc:addCardReward(rarity, tx, ty, picks); -- rarity = chest lvl, picks = card rarity forced
			else
				if(login_obj.emptychest==nil)then
					login_obj.emptychest=0;
				end
				if(login_obj.emptychest>0)then
					login_obj.emptychest = login_obj.emptychest-1;
					facemc:blinkRelicByAttr("login", "emptychest");
					facemc:refreshRelics(hero);
				else
					gamemc:addLoot(rarity, tx, ty, ltype, picks);
				end
			end
			tx = tx+80;
		-- end
		end
		
		localGroup:regroup();
	end
	
	function gamemc:check_chests()
		if(gamemc.warned)then
			return false;
		end

		for i=1,#chests do
			local mc = chests[i];
			if(mc.opened~=true)then
				if(battle_prms.map_point.ptype=="boss")then
					local cx, cy = mc:localToContent(0, -30*scaleGraphics);
					gfxmc:addMiniTxt(cx, cy, "!?");
					gamemc.warned = true;
				else
					if(mc.ltype~="card")then
						-- table.insert(login_obj.eloot, {ltype=mc.ltype, rarity=mc.rarity, amount=1, list=mc.list});
						-- local cx, cy = mc:localToContent(0, -30*scaleGraphics);
						-- gfxmc:addMiniTxt(cx, cy, get_txt('warning_loot'));
						mc:act();
						return true;
					end
				end
			end
		end
		
		if(gamemc.warned)then
			return true;
		end
	end
	
	gamemc.genUserId = 1;
	function gamemc:addEnemyUnit(enemy_obj, tx, ty)
		if(enemy_obj.hpadd)then
			local hpadd = math.random(0, enemy_obj.hpadd);
			enemy_obj.hp = enemy_obj.hp + hpadd;
			enemy_obj.hpadd = nil;
		end
		
		local map = login_obj.map;
		enemy_obj.hpmax = enemy_obj.hp;

		if(login_obj.easyenemies)then
			if(login_obj.easyenemies>0)then
				enemy_obj.hp = 1;
			end
		end
		
		if(enemy_obj.ini)then
			enemy_obj.ini = table.clone(enemy_obj.ini);
		end
		enemy_obj.cards = table.clone(enemy_obj.cards);
		
		if(localGroup.hosting)then
			gamemc.genUserId = gamemc.genUserId+1;
			enemy_obj.userId = "enemy"..gamemc.genUserId;
			if(login_obj.enemiesbonus==nil)then
				login_obj.enemiesbonus = {};
			end
			login_obj.enemiesbonus.times = nil;
			
			if(localGroup.gameId)then
				local turn_obj = {unit=enemy_obj, bonus=login_obj.enemiesbonus, timestamp=0};
				localGroup:getTurnObj(turn_obj);
				localGroup:handleTurnObj(turn_obj);
			else
				local unit = addUnit(enemy_obj.scin or "warrior", tx, ty, -10, 10, enemy_gid, enemy_obj);
				do
					local attr = "armor";
					unit:addStat(attr, enemy_obj[attr]);
				end
				for attr,obj in pairs(conditions) do
					if(enemy_obj[attr])then
						unit:addStat(attr, enemy_obj[attr]);
					end
				end
				
				if(login_obj.enemiesbonus)then
					for attr,val in pairs(login_obj.enemiesbonus) do
						unit:addStat(attr, val);
					end
				end
				unit:refreshHP();
				
				return unit;
			end
		end
		
		return unit;
	end
	
	function gamemc:callEvent(event, gid, bol, source)
		for i=1,#units do
			local unit = units[i];
			if((unit.gid==gid) == bol)then
				unit:eventHandler(event, source);
			end
		end
	end
	function gamemc:refreshAllIntends()
		for i=1,#units do
			local unit = units[i];
			if(unit.showNextMove)then
				unit:showNextMove();
			end
		end
	end
	
	local function checkEasyEnemy()
		if(login_obj.easyenemies)then
			if(login_obj.easyenemies>0)then
				login_obj.easyenemies = login_obj.easyenemies-1;
			end
		end
	end
	
	local function getPartyList(party)
		local list = {};
		for i=1,#enemies do
			if(enemies[i].party == party)then
				table.insert(list, enemies[i]);
			end
		end
		return list;
	end
	
	if(battle_prms.map_point.party)then
		local party_units = battle_prms.map_point.party.units;
		if(options_cheats)then
			-- for i=1,1 do
				-- local enemy_id = "Corrupt Heart";
				-- local enemy_obj = table.cloneByAttr(getEnemyObjByTag(enemy_id));
				-- gamemc:addEnemyUnit(enemy_obj, xy[1], xy[2]);
			-- end
			-- local party = table.cloneByAttr(getEnemySquadByTag("Darklings"));
			-- party_units = party.units;
		end
			
		for i=1,#party_units do
			local enemy_id = party_units[i];
			local enemy_entry = getEnemyObjByTag(enemy_id);
			
			local party = battle_prms.map_point.party;
			if(enemy_entry==nil)then
				show_msg("error: cant find enemy: "..tostring(enemy_id).."/"..tostring(party.tag));
				royal:reportBug("cant find enemy: "..tostring(enemy_id).."/"..tostring(party.tag));
			-- else
				-- print("found enemy: "..tostring(enemy_id).."/"..tostring(party.tag));
			end
			local enemy_obj = table.cloneByAttr(enemy_entry);
			
			if(enemy_obj.party)then
				local party_list = getPartyList(enemy_obj.party);
				if(#party_list>0)then
					enemy_obj = table.cloneByAttr(table.random(party_list));
				end
			end
			
			local xy = gamemc:getNearestFreePlace();
			local enemymc = gamemc:addEnemyUnit(enemy_obj, xy[1], xy[2]);
			
			if(options_cheats and enemymc)then
				-- for j=1,3 do
					-- if(math.random()>0.5)then
						-- enemymc:addStat("charm", 10);
					-- elseif(math.random()>0.5)then
						-- enemymc:addStat("vulnerable", 10);
					-- end
					-- enemymc:addStat("poison", 150);
				-- end
				-- enemymc:addStat("armor", 150);
			end
			
			if(battle_prms.map_point.skull and enemymc)then
				if(math.random()>0.5)then
					enemymc:addStat("shield", 5);
				else
					enemymc:addStat("protect", 4);
				end
			end
		end
		checkEasyEnemy();
		
	else
		local battle_lvl = battle_prms.map_point.lvl;
		local lvl_try=100;
		if(battle_prms.map_point.ptype=="boss")then--battle_prms.map_point.party
			local party = table.random(bosses);
			while(party.lvl~=battle_lvl)do
				party = table.random(bosses);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 100;
					battle_lvl = battle_lvl-1;
				end
			end
			local party_units = party.units;
			
			for i=1,#party_units do
				local enemy_id = party_units[i];
				local enemy_obj = table.cloneByAttr(getEnemyObjByTag(enemy_id));
				local xy = gamemc:getNearestFreePlace();
				gamemc:addEnemyUnit(enemy_obj, xy[1], xy[2]);
			end
			checkEasyEnemy();
		elseif(battle_prms.map_point.ptype=="elite")then
			local party = table.random(elites);
			while(party.lvl~=battle_lvl)do
				party = table.random(elites);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 100;
					battle_lvl = battle_lvl-1;
				end
			end
			local party_units = party.units;
			
			for i=1,#party_units do
				local enemy_id = party_units[i];
				local enemy_obj = table.cloneByAttr(getEnemyObjByTag(enemy_id));
				local xy = gamemc:getNearestFreePlace();
				gamemc:addEnemyUnit(enemy_obj, xy[1], xy[2]);
			end
			checkEasyEnemy();
		elseif(battle_prms.map_point.ptype=="treasure")then
			local loot = {};
			
			if(login_obj.cardontreasure)then
				table.insert(loot, {"card", 0});
			end
			
			if(login_obj.treasureextrarelic==nil)then login_obj.treasureextrarelic=0; end
			if(login_obj.treasureextrarelic>0)then
				login_obj.treasureextrarelic = login_obj.treasureextrarelic-1;
				table.insert(loot, {"relic", 3, 1});
			end
			
			table.insert(loot, {"standart", 2, 1});
			table.insert(loot, {"relic", 3, 1});
			
			if(options_cheats)then
				-- loot = {};
				-- table.insert(loot, {"card", 1, 1});
				-- table.insert(loot, {"card", 2, 2});
				-- table.insert(loot, {"card", 3, 3});
				-- table.insert(loot, {"card", 4});
				-- table.insert(loot, {"relic", 3, 1});
				
				-- table.insert(loot, {"standart", 2});
				-- table.insert(loot, {"boss", 2});
				-- table.insert(loot, {"boss", 2});
				
				table.insert(loot, {"relics", 4, 3});
				table.insert(loot, {"relics", 4, 3});
				
				-- table.insert(loot, {"relics", 4, 3});
			end
			
			gamemc:lootHandler(loot);
			facemc.turnBtn.isVisible = false;
			gamemc.ended=true;
			local gomc = facemc:addBtn('>>>', _W-30*scaleGraphics, _H/2, function()
				if(gamemc:check_chests())then
					return
				end
				show_map();
			end);
		else
			local party = table.random(parties);
			local while_exit = 300;
			while(party.lvl~=battle_lvl and while_exit>0)do
				party = table.random(parties);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 100;
					battle_lvl = battle_lvl-1;
				end
				while_exit = while_exit-1;
			end
			local party_units = party.units;
			for i=1,#party_units do
				local enemy_id = party_units[i];
				local enemy_obj = table.cloneByAttr(getEnemyObjByTag(enemy_id));
				local xy = gamemc:getNearestFreePlace();
				gamemc:addEnemyUnit(enemy_obj, xy[1], xy[2]);
			end
			checkEasyEnemy();
		end
	end
	
	-- function localGroup:fitEnemies()
		-- local units_min_x = nil;
		-- local units_max_x = nil;
		-- for i=1,#units do
			-- local unit = units[i];
			-- if(unit.gid==2)then
				-- if(units_min_x==nil)then units_min_x = unit.x; end
				-- if(units_max_x==nil)then units_max_x = unit.x; end
				
				-- if(units_min_x>unit.x)then units_min_x=unit.x; end
				-- if(units_max_x<unit.x)then units_max_x=unit.x; end
			-- end
		-- end
		-- local gameW = _W/2/gamemc.xScale;
		-- if(units_min_x or units_max_x)then
			-- if(units_max_x>gameW - 40)then
				-- local p = (gameW - 40) / units_max_x;
				-- for i=1,#units do
					-- local unit = units[i];
					-- if(unit.gid==2)then
						-- unit.x = unit.x*p;
					-- end
				-- end
			-- end
		-- end
	-- end
	-- localGroup:fitEnemies();
	
	-- local knight_obj = {hp=18, hpmax=18};
	-- addUnit("knight", 110, -50, -10, 10, enemy_gid, table.cloneByAttr(knight_obj));
	-- addUnit("knight", 60, 50, -10, 10, enemy_gid, table.cloneByAttr(knight_obj));
	
	local function unitAct(unit)
		unit:checkMsgs();
		
		-- unit:eventHandler('heal', unit);
		-- unit:addStat('healed', val);
		if(unit.healed and unit.healed>0)then
			unit:eventHandler('heal', unit);
			unit.healed = nil;
		end

		if(unit._act=="go" and unit.tx)then
			local dx, dy = unit.tx - unit.x, unit.ty - unit.y;
			local d = math.sqrt(dx*dx + dy*dy);
			local s = unit._s*30;
			if(d<s)then
				unit.x, unit.y = unit.tx, unit.ty;
				unit:setAct("idle");
				unit:setDir(-10, 10);
				unit.tx, unit.ty = nil, nil;
			else
				unit:setDir(dx, dy);
				unit:translate(s*dx/d, s*dy/d);
			end
			return
		end
		
		if(unit:spritePlaying()==false)then
			if(unit.dead)then
				return
			end
			if(unit.suicide)then
				unit:setAct("death");
				unit.dead = true;
				unit:refreshHP();
				return
			end

			if(turning==unit)then
				if(unit._act=="attack")then
					local card_obj = unit:drawCard();
					if(localGroup.hosting)then
						if(card_obj.range=='party')then
							for i=1,#units do
								local ally = units[i];
								if(ally.gid==unit.gid)then
									localGroup:playCard(card_obj, ally, ally, true, true);
								end
							end
						elseif(card_obj.range=='ally')then
							local list = gamemc:getUnitsList(unit.gid);
							local ally = table.random(list);
							localGroup:playCard(card_obj, ally, ally, true, true);
						else					
							local tars = gamemc:getEnemiesList(unit.gid);
							if(#tars>0)then
								local tar = table.random(tars);
								if(card_obj.range=='self')then
									tar = unit;
								end
								localGroup:playCard(card_obj, tar, unit, true, true);
							end
						end
					end
					turning=nil;
				end
			end
			
			if(unit._act ~= 'death')then
				if(unit._act~="idle")then
					-- if(unit.levitating or math.random()>0.9)then
						unit:setAct("idle");
					-- end
				else
					-- print("_unit.levitating:", unit.levitating, unit._type, unit:levitating());
					if(unit:levitating() or math.random()>0.9)then
						unit:setAct("idle");
					end
				end
			end
		end
	end
	
	local function goNext(tx, ty)
		if(gamemc:check_chests())then
			return true
		end
		
		local function goNextAct()
			show_skulls(nil, function()
				if(math.random()>0.5)then
					removeRelic("Skull Blue");
				elseif(math.random()>0.5)then
					removeRelic("Skull Red");
				else
					removeRelic("Skull Green");
				end
				show_msg(get_txt('one_of_the_skulls_stuck'));
				
				map_rebuild(login_obj.map.lvl);
				show_destiny();
			end);
		end
		local function goDeadBySkullMissing(rid)
			local txt = get_txt('missing_string');
			if(txt)then
				txt = txt:gsub('STRING', get_name(rid));
				show_msg(txt);
			end
			login_obj.dead = true;
			show_end();
			saveGame();
		end
		
		if(battle_prms.map_point.reward)then
			handle_action(battle_prms.map_point.reward, tx, ty, facemc);
		else
			-- print('end game!',battle_prms.map_point.ptype, login_obj.map.lvl)
			if(battle_prms.map_point.ptype=="boss")then
				if(login_obj.map.lvl>3 or login_obj.ascend)then
					if(save_obj.act4)then
						local list = {"Skull Blue", "Skull Red", "Skull Green"};
						for i=1,#list do
							local rid = list[i];
							if(login_obj.relics[rid]~=true)then
								-- print("_login_obj.map.lvl:", login_obj.map.lvl);
								if(login_obj.ascend and login_obj.map.lvl<3)then
									local event = {tag="Helping Hand", avatar="maid", msg=get_txt('ascend_helping_hand'), actions={}};
									table.insert(event.actions, {txt="[Accept]", moneylose=500, callback=goNextAct});
									table.insert(event.actions, {txt="[Decline]", callback=function()
										goDeadBySkullMissing(rid);
									end});
									show_event(nil, event);
								else
									goDeadBySkullMissing(rid);
								end
								return true
							end
						end
					else
						login_obj.dead = true;
						show_skulls();
						saveGame();
						return true
					end
				end
				
				if(login_obj.map.lvl>4 or login_obj.ascend)then
					goNextAct();
					return true
				end
				
				if(save_obj.act4~=true)then
					local winsByClass = 0;
					for i=1,#heroes do
						local hero_obj = heroes[i];
						local win = getLoginStat("wins"..hero_obj.class);
						if(win>0)then
							winsByClass = winsByClass+1;
						end
					end

					if(save_obj.winsByClass==nil)then save_obj.winsByClass = 0; end
					if(save_obj.winsByClass~=winsByClass)then
						show_skulls(winsByClass);
						return true
					end
				end
			end

			if(localGroup.gameId)then
				local myUserEntry = battle_prms.map_point.myUserEntry;
				local save_str = json.encode(login_obj.deck);
				saveFile(localGroup.coop_save_file, save_str);
				-- royal.coop:put("users/"..myUserEntry.userId.."/"..login_obj.class, save_str, nil, function(event)
					-- if(event.isError)then
						-- print("Network error!");
					-- else
					-- end
				-- end);
									
				show_lobby();
			else
				show_map();
			end
		end
	end
	
	function gamemc:checkGameEnd()
		local units_counter = {};
		units_counter[1] = 0;
		units_counter[2] = 0;
		for i=1,#units do
			local unit = units[i];
			units_counter[unit.gid] = units_counter[unit.gid]+1;
		end
		
		if(gamemc.ended)then
			return true
		end
		if(localGroup.handling>0)then
			return true
		end
		if(localGroup.battle_started_handler)then
			return true
		end
		
		if(units_counter[player_gid]==0)then
			login_obj.dead = true;
			gamemc.ended = true;
			if(localGroup.gameId)then
				show_lobby();
			else
				show_end();
				saveGame();
			end
			
			return true
		end
		
		if(units_counter[enemy_gid]==0)then
			gamemc.ended=true;
			hero:eventHandler("battle_won", hero);
			
			local loot = {};
			if(battle_prms.map_point.ptype=="elite")then
				if(login_obj.elitelootitems==nil)then login_obj.elitelootitems=1; end
				for i=1,login_obj.elitelootitems do
					table.insert(loot, {"relic", 3, 1});
				end
				
				addLoginStat("elites");
				
				local elite_lvl = math.min(login_obj.map.lvl, 3);
				if(battle_prms.map_point.party)then
					if(battle_prms.map_point.party.lvl)then
						elite_lvl = battle_prms.map_point.party.lvl;
					end
				end
				addRunStat("elites"..elite_lvl);
				
				if(battle_prms.map_point.skull)then
					table.insert(loot, {"skull", 3, 1});
					battle_prms.map_point.skull = nil;
				end
			end
			
			if(battle_prms.map_point.ptype=="boss")then
				table.insert(loot, {"relics", 4, 3});
				map_rebuild(login_obj.map.lvl+1);
				
				table.insert(loot, {"card", 2, 3});
				table.insert(loot, {"boss", 2});
				
				addRunStat("bosses");
				
				addLoginStat("bosses");
				setLoginStat("act", login_obj.map.lvl);
				
				-- if(battle_prms.map_point.ptype=="boss")then--battle_prms.map_point.party
				-- print('achievement:', battle_prms.map_point.party.achievement)
				if(battle_prms.map_point.party.achievement)then
					_itemAchievement:createAchievement(battle_prms.map_point.party.achievement);
				end
				-- print('final1:', battle_prms.map_point.party.final);
				if(battle_prms.map_point.party.final)then
					-- login_obj.tag=hero_obj.tag;
					local tags = {};
					tags["Frontier"] = 11;
					tags["Miss Fortune"] = 12;
					tags["Shiva"] = 13;
					tags["Demon"] = 14;
					tags["Blood Mage"] = 15;
					tags["Shaman"] = 16;
					-- print('final2:', login_obj.tag, tags[login_obj.tag]);
					if(tags[login_obj.tag])then
						_itemAchievement:createAchievement(tags[login_obj.tag]);
					end
				end
				
				if(login_obj.map.lvl>3)then
					addLoginStat("wins");
					addLoginStat("wins"..login_obj.class);
				end
			else
				if(login_obj.cardonbattle==nil)then login_obj.cardonbattle=1; end
				for i=1,login_obj.cardonbattle do
					table.insert(loot, {"card", 0});
				end
				table.insert(loot, {"standart", 2});
			end
			
			if(localGroup.gameId)then
				loot = {};
				if(login_obj.cardonbattle==nil)then login_obj.cardonbattle=1; end
				for i=1,login_obj.cardonbattle do
					table.insert(loot, {"card", 0});
				end
			end
			
			gamemc:lootHandler(loot);
			
			facemc.turnBtn.isVisible = false;
			
			if(login_obj.sandbox or login_obj.cheat)then
				print('no xp for sandbox or cheat modes');
			else
				local lvlup = royal:addExp(login_obj.class, math.min(login_obj.map.lvl, 3));
				if(battle_prms.map_point.ptype=="boss")then
					lvlup = lvlup or royal:addExp(login_obj.class, getRunStat("exp"));
					setRunStat("exp", 0);
				end
				if(lvlup or options_cheats)then
					hero:addGfx("levelup");
					local new_hero_lvl = getLoginStat(login_obj.class.."_lvl");
					if(new_hero_lvl%3==0 or options_cheats)then
						-- gfxmc:addMiniTxt(sx, sy, get_txt('too_much_potions')); 
						local cx, cy = hero:localToContent(0, -hero._h);
						local img = gfxmc:addGfxImage("image/map/diamond.png", cx, cy, 60, -2);
						img.xScale, img.yScale = 1, 1;
						if(save_obj.diamonds==nil)then save_obj.diamonds=0; end
						save_obj.diamonds = save_obj.diamonds+1;
					end
				end
			end
			
			local goX, goY = _W-30*scaleGraphics, _H/2;
			local gomc = facemc:addBtn('>>>', goX, goY, function(e)
				goNext(goX, goY);
			end);
			
			return true
		end
		
		return false
	end
	
	local otime = getTimer();
	local oseconds = getSeconds();
	local function turnHandler(e)
		local dtime = getTimer() - otime;
		otime = getTimer();
		
		if(#loading_steps_arr>0)then
			return -- game is still loading
		end

		if(localGroup.battle_started_handler)then
			local st = getTimer();
			localGroup:battle_started_handler();
			return;
		end
		
		-- function facemc:refreshHand(force)
			-- facemc.__refreshHand = force;
		-- end
		-- function facemc:_refreshHand(force)
		if(facemc.__refreshHand ~= nil)then
			facemc:_refreshHand(facemc.__refreshHand);
			facemc.__refreshHand = nil;
		end
		
		if(gamemc.turned)then
			gamemc:turnEnd();
		end
		if(gamemc.started)then
			gamemc:turnStart();
		end
		
		local msgs = 0;
		for i=#units,1,-1 do
			local unit = units[i];
			msgs = msgs + unit:getMsgsCount();
		end
		if(msgs>10)then
			for i=#units,1,-1 do
				units[i]:clearMsgs();
			end
		end

		for i=#units,1,-1 do
			local unit = units[i];
			if(unit._deathstranding)then
				unit._deathstranding = nil;
			end
			if(unit.dead)then
				if(turning==unit)then
					turning = nil;
				end
				if(unit:checkMsgs())then
					if(unit._act=="go" or unit:spritePlaying()==false)then
						if(unit.targetMC)then
							unit.targetMC:removeSelf();
							unit.targetMC = nil;
						end
						table.remove(units, i);
						table.insert(deaths, unit);
					end
				end
			else
				unitAct(unit);
			end
		end
		
		gfxmc:turn(dtime);
		gfxbackmc:turn(dtime);
		if(gamemc.ended)then
			return
		end

		if(stats.turn_gid~=player_gid)then
			if(localGroup._waiting_turn)then return end
			if(localGroup.conditions>0)then return end
			if(localGroup.animations>0)then return end
			if(localGroup.hosting)then
				if(turning==nil)then
					for i=#units,1,-1 do
						local unit = units[i];
						if(unit.energy>0 and unit.dead~=true)then
							if(unit.gid~=player_gid)then
								if(unit.sleep>0 or unit.wakingup==true)then
									unit.energy = 0;
									unit.wakingup = nil;
								else
									unit.energy = 0;
									turning=unit;
									
									local next_card = unit:getNextCard();
									-- print('super', next_card.superanimation);
									unit._casted = next_card.superanimation or false;
									unit:setAct("attack"); -- super_attack
									-- unit._casted
									-- unit:getNextCard()
									-- print();
								end
								break;
							end
						end
					end
				end
				if(turning==nil)then
					if(localGroup.gameId)then
						if(gamemc.turned==false and gamemc.started==false)then
							local turn_obj = localGroup:getTurnObj();
							turn_obj.turned = true;
							turn_obj.gid = stats.turn_gid;
							localGroup:handleTurnObj(turn_obj);
							
							localGroup._waiting_turn = stats.turn+1;
						end
					else
						gamemc:turnEnd();
					end
				end
			end
		end
		
		if(localGroup.animations>0)then
			return
		end
		
		if(localGroup._regroup)then
			localGroup._regroup = nil;
			localGroup:regroup(true);
		end
		
		if(localGroup.checkCards)then
			if(localGroup.checkCardsTimer==nil)then
				localGroup.checkCardsTimer = 1000;
			end
			if(localGroup.checkCardsTimer<0)then
				localGroup.checkCardsTimer = 2000;
				localGroup:checkCards();
			else
				localGroup.checkCardsTimer = localGroup.checkCardsTimer-dtime;
			end
			
			localGroup:unhandledCardsHandler();
		end
		
		if(localGroup.updateAllCards)then
			updateAllCards();
		end
		
		gamemc:checkGameEnd();
		
		-- gamemc:turnGame();
			-- gamemc._turnGame = true;
		if(gamemc._turnGame)then
			gamemc._turnGame = nil;
			gamemc:turnGame();
		end
		
		-- local oseconds = getSeconds();
		if(getSeconds() ~= oseconds)then
			oseconds = getSeconds();
			if(stats.turn_gid == player_gid)then
				if(#hand<1)then
					hero:eventHandler("empty_hand", hero);
				end
			end
		end
	end
	Runtime:addEventListener("enterFrame", turnHandler);
	
	function gamemc:getTargetsByCard(source, card_obj)
		local targets = {};
		local range = card_obj.range;
		if(card_obj.rangeEnemies)then
			-- print("rangeEnemies:", card_obj.rangeEnemies, source[card_obj.rangeEnemies]);
			if(source[card_obj.rangeEnemies])then
				if(source[card_obj.rangeEnemies]~=0)then
					range = "enemies";
				end
			end
			-- print('', 'range:', range)
		end
		if(range=="owner")then
			table.insert(targets, source.owner);
		elseif(range=="self")then
			table.insert(targets, source);
		else
			for i=#units,1,-1 do
				local unit = units[i];
				local targetable = ((range=='enemy' or range=='enemies' or range=='rnd' or range=='rndmiss' or range=="minhp") and unit.gid~=source.gid) or (range=='self' and unit.gid==source.gid);
				targetable = targetable and unit.untargetable==0;
				if(targetable and unit.dead~=true)then
					if(range=="minhp")then
						if(#targets<1)then
							table.insert(targets, unit);
						else
							local hp1, hpmax1 = targets[1]:getHP();
							local hp2, hpmax2 = unit:getHP();
							if(hp2<hp1)then
								targets[1] = unit;
							end
						end
					else
						table.insert(targets, unit);
					end
				end
			end
		end
		if(range=='rnd' or range=='rndmiss')then
			table.shuffle(targets);
		end
		return targets, range;
	end
	function gamemc:useCardViaOwnTargets(card_obj, source, eventable)
		local targets, range = gamemc:getTargetsByCard(source, card_obj);
		for i=1,#targets do
			local unit = targets[i];
			gamemc:useCard(card_obj, unit, source, eventable);
			if((math.random()>0.5 and range=='rndmiss') or range=='rnd')then
				break;
			end
		end
	end
	
	local shortCutExclude = {range=true, tag=true, gfx_target=true, strX=true};
	local function playOnce(card_obj, target, source, eventable, times)
		_G.card_counter = _G.card_counter+1;
		if(target==nil)then
			print('error@target = ', target);
			return 0;
		end
		
		local function compact(attr)
			-- print("_playOnce", card_obj[attr], times);
			if(card_obj[attr] and times>1)then
				local prms = table.keysEx(card_obj, shortCutExclude);
				if(#prms<5)then
					local new_obj = table.cloneByAttr(card_obj);			
					-- for i=1,#prms do
						-- print(i, prms[i]);
					-- end
					new_obj[attr] = new_obj[attr]*times;
					
					card_obj = new_obj;
					times = 1;
				end
			else
				-- local prms = table.keysEx(card_obj, shortCutExclude);
				-- for i=1,#prms do
					-- print(i, prms[i]);
				-- end
			end
		end
		compact("str");
		compact("dmg");
		compact("heal");
		compact("poison");
		
		if(times==nil)then times=1; end
		local unblocked_dmg = 0;
		if(card_obj.range=='enemies' or card_obj.range=='rndmiss')then
			local targets = gamemc:getTargetsByCard(source, card_obj);
			for j=1,times do
				for i=1,#targets do
					local unit = targets[i];
					unblocked_dmg = unblocked_dmg + gamemc:useCard(card_obj, unit, source, eventable);
					if(math.random()>0.5 and card_obj.range=='rndmiss')then
						break;
					end
				end
			end
		elseif(card_obj.range=='rnd')then
			local targets = gamemc:getTargetsByCard(source, card_obj);
			if(#targets>0)then
				local target = table.random(targets);
				target.current_card = {};
				for j=1,times do
					unblocked_dmg = unblocked_dmg + gamemc:useCard(card_obj, target, source, eventable);
				end
				target.current_card = nil;
			else
				print('no targets!');
			end
		else
			target.current_card = {};
			for j=1,times do
				unblocked_dmg = unblocked_dmg + gamemc:useCard(card_obj, target, source, eventable);
			end
			target.current_card = nil;
		end
		return unblocked_dmg;
	end
	local function playLast(card_obj, target, source)
		if(card_obj.nulify)then
			-- print("nulify:", card_obj.tag, card_obj.nulify, localGroup.conditions);
			-- print("_card_obj.nulify:", target[card_obj.nulify]);
			localGroup.conditions = localGroup.conditions+1;
			local function addConditions(evt)
				if(target[card_obj.nulify]==0)then
					Runtime:removeEventListener("enterFrame", addConditions);
					localGroup.conditions = localGroup.conditions-1;
					target:refreshHP();
				end
				target[card_obj.nulify] = 0;
			end
			Runtime:addEventListener("enterFrame", addConditions);
		end
	end

	function gamemc:playCard(card_obj, target, source, interruptable, eventable, times)
		print("playCard", card_obj.tag, source.interrupt, card_obj.draw, eventable, times, card_obj.endTurn);
		if(source==nil or target==nil)then
			return 0;
		end

		if(source.interrupt>0 and interruptable)then
			source.interrupt = source.interrupt-1;
			source:addMsg(get_txt('interrupted'), {1, 0, 0});
			source:refreshHP();
			return 0;
		end

		local unblocked_dmg = 0;
		if(card_obj.times==nil)then card_obj.times=1; end
		if(times==nil)then times=1; end
		
		if(card_obj.exhaust)then
			card_obj.exhausted = true;
		end

		if false then
		local function compact(attr)
			-- print("_playOnce", card_obj[attr], times);
			if(card_obj[attr] and times>1)then
				local prms = table.keysEx(card_obj, shortCutExclude);
				-- print("__playOnce:", attr, card_obj.tag, times, #prms, #prms<5);
				
				if(#prms<5)then
					local new_obj = table.cloneByAttr(card_obj);			
					for i=1,#prms do
						print(i, prms[i]);
					end
					new_obj[attr] = new_obj[attr]*times;
					
					card_obj = new_obj;
					times = 1;
				end
			else
				-- local prms = table.keysEx(card_obj, shortCutExclude);
				-- for i=1,#prms do
					-- print(i, prms[i]);
				-- end
			end
		end
		compact("str");
		compact("dmg");
		compact("heal");
		compact("poison");
		end
		
		for i=1,card_obj.times do
			unblocked_dmg = unblocked_dmg + playOnce(card_obj, target, source, eventable, times);
		end

		if(card_obj.once)then
			if(card_obj.once.range=="self")then
				unblocked_dmg = unblocked_dmg + playOnce(card_obj.once, source, source, eventable, times);
				playLast(card_obj.once, source, source);
			else
				unblocked_dmg = unblocked_dmg + playOnce(card_obj.once, target, source, eventable, times);
				playLast(card_obj.once, target, source);
			end
		end
		
		if(card_obj.scry)then
			local scry = card_obj.scry + (source.scryAdd or 0);
			gamemc:onUseHandler({action="discard", target="deck", filter={"ctype", "all", false}, amount=scry, force=false, limit=scry}, card_obj, target, source);
			source:eventHandler("scry", source);
		end
		if(card_obj.onUse)then
			local useObj = card_obj.onUse;
			gamemc:onUseHandler(useObj, card_obj, target, source);
		end
		if(card_obj.money)then
			login_obj.money = login_obj.money + card_obj.money;
			facemc:moneyRefresh();
		end
		
		if(card_obj.choose)then
			local list = card_obj.choose;
			for i=1,#list do
				local obj = list[i];
				if(obj.tag==nil)then
					for attr,val in pairs(obj) do
						if(attr~="tag" and attr~="times" and attr~="lvl")then
							obj.tag = attr;
						end
					end
				end
				obj.energy = 0;
				obj.class = "none";
				obj.rarity = 0;
				obj.ctype = 2;
			end
			showCardPick(facemc, localGroup.buttons, _W/2, 0, list, 1, false, function(new_card, mc)
				gamemc:playCard(new_card, target, source, false, true);
			end);
		end
		
		if(card_obj.peek)then
			-- showCardPick(facemc, buttons, sx, sy, list, amount, upgradeable, callback, onClose, force)
			-- showCardPick(facemc, localGroup.buttons, _W/2, 0, list, useObj.amount, useObj.action=="upgrade", function(new_card, mc)
			local list = {};
			local imax = math.min(card_obj.peek, #deck);
			for i=1,imax do
				table.insert(list, deck[#deck-(i-1)]);
			end
			showCardPick(facemc, localGroup.buttons, _W/2, 0, list, card_obj.peek, false, function(new_card, mc)
				gamemc:moveCardTo(new_card, draw);
				local cardmc = handmc:getMCbyCardObj(new_card);
				if(cardmc)then
					facemc:insert(cardmc);
					transition.to(cardmc, {time=500, x=facemc.draw.x, y=facemc.draw.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
				end
				facemc:refreshDeksNumbers();
			end, nil, false);
		end
		
		if(card_obj.harmByAttr)then
			source:harm(source[card_obj.harmByAttr]);
		end
		if(card_obj.harm)then
			local val = card_obj.harm;
			if(card_obj.harmRnd)then
				val = val + math.random(0, card_obj.harmRnd);
			end
			source:harm(val);
		end
		
		if(card_obj.after)then
			if(card_obj.after.range=="self")then
				unblocked_dmg = unblocked_dmg + playOnce(card_obj.after, source, source, eventable, times);
				playLast(card_obj.after, source, source);
			else
				unblocked_dmg = unblocked_dmg + playOnce(card_obj.after, target, source, eventable, times);
				playLast(card_obj.after, target, source);
			end
		end
		
		if(card_obj.vamparmor and unblocked_dmg>0)then
			source:addStat("armor", unblocked_dmg);
			target:addGfx("magic_drain_life_target");
			source:addGfx("magic_drain_life_cast");
		end
		if(card_obj.vamp)then
			source:heal(unblocked_dmg);
			if(unblocked_dmg>0)then
				-- magic_drain_life_target
				-- magic_drain_life_cast
				target:addGfx("magic_drain_life_target");
				source:addGfx("magic_drain_life_cast");
			end
		end
		
		playLast(card_obj, target, source);
		
		if(card_obj.gfx_target)then
			target:addGfx(card_obj.gfx_target);
		end
		if(card_obj.gfx_source)then
			source:addGfx(card_obj.gfx_source);
		end
		
		if(card_obj.ctype and eventable)then
			if(source.card_played_this_turn==nil)then source.card_played_this_turn=0; end
			source:eventHandler("played_"..card_obj.ctype, source);
			source:eventHandler("played_any", source);
			source.card_played_this_turn = source.card_played_this_turn+1;
			source["card_type_"..card_obj.ctype.."_played"] = source["card_type_"..card_obj.ctype.."_played"]+1;
			
			for i=1,6 do
				if(source.card_played_this_turn%i == 0)then
					source:eventHandler("played_cards_"..i, source);
				end
			end
			
			
			local ctype_played = source["card_type_"..card_obj.ctype.."_played"];
			for i=1,5 do
				if(ctype_played%i == 0)then
					source:eventHandler("played_ctype"..card_obj.ctype.."_x"..i, source);
				end
			end
			
			source:addStat("cards_game", 1);
			source:addStat("cards_game_"..card_obj.ctype, 1);
			source:addStat("cards_turn_"..card_obj.ctype, 1);
			
			source.played_last_card_ctype = card_obj.ctype;
			
			for i=1,#units do
				local unit = units[i];
				if(unit.gid~=source.gid)then
					unit:eventHandler("enemy_played_any", source);
					unit:eventHandler("enemy_played_"..card_obj.ctype, source);
				end
			end
			if(source==hero)then
				hero:onCtypePlayed(card_obj.ctype);
			end
		end
		
		if(card_obj.ctype==CTYPE_ATTACK)then
			if(source.stealmoney>0)then
				local money = target:stolen(source.stealmoney);
				source:addStat("money", money);
				facemc:moneyRefresh();
			end
		end
		
		-- print("_exhaust1:", card_obj.exhaust, card_obj.exhausted);
		if(card_obj.exhaust)then
			if(login_obj.exhaust_fail==nil)then login_obj.exhaust_fail=0; end
			if(math.random() > login_obj.exhaust_fail/100 or card_obj.class=="negative")then
				card_obj.exhausted = true;
				source:eventHandler("exhausted", source);
			else
				card_obj.exhausted = false;
				show_msg(get_txt('exhaust_failed'));
			end
		end
		
		if(card_obj.skipTurnAct)then
			target.energy = 0;
		end
		
		if(card_obj.endTurn and stats.turn_gid == player_gid)then
			gamemc._turnGame = true;
		end
	end
	
	function gamemc:ruleOut(rule, unit, card_obj)
		if(rule=="unplayable")then
			return false
		end
		if(rule=="empydeck")then
			return #deck<1;
		end
		if(rule=="harmed")then
			return unit.harmed>0;
		end
		if(rule=="lastcard")then
			return #hand<2;
		end
		if(rule=="attack_hand")then
			for i=1,#hand do
				local card = hand[i];
				if(card.dead~=true)then
					-- print(i, card.tag, card.ctype, CTYPE_ATTACK, card.ctype~=CTYPE_ATTACK);
					if(card.ctype~=CTYPE_ATTACK)then
						return false
					end
				end
			end
		end
		if(rule=="only_attack")then
			for i=1,#hand do
				local card = hand[i];
				if(card.dead~=true and card~=card_obj)then
					-- print(i, card.tag, card.ctype, CTYPE_ATTACK, card.ctype~=CTYPE_ATTACK, card~=card_obj);
					if(card.ctype==CTYPE_ATTACK)then
						return false
					end
				end
			end
		end
		return true
	end
	
	function gamemc:iniPotions()
		if(save_obj.potions==nil)then save_obj.potions={}; end
		local potionsmc = facemc.potionsmc;
		for i=1,potionsmc.numChildren do
			local mc = potionsmc[i];
			mc.homeX, mc.homeY = mc.x, mc.y;
			-- mc.potion_id = potion_id;
			-- mc.ico = ico;
			if(mc.potion_id)then
				local card_obj = _G.potions_indexes[mc.potion_id] or save_obj.potions[mc.potion_id];
			
				mc.dragable = true;
				local targets;
				function mc:onPick()
					-- attack_over
					-- addGfxByID(tar, tx, ty, id, scale)
					targets = gamemc:getTargetsByCard(hero, card_obj);
					for i=1,#targets do
						local unit = targets[i];
						if(unit.targetMC)then
							unit.targetMC:setSequence("attack_over");
							unit.targetMC:play();
							unit.targetMC.x, unit.targetMC.y = unit.x, unit.y-34;
						else
							unit.targetMC = addGfxByID(gamemc, unit.x, unit.y-34, "attack_over");--source:addGfx("magic_drain_life_cast");
						end
					end
				end
				function mc:onMove()
					-- local tx, ty = mc.x, mc.y;
					local cx, cy = mc:localToContent(0, 0);
					mc.tar = nil;
					
					if(targets)then
						local tar;
						local minDD=999999999999;
						for i=1,#targets do
							local unit = targets[i];
							local tx, ty = unit.x, unit.y;
							if(unit.localToContent)then
								tx, ty = unit:localToContent(0, 0);
								local dd = get_dd_ex(cx, cy, tx, ty);
								if(unit.targetMC)then
									unit.targetMC:setFillColor(1, 0, 0);
								end
								
								local r = 110*scaleGraphics/2;
								if(dd<r*r and (minDD>dd or tar==nil))then
									tar = unit;
									minDD = dd;
								end
							end
						end
						if(tar)then
							mc.tar = tar;
							if(card_obj.range=='enemies' or card_obj.range=='rnd')then
								for i=1,#targets do
									local unit = targets[i];
									unit.targetMC:setFillColor(0, 1, 0);
								end
							else
								if(tar.targetMC)then
									tar.targetMC:setFillColor(0, 1, 0);
								end
							end
						end
					end
				end
				function mc:onDrop()
					mc.disable = true;
					
					-- if(card_obj.playable)then
						-- local rule = gamemc:ruleOut(card_obj.playable, hero);
						-- if(rule~=true)then
							-- mc.tar = nil;
							-- show_msg(get_txt('rule_'..card_obj.playable..'_hint'));
						-- end
					-- end
					
					if(mc.tar)then
						gamemc:playCard(card_obj, mc.tar, hero, true, false);
						
						hero:eventHandler("potion_used", hero);

						-- gamemc:cleanHand();
						facemc:refreshEnergy();
						-- mc:animateSelfOut();
						hero:setAct("attack");
						
						table.remove(login_obj.potions, mc.id);
						refreshPotions(facemc, localGroup.buttons);
						gamemc:iniPotions();
						
						sound_play("potion_"..card_obj.range);
					else
						-- local card_prms = cards_indexes[ctype];

						transition.cancel(mc)
						transition.to(mc, {time=200, x=mc.homeX, y=mc.homeY, transition=easing.inQuad, onComplete=function(e)
							mc.disable = false;
						end});
						mc:onOut();
					end
					
					for i=#units,1,-1 do
						local unit = units[i];
						if(unit.targetMC)then
							if(unit.targetMC.sequence=="attack_over")then
								unit.targetMC:setSequence("attack_off");
								unit.targetMC:play();
							end
						end
					end
				end
				
				mc.disable = false;
				function mc:disabled()
					return mc.disable or stats.turn_gid~=player_gid or gamemc.ended or facemc.popup~=nil; 
				end
			
			end
		end
	end
	
	function gamemc:createCardMC(tar, card_obj)
		local ctype = card_obj.tag;
		local card_prms = cards_indexes[ctype];
		local mc, body, ntxt = createCardMC(tar, card_obj, hero);

		function mc:animateSelfOut(delay)
			facemc:insert(mc);
			mc.x, mc.y = mc.x+mc.parent.x, mc.y+mc.parent.y;
			transition.to(mc, {delay=delay, time=500, alpha=0, y=mc.y-50, xScale=1/4, yScale=1/4, transition=easing.outQuad, onComplete=function(obj)
				transitionRemoveSelfHandler(mc);
				if(mc.hideExtraHints)then
					mc:hideExtraHints(); 
				end
			end});
		end

		function mc:ini()
			mc.act = function(e)
				
			end
			table.insert(localGroup.buttons, mc);
			mc.w, mc.h = 70*scaleGraphics, 80*scaleGraphics;
			mc.ani = nil;
			function mc:onOver()
				-- print('over', mc.__draging)
				if(mc.parent)then
					mc.parent:insert(mc);
					ntxt:setTextColor(1, 0.5, 0.5);

					transition.cancel(body)
					transition.to(body, {time=300, xScale=settings.cardScaleMax, yScale=settings.cardScaleMax, y=-72*scaleGraphics*(settings.cardScaleMax-settings.cardScaleMin), transition=easing.outQuad, onComplete=function(obj)
						mc:showExtraHints();
					end});
				end
			end
			function mc:onOut()
				-- print('out', mc.__draging, mc.holded)
				if(mc.__draging)then
					return
				end
				if(ntxt.c)then ntxt:setTextColor(ntxt.c[1], ntxt.c[2], ntxt.c[3]); end

				transition.cancel(body)
				transition.to(body, {time=200, xScale=settings.cardScaleMin, yScale=settings.cardScaleMin, y=0, transition=easing.inQuad});
				
				mc:hideExtraHints();
			end
			
			mc.dragable = true;
			local targets;
			function mc:onPick()
				mc:hideExtraHints();
				targets = gamemc:getTargetsByCard(hero, card_obj);
				for i=1,#targets do
					local unit = targets[i];
					if(unit.targetMC)then
						unit.targetMC:setSequence("attack_over");
						unit.targetMC:play();
						unit.targetMC.x, unit.targetMC.y = unit.x, unit.y-34;
					else
						unit.targetMC = addGfxByID(gamemc, unit.x, unit.y-34, "attack_over");
					end
				end
				transition.cancel(mc);
				if(settings.dragAndDrop~=true)then
					mc.holded = true;
				end
			end
			function mc:onMove()
				local cx, cy = 0, 0;
				if(mc.localToContent)then
					cx, cy = mc:localToContent(0, 0);
				end
				mc.tar = nil;
				
				if(mc.y~=nil and mc.y<mc.homeY-50*settings.cardScaleMax)then
					if(body.xScale)then
						local tscale = settings.cardScaleMin/2;
						body.xScale = body.xScale + (tscale - body.xScale)/4;
						body.yScale = body.xScale;
					end
					if(mc.holded)then
						mc.holded = false;
					end
				else
					if(body.xScale)then
						local tscale = settings.cardScaleMax;
						body.xScale = body.xScale + (tscale - body.xScale)/4;
						body.yScale = body.xScale;
					end
				end
				
				if(targets)then
					local tar;
					local minDD=999999999999;
					for i=1,#targets do
						local unit = targets[i];
						local tx, ty = unit.x, unit.y;
						if(unit.localToContent)then
							tx, ty = unit:localToContent(0, 0);
							local dd = get_dd_ex(cx, cy, tx, ty);
							if(unit.targetMC)then
								unit.targetMC:setFillColor(1, 0, 0);
							end
							
							local r = 110*scaleGraphics/2;
							if(dd<r*r and (minDD>dd or tar==nil))then
								tar = unit;
								minDD = dd;
							end
						end
					end
					
					if(tar)then
						mc.tar = tar;
						if(card_obj.range=='enemies' or card_obj.range=='rnd')then
							for i=1,#targets do
								local unit = targets[i];
								unit.targetMC:setFillColor(0, 1, 0);
							end
						else
							if(tar.targetMC)then
								tar.targetMC:setFillColor(0, 1, 0);
							end
						end
					end
				end
			end
			function mc:onDrop()
				mc.disable = true;
				mc:onMove();
				-- print("_mc.holded:", mc.holded);
				if(mc.holded)then
					mc.x=mc.homeX; 
					mc.y=mc.homeY;
					body.xScale = settings.cardScaleMax;
					body.yScale = settings.cardScaleMax;
					facemc.holded = mc;
					mc:showExtraHints();
				else
					mc:onDropEx();
				end
			end
			function mc:onDropEx()
				if(mc.tar and mc.tar.untargetable and mc.tar.untargetable>0)then
					mc.tar = nil;
					show_msg(get_txt('untargetable'));
				end
				if(card_obj.playable)then
					local rule = gamemc:ruleOut(card_obj.playable, hero, card_obj);
					if(rule~=true)then
						mc.tar = nil;
						show_msg(get_txt('rule_'..card_obj.playable..'_hint'));
					end
				end
				
				if(hero.silenceskills>0)then
					if(card_obj.ctype==CTYPE_SKILL)then
						mc.tar = nil;
						show_msg(get_txt('silenceskills_hint'));
					end
				end
				if(hero.entangled>0)then
					if(card_obj.ctype==CTYPE_ATTACK)then
						mc.tar = nil;
						show_msg(get_txt('entangled_hint'):gsub("VAL", hero.entangled));
					end
				end
				
				local played = false;
				if(mc.tar and hero.dead~=true)then
					if(card_obj.energy=="x")then
						card_obj.times = math.max(0, gameobj.energy) + hero.extrax + (card_obj.extraX or 0);
						localGroup:playCard(card_obj, mc.tar, hero, true, true);
						card_obj.times = 0;
						gameobj.energy = 0;
						played = true;
					else
						local energy = card_obj.energyTemp or card_obj.energyTillUse or card_obj.energy;
						if(gameobj.energy >= energy or hero.freecast>0 or (hero.freeattack>0 and card_obj.ctype==CTYPE_ATTACK))then
							localGroup:playCard(card_obj, mc.tar, hero, true, true);
							
							if(hero.doubleheavytap>0 and card_obj.ctype==CTYPE_ATTACK and card_obj.energy>1)then
								hero.doubleheavytap = hero.doubleheavytap-1;
								localGroup:playCard(card_obj, mc.tar, hero, true, true);
							end
							if(hero.doubletap>0 and card_obj.ctype==CTYPE_ATTACK)then
								hero.doubletap = hero.doubletap-1;
								localGroup:playCard(card_obj, mc.tar, hero, true, true);
							end
							if(hero.doubleskill>0 and card_obj.ctype==CTYPE_SKILL)then
								hero.doubleskill = hero.doubleskill-1;
								localGroup:playCard(card_obj, mc.tar, hero, true, true);
							end
							if(hero.doublepower>0 and card_obj.ctype==CTYPE_POWER)then
								hero.doublepower = hero.doublepower-1;
								localGroup:playCard(card_obj, mc.tar, hero, true, true);
							end
							if(hero.doubleplay>0)then
								hero.doubleplay = hero.doubleplay-1;
								localGroup:playCard(card_obj, mc.tar, hero, true, true);
							end
							
							if(hero.freecast>0)then
								hero.freecast = hero.freecast-1;
							elseif(hero.freeattack>0 and card_obj.ctype==CTYPE_ATTACK)then
								hero.freeattack = hero.freeattack-1;
							else
								gameobj.energy = gameobj.energy - energy;
							end
							hero:refreshHP();

							card_obj.energyTillUse = nil;
							played = true;
						else
							show_msg(get_txt('not_enought_energy'));
						end
					end
					facemc:refreshRelics(hero);
				end

				if(mc.hideExtraHints)then
					mc:hideExtraHints(); 
				end
				
				if(played)then
					card_obj.dead = true;
					gamemc:cleanHand();
					facemc:refreshEnergy();
					mc:animateSelfOut();
					hero:setAct("attack");

					facemc:refreshHand();
					
					if(card_obj.ctype==CTYPE_POWER)then
						hero:addGfx("sword_fall");
					end

					if(#hand<1)then
						hero:eventHandler("empty_hand", hero);
					end
					facemc:refreshDeksNumbers();
				else
					-- print("mc.x:", mc.x);
					-- local tw = 52*scaleGraphics*settings.cardScaleMin*2;
					-- if(mc.x<tw)then
						-- mc.disable = false;
						-- local old=hand[1];
						-- for i=1,#hand do
							-- if(hand[i]==card_obj)then
								-- hand[1] = card_obj;
								-- hand[i] = old;
								-- break;
							-- end
						-- end
						-- facemc:refreshHand();
					-- elseif(mc.x>_W-tw)then
						-- mc.disable = false;
						-- local old=hand[#hand];
						-- for i=1,#hand do
							-- if(hand[i]==card_obj)then
								-- hand[#hand] = card_obj;
								-- hand[i] = old;
								-- break;
							-- end
						-- end
						-- facemc:refreshHand();
					-- else
						transition.cancel(mc)
						transition.to(mc, {time=200, x=mc.homeX, y=mc.homeY, transition=easing.inQuad, onComplete=function(e)
							mc.disable = false;
						end});
						mc:onOut();
					-- end
					
				end
				
				for i=#units,1,-1 do
					local unit = units[i];
					if(unit.targetMC)then
						if(unit.targetMC.sequence=="attack_over")then
							unit.targetMC:setSequence("attack_off");
							unit.targetMC:play();
						end
					end
				end
			end
			
			mc.disable = false;
			function mc:disabled()
				return mc.disable or stats.turn_gid~=player_gid or gamemc.ended or facemc.wnd~=nil or facemc.popup~=nil or facemc.holded~=nil;
			end
			
			mc.ini = nil;
		end
		
	
		return mc
	end
	
	function gamemc:upgradeCard(card_obj)
		local mc = handmc:getMCbyCardObj(card_obj);
		upgradeCard(card_obj, mc);
	end
	
	function gamemc:shuffleDeck()
		table.shuffle(deck);
		table.shuffle(deck);
		table.shuffle(deck);
	end
	function gamemc:addCardToDraw(card)
		table.insert(draw, card);
		facemc:refreshDeksNumbers();
	end
	function gamemc:addCardToDeck(card)
		table.insert(deck, card);
		facemc:refreshDeksNumbers();
	end
	function gamemc:addCardToHand(card)
		hero:eventHandler(card.tag, hero);
		hero:eventHandler("addedCtype"..card.ctype, hero);
		
		for i=#hand,1,-1 do
			local old = hand[i];
			if(old.tag==card.tag and old.lvl==card.lvl)then
				hero:eventHandler("samecardinhand", hero);
			end
		end
		
		for l=1,#lists do
			local list = lists[l];
			for i=#list,1,-1 do
				if(list[i]==card)then
					table.remove(list, i);
				end
			end
		end
			
		table.insert(hand, card);
	end
	function gamemc:moveCardTo(card_obj, to)
		for l=1,#lists do
			local list = lists[l];
			for i=#list,1,-1 do
				if(list[i]==card_obj)then
					if(list==hand and to==draw)then
						hero:onDiscard();
						if(card_obj.onDiscard)then
							gamemc:playCard(card_obj.onDiscard, hero, hero, true);
						end
						hero:eventHandler("discard", hero);
					end
					table.remove(list, i);
					break;
				end
			end
		end
		
		table.insert(to, card_obj);
	end
	function gamemc:refillDeck()
		while(#draw>0)do
			table.insert(deck, table.remove(draw, 1));
		end
		gamemc:shuffleDeck();
		hero:eventHandler("shuffle", hero);
	end
	function gamemc:drawCard(innate, ifDraw, onlyKeepZero)
		if(#deck<1)then
			gamemc:refillDeck();
		end
		
		if(#deck>0)then
			local i = #deck;
			if(innate)then
				for j=#deck,1,-1 do
					if(deck[j].innate)then
						i=j;
						break;
					end
				end
			end
			local card_obj = table.remove(deck, i);
			card_obj.dead = nil;
			card_obj.energyTemp = nil;
			
			if(hero.confuse>0)then
				card_obj.energy = math.random(0,4);
			end
			
			if(card_obj.onDraw)then
				gamemc:onUseHandler(card_obj.onDraw, card_obj, hero, hero);
			end
			if(ifDraw)then
				if(card_obj.ctype == ifDraw.ctype)then
					gamemc:playCard(ifDraw, hero, hero, true);
				end
			end
			

			gamemc:addCardToHand(card_obj);
			
			if(onlyKeepZero)then
				local energy = card_obj.energyTemp or card_obj.energyTillUse or card_obj.energy;
				if(energy~=0)then
					card_obj.dead = true;
				end
			end
		end
	end
	function gamemc:drawCards(imax, innate, ifDraw, onlyKeepZero)
		if(imax==nil)then
			imax = login_obj.drawPower;
			if(stats.turn==1)then
				imax = imax + login_obj.drawPowerStart;
			end
			-- print("drawCards:", gameobj.turn, stats.turn, imax);
		end
		if(hero.drawless>0)then
			imax = imax-1;
		end
		for i=1,imax do
			gamemc:drawCard(innate, ifDraw, onlyKeepZero);
		end
		
		facemc:refreshDeksNumbers();
	end
	
	function gamemc:handlePlayedCard(card_obj)
		if(card_obj.ctype==CTYPE_POWER and card_obj.dead)then
			-- power cards are absorbed if played
		elseif(card_obj.dead~=true and (card_obj.retain or card_obj.tempRetain))then	
			card_obj.tempRetain = nil;
			table.insert(hand, card_obj);
			if(card_obj.onRetain)then
				gamemc:handleCardsAttrsManipulations(card_obj, card_obj.onRetain, hero, hero);
			end
			if(hero.cheapretainer>0)then
				card_obj.energy = math.max(card_obj.energy - hero.cheapretainer, 0);
			end
		else
			card_obj.dead = false;--reseting played card
			if(card_obj.exhausted)then
				if(card_obj.onExhaust)then
					gamemc:playCard(card_obj.onExhaust, hero, hero, true);
				end
				table.insert(trash, card_obj);
			else
				if(hero.rebound>0)then
					hero.rebound = hero.rebound-1;
					hero:refreshHP();
					table.insert(deck, card_obj);
				else
					table.insert(draw, card_obj);
				end
			end
		end
		
	end
	function gamemc:cleanHand()
		for i=#hand,1,-1 do
			local card_obj = hand[i];
			if(card_obj.dead)then
				table.remove(hand, i);
				gamemc:handlePlayedCard(card_obj);
			end
		end
	end
	function gamemc:discardHand()
		if(hero.retainhand>0)then
			return;
		end
		for i=#hand,1,-1 do
			if(hand[i].hold)then
				hand[i].hold = nil;
			else
				local card_obj = table.remove(hand, i);
				if(card_obj.ethereal)then -- should be removed if not played
					if(card_obj.dead~=true)then -- not played
						card_obj.exhausted = true;
						hero:eventHandler("exhausted", hero);
					end
				end
				if(card_obj.onTurn)then
					gamemc:playCard(card_obj.onTurn, hero, hero, true);
				end

				gamemc:handlePlayedCard(card_obj);
				
				local mc = handmc:getMCbyCardObj(card_obj);
				if(mc)then
					mc.x, mc.y = mc.x+handmc.x, mc.y+handmc.y;
					facemc:insert(mc);
					
					mc.disable = true;
						
					transition.cancel(mc);
					
					if(card_obj.ethereal)then
						elite.addAniByMasks(mc, "image/masks/bite_", transitionRemoveSelfHandler);
						transition.to(mc, {time=1000, y=mc.y - 100*scaleGraphics, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler})
					else					
						if(card_obj.exhausted)then
							transition.to(mc, {time=300 + (facemc.trash.x-mc.x)/2, x=facemc.trash.x, y=facemc.trash.y, transition=easing.outQuad, xScale=scaleGraphics/3, yScale=scaleGraphics/3, onComplete=transitionRemoveSelfHandler});
						else
							transition.to(mc, {time=300 + (facemc.draw.x-mc.x)/2, x=facemc.draw.x, y=facemc.draw.y, transition=easing.outQuad, xScale=scaleGraphics/3, yScale=scaleGraphics/3, onComplete=transitionRemoveSelfHandler});
						end
					end
				end
			end
		end
		
		facemc:refreshDeksNumbers();
	end
	
	function gamemc:onHand(hand_obj, tar, source)
		local count = 0;
		for i=#hand,1,-1 do
			local card_obj = hand[i];
			local ctype = card_obj.id;
			if(card_obj.dead~=true)then
				if((card_obj.ctype==hand_obj.ctype)==hand_obj.value)then
					if(hand_obj.action=="discard")then
						card_obj.dead = true;
						gamemc:moveCardTo(card_obj, draw);
					end
					if(hand_obj.action=="exhaust")then
						card_obj.exhausted = true;
						card_obj.dead = true;
						source:eventHandler("exhausted", source);
						local mc = handmc:getMCbyCardObj(card_obj);
						if(mc)then
							mc:animateSelfOut();
						end
					end
					count = count+1;
				end
			end
		end
		
		facemc:refreshDeksNumbers();
		facemc:refreshHand();
		
		if(count>0)then
			local card_obj = hand_obj.onCount;
			if(card_obj)then
				for i=1,count do
					gamemc:useCard(card_obj, tar, source);
				end
			end
		end
	end
	
	function gamemc:onUseHandler(useObj, card_obj, tar, source)
		-- print('onUse:', useObj);
		if((tar==hero or source==hero) and (useObj.action=="copy" or useObj.action=="upgrade" or useObj.action=="hold" or useObj.action=="redeck" or useObj.action=="rehand" or useObj.action=="discard" or useObj.action=="exhaust" or useObj.action=="energyZero" or useObj.action=="change" or useObj.action=="transform"))then
			if(useObj.target=="this")then
				-- gamemc:addCardToDraw(table.cloneByAttr(card_obj));
				if(useObj.action=="copy")then
					local list_target = login_obj.game[useObj.to];-- hand, deck, draw
					table.insert(list_target, table.cloneByAttr(card_obj));
				else
					card_obj.dead = false;
					card_obj.exhausted = false;
					gamemc:moveCardTo(card_obj, deck);
					
					local cardmc = handmc:getMCbyCardObj(card_obj);
					if(cardmc)then
						facemc:insert(cardmc);
						transition.to(cardmc, {time=500, x=facemc.deck.x, y=facemc.deck.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
					end
				end
				facemc:refreshDeksNumbers();
				facemc:refreshHand();
			end
			if(useObj.target=="hand" or useObj.target=="draw" or useObj.target=="deck" or useObj.target=="trash" or useObj.target=="all" or useObj.target=="permanent")then
				local filter = useObj.filter;
				local list = {};
				local sources;
				if(useObj.target=="all")then
					sources = lists;
					if(useObj.action=="discard")then
						sources = listsX;
					end
					-- for l=1,#lists do
						-- for i=1,#lists[l] do
							-- table.insert(list, lists[l][i]);
						-- end
					-- end
				else
					-- local list_target = login_obj.game[useObj.target];
					sources = {login_obj.game[useObj.target]}; -- login_obj.game.permanent -- permanent
				end
				
				for j=1,#sources do
					local list_target = sources[j];
					for i=1,#list_target do
						local this_card_obj = list_target[i];
						if((this_card_obj.dead~=true and useObj.target=="hand") or useObj.target~="hand")then
							if(filter==nil or filter=="all" or (this_card_obj[filter[1]]==filter[2]) == filter[3])then
								table.insert(list, this_card_obj);
							end
						end
					end
				end
				-- print('onUse:', #list);
				showCardPick(facemc, localGroup.buttons, _W/2, 0, list, useObj.amount, useObj.action=="upgrade", function(new_card, mc)
					-- if(new_card.rewriteOnUseAction)then
						-- action = 
					-- end
					if(useObj.action == "energyZero")then
						new_card.energy = 0;

						local cardmc = handmc:getMCbyCardObj(new_card);
						cardmc:update();
					end
					if(useObj.action == "transform")then
						-- useObj.val="Ash"
						new_card.exhausted = true;
						new_card.dead = true;
						new_card.removed = true;
						
						local temp = table.cloneByAttr(cards_indexes[useObj.val]);
						if(temp)then
							gamemc:addCardToHand(temp);
						else
							show_msg("error: missing card "..tostring(useObj.val));
						end
					end

					if(useObj.tempRetain)then
						new_card.tempRetain = true;
					end
					
					if(useObj.action == "upgrade")then
						gamemc:upgradeCard(new_card, nil, useObj.target=="permanent");
						if(useObj.target=="permanent")then
							local txt = get_txt("card_upgraded");
							txt = txt:gsub("TAG", new_card.tag);
							show_msg(txt); -- card_upgraded="TAG upgraded!"
						end
					end
					if(useObj.play)then
						for i=1,useObj.play do
							gamemc:playCard(new_card, tar, source, true);
						end
					end
					
					if(useObj.action=="rehand" or new_card.rewriteOnUseAction=="rehand")then
						new_card.dead = false;
						new_card.exhausted = false;
						gamemc:addCardToHand(new_card);
					elseif(useObj.action == "discard" or new_card.rewriteOnUseAction=="discard")then
						gamemc:moveCardTo(new_card, draw);
						local cardmc = handmc:getMCbyCardObj(new_card);
						if(cardmc)then
							facemc:insert(cardmc);
							transition.to(cardmc, {time=500, x=facemc.draw.x, y=facemc.draw.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
						end
					elseif(useObj.action == "redeck" or new_card.rewriteOnUseAction=="redeck")then
						new_card.dead = false;
						new_card.exhausted = false;
						gamemc:moveCardTo(new_card, deck);
						
						local cardmc = handmc:getMCbyCardObj(new_card);
						if(cardmc)then
							facemc:insert(cardmc);
							transition.to(cardmc, {time=500, x=facemc.deck.x, y=facemc.deck.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
						end
					elseif(useObj.action == "exhaust" or new_card.rewriteOnUseAction=="exhaust")then
						new_card.exhausted = true;
						new_card.dead = true;
						source:eventHandler("exhausted", source);
						gamemc:moveCardTo(new_card, trash);
					end
					
					if(useObj.onNegativeCard)then
						if(new_card.ctype==CTYPE_STATUS or new_card.ctype==CTYPE_CURSE)then
							gamemc:playCard(useObj.onNegativeCard, tar, source, true);
						end
					end
					if(useObj.changePick)then
						for attr,val in pairs(useObj.changePick) do
							if(attr=="energy" or attr=="energyTemp")then
								if(new_card.energy~=X)then
									if(new_card.energy>val)then
										new_card[attr] = val;
									end
								end
							else
								new_card[attr] = val;
							end
						end
						local cardmc = handmc:getMCbyCardObj(new_card);
						if(cardmc)then
							cardmc:update();
						end
					end
					if(useObj.addPick)then
						for attr,val in pairs(useObj.addPick) do
							print("addPick:", new_card.tag, new_card[attr], attr, val);
							new_card[attr] = new_card[attr] + val;
						end
						local cardmc = handmc:getMCbyCardObj(new_card);
						if(cardmc)then
							cardmc:update();
						end
					end
					
					if(useObj.action == "copy")then
						if(useObj.copies==nil)then useObj.copies=1; end
						for i=1,useObj.copies do
							if(useObj.nextTurn)then
								source:addNextCard({range="self", addCardsObj={hand={table.cloneByAttr(new_card)}}});
							else
								gamemc:addCardToHand(table.cloneByAttr(new_card));
							end
						end
					end
					
					if(useObj.onCount)then
						gamemc:useCard(useObj.onCount, tar, source);
					end
					if(useObj.refund)then
						-- print("refund:", new_card.energy, new_card.energy==X);
						if(new_card.energy==X)then
							gameobj.energy = gameobj.energy + gameobj.energy;
						elseif(new_card.energy)then
							gameobj.energy = gameobj.energy + new_card.energy;
						end
						facemc:refreshEnergy();
					end
					facemc:refreshHand();
					facemc:refreshDeksNumbers();
					gamemc:cleanHand();
				end, nil, useObj.force, {limit=useObj.limit});
			end
		end
		if(useObj.action == "plus")then
			card_obj[useObj.target] = card_obj[useObj.target] + useObj.val;
			
			if(useObj.permanent)then
				local original = getOriginalCardObj(card_obj.tempID);
				if(original)then
					original[useObj.target] = original[useObj.target] + useObj.val;
				end
			end
		end
		if(useObj.action == "minus")then
			if(useObj.min==nil)then useObj.min=0; end
			card_obj[useObj.target] = math.max(card_obj[useObj.target] - useObj.val, useObj.min);
		end
		if(useObj.action == "play")then
			gamemc:useCard(useObj.play, tar, source);
		end
	end
	
	function gamemc:pickConditionHandler(event, tar, source, eventable)
		local checkTarget = tar;
		if(event.range=="self")then
			checkTarget = source;
		end
		
		local list = {};
		for attr,obj in pairs(conditions) do
			if(checkTarget[attr]~=0)then
				if(obj[event.attr]==event.val)then
					table.insert(list, attr);
				end
			end
		end
		
		if(#list>0)then
			print('TODO');
			
		end
	end
	function gamemc:onConditionsHandler(event, tar, source, eventable)
		-- onConditions={range="self", action="purge", attr="voodoo", val=true, onCount={range="enemy", dmg=10}}
		local checkTarget = tar;
		if(event.range=="self")then
			checkTarget = source;
		end
		for attr,obj in pairs(conditions) do
			if(checkTarget[attr]~=0)then
				if(obj[event.attr]==event.val)then
					local checkVal = checkTarget[attr];
					if(event.action=="purge")then
						checkTarget[attr] = 0;
						if(obj.onExpire)then
							gamemc:playCard(obj.onExpire, checkTarget, checkTarget, false, false);
						end
					end
					if(event.action=="add")then
						checkTarget[attr] = checkTarget[attr] + event.add;
					end
					if(event.action=="play")then
						gamemc:playCard(obj.play, tar, source, false, false, checkTarget[attr]);
					end
					if(event.onCount)then
						gamemc:playCard(event.onCount, tar, source, eventable);
					end
					if(event.onStack)then
						for i=1,checkVal do
							gamemc:playCard(event.onStack, tar, source, eventable);
						end
					end
				end
			end
		end
		checkTarget:refreshHP();
	end
	
	function gamemc:handleCardsAttrsManipulations(card_obj, obj, target, source)
		for attr,val in pairs(obj) do
			if(obj.onUse)then
				local useObj = obj.onUse;
				gamemc:onUseHandler(useObj, card_obj, target, source);
			elseif(attr~="permanent")then
				card_obj[attr] = card_obj[attr] + val;
				if(attr=="energy")then
					card_obj[attr] = math.max(card_obj[attr], 0);
					card_obj[attr] = math.min(card_obj[attr], 9);
				end
				
				if(obj.permanent)then
					local original = getOriginalCardObj(card_obj.tempID);
					if(original)then
						original[attr] = original[attr] + val;
					end
				end
			end
		end
	end
	
	function gamemc:tryIfStatement(obj, ifObj)
		local ready = false;
		if(obj.condition)then
			if(obj.more)then
				ready = ifObj[obj.condition]>obj.more;
			elseif(obj.val)then
				ready = ifObj[obj.condition]==obj.val;
			else
				ready = ifObj[obj.condition]~=0;
			end
		end
		if(obj.czero)then
			ready = ifObj[obj.czero]==0;
		end
		if(obj.intend and ifObj.intends)then
			ready = ifObj.intends[obj.intend]==true;
		end
		if(obj.hpLess)then
			ready = ifObj:getHPper() <= obj.hpLess/100;
		end
		if(obj.hpLessEx)then
			local hp,hpmax = ifObj:getHP();
			ready = hp<=obj.hpLessEx;
		end
		if(obj.hpMore)then
			ready = ifObj:getHPper() >= obj.hpMore/100;
		end
		return ready;
	end
	
	local function handleIfStatement(obj, ifObj, ifTar, source)
		local ready = gamemc:tryIfStatement(obj, ifObj);
		-- print("_ready:", ready);
		if(ready)then
			obj.play.ifEnemy = nil; -- forcing out recursion
			obj.play.ifSelf = nil; -- forcing out recursion
			if(obj.play.range=='self')then -- it is important to preserve 'tar'
				gamemc:useCard(obj.play, source, source);
			else
				gamemc:useCard(obj.play, ifTar, source);
			end
		elseif(obj.otherwise)then
			if(obj.otherwise.range=='self')then -- it is important to preserve 'tar'
				gamemc:useCard(obj.otherwise, source, source);
			else
				gamemc:useCard(obj.otherwise, ifTar, source);
			end
		end
	end

	function gamemc:useCardEx(card_obj, tar, source, eventable) -- returns: NUMBER
		if(tar==nil or source==nil)then
			return 0;
		end
		local ctype = card_obj.id;
		card_obj.dead = true;

		if(source.frozen==0 and (source==hero or tar==hero))then
			if(card_obj.draw)then
				gamemc:drawCards(getStatCountingRnd(card_obj, "draw"), nil, card_obj.ifDraw, card_obj.onlyKeepZero);
			end
			if(card_obj.drawUntil)then
				local cards_at_hand = handmc:getCardsCount();
				local more_cards = card_obj.drawUntil - cards_at_hand;
				if(more_cards>0)then
					gamemc:drawCards(more_cards, nil, card_obj.ifDraw, card_obj.onlyKeepZero);
				end
			end
			if(card_obj.chooseOneRandom)then
				local list = getCardLoot(card_obj.chooseOneRandom);
				local wnd = showCardPick(facemc, localGroup.buttons, sx, sy, list, false, false, function(card_obj, mc)
					table.insert(deck, card_obj);
					facemc:refreshDeksNumbers();
					
					facemc:insert(mc);
					transition.to(mc, {time=500, x=facemc.deck.x, y=facemc.deck.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
				end);
				wnd:addOption(get_txt('cancel'));		
			end
		end
		
		local armor = getStatCountingRnd(card_obj, "armor");
		if(card_obj.harmToBlock)then armor = armor + source.harmed*card_obj.harmToBlock; end
		if(card_obj.armorPerCardInHand)then
			armor = armor + card_obj.armorPerCardInHand*handmc:getCardsCount();
		end
		
		if(armor~=0 and armor~=nil)then
			if(card_obj.dexX==nil)then card_obj.dexX=1; end
			if(source.dex~=0)then
				armor = armor + source.dex*card_obj.dexX;
			end
			if(source.frail>0 and card_obj.dexX~=0)then
				armor = armor*0.75;
				armor = math.floor(armor);
			end
			if(source.owner)then
				if(source.owner.focus~=0)then
					armor = armor + source.owner.focus;
				end
			end
		end
		source:addStat("armor", armor, tar);
		
		if((card_obj.dmgByAttrFromSource~=nil or card_obj.dmgByAttrFromTarget~=nil) and card_obj.dmg==nil)then
			card_obj.dmg = 0;
		end
		
		local unblocked_dmg = 0;
		if(card_obj.dmg~=nil)then
			if(card_obj.strX==nil)then card_obj.strX=1; end
			local dmg = card_obj.dmg;
			if(card_obj.addDmgByCard)then
				dmg = dmg+getAddDmg(login_obj.deck, card_obj);
			end
			if(card_obj.getAddDmgByAttr)then
				local obj = card_obj.getAddDmgByAttr;
				dmg = dmg + getAddDmgByAttr(login_obj.game[obj.list], obj.attr, obj.val)*obj.dmg;
			end
			if(card_obj.drawToDmg)then
				dmg = dmg + #draw*card_obj.drawToDmg;
			end
			if(card_obj.deckToDmg)then
				dmg = dmg + math.floor(#deck*card_obj.deckToDmg);
			end
			if(card_obj.dmgPerUpgrade)then
				dmg = dmg + card_obj.dmgPerUpgrade*(card_obj.lvl-1);
			end
			if(card_obj.dmgRnd)then
				dmg = dmg + math.random(0, card_obj.dmgRnd);
			end
			if(card_obj.dmgByEnemiesCount)then
				dmg = dmg + card_obj.dmgByEnemiesCount*(#gamemc:getEnemiesList(source.gid));
			end
			if(card_obj.dmgByAttrFromSource)then
				dmg = dmg + source[card_obj.dmgByAttrFromSource];
				-- print("dmgByAttrFromSource:", card_obj.dmgByAttrFromSource, dmg, source[card_obj.dmgByAttrFromSource]);
			end
			if(card_obj.dmgByAttrFromTarget)then
				dmg = dmg + tar[card_obj.dmgByAttrFromTarget];
			end
			if(source.owner)then
				if(source.owner.focus~=0)then
					dmg = dmg + source.owner.focus;
				end
			end
			if(card_obj.energy==0 and card_obj.ctype==CTYPE_ATTACK)then
				if(source.wristblade>0)then
					dmg = dmg+source.wristblade;
				end
			end
			print('battle1:', card_obj.tag, card_obj.empowerDmgByTargetAttr);
			if(card_obj.empowerDmgByTargetAttr)then
				print('battle1:', card_obj.tag, card_obj.empowerDmgByTargetAttr, tar[card_obj.empowerDmgByTargetAttr]);
				if(tar[card_obj.empowerDmgByTargetAttr] and tar[card_obj.empowerDmgByTargetAttr]>0)then
					-- if(tar[card_obj.empowerDmgByTargetAttr]>0)then
						dmg = math.round(dmg*1.5);
					-- end
				end
			end
			if((source and source.wrath>0) or tar.wrath>0)then
				dmg = dmg*2;
			end
			if(source and source.divine>0)then
				dmg = dmg*3;
			end
			unblocked_dmg = unblocked_dmg + tar:takeDmg(dmg, card_obj.strX, card_obj.dtype, source, eventable);
		end
		-- if(card_obj.damagedToDmg)then
			-- if(source.damaged>0)then
				-- tar:takeDmg(source.damaged*card_obj.damagedToDmg, 0, card_obj.dtype, source);
			-- else
				-- show_msg('not a scratch!');
			-- end
		-- end
		
		if(card_obj.armorToTarget)then
			local armorToTarget = card_obj.armorToTarget;
			if(source.owner)then
				if(source.owner.focus~=0)then
					armorToTarget = armorToTarget + source.owner.focus;
				end
			end
			tar:addStat("armor", armorToTarget, tar);
		end
		tar:addStat("dex", card_obj.dex, tar);
		
		if(card_obj.armorFromUdmg and unblocked_dmg>0)then
			source:addStat("armor", unblocked_dmg*card_obj.armorFromUdmg, source);
		end
		if(card_obj.armorFromEnergyMax)then
			source:addStat("armor", math.floor(source.energymax*card_obj.armorFromEnergyMax), source);
		end
		if(card_obj.armorFromDraw)then
			source:addStat("armor", #draw*card_obj.armorFromDraw, source);
		end
		-- tar:addStat("protect", card_obj.protect, tar);
		-- tar:addStat("noDraw", card_obj.noDraw, tar);
		if(card_obj.missingHP)then
			local hp, hpmax = source:getHP();
			local val = math.floor((hpmax - hp) * card_obj.missingHP.val);
			if(card_obj.missingHP.attr)then
				tar:addStat(card_obj.missingHP.attr, val, tar);
			end
			if(card_obj.missingHP.dmg)then
				local dmg = card_obj.missingHP.dmg * val;
				unblocked_dmg = unblocked_dmg + tar:takeDmg(dmg, card_obj.strX, card_obj.dtype, source, eventable);
			end
		end
		if(card_obj.consumePain)then
			-- local hp, hpmax = source.pain;
			local val = math.floor(source.pain * card_obj.consumePain.val);
			if(val>=1)then
				source.pain = source.pain - math.floor(val/card_obj.consumePain.val);
				-- print("consumePain", val, source.pain, card_obj.consumePain.val)
				if(card_obj.consumePain.attr)then
					tar:addStat(card_obj.consumePain.attr, val, tar);
				end
				if(card_obj.consumePain.dmg)then
					local dmg = card_obj.consumePain.dmg * val;
					unblocked_dmg = unblocked_dmg + tar:takeDmg(dmg, card_obj.strX, card_obj.dtype, source, eventable);
				end
			end
		end
		-- unit.pain = unit.pain + dmg; -- for cards with consumePain
		
		if(unblocked_dmg>0 and eventable)then
			source:eventHandler("unblocked_dmg", tar);
		end
		
		if(card_obj.pets)then
			local st = getTimer()
			for i=1,#card_obj.pets do
				source:addPet(card_obj.pets[i]);
			end
			print('pets:', (getTimer()-st));
		end
		
		if(card_obj.evoke)then
			source:evokeActive(card_obj.evoke, card_obj.evokeReSummon);--petPlayPassive
		end
		if(card_obj.evokePassive)then
			source:evokePassive(card_obj.evokePassive);
		end
		if(card_obj.onPet)then
			-- onPet={onCount={range="enemy", dmg=4}}
			-- onPet={onCount={range="enemy", draw=1}, unique=true}
			local obj = card_obj.onPet;
			local unique = {};
			for i=1,#source.pets do
				local pet = source.pets[i];
				if(obj.unique~=true or unique[pet.tag]~=true)then
					unique[pet.tag] = true
					gamemc:playCard(obj.onCount, tar, source, true);
				end
				if(obj.evoke)then
					pet.evoke = pet.evoke+1;
					pet.dead = true;
				end
			end
			if(obj.evoke)then
				source:startEvoking();
			end
		end
		
		if(card_obj.hpmax)then
			source:feed(card_obj.hpmax);
		end

		
		
		if(card_obj.vulnerableSelf)then
			source:addStat("vulnerable", card_obj.vulnerableSelf, tar);
		end
		if(card_obj.stealturn)then
			-- facemc.turnBtn = facemc:addBtn(get_txt('turn'), _W - deck_x, _H - 90*scaleGraphics, function() --stats.turn_gid
			if(stats.turn_gid~=source.gid)then
				facemc.turnBtn:act();
			end
		end
		
		-- if(localGroup.conditions==nil)then localGroup.conditions=0; end
		localGroup.conditions = localGroup.conditions+1;
		
		-- do
			-- for attr,obj in pairs(conditions) do
				-- if(obj.event == "death")then
					-- local val = getStatCountingRnd(card_obj, attr);
					-- if(obj.target=="source")then
						-- source:addStat(attr, val, source);
					-- else
						-- tar:addStat(attr, val, source);
					-- end
				-- end
			-- end
		-- end
		
		local function addConditions(evt)
			for attr,obj in pairs(conditions) do
				-- if(obj.event ~= "death")then
					local val = getStatCountingRnd(card_obj, attr);
					if(obj.target=="source")then
						source:addStat(attr, val, source);
					else
						tar:addStat(attr, val, source);
					end
				-- end
			end
			
			if(card_obj.eventAll)then
				for i=1,#units do
					units[i]:eventHandler(card_obj.eventAll, source);
				end
			end
			
			
			localGroup:refreshPets();
			
			Runtime:removeEventListener("enterFrame", addConditions);
			localGroup.conditions = localGroup.conditions-1;
		end
		Runtime:addEventListener("enterFrame", addConditions);
		
		if(card_obj.corruption or card_obj.candleblue or card_obj.candlered)then
			facemc:refreshHand();
		end
		
		if(card_obj.heal)then
			source:heal(getStatCountingRnd(card_obj, "heal"));
		end
		if(card_obj.healUp)then
			local val = card_obj.healUp - source:getHP();
			if(val>0)then
				source:heal(val);
			end
		end
		if(card_obj.healTarget)then
			tar:heal(getStatCountingRnd(card_obj, "healTarget"));
		end
		
		if(tar.dead)then
			if(card_obj.feed)then
				source:feed(card_obj.feed);
			end
			if(card_obj.onKill)then
				gamemc:handleCardsAttrsManipulations(card_obj, card_obj.onKill, target, source);
			end
		end
		
		if(card_obj.hpPer)then
			if(card_obj.hpPer<1)then
				tar:harm(math.ceil(tar:getHP()*card_obj.hpPer));
			else
				tar:heal(math.ceil(tar:getHP()*(card_obj.hpPer-1)));
			end
		end
		
		if(card_obj.cleanse)then
			tar:cleanse(card_obj.cleanse);
		end
		
		if(card_obj.cursesAdd)then
			tar:addStat(card_obj.cursesAdd, source:countCurces(), source);
		end
		if(card_obj.strMlt)then
			tar.str = tar.str*card_obj.strMlt;
			if(tar.str~=0)then
				tar:eventHandler("str", source);
				tar:refreshHP();
			end
		end
		if(card_obj.armorMlt)then
			source.armor = source.armor*card_obj.armorMlt;
			if(source.armor~=0)then
				source:eventHandler("armor", source);
				source:refreshHP();
			end
		end
		if(card_obj.poisonMlt)then
			tar.poison = tar.poison*card_obj.poisonMlt;
			if(tar.poison~=0)then
				tar:eventHandler("poison", source);
				tar:refreshHP();
			end
		end
		if(card_obj.charmMlt)then
			if(tar.charm~=0)then
				tar.charm = tar.charm*card_obj.charmMlt;
				tar:eventHandler("charm", source);
				tar:refreshHP();
			end
		end
		if(card_obj.battlefervorMlt)then
			if(tar.battlefervor~=0)then
				tar.battlefervor = tar.battlefervor*card_obj.battlefervorMlt;
				tar:eventHandler("battlefervor", source);
				tar:refreshHP();
			end
		end
		if(card_obj.energyMlt)then
			gameobj.energy = gameobj.energy * card_obj.energyMlt;
			facemc:refreshEnergy();
		end
		
		-- print("energyAdd1:", card_obj.energyAdd);
		if(card_obj.energyAdd)then
			-- print("energyAdd2:", card_obj.range, source, tar, hero);
			if(tar==hero)then
				gameobj.energy = gameobj.energy+getStatCountingRnd(card_obj, "energyAdd");
				-- print("_energy:", gameobj.energy);
				facemc:refreshEnergy();
			end
		end
		
		if(card_obj.deckToEnergy)then
			gameobj.energy = gameobj.energy + math.floor(#deck/card_obj.deckToEnergy);
			facemc:refreshEnergy();
		end
		
		if(card_obj.nextTurn)then
			source:addNextCard(card_obj.nextTurn);
		end
		
		if(card_obj.drawPlayExhaust)then
			for i=1,card_obj.drawPlayExhaust do
				if(#deck<1)then
					gamemc:refillDeck();
				end
				if(#deck>0)then
					local obj = table.remove(deck, 1);
					gamemc:playCard(obj, tar, source, true);
					obj.exhausted = true;
					source:eventHandler("exhausted", source);
				else
					show_msg('deck_empty');
				end
			end
		end
		
		-- onConditions={range="self", action="purge", attr="voodoo", val=true, onCount={range="enemy", dmg=10}}
		if(card_obj.pickCondition)then
			local obj = card_obj.pickCondition;
			gamemc:pickConditionHandler(obj, tar, source, eventable)
			-- table.insert(cards, {tag="Well of Hatred",		class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", 
			-- pickCondition={range="self", action="double", attr="voodoo", val=true}, exhaust=true, onUpgrade={pickCondition={range="self", action="triple", attr="voodoo", val=true}}}); -- Doubles(Triples) Hatred on selected Doll
			
		end
		if(card_obj.onConditions)then
			local obj = card_obj.onConditions;
			-- if(obj.range=="self")then
				-- gamemc:onConditionsHandler(source, obj, source, eventable);
			-- else
				gamemc:onConditionsHandler(obj, tar, source, eventable);
			-- end
		end
		
		if(card_obj.cloneAttr)then
			if(tar[card_obj.cloneAttr.attrFrom])then
				tar:addStat(card_obj.cloneAttr.attrTo, tar[card_obj.cloneAttr.attrFrom], source);
			end
		end
		
		
		if(card_obj.event)then
			tar:eventHandler(card_obj.event, source);
		end
		
		if(card_obj.hpleft)then
			local val = tar:getHP()-1;
			tar:harm(val);
		end
		
		if(card_obj.hand)then
			gamemc:onHand(card_obj.hand, tar, source);
		end
		if(card_obj.addCards and (tar==hero or source==hero))then
			local obj = card_obj.addCards;
			
			local function handleList(list, tar)
				for i=1,#list do
					local card_tag = list[i];
					local new_card = table.cloneByAttr(cards_indexes[card_tag]);
					if(obj.upgrade or hero.upgradenewtempcards>0)then
						upgradeCard(new_card);
					end
					if(exhaust)then
						new_card.exhaust = true;
					end
					if(obj.shuffle)then
						if(#tar>2)then
							table.insert(tar, math.random(1, #tar-1), new_card);
						else
							table.insert(tar, new_card);
						end
					else
						table.insert(tar, new_card);
					end
				end
				facemc:refreshHand();
				facemc:refreshDeksNumbers();
				gamemc:cleanHand();
			end
			if(obj.deck)then handleList(obj.deck, deck); end
			if(obj.draw)then handleList(obj.draw, draw); end
			if(obj.hand)then handleList(obj.hand, hand); end
			if(obj.deck)then
				gamemc:shuffleDeck();
			end
		end
		
		if(card_obj.addCardsObj and (tar==hero or source==hero))then
			local obj = card_obj.addCardsObj;
			local function handleList(list, tar)
				for i=1,#list do
					local new_card = list[i];
					table.insert(tar, new_card);
				end
				facemc:refreshHand();
				facemc:refreshDeksNumbers();
				gamemc:cleanHand();
			end
			if(obj.deck)then handleList(obj.deck, deck); end
			if(obj.draw)then handleList(obj.draw, draw); end
			if(obj.hand)then handleList(obj.hand, hand); end
		end
		if(card_obj.rnd)then
			if(math.random()<card_obj.rnd[1]/100)then
				-- gamemc:useCard(card_obj.rnd[2], tar, source);
				local new_card = card_obj.rnd[2];
				if(new_card.range=='self')then
					tar = source;
				end
				gamemc:playCard(new_card, tar, source, true);
			end
		end
		if(card_obj.rndCards)then
			local new_card = table.random(card_obj.rndCards);
			if(new_card.range=='self')then
				tar = source;
			end
			gamemc:playCard(table.random(card_obj.rndCards), tar, source, true);
		end
		if(card_obj.potion and (tar==hero or source==hero))then
			if(#login_obj.potions>=login_obj.potions_max)then
				gfxmc:addMiniTxt(sx, sy, get_txt('too_much_potions')); --gfx_mc:addGfxImage(path, _x, _y, ttl, tty, ttr, ttscale)
				return unblocked_dmg;
			end
			local potion_obj = table.random(_G.potions);
			local potion_id = potion_obj.tag;
			table.insert(login_obj.potions, potion_id);-- refreshPotions(facemc, localGroup.buttons);
			facemc:refreshPotions();
			gamemc:iniPotions();
		end
		if(card_obj.ignore)then
			tar:addIgnore(card_obj.ignore);
		end
		
		if(card_obj.ifSelf)then
			local obj = card_obj.ifSelf;
			handleIfStatement(obj, source, tar, source);
		end
		if(card_obj.ifEnemy)then
			local obj = card_obj.ifEnemy;
			handleIfStatement(obj, tar, tar, source);
		end
		
		
		if(card_obj.suicide)then
			-- source.dead = true;
			source.suicide = true;
		end
		if(card_obj.escaping)then
			localGroup.animations = localGroup.animations+1;
			source.tx, source.ty = source.x+300, source.y;
			transition.to(source, {time=2500, x=source.x+200, transition=easing.outQuad, alpha=0, onComplete=function(obj)
				localGroup.animations = localGroup.animations-1;
				transitionRemoveSelfHandler(obj);
			end});
			source:setAct("go");--source.suicide = true;
			source:setDir(100, 0);
			source._stuned = 1;
			
			-- build_crash_small
			-- source:addGfx("build_crash_small");
			local cx, cy = gamemc:localToContent(source.x, source.y);
			addGfxByID(gfxmc, cx, cy-50, "build_crash_small", 2);
			
			
			for i=#units,1,-1 do
				if(units[i]==source)then
					table.remove(units, i);
				end
			end
		end
		
		if(card_obj.summon)then
			local amount = card_obj.summon.amount;--#list;
			if(amount>0)then
				for i=1,amount do
					local enemy_id = table.random(card_obj.summon.list);
					local xy = gamemc:getNearestFreePlace(source.x, source.y);
					if(xy)then
						local enemy_obj = table.cloneByAttr(getEnemyObjByTag(enemy_id));
						if(card_obj.summon.hp)then
							local source_hp, source_hpmax = source:getHP();
							enemy_obj.hp, enemy_obj.hpmax = source_hp, source_hpmax;
						end
						
						enemy_obj.minion = 1;
						enemy_obj.sleep = 1;
						local unit = gamemc:addEnemyUnit(enemy_obj, source.x, source.y);
						if(unit)then
							
							-- print("_source.suicide:", source.suicide);
							if(source.suicide)then
								-- unit.tx, unit.ty = xy[1], xy[2];
								-- localGroup:regroup(true);
								-- localGroup:regroup();
								localGroup._regroup = true;
							else
								unit.x, unit.y = xy[1]+100, xy[2]-100;
								unit.tx, unit.ty = xy[1], xy[2];
								unit.alpha = 0;
								transition.to(unit, {time=750, alpha=1});
								unit.master = source;
								unit:setAct("go");--source.suicide = true;
							end
						end
					end
				end
			end
		end
		
		if(card_obj.woundsToDeck)then	
			for i=1,card_obj.woundsToDeck do
				gamemc:addCardToDeck(table.cloneByAttr(cards_indexes["Wound"]));
			end
		end
		if(card_obj.woundsToHand)then
			for i=1,card_obj.woundsToHand do
				gamemc:addCardToHand(table.cloneByAttr(cards_indexes["Wound"]));
			end
			facemc:refreshHand();
		end
		
		-- card_obj.class
		-- create={count=1, attr="ctype", val=CTYPE_ATTACK, energyTemp=0}
		-- create={count=1, attr="ctype", val=CTYPE_SKILL, energyTemp=0}
		-- create={count=1, attr="class", val="none"}
		-- create={count=1, attr="class", val="none"}
		if(card_obj.create)then
			local class = card_obj.create.class or card_obj.class or login_obj.class;
			local attr, val, count = card_obj.create.attr, card_obj.create.val, card_obj.create.count or 1;
			if(attr=="class")then class=val; end
			if(card_obj.class=="any")then class = login_obj.class; end
			if(class=="hero")then class=login_obj.class; end;
			
			local list = {};
			for i=1,#cards do
				local card = cards[i];
				if(card.class == class or class=="all")then
					if(card[attr] == val and (card.rarity>0 or attr=="tag"))then
						table.insert(list, table.cloneByAttr(card));
					end
				end
			end
			print('create:', #list, attr, val, count, class); -- create:	0	ctype	3	1
			if(#list>0)then
				-- showCardPick(facemc, buttons, sx, sy, list, amount, upgradeable, callback, onClose, force, prms)
				table.shuffle(list);
				table.shuffle(list);
				table.shuffle(list);
				while(#list>count)do
					table.remove(list, 1);
					table.shuffle(list);
				end
				if(card_obj.create.pick)then
					showCardPick(facemc, localGroup.buttons, _W/2, 0, list, card_obj.create.pick, false, function(new_card, mc)
						-- if(useObj.action == "rehand")then
							new_card.dead = false;
							new_card.exhausted = false;
							if(card_obj.create.upgrade or hero.upgradenewtempcards>0)then
								upgradeCard(new_card);
							end
							if(card_obj.create.energyTemp)then
								new_card.energyTemp = card_obj.create.energyTemp;
							end
							-- print("__change:", card_obj.create.change);
							if(card_obj.create.change)then
								-- print("___change:", attr2, val2);
								for attr2,val2 in pairs(card_obj.create.change) do
									if(val2 == "ENERGY")then
										new_card[attr2] = gameobj.energy + (card_obj.create.changeX or 0);
									else
										new_card[attr2] = val2 + (card_obj.create.changeX or 0);
									end
								end
							end
							if(card_obj.create.target and login_obj.game[card_obj.create.target])then
								table.insert(login_obj.game[card_obj.create.target], new_card);
							else
								gamemc:addCardToHand(new_card);
							end
							facemc:refreshHand();
						-- end
					end, false);
				else
					for i=1,count do
						local new_card = table.random(list);
						if(new_card)then
							-- new_card = table.cloneByAttr(new_card);
							if(card_obj.create.upgrade or hero.upgradenewtempcards>0)then
								upgradeCard(new_card);
							end
							if(card_obj.create.energyTemp)then
								new_card.energyTemp = card_obj.create.energyTemp;
							end
							-- print("__change:", card_obj.create.change);
							if(card_obj.create.change)then
								-- print("___change:", attr2, val2);
								for attr2,val2 in pairs(card_obj.create.change) do
									if(val2 == "ENERGY")then
										new_card[attr2] = gameobj.energy + (card_obj.create.changeX or 0);
									else
										new_card[attr2] = val2 + (card_obj.create.changeX or 0);
									end
								end
							end
							
							-- local 
							new_card.sx, new_card.sy = card_obj.sx, card_obj.sy;
							
							
							-- "target":"deck"
							if(card_obj.create.target and login_obj.game[card_obj.create.target])then
								table.insert(login_obj.game[card_obj.create.target], new_card);
							else
								gamemc:addCardToHand(new_card);
							end
							
							facemc:refreshHand();
						else
							show_msg('err#cant find card by ctype:'..tostring(card_obj.create));
						end
					end
				end
			else
				print('create error! #list=', #list);
				show_msg('err#cant_build_list_for_create('..tostring(card_obj.create.target)..")");
			end
		end
		
		if(card_obj.shuffle)then
			gamemc:refillDeck();
		end
		
		if(card_obj.drainEnergy)then
			gameobj.energy = 0;
		end
		
		facemc:refreshHand();
		facemc:refreshDeksNumbers();
		
		return unblocked_dmg;
	end
	
	-- localGroup.animations = 0;
	function facemc:addCenterMsg(txt1, txt2)
		local mc = newGroup(facemc);
		mc.x, mc.y = _W/2, _H/2+30*scaleGraphics;
		local bg = display.newRect(mc, 0, 0, _W, 50*scaleGraphics);
		bg:setFillColor(0, 0, 0, 0.4);
		local dtxt = newOutlinedText(mc, txt1, 0, 0, fontMain, 24*scaleGraphics, 1, 0, 1);
		if(txt2)then
			dtxt.y = -12*scaleGraphics
			local dtxt = newOutlinedText(mc, txt2, 0, 12*scaleGraphics, fontMain, 16*scaleGraphics, 1, 0, 1);
		end
		
		localGroup.animations = localGroup.animations+1;

		transition.to(mc, {time=500, alpha=1, y=_H/2, transition=easing.outQuad, onComplete=function(obj)
			transition.to(mc, {delay=500, time=400, alpha=0, y=_H/2-20*scaleGraphics, transition=easing.inQuad, onComplete=function(obj)
				localGroup.animations = localGroup.animations-1;
			end});
		end});
	end
	
	function gamemc:turnEnd()
		-- print("gamemc:turnEnd1", facemc.wnd);
		gamemc.turned = true;
		if(facemc.wnd)then
			return
		end
		gamemc.turned = false;--gamemc.started
		--drop armor
		--do regen and poison
		--expire conditions
		
		-- iniNewStat("armor",			"image/mini/_armor.png");
		-- iniNewStat("protect",		"image/mini/_protect.png");
		-- iniNewStat("str",			"image/mini/_rush.png");
		-- iniNewStat("vulnerable",	"image/mini/_broken.png");
		-- iniNewStat("weak",			"image/mini/_weak.png");
		
		-- END PHASE
		for i=#units,1,-1 do
			local unit = units[i];
			if(unit.gid==stats.turn_gid)then
				-- unit:addStat("armor", unit.protect);
				unit:addStat("str", unit.strNext);
				unit:addStat("strNext", -unit.strNext);
				
				-- unit:tickStat("vulnerable");
				-- unit:tickStat("weak");
				-- unit:tickStat("noDraw");

				unit:eventHandler("turnEnd", unit);
				
				unit.energy = 0;
				
				for attr,obj in pairs(conditions) do
					if(obj.expire and obj.expireAtEnd)then
						unit:tickStat(attr, obj.expire);
					end
				end
				
				unit:showNextMove();
				
				unit:turnIgnores();
			end
		end
		
		gamemc:turnStart();
	end
	function gamemc:turnStart()
		-- print("gamemc:turnEnd2", facemc.wnd);
		gamemc.started = true;
		if(facemc.wnd)then
			return
		end
		if(localGroup.conditions>0)then
			return
		end
		if(localGroup.animations>0)then
			return
		end
		
		if(gamemc:checkGameEnd())then
			return
		end
		
		gamemc.started = false;
		
		if(stats.turn_gid==player_gid)then
			gamemc:discardHand();
			facemc:refreshHand();
		end
		
		stats.turn_gid = stats.turn_gid+1;
		if(stats.turn_gid>2)then
			stats.turn_gid=1;
			stats.turn = stats.turn + 1;
		end
		
		-- BEGIN PHASE
		if(stats.turn_gid==player_gid)then
			localGroup.handX = _W/2;
			gamemc:drawCards();
			facemc:refreshHand();
			
			gameobj.energy = gameobj.energy + login_obj.energymax + hero.energymax;
			-- if(hero.berserk>0)then
				-- if(hero:getHPper()<=0.5)then
					-- gameobj.energy = gameobj.energy + hero.berserk;
				-- end
			-- end
			facemc:refreshEnergy();
			-- print("_gameobj.energy(BEGIN PHASE):", gameobj.energy);
			
			facemc:addCenterMsg(get_txt("turn_player"), get_txt('turn').." #"..stats.turn);
		else
			facemc:addCenterMsg(get_txt("turn_enemy"));
		end
		
		for i=#units,1,-1 do
			local unit = units[i];
			if(unit.gid==stats.turn_gid)then
				unit.energy = unit.energy + unit.energymax;
				
				if(unit.blur<1 and unit.barricade<1)then
					unit:dropArmor();
				end
				if(unit.poison>0)then
					unit:doPoison(unit.poison);
				end
				unit:eventHandler("turn", unit);
				
				unit.card_played_this_turn = 0;
				for j=1,5 do
					unit["card_type_"..j.."_played"] = 0;
				end
				unit.harmed = 0;
				
				for attr,obj in pairs(conditions) do
					if(obj.expire and obj.expireAtEnd~=true)then
						unit:tickStat(attr, obj.expire);
					end
					-- if(unit.drawondebuff>0)then
						-- for i=1,unit.drawondebuff do
							-- if(obj.debuff)then
								-- gamemc:drawCard();
							-- end
						-- end
					-- end
				end
				
				-- unit.damagedVal = 0;
				
				unit:playNextCard();
			end
		end
		facemc:refreshRelicsIndicators(hero);
		
		localGroup._waiting_turn = nil;
		facemc.turnBtn.isVisible = stats.turn_gid==player_gid;
	end
	function localGroup:remakeCards()
		for i=handmc.numChildren,1,-1 do
			local mc = handmc[i];
			-- if(mc.card_obj)then
				-- if(mc.card_obj.dead)then
					mc:removeSelf();
				-- end
			-- end
		end
		facemc:refreshHand();
	end
	function facemc:remakeCards()
		localGroup:remakeCards();
	end
	function handmc:getCardsCount()
		local c = 0;
		for i=1,#hand do
			local card_obj = hand[i];
			if(card_obj.dead~=true)then
				c = c+1;
			end
		end
		return c;
	end
	function handmc:getMCbyCardObj(card_obj)
		for i=handmc.numChildren,1,-1 do
			local mc = handmc[i];
			if(mc.card_obj==card_obj)then
				return mc;
			end
		end
		return nil;
	end
	
	function facemc:refreshHandXY(force)
		-- for j=1,5 do
			-- hero["card_type_"..j.."_hand"] = 0;
		-- end
		-- hero["card_type_all_hand"] = 0;
		local hand_l = 0;
		for i=1,#hand do
			local card_obj = hand[i];
			if(card_obj.dead~=true)then
				-- hero["card_type_"..card_obj.ctype.."_hand"] = hero["card_type_"..card_obj.ctype.."_hand"] + 1;
				-- hero["card_type_all_hand"] = hero["card_type_all_hand"]+1;
				hand_l = hand_l+1;
			end
		end
		
		local ii=0;
		for i=1,#hand do
			local card_obj = hand[i];
			if(card_obj.dead~=true)then
				local mc = handmc:getMCbyCardObj(card_obj);
				if(mc)then
					mc:update();
					if(mc.onOut)then mc:onOut(); end
					
					local tw = 52*scaleGraphics*settings.cardScaleMin*2;
					local handW = hand_l*tw;
					if(settings.fitAllCards)then
						localGroup.handXmin = _W/2 - (handW - _W)/2-10;
						localGroup.handXmax = _W/2 + (handW - _W)/2+10;
						localGroup.handXbol = handW > _W;
						
						if(localGroup.handXbol and facemc.wnd==nil)then
							if(#tutorials==0)then
								if(save_obj.unlocks['tutorial_fitallcards_1']==nil)then
									table.insert(tutorials, {title="fitallcards"});
									table.insert(tutorials, {title="fitallcards"});
									table.insert(tutorials, {title="fitallcards"});
									
									tutorials:restep();
									tutorials:setScene(localGroup);
									tutorials:step();
								end
							end
						end
					
					else
						tw = math.min(tw, _W/(hand_l+1));
					end
					
					local csx, csy = localGroup.handX + (ii-hand_l/2 + 0.5) * tw, _H - 44*scaleGraphics*settings.cardScaleMin*2; 
					mc.homeX, mc.homeY = csx, csy;
					if(localGroup:getDraging()~=mc)then
						mc.xScale, mc.yScale=facemc.deck.xScale, facemc.deck.yScale;
					
						if(mc.ani)then
							transition.cancel(mc.ani);
							mc.ani = nil;
						end
						
						-- mc:emitter(bol);
						local emitter_bol = false;
						local emiiter_got = false;
						if(card_obj.ifSelf)then
							emitter_bol = emitter_bol or gamemc:tryIfStatement(card_obj.ifSelf, hero);
							emiiter_got = true;
							-- mc:emitter(bol);
						end
						
						-- gamemc:ruleOut(rule, unit, card_obj)
						-- local rule = gamemc:ruleOut(card_obj.playable, hero, card_obj);
						if(card_obj.playable)then
							-- local bol = gamemc:tryIfStatement(card_obj.ifSelf, hero, hero);
							-- mc:emitter(bol);
							emitter_bol = emitter_bol or gamemc:ruleOut(card_obj.playable, hero, card_obj);
							emiiter_got = true;
						end
						if(emiiter_got)then
							mc:emitter(emitter_bol);
						end
					
						if(force)then
							mc.x, mc.y = csx, csy;
							if(mc.ini)then mc:ini(); end
						else
							mc.ani = transition.to(mc, {delay=(ii-1)*50, time=300+ii*200, x=csx, y=csy, transition=easing.outQuad, xScale=1, yScale=1, onComplete=function(obj)
								if(mc.ini)then mc:ini(); end
								mc.ani = nil;
							end});
							mc:toBack();
						end
					end
					
					ii=ii+1;
				end
			end
		end
	end
	function facemc:refreshHand(force)
		for j=1,5 do
			hero["card_type_"..j.."_hand"] = 0;
		end
		hero["card_type_all_hand"] = 0;
		local hand_l = 0;
		for i=1,#hand do
			local card_obj = hand[i];
			if(card_obj.dead~=true)then
				hero["card_type_"..card_obj.ctype.."_hand"] = hero["card_type_"..card_obj.ctype.."_hand"] + 1;
				hero["card_type_all_hand"] = hero["card_type_all_hand"]+1;
				hand_l = hand_l+1;
			end
		end
		if(force)then
			facemc.__refreshHand = force;
		else
			facemc.__refreshHand = false;
		end
	end
	function facemc:_refreshHand(force)
		-- print("facemc:_refreshHand", force);
		for i=handmc.numChildren,1,-1 do
			local mc = handmc[i];
			if(mc.card_obj)then
				if(mc.card_obj.dead)then
					mc:hideExtraHints();
					mc:removeSelf();
				end
			end
		end
		
		for i=1,#hand do
			local card_obj = hand[i];
			if(card_obj.dead~=true)then
				local mc = handmc:getMCbyCardObj(card_obj);
				if(mc==nil)then
					mc = gamemc:createCardMC(handmc, card_obj, csx, csy);
					if(card_obj.sx and card_obj.sy)then
						mc.x, mc.y=card_obj.sx-handmc.x, card_obj.sy-handmc.y;
						card_obj.sx, card_obj.sy = nil, nil;
					else
						mc.x, mc.y=facemc.deck.x-handmc.x, facemc.deck.y-handmc.y;
					end
				end
			end
		end

		facemc:refreshHandXY(force);

		for i=#draw,1,-1 do
			local card_obj = draw[i];
			if(card_obj.exhausted)then
				gamemc:moveCardTo(card_obj, trash);
			end
		end
	end

	table.insert(loading_steps_arr, function()
		for i=1,#relics do
			local robj = relics[i];
			if(robj.condition)then
				if(robj.condition.once==false)then
					robj.condition.once=true;
				end
				if(robj.condition.play)then
					local rmc = facemc:getRelicMC(robj.tag);
					if(rmc)then
						robj.condition.play.sx, robj.condition.play.sy = rmc.x, rmc.y;
					end
				end
			end
		end
	end);
	table.insert(loading_steps_arr, function()
		gamemc:iniPotions();
	end);
	table.insert(loading_steps_arr, function()
		gameobj.energy = login_obj.energymax;
		if(login_obj.extraenergy)then
			if(login_obj.extraenergy>0)then
				gameobj.energy = gameobj.energy + login_obj.extraenergy;
				login_obj.extraenergy = 0;
				facemc:refreshRelics(hero);
			end
		end
		facemc:refreshEnergy();
	end);
	table.insert(loading_steps_arr, function()
		function localGroup:battle_started_handler()
			if(localGroup.handling==0)then
				localGroup.battle_started_handler = nil;
				for i=1,#units do
					local unit = units[i];
					unit:eventHandler("battle_start", unit);
					unit:eventHandler("turn", unit);
				end
				
			end
			
			if(options_cheats)then
				-- local card_obj = table.cloneByAttr(cards_indexes["Burn"]);
				-- gamemc:addCardToDeck(card_obj);
			end
		end
	end);
	table.insert(loading_steps_arr, function()
		gamemc:shuffleDeck();
		gamemc:drawCards(nil, true);
		
		if(localGroup.gameId)then
			local response = loadFile(localGroup.coop_save_file);
			if(response)then
				localGroup:loadDeck(json.decode(response));
			end
		end
	end);
	
	local extra_loading_terrain = 0;
	function localGroup:resize()
		local deck_x = 30*scaleGraphics;
		-- facemc.deck = addDeckMC("deck", deck_x - 6*scaleGraphics, _H - 40*scaleGraphics, {0, 1, 0});
		-- facemc.draw = addDeckMC("draw", _W - deck_x - 44*scaleGraphics, facemc.deck.y, {0, 0, 1});
		-- facemc.trash = addDeckMC("trash", _W - deck_x, facemc.deck.y, {1, 0, 0});
		if(facemc.energyBtn)then
			facemc.energyBtn.x = deck_x;
			facemc.energyBtn.y = math.min(_H - 172*_G.settings.cardScaleMin*scaleGraphics - 10*scaleGraphics, _H - 90*scaleGraphics);
		end
		
		facemc.deck.x, facemc.deck.y = deck_x - 6*scaleGraphics, _H - 40*scaleGraphics;
		facemc.draw.x, facemc.draw.y = _W - deck_x - 0*scaleGraphics, facemc.deck.y;
		
		if(facemc.trash.isVisible)then
			facemc.trash.x = _W - deck_x - 44*scaleGraphics;
		end
		-- facemc.trash.isVisible = true;
		-- facemc.trash.x = _W - deck_x + 44*scaleGraphics;
		-- transition.to(facemc.draw, {time=500, x=_W - deck_x, transition=easing.outQuad});
		-- transition.to(facemc.trash, {time=500, x=_W - deck_x - 44*scaleGraphics, transition=easing.outQuad});
		
		facemc.turnBtn.x = _W-deck_x;
		if(facemc.energyBtn)then
			facemc.turnBtn.y = facemc.energyBtn.y;
		end
		
		gamemc.x, gamemc.y = 0, 0;
		gamemc.xScale, gamemc.yScale = scaleGraphics, scaleGraphics;
		-- gamemc:scale(scaleGraphics, scaleGraphics);
		terrain.xScale, terrain.yScale = gamemc.xScale/2, gamemc.yScale/2;
		
		-- local deck_x = 30*scaleGraphics;
		-- facemc.deck = addDeckMC("deck", deck_x - 6*scaleGraphics, _H - 40*scaleGraphics, {0, 1, 0});
		-- facemc.draw = addDeckMC("draw", _W - deck_x - 44*scaleGraphics, facemc.deck.y, {0, 0, 1});
		-- facemc.trash = addDeckMC("trash", _W - deck_x, facemc.deck.y, {1, 0, 0});

		cleanGroup(terrain);
		local imax = math.ceil(_W/(256*terrain.xScale/2));
		local jmax = math.ceil(_H/(32*terrain.yScale/2));
		
		-- terrain.xScale, terrain.yScale;
		
		-- local ttypes = {"bricks"};
		-- its ok but not for first act: "sand", "snow", "dirt"
		-- "terrain" - cool, uncomplete, tiodor
		local filename = "tiles_"..ttype..imax.."x"..jmax.."x"..terrnd..".jpg";
		
		-- do
			local image = display.newImage(terrain, filename, system.TemporaryDirectory);
			if(image)then
				print('loaded cashed terrain:', filename);
				terrain.xScale, terrain.yScale = 1,1;
				image.x, image.y = image.width/2, image.height/2;
				return
			end
		-- end
		
		for j=-1,jmax do
			for i=-2,imax do
				local id = math.random(1,10);
				if(math.random()>0.5)then
					id = 1;
				end
				-- local ttype = "grass";
				-- local tile = display.newImage(terrain, "image/terrain/"..ttype..id..".png");
				-- tile.x, tile.y = 126*i + 64*(j%2), 64*j/2;
				local tile = display.newImage(terrain, "image/terrain/full/"..ttype..id..".png");
				tile:scale(1/2, 1/2);
				tile:setFillColor(3/4);
				tile.x, tile.y = 256*i/2 + 128*(j%2)/2, 256*j/4/2;
				
				tile.fill.effect = "filter.pixelate";
				tile.fill.effect.numPixels = 4;
			end
		end

		-- local envmc = newGroup(terrain);
		-- local shiftX, shiftY = _W/2, _H/2;
		-- envmc:translate(shiftX, shiftY);
		
		extra_loading_terrain = extra_loading_terrain+2;
		timer.performWithDelay(100, function()
			display.save(terrain, {filename=filename, baseDir=system.TemporaryDirectory, captureOffscreenArea=false, jpegQuality=0.70});
			extra_loading_terrain = extra_loading_terrain-1;
			timer.performWithDelay(100, function()
				extra_loading_terrain = extra_loading_terrain-1;
				local image = display.newImage(localGroup, filename, system.TemporaryDirectory);
				if(image)then
					cleanGroup(terrain);
					terrain:insert(image);
					print('loaded cashed terrain:', filename);
					terrain.xScale, terrain.yScale = 1,1;
					image.x, image.y = image.width/2, image.height/2;
				end
			end);
		end);
	end
	
	table.insert(loading_steps_arr, function()
		localGroup:resize();
	end);
	
	table.insert(loading_steps_arr, function()
		facemc:_refreshHand();
	end);
	table.insert(loading_steps_arr, function()
		for i=#units,1,-1 do
			local unit = units[i];
			if(unit.gid~=player_gid)then
				unit:showNextMove();
			end
		end
	end);
	
	table.insert(loading_steps_arr, function()
		if(save_obj["tutorial1"]~=true and save_obj.ai~=true)then
			facemc:pause_switch(true);
			if(facemc.showTutorial)then
				facemc:showTutorial();
			end
			if(facemc.pauseHideCtrls)then
				facemc:pauseHideCtrls(function()
					facemc:pause_switch(false);
				end);
			end
		end
		if(facemc.mpRefresh)then
			facemc:mpRefresh();
		end
	end);
	
	
	
	-- show_loading();
	local loadbg = display.newRect(localGroup, _W/2, _H/2, _W, _H);
	loadbg:setFillColor(0);
	local function loadingHandler(e)
		-- print("ent#conditions:", localGroup.conditions);
		loadbg:toFront();
		if(localGroup.conditions>0)then
			return
		end
		print("_extra_loading_terrain:", extra_loading_terrain);
		if(extra_loading_terrain>0)then
			return
		end
		
		print("_loading:", #loading_steps_arr);
		if(#loading_steps_arr>0)then
			local step = table.remove(loading_steps_arr, 1);
			step();
			loadbg:toFront();
		else
			Runtime:removeEventListener("enterFrame", loadingHandler);
			-- hide_loading();
			if(loadbg and loadbg.removeSelf)then
				-- loadbg:removeSelf();
				transition.to(loadbg, {time=200, alpha=0, onComplete=transitionRemoveSelfHandler});
			end
		end
	end
	Runtime:addEventListener("enterFrame", loadingHandler);
	
	function localGroup:actEscape()
		if(facemc.holded)then
			local cardmc = facemc.holded;
			cardmc:onMove();
			cardmc:onDropEx();
			facemc.holded = nil;
			return true;
		end
	
		facemc:pause_switch();
		return true;
	end
	function localGroup:actSpace()
		if(facemc.turnBtn.isVisible)then
			facemc.turnBtn.act();
		end
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);

	
	localGroup:regroup();
	
	facemc.deck:refresh();
	facemc.draw:refresh();
	facemc.trash:refresh();
		
	facemc:refreshGUI();
	facemc:refreshHand();
		
	function localGroup:removeAll()
		for i=1,#chests do
			local mc = chests[i];
			if(mc.opened~=true)then
				if(mc.ltype=="card")then
					table.insert(login_obj.eloot, {ltype=mc.ltype, rarity=mc.rarity, amount=1, list=mc.list});
				end
			end
		end
		
		royal:clearCardsLog();
		
		Runtime:removeEventListener("enterFrame", turnHandler);
	end
	
	return localGroup;
end