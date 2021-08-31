	function _G.handle_action(item_obj, sx, sy, facemc)
		if(item_obj._tracking)then
			item_obj._tracking._picked = true;
		end
		if(item_obj.minigame)then
			show_mini(item_obj.minigame);
			return
		end
		
		if(item_obj.msg)then
			if(facemc.msgtxt)then
				facemc.msgtxt:setText(item_obj.msg);
			end
		end
		
		if(item_obj.cleanStartingDeck)then
			print("cleanStartingDeck:", login_obj._cleandeck, #login_obj.deck);
			if(login_obj._cleandeck~=true)then
				login_obj._cleandeck = true;
				while(#login_obj.deck>0)do
					table.remove(login_obj.deck, 1);
				end
			end
		end
		
		if(item_obj.loserelics0)then
			for rid, bol in pairs(login_obj.relics) do
				local robj = relics_indexes[rid];
				if(robj.rarity==0)then
					removeRelic(rid, facemc);
				end
			end
			facemc:refreshRelics();
		end
		
		if(item_obj.login)then
			handleLoginObj(item_obj.login, facemc);
		end

		if(item_obj.search)then
			local val = math.random(0, 100);
			-- print('search:', facemc.search>val, facemc.search, val);
			local loot = table.randomByIndexEx(facemc.loots);
			if((options_cheats or facemc.search<val) and loot)then
				local attr, val = loot[1], loot[2];
				
				facemc.loots[attr] = nil;
				local obj = {};
				obj[attr] = val;
				obj.proceed = false;
				
				local msg = {};
				handleOneAction(obj, msg);
				show_msg(tostring(table.concat(msg, ", ")));
				
				handle_action(obj, sx, sy, facemc);
				facemc.search = facemc.search + item_obj.search;

				local txt = get_txt("event_search_txt");
				txt = txt:gsub("VAL", facemc.search);
				item_obj.dtxt:setText(txt);
				return
			else
				show_battle({ptype="elite", lvl=login_obj.map.lvl});
				return
			end
		end
		if(item_obj.price)then
			local success = false;
			for attr,val in pairs(item_obj.price.cost) do
				-- {txt="[Offer]", price={cost={relic="Blood Vial"}, removecard="Strike", card="Bite", times=5}},
				-- {txt="[Accept]", price={cost={hpmax=20}, removecard="Strike", card="Bite", times=5}},
				if(attr=="relic")then
					if(login_obj.relics[val])then
						removeRelic(val, facemc);
						facemc:refreshRelics();
						success = true;
					end
				end
				if(attr=="hpmax")then
					login_obj.hpmax = math.ceil(login_obj.hpmax * (100-val)/100);
					facemc:hpRefresh();
					success = true;
				end
				if(attr=="money")then
					if(login_obj.money>=val or options_cheats)then
						login_obj.money = login_obj.money - val;
						facemc:moneyRefresh();
						success = true;
					end
				end
				if(attr=="card")then
					local count = removeCardByTag(val);
					if(count>0)then
						facemc:bookRefresh();
						success = true;
					end
				end
			end
			print("_success:", success);
			if(success)then
				handle_action(item_obj.price, sx, sy, facemc);
			end
		end
		if(item_obj.heal)then
			local val = math.round(login_obj.hpmax*item_obj.heal);
			login_obj.hp = math.min(login_obj.hp+val, login_obj.hpmax);
		end
		if(item_obj.dmg)then
			local val = item_obj.dmg;
			login_obj.hp = login_obj.hp-val;
			facemc:hpRefresh();
		end
		if(item_obj.hpmax)then
			login_obj.hpmax = login_obj.hpmax + item_obj.hpmax;
			login_obj.hp = login_obj.hp + item_obj.hpmax;
		end
		if(item_obj.hpmaxper)then
			local val = math.ceil(login_obj.hpmax * item_obj.hpmaxper/100);
			login_obj.hpmax = login_obj.hpmax+val;
			facemc:hpRefresh();
		end
		if(item_obj.potion)then
			if(login_obj.potionless)then
				show_msg(get_txt('potionless'));
			else
				for i=1,item_obj.potion do
					local potion_obj = table.random(_G.potions);
					local potion_id = potion_obj.tag;
					table.insert(login_obj.potions, potion_id);
				end
				facemc:refreshPotions();
			end
		end
		if(item_obj.money)then
			local money = item_obj.money;
			login_obj.money = login_obj.money + money;
			if(login_obj.money_heals)then
				login_obj.hp = login_obj.hp + login_obj.money_heals;
				facemc:hpRefresh();
			end
			
			for i=1,money do
				local coin = display.newImage(facemc, "image/money_.png", sx, sy);
				local t = math.random(1100, 1500);
				local tar = facemc.moneyico;
				transition.to(coin, {time=t, x=tar.x, transition=table.random(easings)});
				transition.to(coin, {time=t, y=tar.y, transition=table.random(easings), onComplete=function(tmc)
					facemc:moneyRefresh();
					transitionRemoveSelfHandler(tmc);
				end});
			end
			facemc:moneyRefresh();
		end
		if(item_obj.moneylose)then
			local money = item_obj.moneylose;
			login_obj.money = math.max(login_obj.money - money, 0);
			facemc:moneyRefresh();
		end
		if(item_obj.relic)then
			getRelicLoot(3, false); -- shuffle and fill rloot if it not set yet
			
			if(relics_indexes[item_obj.relic])then
				addRelic(item_obj.relic, facemc);
			elseif(#login_obj.rloot>0)then
				for i=1,item_obj.relic do
					local rid = getRelicLoot(3, false);
					if(rid)then
						addRelic(rid, facemc);
					end
				end
			end
			facemc:refreshRelics();
		end
		
		if(item_obj.cardRnd)then
			for i=1,item_obj.cardRnd do
				local list = getCardLoot(5, nil, login_obj.class, false);
				addCardObj(table.random(list));
			end
		end
		if(item_obj.cardPicks)then
			for i=1,item_obj.cardPicks do
				table.insert(login_obj.eloot, {ltype='card', amount=1});
			end
		end
		if(item_obj.card1)then
			table.insert(login_obj.eloot, {ltype='card', rarity=1, amount=item_obj.card1});
		end
		if(item_obj.card2)then
			table.insert(login_obj.eloot, {ltype='card', rarity=2, amount=item_obj.card2});
		end
		if(item_obj.card3)then
			table.insert(login_obj.eloot, {ltype='card', rarity=3, amount=item_obj.card3});
		end
		if(item_obj.cardRndColorless)then
			for i=1,item_obj.cardRndColorless do
				local list = getCardLoot(5, nil, "none", false);
				addCardObj(table.random(list));
			end
		end
		
		if(item_obj.relic1)then
			local rid = getRelicLoot(1, true); 
			addRelic(rid, facemc);
			facemc:refreshRelics();
		end
		if(item_obj.relic2)then
			local rid = getRelicLoot(2, true); 
			addRelic(rid, facemc);
			facemc:refreshRelics();
		end
		if(item_obj.relic3)then
			local rid = getRelicLoot(3, true); 
			addRelic(rid, facemc);
			facemc:refreshRelics();
		end
		if(item_obj.relic4)then
			local rid = getRelicLoot(4, true); 
			addRelic(rid, facemc);
			facemc:refreshRelics();
		end
		if(item_obj.randomrelic)then
			local list = {};
			for i=1,#relics do
				local robj = relics[i];
				if(robj.group==item_obj.randomrelic)then
					if(login_obj.relics[robj.tag]~=true)then
						table.insert(list, robj.tag);
					end
				end
			end
			if(#list>0)then
				local rid = table.random(list);
				addRelic(rid, facemc);
				facemc:refreshRelics();
			else
				show_msg('error:cant_find_options');
			end
		end
		
		if(item_obj.curse)then
			local curses = {};
			for i=1,#cards do
				local cobj = cards[i];
				if(cobj.ctype==CTYPE_CURSE)then
					table.insert(curses, cobj.tag);
				end
			end
			
			for i=1,item_obj.curse do
				local card = table.random(curses);
				addCard(card);
			end
		end
		
		if(item_obj.cards)then
			for i=1,#item_obj.cards do
				local card_tag = item_obj.cards[i];
				addCard(card_tag);
			end
			facemc:bookRefresh();
		end
		if(item_obj.card)then
			if(item_obj.times)then
				for i=1,item_obj.times do
					addCard(item_obj.card);
				end
			else
				addCard(item_obj.card);
			end
			facemc:bookRefresh();
		end
		if(item_obj.change)then
			-- change={changePick={innate=true}, amount=1, filter={"ctype", CTYPE_ATTACK, true}}
			local obj = item_obj.change;
			local list = {};
			local filter = obj.filter;
			for j=1,#login_obj.deck do
				local card_obj = login_obj.deck[j];
				if((card_obj[filter[1]]==filter[2]) == filter[3])then
					table.insert(list, card_obj);
				end
			end
			
			showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, list, obj.amount, false, function(card_obj, mc)
				for attr,val in pairs(obj.changePick) do
					card_obj[attr] = val;
				end
				addCardAni(card_obj, true);
			end, function()
				-- show_map();
				if(item_obj.proceed~=false)then
					show_map();
				end
			end);
			return
		end
		if(item_obj.dublicate)then
			showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, item_obj.dublicate, false, function(card_obj, mc)
				local new_card = table.cloneByAttr(card_obj);
				addCardObj(new_card);
			end, function()
				show_map();
			end);
			return
		end
		if(item_obj.upgrade)then
			-- print('main_quest_type:', type(item_obj.upgrade), item_obj.upgrade);
			if(type(item_obj.upgrade)=="table")then
				for i=1,#item_obj.upgrade do
					local tag = item_obj.upgrade[i];
					for j=1,#login_obj.deck do
						local card_obj = login_obj.deck[j];
						if(card_obj.tag==tag)then
							upgradeCard(card_obj, nil, true);
						end
					end
				end
				
			else
				showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, item_obj.upgrade, true, function(card_obj, mc)
					upgradeCard(card_obj, mc, true);
				end, function()
					show_map();
				end);
				return
			end
			
		end
		if(item_obj.upgradeskills)then
			local trys = 0;
			local vals = item_obj.upgradeskills/1;
			while(trys<999 and vals>0 and #login_obj.deck>0)do
				local card_obj = table.random(login_obj.deck);
				local r = false;
				if(card_obj.ctype==CTYPE_SKILL)then
					r = upgradeCard(card_obj, nil, true);
				end
				if(r)then
					vals = vals-1;
				end
				trys = trys+1;
			end
			print("upgs:", trys, vals);
		end
		if(item_obj.upgradeattacks)then
			local trys = 0;
			local vals = item_obj.upgradeattacks/1;
			while(trys<999 and vals>0 and #login_obj.deck>0)do
				local card_obj = table.random(login_obj.deck);
				local r = false;
				if(card_obj.ctype==CTYPE_ATTACK)then
					r = upgradeCard(card_obj, nil, true);
				end
				if(r)then
					vals = vals-1;
				end
				trys = trys+1;
			end
			print("upgs:", trys, vals);
		end
		if(item_obj.transform)then
			showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, item_obj.transform, false, function(card_obj, mc)
				transformCard(card_obj);
			end, function()
				show_map();
			end);
			return
		end
		if(item_obj.rnd)then
			if(item_obj.rnd.chance/100 > math.random())then
				handle_action(item_obj.rnd, sx, sy, facemc);
			elseif(item_obj.rnd.onFail)then
				handle_action(item_obj.rnd.onFail, sx, sy, facemc);
				return
			else
				show_msg('not happened!');
			end
		end
		if(item_obj.removecard)then
			local function checkReward(card_obj)
				if(item_obj.rewards)then
					for i=1,#item_obj.rewards do
						local reward = item_obj.rewards[i];
						if(reward.ctype)then
							if(card_obj.ctype==reward.ctype)then
								handle_action(reward, sx, sy, facemc);
								return true
							end
						elseif(reward.rarity)then
							if(card_obj.rarity==reward.rarity)then
								handle_action(reward, sx, sy, facemc);
								return true
							end
						end
					end
				end
				return false
			end
			if(item_obj.removecard=="all")then
				while(#login_obj.deck>0)do
					table.remove(login_obj.deck, 1);
				end
			elseif(cards_indexes[item_obj.removecard])then
				local count = removeCardByTag(item_obj.removecard);
				local card_obj = cards_indexes[item_obj.removecard];
				checkReward(card_obj);
				facemc:bookRefresh();
			else
				local wnd = showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, item_obj.removecard, false, function(card_obj, mc)
					for i=#login_obj.deck,1,-1 do
						local temp = login_obj.deck[i];
						if(temp==card_obj)then
							table.remove(login_obj.deck, i);
							removeCardAni(card_obj);
							break;
						end
					end
					checkReward(card_obj);
					facemc:bookRefresh();
				end, function()
					show_map();
				end);
				if(wnd and wnd~=true)then
					item_obj.proceed = false;
					wnd:addHint(get_txt("event_removecard_"..item_obj.removecard.."_txt"));
				end
			end
			
			if((item_obj.removecard=="all" or item_obj.removecard=="rnd") and item_obj.proceed==nil)then
				item_obj.proceed = true;
			end
		end
		if(item_obj.upgraderandom)then
			for i=1,item_obj.upgraderandom do
				showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, 'rnd', true, function(card_obj, mc)
					upgradeCard(card_obj, mc, true);
				end);
			end
		end
		
		if(item_obj.sandbox)then login_obj.sandbox = true; end
		if(item_obj.ascend)then login_obj.ascend = true; end
		if(item_obj.cheat)then login_obj.cheat = true; end
		if(item_obj.daily)then login_obj.daily = true; end
		
		-- print("fa1", item_obj.daily and facemc.extramc);
		if(item_obj.daily)then
			if(login_obj.mods==nil)then login_obj.mods = {}; end
			table.insert(login_obj.mods, get_name_id(item_obj.tag));
			
			if(item_obj._ordinaldate)then
				login_obj._ordinaldate = item_obj._ordinaldate;
			end
		end
		
		local function add_bonus(str, obj)
			if(login_obj[str]==nil)then login_obj[str]={}; end
			for attr,val in pairs(item_obj[str]) do
				if(login_obj[str][attr] and type(val)=="number")then
					login_obj[str][attr] = login_obj[str][attr]+val;
				else
					login_obj[str][attr] = val;
				end
				
				if(login_obj[str]._count==nil)then
					login_obj[str]._count=1;
				else
					login_obj[str]._count=login_obj[str]._count+1;
				end
			end
		end
		
		if(item_obj.herobonus)then
			add_bonus('herobonus', item_obj.herobonus);
		end
		if(item_obj.enemiesbonus)then
			add_bonus('enemiesbonus', item_obj.enemiesbonus);
		end
		if(item_obj.removecurses)then
			if(item_obj.removecurses=="all")then
				for i=#login_obj.deck,1,-1 do
					local card_obj = login_obj.deck[i];
					if(card_obj.ctype==CTYPE_CURSE and card_obj.escape~=false)then
						table.remove(login_obj.deck, i);
						removeCardAni(card_obj);
					end
				end
				facemc:bookRefresh();
				show_map();
			else
				showCardPick(facemc, facemc.buttons, facemc.book.x, facemc.book.y, login_obj.deck, item_obj.removecurses, false, function(card_obj, mc)
					for i=#login_obj.deck,1,-1 do
						local temp = login_obj.deck[i];
						if(temp==card_obj)then
							table.remove(login_obj.deck, i);
							removeCardAni(card_obj);
							break;
						end
					end
					
					facemc:bookRefresh();
				end, function()
					show_map();
				end);
			end
			return
		end
		if(item_obj.fight)then
			local map_point = {};
			local party = getEnemySquadByTag(item_obj.fight);
			if(party)then
				map_point.lvl = party.lvl;
				map_point.party = party;
				map_point.reward = item_obj.reward;
				show_battle(map_point);
			else
				show_msg('error: cant find enemy party "'..item_obj.fight..'"');
			end
			return
		end
		if(item_obj.actions)then
			if(#item_obj.actions>0)then
				facemc:handleActions(item_obj.actions);
			else
				show_msg('error: no actions where it shoud be');
			end
			item_obj.proceed = false;
		end

		if(login_obj.callback)then
			login_obj:callback();
			return
		end
		-- print('proceed:', item_obj.proceed, item_obj.transform, item_obj.proceed~=false and item_obj.transform==nil); -- mods
		if(item_obj.proceed~=false and item_obj.transform==nil)then
			show_map();
		end
	end
	function _G.handleOneAction(item_obj, arr, prefix)
		local prefix_i = #arr;
		if(item_obj.heal)then
			local txt = get_txt("event_heal_txt");
			txt = txt:gsub("VAL", math.round(login_obj.hpmax*item_obj.heal));
			table.insert(arr, txt);
		end
		local function addDesc(attr, login_attr)
			if(item_obj[attr])then
				local txt = get_txt("event_"..attr.."_txt");
				
				if(attr=="hpmaxper")then
					txt = get_txt("event_".."hpmax".."_txt");
					if(item_obj[attr]>0)then
						txt = txt:gsub("VAL", "+"..math.ceil(item_obj[attr]*login_obj.hpmax/100));
					else
						txt = txt:gsub("VAL", ""..math.ceil(item_obj[attr]*login_obj.hpmax/100));
					end
				elseif(attr=="hpmax" and item_obj[attr]>0)then
					txt = txt:gsub("VAL", "+"..item_obj[attr]);
				else
					local val = item_obj[attr];
					if(login_attr)then
						val = math.min(val, login_obj[login_attr]);
					end
					txt = txt:gsub("VAL", val);
				end
				table.insert(arr, txt);
			end
		end
		addDesc("hpmax");
		addDesc("hpmaxper");
		addDesc("dmg");
		-- addDesc("potion");
		addDesc("money");
		addDesc("moneylose", "money");
		
		local function addDescExt(attr)
			if(item_obj[attr])then
				-- print(attr, type(item_obj[attr]), type(item_obj[attr])=="table")
				if(type(item_obj[attr])=="table")then
					local txt = get_txt("event_"..attr.."_specific_txt");
					local tags = {};
					for i=1,#item_obj[attr] do
						table.insert(tags, item_obj[attr][i]);
					end
					txt = txt:gsub("NAMES", table.concat(tags, ", "));
					table.insert(arr, txt);
				elseif(cards_indexes[item_obj[attr]])then
					local txt = get_txt("event_removecard_specific_txt");
					txt = txt:gsub("NAME", item_obj[attr]);
					table.insert(arr, txt);
				else
					local txt = get_txt("event_"..attr.."_"..item_obj[attr].."_txt");
					table.insert(arr, txt);
				end
			end
		end
		-- addDescExt("relic");
		addDescExt("potion");
		addDescExt("upgrade");
		addDescExt("dublicate");
		addDescExt("upgraderandom");
		addDescExt("removecard");
		addDescExt("removecurses");
		addDescExt("transform");
		addDescExt("curse");
		
		addDescExt("randomrelic");
		
		if(item_obj["price"])then
			local price = get_txt("lose_stuff");
			for attr,val in pairs(item_obj.price.cost) do
				local txt = val.." "..get_txt(attr);
				
				if(attr=="relic")then
					txt = '"'..royal.getRelicNameByRid(val)..'"';
				end
				if(attr=="hpmax")then
					txt = val.."%% "..get_txt(attr);
				end
				-- print("_attr:", attr, attr=="hpmax", txt);
				price = price:gsub("ATTR", txt..": ");
			end
			
			handleOneAction(item_obj.price, arr, price);
		end
		
		-- {txt="[Offer]", price={cost={relic="Blood Vial"}, removecard="Strike", card="Bite", times=5}},
		-- {txt="[Accept]", price={cost={hpmax=0.2}, removecard="Strike", card="Bite", times=5}},
		
		local function addDescNamExt(attr, val)
			local txt = get_txt("event_"..attr.."_txt");
			local name;
			if(attr=="relic")then
				local rid = val;
				name = royal.getRelicName(relics_indexes[rid]);
				-- name = get_name(item_obj[attr]);
				-- if(_G.settings.relicNames)then
					-- local
					-- local art_xml = get_xml_by_attr(arts_xml, 'type', tostring(scin));
					-- if(art_xml)then
						-- name = get_name(art_xml.properties.tag);--.." ("..name..")";
					-- end
				-- end
			else
				name = get_name(val);
			end
			txt = txt:gsub("VAL", name);
			if(item_obj.times)then
				txt = txt.." x"..item_obj.times;
			end
			table.insert(arr, txt);
		end
		local function addDescName(attr)
			if(item_obj[attr])then
				addDescNamExt(attr, item_obj[attr]);
			end
		end
		addDescName("card");
		
		if(item_obj.cards)then
			for i=1,#item_obj.cards do
				local card_tag = item_obj.cards[i];
				addDescNamExt("card", card_tag);
			end
		end
		
		if(item_obj.relic)then
			local attr = item_obj.relic;
			if(relics_indexes[attr])then
				addDescName("relic");
			else
				addDescExt("relic");
			end
		end
		
		-- upgradeskills upgradeattacks
		-- quest_upgradeattacks2="Upgrade 2 random Attacks"
		-- quest_upgradeskills2="Upgrade 2 random Skills"
		-- addDescExt("upgradeattacks");
		-- addDescExt("upgradeskills");
		if(item_obj.enemiesbonus)then
			local txt = get_txt("enemiesbonus");
			txt = txt:gsub("VAL", getCardDesc(item_obj.enemiesbonus));
			table.insert(arr, txt);
		end
		if(item_obj.herobonus)then
			local txt = get_txt("herobonus");
			txt = txt:gsub("VAL", getCardDesc(item_obj.herobonus));
			table.insert(arr, txt);
		end
		
		
		if(item_obj.login)then
			local hint_str, hint_arr = getRelicDesc({tag=item_obj.tag or 'event', login=item_obj.login});
			if(#hint_arr>0)then
				for i=1,#hint_arr do
					table.insert(arr, hint_arr[i]);
				end
			else
				table.insert(arr, hint_str);
			end
		end
		
		-- if(item_obj.sandbox)then
			-- local txt = get_txt("sandbox").." - "..get_txt("sandbox_hint");
			-- table.insert(arr, txt);
		-- end
		
		-- if(item_obj.ascend)then
			-- local txt = get_txt("ascend").." - "..get_txt("ascend_hint");
			-- table.insert(arr, txt);
		-- end
		if(item_obj.nothing)then
			table.insert(arr, get_txt("nothing"));
		end
		
		addDescExt("cardRnd");
		addDescExt("cardPicks");
		
		addDescExt("card1");
		addDescExt("card2");
		addDescExt("card3");
		
		addDescExt("cardRndColorless");
		
		addDescExt("relic1");
		addDescExt("relic2");
		addDescExt("relic3");
		addDescExt("relic4");
		addDescExt("loserelics0");
		
		if(prefix)then
			prefix_i = prefix_i+1;
			if(arr[prefix_i])then
				arr[prefix_i] = prefix..arr[prefix_i];
			end
		end
	end