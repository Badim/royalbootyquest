module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "map";
	
	local background = display.newImage(localGroup, "image/background/book.jpg");
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
	
	addTopBar(facemc, localGroup.buttons);

	local function addDeckBtn(tx, ty, txt, hint, act)
		local btn = newGroup(facemc);
		btn.x, btn.y = tx, ty;
		local body = display.newImage(btn, "image/deck.png");
		body:scale(scaleGraphics/8, scaleGraphics/8);
		btn.dtxt = newOutlinedText(btn, txt, 0, 0, fontMain, 18*scaleGraphics, 1, 0, 1);
		
		btn.hint="cheat: "..hint;
		btn.act = function(e)
			act(e);
		end
		table.insert(localGroup.buttons, btn);
		btn.w, btn.h = 30*scaleGraphics, 40*scaleGraphics;
		function btn:onOver()
			btn.dtxt:setTextColor(0, 1, 0);
		end
		function btn:onOut()
			btn.dtxt:setTextColor(1, 1, 1);
		end
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		return btn
	end
	
	local decksY = _H - 44*scaleGraphics;
	if(options_cheats or login_obj.sandbox)then
	facemc.upgrade = addDeckBtn(36*7*scaleGraphics, decksY, "✪", get_txt('upgrade'), function(e)
		showCardPick(facemc, localGroup.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, true, function(card_obj, mc)
			upgradeCard(card_obj, mc);
		end);
	end);
	
	facemc.plus = addDeckBtn(36*5*scaleGraphics, decksY, "⦾", 'add: colorless',function(e)
		local list = {};
		for i=1,#cards do
			if(cards[i].class=="none")then
				table.insert(list, cards[i]);
			end
		end
		showCardPick(facemc, facemc.parent.buttons, facemc.book.x, facemc.book.y, list, false, false, function(new_card, mc)
			addCard(new_card.tag);
			facemc.book.dtxt:setText(#login_obj.deck);
		end);
	end);
	facemc.plus = addDeckBtn(36*6*scaleGraphics, decksY, "Ω", 'add: negative',function(e)
		local list = {};
		for i=1,#cards do
			if(cards[i].class=="negative")then
				table.insert(list, cards[i]);
			end
		end
		showCardPick(facemc, facemc.parent.buttons, facemc.book.x, facemc.book.y, list, false, false, function(new_card, mc)
			addCard(new_card.tag);
			facemc.book.dtxt:setText(#login_obj.deck);
		end);
	end);
	
	facemc.plus = addDeckBtn(36*4*scaleGraphics, decksY, "⦿", "add: "..login_obj.class,function(e)
		local list = {};
		for i=1,#cards do
			if(cards[i].class==login_obj.class)then
				table.insert(list, cards[i]);
			end
		end
		showCardPick(facemc, facemc.parent.buttons, facemc.book.x, facemc.book.y, list, false, false, function(new_card, mc)
			addCard(new_card.tag);
			facemc.book.dtxt:setText(#login_obj.deck);
		end);
	end);
	
	facemc.plus = addDeckBtn(36*8*scaleGraphics, decksY, "♻", get_txt('remove'), function(e)
		showCardPick(facemc, localGroup.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, false, function(card_obj, mc)
			for i=#login_obj.deck,1,-1 do
				local temp = login_obj.deck[i];
				if(temp==card_obj)then
					table.remove(login_obj.deck, i);
					break;
				end
			end
			
			facemc:bookRefresh();
		end);
	end);
	
	if(_G.save_obj.druid_admin)then
		facemc.plus = addDeckBtn(36*10*scaleGraphics, decksY, "🖉", get_txt('sync'), function(e)
			royal:uploadTempCards("druid");
		end);
	end
	
	facemc.plus = addDeckBtn(36*2*scaleGraphics, decksY, "r", get_txt('items'), function(e)
		local wnd = newGroup(facemc);
		facemc.wnd = wnd;
		
		local rect = display.newRect(wnd, _W/2, _H/2, _W, _H);
		rect:setFillColor(0, 0, 0, 0.85);
		
		function wnd:closeMe()
			facemc.wnd = nil;
			wnd:removeSelf();
		end
		
		local relicsmc = newGroup(wnd);
		local rowD = 20*scaleGraphics;
		local itemW = 32*scaleGraphics;
		local rows = math.floor((_W - rowD*2)/(itemW))+1;
		
		local dtxt = newOutlinedText(wnd, "relics: "..#relics, _W/2, 22*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
		if(login_obj.tags)then
			local tags = table.keys(login_obj.tags);
			dtxt:setText("relics: "..#relics..", tags: "..table.concat(tags, ", "));
		end

		local relic1txt = newOutlinedText(wnd, "", 0, 100*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
		relic1txt:setTextColor(237/255, 198/255, 80/255);
		local relic2txt = newOutlinedText(wnd, "", 0, 116*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
		
		do
			local tx, ty = 0, 0;
			local function touchHandler(e)
				if(e.phase=='began')then
					tx, ty = e.x, e.y;
				elseif(e.phase=='moved')then
					local dx, dy = e.x-tx, e.y-ty;
					relicsmc:translate(0, dy);
					tx, ty = e.x, e.y;
				end
			end
			rect:addEventListener('touch', touchHandler);
			
			elite.setScrollable(relicsmc);
		end
	
		local j=0;
		for i=1,#relics do
			local robj = relics[i];
			local scin = robj.scin or 100;

			local rmc = newGroup(relicsmc);
			rmc.x, rmc.y = rowD + ((j)%rows)*itemW, 50*scaleGraphics + math.floor((j)/rows)*62*scaleGraphics;
			local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
			ico:scale(scaleGraphics/2, scaleGraphics/2);
			
			table.insert(localGroup.buttons, rmc);
			rmc.w, rmc.h = 30*scaleGraphics, 30*scaleGraphics;
			
			function rmc:act()
				if(robj.rarity==7)then
					local shop_item_id = robj._store;
					if(options_shop_enabled and eliteShop:getItemShopObj(shop_item_id))then
						eliteShop:buyItem(shop_item_id, function(new_item_id)
							hide_loading(function()
								show_msg(get_txt("bought")..': '..get_txt(new_item_id));
								if(facemc.parent)then
									show_map();
								end
							end);
						end);
					end
				else
					addRelic(robj.tag, facemc);
					facemc:refreshRelics();
					wnd:closeMe();
				end
			end

			local name = get_name(robj.tag).." ("..robj.rarity..")";
			local art_xml = get_xml_by_attr(arts_xml, 'type', tostring(scin));
			if(art_xml)then
				name = name.." / "..get_name(art_xml.properties.tag)
			end
			if(robj.lbl)then
				name = name.." ("..robj.lbl..")";
			end
			local hint = getRelicDesc(robj);
			function rmc:onOver()
				relic1txt:setText(name);
				relic2txt:setText(hint);

				relic1txt.x = math.min(math.max(rmc.x + relicsmc.x, relic1txt.width/2), _W-relic1txt.width/2);
				relic2txt.x = math.min(math.max(rmc.x + relicsmc.x, relic2txt.width/2), _W-relic2txt.width/2);
				
				relic1txt.y = rmc.y + relicsmc.y + 26*scaleGraphics;
				relic2txt.y = rmc.y + relicsmc.y + 42*scaleGraphics;
			end
			function rmc:onOut()
				relic1txt:setText("");
				relic2txt:setText("");
			end
			j = j+1;
		end
	end);
	
	facemc.plus = addDeckBtn(36*1*scaleGraphics, decksY, "e", get_txt('events'), function(e)
		local wnd = newGroup(facemc);
		facemc.wnd = wnd;
		
		local rect = display.newRect(wnd, _W/2, _H/2, _W, _H);
		rect:setFillColor(0, 0, 0, 0.85);
		
		function wnd:closeMe()
			facemc.wnd = nil;
			wnd:removeSelf();
		end
		
		local eventsmc = newGroup(wnd);
		elite.setScrollable(eventsmc);
		local rowD = 80*scaleGraphics;
		local itemW = 120*scaleGraphics;
		local rows = math.floor((_W - rowD*2)/(itemW))+1;
		
		local dtxt = newOutlinedText(wnd, "events: "..#events, _W/2, 22*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
		
		local j=0;
		local temp = {};
		for i=1,#events do
			local item_obj = events[i];
			
			local rmc = newGroup(eventsmc);
			rmc.x, rmc.y = rowD + ((j)%rows)*itemW, 50*scaleGraphics + math.floor((j)/rows)*60*scaleGraphics;
			-- local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
			-- ico:scale(scaleGraphics/2, scaleGraphics/2);
			
			local stxt = newOutlinedText(rmc, item_obj.tag.." ("..item_obj.lvl..")", 0, 0, fontMain, 10*scaleGraphics, 1, 0, 1);
			if(item_obj.msg)then
				table.insert(temp, item_obj.tag.."	"..item_obj.msg);
			else
				table.insert(temp, item_obj.tag);
			end
			
			for j=1,#item_obj.actions do
				local item_obj = item_obj.actions[j];
				local txt = newOutlinedText(rmc, item_obj.txt, 0, 12*scaleGraphics + (j-1)*12*scaleGraphics, fontMain, 8*scaleGraphics, 1, 0, 1);
				
				local qarr = {};
				handleOneAction(item_obj, qarr);
				table.insert(temp, item_obj.txt.."	"..table.concat(qarr, ", "));
			end
			
			
			
			table.insert(localGroup.buttons, rmc);
			rmc.w, rmc.h = 60*scaleGraphics, 30*scaleGraphics;
			
			function rmc:act()
				handleEvent("quest", facemc);
				show_event({ptype="quest", cheat=true, tag=item_obj.tag});
			end
			function rmc:onOver()
				stxt:setTextColor(0.7, 1.0, 0.7);
			end
			function rmc:onOut()
				stxt:setTextColor(1, 1, 1);
			end
			j = j+1;
			table.insert(temp, "");
		end
		if(options_debug)then
			saveFile("events.tvs", table.concat(temp, "\r\n"));
		end
	end);
	
	
	
	
	
	end
	
	local cheatsmc = newGroup(facemc);
	local function addCheatItems(tx, ty, title, act)
		local mc = newGroup(cheatsmc);
		local ico = display.newImage(mc, "image/map/"..title..".png");
		mc:translate(tx, ty);
		mc:scale(scaleGraphics/2, scaleGraphics/2);
		
		mc.hint = get_txt(title);
		function mc:onOver()
			ico.fill.effect = "filter.brightness";
			ico.fill.effect.intensity=0.1;
		end
		function mc:onOut()
			ico.fill.effect = nil;
		end
		function mc:disabled()
			return facemc.wnd~=nil or cheatsmc.isVisible==false;
		end
		mc.w, mc.h = 30*scaleGraphics, 30*scaleGraphics;
		table.insert(localGroup.buttons, mc);
		mc.act = function(e)
			transitionBlink(ico);
			act();
		end
		return mc
	end
	
	if(options_cheats and login_obj.sandbox~=true)then
	
	-- cheatsmc.isVisible = options_cheats;
	local ctxt = newOutlinedText(cheatsmc, "cheats", 0, 0, fontMain, 12*scaleGraphics, 1, 0, 1);
	ctxt.x, ctxt.y = _W - ctxt.width/2 - 10*scaleGraphics, _H - 88*scaleGraphics;
	
	addCheatItems(_W - 30*scaleGraphics, _H - 28*scaleGraphics, "boss", function()
		-- show_battle({ptype="elite", lvl=1, cheat=true});
		show_battle({ptype="boss", lvl=3, cheat=true, party={tag="Awakened One", 	lvl=3, 	achievement=8, units={"Cultist", "Cultist", "Awakened One"}}});
	end);
	addCheatItems(_W - 70*scaleGraphics, _H - 28*scaleGraphics, "battle", function()
		-- show_battle({ptype="elite", lvl=1, cheat=true});
		-- point.party = table.cloneByAttr(party);
		show_battle({ptype="battle", lvl=3, cheat=true});
	end);
	if(login_obj.sandbox~=true)then
		local cheat_forge = addCheatItems(_W - (40+60)*scaleGraphics, _H - 28*scaleGraphics, "forge", show_forge);
	end
	addCheatItems(_W - (70+60)*scaleGraphics, _H - 28*scaleGraphics, "shop", show_shop);
	addCheatItems(_W -(100+60)*scaleGraphics, _H - 28*scaleGraphics, "rest", show_rest);
	addCheatItems(_W -(130+60)*scaleGraphics, _H - 28*scaleGraphics, "treasure", function()
		show_battle({ptype="treasure", lvl=1, cheat=true});
	end);
	addCheatItems(_W - (160+60)*scaleGraphics, _H - 28*scaleGraphics, "elite", function()
		show_battle({ptype="elite", lvl=1, cheat=true});
	end);
	
	addCheatItems(_W - 90*scaleGraphics, _H - 60*scaleGraphics, "warp", function()
		map_rebuild(login_obj.map.lvl+1);
		show_map();
	end);
	addCheatItems(_W - 60*scaleGraphics, _H - 60*scaleGraphics, "end", function()
		login_obj.dead = true;
		show_end();
		saveGame();
	end);
	if(login_obj.sandbox~=true)then
		local cheat_destiny = addCheatItems(_W - 30*scaleGraphics, _H - 60*scaleGraphics, "destiny", function()
			show_destiny();
		end);
	end
	
	end
	
	if(login_obj.sandbox)then
		local cheat_forge = addCheatItems(_W - 60*scaleGraphics, _H - 28*scaleGraphics, "forge", show_forge);
		local cheat_destiny = addCheatItems(_W - 30*scaleGraphics, _H - 28*scaleGraphics, "destiny", show_destiny);
	end
	
	local mapobj = login_obj.map;
	local points = mapobj.points;
	
	local sx, sy = (- mapobj.width)/2, math.min((- mapobj.height)/2, 60*scaleGraphics);

	local mapmc = newGroup(gamemc);
	mapmc.x, mapmc.y = _W/2, _H/2;
	local pap2 = display.newImage(mapmc, "image/map/papirus_m.png");
	pap2.width = mapobj.width*scaleGraphics/2-100*scaleGraphics;
	pap2.yScale = scaleGraphics/2;
	pap2.x, pap2.y = 0, 20*scaleGraphics;
	
	local pap1 = display.newImage(mapmc, "image/map/papirus_l.png");
	pap1:scale(scaleGraphics/2, pap2.yScale);
	pap1.x, pap1.y = -(pap2.contentWidth + pap1.contentWidth)/2, pap2.y;
	
	local pap3 = display.newImage(mapmc, "image/map/papirus_r.png");
	pap3:scale(scaleGraphics/2, pap2.yScale);
	pap3.x, pap3.y =  (pap2.contentWidth + pap3.contentWidth)/2, pap2.y;
	
	local lines = newGroup(mapmc);
	local gsx, gsy = sx+mapobj.width/2, sy+mapobj.height/2;
	-- local grid = display.newRect(mapmc, 0, 0, mapobj.width, mapobj.height);
	-- grid.alpha = 1/5;
	
	if(login_obj.sandbox~=true)then
		facemc:showScores();
	end
	
	local map_tag = mapobj.tag;
	if(language:get_bol(map_tag))then
		map_tag = get_txt(map_tag);
	else
		map_tag = get_txt("actX"):gsub("VAL", mapobj.lvl);
	end
	
	local topX, deltaX = _W - 46*scaleGraphics, 4*scaleGraphics;
	
	local atxt = newOutlinedText(facemc, map_tag, _W/2, topY, fontMain, 14*scaleGraphics, 1, 0, 1);
	local function addBar(tw)
		local bar = add_bar("black_bar3", tw);
		facemc:insert(bar);
		topX = topX - bar.w/2;
		bar.x, bar.y = topX, topY;
		topX = topX - bar.w/2 - deltaX;
		elite:add_chains_pair(facemc, "gui/chain4", bar.x, -4*scaleGraphics, tw - 14*scaleGraphics, topY, 1);
		return bar;
	end
	local bar = addBar(atxt.width + 8*scaleGraphics);
	atxt.x = bar.x;
	facemc:insert(atxt);
	
	
	if (save_obj.act4) then
		if(save_obj.act4 and login_obj.map.lvl ~= 4)then
			local skulls = 0;
			for i=1,#points do
				local point = points[i];
				if(point.skull)then
					skulls = skulls+1;
				end
			end
			if(skulls<1)then
				if(login_obj.relics["Skull Green"]~=true)then
					login_obj.relics["Skull Green"]=true;
					show_msg('Green Skull - on the house');
				end
			end
		end
	
		local skulls = newGroup(facemc);
		skulls.w = 60*scaleGraphics;
		local bar = addBar(skulls.w);
		skulls.x, skulls.y = bar.x, bar.y;
		
		bar.act = function(e)
			show_skulls();
		end
		table.insert(facemc.parent.buttons, bar);
		elite.addOverOutBrightness(bar);

		
		local list = {"Skull Blue", "Skull Red", "Skull Green"};
		
		-- setRunStat("skulls", 0);
		
		for i=1,3 do
			local skull = display.newImage(skulls, "image/map/skull"..i..".png");
			skull:scale(scaleGraphics/2, scaleGraphics/2);
			skull.x, skull.y = (i - 3/2 - 0.5)*18*scaleGraphics, 0;
			skulls:toFront();
			local rid = list[i];
			if(login_obj.relics[rid])then
				-- addRunStat("skulls", 1);
			else
				skull.fill.effect = "filter.grayscale";
			end
		end
	end
	
	
	if(login_obj.eloot==nil)then login_obj.eloot={}; end
	-- if(options_cheats and #login_obj.eloot<1)then
		-- table.insert(login_obj.eloot, {ltype='card', rarity=1, amount=1});
		-- table.insert(login_obj.eloot, {ltype='card', rarity=2, amount=1});
		-- table.insert(login_obj.eloot, {ltype='card', rarity=3, amount="rnd"});
	-- end
	
	for i=#login_obj.eloot,1,-1 do
		local lootobj = login_obj.eloot[i];
		if(lootobj.dead)then
			table.remove(login_obj.eloot, i);
		end
	end
	
	if(login_obj.cardsreward==nil)then login_obj.cardsreward=3; end
	local function handleLoot(lootobj, cardmc)
		if(lootobj.list==nil)then
			lootobj.list = getCardLoot(login_obj.cardsreward, lootobj.rarity, lootobj.class);
		end
		local wnd = showCardPick(facemc, localGroup.buttons, sx, sy, lootobj.list, lootobj.amount, false, function(card_obj, mc)
			lootobj.dead = true;
			addCardObj(card_obj);
			facemc.book.dtxt:setText(#login_obj.deck);
			if(mc)then
				facemc:insert(mc);
				transition.to(mc, {time=500, x=facemc.book.x, y=facemc.book.y, xScale=1/2, yScale=1/2, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
			end
			show_map();
		end);
		if(wnd~=true and wnd~=false and wnd~=nil)then
			if(login_obj.consume)then
				wnd:addOption(get_txt('consume'), function()
					lootobj.dead = true;
					handleEvent('consume', facemc);
					show_map();
				end);
			end
			wnd:addOption(get_txt('cancel'), function()
				wnd:closeMe();
				cardmc.disabled = nil;
			end);
		end
		cardmc.disabled = true;
	end
	
	local lootmc;
	local show_loot_max = 3;
	local function fillLootMC()
		if(#login_obj.eloot>0)then
			lootmc = newGroup(facemc);
			local count = #login_obj.eloot
			if(#login_obj.eloot>show_loot_max)then
				count = 1;
			end
			lootmc.w = 16*scaleGraphics*count+4*scaleGraphics;
			local bar = addBar(lootmc.w);
			lootmc.x, lootmc.y = bar.x, bar.y;
			lootmc:toFront();
			
			function lootmc:highlight()
				for i=1,lootmc.numChildren do
					local cardmc = lootmc[i];
					cardmc.ico:setFillColor(1, 0, 0);
				end
			end
			
			for i=1,#login_obj.eloot do
				local lootobj = login_obj.eloot[i];
				local cardmc = newGroup(lootmc);
				local cardico = display.newImage(cardmc, "image/card_hide.png");
				cardmc.ico = cardico;
				cardmc.x, cardmc.y = (i - #login_obj.eloot/2 - 0.5)*16*scaleGraphics, 0;
				cardmc.w, cardmc.h = 24*scaleGraphics, 24*scaleGraphics;
				cardico:scale(scaleGraphics/18, scaleGraphics/18);
				links["eloot"] = cardmc;
				
				table.insert(localGroup.buttons, cardmc);
				elite.addOverOutBrightness(cardmc);
				cardmc.hint = get_txt('undecidedloot');--if(#login_obj.eloot>0)then
				
				local glow = newGroup(cardmc);
				glow:scale(scaleGraphics/5, scaleGraphics/3);
				local item = display.newImage(glow, "image/glow_3.png");
				anirotation(item, math.random(50, 60));
				
				local item = display.newImage(glow, "image/glow_3.png");
				anirotation(item, -math.random(20, 30));
				
				if(#login_obj.eloot>show_loot_max)then
					local dtxt = newOutlinedText(cardmc, #login_obj.eloot, 0, 0, fontMain, 10*scaleGraphics, 1, 0, 1);
					cardmc.x = 0;
					cardmc.act = function()
						handleLoot(lootobj, cardmc);
					end

					return;
				else
					cardmc.act = function()
						handleLoot(lootobj, cardmc);
					end
				end
			end
		end
	end
	fillLootMC();
	
	-- mapmc
	mapmc.act = function(e)
				
	end
	table.insert(localGroup.buttons, mapmc);
	mapmc.w, mapmc.h = (mapobj.width+300)*scaleGraphics/2, (mapobj.height+40)*scaleGraphics/2;

	function mapmc:onOver()
		
	end
	function mapmc:onOut()
		
	end
	function mapmc:onMove()
		-- print(mapmc.x, mapmc.y);
		-- if(mapmc.x>)then
			-- mapmc.x = 
		-- end
	end
	function mapmc:disabled()
		return facemc.wnd~=nil;
	end
	mapmc.dragable = true;
	mapmc.lockedY = true;
	
	mapmc.x = mapmc.w/2;
	
	function localGroup:onScroll(delta)
		if(facemc.wnd==nil)then
			mapmc:translate(delta*scaleGraphics/4, 0);
		end
	end
	
	local selmc = display.newCircle(mapmc, 999999, 999999, 20*scaleGraphics);
	selmc.strokeWidth= 4*scaleGraphics;
	selmc:setFillColor(0, 0, 0, 0);
	selmc:setStrokeColor(1, 1, 1, 1/2);
	selmc.isVisible = false;

	local indexes = {};
	for i=1,#points do
		local point = points[i];
		local mc = newGroup(mapmc);
		mc:translate(sx*scaleGraphics/2, 0);
		mc:translate(point.x*scaleGraphics/2, (point.y)*scaleGraphics/2);
		
		mc.obj = point;
		indexes[point.id] = mc;
		
		if(point.skull)then
			local item = display.newImage(mc, "image/glow_3.png");
			item:scale(scaleGraphics/2, scaleGraphics/2);
			anirotation(item, 50);
			
			local item = display.newImage(mc, "image/glow_3.png");
			item:scale(scaleGraphics/2, scaleGraphics/2);
			anirotation(item, -20);
		end
		
		if(mapobj.point == point.id)then
			selmc.x, selmc.y = mc.x, mc.y;
			selmc.isVisible = true;
		end
		
		local ico;
		local ico_patch = "image/map/hidden.png";
		if(point.hidden)then
			--ico = display.newImage(mc, "image/map/hidden.png");
			mc.hint = get_txt("unknown");
			if(options_cheats)then
				mc.hint = mc.hint.." ("..get_txt(point.ptype)..")"
			end
		else
			--ico = display.newImage(mc, "image/map/"..point.ptype..".png");
			ico_patch = "image/map/"..point.ptype..".png";
			mc.hint = get_txt(point.ptype);
			if(point.ptype=="boss")then
				if(point.party)then
					mc.hint = get_txt(point.party.tag);
				end
			end
			if((point.ptype=="battle" or point.ptype=="elite") and options_cheats)then
				if(point.party)then
					mc.hint = get_txt(point.party.tag);
				end
			end
		end

		-- local iglow = elite.add_glow_simple(mc, ico_patch, 2, {1, 1, 1, 1/20});
		ico = display.newImage(mc, ico_patch);
		-- ico:setFillColor(30/255, 30/255, 30/255);
		ico:scale(scaleGraphics/2, scaleGraphics/2);
		
		mc.act = function(e)
			transitionBlink(ico);
			
			if(not mc.playable)then
				if(options_cheats)then
					mc.playable = true;
				end
				show_msg(get_txt("too_far"));
				return
			end
			-- print("_point.xi:", point.xi);
			if(#login_obj.eloot>0 and mc.warning~=true and (point.xi==1 or point.ptype=="boss"))then
				show_msg(get_txt("warning_loot"));
				mc.warning = true;
				
				if(lootmc)then
					lootmc:highlight();
				end
				
				return
			end
			
			if(login_obj.hiddentreasure==nil)then login_obj.hiddentreasure=0; end
			if(login_obj.hiddennoenemies==nil)then login_obj.hiddennoenemies=0; end
			
			if(point.hidden and math.random() < login_obj.hiddentreasure/100)then
				point.ptype = "treasure";
			end
			print("_login_obj.hiddennoenemies:", point.ptype, login_obj.hiddennoenemies)
			if(point.hidden and point.ptype=="battle" and math.random()<login_obj.hiddennoenemies/100)then
				local list = {"quest", "quest", "quest", "shop", "treasure"};
				point.ptype = table.random(list);
			end
			
			selmc.x, selmc.y = mc.x, mc.y;
			selmc.isVisible = true;
			mapobj.point = point.id;
			
			point.dead = true;
			point.hidden = false;
			
			if(point.ptype=="rest")then
				show_rest();
			elseif(point.ptype=="forge")then
				if(login_obj.forgerest)then
					show_rest();
				else
					show_forge();
				end
			elseif(point.ptype=="quest")then
				handleEvent("quest", facemc);
				show_event(point);
			elseif(point.ptype=="shop")then
				show_shop();
			else
				show_battle(point);
			end
			addRunStat("floors");
		end
		
		if(point.dead)then
			-- ico.fill.effect = "filter.brightness";
			-- ico.fill.effect.intensity=0.1;
			ico.fill.effect = "filter.saturate";
			ico.fill.effect.intensity = 0;
			ico:setFillColor(1/4);
			-- mc.alpha = 0.3;
			-- if(iglow.removeSelf)then
				-- iglow:removeSelf();
			-- end
		else
			table.insert(localGroup.buttons, mc);
			mc.w, mc.h = 30*scaleGraphics, 30*scaleGraphics;
		end

		function mc:onOver()
			ico.fill.effect = "filter.brightness";
			ico.fill.effect.intensity=0.1;
		end
		function mc:onOut()
			ico.fill.effect = nil;
		end
		function mc:disabled()
			return facemc.wnd~=nil;
		end
	end
	
	for i=1,#points do
		local point = points[i];
		local mc = indexes[point.id];
		
		if(point.nxt1)then
			if(indexes[point.nxt1])then
				local parmc = indexes[point.nxt1];
				local dx, dy = mc.x-parmc.x, mc.y-parmc.y;
				local cx, cy = (mc.x+parmc.x)/2, (mc.y+parmc.y)/2;
				dx, dy = dx*0.2, dy*0.2;
				local line = display.newLine(lines, cx-dx, cy-dy, cx+dx, cy+dy);
				-- line:scale(0.5, 0.5);
				-- mapmc:insert(4, line);
				line.strokeWidth = 4*scaleGraphics;
				line.alpha = 0.5;
				line:setStrokeColor(30/255);
				parmc.child = mc;
			end
		end
		if(point.nxt2)then
			if(indexes[point.nxt2])then
				local parmc = indexes[point.nxt2];
				local dx, dy = mc.x-parmc.x, mc.y-parmc.y;
				local cx, cy = (mc.x+parmc.x)/2, (mc.y+parmc.y)/2;
				dx, dy = dx*0.2, dy*0.2;
				local line = display.newLine(lines, cx-dx, cy-dy, cx+dx, cy+dy);
				-- line:scale(0.5, 0.5);
				-- mapmc:insert(3, line);
				line.strokeWidth = 4*scaleGraphics;
				line.alpha = 0.5;
				line:setStrokeColor(30/255);
				parmc.child = mc;
			end
		end
	end
	
	
	local map_beated = true;
	for i=1,#points do
		local point = points[i];
		local mc = indexes[point.id];
		if(mapobj.point==nil)then
			if(mc.child==nil)then
				transitionBeat(mc, 200, true);
				mc.playable = true;
				map_beated = false;
			end
		else
			if(point.id==mapobj.point)then
				if(point.nxt1)then
					if(indexes[point.nxt1])then
						local parmc = indexes[point.nxt1];
						transitionBeat(parmc, 200, true);
						parmc.playable = true;
						map_beated = false;
					end
				end
				if(point.nxt2)then
					if(indexes[point.nxt2])then
						local parmc = indexes[point.nxt2];
						transitionBeat(parmc, 200, true);
						parmc.playable = true;
						map_beated = false;
					end
				end
			end
		end
	end
	
	-- print("_map_beated:", map_beated);
	if(map_beated)then
		show_msg("Map beated. Why you even here? Plz restart the Game.");
		map_rebuild(login_obj.map.lvl+1);
		-- show_map();
	end
	
	for i=1,#login_obj.deck do
		local card_obj = login_obj.deck[i];
		local id = get_name_id(card_obj.tag);
		save_obj.unlocks['card_'..id]=2;
	end
	
	for rid,val in pairs(login_obj.relics) do
		if(val)then
			local id = get_name_id(rid);
			save_obj.unlocks['item_'..id] = 2;
		end
	end
	
	
	saveGame();
	if(settings.playerName and settings.playerPIN and settings.cloudAutoSave)then
		saveCloud();
	end
	setLoginStat("decksize", #login_obj.deck);
	
	local cards_log = royal.cards_log;
	local newcardsmc = newGroup(facemc);
	if(#cards_log>0)then
		-- local function logHandler(e)
			-- if(localGroup.dead or localGroup.parent==nil)then
				-- Runtime:removeEventListener("enterFrame", logHandler);
				-- return
			-- end
			local delay, extra = 850, 500;
			local easings = {easing.inBack, easing.outBack, easing.inOutBack, easing.outInBack};
			while(#cards_log>0)do
				local log_obj = table.remove(cards_log, 1);
				local card_obj = log_obj.obj;
				local mc, body, ntxt = createCardMC(newcardsmc, card_obj);
				body.xScale, body.yScale = settings.cardScaleMax, settings.cardScaleMax;
				mc.x, mc.y = _W/2, _H/2;

				transition.to(mc, {delay=delay + #cards_log*200+extra, time=900, x=facemc.book.x, xScale=scaleGraphics/18, yScale=scaleGraphics/18, transition=table.random(easings)});
				transition.to(mc, {delay=delay + #cards_log*200+extra, time=900, y=facemc.book.y, xScale=scaleGraphics/18, yScale=scaleGraphics/18, transition=table.random(easings)});
				
				transition.to(mc, {delay=delay + #cards_log*200+extra, time=900, xScale=scaleGraphics/18, yScale=scaleGraphics/18, transition=table.random(easings), onComplete=transitionRemoveSelfHandler});
			end
			
			-- local easings = {easing.inBack, easing.outBack, easing.inOutBack, easing.outInBack};
			for i=1,newcardsmc.numChildren do
				local mc = newcardsmc[i];
				local tx = _W/2 + math.random(-200, 200)*scaleGraphics;
				local ty = _H/2 + math.random(-60, 60)*scaleGraphics;
				
				mc.alpha = 0;
				transition.to(mc, {time=delay, x=tx, y=ty, alpha=1, transition=easing.outQuart});
			end
		-- end
		-- Runtime:addEventListener("enterFrame", logHandler);
	else
		local review_link;
		if(options_steam)then
			review_link = "https://store.steampowered.com/recommended/recommendgame/948350";
		elseif(optionsBuild=="ios")then
			review_link = "https://itunes.apple.com/us/app/royal-booty-quest/id1414474189?mt=8&action=write-review";
		elseif(optionsBuild=="mac")then
			review_link = "https://itunes.apple.com/us/app/royal-booty-quest/id1436377350?mt=12&action=write-review";
		end
		
		
		if(review_link)then
			if(settings.reviewrequest==nil)then
				settings.reviewrequest=50;
				require("eliteScale").saveScales();
			end

			if(settings.reviewrequest>0)then -- and options_cheats==false
				settings.reviewrequest = settings.reviewrequest-1;
				require("eliteScale").saveScales();
			else
				local txt_arr = {};
				local txt = get_txt('enjoing_gname'):gsub("NAME", moregamesName);
				table.insert(txt_arr, txt);
				table.insert(txt_arr, get_txt("enjoing_review"));
				local cnfr_mc = royal.show_wnd_question(facemc, facemc.buttons, txt_arr, function()
					-- ok
					system.openURL(review_link);
					-- settings.reviewrequest = 0;
					require("eliteScale").saveScales();
				end, function()
					-- cancel
					settings.reviewrequest = 1000;
					require("eliteScale").saveScales();
				end);
				cnfr_mc:addOption('later', function()
					-- later
					settings.reviewrequest = 100;
					require("eliteScale").saveScales();
				end);
				cnfr_mc.x, cnfr_mc.y = _W/2 - cnfr_mc.w/2, _H/2 - cnfr_mc.h/2;
			end
		else
			print('dont have a review link');
		end
	end
	
	-- print("tutorial_undecidedloot_1:", save_obj.unlocks['tutorial_undecidedloot_1']);
	if(#login_obj.eloot>0)then
		if(facemc.wnd==nil and newcardsmc.numChildren==0)then
			if(#tutorials==0)then
				if(save_obj.unlocks['tutorial_undecidedloot_1']==nil)then
					table.insert(tutorials, {title="undecidedloot"});
					table.insert(tutorials, {title="undecidedloot", high="eloot"});
					
					tutorials:restep();
					tutorials:setScene(localGroup);
					tutorials:step();
				end
			end
		end
	end
	
	if(selmc.isVisible)then
		local function autoScroll(e)
			if(localGroup.dead or localGroup.removeSelf==nil)then
				Runtime:removeEventListener("enterFrame", autoScroll);
				return
			end
			
			if(selmc.localToContent==nil)then
				Runtime:removeEventListener("enterFrame", autoScroll);
				return
			end
			local tx, ty = selmc:localToContent(0, 0);
			-- print(tx, ty);
			if(tx>_W-200*scaleGraphics)then
				mapmc.x = mapmc.x-(tx-(_W-200*scaleGraphics))/4;
			else
				mapmc.x = math.floor(mapmc.x);
				Runtime:removeEventListener("enterFrame", autoScroll);
			end
		end
		Runtime:addEventListener("enterFrame", autoScroll);
	end
	
	function localGroup:actEscape()
		facemc:pause_switch();
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	for rid, bol in pairs(login_obj.relics) do
		local robj = relics_indexes[rid];
		if(robj==nil)then
			login_obj.relics[rid] = nil;
			show_msg('(error) relic was changes and removed for current run:'..tostring(rid));
		end
	end
	
	if(pixelArtOn)then pixelArtOn(); end
	game_art:loadDataByObj(game_art.sets[login_obj.scin]);
	if(pixelArtOff)then pixelArtOff(); end
	
	return localGroup;
end