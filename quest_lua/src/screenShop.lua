module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "shop";
	
	local background = display.newImage(localGroup, "image/background/wizardguild.jpg");
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
	
	function facemc:addBtn(txt, tx, ty, act)
		local btn = add_bar("black_bar3", 52*scaleGraphics);
		local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		facemc:insert(btn);
		btn.x, btn.y = tx, ty;
		btn.act = act;
		table.insert(localGroup.buttons, btn);
		elite.addOverOutBrightness(btn);
		function btn:setText(txt)
			dtxt.text = txt;
		end
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		return btn;
	end
	local gomc;
	gomc = facemc:addBtn('>>>', _W-30*scaleGraphics, _H/2, function()
		if(gomc)then
			gomc:setText(get_txt("question_exit"));
			gomc = nil;
		else
			show_map();
		end
	end);
	
	local function confirmation(act, txt, price, desc)
		local txt_arr = {};
		-- table.insert(txt_arr, get_txt('confirming'));
		table.insert(txt_arr, txt);
		if(desc)then
			table.insert(txt_arr, desc);
		end
		if(price)then
			-- table.insert(txt_arr, price);
			table.insert(txt_arr, "");
			table.insert(txt_arr, get_txt('cost')..': %y%'..price..'%y% '..get_txt('money'));
		end
		local wnd_mc = royal.show_wnd_question(facemc, facemc.buttons, txt_arr, function()
			act();
		end, function()
			-- tar_mc:hide_wnd();
		end);
		wnd_mc.x, wnd_mc.y = (_W-wnd_mc.w)/2, (_H-wnd_mc.h)/2;
	end
	
	local colorless_list = {};
	for i=1,#cards do
		local cobj = cards[i];
		if(cobj.class=="none")then
			if(cobj.rarity>0)then
				for j=cobj.rarity,3 do
					table.insert(colorless_list, cobj.tag);
				end
			end
		end
	end

	local loot = {};
	local function addLoot(list)
		local new_card = table.random(list);
		local again = true;
		local save = 200;
		while(again and save>0)do
			new_card = table.random(list);
			again = false;
			
			if(#loot>0)then
				for j=1,#loot do
					if(loot[j]==new_card)then
						again = true;
						break;
					end
				end
			end
			save = save-1;
		end
		-- print(new_card, save);
		table.insert(loot, new_card);
	end

	if(login_obj.cloot==nil)then login_obj.cloot={}; end
	for i=1,5 do
		addLoot(login_obj.cloot);
	end
	for i=1,2 do
		addLoot(colorless_list);
	end
	
	local list = {};
	for i=1,#loot do
		local ctype = loot[i];
		if(cards_indexes[ctype])then
			table.insert(list, table.cloneByAttr(cards_indexes[ctype]));
		end
	end
	
	local items = {};
	items.discount = true;
	function items:refresh()
		for i=1,#items do
			local mc = items[i];
			if(mc.removeSelf)then
				if(mc.refresh)then
					mc:refresh();
				end
			end
		end
		
		if(items.discount)then
			items.discount = false;
			local i = math.random(1, 5);
			local mc = items[i];
			mc.discount = 1;
			mc:refresh();
		end
	end
	
	local thisScale = scaleGraphics;
	local thisW, thisH = _W-40*scaleGraphics, _H-80*scaleGraphics;
	local cardW, cardH = 130, 210;
	local priceD = cardH/2-14;
	-- local thisDebug = display.newRect(facemc, _W/2, _H/2 + (_H - thisH)/2, thisW, thisH);
	-- thisDebug.alpha = 0.5;
	-- 80 / 160
	
	
	local tw, th = thisW/5, thisH/2;
	while((tw<cardW*thisScale or th<cardH*thisScale) and thisScale>0.1)do
		thisScale = thisScale - 0.01;
	end
	-- print("scales2:", thisScale, tw, cardW*thisScale, "|", th, cardH*thisScale);
	
	-- for i=1,3,2 do
		-- local test1 = display.newRect(gamemc, cardW*thisScale/2 + 10*scaleGraphics, (_H - thisH) + thisH * i/4, cardW, cardH);
		-- test1:scale(thisScale, thisScale);
		-- test1.alpha = 0.7;
		-- test1.strokeWidth = 2;
		-- test1:setStrokeColor(1, 0, 0, 0.5);
	-- end
	-- for i=0,4 do
		-- local test2 = display.newCircle(gamemc, cardW*thisScale/2 + 10*scaleGraphics, (_H - thisH) + thisH * i/4, 10*scaleGraphics);
		-- test2:setFillColor(1, 0, 0, 0.55);
	-- end
	
	
	-- for i=1,3,2 do
		-- local test1 = newGroup(gamemc);
		-- test1:translate(cardW*thisScale/2 + 10*scaleGraphics, (_H - thisH) + thisH * i/4);
		-- test1:scale(thisScale/2, thisScale/2);
		
		-- local body = display.newImage(test1, "image/deck.png");
		-- local body = display.newImage(test1, "image/cards_front_2.png");
	-- end

	
	local cards = newGroup(gamemc);
	local irow = 5;
	local sx, sy = _W/2, 80*scaleGraphics + 60*thisScale;
	for i=1,#list do
		local card_obj = list[i];
		local mc, body, ntxt = createCardMC(cards, card_obj, nil, card_obj.class);
		mc.x = sx - ((irow-(i-1)%irow)-irow/2-0.5)*cardW*thisScale;
		-- mc.y = sy + math.floor((i-1)/irow)*160*thisScale;
		-- mc.y = (_H - thisH)/2 + (math.floor((i-1)/irow)+1)*_H/3;
		local ij = math.floor((i-1)/irow)*2 + 1;
		mc.y = (_H - thisH) + thisH * (ij/4) - 8*scaleGraphics;
		
		-- body:scale(thisScale/2, thisScale/2);
		-- body:scale(1.5, 1.5);
		body.xScale, body.yScale = 1/2, 1/2;
		body:scale(2/scaleGraphics, 2/scaleGraphics);
		
		mc.xScale, mc.yScale = 1, 1;
		
		-- body.xScale, body.yScale = thisScale/2, thisScale/2;
		body:scale(thisScale, thisScale);
		
		mc.cost = math.random(20, 50) + math.random(15,30)*card_obj.rarity;
		if(card_obj.class=="none")then
			mc.cost = mc.cost + math.random(30,50)*card_obj.rarity;
		end
		
		local costtxt = display.newText(mc, mc.cost, 0, 0, fontMain, 12*scaleGraphics);
		costtxt.x, costtxt.y = 0, priceD*thisScale;
		local costico = display.newImage(mc, "image/money_.png");
		costico:scale(scaleGraphics/2, scaleGraphics/2);
		costico.x, costico.y = -(costtxt.contentWidth + costico.contentWidth + scaleGraphics*2)/2, costtxt.y;
		-- transition.to(mc, {time=700-i*100, x=_W/2 + 120*scaleGraphics*(i-#list/2-0.5), y=_H/2, xScale=2, yScale=2});
		
		table.insert(items, mc);
		function mc:refresh()
			if(mc.discount==1)then
				mc.cost = math.min(math.ceil(mc.cost/2), math.random(20,50));
				mc.discount = 2;
				-- print("_mc.cost:", mc.cost);
				costtxt.text = mc.cost;
			end
			if(login_obj.money<mc.cost)then
				if(costtxt.setTextColor)then
					costtxt:setTextColor(5/6, 1/6, 1/6);
				end
			elseif(mc.discount)then
				if(costtxt.setTextColor)then
					costtxt:setTextColor(1/6, 5/6, 1/6);
				end
			end
		end
		mc:refresh();
		
		function mc:disabled()
			return facemc.wnd~=nil;
		end
		
		mc.act = function(e)
			if(login_obj.money<mc.cost and options_cheats==false)then
				show_msg(get_txt('not_enought_money'));
				return false
			end
			
			confirmation(function()
				sound_play("shop_buy_card");
				login_obj.money = login_obj.money-mc.cost;
				facemc:moneyRefresh();
				
				items:refresh();
				
				costtxt:removeSelf();
				costico:removeSelf();
				-- mc:removeSelf();
				-- facemc:insert(mc);
				function mc:disabled()
					return true;
				end
				transition.to(mc, {time=500, x=facemc.book.x-10*scaleGraphics, y=facemc.book.y, xScale=1/5, yScale=1/5, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
				
				-- table.insert(login_obj.deck, card_obj);
				addCardObj(card_obj);
				facemc:bookRefresh();
			end, get_name(card_obj.tag), mc.cost, getCardDesc(card_obj));
		end;
		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = 80*thisScale, 160*thisScale;

		function mc:onOver()
			if(login_obj.money<mc.cost)then
				mc.ntxt:setTextColor(1, 0.5, 0.5);
			else
				mc.ntxt:setTextColor(0.5, 1, 0.5);
			end
		end
		function mc:onOut()
			mc:updateTitleText()
		end
	end
	
	local removemc = newGroup(facemc);
	local body = display.newImage(removemc, "image/deck.png");
	removemc.dtxt = newOutlinedText(removemc, get_txt('remove'), 0, 0, fontMain, 18*scaleGraphics, 1, 0, 1);
	
	local i = irow*2;
	removemc.x = sx - ((irow-(i-1)%irow)-irow/2-0.5)*cardW*thisScale;
	-- body:scale(scaleGraphics/2, scaleGraphics/2);
	-- body:scale(thisScale/4, thisScale/4);
	-- body:scale(1/2, 1/2);
	-- body:scale(1.5, 1.5);
	
	local ij = math.floor((i-1)/irow)*2 + 1;
	removemc.y = (_H - thisH) + thisH * (ij/4) - 8*scaleGraphics;
	
	removemc.xScale, removemc.yScale = 1, 1;
	body.xScale, body.yScale = thisScale/2, thisScale/2;
	
	if(login_obj.removecard_cost==nil)then login_obj.removecard_cost=75; end
	if(login_obj.removecard_inc==nil)then login_obj.removecard_inc=25; end
	
	local cost = login_obj.removecard_cost;
	local costtxt = display.newText(removemc, cost, 0, 0, fontMain, 12*scaleGraphics);
	costtxt.x, costtxt.y = 0, priceD*thisScale;
	local costico = display.newImage(removemc, "image/money_.png");
	costico:scale(thisScale/2, thisScale/2);
	costico.x, costico.y = -(costtxt.contentWidth + costico.contentWidth + thisScale*2)/2, costtxt.y;
	
	
	table.insert(items, removemc);
	function removemc:refresh()
		if(removemc.discount==1)then
			cost = math.min(math.ceil(cost/2), math.random(20,50));
			removemc.discount = 2;
		end
		if(login_obj.money<cost)then
			if(costtxt.setTextColor)then
				costtxt:setTextColor(5/6, 1/6, 1/6);
			end
		elseif(removemc.discount)then
			if(costtxt.setTextColor)then
				costtxt:setTextColor(1/6, 5/6, 1/6);
			end
		end
	end
	removemc:refresh();
		
	removemc.act = function(e)
		if(login_obj.money<cost and options_cheats==false)then
			show_msg(get_txt('not_enought_money'));
			return false
		end
		sound_play("shop_remove_card");

		local wnd = showCardPick(facemc, localGroup.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, false, function(card_obj, mc)
			local card_name = get_name(card_obj.tag);
			if(card_obj.lvl==nil)then card_obj.lvl=1; end
			if(card_obj.lvl>1)then
				card_name = "%%g%%"..card_name.."+".."%%g%%";
			end
			local cfrm_hint = get_txt('remove_card_hint'):gsub("NAME", card_name);
		
			confirmation(function()
				login_obj.money = login_obj.money-cost;
				facemc:moneyRefresh();
				items:refresh();
				
				login_obj.removecard_cost = login_obj.removecard_cost + login_obj.removecard_inc;
				
				for i=#login_obj.deck,1,-1 do
					local temp = login_obj.deck[i];
					if(temp==card_obj)then
						table.remove(login_obj.deck, i);
						break;
					end
				end

				removemc.dtxt:setText(get_txt('sold out'));
				removemc.act = nil;
				removemc.disabled = true;
				
				if(costico.removeSelf)then costico:removeSelf(); end
				if(costtxt.removeSelf)then costtxt:removeSelf(); end
				
				facemc:bookRefresh();
			end, get_txt('confirming'), cost, cfrm_hint);
		end);
		wnd:addOption(get_txt('cancel'), function()
			-- mc:closeMe();
		end);
		
	end
	table.insert(facemc.parent.buttons, removemc);
	removemc.w, removemc.h = 40*thisScale, 80*thisScale;
	function removemc:onOver()
		removemc.dtxt:setTextColor(0, 1, 0);
	end
	function removemc:onOut()
		removemc.dtxt:setTextColor(1, 1, 1);
	end
	function removemc:disabled()
		return facemc.wnd~=nil;
	end
	
	-- for i=1,3 do
		
	-- end
	
	local i = irow*2 - 2;
	local ix = sx - ((irow-(i-1)%irow)-irow/2-0.5-0.5)*cardW*thisScale;
	
	local ij = math.floor((i-1)/irow)*2 + 1;
	local iy = (_H - thisH) + thisH * (ij/4) - 60*thisScale;

	local shop_relics = {};
	
	local relic1txt = newOutlinedText(facemc, "", 0, iy + 16*thisScale + 20*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
	relic1txt:setTextColor(237/255, 198/255, 80/255);
	local relic2txt = newOutlinedText(facemc, "", 0, iy + 16*thisScale + 32*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
	
	for i=1,3 do
		local robj = table.random(relics);
		if(options_cheats)then
			robj = royal.getRelicNameByRid("Old Coin");
		end
		-- local rid = robj.tag;
		local tryes = 2000;
		local retry = true;
		-- "Old Coin", 				rarity=3, scin=225,login={money=300}
		while(retry or login_obj.relics[robj.tag] or robj.rarity==0 or robj.rarity==4 or robj.rarity==5 or robj.rarity==7 or shop_relics[robj.tag])do
			retry = false;
			robj = table.random(relics);
			
			if(robj.lbl)then
				print("_robj.lbl:", robj.tag, robj.lbl, login_obj.tags[robj.lbl], not login_obj.tags[robj.lbl]);
				if(not login_obj.tags[robj.lbl])then
					retry = true;
				end
			end
			
			if(robj.login)then
				if(robj.login.money)then
					retry=true;
				end
			end
			
			tryes = tryes-1;
			if(tryes<0)then
				break;
			end
		end
		print(robj.tag, royal.getRelicName(robj), tryes)
		-- if(options_cheats)then
			-- while(string.find(robj.tag, "Bracelet")==nil)do
				-- robj = table.random(relics);
			-- end
		-- end
		
		if(login_obj.relics[robj.tag])then
			break;
		end
		
		local rmc = newGroup(facemc);
		rmc.x, rmc.y = ix + (i - 3/2 - 0.5)*60*thisScale, iy;
		
		
		shop_relics[robj.tag] = true;
		
		for j=#login_obj.rloot,1,-1 do
			if(login_obj.rloot[j] == robj.tag)then
				table.remove(login_obj.rloot, j);
			end
		end
		
		local scin = robj.scin or 102;
		local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
		ico:scale(thisScale/2, thisScale/2);
		
		local cost = math.random(50,100) + robj.rarity*50;
		if(robj.rarity==6)then cost=math.random(100,200); end
		
		local costtxt = display.newText(rmc, cost, 0, 0, fontMain, 12*scaleGraphics);
		costtxt.x, costtxt.y = 0, 24*thisScale;
		local costico = display.newImage(rmc, "image/money_.png");
		costico:scale(thisScale/2, thisScale/2);
		costico.x, costico.y = -(costtxt.contentWidth + costico.contentWidth + thisScale*2)/2, costtxt.y;
		
		
		table.insert(items, rmc);
		function rmc:refresh()
			if(rmc.discount==1)then
				cost = math.ceil(cost/2);
				rmc.discount = 2;
			end
			if(login_obj.money<cost)then
				if(costtxt.setTextColor)then
					costtxt:setTextColor(5/6, 1/6, 1/6);
				end
			elseif(rmc.discount)then
				if(costtxt.setTextColor)then
					costtxt:setTextColor(1/6, 5/6, 1/6);
				end
			end
		end
		rmc:refresh();
		
		table.insert(localGroup.buttons, rmc);
		rmc.w, rmc.h = 30*thisScale, 30*thisScale;

		local name = royal.getRelicName(robj);
		local hint = getRelicDesc(robj);
		function rmc:onOver()
			relic1txt:setText(name);
			relic2txt:setText(hint);

			relic1txt.x = math.max(rmc.x, relic1txt.width/2);
			relic2txt.x = math.max(rmc.x, relic2txt.width/2);
			
			facemc:insert(relic1txt);
			facemc:insert(relic2txt);
		end
		function rmc:onOut()
			relic1txt:setText("");
			relic2txt:setText("");
		end
		function rmc:disabled()
			return facemc.wnd~=nil;
		end
		function rmc:act()
			if(login_obj.money<cost and options_cheats==false)then
				show_msg(get_txt('not_enought_money'));
				return false
			end
			sound_play("shop_buy_relic");
			confirmation(function()
				login_obj.money = login_obj.money-cost;
				facemc:moneyRefresh();
				addRelic(robj.tag, facemc);
				rmc:removeSelf();
				items:refresh();
				facemc:refreshRelics();
			end, name, cost, hint);
		end
	end
	
	local i = irow*2 - 2;
	local ix = sx - ((irow-(i-1)%irow)-irow/2-0.5-0.5)*cardW*thisScale;
	
	local ij = math.floor((i-1)/irow)*2 + 1;
	local iy = (_H - thisH) + thisH * (ij/4) + 20*thisScale;
	
	local relic1txt = newOutlinedText(facemc, "", 0, iy + 14*thisScale + 20*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
	relic1txt:setTextColor(237/255, 198/255, 80/255);
	local relic2txt = newOutlinedText(facemc, "", 0, iy + 14*thisScale + 32*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
	
	for i=1,3 do
		local rmc = newGroup(facemc);
		rmc.x, rmc.y = ix + (i - 3/2 - 0.5)*60*thisScale, iy;
		
		local potion_obj = table.random(_G.potions);
		local potion_id = potion_obj.tag;
		
		local ico = display.newImage(rmc, "image/potions/"..get_name_id(potion_id)..".png");
		if(ico==nil)then
			ico = display.newImage(rmc, "image/potions/_unknow.png");
		end
		ico:scale(thisScale/2, thisScale/2);
		
		local cost = 20 + potion_obj.rarity*25 + math.random(0,10);--Potion prices are now based on rarity (Common: 50, Uncommon: 75, Rare: 100)
		
		local costtxt = display.newText(rmc, cost, 0, 0, fontMain, 12*scaleGraphics);
		costtxt.x, costtxt.y = 0, 24*thisScale;
		local costico = display.newImage(rmc, "image/money_.png");
		costico:scale(thisScale/2, thisScale/2);
		costico.x, costico.y = -(costtxt.contentWidth + costico.contentWidth + thisScale*2)/2, costtxt.y;
		
		table.insert(items, rmc);
		function rmc:refresh()
			if(rmc.discount==1)then
				cost = math.ceil(cost/2);
				rmc.discount = 2;
			end
			if(login_obj.money<cost)then
				if(costtxt.setTextColor)then
					costtxt:setTextColor(5/6, 1/6, 1/6);
				end
			elseif(rmc.discount)then
				if(costtxt.setTextColor)then
					costtxt:setTextColor(1/6, 5/6, 1/6);
				end
			end
		end
		rmc:refresh();
		
		table.insert(localGroup.buttons, rmc);
		rmc.w, rmc.h = 30*thisScale, 30*thisScale;
		local hint = getCardDesc(potion_obj);
		function rmc:onOver()
			relic1txt:setText(get_name(potion_obj.tag));
			relic2txt:setText(hint);

			relic1txt.x = math.max(rmc.x, relic1txt.width/2);
			relic2txt.x = math.max(rmc.x, relic2txt.width/2);
		end
		function rmc:onOut()
			relic1txt:setText("");
			relic2txt:setText("");
		end
		function rmc:disabled()
			return facemc.wnd~=nil;
		end
		function rmc:act()
			if(login_obj.money<cost and options_cheats==false)then
				show_msg(get_txt('not_enought_money'));
				return false
			end
			sound_play("shop_buy_potion");
			confirmation(function()
				login_obj.money = login_obj.money-cost;
				facemc:moneyRefresh();
				table.insert(login_obj.potions, potion_id);
				facemc:refreshPotions();
				rmc:removeSelf();
				items:refresh();
			end, get_name(potion_obj.tag), cost, hint);
		end
	end
	
	items:refresh();
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	function localGroup:removeAll()
		royal:clearCardsLog();
	end
	
	function localGroup:actEscape()
		show_map();
		return true;
	end
	
	return localGroup;
end