module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "forge";
	
	local background = display.newImage(localGroup, "image/background/blacksmith.jpg");
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
	
	local forge_fname = "__forge_cards.json";
	local function getHammersPrice(rarity)
		if(login_obj.sandbox)then
			return 0;	
		else
			return 1 + rarity*rarity;
		end
	end
	local mycards;
	local myjson = loadFile(forge_fname);
	if(myjson)then
		mycards = json.decode(myjson);
	else
		mycards = {};
	end
	if(royal.forge==nil)then
		local firebase = require('firebase');
		royal.forge = firebase('https://cards-114b3.firebaseio.com/');
	end
	local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
	
	if(save_obj.hammers==nil)then save_obj.hammers=0; end
	local scrbar = facemc:addChainedBar(52*scaleGraphics);
	local moneyico = display.newImage(facemc, "image/hammers.png");
	moneyico.x, moneyico.y = scrbar.x - scrbar.w/2 + 12*_G.scaleGraphics, topY;
	moneyico:scale(_G.scaleGraphics/2, _G.scaleGraphics/2);
	local htxt = newOutlinedText(facemc, save_obj.hammers, scrbar.x + scrbar.w/2 - 2*scaleGraphics, moneyico.y, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
	function htxt:refresh()
		htxt:setText(save_obj.hammers);
		htxt.x = scrbar.x + scrbar.w/2 - 2*scaleGraphics - htxt.width/2;
	end
	htxt:refresh();
	
	local shop_item_id = "hammers_pack";
	local function tryToBuyHammers()
		if(options_shop_enabled and eliteShop:getItemShopObj(shop_item_id))then
			eliteShop:buyItem(shop_item_id, function(new_item_id)
				hide_loading(function()
					show_msg(get_txt("bought")..': '..get_txt(new_item_id));
					if(htxt.parent)then
						htxt:refresh();
					end
				end);
			end);
			return true;
		end
	end
	if(options_shop_enabled and eliteShop:getItemShopObj(shop_item_id))then
		scrbar.hint = get_txt(shop_item_id);
		scrbar.act = function(e)
			tryToBuyHammers();
		end
		table.insert(facemc.parent.buttons, scrbar);
		elite.addOverOutBrightness(scrbar);
	end
	
	function facemc:addBtn(txt, tx, ty, act)
		local btn = add_bar("black_bar3", 70*scaleGraphics);
		local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		fitTextFildByW(dtxt, 66*scaleGraphics);
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
	
	local thisScale = scaleGraphics*2;
	local thisW, thisH = _W-20*scaleGraphics, _H-80*scaleGraphics;
	local cardW, cardH = 130, 180;
	local tw, th = thisW/5, thisH/1;
	while((tw<cardW*thisScale or th<cardH*thisScale) and thisScale>0.1)do
		thisScale = thisScale - 0.01;
	end
	local moreX = math.max((_W - cardW*thisScale*5 - 10*scaleGraphics), 0);
	-- print("_moreX:", moreX);
	
	local function show_forge_merge(optionL, stype)
		cleanGroup(gamemc);
		local result = newGroup(gamemc);
		result:scale(thisScale/2, thisScale/2);
		result.x, result.y = _W/2 + cardW*thisScale + moreX*2, _H/2;

		local stackmc = newGroup(gamemc);
		stackmc.x, stackmc.y = _W/2 + cardW*0*thisScale, _H/2;
		
		do
			local rect = display.newRect(gamemc, stackmc.x, stackmc.y, 180*thisScale, _H);
			rect:toBack();
			rect:setFillColor(0, 0, 0, 0.15);
			
			local tx, ty = 0, 0;
			local function touchHandler(e)
				if(e.phase=='began')then
					tx, ty = e.x, e.y;
				elseif(e.phase=='moved')then
					local dx, dy = e.x-tx, e.y-ty;
					stackmc:translate(0, dy);
					tx, ty = e.x, e.y;
				end
			end
			rect:addEventListener('touch', touchHandler);
			elite.setScrollable(stackmc);
		end
		
		local stacklist = {};
		local checked = {};
		local mins = {energy=0, rarity=1};
		local sums = {energy=0};
		local echanges = {exhaust=-1, ethereal=-1};
		local exclude = {_merged=true, _likes=true, class=true, tag=true, author=true, timestamp=true};
		local energy_min = 9;
		function stackmc:refresh()
			stackmc.x, stackmc.y = _W/2 + cardW*0*thisScale, _H/2;
			local prms = {};
			mins = {energy=0, rarity=1};
			sums = {energy=0};
			for i,card_obj in pairs(stacklist) do
				if(card_obj.energy ~= "x")then
					energy_min = math.min(card_obj.energy, energy_min);
				end
				for attr, val in pairs(card_obj) do
					-- print(i, attr, val);
					if(sums[attr]~=nil)then
						if(val~="x")then
							sums[attr] = sums[attr] + val;
						end
					elseif(mins[attr]~=nil and attr~="times")then
						mins[attr] = math.max(mins[attr], val);
					elseif(exclude[attr]~=true and attr~="tempID" and attr~="onUpgrade" and attr~="tag" and attr~="lvl" and val~="any" and val~=0)then
						if(type(val)=="number" and attr~="ctype" and attr~="times")then
							mins[attr] = val;
						else
							table.insert(prms, {attr, val});
						end
					end
				end
				
				local icon = get_name_id(card_obj.tag);
				if(card_obj.class=="any")then
					icon = login_obj.class.."/"..get_name_id(card_obj.tag);
				else
					icon = card_obj.class.."/"..get_name_id(card_obj.tag);
				end
				table.insert(prms, {"icon", icon});
			end
			
			if(stype=="card")then
				table.insert(prms, {"icon", "_extra5"});
				table.insert(prms, {"hue", 0});
			end
			
			for attr,val in pairs(mins) do
				if(attr~="rarity" and attr~="energy")then
					table.insert(prms, {attr, val});
				end
			end
			
			for i=#prms,1,-1 do
				for j=#prms,1,-1 do
					if(i~=j)then
						if(prms[i][1]==prms[j][1])then
							if(prms[i][2]==prms[j][2])then
								table.remove(prms, j);
								break;
							end
						end
					end
				end
			end
			
			if(stype=="potion")then
				for i=#prms,1,-1 do
					if(prms[i][1]=="exhaust" or prms[i][1]=="innate" or prms[i][1]=="ethereal" or prms[i][1]=="ctype" or prms[i][1]=="icon")then
						table.remove(prms, i);
					end
				end
			end

			table.sort(prms, function(a, b)
				return a[1] < b[1];
			end);
			
			cleanGroup(stackmc);
			local btns = {};
			for i=1,#prms do
				local prm = prms[i];
				local attr, val = tostring(prm[1]), tostring(prm[2]);
				-- print(i, prm[1], prm[2], type(prm[2]));
				local itemmc = newGroup(stackmc);
				itemmc.x, itemmc.y = -moreX*2, (i - #prms/2-0.5)*16*scaleGraphics;
				if(attr=="ctype")then
					val = get_txt("ctype_"..val);
				end
				local dtxt = newOutlinedText(itemmc, get_txt(attr)..": "..val, -30*scaleGraphics, 0, fontMain, 12*scaleGraphics, 1, 0, 1);
				dtxt:translate(dtxt.width/2, 0);
				
				if(attr=="harm" or attr=="exhaust")then
					local btn = elite.addSmallSwitcher(itemmc, "image/gui/ready2", "image/gui/ready2", -40*scaleGraphics, 0, function()
						-- return checked[attr]==prm;
					end);
					checked[attr] = prm;
				else
					local btn = elite.addSmallSwitcher(itemmc, "image/gui/ready1", "image/gui/ready0", -40*scaleGraphics, 0, function()
						return checked[attr]==prm;
					end);
					table.insert(btns, btn);
					
					itemmc.act = function()
						if(checked[attr] == prm)then
							checked[attr] = nil;
						else
							checked[attr] = prm;
						end
						-- btn:refresh();
						for i=1,#btns do
							btns[i]:refresh();
						end
						result:refresh();
					end
				end
				
				table.insert(facemc.buttons, itemmc);
				itemmc.w, itemmc.h = cardW*thisScale, 14*scaleGraphics;
				elite.addOverOutBrightness(itemmc, btn);
				if(get_txt_force(attr.."_hint"))then
					itemmc.hint = get_txt(attr.."_hint");
				end
				function itemmc:disabled()
					return facemc.wnd~=nil;
				end
				
				
			end
		end

		function result:refresh()
			cleanGroup(result);
			result:toFront();
			
			local card_obj = {times=1};
			local prms_count = 0;
			for attr,prm in pairs(checked) do
				card_obj[prm[1]] = prm[2];
				if(attr~='icon' and attr~='range' and attr~='ctype' and attr~='hue' and attr~='author')then
					prms_count = prms_count+1;
				end
			end

			if(card_obj.icon==nil)then
				card_obj.icon = "_extra5";
			end
			if(card_obj.hue==nil)then
				card_obj.hue = math.random(0, 360);
			end
			card_obj.tag = result.cname;
			card_obj.energy = sums.energy;
			card_obj.rarity = mins.rarity;
			card_obj.class = login_obj.class;
			card_obj.author = player_name;
			if(card_obj.ctype==nil)then
				card_obj.ctype = CTYPE_ATTACK;
			end
			if(card_obj.range==nil)then
				card_obj.range = "enemy";
			end
			
			local _merged = 1;
			for i,cobj in pairs(stacklist) do
				-- counter=counter+1;
				if(cobj._merged)then
					_merged = math.max(_merged, cobj._merged+1);
				end
			end
			-- print("__merged:", _merged);
			card_obj._merged = _merged;
			
			-- if(card_obj.range=="enemies")then
				-- card_obj.energy = card_obj.energy+1;
			-- end
			
			local prms_limit = 5;
			card_obj.energy = math.max(math.floor(prms_count/prms_limit), energy_min);
			
			gamemc.hintprms.text = get_txt('prms')..": "..prms_count;
			if(prms_count>=prms_limit)then
				gamemc.hintprms.text = gamemc.hintprms.text;--..", +"..math.floor(prms_count/prms_limit).." "..get_txt('energy');
			end
			
			if(echanges)then
				for attr,val in pairs(echanges) do
					if(card_obj[attr])then
						card_obj.energy = card_obj.energy+val;
						card_obj.energy = math.max(0, card_obj.energy);
					end
				end
			end

			if(card_obj.times>1)then
				card_obj.energy = card_obj.energy+card_obj.times;
			end
			card_obj.energy = math.max(energy_min, card_obj.energy);
			card_obj.energy = math.max(1, card_obj.energy);
			
			card_obj.energy = math.min(9, card_obj.energy); -- limits energy cost to 9(couse I have only 9 in art!)
			
			result.card_obj = card_obj;
			local mc, body;
			if(stype=="card")then
				mc, body = createCardMC(result, card_obj, nil, nil, 2);
				mc.xScale, mc.yScale = 1, 1;
				body.xScale, body.yScale = 1, 1;
				result.card_mc = mc;
			end
			if(stype=="potion")then
				local mc = newGroup(result);
				mc.x = cardW*1 - moreX/result.xScale;
				local holder = display.newImage(mc, "image/cards_back.png");
				local ico = display.newImage(mc, "image/cards/none/panacea.jpg", 0, -41*2);
				local cfront = newShaderImage(mc, "image/cards_front_2.png", 0, 1, false);
				
				local holder = display.newImage(mc, "image/cards_rarity_1.png", 0, 2*2);
				local typemc = display.newImage(mc, "image/cards_ctype6.png", 0, 67*2);
				
				local ntxt = newOutlinedText(mc, "NAME", 0, -2*2, fontMain, 13*2, 1, 0, 1);
				ntxt.c = {1, 1, 1};
				mc.ntxt = ntxt;
				ntxt:setText(card_obj.tag);
				
				mc.dtxt = display.newText(mc, getCardDesc(card_obj, nil, nil, {}), 0*2, 10*2, 74*2, 0, fontMain, 9*2);
				mc.dtxt.anchorY = 0;
			end
			
			card_obj.onUpgrade = {};
			for i,scard in pairs(stacklist) do
				for attr,prm in pairs(checked) do
					if(scard.onUpgrade)then
						if(scard.onUpgrade[prm[1]])then
							if(card_obj.onUpgrade[prm[1]]~=nil)then
								if(type(card_obj.onUpgrade[prm[1]])=="number")then
									card_obj.onUpgrade[prm[1]] = math.max(scard.onUpgrade[prm[1]], card_obj.onUpgrade[prm[1]]);
								else
									card_obj.onUpgrade[prm[1]] = scard.onUpgrade[prm[1]];
								end
							else
								card_obj.onUpgrade[prm[1]] = scard.onUpgrade[prm[1]];
							end
						end
					end
				end
			end
			
			if(stype=="card")then
				local uobj = table.cloneByAttr(card_obj);
				upgradeCard(uobj);
				local umc, ubody = createCardMC(result, uobj, nil, nil, 2);
				umc.x, umc.y = mc.x + cardW*2 - moreX/result.xScale, mc.y;
				umc.xScale, umc.yScale = 1, 1;
				ubody.xScale, ubody.yScale = 1, 1;
			end
			
			gamemc.buildmc.isVisible = true;
			gamemc.hintbuild.isVisible = true;
			gamemc.hintprms.isVisible = true;
			
			if(gamemc.buildmc.pricemc)then
				gamemc.buildmc.pricemc:removeSelf();
			end
			local pricemc = newGroup(gamemc.buildmc);
			gamemc.buildmc.pricemc = pricemc;
			local hammers = getHammersPrice(result.card_obj.rarity);
			if(stype=="potion")then
				hammers = 1;
			end

			local btn = gamemc.buildmc;
			local moneyico = display.newImage(pricemc, "image/hammers.png");
			moneyico.x, moneyico.y = -btn.w/2 + 12*_G.scaleGraphics, 0;
			moneyico:scale(_G.scaleGraphics/2, _G.scaleGraphics/2);
			local dtxt = newOutlinedText(pricemc, hammers, btn.w/2 - 2*scaleGraphics, 0, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
			dtxt:translate(-dtxt.width/2, 0);
		end
		
		if(stype=="potion")then
			result.cname = "New Potion";
		else
			result.cname = "New Card";
		end
		result.act = function()
			local ntxt = elite.newNativeText(result, 0, -2*scaleGraphics, 80*scaleGraphics, 13*scaleGraphics, function(txt)
				if(cards_indexes[txt] or mycards[txt])then
					show_msg('this name already taken');
				else
					result.cname = txt;
					_G.language:addEnWord(get_name_id(txt), txt);
					result:refresh();
					
					royal.forge:get("cards/"..txt, nil, function(event)
						if(event.isError)then
							print("Network error!");
						else
							print("_event:", event.response);
							print("_event:", json.decode(event.response));
							local response = json.decode(event.response);
							if(response)then
								show_msg('this name already taken in global: '..txt);
							else
								print('this name is free', txt);
							end
						end
					end);
				end
				-- if(result.card_obj)then
					-- result.card_obj.tag = txt;
				-- end
				-- if(result.card_mc)then
					-- result.card_mc.card_obj = result.card_obj;
					-- result.card_mc:updateTitleText()
				-- end
			end);
			ntxt.text = result.cname;
			ntxt.maxsymbols = 16;
			-- ntxt.nospaces = true;
			ntxt.baned = {"%.", "%/", "%\\"};
		end
		table.insert(localGroup.buttons, result);
		result.w, result.h = 80*scaleGraphics, 120*scaleGraphics;
		
		for i=1,optionL do
			local option = newGroup(gamemc);
			local body = display.newImage(option, "image/card_hide.png");
			option:scale(thisScale/2, thisScale/2);
			option.x, option.y = _W/2 - cardW*i*thisScale-moreX*(3-i), _H/2;
			option.act = function()
				-- showCardPick(facemc, buttons, sx, sy, list, amount, upgradeable, callback, onClose, force)
				local list = {};
				for i=1,#login_obj.deck do
					local card = login_obj.deck[i];
					if(card.lvl==nil)then card.lvl=1; end
					-- if(card.lvl<2 or card.unlimited)then
						if(card.class~="negative")then
							table.insert(list, card);
						end
					-- end
				end
				
				if(#list==0)then
					local txt = get_txt("not_enought_val");
					txt = txt:gsub("VAL", get_txt("cards"));
					show_msg(txt);
					return
				end
		
				local wnd = showCardPick(facemc, facemc.buttons, option.x, option.y, list, 1, false, function(card_obj, mc)
					body:removeSelf();
					elite.removeMe(mc);
					
					mc = createCardMC(option, card_obj, nil, nil, 2);
					-- option:insert(mc);
					mc.x, mc.y = 0, 0;
					mc.xScale, mc.yScale = 1, 1;
					mc.body.xScale, mc.body.yScale = 1, 1;
					body = mc;
					stacklist[i] = card_obj;
					for attr,val in pairs(checked) do
						checked[attr] = nil;
					end
					stackmc:refresh();
					result:refresh();
				end);
				
				if(wnd)then
					if(type(wnd) == "table")then
						if(wnd.addOption)then
							wnd:addOption(get_txt('cancel'), function()
									-- mc:closeMe();
							end);
						end
					end
				end
			end
			function option:disabled()
				return facemc.wnd~=nil;
			end
			elite.addOverOutBrightness(option);
			option.w, option.h = body.contentWidth, body.contentHeight;
			table.insert(localGroup.buttons, option);
		end
		
		gamemc.hintbuild = display.newText(gamemc, get_txt('forge_hint_rename'), result.x + cardW*thisScale/2 - moreX, result.y - (cardH)*thisScale/2 - 10*scaleGraphics, fontMain, 12*scaleGraphics);
		gamemc.hintprms = display.newText(gamemc, get_txt('prms'), result.x + cardW*thisScale/2 - moreX, result.y + (cardH)*thisScale/2 + 4*scaleGraphics, fontMain, 12*scaleGraphics);
		
		gamemc.buildmc = facemc:addBtn("", result.x + cardW*thisScale/2 - moreX, result.y + (cardH)*thisScale/2+24*scaleGraphics, function(e)
			local hammers = getHammersPrice(result.card_obj.rarity);
			if(stype=="potion")then
				hammers = 1;
			end
			-- save_obj.hammers = save_obj.hammers+hammers;
			if(cards_indexes[result.card_obj.tag] or mycards[result.card_obj.tag])then
				show_msg('this name already taken');
				return
			end
			if(save_obj.hammers<hammers)then
				if(not tryToBuyHammers())then
					local txt = get_txt("not_enought_val");
					txt = txt:gsub("VAL", get_txt("hammers"));
					show_msg(txt);
				end
				return
			end
			
			local counter = 0;
			for i,card_obj in pairs(stacklist) do
				counter=counter+1;
			end
			if(counter<2 and stype=="card")then
				local txt = get_txt("not_enought_val");
				txt = txt:gsub("VAL", get_txt("cards"));
				show_msg(txt);
				return
			end
			
			local txt_arr = {};
			table.insert(txt_arr, get_txt('confirm'));
			for i,card_obj in pairs(stacklist) do
				table.insert(txt_arr, get_txt('destroy')..": "..card_obj.tag);
			end
			
			if(stype=="potion")then
				table.insert(txt_arr, get_txt('boil')..": "..result.card_obj.tag);
				table.insert(txt_arr, "");
				table.insert(txt_arr, get_txt('cost')..': %y%'..hammers..'%y% '..get_txt('hammers'));
				local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
					for i,card_obj in pairs(stacklist) do
						for j=#login_obj.deck,1,-1 do
							if(login_obj.deck[j]==card_obj)then
								table.remove(login_obj.deck, j);
								break;
							end
						end
					end
					
					if(save_obj.potions==nil)then save_obj.potions={}; end
					potions_indexes[result.card_obj.tag] = result.card_obj;
					save_obj.potions[result.card_obj.tag] = result.card_obj;

					table.insert(login_obj.potions, result.card_obj.tag);
					save_obj.hammers = save_obj.hammers-hammers;
					
					show_map();
				end, function()
					
				end);
			else
				table.insert(txt_arr, get_txt('build')..": "..result.card_obj.tag);
				table.insert(txt_arr, "");
				table.insert(txt_arr, get_txt('cost')..': %y%'..hammers..'%y% '..get_txt('hammers'));
				local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
					for i,card_obj in pairs(stacklist) do
						for j=#login_obj.deck,1,-1 do
							if(login_obj.deck[j]==card_obj)then
								table.remove(login_obj.deck, j);
								break;
							end
						end
					end
					
					addCardObj(result.card_obj);
					save_obj.hammers = save_obj.hammers-hammers;
					
					mycards[result.card_obj.tag] = result.card_obj;
					saveFile(forge_fname, json.encode(mycards));
					
					show_map();
					
					local data_json = json.encode(result.card_obj);
					royal.forge:put("cards/"..result.card_obj.tag.."/", data_json, nil, function(event)
						if(event.isError)then
							print("Network error!");
						else
							
							print("event:", event.response);
							print("json:", json.decode(event.response));
							local response = json.decode(event.response);
							if(response)then
								if(response.error)then
									show_msg('this name already taken in global: '..result.card_obj.tag);
								else
									show_msg('shared: ' .. result.card_obj.tag);
									
									royal.forge:put("cards/"..result.card_obj.tag.."/".."timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
										if(event.isError)then
											print("Network error!");
										else
											print('submit3');
										end
									end);
								end
							else
								show_msg('shared: ' .. result.card_obj.tag);
							end
						end
					end);
					
				end, function()
					
				end);
			end
		end);
		gamemc.buildmc.isVisible = false;
		gamemc.hintbuild.isVisible = false;
		gamemc.hintprms.isVisible = false;
		gamemc:insert(gamemc.buildmc);
	end
	
	facemc.boilerbtn = facemc:addBtn(get_txt('boiler'), _W - 60*scaleGraphics - 3*80*scaleGraphics, _H-30*scaleGraphics, function()
		show_forge_merge(1, 'potion');
	end);
	facemc.boilerbtn.hint = get_txt('forge_boiler_hint');
	
	facemc.destroybtn = facemc:addBtn(get_txt('destroy'), _W - 60*scaleGraphics - 4*80*scaleGraphics, _H-30*scaleGraphics, function()
		cleanGroup(gamemc);
		local wnd = showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, 1, false, function(card_obj, mc)
			local hammers = getHammersPrice(card_obj.rarity);
			local txt_arr = {};
			table.insert(txt_arr, get_txt('confirm'));
			table.insert(txt_arr, get_txt('destroy')..": "..card_obj.tag);
			table.insert(txt_arr, '+%y%'..hammers..'%y% '..get_txt('hammers'));
			local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
				-- for i,card_obj in pairs(stacklist) do
					for j=#login_obj.deck,1,-1 do
						if(login_obj.deck[j]==card_obj)then
							table.remove(login_obj.deck, j);
							break;
						end
					end
					save_obj.hammers = save_obj.hammers+hammers;
				-- end
				-- addCardObj(result.card_obj);
				-- show_map();
				htxt:refresh();
				facemc:bookRefresh();
				facemc.destroybtn.isVisible = false;
			end, function()
				
			end);
		end);
		if(type(wnd)~="boolean")then
			if(wnd.addOption)then
				wnd:addOption(get_txt('cancel'), function()
					
				end);
			end
		end
	end);
	facemc.destroybtn.hint = get_txt('forge_destroy_hint');
	if(login_obj.sandbox)then
		facemc.destroybtn.isVisible = false;
	end
	local gomc = facemc:addBtn(get_txt('merge'), _W - 60*scaleGraphics - 2*80*scaleGraphics, _H-30*scaleGraphics, function()
		show_forge_merge(2, 'card');
	end);
	gomc.hint = get_txt('forge_merge_hint');
	
	local function forge_external_card_cloned(card_obj, author)
		-- card_obj.tag
		-- _merged
		-- _likes
		-- _prms / complexity
		-- timestamp
		
		local likes = card_obj._likes or 0;
		if(card_obj._likes)then
			likes = card_obj._likes + 1;
		end
		
		if(card_obj.timestamp==nil)then
			royal.forge:put("cards/"..card_obj.tag.."/".."timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					print('submit3');
				end
			end);
		end
		
		royal.forge:put("cards/"..card_obj.tag.."/_likes", json.encode(likes), nil, function(event)
			if(event.isError)then
				print("Network error!");
			else
				print("event:", event.response);
				print("json:", json.decode(event.response));
				-- local response = json.decode(event.response);
				-- if(response)then
					-- if(response.error)then
						-- show_msg('this name already taken in global: '..result.card_obj.tag);
					-- else
						-- show_msg('shared: ' .. result.card_obj.tag);
						
						-- royal.forge:put("cards/"..result.card_obj.tag.."/".."timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
							-- if(event.isError)then
								-- print("Network error!");
							-- else
								-- print('submit3');
							-- end
						-- end);
					-- end
				-- else
					-- show_msg('shared: ' .. result.card_obj.tag);
				-- end
			end
		end);
		
		if(author and author~="" and author~=" ")then
			local function updateAuthorLikes(alikes)
				royal.forge:put("likes/"..author.."/likes", json.encode(alikes), nil, function(event)
					
				end);
			end
			royal.forge:get("likes/"..author.."/likes", nil, function(event)
				
				if(event.isError)then
					print("Network error!");
				else
					print("alikes@event:", event.response);
					print("alikes@json:", json.decode(event.response));
					local response = json.decode(event.response);
					print("alikes@response:", response, type(response));
					if(response)then
						updateAuthorLikes(response+1);
					else
						updateAuthorLikes(1);
					end
				end
					
				
			end);
			
		end
		
	end
	
	
	-- item_rarity1
	local cashe = {};
	local function show_cards_list(response, rarity, author)
		local list = {};
		for tag,card in pairs(response) do
			if(rarity==nil or card.rarity==rarity)then
				if(author==nil or card.author==author)then
					table.insert(list, card);
				end
			end
		end
		
		local wnd = showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, list, 1, false, function(card_obj, mc)
			local hammers = 1 + getHammersPrice(card_obj.rarity)*4;
			local txt_arr = {};
			table.insert(txt_arr, get_txt('confirm'));
			table.insert(txt_arr, get_txt('create')..": "..card_obj.tag);
			table.insert(txt_arr, "");
			table.insert(txt_arr, get_txt('cost')..': %y%'..hammers..'%y% '..get_txt('hammers'));
			local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
				if(save_obj.hammers<hammers)then
					if(not tryToBuyHammers())then
						local txt = get_txt("not_enought_val");
						txt = txt:gsub("VAL", get_txt("hammers"));
						show_msg(txt);
					end
					return
				end
				save_obj.hammers = save_obj.hammers-hammers;
				addCardObj(card_obj);
				show_map();
				forge_external_card_cloned(card_obj, author or card_obj.author);
			end, function()
				
			end);
		end, nil, false, {cardDY=16*scaleGraphics}); -- prms.cardDY
		if(wnd)then
			wnd:addOption(get_txt('cancel'), function()
				
			end);
			
			local cardsmc = wnd.cards;
			for i=1,cardsmc.numChildren do
				local mc = cardsmc[i];
				if(mc.author)then
					mc:author();
				end
				
				if(mc.card_obj)then
					for j=1,#login_obj.deck do
						local old = login_obj.deck[j];
						if(old.tag==mc.card_obj.tag)then
							mc.hint = get_txt("forge_already");
							mc.act = nil;
							mc.alpha = 0.5;
						end
						-- for j=#list,1,-1 do
							-- local new = list[j];
							-- if(old.tag==new.tag)then
								-- table.remove(list, j);
							-- end
						-- end
					end
					
					if(system.getInfo("environment")=="simulator")then
						local ico = display.newImage(mc, "image/gui/btnMinus.png");
						ico:translate(-44*mc._scale, -74*mc._scale);
						ico:scale(mc._scale/4, mc._scale/4);
						ico.hint = get_txt('remove');
						ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
						ico.act = function()
							mc:removeSelf();
							
							royal.forge:delete("cards/"..mc.card_obj.tag, nil, function(event)
								if(event.isError)then
									print("Network error!");
								else
									local data_obj = json.decode(event.response);
									print('deleted:', event.response, data_obj);
								end
							end)
							
							for tag,card in pairs(response) do
								if(mc.card_obj==card)then
									response[tag] = nil;
									break;
								end
							end
						end
						table.insert(localGroup.buttons, ico);
						elite.addOverOutBrightness(ico);
					end
				end
			end
		end
	end
	local gomc = facemc:addBtn(get_txt('build'), _W - 60*scaleGraphics - 1*80*scaleGraphics, _H-30*scaleGraphics, function()
		cleanGroup(gamemc);
		
		local function load_global_cards(rarity, author)
			local query = '?orderBy="class"&equalTo="'..login_obj.class..'"'..'&limitToLast=200';
			if(cashe[query])then
				show_cards_list(cashe[query], rarity, author);
				return
			end
			royal.forge:get("cards/", query, function(event)
				if(event.isError)then
					print("Network error!");
				else
					print("_event.response:", event.response);
					local response = json.decode(event.response);
					if(response)then
						cashe[query] = response;
						show_cards_list(response, rarity, author);
					else
						show_msg(get_txt("nothing_to_pick_from"));
					end
				end
			end);
		end
		
		local i = 0;
		if(player_name)then
			local gomc = facemc:addBtn(player_name, _W - 60*scaleGraphics - i*80*scaleGraphics, _H-60*scaleGraphics, function()
				load_global_cards(nil, player_name);
			end);
			gomc.hint = get_txt("own_recipts");
			gamemc:insert(gomc);
			i = i+1;
		end
		
		local gomc = facemc:addBtn(get_txt('item_rarity1'), _W - 60*scaleGraphics - i*80*scaleGraphics, _H-60*scaleGraphics, function()
			load_global_cards(1);
		end);
		i = i+1;
		gamemc:insert(gomc);
		gomc.hint = (1 + getHammersPrice(1)*4).." "..get_txt('hammers');
		
		local gomc = facemc:addBtn(get_txt('item_rarity2'), _W - 60*scaleGraphics - i*80*scaleGraphics, _H-60*scaleGraphics, function()
			load_global_cards(2);
		end);
		i = i+1;
		gamemc:insert(gomc);
		gomc.hint = (1 + getHammersPrice(2)*4).." "..get_txt('hammers');
		
		local gomc = facemc:addBtn(get_txt('item_rarity3'), _W - 60*scaleGraphics - i*80*scaleGraphics, _H-60*scaleGraphics, function()
			load_global_cards(3);
		end);
		gamemc:insert(gomc);
		gomc.hint = (1 + getHammersPrice(3)*4).." "..get_txt('hammers');
		i = i+1;
		
		
		
		-- local myjson = loadFile(forge_fname);
		-- if(myjson)then
			local list = {};
			for tag, card in pairs(mycards) do
				table.insert(list, card);
			end
			-- for i=1,#list do
				-- local card_obj = list[i];
			-- end
			
			-- local wnd = showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, list, 1, false, function(card_obj, mc)
				-- local hammers = getHammersPrice(card_obj.rarity)*2;
				-- local txt_arr = {};
				-- table.insert(txt_arr, get_txt('confirm'));
				-- table.insert(txt_arr, get_txt('create')..": "..card_obj.tag);
				-- table.insert(txt_arr, "");
				-- table.insert(txt_arr, get_txt('cost')..': %y%'..hammers..'%y% '..get_txt('hammers'));
				-- local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
					-- if(save_obj.hammers<hammers)then
						-- local txt = get_txt("not_enought_val");
						-- txt = txt:gsub("VAL", get_txt("hammers"));
						-- show_msg(txt);
						-- return
					-- end
					-- save_obj.hammers = save_obj.hammers-hammers;
					-- addCardObj(card_obj);
					-- show_map();
				-- end, function()
					
				-- end);
			-- end, nil, false);
			-- wnd:addOption(get_txt('cancel'), function()
				
			-- end);

	end);
	gomc.hint = get_txt('forge_build_hint');
	
	local exitmc;
	exitmc = facemc:addBtn('>>>', _W-60*scaleGraphics, _H-30*scaleGraphics, function()
		if(exitmc)then
			exitmc:setText(get_txt("question_exit"));
			exitmc = nil;
		else
			show_map();
		end
	end);

	function localGroup:actEscape()
		show_map();
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	-- if(options_cheats)then
		-- royal.forge:delete("cards", nil, function(event)
			-- print('fb:', event.isError, event.response);
			-- if(event.isError)then
				-- print("Network error!");
			-- else
				-- print();
			-- end
		-- end);
	-- end

	return localGroup;
end