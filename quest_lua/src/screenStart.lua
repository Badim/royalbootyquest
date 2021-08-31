module(..., package.seeall);

function new(options)	
	local localGroup = display.newGroup();
	localGroup.name = "start";
	
	local background = display.newImage(localGroup, "image/background/barrack.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	if(save_obj.diamonds==nil)then save_obj.diamonds=0; end
	local function tryToBuyDiamonds()
		local shop_item_id = "diamonds_pack";
		
		local msg = get_txt("not_enought_val");
		msg = msg:gsub("VAL", get_txt("diamonds"));
		
		if(options_shop_enabled and eliteShop:getItemShopObj(shop_item_id))then
			local wnd = newGroup(facemc);
			wnd.x, wnd.y = _W/2, _H/2;
			function wnd:closeMe()
				wnd:removeSelf();
				facemc.wnd = nil;
			end
			facemc.wnd = wnd;
			
			local rect = display.newRect(wnd, 0, 0, _W, _H);
			rect:setFillColor(0, 0, 0, 0.85);
			
			-- local mcbg = add_bg_title("bg_3", 400*scaleGraphics, 100*scaleGraphics, get_txt('diamonds'));
			-- mcbg.x, mcbg.y = 0, 0;
			-- wnd:insert(mcbg);
			
			-- local dtxt = display.newText(wnd, msg, 0, -20*scaleGraphics, fontMain, 14*scaleGraphics);
			-- local dtxt = display.newText(wnd, get_txt("diamonds_hint"), 0, 0, fontMain, 14*scaleGraphics);
			
			-- facemc:addBtn(wnd, localGroup.buttons, "5 - $9.99", 0, 30*scaleGraphics, function()
				
			-- end, 100*scaleGraphics);
			
			local txt_arr = {};
			-- table.insert(txt_arr, get_txt('diamonds'));
			table.insert(txt_arr, msg);
			table.insert(txt_arr, get_txt("diamonds_hint"));
			table.insert(txt_arr, get_txt("diamonds_buy"));
			table.insert(txt_arr, "");
			table.insert(txt_arr, "");
			table.insert(txt_arr, "5 Diamonds - $9.99");
			-- table.insert(txt_arr, "");
			
			local cnfr_mc = royal.show_wnd_question(wnd, localGroup.buttons, txt_arr, function()
				eliteShop:buyItem(shop_item_id, function(new_item_id)
					hide_loading(function()
						show_msg(get_txt("bought")..': '..get_txt(new_item_id));
						show_start();
					end);
				end);
			end, function()
				wnd:closeMe();
			end, 420*scaleGraphics);
			cnfr_mc.x, cnfr_mc.y = 0*_W/2 - cnfr_mc.w/2, 0*_H/2 - cnfr_mc.h/2;
			
			for i=1,5 do
				local img = display.newImage(wnd, "image/map/diamond.png", (i - 5/2 - 1/2)*30*scaleGraphics, 0, cnfr_mc.h - 20*scaleGraphics);
				img:scale(scaleGraphics/2, scaleGraphics/2);
			end
			
		else
			
			show_msg(msg);
		end
	end
	
	local minY = _H - (12+options_save_border_h)*scaleGraphics - 12*scaleGraphics;

	function facemc:addBtn(tar, buttons, txt, tx, ty, act, btwW)
		local btn = add_bar("black_bar3", btwW or 70*scaleGraphics);
		local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		while(dtxt.width>btn.w-4*scaleGraphics and dtxt.size>4)do
			dtxt.size = dtxt.size-1;
		end
		btn.dtxt = dtxt;
		tar:insert(btn);
		btn.x, btn.y = tx, ty;
		btn.act = act;
		-- table.insert(localGroup.buttons, btn);
		table.insert(buttons, btn);
		elite.addOverOutBrightness(btn);
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		return btn;
	end
	function facemc:addBtnIco(tar, buttons, txt, tx, ty, pico, act)
		local btn = add_bar("black_bar3", 28*scaleGraphics);
		-- local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		-- while(dtxt.width>btn.w-4*scaleGraphics and dtxt.size>4)do
			-- dtxt.size = dtxt.size-1;
		-- end
		local ico = display.newImage(btn, "image/buildings/"..pico..".png");
		ico:scale(scaleGraphics/2, scaleGraphics/2);
		tar:insert(btn);
		btn.x, btn.y = tx, ty;
		btn.act = act;
		-- table.insert(localGroup.buttons, btn);
		btn.hint = txt;
		table.insert(buttons, btn);
		elite.addOverOutBrightness(btn);
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		return btn;
	end

	-- function _G.addGfxByID(tar, tx, ty, id, scale, hue, saturation)
		-- local item_obj = art.byids[id];
		-- local mc = _G.addGfxEx(tar, tx, ty, item_obj.sprite_id, scale, hue, saturation);
		-- mc:setSequence(id);
		-- mc:play();
		-- return mc;
	-- end
	-- local specialmc = newGroup(facemc);
	-- local item_obj = game_art.links[_id];
	-- for item_obj,id in pairs(game_art.links) do
	
		-- print(item_obj, id);
		
		-- local tx, ty = 100, 100;
		-- addGfxByID(specialmc, tx, ty, id, scale, hue, saturation)
		-- local mc = _G.addGfxEx(specialmc, tx, ty, item_obj.sprite_id, scale, hue, saturation);
		-- mc:setSequence(id);
		-- mc:play();
	-- end
	
	-- local byids = game_art.byids;
	-- local i=1;
	-- for id,item_obj in pairs(game_art.byids) do
		-- print(item_obj, id, byids[id]);
		-- local tx, ty = 100*i, 100;
		-- while(tx>_W)do
			-- tx = tx - _W;
			-- ty = ty+50*scaleGraphics;
		-- end
		-- local mc = addGfxEx(specialmc, tx, ty, item_obj.sprite_id);
		-- mc:setSequence(id);
		-- mc:play();
		-- local dtxt = display.newText(specialmc, id, tx, ty+20*scaleGraphics, nil, 4*scaleGraphics);
		-- local item_obj = art.byids[id]
		-- if(game_art.byids[id])then
			-- local mc = addGfxByID(tar, tx, ty, id);
		-- end
		-- i = i+1;
	-- end
	
	localGroup.buttons = {};

	local avatarbg = newGroup(gamemc);
	local heroesmc = newGroup(gamemc);
	local units = {};

	local function start_game(hero_obj)
		login_ini(hero_obj);
		
		if(hero_obj.state == "hidden")then
			login_obj.sandbox = true;
		end
		
		royal:fillCardLoot();
		
		login_obj.rloot = {};
		-- for i=1,#relics do
			-- local robj = relics[i];
			-- if(robj.rarity>0 and robj.rarity<5)then
				-- table.insert(login_obj.rloot, relics[i].tag);
			-- end
		-- end
		-- table.shuffle(login_obj.rloot);
		-- table.shuffle(login_obj.rloot);
		-- login_obj.tags[lbl]
		
	
		
		for attr, val in pairs(login_obj.stats) do
			print(attr, attr:find("run_"), val);
			login_obj.stats[attr] = nil;
		end

		if(get_wins_by_classes()>2)then
			save_obj.act4 = true;
		end
		map_rebuild(1);
		-- show_map();
		
		local startupsTemp = table.clone(startups);
		local startupsNegative = {};
		for i=1,#startupsTemp do
			local startup = startupsTemp[i];
			startup.used = nil;
			if(startup.lvl<0)then
				table.insert(startupsNegative, startup);
			end
		end
		
		for i=1,#hero_obj.relics do
			-- login_obj.relics[hero_obj.relics[i]] = true;
			addRelic(hero_obj.relics[i]);
		end
		
		-- local event = {tag="Destiny", avatar="maid", actions={}};
		local event = {tag="Welcome", avatar="maid", actions={}};
		local actions = {};
		local function curseEvent(obj)
			local startup = table.random(startupsNegative);
			while((obj.transform and startup.card) or (obj.removecard and startup.card) or (obj.hpmax and startup.hpmax) or (obj.money and startup.moneylose) or startup.used or startup.lvl~=-obj.lvl)do
				startup = table.random(startupsNegative);
			end
			
			for attr,val in pairs(startup) do
				-- print("",'curse:', attr, val)
				if(obj[attr]==nil)then
					obj[attr] = val;
				else
					obj[attr] = obj[attr] + val;
				end
			end
			startup.used = true;
		end
		local function addEventObj(startup)
			local obj = {txt="["..(#actions+1).."]"};
			for attr,val in pairs(startup) do
				-- print("",'add:', attr, val);
				obj[attr] = val;
			end
			return obj
		end
		local function addEventOption(lvl)
			local startup = table.random(startupsTemp);
			while(startup.lvl~=lvl or startup.used)do
				startup = table.random(startupsTemp);
			end
			print('new:', lvl, startup.lvl);
			
			local obj = addEventObj(startup);
			while(obj.lvl>0)do
				print("",'rmv:', obj.txt, obj.lvl);
				curseEvent(obj);
			end
			table.insert(actions, obj);
			startup.used = true;
		end

		addEventOption(0);
		addEventOption(0);
		-- addEventOption(0);
		addEventOption(1);
		addEventOption(1);
		addEventOption(math.random(1,2));
		
		table.insert(actions, {txt="[Back]", actions=event.actions});
		
		local lvl = getLoginStat(hero_obj.class.."_lvl");

		table.insert(event.actions, {txt="[Standard]".." "..get_txt('mode_standart_hint'), actions=actions});
		
		local mods = {};
		local daily_mods = {};
		local proceed_daily_obj = {txt="[Proceed]", actions=daily_mods, disabled=true, hint=get_txt('loading')};
		table.insert(mods, proceed_daily_obj);
		table.insert(mods, {txt="[Back]", actions=event.actions});
		
		local obj = {txt="[Daily Climb]".." "..get_txt('mode_daily_hint'), actions=mods};
		if(lvl<1)then
			obj.disabled = true;
			obj.hint = get_txt("not_enought_val");
			obj.hint = obj.hint:gsub("VAL", get_txt("xp"));
		end
		table.insert(event.actions, obj);
		
		local obj = {ascend=true, txt="["..get_txt('ascend').."] "..get_txt("ascend_hint")};
		if(save_obj.act4~=true)then
			obj.disabled = true;
			obj.hint = get_txt('act4_is_locked');
		elseif(lvl<3)then
			obj.disabled = true;
			obj.hint = get_txt("not_enought_val");
			obj.hint = obj.hint:gsub("VAL", get_txt("xp"));
		end
		table.insert(event.actions, obj);
		
		local custom_obj = {txt="[Custom]".." "..get_txt('mode_custom_hint'), disabled=true, cheat=true, actions={}, hint=get_txt("under_construction")};
		table.insert(event.actions, custom_obj);
		for j=1,#royal.customs do
			local mod = table.cloneByAttr(royal.customs[j]);
			mod.txt = "["..mod.tag.."]";
			if(math.random()>0.5)then
				table.insert(custom_obj.actions, mod);
			end
		end
		table.insert(custom_obj.actions, {txt="[Back]", actions=event.actions});
		
		local obj = {sandbox=true, txt="["..get_txt('sandbox').."] "..get_txt("sandbox_hint")};
		if(lvl<2)then
			obj.disabled = true;
			obj.hint = get_txt("not_enought_val");
			obj.hint = obj.hint:gsub("VAL", get_txt("xp"));
		end
		table.insert(event.actions, obj);
		-- table.insert(event.actions, {txt="[Back]", callback=show_start});
		
		show_event(nil, event);

		-- function director:onLoad()
			-- director.onLoad = nil;
			-- local bgi = 14;
			-- local bg = add_bg_title("bg_3", 400*scaleGraphics, bgi*14*scaleGraphics + 26*scaleGraphics, get_txt('scores'));
			-- bg.x, bg.y = _W/2, _H/2;
			-- extramc:insert(bg);
			-- require("src.injectScores").inject(extramc, bg, localGroup.buttons);
			-- extramc:fetchQuery('?orderBy="score"&limitToLast=300', "score", {attr="class", val=hero_obj.class});
		-- end
		
		if(royal.db==nil)then
			local firebase = require('firebase');
			royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
		end
			
		function localGroup:getDailyMods(ordinalDate)
			royal.db:get("daily/"..ordinalDate.."/mods", query, function(event)
				if(event.isError)then
					print("Network error!");
				else
					local data_obj = json.decode(event.response);
					print("response:", event.response, data_obj);
					if(data_obj)then
						saveFile('daily_mods.json', json.encode({['date']=ordinalDate, mods=data_obj}));
						localGroup:checkDailyMods(ordinalDate);
						if(localGroup.parent)then
							show_msg('daily mods loaded');
						end
					else
						local new_mods = {};
						for i=3,5 do
							local list = {};
							for j=1,#royal.customs do
								local mod = royal.customs[j];
								if(mod.ctype==i)then
									table.insert(list, mod);
								end
							end
							local mod = table.random(list);
							-- mod.disabled = true;
							-- mod.txt = "["..mod.tag.."]";
							table.insert(new_mods, mod);
						end
						
						royal.db:put("daily/"..ordinalDate.."/mods", json.encode(new_mods), nil, function(event)					
							if(event.isError)then
								print("Network error!");
							else
								print("put:", event.response)
								localGroup:checkDailyMods(ordinalDate);
							end
						end);

						
					end
				end
			end);
		end
		
		function localGroup:checkDailyMods(ordinalDate)
			local loaded_mods;
			local fname = 'daily_mods.json';
			local cashed_str = loadFile(fname);
			if(cashed_str)then
				local cashed_json = json.decode(cashed_str);
				if(cashed_json)then
					if(cashed_json.date == ordinalDate)then
						loaded_mods = cashed_json.mods;
					else
						elite.removeFile(fname);
					end
				end
			end

			if(loaded_mods)then
				local recursion = daily_mods;
				for i=1,#loaded_mods do
					local mod = table.cloneByAttr(loaded_mods[i]);
					mod._ordinaldate = ordinalDate;
					mod.daily = true;
					table.insert(recursion, mod);
					if(i~=#loaded_mods)then
						mod.actions = {};
						recursion = mod.actions;
					end
					print('daily_mods:', #daily_mods);
					
					local mod = table.cloneByAttr(loaded_mods[i]);
					mod.disabled = true;
					mod.txt = "["..mod.tag.."]";
					table.insert(mods, 1, mod);
				end
				if(#loaded_mods>0)then
					proceed_daily_obj.disabled = nil;
					proceed_daily_obj.hint = nil;
				end
			else
				localGroup:getDailyMods(ordinalDate);
			end
		end
		
		network.request("http://worldclockapi.com/api/json/utc/now", nil, function(e)
			print(e, e.response)
			local server_time_obj = json.decode(e.response);
			if(server_time_obj)then
				local ordinalDate = server_time_obj.ordinalDate;
				print('json2:', ordinalDate, server_time_obj.ordinalDate, currentFileTime);
				mainGroup.ordinalDate = ordinalDate;
				mainGroup.currentFileTime = currentFileTime;
				localGroup:checkDailyMods(ordinalDate);
			end
		end);
	end
	
	local function onBack(e)
		if(avatarbg.numChildren and avatarbg.numChildren>0)then
			cleanGroup(avatarbg);
		else
			show_menu();
		end
	end
	-- local gomc = facemc:addBtn(facemc, localGroup.buttons, '<<<', 30*scaleGraphics, _H-60*scaleGraphics, function()
		-- if(avatarbg.numChildren>0)then
			-- cleanGroup(avatarbg);
		-- else
			-- show_menu();
		-- end
	-- end);
	
	localGroup.sequences = 0;
	function localGroup:addLockAnimation(tarmc, ico)
		-- if(login_obj_get_item_lvl("locks_"..tarmc.utype)>0)then
			-- return
		-- end
		-- login_obj_add_item_lvl("locks_"..tarmc.utype);
		if(tarmc.insert==nil)then
			return
		end
		
		local delay = localGroup.sequences * 200;
		ico.alpha = 0;
		--transition.to(fade_out, {time=200, alpha=0, transition=easing.inQuad, onComplete=transitionRemoveSelfHandler});
		local animc = newGroup(tarmc);
		animc:scale(scaleGraphics/2, scaleGraphics/2);

		local top = display.newImage(animc, "image/map/lock_top.png"); -- 56*82   17*27
		local body =display.newImage(animc, "image/map/lock_body.png");
		
		top.anchorX,top.anchorY = 17/56,27/82;
		top.x, top.y = -top.anchorX*top.width/2, -top.anchorY*top.height/2;
		transition.to(top, {delay=delay+200, time=1000, rotation=-80, transition=easing.outQuad});
		
		body.anchorX,body.anchorY = 17/56,27/82;
		body.x, body.y = -body.anchorX*body.width/2, -body.anchorY*body.height/2;
		transition.to(body, {delay=delay+200, time=1000, rotation=20, transition=easing.outQuad});
		
		transition.to(animc, {delay=delay+900, time=900, y=100*scaleGraphics, alpha=0, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
		transition.to(ico, {delay=delay+800, time=800, alpha=1, transition=easing.inQuad, onComplete=function() localGroup.sequences=0; end});
		localGroup.sequences = localGroup.sequences+1;
	end
	
	local function addRoaylBtn(tx, ty, hint, act, img, scale)
		local btn = newGroup(facemc);
		btn:translate(tx, ty);
		local img = display.newImage(btn, img);
		if(scale==nil)then scale=1; end
		img:scale(scale*scaleGraphics/2, scale*scaleGraphics/2);
		
		btn.hint = get_txt(hint);
		btn.act = act;
		elite.addOverOutBrightness(btn, img);
		
		-- btn.w, btn.h = 140*scaleGraphics, 90*scaleGraphics;
		btn.w, btn.h = img.contentWidth, img.contentHeight;
		table.insert(localGroup.buttons, btn);
		return btn, img;
	end
	
	local btn = addRoaylBtn(_W - 20*scaleGraphics, 20*scaleGraphics, "exit", onBack, "image/button/cancel.png");
	function btn:disabled()
		return facemc.wnd~=nil;
	end
	
	local heroes_l = 0;
	for i=1,#heroes do
		local hero_obj = heroes[i];
		if(hero_obj.state ~= "hidden" or save_obj.show_hidden_heroes)then
			heroes_l = heroes_l+1;
		end
	end
	
	
	local thisScale = scaleGraphics;
	thisScale = math.min(math.floor((_W-50*scaleGraphics)/heroes_l/40), scaleGraphics);
	
	local chains_h = 30*thisScale;
	
	local heads = {};
	local all_locked = true;
	for i=1,#heroes do
		local hero_obj = heroes[i];
		local unlocked = save_obj.unlocks['hero_'..hero_obj.class];
		if(unlocked)then
			all_locked = false;
		end
	end
	
	if(all_locked)then
		local function unlock_all()
			for i=1,#heads do
				local mc = heads[i];
				mc:unlock();
			end
		end
	
		
		-- if(#tutorials==0)then
		while(#tutorials>0) do
			table.remove(tutorials, 1);
		end
		table.insert(tutorials, {title="welcome", callback=unlock_all});
		table.insert(tutorials, {title="welcome", high="start_hero_1"});
		-- end
		-- tutorials:scale(scaleGraphics/2);
		tutorials:restep();
		tutorials:setScene(localGroup);
		tutorials:step();
	end
	
	
	
	for i=1,#heroes do
		local hero_obj = heroes[i];
		if(hero_obj.state ~= "hidden" or save_obj.show_hidden_heroes)then
		local mc = newGroup(heroesmc);
		mc.x, mc.y = _W/2 + 40*(i-heroes_l/2-0.5)*thisScale, chains_h;
		local scin = hero_obj.scin;
		links["start_hero_"..i] = mc;
		table.insert(heads, mc);
		
		elite:add_chains_h(heroesmc, "gui/chain4", mc.x-8*thisScale, -3*thisScale, chains_h, 1);
		elite:add_chains_h(heroesmc, "gui/chain4", mc.x+8*thisScale, -3*thisScale, chains_h, 1);
		
		local mcbg = add_bar("black_bar", 28*thisScale, thisScale/2);
		mc:insert(mcbg);
		
		local headmc = newGroup(mc);
		pixelArtOn();
		local head = display.newImage(headmc, "image/heads/"..scin..".png");
		head:scale(thisScale/2, thisScale/2);
		mc.head = head;
		pixelArtOff();
		
		local lockico;
		
		function mc:unlock()
			head.isVisible = true;
			localGroup:addLockAnimation(mc, headmc);
			if(lockico)then
				if(lockico.removeSelf)then
					lockico:removeSelf();
				end
				lockico = nil;
			end
			mc.disabled = false;
		end
		function mc:lock()
			head.isVisible = false;
			lockico = display.newImage(mc, "image/map/lock.png");
			lockico:scale(thisScale/2, thisScale/2);
			if(all_locked)then
				mc.disabled = true;
			end
		end
		
		pixelArtOn();
		local unlocked = save_obj.unlocks['hero_'..hero_obj.class];
		if(unlocked)then
			if(hero_obj.state ~= "done")then
				local ico = display.newImage(headmc, "image/indevelopment.png", 8*thisScale, -8*thisScale);
				ico:scale(thisScale/3, thisScale/3);
			end
			
			mc:unlock();
		else
			mc:lock();
		end
		pixelArtOff();

		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = 32*thisScale, 32*thisScale;
		elite.addOverOutBrightness(mc, mcbg);
		function mc:disabled()
			return facemc.wnd~=nil;
		end
		-- function mc:onOver()
			-- mc.parent:insert(mc);

			-- transition.cancel(body)
			-- transition.to(body, {time=300, xScale=1.4, yScale=1.4, y=-32*scaleGraphics, transition=easing.outQuad, onComplete=function(obj)
			-- end});
		-- end
		-- function mc:onOut()
			-- transition.cancel(body)
			-- transition.to(body, {time=200, xScale=1, yScale=1, y=0, transition=easing.inQuad});
		-- end
		
		function mc:act()
			tutorials:done("welcome");
			
			-- if(save_obj.show_hidden_heroes)then
				-- royal:downloadTempCards(hero_obj.class);
			-- end
			
			if(options_adult)then
				cleanGroup(avatarbg);
				
				-- local sepia = display.newImage(avatarbg, "image/sepia/"..scin..".jpg");
				-- if(sepia)then sepia:scale(scaleGraphics*1, scaleGraphics*1); end
				-- if(sepia)then sepia.height = _H; end
				-- sepia.x, sepia.y = _W - 100*scaleGraphics, _H/2;
				
				local avatar = display.newImage(avatarbg, "image/avatars/"..scin..".png");
				if(avatar)then
					avatar:scale(scaleGraphics*0.50, scaleGraphics*0.50);
					avatar.x, avatar.y = _W*1/4, _H - avatar.contentHeight/2 + 0*50*scaleGraphics; -- 50*scaleGraphics
					transitionBlink(avatar, 0.2);
				end
				
				table.insert(localGroup.buttons, avatar);
				avatar.w, avatar.h = avatar.contentWidth, avatar.contentHeight;
				-- elite.addOverOutBrightness(avatar);
				if(options_cheats)then
					avatar.act = function()
						if(facemc.wnd==nil)then
							director:changeScene({scin=hero_obj.scin, class=hero_obj.class}, 'src.screenHeroPromo');
						end
					end
				end
				
			end

			local thisX = math.min(_W*3/4, _W-150*scaleGraphics);
			mainGroup.hero_obj = hero_obj;
			if(unlocked)then
				local save_file = loadFile("save_"..hero_obj.class..".json");
				local continue = save_file~=nil;
				if(save_file)then
					_G.login_obj = json.decode(save_file);
					if(login_obj)then
						if(login_obj.dead)then
							continue = false;
						end
					end
				end
				
				local gomc2 = facemc:addBtn(avatarbg, localGroup.buttons, get_txt('continue'), thisX-22*scaleGraphics, minY, function()
					show_map();
				end);

				if(continue)then
					local gomc1 = facemc:addBtn(avatarbg, localGroup.buttons, get_txt('restart'), thisX-94*scaleGraphics, minY, function()
						local txt_arr = {};
						table.insert(txt_arr, get_txt('restart'));
						table.insert(txt_arr, get_txt('question_restart'));
						local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
							start_game(hero_obj);
						end, function()
							
						end);
						
						
					end);
					gomc2.hint = get_txt("cards")..": "..#login_obj.deck..", "..get_txt("act")..": "..login_obj.map.lvl;
					print("fa:", login_obj.daily, login_obj._ordinaldate);
					if(login_obj.daily and login_obj._ordinaldate)then
						gomc2.hint = gomc2.hint..", "..get_txt('daily')..": "..login_obj._ordinaldate;
					end
				else
					local gomc1 = facemc:addBtn(avatarbg, localGroup.buttons, get_txt('start'), thisX-94*scaleGraphics, minY, function()
						start_game(hero_obj);
					end);
				
					elite.setDisabled(gomc2, true);
					gomc2.disabled = true;
				end
				
				local custom;
				custom = facemc:addBtnIco(avatarbg, localGroup.buttons, get_txt('customization'), thisX + 32*scaleGraphics, minY, "customization", function()
					local extramc = newGroup(facemc);
					facemc.wnd = extramc;
					
					local rect = display.newRect(extramc, _W/2, _H/2, _W, _H);
					rect:setFillColor(0, 0, 0, 0.85);
					
					local function addOption(tar, tx, ty, pimg, act)
						local btn = display.newImage(tar, pimg, tx, ty);
						btn:scale(scaleGraphics/2, scaleGraphics/2);
						elite.addOverOutBrightness(btn);
						btn.w, btn.h = btn.contentWidth, btn.contentHeight;
						table.insert(localGroup.buttons, btn);
						btn.act = act;
						return btn;
					end
					function extramc:closeMe()
						extramc:removeSelf();
						facemc.wnd = nil;
					end
					addOption(extramc, _W - 20*scaleGraphics, 20*scaleGraphics, "image/button/cancel.png", function()
						extramc:closeMe();
					end);
					
					if(save_obj['custom_scin_'..hero_obj.class.."_set"]==nil)then
						save_obj['custom_scin_'..hero_obj.class.."_set"] = 1;
					end
					local set_id = save_obj['custom_scin_'..hero_obj.class.."_set"];
					
					local scin = save_obj['custom_scin_'..hero_obj.class.."_val"..set_id] or hero_obj.scin;
					local mcbg = add_bg_title("bg_3", 500*scaleGraphics, 220*scaleGraphics, get_txt('customization'));
					mcbg.x, mcbg.y = _W/2, _H/2;
					extramc:insert(mcbg);

					local cardmc = newGroup(mcbg);
					cardmc.x, cardmc.y = -180*scaleGraphics, 0;
					local card = display.newImage(cardmc, "image/cards_back.png");
					if(card)then card:scale(scaleGraphics/2, scaleGraphics/2); end
					local card = display.newImage(cardmc, "image/sepia/"..hero_obj.scin..".jpg");
					if(card)then card:scale(scaleGraphics/2, scaleGraphics/2); end
					local card = display.newImage(cardmc, "image/cards_front_3.png");
					if(card)then card:scale(scaleGraphics/2, scaleGraphics/2); end
					
					local typemc = display.newImage(cardmc, "image/heads/"..hero_obj.scin..".png");
					if(typemc)then
						typemc.y = 67*scaleGraphics;
						typemc:scale(scaleGraphics/2, scaleGraphics/2);
					end
					
					local selmc = display.newImage(mcbg, "image/floor_test2.png", 99999, 0);
					selmc:scale(scaleGraphics/1, scaleGraphics/1);
					function selmc:deslect(ext)
						for i=1,#units do
							local unit=units[i];
							if(unit.parent)then
								unit:setAct('idle');
							end
						end
					end

					local barsmc = newGroup(mcbg);
					local skins = {};
					local function addUnit(scin, tx, ty)
						pixelArtOn();
						local unit = require("objUnit").new(scin, 1, {}, localGroup.buttons);
						unit:translate(tx, ty);
						unit:scale(scaleGraphics/1, scaleGraphics/1);
						mcbg:insert(unit);
						unit:setAct('idle');
						unit:setDir(10, 10);
						unit:clearStatuses();
						pixelArtOff();
						table.insert(skins, unit);
						
						-- save_obj['custom_scin_'..hero_obj.class.."_val"] = scin;
						-- save_obj['custom_scin_'..hero_obj.class.."_filters"] = filters;
						-- save_obj['custom_scin_'..hero_obj.class.."_cards"] = custom_cards;
						-- if(save_obj['custom_scin_'..hero_obj.class.."_filters"])then
							-- unit:applyFilters(save_obj['custom_scin_'..hero_obj.class.."_filters"]);
						-- end
						
						function unit:act()
							selmc.x, selmc.y = unit.x, unit.y;
							selmc:deslect(unit);
							unit.isVisible = true;
							unit:setAct('go');
							unit:showOptions();
						end
						unit.w, unit.h = unit.contentWidth, unit.contentHeight;
						table.insert(localGroup.buttons, unit);
						table.insert(units, unit);
						
						local effectEliteHue = {tag="hue", 					name="filter.custom.eliteMulti",	prm1="hue", prm2="angle", min=0, max=360, val=20, def=0};
						local effectEliteSaturation = {tag="saturation",	name="filter.custom.eliteMulti",	prm1="saturate", prm2="intensity", min=0, max=8, val=0.2, def=1};
						local effectEliteBrightness = {tag="brightness",	name="filter.custom.eliteMulti",	prm1="brightness",	prm2="intensity",	min=-1, max=1, val=0.05, def=1};
							
						local effects = {};
						table.insert(effects, effectEliteHue);
						table.insert(effects, effectEliteSaturation);
						table.insert(effects, effectEliteBrightness);
						function unit:showOptions()
							while(barsmc.numChildren>0)do
								barsmc[1]:removeSelf();
							end
							
							local barw = 60*scaleGraphics;
							local deltaX = -20;
							local sprites = unit:getSprites();
							
							function sprites:save()
								local filters = {};
								local custom_cards = {};
								for i=1,#sprites do
									local item = sprites[i];
									local body_mc = item.mc;
									if(body_mc.fill.effect)then
										filters[item.id] = {};
										for j=1,#effects do
											local effect = effects[j];
											filters[item.id][j] = {prm1=effect.prm1, prm2=effect.prm2, val=body_mc.fill.effect[effect.prm1][effect.prm2]};
											if(item.id=="cards")then
												custom_cards[effect.prm1] = body_mc.fill.effect[effect.prm1][effect.prm2];
											end
										end
									end
								end
								save_obj['custom_scin_'..hero_obj.class.."_val"..set_id] = scin;
								save_obj['custom_scin_'..hero_obj.class.."_filters"..set_id] = filters;
								save_obj['custom_scin_'..hero_obj.class.."_cards"..set_id] = custom_cards;
							end
								
							local function add_part_bar(body_name, body_mc, vx, vy, effect)
								local bar_mc = newGroup(barsmc);
								bar_mc.x, bar_mc.y = deltaX*scaleGraphics + vx*(barw+40*scaleGraphics), -60*scaleGraphics+18*scaleGraphics*(vy-1);
								local p = 0.01;
								local barbot = add_bar("bar_xp2", barw*p);
								barbot.x = -(barw - barw*p)/2;
								bar_mc:insert(barbot);
								local bartop = add_bar("bar_xp1", barw);
								bar_mc:insert(bartop);
								local dtxt1 = display.newText(bar_mc, "", 0, 0, fontMain, 10*scaleGraphics);
								
								if(save_obj['custom_scin_'..hero_obj.class.."_filters"..set_id])then
									local this_filters = save_obj['custom_scin_'..hero_obj.class.."_filters"..set_id];
									-- print(this_filters);
									if(this_filters)then
										-- print(body_name, effect.tag, effect.prm1, effect.prm2, this_filters[body_name]);
										if(this_filters[body_name])then
											-- print(this_filters[body_name][effect.prm1])
											for attr,val in pairs(this_filters[body_name]) do
												-- print("", attr, val);
												for attr2,val2 in pairs(val) do
													-- print("", "", attr2, val2);
													if(val.prm1 == effect.prm1)then
														dtxt1.text = math.round(val.val*100)/100;
														break;
													end
												end
											end
											if(this_filters[body_name][effect.prm1])then
												print(this_filters[body_name][effect.prm1][effect.prm2])
											end
										end
									end
								end
								
								local function effectChange(e)
									-- print("effectChange:", body_name, _G.save_obj.donation);
									-- _G.save_obj.donation
									if(e.phase=='ended')then
										if(body_mc.fill.effect==nil)then
											body_mc.fill.effect = effect.name;
											
											if(effect.dstuff)then
												for k,v in pairs(effect.dstuff) do
													body_mc.fill.effect[k]=v;
												end
											end

											if(effect.defi)then
												body_mc.fill.effect[effect.prm] = effect.defi;
											else
												if(effect.prm1)then
													body_mc.fill.effect[effect.prm1][effect.prm2] = effect.def;
												else
													body_mc.fill.effect[effect.prm] = effect.def;
												end
											end
										end
										
										local current_val;
										if(effect.i)then 
											current_val = effect.defi[effect.i];
										else
											if(effect.prm)then
												current_val = body_mc.fill.effect[effect.prm];
											else
												current_val = body_mc.fill.effect[effect.prm1][effect.prm2];
											end
										end
										if(current_val)then
											current_val = current_val + e.target.i*effect.val;
											if(current_val>effect.max)then current_val=effect.max; end
											if(current_val<effect.min)then current_val=effect.min; end
											
											if(effect.i)then 
												effect.defi[effect.i] = current_val;
												body_mc.fill.effect[effect.prm] = effect.defi;
											else
												if(effect.prm)then
													body_mc.fill.effect[effect.prm] = current_val;
												else
													body_mc.fill.effect[effect.prm1][effect.prm2] = current_val;
												end
											end
											p = (current_val-effect.min)/(effect.max-effect.min);
											barbot:removeSelf();
											barbot = add_bar("bar_xp2", barw*p);
											barbot.x = -(barw - barw*p)/2;
											bar_mc:insert(1, barbot);
											dtxt1.text = math.floor(current_val*100)/100;
											
											unit:setAct('go');
										end
										
										sprites:save();
										
										return true
									end
								end
								
								local btn = display.newImage(bar_mc, "image/gui/btnMinus.png");
								btn.i=-1;
								btn.x, btn.y = -6*scaleGraphics-barw/2, 0;
								btn.xScale, btn.yScale = scaleGraphics/2, scaleGraphics/2;
								btn:addEventListener("touch", effectChange);
								
								local btn = display.newImage(bar_mc, "image/gui/btnPlus.png");
								btn.i=1;
								btn.x, btn.y = 6*scaleGraphics+barw/2, 0;
								btn.xScale, btn.yScale = scaleGraphics/2, scaleGraphics/2;
								btn:addEventListener("touch", effectChange);
								
								return bar_mc
							end
							
							table.insert(sprites, 1, {id="cards", mc=card, brightness=false});
							
							for i=1,#sprites do
								local item = sprites[i];
								for j=1,#effects do
									local barY = -60*scaleGraphics+18*scaleGraphics*(i-1);
									if(effects[j].tag~="brightness" or item.brightness~=false)then
										local bar = add_part_bar(item.id, item.mc, j-1, i, effects[j]);
									end
									if(i==1)then
										local dtxt2 = display.newText(barsmc, get_txt(effects[j].tag), deltaX*scaleGraphics - 100*scaleGraphics + (barw+40*scaleGraphics)*j, barY-20*scaleGraphics, fontMain, 12*scaleGraphics);
									end
									if(j==1)then
										local dtxt2 = display.newText(barsmc, get_txt(item.id)..":", deltaX*scaleGraphics-50*scaleGraphics, barY, fontMain, 12*scaleGraphics);
										dtxt2.anchorX = 1;
									end
								end
							end
							
							local bigBtnY = 94*scaleGraphics;
							local function addBigBtn(tar, tx, ty, tw, txt, act, pico)
								local btn = newGroup(tar);
								btn:translate(tx, ty);
								local btnbg = add_bar("black_bar3", tw);
								btn:insert(btnbg);
								-- btnbg:scale(scaleGraphics/2, scaleGraphics/2);
								local dtxt = display.newText(btn, txt, 10*scaleGraphics, 0, fontMain, 12*scaleGraphics);
								btn.dtxt = dtxt;
								elite.addOverOutBrightness(btn, btnbg);
								btn.w, btn.h = btnbg.contentWidth, btnbg.contentHeight;
								table.insert(localGroup.buttons, btn);
								btn.act = act;
								if(pico)then
									local ico = display.newImage(btn, pico);
									ico:scale(scaleGraphics/2, scaleGraphics/2);
									btn.ico = ico;
								end
								return btn;
							end
							
							local btn = addBigBtn(barsmc, 110*scaleGraphics, bigBtnY, 80*scaleGraphics, get_txt("reset"), function()
								save_obj['custom_scin_'..hero_obj.class.."_val"..set_id] = nil;
								save_obj['custom_scin_'..hero_obj.class.."_filters"..set_id] = nil;
								save_obj['custom_scin_'..hero_obj.class.."_cards"..set_id] = nil;
								extramc:closeMe();
							end);
							local ico = display.newImage(btn, "image/button/refresh.png", -30*scaleGraphics, 0);
							ico:scale(scaleGraphics/2, scaleGraphics/2);
							
							local cost = 2;
							local btn = addBigBtn(barsmc,  200*scaleGraphics, bigBtnY, 80*scaleGraphics, get_txt("ok"), function()
								if(save_obj.unlocks['scin_'..scin]~=true)then
									if(save_obj.diamonds < cost)then
										tryToBuyDiamonds()
										return
									end
									save_obj.diamonds = save_obj.diamonds - cost;
									save_obj.unlocks['scin_'..scin] = true;
								end
					
								sprites:save();
								
								extramc:closeMe();
							end);
							local ico = display.newImage(btn, "image/button/ok.png", -30*scaleGraphics, 0);
							ico:scale(scaleGraphics/2, scaleGraphics/2);
							if(save_obj.unlocks['scin_'..scin]~=true)then
								ico:removeSelf();
								btn.dtxt.text = get_txt('unlock');
								btn.dtxt.x = 14*scaleGraphics;
								
								local group = newGroup(btn);
								group.x, group.y = -20*scaleGraphics, 0;
								local ico = royal.add_glow(group, "image/map/diamond.png", 2, {0,0,0});
								ico:scale(scaleGraphics/2, scaleGraphics/2);
								local ico = display.newImage(group, "image/map/diamond.png");
								ico:scale(scaleGraphics/2, scaleGraphics/2);
								
								local group = newGroup(btn);
								group.x, group.y = -28*scaleGraphics, 0;
								local ico = royal.add_glow(group, "image/map/diamond.png", 2, {0,0,0});
								ico:scale(scaleGraphics/2, scaleGraphics/2);
								local ico = display.newImage(group, "image/map/diamond.png");
								ico:scale(scaleGraphics/2, scaleGraphics/2);								
							end

							function barsmc:refresh()
								set_id = save_obj['custom_scin_'..hero_obj.class.."_set"];
								for i=1,3 do
									local btn = barsmc['btn'..i];
									if(btn.ico)then
										if(set_id==i)then
											btn.ico.fill.effect = nil;
											btn.ico.alpha = 1;
										else
											btn.ico.fill.effect = "filter.grayscale";
											btn.ico.alpha = 0.7;
										end
									end
								end
								
								if(save_obj['custom_scin_'..hero_obj.class.."_filters"..set_id])then
									unit:applyFilters(save_obj['custom_scin_'..hero_obj.class.."_filters"..set_id]);
								else
									-- unit:applyFilters({});
									unit:removeFilters()
								end
							end
							
							barsmc.btn1 = addBigBtn(barsmc,  -(180+34)*scaleGraphics, bigBtnY, 34*scaleGraphics, "", function()
								save_obj['custom_scin_'..hero_obj.class.."_set"] = 1;
								barsmc:refresh();
							end, "image/buildings/set1.png");
							barsmc.btn2 = addBigBtn(barsmc,  -180*scaleGraphics, bigBtnY, 34*scaleGraphics, "", function()
								save_obj['custom_scin_'..hero_obj.class.."_set"] = 2;
								barsmc:refresh();
							end, "image/buildings/set2.png");
							barsmc.btn3 = addBigBtn(barsmc,  -(180-34)*scaleGraphics, bigBtnY, 34*scaleGraphics, "", function()
								save_obj['custom_scin_'..hero_obj.class.."_set"] = 3;
								barsmc:refresh();
							end, "image/buildings/set3.png");
							barsmc:refresh();
							
						end
					end

					addUnit(scin, -180*scaleGraphics, 0);
					addUnit(hero_obj.scin2 or "warrior", -180*scaleGraphics, 0);
					
					for i=1,#skins do
						skins[i].isVisible = false;
					end
					skins[1]:act();
					
					local function addScrBtn(tar, tx, ty, path, act)
						local btn = newGroup(tar);
						btn:translate(tx, ty);
						local ico = display.newImage(btn, path);
						ico:scale(scaleGraphics/2, scaleGraphics/2);
						elite.addOverOutBrightness(btn);
						btn.w, btn.h = ico.contentWidth, ico.contentHeight;
						table.insert(localGroup.buttons, btn);
						btn.act = act;
						return btn;
					end
					
					local si = 1;
					addScrBtn(mcbg, -210*scaleGraphics, 0, "image/button/back.png", function()
						for i=1,#skins do
							skins[i].isVisible = false;
						end
						si = si-1;
						if(si<1)then si=#skins; end
						skins[si]:act();
						skins[si].isVisible = true;
					end);
					addScrBtn(mcbg, -150*scaleGraphics, 0, "image/button/next.png", function()
						for i=1,#skins do
							skins[i].isVisible = false;
						end
						si = si+1;
						if(si>#skins)then si=1; end
						skins[si]:act();
						skins[si].isVisible = true;
					end);
					
				end);
				
				local book;
				book = facemc:addBtnIco(avatarbg, localGroup.buttons, get_txt('library'), thisX + 62*scaleGraphics, minY, "library", function()
					local class = hero_obj.class;
					local extramc = newGroup(facemc);
					facemc.wnd = extramc;
					
					local list = {};
					for i=1,#cards do
						if(cards[i].class==class)then
							table.insert(list, cards[i]);
						end
					end
					
					local listmc = showCardPick(extramc, localGroup.buttons, book.x, book.y, list, false, false, function(new_card, mc)
						facemc.wnd = nil;
					end);
					
					local btn = display.newImage(extramc, "image/button/cancel.png", _W - 20*scaleGraphics, 20*scaleGraphics);
					btn:scale(scaleGraphics/2, scaleGraphics/2);
					elite.addOverOutBrightness(btn);
					btn.w, btn.h = btn.contentWidth, btn.contentHeight;
					table.insert(localGroup.buttons, btn);
					btn.act = function()
						extramc:removeSelf();
						facemc.wnd = nil;
					end
					-- print("_cardsmc:", listmc, type(listmc)=="table")
					if(listmc and type(listmc)=="table")then
						local cardsmc = listmc.cards;
						for i=1,cardsmc.numChildren do
							local mc = cardsmc[i];
							if(mc.card_obj)then
								local id = get_name_id(mc.card_obj.tag);
								if(save_obj.unlocks['card_'..id]~=2 and options_cheats~=true)then
									mc.ntxt:setText(get_txt('unknown'));
									mc.dtxt.text = "?????";
									function mc:update()
										mc.ntxt:setTextColor(mc.ntxt.c[1], mc.ntxt.c[2], mc.ntxt.c[3]);
									end
									function mc:showExtraHints()
									end
									function mc:updateTitleText()
									end
								else
									function mc:act()
										if(mc.umc)then
											mc.umc:removeSelf();
											mc.umc = nil;
										else
											local uobj = table.cloneByAttr(mc.card_obj);
											upgradeCard(uobj);
											local umc, ubody = createCardMC(cardsmc, uobj);
											umc.x, umc.y = mc.x, mc.y;
											ubody.xScale, ubody.yScale = 1/2, 1/2;
											umc.xScale, umc.yScale = 2, 2;
											mc.umc = umc;
										end
									end
								end
							end
							-- save_obj.unlocks['card_'..get_name_id(card_obj.tag)]
						end
					end
				end);
				
				local chest;
				chest = facemc:addBtnIco(avatarbg, localGroup.buttons, get_txt('items'), thisX + 92*scaleGraphics, minY, "items", function()
					local extramc = newGroup(facemc);
					facemc.wnd = extramc;
					
					local rect = display.newRect(extramc, _W/2, _H/2, _W, _H);
					rect:setFillColor(0, 0, 0, 0.85);
					
					local btn = display.newImage(extramc, "image/button/cancel.png", _W - 20*scaleGraphics, 20*scaleGraphics);
					btn:scale(scaleGraphics/2, scaleGraphics/2);
					elite.addOverOutBrightness(btn);
					btn.w, btn.h = btn.contentWidth, btn.contentHeight;
					table.insert(localGroup.buttons, btn);
					btn.act = function()
						extramc:removeSelf();
						facemc.wnd = nil;
					end
					
					local contentmc = newGroup(extramc);
					local relicsmc = newGroup(contentmc);
					local rowD = 20*scaleGraphics;
					local itemW = 34*scaleGraphics;
					local itemH = 62*scaleGraphics;
					-- local rows = math.floor((_W - rowD*2)/(itemW))+1;
					
					do
						local tx, ty = 0, 0;
						local function touchHandler(e)
							if(e.phase=='began')then
								tx, ty = e.x, e.y;
							elseif(e.phase=='moved')then
								local dx, dy = e.x-tx, e.y-ty;
								contentmc:translate(0, dy);
								tx, ty = e.x, e.y;
							end
						end
						rect:addEventListener('touch', touchHandler);
						
						elite.setScrollable(contentmc);
					end
					
					local dtxt = newOutlinedText(contentmc, "items: "..#relics, _W/2, 22*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
					-- if(login_obj.tags)then
						-- local tags = table.keys(login_obj.tags);
						-- dtxt:setText("relics: "..#relics..", tags: "..table.concat(tags, ", "));
					-- end

					local relic1txt = newOutlinedText(contentmc, "", 0, 100*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
					relic1txt:setTextColor(237/255, 198/255, 80/255);
					local relic2txt = newOutlinedText(contentmc, "", 0, 116*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
				
					-- local j=0;
					local tx, ty = rowD, 90*scaleGraphics;
					-- local nativetxt = newGroup(contentmc);
					
					local function showItems(rarity)
						for i=1,#relics do
							local robj = relics[i];
							if(robj.rarity == rarity)then
								local scin = robj.scin or 102;
								
								if(tx>_W-rowD)then
									tx = rowD;
									ty = ty + itemH;
								end

								local rmc = newGroup(relicsmc);
								rmc.x, rmc.y = tx, ty;
								tx = tx + itemW;

								local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
								ico:scale(scaleGraphics/2, scaleGraphics/2);
								
								table.insert(localGroup.buttons, rmc);
								rmc.w, rmc.h = 28*scaleGraphics, 30*scaleGraphics;

								local name = "";
								if(save_obj['item_nick_'..robj.tag])then
									name = save_obj['item_nick_'..robj.tag];
								else
									local art_xml = get_xml_by_attr(arts_xml, 'type', tostring(scin));
									if(art_xml)then
										name = name..""..get_name(art_xml.properties.tag)
										name = name.." / ";
									end
									name = name..get_name(robj.tag);
								end
								name = name.." ("..robj.rarity..")";
								if(robj.lbl)then
									name = name.." ("..robj.lbl..")";
								end
								local hint = getRelicDesc(robj);
								
								local id = get_name_id(robj.tag);
								if(save_obj.unlocks['item_'..id]~=2)then
									local icoBackMC = newGroup(rmc);
									for ix=-1,1,2 do
										for iy=-1,1,2 do
											local icoBack = display.newImage(icoBackMC, "image/arts/item_"..scin..".png", ix, iy);
											icoBack:scale(scaleGraphics/2, scaleGraphics/2);
											icoBack.fill.effect = "filter.brightness"
											icoBack.fill.effect.intensity = 1.0;
										end
									end
									icoBackMC.alpha = 0.5;
									
									ico.fill.effect = "filter.grayscale";
									-- ico.fill.effect = "filter.brightness"
									-- ico.fill.effect.intensity = 1.0;
									-- ico.alpha = 1/2;
									
									ico:setFillColor(1/50);
									ico:toFront();
									name = get_txt('unknown');
									hint = "?????";
								else
									if(options_mobile)then
										rmc.hint = hint;
									end
								end

								function rmc:act()
									rmc:onOver();
									-- table.insert(localGroup.buttons, tagtxt);
									-- tagtxt.w, tagtxt.h = tagtxt.width, tagtxt.height;
									if(save_obj.unlocks['item_'..id]==2)then
										if(save_obj.donation)then
											if(save_obj.donation>1)then
												elite.newNativeText(contentmc, relic1txt.x, relic1txt.y, relic1txt.width, relic1txt.height, function(new_tag)
													if(#new_tag>0)then
														save_obj['item_nick_'..robj.tag] = new_tag;
														name = new_tag;
														saveGame();
													end
												end);
											end
										end
									end
								end
								
								function rmc:onOver()
									relic1txt:setText(name);
									relic2txt:setText(hint);

									relic1txt.x = math.min(math.max(rmc.x, relic1txt.width/2), _W-relic1txt.width/2);
									relic2txt.x = math.min(math.max(rmc.x, relic2txt.width/2), _W-relic2txt.width/2);
									
									relic1txt.y = rmc.y + 26*scaleGraphics;
									relic2txt.y = rmc.y + 42*scaleGraphics;
								end
								function rmc:onOut()
									relic1txt:setText("");
									relic2txt:setText("");
								end
							end
						end
					end
					for i=0,6 do
						local dtxt1 = newOutlinedText(contentmc, get_txt("item_rarity"..i)..":", 4*scaleGraphics, ty - itemH/2, fontMain, 12*scaleGraphics, 1, 0, 1);
						dtxt1:setTextColor(237/255, 198/255, 80/255);
						dtxt1:translate(dtxt1.width/2, 0);
						local dtxt2 = newOutlinedText(contentmc, get_txt("item_rarity"..i.."_hint"), dtxt1.x + dtxt1.width/2 + 4*scaleGraphics, ty - itemH/2, fontMain, 12*scaleGraphics, 1, 0, 1);
						dtxt2:translate(dtxt2.width/2, 0);
						-- dtxt:setTextColor(237/255, 198/255, 80/255);
						showItems(i);
						tx = rowD;
						ty = ty + itemH*1.5;
					end
				end);
				
				local scoresbtn;
				scoresbtn = facemc:addBtnIco(avatarbg, localGroup.buttons, get_txt('scores'), thisX + 122*scaleGraphics, minY, "scores", function()
					local extramc = newGroup(facemc);
					facemc.wnd = extramc;
					
					local rect = display.newRect(extramc, _W/2, _H/2, _W, _H);
					rect:setFillColor(0, 0, 0, 0.85);
					
					local btn = display.newImage(extramc, "image/button/cancel.png", _W - 20*scaleGraphics, 20*scaleGraphics);
					btn:scale(scaleGraphics/2, scaleGraphics/2);
					elite.addOverOutBrightness(btn);
					btn.w, btn.h = btn.contentWidth, btn.contentHeight;
					table.insert(localGroup.buttons, btn);
					btn.act = function()
						extramc:removeSelf();
						facemc.wnd = nil;
					end
					
					
					
					local bgi = 14;
					local bg = add_bg_title("bg_3", 400*scaleGraphics, bgi*14*scaleGraphics + 26*scaleGraphics, get_txt('scores'));
					bg.x, bg.y = _W/2, _H/2;
					extramc:insert(bg);
					
					require("src.injectScores").inject(extramc, bg, localGroup.buttons);
					
					-- extramc:fetchScores('?orderBy="score"&limitToLast=100', 'score');
					-- extramc:fetchScores('score');
					-- local class = hero_obj.class;
					extramc:dropJoined();
					extramc:fetchQuery('?orderBy="class"&equalTo="'..hero_obj.class..'"&limitToLast=300', "score", {attr="class", val=hero_obj.class}, "joined");
					extramc:fetchQuery('?orderBy="score"&limitToLast=300', "score", {attr="class", val=hero_obj.class}, "joined");
					extramc:showOwnOnEmpty("joined");
				end);
			else
				local cost = 1;
				local gomc = facemc:addBtn(avatarbg, localGroup.buttons, get_txt('unlock'), thisX, minY, function()
					if(save_obj.diamonds < cost)then
						tryToBuyDiamonds()
						return
					end
					
					save_obj.diamonds = save_obj.diamonds-cost;
					save_obj.unlocks['hero_'..hero_obj.class] = true;
					save_obj.unlocks['scin_'..hero_obj.scin] = true;
					
					local save_file = loadFile("save_"..hero_obj.class..".json");
					local continue = save_file~=nil;
					if(save_file)then
						_G.login_obj = json.decode(save_file);
						if(login_obj.dead)then
							continue = false;
						end
					end
				
					if(continue)then
						show_start();
					else
						start_game(hero_obj);
					end
				end, 110*scaleGraphics);
				gomc.dtxt.x = -50*scaleGraphics;
				
				if(save_obj.diamonds < cost)then
					gomc.hint = get_txt("diamonds_hint");
				end
				
				local dtxt = gomc.dtxt;
				while(dtxt.width>78*scaleGraphics and dtxt.size>4)do
					dtxt.size = dtxt.size-1;
				end
				gomc.dtxt:translate(gomc.dtxt.width/2, 0);
				
				local ico = display.newImage(gomc, "image/map/diamond.png", 40*scaleGraphics, 0);
				ico:scale(scaleGraphics/2, scaleGraphics/2);
				-- print("_save_obj.diamonds:", save_obj.diamonds);
				if(save_obj.diamonds<1)then
					ico.fill.effect = "filter.grayscale";
					ico:setFillColor(0.50);
					ico.alpha = 0.85;
				end
			end
			
			-- local txtbg = display.newImage(avatarbg, "image/cards_rarity_"..math.random(0,3)..".png", 0, 24*scaleGraphics);
			-- txtbg:scale(scaleGraphics/2, scaleGraphics/2);
			
			local tagtxt = newOutlinedText(avatarbg, save_obj['hero_nick_'..hero_obj.tag] or get_txt("hero_"..get_name_id(hero_obj.tag)), _W*3/4, _H/2 - 80*scaleGraphics, fontMain, 26*scaleGraphics, 1, 0, 2);
			tagtxt:setTextColor(237/255, 198/255, 80/255);
			-- ntxt:scale(1/2, 1/2);
			
			local nativetxt = newGroup(avatarbg);
			table.insert(localGroup.buttons, tagtxt);
			tagtxt.w, tagtxt.h = tagtxt.width, tagtxt.height;
			if(save_obj.donation)then
				if(save_obj.donation>2)then
					tagtxt.act = function()
						elite.newNativeText(nativetxt, tagtxt.x, tagtxt.y, tagtxt.width, tagtxt.height, function(new_tag)
							save_obj['hero_nick_'..hero_obj.tag] = new_tag;
							tagtxt:setText(new_tag);
							saveGame();
						end);
					end
				end
			end
			function tagtxt:onOver()
				tagtxt:setTextColor(80/255, 198/255, 237/255);
			end
			function tagtxt:onOut()
				tagtxt:setTextColor(237/255, 198/255, 80/255);
			end
			function tagtxt:disabled()
				return facemc.wnd~=nil;
			end
			
			local statsmc = newGroup(avatarbg);
			
			local itemmc = newGroup(statsmc);
			itemmc.x, itemmc.y = 0, _H/2 - 56*scaleGraphics;
			local moneyico = display.newImage(itemmc, "image/money.png");
			moneyico:scale(scaleGraphics/2, scaleGraphics/2);
			local dtxt2 = newOutlinedText(itemmc, hero_obj.money, 0, 0, fontMain, 20*scaleGraphics, 1, 0, 2);
			dtxt2:scale(1/2, 1/2);
			itemmc.hint = get_txt("money")..": "..hero_obj.money;
			table.insert(localGroup.buttons, itemmc);
			itemmc.w, itemmc.h = moneyico.contentWidth, moneyico.contentHeight;
			
			local itemmc = newGroup(statsmc);
			itemmc.x, itemmc.y = 0, _H/2 - 56*scaleGraphics;
			local moneyico = display.newImage(itemmc, "image/hp.png");
			moneyico:scale(scaleGraphics/2, scaleGraphics/2);
			local dtxt1 = newOutlinedText(itemmc, hero_obj.hp, 0, 0, fontMain, 20*scaleGraphics, 1, 0, 2);
			dtxt1:scale(1/2, 1/2);
			itemmc.hint = get_txt("hp")..": "..hero_obj.hp;
			table.insert(localGroup.buttons, itemmc);
			itemmc.w, itemmc.h = moneyico.contentWidth, moneyico.contentHeight;
			
			local xp = getLoginStat(hero_obj.class.."_exp");
			local lvl = getLoginStat(hero_obj.class.."_lvl");
			local xp_min = royal:get_lvl_xp(lvl+1);
			-- print("lvl", xp, lvl, xp_min);
			if(lvl>0)then
				local itemmc = newGroup(statsmc);
				itemmc.x, itemmc.y = 0, _H/2 - 56*scaleGraphics;
				local moneyico = display.newImage(itemmc, "image/level.png", 0);
				moneyico:scale(scaleGraphics/2, scaleGraphics/2);
				local dtxt1 = newOutlinedText(itemmc, lvl, 0, 0, fontMain, 20*scaleGraphics, 1, 0, 2);
				dtxt1:scale(1/2, 1/2);
				
				itemmc.hint = get_txt("xp_sc")..": "..xp.."/"..xp_min
				table.insert(localGroup.buttons, itemmc);
				itemmc.w, itemmc.h = moneyico.contentWidth, moneyico.contentHeight;
			end
			
			local jmin, jmax = 0, 0;
			for j=1,#cards do
				local card = cards[j];
				if(card.class==hero_obj.class)then
					if(save_obj.unlocks['card_'..get_name_id(card.tag)])then
						jmin = jmin+1;
					end
					jmax = jmax+1;
				end
			end
			if(jmin>0)then
				local itemmc = newGroup(statsmc);
				itemmc.x, itemmc.y = 0, _H/2 - 56*scaleGraphics;
				local moneyico = display.newImage(itemmc, "image/cards.png");
				moneyico:scale(scaleGraphics/2, scaleGraphics/2);
				local dtxt1 = newOutlinedText(itemmc, math.floor(100*jmin/jmax).."%", 0, 0, fontMain, 20*scaleGraphics, 1, 0, 2);
				dtxt1:scale(1/2, 1/2);
				
				itemmc.hint = get_txt("unlocked_cards")..": "..dtxt1.text;
				table.insert(localGroup.buttons, itemmc);
				itemmc.w, itemmc.h = moneyico.contentWidth, moneyico.contentHeight;
			end
			
			local win = getLoginStat("wins"..hero_obj.class);
			if(win>0)then
				local itemmc = newGroup(statsmc);
				itemmc.x, itemmc.y = 0, _H/2 - 56*scaleGraphics;
				local moneyico = display.newImage(itemmc, "image/wins1.png");
				moneyico:scale(scaleGraphics/2, scaleGraphics/2);
				local dtxt1 = newOutlinedText(itemmc, win, 0, 0, fontMain, 20*scaleGraphics, 1, 0, 2);
				dtxt1:scale(1/2, 1/2);
			end
			
			
			
			statsmc.x = _W*3/4;
			elite.arrangeGroup(statsmc, 30*scaleGraphics);
			
			-- local itxt = display.newText(avatarbg, "Supernatural creature. As talented shapeshifters often appearing in human form and female. Accordingly they are said to seduce men.", _W*3/4, _H/2 - 44*scaleGraphics, 230*scaleGraphics, 70*scaleGraphics, fontMain, 12*scaleGraphics);
			local itxt = display.newText(avatarbg, get_txt("hero_"..get_name_id(hero_obj.tag).."_hint"), _W*3/4, _H/2 - 44*scaleGraphics, 230*scaleGraphics, 80*scaleGraphics, fontMain, 12*scaleGraphics);
			itxt:translate(0, itxt.contentHeight/2);
			
			local next_y = 0;
			for j=1,#hero_obj.relics do
				local relic_id = hero_obj.relics[j];
				local robj = relics_indexes[relic_id];
				local scin = robj.scin or 102;
				local rmc = newGroup(avatarbg);
				rmc.x, rmc.y = _W*3/4-80*scaleGraphics, _H/2 + 40*scaleGraphics;
				
				pixelArtOn();
				local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
				ico:scale(scaleGraphics/2, scaleGraphics/2);
				pixelArtOff();
				
				local itxt = newOutlinedText(avatarbg, royal.getRelicName(robj), rmc.x + 20*scaleGraphics, rmc.y-8*scaleGraphics, fontMain, 14*scaleGraphics, 1, 0, 1);
				-- itxt:scale(1/2, 1/2);
				itxt:setTextColor(237/255, 198/255, 80/255);
				itxt:translate(itxt.contentWidth/2 - 4*scaleGraphics, 0);
				
				local hint = getRelicDesc(robj);
				
				local itxt = display.newText({parent=avatarbg, text=hint, x=rmc.x + 20*scaleGraphics, 
					y=rmc.y+8*scaleGraphics, width=180*scaleGraphics, font=fontMain, fontSize=12*scaleGraphics}); -- , height=60*scaleGraphics
				-- local itxt = display.newText(avatarbg, hint, rmc.x + 20*scaleGraphics, rmc.y+8*scaleGraphics, 180*scaleGraphics, 60*scaleGraphics, fontMain, 12*scaleGraphics);
				itxt:translate(itxt.contentWidth/2 - 4*scaleGraphics, itxt.contentHeight/2-6*scaleGraphics);
				
				next_y = itxt.y + itxt.contentHeight/2;
				
				-- object.contentBounds
				-- object.contentHeight
				-- object.contentWidth
			end
			
			local extra_hint_id = get_name_id("extra_"..hero_obj.tag.."_hint");
			local extra_hint_txt = get_txt_force(extra_hint_id, true);
			-- local ntxt = newOutlinedText(avatarbg, extra_hint_txt, tagtxt.x, next_y + 10*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
			if(extra_hint_txt)then
				local ntxt = display.newText({parent=avatarbg, text=extra_hint_txt, x=tagtxt.x, y=next_y + 4*scaleGraphics, width=230*scaleGraphics,
					font=fontMain, fontSize=10*scaleGraphics});
				ntxt:translate(0, ntxt.contentHeight/2);
			end
			-- ntxt:setTextColor(237/255, 198/255, 80/255);
			
			-- local itxt = newOutlinedText(avatarbg, "extra_hint", rmc.x + 20*scaleGraphics, rmc.y-8*scaleGraphics, fontMain, 14*scaleGraphics, 1, 0, 1);
				-- itxt:scale(1/2, 1/2);
			-- itxt:setTextColor(237/255, 198/255, 80/255);
			-- itxt:translate(itxt.contentWidth/2 - 4*scaleGraphics, 0);
			
			-- local xp = getLoginStat(hero_obj.class.."_exp");
			-- local lvl = getLoginStat(hero_obj.class.."_lvl");
			-- local xp_min = royal:get_lvl_xp(lvl+1);
			if(lvl>0)then
				-- local ntxt = newOutlinedText(avatarbg, get_txt("xp_sc")..": "..xp.."/"..xp_min, tagtxt.x, _H/2 + 90*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
				-- ntxt:setTextColor(237/255, 198/255, 80/255);
			end
			
			if(options_debug)then
				local class = hero_obj.class;
				local lfs = require "lfs";
				local doc_path = system.pathForFile("image/cards/"..class.."/", system.ResourceDirectory);
				print("<lost&found>");
				for file in lfs.dir(doc_path) do
					local ok = false;
					for i=1,#cards do
						local id = get_name_id(cards[i].tag);
						if(file:find(id, 1)~=nil)then
							ok = true;
							break;
						end
					end
					if(ok~=true)then
						print("file free:", file, ok);
					end
				end
				
				for i=1,#cards do
					local card = cards[i];
					if(card.class == class)then
						local img = display.newImage("image/cards/"..card.class.."/"..get_name_id(card.tag)..".jpg");
						if(img)then
							img:removeSelf();
						else
							print("missing img:", card.class, card.tag);
						end
					end
				end
				print("</lost&found>");
				
				local class = "none";
				local lfs = require "lfs";
				local doc_path = system.pathForFile("image/cards/"..class.."/", system.ResourceDirectory);
				print("<lost&found>");
				for file in lfs.dir(doc_path) do
					local ok = false;
					for i=1,#cards do
						local id = get_name_id(cards[i].tag);
						if(file:find(id, 1)~=nil)then
							ok = true;
							break;
						end
					end
					if(ok~=true)then
						print("file free:", file, ok);
					end
				end
				
				for i=1,#cards do
					local card = cards[i];
					if(card.class == class)then
						local img = display.newImage("image/cards/"..card.class.."/"..get_name_id(card.tag)..".jpg");
						if(img)then
							img:removeSelf();
						else
							print("missing img:", card.class, card.tag);
						end
					end
				end
				print("</lost&found>");
			end

			if(options_debug or options_cheats or true)then
				local stats = {cards=0, ctype1=0, ctype2=0, ctype3=0, ctype4=0, ctype5=0};
				for j=1,#cards do
					local card = cards[j];
					if(card.class==hero_obj.class)then
						stats.cards = stats.cards+1;
						stats["ctype"..card.ctype] = stats["ctype"..card.ctype]+1;
					end
				end
				
				local ntxt = newOutlinedText(avatarbg, "cards: "..stats.cards, tagtxt.x, _H - 84*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
				ntxt:setTextColor(237/255, 198/255, 80/255);
				
				if(hero_obj.state)then
					ntxt:setText("status: "..hero_obj.state..", "..ntxt.text);
				end
				for j=1,3 do
					local typemc = display.newImage(avatarbg, "image/cards_ctype"..j..".png", tagtxt.x + (j-3/2-0.5)*28*scaleGraphics, ntxt.y+20*scaleGraphics);
					typemc:scale(scaleGraphics/2, scaleGraphics/2);
					local dtxt = newOutlinedText(avatarbg, stats["ctype"..j], typemc.x, typemc.y, fontMain, 10*scaleGraphics, 1, 0, 2);
				end
				
				if(hero_obj.tags)then
					-- local dtxt = newOutlinedText(avatarbg, "tags:", ntxt.x, ntxt.y + 40*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
					-- dtxt:setTextColor(237/255, 198/255, 80/255);
					local list1 = {};
					local list2 = {};
					local list3 = {};
					table.foreach(hero_obj.tags, function(attr, val)
						list2[val]=true;
						table.insert(list1, get_txt(val));
					end)
					local dtxt = newOutlinedText(avatarbg, "tags: "..table.concat(list1, ", "), ntxt.x, ntxt.y + 40*scaleGraphics, fontMain, 8*scaleGraphics, 1, 0, 1);
					
					-- for j=1,#relics do
						-- local robj = relics[j];
						-- if(robj.lbl)then
							-- if(list2[robj.lbl])then
								-- table.insert(list3, robj);
							-- end
						-- end
					-- end
					-- for j=1,#list3 do
						-- local robj = list3[j];
						-- local scin = robj.scin or 102;
						-- local rmc = newGroup(mc);
						-- rmc.x, rmc.y = (j-#list3/2-0.5)*22*scaleGraphics, 148*scaleGraphics;
						-- local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
						-- ico:scale(scaleGraphics/3, scaleGraphics/3);
					-- end
				end
			end
			
			
		end
	end
	end
	local function turnHandler(e)
		for i=#units,1,-1 do
			local unit=units[i];
			if(unit.parent)then
				if(unit:spritePlaying()==false)then
					if(unit._act=="attack")then

					end
					unit:setAct('idle');
				end
			else
				table.remove(units, i);
			end
		end
	end
	Runtime:addEventListener('enterFrame', turnHandler);
	
	local ts = 34*scaleGraphics;
	local function addRoundBtn(tar, title, tx, ty, pimg, act, pimg2, bol)
		local btn = newGroup(tar);
		btn:translate(tx, ty);
		btn:scale(scaleGraphics/2, scaleGraphics/2);
		
		function btn:refresh()
			cleanGroup(btn);
			local img = pimg;
			if(bol)then
				img = pimg2;
				if(bol())then
					img = pimg;
				end
			else
				
			end
			local body = display.newImage(btn, img);
		end
		btn:refresh();
		
		btn.hint=get_txt(title);
		btn.act = function(btn)
			if(act)then
				act(btn);
			end
			btn:refresh();
		end
		table.insert(localGroup.buttons, btn);
		btn.w, btn.h = 40*scaleGraphics, 40*scaleGraphics;
		elite.addOverOutBrightness(btn);

		-- function btn:disabled()
			-- return tar.wnd~=nil;
		-- end
		return btn;
	end
	
	local extra_options_mc = newGroup(localGroup);
	extra_options_mc.x, extra_options_mc.y = 120*scaleGraphics, _H-150*scaleGraphics;
	local extra_bg = add_bg_title("bg_in", 90*scaleGraphics, 170*scaleGraphics, get_txt('options'), 2);
	extra_options_mc:insert(extra_bg);
	extra_bg.x, extra_bg.y = 0,0;
	
	local function add_small_button(tar_mc, fname, utype, tx, ty, act)
		local fire_mc = display.newGroup();
		fire_mc.w, fire_mc.h = 10*scaleGraphics,10*scaleGraphics
		fire_mc.xScale, fire_mc.yScale = scaleGraphics/2, scaleGraphics/2;
		fire_mc.x, fire_mc.y = tx, ty
		tar_mc:insert(fire_mc)
		local body=display.newImage(fire_mc, fname..".png");
		body.x, body.y = 0,0;
		
		fire_mc.utype=utype;
		fire_mc._selected = false;
		fire_mc._over = display.newImage(fire_mc, fname.."_.png");
		fire_mc._over.x, fire_mc._over.y = 0,0;
		-- table.insert(building_list, fire_mc);
		
		if(act)then
			fire_mc:addEventListener('tap', function(e)
				act();
			end);
		end
	end
	
	local mini_dd = 26*scaleGraphics;
	local troops_bars_w = 62*scaleGraphics;
	if(true)then
		local troops_mc = display.newGroup();
		extra_options_mc:insert(troops_mc);
		local troop_lvl_bg = add_bar("price_bar", troops_bars_w);
		troop_lvl_bg.x, troop_lvl_bg.y = 0,-50*scaleGraphics;
		troops_mc:insert(troop_lvl_bg);
		
		local troop_lvl_bar = display.newImage(troops_mc, "image/gui/red1s_m.png");
		troop_lvl_bar.xScale, troop_lvl_bar.yScale = scaleGraphics/2, scaleGraphics/2;
		troop_lvl_bar.x, troop_lvl_bar.y = troop_lvl_bg.x, troop_lvl_bg.y
		local tdtxt = display.newText(troops_mc, get_txt('master_volume'), 0, troop_lvl_bg.y+txt_number_offset-16*scaleGraphics, fontMain, 12*scaleGraphics);
		local troop_lvl_dtxt = display.newText(troops_mc, "100%", 0, 0, fontNumbers, 10*scaleGraphics);
		troop_lvl_dtxt.x, troop_lvl_dtxt.y = troop_lvl_bg.x, troop_lvl_bg.y+txt_number_offset;

		add_small_button(troops_mc, "image/gui/btnMinus", 'volume_down', troop_lvl_bg.x - mini_dd, troop_lvl_bg.y, function() 
			audio.setVolume(math.max(audio.getVolume() - 0.1, 0));
			localGroup:refreshVolume();
			sound_play("pack_click");
			require("eliteScale").saveScales();
		end);
		add_small_button(troops_mc, "image/gui/btnDonat", 'volume_up', troop_lvl_bg.x + mini_dd, troop_lvl_bg.y, function() 
			audio.setVolume(math.min(audio.getVolume() + 0.1, 1));
			localGroup:refreshVolume();
			sound_play("pack_click");
			require("eliteScale").saveScales();
		end);

		function localGroup:refreshVolume()
			local full_w = 3*scaleGraphics;
			troop_lvl_bar.xScale = math.max(0.01, (full_w)*audio.getVolume()/1);
			troop_lvl_bar.x = -26*scaleGraphics+troop_lvl_bar.contentWidth/2;
			troop_lvl_dtxt.text = tostring(math.round(audio.getVolume()*100)).."%";
			tdtxt.text = get_txt('master_volume');
			extra_bg.dtxt.text = get_txt('options');
		end
		localGroup:refreshVolume();
	end
	
	if(true)then
		local troops_mc = display.newGroup();
		extra_options_mc:insert(troops_mc);
		local troop_lvl_bg = add_bar("price_bar", troops_bars_w);
		troop_lvl_bg.x, troop_lvl_bg.y = 0,-10*scaleGraphics;
		troops_mc:insert(troop_lvl_bg);
		
		local troop_lvl_bar = display.newImage(troops_mc, "image/gui/blue1s_m.png");
		troop_lvl_bar.xScale, troop_lvl_bar.yScale = scaleGraphics/2, scaleGraphics/2;
		troop_lvl_bar.x, troop_lvl_bar.y = troop_lvl_bg.x, troop_lvl_bg.y
		local tdtxt = display.newText(troops_mc, get_txt('gui_size'), 0, troop_lvl_bg.y+txt_number_offset-16*scaleGraphics, fontMain, 12*scaleGraphics);
		local troop_lvl_dtxt = display.newText(troops_mc, "100%", 0, 0, fontNumbers, 10*scaleGraphics);
		troop_lvl_dtxt.x, troop_lvl_dtxt.y = troop_lvl_bg.x, troop_lvl_bg.y+txt_number_offset;

		add_small_button(troops_mc, "image/gui/btnMinus", 'gui_size_down', troop_lvl_bg.x - mini_dd, troop_lvl_bg.y, function() 
			_G.scaleGraphics = _G.scaleGraphics-0.1;
			sound_play("pack_click");
			show_start(true);
			-- director:changeScene('src.screenMenu');
			-- local current_mc = director:getCurrHandler();
			-- current_mc.options_mc:switch();
			require("eliteScale").saveScales();
		end);
		add_small_button(troops_mc, "image/gui/btnDonat", 'gui_size_up', troop_lvl_bg.x + mini_dd, troop_lvl_bg.y, function() 
			_G.scaleGraphics = _G.scaleGraphics+0.1;
			sound_play("pack_click");
			show_start(true);
			-- director:changeScene('src.screenMenu');
			-- local current_mc = director:getCurrHandler();
			-- current_mc.options_mc:switch();
			require("eliteScale").saveScales();
		end);

		function localGroup:refreshGuiSize()
			local full_w = 3*scaleGraphics;
			troop_lvl_bar.xScale = (full_w)*audio.getVolume()/1;
			troop_lvl_bar.x = -26*scaleGraphics+troop_lvl_bar.contentWidth/2;
			troop_lvl_dtxt.text = tostring(math.round(_G.scaleGraphics*100)).."%";
			tdtxt.text = get_txt('gui_size');
			extra_bg.dtxt.text = get_txt('options');
		end
		localGroup:refreshGuiSize();
	end
	
	extra_options_mc.isVisible = false;
	
	local pause_switch;
	pause_switch = function(pause_btn)
		if(facemc.optionsmc)then
			extra_options_mc.isVisible = false;
			facemc.optionsmc:removeSelf();
			facemc.optionsmc = nil;
			return true
		end
		local wnd = newGroup(facemc);
		-- extra_options_mc.isVisible = true and not options_mobile;

		local dy = 44*scaleGraphics;
		
		addRoundBtn(wnd, "music", pause_btn.x, pause_btn.y - 12*scaleGraphics - 1*dy, "image/gui/btn_music.png", eliteSoundsIns.switchMusic, "image/gui/btn_music_off.png", eliteSoundsIns.getMusicBol);
		addRoundBtn(wnd, "sound", pause_btn.x, pause_btn.y - 12*scaleGraphics - 2*dy, "image/gui/btn_sound.png", eliteSoundsIns.switchSound, "image/gui/btn_sound_off.png", eliteSoundsIns.getSoundBol);
		addRoundBtn(wnd, "debug", pause_btn.x, pause_btn.y - 12*scaleGraphics - 3*dy, "image/gui/btn_high_off.png", function()
			if(mainGroup.hero_obj)then
				show_fade_gfx(function()
					director:changeScene(options, "src.screenDebug");
				end);
			else
				show_msg('choose hero in start menu');
			end
		end);
		addRoundBtn(wnd, "show_hidden_heroes",	pause_btn.x, pause_btn.y - 12*scaleGraphics - 4*dy, "image/gui/btn_extratext.png", function()
			-- show_fade_gfx(function()
				-- director:changeScene(options, "src.screenEditor");
			-- end);
			save_obj.show_hidden_heroes = not save_obj.show_hidden_heroes;
			show_start();
		end);
		addRoundBtn(wnd, "editor",	pause_btn.x, pause_btn.y - 12*scaleGraphics - 5*dy, "image/gui/btn_high_on.png", function()
			show_fade_gfx(function()
				director:changeScene(options, "src.screenEditor");
			end);
		end);
		
		if(options_mobile)then
			local btnSizeY = math.max(pause_btn.y - 12*scaleGraphics - 6*dy, 30*scaleGraphics);
			local btn = addRoaylBtn(ts/2+ts*1, btnSizeY, "minus", function()
				_G.scaleGraphics = _G.scaleGraphics-0.1;
				if(scaleGraphics>2)then _G.scaleGraphics = _G.scaleGraphics-0.1; end
				
				show_msg(get_txt('scale')..": "..(scaleGraphics*100).."%")
				show_start(true);
				require("eliteScale").saveScales();
				return
			end, "image/button/minus.png");
			wnd:insert(btn);
			
			local btn = addRoaylBtn(ts/2+ts*0, btnSizeY, "plus", function()
				_G.scaleGraphics = _G.scaleGraphics+0.1;
				if(scaleGraphics>2)then _G.scaleGraphics = _G.scaleGraphics+0.1; end
				
				show_msg(get_txt('scale')..": "..(scaleGraphics*100).."%")
				show_start(true);
				require("eliteScale").saveScales();
				return
			end, "image/button/plus.png");
			wnd:insert(btn);
		end
		
		
		local lang_list_tw = 30*scaleGraphics;
		local lang_list_arr = language:getList();
		local lang_list_mc = language:showList(0, 0, lang_list_tw, 0, scaleGraphics);
		wnd:insert(lang_list_mc);
		lang_list_mc.x, lang_list_mc.y = _W/2-(#lang_list_arr-1)*lang_list_tw/2, minY;
		function language:act()
			royal:exeLangListeners();
			show_start(true);
		end
	
		
		facemc.optionsmc = wnd;
	end
	
	local optionsX, optionsY = ts, _H-ts;
	local pause_btn = addRoundBtn(facemc, "options", optionsX, optionsY, "image/gui/btn_gear.png", pause_switch);
	pause_btn.disabled = nil;
	
	if(options)then
		pause_switch(pause_btn);
	end
	
	function localGroup:actEscape()
		onBack();
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	royal:clearCardsLog();
	function localGroup:removeAll()
		Runtime:removeEventListener('enterFrame', turnHandler);
	end
	
	local function submitFirebase()
		local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
		if(player_name)then
			if(#player_name>2 and #player_name<13)then
				if(#_G.scores_unsubmitted>0)then
					if(royal.db==nil)then
						local firebase = require('firebase');
						royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
					end
				
					local score_obj = table.remove(_G.scores_unsubmitted, 1);
					score_obj.nick = player_name;
					royal.db:post("scores", json.encode(score_obj), nil, function(event)
						print(event.isError, event.phase, event.response);
						if(event.isError)then
							-- print('ERROR!')
							-- local encodedString = b64lib.b64("Hello {('%!&jQ')} World");
							-- local decodedString = b64lib.unb64(encodedString);
							table.insert(_G.scores_unsubmitted, score_obj)
						else
							show_msg(get_txt("submitted")..": "..get_txt("scores"));
						end
					end);
				end
			end
		end
	end
	submitFirebase();
	
	if(system.getInfo("environment")=="simulator")then
		local save_date = os.date( "%Y" )..os.date( "%m" )..os.date( "%d" );
		local fname = "rbq-db."..save_date..".json";
		local file = loadFile(fname);
		if (file) then
			print('backup today already done');
		else
			if(royal.db==nil)then
				local firebase = require('firebase');
				royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
			end
			royal.db:get("scores", '?orderBy="'.."score"..'"&limitToLast=800', function(event)
				if(event.isError)then
					print("Network error!");
				else
					saveFile(fname, event.response);
				end
			end);
		end
		
		-- local save_date = os.date( "%d" )..os.date( "%m" )..os.date( "%Y" );
		local fname = "rbq-forge."..save_date..".json";
		local file = loadFile(fname);
		if (file) then
			print('backup today already done');
		else
			if(royal.forge==nil)then
				local firebase = require('firebase');
				royal.forge = firebase('https://cards-114b3.firebaseio.com/');
			end
			royal.forge:get("cards", nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					saveFile(fname, event.response);
				end
			end);
		end
	end
	
	return localGroup;
end