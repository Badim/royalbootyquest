module(..., package.seeall);

function new(options)	
	local localGroup = display.newGroup();
	localGroup.name = "menu";
	
	local background = display.newImage(localGroup, "image/background/book.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	if(options_debug)then
		local txt = table.concat(log_texts, "\r\n");
		local ltxt = display.newText(gamemc, txt, _W/2, _H/2, nil, 8*scaleGraphics);
		ltxt.y = ltxt.contentHeight/2 + 30*scaleGraphics;
		ltxt:addEventListener('touch', function(e)
			ltxt:removeSelf();
			return true;
		end);
		show_msg("lang locale:"..tostring(system.getPreference("locale", "language")).."!");
	end
	
	if(settings.dragAndDrop==nil)then
		settings.dragAndDrop = true;
	end
	
	local logobg = display.newImage(facemc, "image/gui/logo_bg.png");
	logobg:scale(scaleGraphics/2, scaleGraphics/2);
	logobg.x, logobg.y = _W/2, 50*scaleGraphics;
	
	local logo = display.newImage(facemc, "image/gui/logo1.png");
	logo:scale(scaleGraphics/2, scaleGraphics/2);
	logo.x, logo.y = logobg.x, logobg.y;
	
	local txt1 = get_txt("royal_booty_quest");
	local txt2 = "Royal Booty Quest";
	
	-- local title1txt = newOutlinedText(facemc, get_txt("royal_booty_quest"), _W/2, 40*scaleGraphics, fontMain, 32*scaleGraphics, 1, 0, 1);
	-- title1txt:setTextColor(237/255, 198/255, 80/255);
	-- if(get_name_id(txt1)~= get_name_id(txt2))then
		-- local title2txt = newOutlinedText(facemc, "("..txt2..")", _W/2, 72*scaleGraphics, fontMain, 18*scaleGraphics, 1, 0, 1);
		-- title2txt:setTextColor(237/255, 198/255, 80/255);
	-- end
	
	local stores = {};
	-- table.insert(stores, {tag="Steam", url="https://store.steampowered.com/app/948350/Royal_Booty_Quest/"});
	-- if(optionsBuild~="ios" and optionsBuild~="mac")then
		-- table.insert(stores, {tag="Google Play", url="https://play.google.com/store/apps/details?id=com.elitegamesltd.royalquest"});
	-- end
	-- if(optionsBuild~="android")then
		-- table.insert(stores, {tag="iTunes", url="https://itunes.apple.com/us/app/royal-booty-quest/id1414474189"});
	-- end
	-- table.insert(stores, {tag="Discord", url="https://discord.gg/j5e7fYd"});
	
	localGroup.buttons = {};
	facemc.buttons = localGroup.buttons;
	
	function localGroup:switchFullscreen()
		if(native.getProperty("windowMode")=="fullscreen")then
			native.setProperty("windowMode", "normal");
		else
			native.setProperty("windowMode", "fullscreen");
		end
		settings.fullscreen = native.getProperty("windowMode")=="fullscreen";
		saveGame();
	end
	
	local function show_exit()
		local txt_arr = {};
		table.insert(txt_arr, get_txt('quit_game'));
		local cnfr_mc = royal.show_wnd_question(facemc, facemc.buttons, txt_arr, function()
			local fade_out = display.newRect(mainGroup.parent, _W/2, _H/2, _W, _H);
			fade_out:setFillColor(0,0,0);
			transition.from(fade_out, {time=400, alpha=0, onComplete=function(obj)
				native.requestExit();
			end});
		end, function()
			
		end);
						
		facemc.wnd = cnfr_mc;
	end
	
	local ts = 34*scaleGraphics;
	local function addRoaylBtn(tx, ty, hint, act, img, scale)
		local btn = newGroup(facemc);
		btn:translate(tx, ty);
		local img = display.newImage(btn, img);
		if(scale==nil)then scale=1; end
		img:scale(scale*scaleGraphics/2, scale*scaleGraphics/2);
		
		btn.hint = get_txt(hint);
		btn.act = act;
		elite.addOverOutBrightness(btn, img);
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		
		-- btn.w, btn.h = 140*scaleGraphics, 90*scaleGraphics;
		btn.w, btn.h = img.contentWidth, img.contentHeight;
		table.insert(localGroup.buttons, btn);
		return btn, img;
	end
	addRoaylBtn(_W/2, _H - 120*scaleGraphics, "play", function()
		-- if(login_obj.dead)then
			show_start();
		-- else
			-- show_map();
		-- end
	end, "image/gui/btn_play.png");
	
	-- if(true or ((options_cheats or optionsBuild == "win32") and system.getInfo("environment")=="simulator"))then
		
		local pve_btn = addRoaylBtn(_W/2 - 100*scaleGraphics, _H - 120*scaleGraphics, "pve", function()
			local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
			if(player_name)then
				show_lobby();
			else
				show_msg('you dont have a name - use google play or submit scores');
			end
		end, "image/gui/btn_credits.png");
		pve_btn.hint = "pve"..' ('..get_txt("under_construction")..")";
		
		-- addRoaylBtn(_W/2 + 100*scaleGraphics, _H - 120*scaleGraphics, "bot1", function()
			-- _G.options_save_fname = "bot1";
			-- loadGame({});
			-- save_obj.customName = "bot1";
			-- save_obj.ai = true;
			-- save_obj.unlocks = {};
			-- show_lobby();
		-- end, "image/gui/btn_credits.png");
		
		-- addRoaylBtn(_W/2 + 150*scaleGraphics, _H - 120*scaleGraphics, "bot2", function()
			-- _G.options_save_fname = "bot2";
			-- loadGame({});
			-- save_obj.customName = "bot2";
			-- save_obj.ai = true;
			-- save_obj.unlocks = {};
			-- show_lobby();
		-- end, "image/gui/btn_credits.png");
		
	-- end
	
	if(options_moregames)then
		-- local more_mc = add_button("more_games", _W-ts, _H-ts, "image/gui/btn_dice.png", function()
			-- show_more();
		-- end);
		local more_mc = addRoaylBtn(_W-ts, _H-ts, "more", function()
			show_more();
		end, "image/gui/btn_dice.png");
		
		if(_G.more_games_looked ~= true)then
			-- local date = os.date( "*t" )    -- Returns table of date & time values
			-- print( "date:", date.year, date.month,  os.date( "%j")) 
			-- print("data", os.date( "%j"), os.date("%Y"), tonumber(os.date( "%j"))>moregamesDays, tonumber(os.date("%Y"))>moregamesYear);
			if(tonumber(os.date( "%j"))>moregamesDays or tonumber(os.date("%Y"))>moregamesYear)then
				elite.add_notification(localGroup, more_mc.x+22*scaleGraphics, more_mc.y-22*scaleGraphics, '1');
			end
		end
	end
	
	local topX = _W - 20*scaleGraphics;
	if(optionsBuild~="ios" and optionsBuild~="mac")then
		addRoaylBtn(topX, 20*scaleGraphics, "exit", show_exit, "image/button/cancel.png");
		topX = topX-30*scaleGraphics;
	end
	if(options_desctop)then
		local btn = elite.addSmallSwitcher(facemc, "image/button/fullscreen2", "image/button/fullscreen1", topX, 20*scaleGraphics, function()
			return native.getProperty("windowMode")=="fullscreen";
		end);
		btn.act = function()
			localGroup:switchFullscreen();
			btn:refresh();
		end
		btn.hint = get_txt("fullscreen");
		table.insert(localGroup.buttons, btn);
		btn.w, btn.h = 40*scaleGraphics, 40*scaleGraphics;
		elite.addOverOutBrightness(btn);
	end
	
	for i=1,#stores do
		local obj = stores[i];
		local id = get_name_id(obj.tag);
		local btn, img = addRoaylBtn(_W/2 + 50*scaleGraphics*(i-#stores/2-0.5), _H - 60*scaleGraphics, obj.tag, function()
			system.openURL(obj.url);--https://discord.gg/j5e7fYd
		end, "gfx/stores/"..id..".png", 4);
		btn.w, btn.h = 40*scaleGraphics, 40*scaleGraphics;
		img:scale(1/5, 1/5);
	end

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

		function btn:disabled()
			return tar.wnd~=nil;
		end
		return btn;
	end
	
	local gpgs_mc;
	if(optionsBuild=="android")then
		--play_mc.y = _H - 116*scaleGraphics;
		-- show_msg("google_status:"..tostring(_itemAchievement._google_status));
		if(_itemAchievement._google_status<3 and options_gamecenter)then
			if(false)then
				_itemAchievement:iniGoogle();
			else
				gpgs_mc = addRoaylBtn(_W-ts, _H-ts*3, "GPGS", function()
					transition.to(gpgs_mc, {time=300, alpha=0.0, onComplete=function(obj)
						transitionRemoveSelfHandler(obj);
					end});
					_itemAchievement:iniGoogle();
				end, "image/gui/btn_gpgs.png");
			end
		end
	end
	
	local function show_versionlog()
		if(facemc.wnd)then
			facemc.wnd:removeSelf();
			facemc.wnd = nil;
			return
		end
		local wndmc = newGroup(localGroup);
		wndmc.x, wndmc.y = _W/2, _H/2;
		local w, h = _W - 100*scaleGraphics, _H-100*scaleGraphics;
		
		facemc.wnd = wndmc;
		
		local content = loadFile("_version.txt", system.ResourceDirectory);
		if(content)then
			local textGroup = newGroup(wndmc);
			local dtxt = display.newText(textGroup, content, 0, 0, w-20*scaleGraphics, 0, fontMain, 12*scaleGraphics);
			dtxt:translate(0, dtxt.height/2 - h/2 + 10*scaleGraphics);
			
			local maskS = 266;
			local mask = graphics.newMask("image/masks/rect.png");
			textGroup:setMask(mask);
			
			textGroup.maskScaleX = w/maskS;
			textGroup.maskScaleY = h/maskS;
			
			textGroup.maskX, textGroup.maskY = -maskS/textGroup.maskScaleX/2, -maskS/textGroup.maskScaleY/2 + 30*scaleGraphics;
			
			-- elite.setScrollable(textGroup);
			local function mouseHandler(e)
				if(textGroup.parent==nil)then
					Runtime:removeEventListener("mouse", mouseHandler);
					return
				end
				if(e.scrollY)then
					if(e.scrollY~=0)then
						textGroup:translate(0, -e.scrollY*scaleGraphics/2);
						textGroup.maskY = textGroup.maskY + e.scrollY*scaleGraphics/2;
					end
				end
			end
			Runtime:addEventListener("mouse", mouseHandler);
		end
		
		
		local wndbg = add_bg_title("bg_3", w, h, get_txt('changelog'));
		wndbg.x, wndbg.y = 0, 0;
		wndmc:insert(wndbg);
		wndbg:toBack();
		
		wndmc:addEventListener("tap", function(e)
			wndmc:removeSelf();
			facemc.wnd = nil;
			return true
		end);
	end
	
	local function show_credits()
		if(facemc.wnd)then
			facemc.wnd:removeSelf();
			facemc.wnd = nil;
			return
		end
		local wndmc = newGroup(localGroup);
		wndmc.x, wndmc.y = _W/2, _H/2;
		local w, h = 400*scaleGraphics, 260*scaleGraphics;
		
		facemc.wnd = wndmc;
		
		local arr = {};
		table.insert(arr, "developed by Badim, gamedesign by DN");
		-- table.insert(arr, "gamedesign by DN");
		table.insert(arr, "art by:");
		table.insert(arr, "darkvam (cards), Tiodor(heroes & enemies), Choops(logo, enemies), Royal Heroes");
		table.insert(arr, "tnx to Discord Knights:");
		table.insert(arr, "eolevan, Malouf, Psy0ch, skylex157, cibai, Defender Fidei");
		table.insert(arr, "illumenande, shadowfax45, stubbieoz, TheFatDaddy, Warshadow");
		table.insert(arr, "English by illuminande, German by Psy0ch, Portuguese by The Falling");
		table.insert(arr, "Dungeon Master: Dealmi");
		table.insert(arr, "Spanish by Skylex and Juantxu Vivancos, Polish by Styllshadow");
		table.insert(arr, "inspired by:");
		table.insert(arr, "Royal Heroes, Card Quest, Dream Quest, Night of the Full Moon");
		table.insert(arr, "Slay the Spire, Majesty, Fate Hunters, Deck Hunter, Monster Slayers");
		table.insert(arr, "tnx for support:");
		table.insert(arr, "Bogomazon, MadCoder, sergey120xp, Sergey Brava, Konstantin Klepikov, Iqzimp");
		
		for i=1,#arr do
			local txt = display.newText(wndmc, arr[i], 0, 18*(i-#arr/2-0.5)*scaleGraphics, fontMain, 10*scaleGraphics);
			if(true and arr[i]:find("Skylex", 1)~=nil)then
				txt.w, txt.h = txt.width, txt.height;
				table.insert(localGroup.buttons, txt);
				elite.addOverOutBrightness(txt);
				txt.act = function()
					if(royal.counter==nil)then
						royal.counter = 1;
					else
						royal.counter = royal.counter+1;
					end
					if(royal.counter>3)then
						-- _G.save_obj.donation = 3;
						_G.save_obj.druid_admin = true;
						show_msg("Hail Druid King!");
						saveGame();
						royal:uploadTempCards("druid");
					end
					print(royal.counter, _G.save_obj.donation);
				end
			end
			if(false and arr[i]:find("Skylex", 1)~=nil)then
				txt.w, txt.h = txt.width, txt.height;
				table.insert(localGroup.buttons, txt);
				elite.addOverOutBrightness(txt);
				txt.act = function()
					if(royal.counter==nil)then
						royal.counter = 1;
					else
						royal.counter = royal.counter+1;
					end
					if(royal.counter>3)then
						_G.save_obj.donation = 3;
						saveGame();
					end
					print(royal.counter, _G.save_obj.donation);
				end
			end
		end
		
		local wndbg = add_bg_title("bg_3", w, #arr*18*scaleGraphics + 20*scaleGraphics, get_txt('credits'));
		wndbg.x, wndbg.y = 0, 0;
		wndmc:insert(wndbg);
		wndbg:toBack();

		-- art by:
		-- Ruslan (cards), Tiodor(Heroes & enemies), Choops(logo, enemies), Royal Heroes
		-- cards: Ruslan, heroes: Tiodor, enemies: Choops & Tiodor & Royal Heroes, splashes: Anthony Avon
		-- tnx to Discord Knights:
		-- eolevan, Malouf, Psy0ch, skylex157, cibai, illumenande, shadowfax45, stubbieoz, TheFatDaddy, Warshadow
		-- English - illuminande
		-- German - Psy0ch
		-- Inspired by:
		-- Card Quest, Royal Heroes, Dream Quest, Night of the Full Moon, Slay the Spire, Fate Hunters, Spellrune Realm of Portals, Deck Hunter, Monster Slayers
		wndmc:addEventListener("tap", function(e)
			wndmc:removeSelf();
			facemc.wnd = nil;
			return true
		end);
	end
	
	if(options_steam==true or optionsBuild=="mac")then
		_G.save_obj.donation = 3;
	end
	
	local function show_donat()
		if(facemc.wnd)then
			facemc.wnd:removeSelf();
			facemc.wnd = nil;
			return
		end
		local wndmc = newGroup(localGroup);
		wndmc.x, wndmc.y = _W/2, _H/2;
		local w, h = 400*scaleGraphics, 260*scaleGraphics;

		facemc.wnd = wndmc;
		
		local content = newGroup(wndmc);
		
		local arr1 = {};
		if(options_steam)then
			table.insert(arr1, "Royal Booty Quest is a result of hard labor.");
			table.insert(arr1, "Support for caffeine deprived devs plus some awesome RBQ cards for you!");

			table.insert(arr1, "Coffee for coding is an initiative inspired by our faithful fans.");
			table.insert(arr1, "It'll reward my efforts in delivering DLCs and frequent updates.");
			table.insert(arr1, "I'll not say 'no' to some loose change coming our way.");
			table.insert(arr1, "That can be used for more coffee = more coding, right? ;)");
			table.insert(arr1, "I also included a gift for all those who wish to say thanks – decks of RBQ Cards,");
			table.insert(arr1, "in the form of high resolution jpgs, featuring gorgeous character artwork!");
			table.insert(arr1, "You can use the cards for role playing games, or just enjoy the drawings.");
			table.insert(arr1, "So enjoy and thank you for your continuous support!");
			table.insert(arr1, "Once downloaded, you will find the cards in your RBQ folder.");
			table.insert(arr1, "");
			table.insert(arr1, "");
		elseif(optionsBuild == "mac")then
			table.insert(arr1, "Royal Booty Quest is a result of hard labor.");
			table.insert(arr1, "I work alone on it. And wanna say thx to you for supporting me.");

			table.insert(arr1, "It'll reward my efforts in delivering DLCs and frequent updates.");
			-- table.insert(arr1, "That can be used for more coffee = more coding, right? ;)");
			table.insert(arr1, "I also included a gift for all those who wish to say thanks.");
			
			table.insert(arr1, "H1Rename Equipment: Give your favourite gear epic custom names!");
			-- table.insert(arr1, "Give your favourite gear epic custom names!");
			table.insert(arr1, "H1Name your Heroes: You can rename your heroes as you wish.");
			-- table.insert(arr1, "You can rename your heroes as you wish.");
			table.insert(arr1, "H2Gravestones");
			table.insert(arr1, "H2Lootable remains from your fallen heroes now appear in your current run.");
			table.insert(arr1, "H2Recolor Cards: You can change color of decks.");
			table.insert(arr1, "H2Recolor your Heroes: Change a color of scin, dress, hair as you wish.");
			save_obj.donation = 3;
		else
			table.insert(arr1, "Royal Booty Quest is totally free.");
			table.insert(arr1, "");
			table.insert(arr1, "But you can donate to show your support and help the game grow!");
			table.insert(arr1, "As thanks, there are some fun cosmetic extras available to those who donate.");
			table.insert(arr1, "");
			table.insert(arr1, "You can increase your donation at any time, so give as much or as little as you want.");
			table.insert(arr1, "Press any of the tabs below for more information on donation options.");
			table.insert(arr1, "");
			table.insert(arr1, "");
		end
		
		function wndmc:showInfo()
			cleanGroup(content);
			for i=1,#arr1 do
				local text = arr1[i];
				local dtxt = display.newText(content, text, 0, 18*(i-#arr1/2-0.5)*scaleGraphics, fontMain, 10*scaleGraphics);
				if(text:find("H1", 1)~=nil)then
					dtxt:setTextColor(237/255, 198/255, 80/255);
					dtxt.text = text:gsub("H1", "");
				end
				if(text:find("H2", 1)~=nil)then
					dtxt:setTextColor(1/2, 1/2, 1/2, 1/2);
					dtxt.text = text:gsub("H2", "");
				end
			end
		end
		wndmc:showInfo();
		
		local wndbg = add_bg_title("bg_3", w, #arr1*18*scaleGraphics + 20*scaleGraphics, get_txt('donations_extras'));
		wndbg.x, wndbg.y = 0, 0;
		wndmc:insert(wndbg);
		wndbg:toBack();
		
		local closemc = display.newImage(wndmc, "image/button/cancel.png");
		closemc:scale(scaleGraphics/2, scaleGraphics/2);
		closemc.w, closemc.h = closemc.contentWidth, closemc.contentHeight;
		table.insert(localGroup.buttons, closemc);
		elite.addOverOutBrightness(closemc);
		closemc.act = function()
			localGroup:actEscape();
		end
		closemc.x, closemc.y = wndbg.w/2-16*scaleGraphics, -wndbg.h/2+16*scaleGraphics;
			
			
		local tabs = newGroup(wndmc);
		local arr = {};
		tabs:toBack();
		local function addTab(callback)
			local tw, th = 40*scaleGraphics, 50*scaleGraphics;
			local btn = newGroup(tabs);
			-- local bar = add_bar("black_bar3", tw);
			local bg = display.newRect(btn, 0, 0, tw-2, 6*scaleGraphics);
			bg.y = -th/2 + bg.height/2 + 4;
			bg:setFillColor(0);
			local bar = add_bg("bg_3", tw, th, true);
			bar:removeTop();
			bar.x, bar.y = 0, -4*scaleGraphics;
			btn:insert(bar);
			btn.x, btn.y = tx, wndbg.h/2 + 18*scaleGraphics;
			
			btn.w, btn.h = tw, tw;
			table.insert(localGroup.buttons, btn);
			elite.addOverOutBrightness(btn);
			btn.act = function()
				for i=1,#arr do
					tabs:insert(arr[i]);
				end
				wndmc:insert(btn);
				if(callback)then
					callback();
				end
			end
			
			table.insert(arr, btn);
			elite.arrangeGroup(tabs, 44*scaleGraphics);
			
			return btn;
		end
		------------------------
		function wndmc:showSilver()
			cleanGroup(content);
			local txts = {};
			table.insert(txts, "Your generosity keeps both the game and its developers going.");
			-- table.insert(txts, "But you can donate to show your support and help the game grow!");
			-- table.insert(txts, "As thanks, there are some fun cosmetic extras available to those who donate.");
			-- table.insert(txts, "You can increase your donation at any time, so give as much or as little as you want.");
			-- table.insert(txts, "Press any of the tabs below for more information on donation options.");

			for i=1,#txts do
				local txt = display.newText(content, txts[i], 0, 18*(i-#txts/2-0.5)*scaleGraphics, fontMain, 10*scaleGraphics);
			end
		end
		local minw = 80*scaleGraphics;
		function wndmc:addBuyBtn(val, sign, text, act)
			local btn = newGroup(content);
			btn.x, btn.y = 0, wndbg.h/2 - 16*scaleGraphics;
			local txt = display.newText(btn, text.."   "..sign..val, 0, 0, fontMain, 12*scaleGraphics);
			
			minw = math.max(minw, txt.width + 10*scaleGraphics);
			local bar = add_bar("black_bar3", minw);
			btn:insert(bar);
			bar:toBack();
			
			function btn:setText(text2)
				txt.text = text2;
				minw = math.max(minw, txt.width + 10*scaleGraphics);
				bar:removeSelf();
				bar = add_bar("black_bar3", minw);
				btn:insert(bar);
				bar:toBack();
			end
			function btn:check(donation)
				if(save_obj.donation)then
					if(save_obj.donation>=donation)then
						btn:setText(get_txt('owned'));
						-- btn:setText('-----');
						btn.disabled = true;
					end
				end
			end
			
			btn.w, btn.h = bar.w, bar.h;
			table.insert(localGroup.buttons, btn);
			elite.addOverOutBrightness(btn, bar);
			btn.act = act;
			return btn;
		end
		local function doDonation(val, item_id)
			-- show_loading();
			eliteShop:buyItem(item_id, function(new_item_id)
				hide_loading(function()
					show_msg(get_txt("bought")..': '..new_item_id);
				end);
			end);
		end
		local function handleTxts(txts)
			for i=1,#txts do
				local text = txts[i];
				local dtxt = display.newText(content, text, 0, 18*(i - #arr1/2 - 0.5)*scaleGraphics, fontMain, 10*scaleGraphics);
				if(text:find("H1", 1)~=nil)then
					dtxt:setTextColor(237/255, 198/255, 80/255);
					dtxt.text = text:gsub("H1", "");
				end
				if(text:find("H2", 1)~=nil)then
					dtxt:setTextColor(1/2, 1/2, 1/2, 1/2);
					dtxt.text = text:gsub("H2", "");
				end
			end
			-- relic1txt:setTextColor(237/255, 198/255, 80/255);
		end
		
		------------------------
		if(options_steam)then
			wndmc:addBuyBtn(5, "$", get_txt('donation_btn'), function()
				system.openURL("https://store.steampowered.com/app/1004120");
			end);
		elseif(optionsBuild == "mac")then
			
		else
			local tab1 = addTab(function()
				wndbg:setText(get_txt("donations_extras"));
				wndmc:showInfo();
			end);
			local ico = display.newImage(tab1, "image/gui/book_rewads.png");
			ico:scale(scaleGraphics/2, scaleGraphics/2);
			------------------------
			local tab = addTab(function()
				wndbg:setText(get_txt("donation_silver"));
				cleanGroup(content);
				
				local txts = {};
				table.insert(txts, "Your generosity keeps both the game and its developers going.");
				table.insert(txts, "Branded Armor icon in game.");
				table.insert(txts, "");
				table.insert(txts, "H1Medal");
				table.insert(txts, "A Medal on the score screen.");
				table.insert(txts, "H2Gravestones");
				table.insert(txts, "H2Lootable remains from your fallen heroes now appear in your current run.");
				handleTxts(txts);
				
				local dbtn = wndmc:addBuyBtn(5, "$", get_txt('donation_btn'), function()
					doDonation(1, 'pack_silver');
					localGroup:actEscape();
				end);
				dbtn:check(1);
			end);
			local ico = display.newImage(tab, "image/gui/win_1.png", 0, 6*scaleGraphics);
			ico:scale(scaleGraphics/2, scaleGraphics/2);
			------------------------
			local tab = addTab(function()
				wndbg:setText(get_txt("donation_gold"));
				cleanGroup(content);
				
				local txts = {};
				table.insert(txts, "Generous donations give me more resources to improve the game.");
				table.insert(txts, "Includes Silver Rewards.");
				table.insert(txts, "");
				table.insert(txts, "H1Rename Equipment");
				table.insert(txts, "Give your favourite gear epic custom names!");
				table.insert(txts, "Recolor Cards");
				table.insert(txts, "You can change color of decks.");
				-- table.insert(txts, "Hall of Heroes");
				-- table.insert(txts, "Four separate rankings pages with support for custom notes!");
				handleTxts(txts);
				
				local dbtn = wndmc:addBuyBtn(10, "$", get_txt('donation_btn'), function()
					doDonation(2, 'pack_gold');
					localGroup:actEscape();
				end);
				dbtn:check(2);
			end);
			local ico = display.newImage(tab, "image/gui/win_2.png", 0, 6*scaleGraphics);
			ico:scale(scaleGraphics/2, scaleGraphics/2);
			------------------------
			local tab = addTab(function()
				wndbg:setText(get_txt("donation_amber"));
				cleanGroup(content);
				
				local txts = {};
				table.insert(txts, "Available if you truly want to spend his much to support the game!");
				table.insert(txts, "Includes Golden Rewards.");
				table.insert(txts, "");
				table.insert(txts, "H1Name your Heroes");
				table.insert(txts, "You can rename your heroes as you wish.");
				-- table.insert(txts, "");
				table.insert(txts, "Recolor your Heroes");
				table.insert(txts, "Change a color of scin, dress, hair as you wish.");
				handleTxts(txts);
				
				local dbtn = wndmc:addBuyBtn(20, "$", get_txt('donation_btn'), function()
					doDonation(3, 'pack_amber');
					localGroup:actEscape();
				end);
				dbtn:check(3);
			end);
			local ico = display.newImage(tab, "image/gui/win_3.png", 0, 6*scaleGraphics);
			ico:scale(scaleGraphics/2, scaleGraphics/2);
			
			wndmc:insert(tab1);
		end
		
		local rectbg = display.newRect(wndmc, 0, 0, _W, _H);
		rectbg:setFillColor(0, 0, 0, 2/3);
		rectbg:toBack();
		
		rectbg.w, rectbg.h = _W, _H;
		table.insert(localGroup.buttons, rectbg);
		-- elite.addOverOutBrightness(btn, bar);
		rectbg.act = function()
			localGroup:actEscape();
		end
		removeHint();
		
		-- rectbg:addEventListener("tap", function(e)
			-- localGroup:actEscape();
			-- return true
		-- end);
	end
	-- show_donat();
	if(options_shop_enabled)then
		local donat = addRoaylBtn(_W-ts*3, _H-ts, "appreciation", function()
			show_donat();
		end, "image/gui/coffee_big.png");
	end
	
	local extra_options_mc = newGroup(localGroup);
	extra_options_mc.x, extra_options_mc.y = 120*scaleGraphics, _H-180*scaleGraphics;
	local extra_bg = add_bg_title("bg_in", 110*scaleGraphics, 240*scaleGraphics, get_txt('options'), 2);
	extra_options_mc:insert(extra_bg);
	extra_bg.x, extra_bg.y = 0,0;
	
	local function add_small_button(tar_mc, fname, utype, tx, ty, act, hint)
		local fire_mc = newGroup(tar_mc);
		fire_mc.w, fire_mc.h = 10*scaleGraphics,10*scaleGraphics
		fire_mc.xScale, fire_mc.yScale = scaleGraphics/2, scaleGraphics/2;
		fire_mc.x, fire_mc.y = tx, ty
		local body=display.newImage(fire_mc, fname..".png");
		body.x, body.y = 0,0;
		
		fire_mc.utype = utype;
		fire_mc._selected = false;
		fire_mc._over = display.newImage(fire_mc, fname.."_.png");
		fire_mc._over.x, fire_mc._over.y = 0,0;
		
		fire_mc.w, fire_mc.h = 20*scaleGraphics, 20*scaleGraphics;
		table.insert(localGroup.buttons, fire_mc);
		elite.addOverOutBrightness(fire_mc);
		fire_mc.act = function()
			if(act)then act(); end
			return true
		end
		return fire_mc;
	end
	
	local mini_dd = 26*scaleGraphics;
	local troops_bars_w = 62*scaleGraphics;
	if(true)then
		local troops_mc = newGroup(extra_options_mc);
		local troop_lvl_bg = add_bar("price_bar", troops_bars_w);
		troop_lvl_bg.x, troop_lvl_bg.y = 0, -extra_bg.h/2 + (40 + 0*40)*scaleGraphics;
		troops_mc:insert(troop_lvl_bg);
		
		local troop_lvl_bar = display.newImage(troops_mc, "image/gui/red1s_m.png");
		troop_lvl_bar.xScale, troop_lvl_bar.yScale = scaleGraphics/2, scaleGraphics/2;
		troop_lvl_bar.x, troop_lvl_bar.y = troop_lvl_bg.x, troop_lvl_bg.y
		local tdtxt = display.newText(troops_mc, get_txt('master_volume'), 0, troop_lvl_bg.y+txt_number_offset-16*scaleGraphics, fontMain, 12*scaleGraphics);
		local troop_lvl_dtxt = display.newText(troops_mc, "100%", 0, 0, fontNumbers, 10*scaleGraphics);
		troop_lvl_dtxt.x, troop_lvl_dtxt.y = troop_lvl_bg.x, troop_lvl_bg.y+txt_number_offset;

		local btn = add_small_button(troops_mc, "image/gui/btnMinus", 'volume_down', troop_lvl_bg.x - mini_dd, troop_lvl_bg.y, function() 
			audio.setVolume(math.max(audio.getVolume() - 0.1, 0));
			localGroup:refreshVolume();
			sound_play("pack_click");
			require("eliteScale").saveScales();
		end);
		local btn = add_small_button(troops_mc, "image/gui/btnDonat", 'volume_up', troop_lvl_bg.x + mini_dd, troop_lvl_bg.y, function() 
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
	
	if(true)then -- gui size
		local troops_mc = newGroup(extra_options_mc);
		local troop_lvl_bg = add_bar("price_bar", troops_bars_w);
		troop_lvl_bg.x, troop_lvl_bg.y = 0, -extra_bg.h/2 + (40 + 1*40)*scaleGraphics;
		troops_mc:insert(troop_lvl_bg);
		
		local troop_lvl_bar = display.newImage(troops_mc, "image/gui/blue1s_m.png");
		troop_lvl_bar.xScale, troop_lvl_bar.yScale = scaleGraphics/2, scaleGraphics/2;
		troop_lvl_bar.x, troop_lvl_bar.y = troop_lvl_bg.x, troop_lvl_bg.y
		local tdtxt = display.newText(troops_mc, get_txt('gui_size'), 0, troop_lvl_bg.y+txt_number_offset-16*scaleGraphics, fontMain, 12*scaleGraphics);
		fitTextFildByW(tdtxt, extra_bg.w - 2*scaleGraphics);
		local troop_lvl_dtxt = display.newText(troops_mc, "100%", 0, 0, fontNumbers, 10*scaleGraphics);
		troop_lvl_dtxt.x, troop_lvl_dtxt.y = troop_lvl_bg.x, troop_lvl_bg.y+txt_number_offset;

		add_small_button(troops_mc, "image/gui/btnMinus", 'gui_size_down', troop_lvl_bg.x - mini_dd, troop_lvl_bg.y, function() 
			_G.scaleGraphics = _G.scaleGraphics-0.1;
			sound_play("pack_click");
			show_menu(true);
			-- director:changeScene('src.screenMenu');
			-- local current_mc = director:getCurrHandler();
			-- current_mc.options_mc:switch();
			require("eliteScale").saveScales();
		end);
		add_small_button(troops_mc, "image/gui/btnDonat", 'gui_size_up', troop_lvl_bg.x + mini_dd, troop_lvl_bg.y, function() 
			_G.scaleGraphics = _G.scaleGraphics+0.1;
			sound_play("pack_click");
			show_menu(true);
			-- director:changeScene('src.screenMenu');
			-- local current_mc = director:getCurrHandler();
			-- current_mc.options_mc:switch();
			require("eliteScale").saveScales();
		end);

		function localGroup:refreshGuiSize()
			local full_w = 3*scaleGraphics;
			troop_lvl_bar.xScale = (full_w)*1/1;
			troop_lvl_bar.x = -26*scaleGraphics+troop_lvl_bar.contentWidth/2;
			troop_lvl_dtxt.text = tostring(math.round(_G.scaleGraphics*100)).."%";
			tdtxt.text = get_txt('gui_size');
			extra_bg.dtxt.text = get_txt('options');
		end
		localGroup:refreshGuiSize();
	end
	
	if(settings.saveBorderBot==nil)then settings.saveBorderBot = 0; end
	if(true)then -- save size
		local troops_mc = newGroup(extra_options_mc);
		local troop_lvl_bg = add_bar("price_bar", troops_bars_w);
		troop_lvl_bg.x, troop_lvl_bg.y = 0,-extra_bg.h/2 + (40 + 2*40)*scaleGraphics;
		troops_mc:insert(troop_lvl_bg);
		
		local troop_lvl_bar = display.newImage(troops_mc, "image/gui/blue1s_m.png");
		troop_lvl_bar.xScale, troop_lvl_bar.yScale = scaleGraphics/2, scaleGraphics/2;
		troop_lvl_bar.x, troop_lvl_bar.y = troop_lvl_bg.x, troop_lvl_bg.y
		local tdtxt = display.newText(troops_mc, get_txt('bottom_delta'), 0, troop_lvl_bg.y+txt_number_offset-16*scaleGraphics, fontMain, 12*scaleGraphics);
		fitTextFildByW(tdtxt, extra_bg.w - 2*scaleGraphics);
		local troop_lvl_dtxt = display.newText(troops_mc, settings.saveBorderBot, 0, 0, fontNumbers, 10*scaleGraphics);
		troop_lvl_dtxt.x, troop_lvl_dtxt.y = troop_lvl_bg.x, troop_lvl_bg.y+txt_number_offset;

		local function refresh()
			local full_w = 3*scaleGraphics;
			troop_lvl_bar.xScale = (full_w)*1/1;
			troop_lvl_bar.x = -26*scaleGraphics+troop_lvl_bar.contentWidth/2;
			troop_lvl_dtxt.text = tostring(settings.saveBorderBot);
			tdtxt.text = get_txt('bottom_delta');
		end
		
		add_small_button(troops_mc, "image/gui/btnMinus", 'down', troop_lvl_bg.x - mini_dd, troop_lvl_bg.y, function() 
			settings.saveBorderBot = settings.saveBorderBot-10;
			hintGroup.y = -settings.saveBorderBot;
			refresh();
			sound_play("pack_click");
			addHint('test: '..get_txt('forge_hint'));
			saveSettings();
		end);
		add_small_button(troops_mc, "image/gui/btnDonat", 'up', troop_lvl_bg.x + mini_dd, troop_lvl_bg.y, function() 
			settings.saveBorderBot = settings.saveBorderBot+10;
			hintGroup.y = -settings.saveBorderBot;
			refresh();
			sound_play("pack_click");
			addHint('test: '..get_txt('forge_hint'));
			saveSettings();
		end);

		
		refresh();
	end
	
	
	-- local function add_small_switcher(tar_mc, fname1, fname2, utype, tx, ty, act, bol)
		-- local btn = newGroup(tar_mc);
		-- btn.xScale, btn.yScale = scaleGraphics/2, scaleGraphics/2;
		-- btn.x, btn.y = tx, ty
		-- local body;
		-- function btn:refresh()
			-- if(body)then
				-- body:removeSelf();
			-- end
			-- if(bol())then
				-- body=display.newImage(btn, fname1..".png");
			-- else
				-- body=display.newImage(btn, fname2..".png");
			-- end
		-- end
		-- btn:refresh();
		-- return btn;
	-- end
	
	do 
		local isx, idy = 40*scaleGraphics, 20*scaleGraphics;
		elite.addCheckboxOption(extra_options_mc, get_txt('relic_names'), get_txt("relic_names_hint"), extra_bg.w, 0, isx + idy*0, "image/gui/btnPlus", "image/gui/btnMinus", localGroup.buttons, function()
			return _G.settings.relicNames==true;
		end, function()
			_G.settings.relicNames = not _G.settings.relicNames;
			saveSettings();
		end);
		
		elite.addCheckboxOption(extra_options_mc, get_txt('fit_all_cards'), get_txt("fit_all_cards_hint"), extra_bg.w, 0, isx + idy*1, "image/gui/btnPlus", "image/gui/btnMinus", localGroup.buttons, function()
			return _G.settings.fitAllCards~=true;
		end, function()
			_G.settings.fitAllCards = not _G.settings.fitAllCards;
			saveSettings();
		end);
		
		elite.addCheckboxOption(extra_options_mc, get_txt('gui_mana_top'), get_txt("gui_mana_top_hint"), extra_bg.w, 0, isx + idy*2, "image/gui/btnPlus", "image/gui/btnMinus", localGroup.buttons, function()
			return _G.settings.manaTop == true;
		end, function()
			_G.settings.manaTop = not _G.settings.manaTop;
			saveSettings();
		end);
		
		elite.addCheckboxOption(extra_options_mc, get_txt('gui_dragdrop'), get_txt("gui_dragdrop_hint"), extra_bg.w, 0, isx + idy*3, "image/gui/btnPlus", "image/gui/btnMinus", localGroup.buttons, function()
			return _G.settings.dragAndDrop == true;
		end, function()
			_G.settings.dragAndDrop = not _G.settings.dragAndDrop;
			saveSettings();
		end);
	end
	
	function localGroup:show_saves()
		if(facemc.wnd)then
			facemc.wnd:removeSelf();
			facemc.wnd = nil;
			return
		end
		
		local wnd_mc = add_bg_title("bg_in", 320*scaleGraphics, 230*scaleGraphics, get_txt('royalcloud'));
		wnd_mc.x = _W/2 - wnd_mc.w*0/2;
		wnd_mc.y = _H/2 - wnd_mc.h*0/2;
		wnd_mc.utype = 'saves';
		facemc.wnd = wnd_mc;
		
		local wnd_bg = display.newRect(localGroup, _W/2, _H/2, _W, _H);
		wnd_bg:setFillColor(0, 0, 0, 0.9);
		transition.from(wnd_bg, {time=250, alpha=0, onComplete=function()
			if(wnd_mc.insert)then
				wnd_mc:insert(wnd_bg);
				wnd_bg.x, wnd_bg.y = 0, 0;
				wnd_bg:toBack();
			end
		end});
		transition.from(wnd_mc, {time=200, x=-wnd_mc.w});
		localGroup:insert(wnd_mc);
		
		
		local close_btn = display.newImage(wnd_mc, "image/button/cancel.png");
		close_btn.xScale, close_btn.yScale = scaleGraphics/2, scaleGraphics/2;
		close_btn.x, close_btn.y = wnd_mc.w/2-34*scaleGraphics/2, -wnd_mc.h/2+34*scaleGraphics/2;
		
		close_btn.w, close_btn.h = 30*scaleGraphics, 30*scaleGraphics;
		table.insert(localGroup.buttons, close_btn);
		-- function close_btn:onOver()
			-- close_btn.xScale, close_btn.yScale = scaleGraphics/1.9, scaleGraphics/1.9;
		-- end
		-- function close_btn:onOut()
			-- close_btn.xScale, close_btn.yScale = scaleGraphics/2, scaleGraphics/2;
		-- end
		elite.addOverOutBrightness(close_btn);
		close_btn.act = function()
			localGroup:actEscape();
			return true
		end
		
		if(options_desctop)then
			local folder_mc = add_bar("black_bar", 160*scaleGraphics);
			folder_mc.y = wnd_mc.h/2 - 20*scaleGraphics;
			wnd_mc:insert(folder_mc);
			local dtxt = display.newText(folder_mc, get_txt('open_save_folder'), 0, 0, fontMain, 20*scaleGraphics);
			fitTextFildByW(dtxt, folder_mc.w);
			while(dtxt.width>150*scaleGraphics)do
				dtxt.size = dtxt.size-1;
			end
			
			table.insert(localGroup.buttons, folder_mc);
			elite.addOverOutBrightness(folder_mc);
			folder_mc.act=function()
				local path = system.pathForFile("save04.json", system.DocumentsDirectory);
				system.openURL(system.pathForFile(nil, system.DocumentsDirectory));
				return true
			end
		end
		
		if(settings.playerName==nil)then settings.playerName="(John Doe)"; end
		if(settings.playerPIN==nil)then settings.playerPIN="0000"; end
		
		local itxtY=-wnd_mc.h/2+40*scaleGraphics;
		local uid_itxt = elite.newNativeText(wnd_mc, -45*scaleGraphics, itxtY, 100*scaleGraphics, 20*scaleGraphics, function(str)
			settings.playerName=str;
			saveSettings();
		end, true);
		local pid_itxt = elite.newNativeText(wnd_mc, 55*scaleGraphics, itxtY, 80*scaleGraphics, 20*scaleGraphics, function(str)
			settings.playerPIN=str;
			saveSettings();
		end, true);
		
		-- local uid_itxt = native.newTextField(0, 0, 100*scaleGraphics, 20*scaleGraphics);
		-- uid_itxt.x, uid_itxt.y = -45*scaleGraphics, 0;
		uid_itxt.align = 'center';
		uid_itxt.placeholder = "(John Doe)"
		uid_itxt.text = settings.playerName;
		uid_itxt.inputType = "default";
		-- wnd_mc:insert(uid_itxt);
		-- table.insert(localGroup.natives, uid_itxt);
		
		-- local pid_itxt = native.newTextField(0, 0, 80*scaleGraphics, 20*scaleGraphics);
		-- pid_itxt.x, pid_itxt.y = 55*scaleGraphics, 0;
		pid_itxt.align = 'center';
		pid_itxt.placeholder = "0000"
		pid_itxt.text = settings.playerPIN;
		pid_itxt.inputType = "number";
		-- pid_itxt.isSecure = true;
		-- wnd_mc:insert(pid_itxt);
		-- table.insert(localGroup.natives, pid_itxt);
		
		local uid_dtxt = display.newText(wnd_mc, get_txt('login'), 0, 0, fontMain, 20*scaleGraphics);
		uid_dtxt.x, uid_dtxt.y = -wnd_mc.x + uid_itxt.x, -wnd_mc.y + uid_itxt.y-20*scaleGraphics;
		local pid_dtxt = display.newText(wnd_mc, get_txt('pin'), 0, 0, fontMain, 20*scaleGraphics);
		pid_dtxt.x, pid_dtxt.y = -wnd_mc.x + pid_itxt.x, -wnd_mc.y + pid_itxt.y-20*scaleGraphics;
		
		if(settings.cloudAutoSave==nil)then settings.cloudAutoSave = false; end
		if(settings.cloudAutoLoad==nil)then settings.cloudAutoLoad = false; end
		
		elite.addCheckboxOption(wnd_mc, get_txt('cloud_auto_save'), get_txt("cloud_auto_save_hint"), 140*scaleGraphics, 0, itxtY+58*scaleGraphics, "image/gui/btnPlus", "image/gui/btnMinus", localGroup.buttons, function()
			return settings.cloudAutoSave==true;
		end, function()
			settings.cloudAutoSave = not settings.cloudAutoSave;
			saveSettings();
		end);
		-- elite.addCheckboxOption(wnd_mc, get_txt('cloud_auto_load'), get_txt("cloud_auto_load_hint"), 140*scaleGraphics, 0, itxtY+80*scaleGraphics, "image/gui/btnPlus", "image/gui/btnMinus", localGroup.buttons, function()
			-- return settings.cloudAutoLoad==true;
		-- end, function()
			-- settings.cloudAutoLoad = not settings.cloudAutoLoad;
			-- saveSettings();
		-- end);
		
		local hint_dtxt = display.newText({parent=wnd_mc, text=get_txt('cloud_input_hint'), width=wnd_mc.w - 10*scaleGraphics, font=fontMain, fontSize=12*scaleGraphics, align='center'});
		hint_dtxt.y = itxtY + 96*scaleGraphics + hint_dtxt.contentHeight/2;
		
		local function check_input()
			if(uid_itxt.text==uid_itxt.placeholder or #uid_itxt.text<6)then
				local arts_hint_dtxt = uid_dtxt;
				arts_hint_dtxt.fill.effect = "filter.brightness";
				arts_hint_dtxt.fill.effect.intensity = 1.0;
				transition.to(arts_hint_dtxt.fill.effect,{intensity=0, time=200, transition=easing.outQuad, onComplete=function(obj)
					obj.intensity = 1;
					
					transition.to(arts_hint_dtxt.fill.effect,{intensity=0, time=200, transition=easing.outQuad, onComplete=function(obj)
						obj.intensity = 1;
					end});
					transition.to(arts_hint_dtxt.fill.effect,{intensity=0, delay=250, time=200, transition=easing.outQuad});
				
				end});
				transition.to(arts_hint_dtxt.fill.effect,{intensity=0, delay=250, time=200, transition=easing.outQuad});
				arts_hint_dtxt:setTextColor(1,0,0);
				return true
			end
			uid_dtxt:setTextColor(1);
			
			if(pid_itxt.text=="0000" or #pid_itxt.text~=4)then
				local arts_hint_dtxt = pid_dtxt;
				arts_hint_dtxt.fill.effect = "filter.brightness";
				arts_hint_dtxt.fill.effect.intensity = 1.0;
				transition.to(arts_hint_dtxt.fill.effect,{intensity=0, time=200, transition=easing.outQuad, onComplete=function(obj)
					obj.intensity = 1;
					
					transition.to(arts_hint_dtxt.fill.effect,{intensity=0, time=200, transition=easing.outQuad, onComplete=function(obj)
						obj.intensity = 1;
					end});
					transition.to(arts_hint_dtxt.fill.effect,{intensity=0, delay=250, time=200, transition=easing.outQuad});
				
				end});
				transition.to(arts_hint_dtxt.fill.effect,{intensity=0, delay=250, time=200, transition=easing.outQuad});
				arts_hint_dtxt:setTextColor(1,0,0);
				return true
			end
			pid_dtxt:setTextColor(1);
			
			settings.playerName=uid_itxt.text;
			settings.playerPIN=pid_itxt.text;
			saveSettings();
			
			return false
		end
		
		local load_mc = add_bar("black_bar", 80*scaleGraphics);
		load_mc.x, load_mc.y = -50*scaleGraphics, itxtY+30*scaleGraphics;
		wnd_mc:insert(load_mc);
		local dtxt = display.newText(load_mc, get_txt('load'), 0, 0, fontMain, 20*scaleGraphics);
		
		table.insert(localGroup.buttons, load_mc);
		elite.addOverOutBrightness(load_mc);
		-- function load_mc:onOver()
			-- dtxt:setTextColor(1, 1, 0.5);
		-- end
		-- function load_mc:onOut()
			-- dtxt:setTextColor(1);
		-- end
		load_mc.act = function()
			if(check_input())then
				return true
			end
			loadCloud(facemc);
			localGroup:closeWnd();
			return true
		end
		
		local save_mc = add_bar("black_bar", 80*scaleGraphics);
		save_mc.x, save_mc.y = 50*scaleGraphics, load_mc.y;
		wnd_mc:insert(save_mc);
		local dtxt = display.newText(save_mc, get_txt('sync'), 0, 0, fontMain, 20*scaleGraphics);
		
		table.insert(localGroup.buttons, save_mc);
		elite.addOverOutBrightness(save_mc);
		-- function save_mc:onOver()
			-- dtxt:setTextColor(1, 1, 0.5);
		-- end
		-- function save_mc:onOut()
			-- dtxt:setTextColor(1);
		-- end
		save_mc.act = function()
			if(check_input())then
				print('input is not correct');
				return true
			end
			print('trying to save to the cloud');
			saveCloud();
			elite.setDisabled(save_mc, true);
			save_mc.alpha = 0.5;
			return true
		end
		-- end);
		if(false)then
			local clear_mc = add_bar("black_bar", 80*scaleGraphics);
			clear_mc.x, clear_mc.y = -load_mc.x,30*scaleGraphics;
			wnd_mc:insert(clear_mc);
			local dtxt = display.newText(clear_mc, get_txt('clear'), 0, 0, fontMain, 20*scaleGraphics);
			
			
			table.insert(localGroup.buttons, clear_mc);
			function clear_mc:onOver()
				dtxt:setTextColor(1, 1, 0.5);
			end
			function clear_mc:onOut()
				dtxt:setTextColor(1);
			end
			clear_mc.act = function()
				for i=1,3 do
					os.remove( system.pathForFile(options_save_fname..".cloud", system.DocumentsDirectory ));
				end
				show_msg('Local cloud saves was cleared.');
				show_menu();
			end
		end
	end
	
	extra_options_mc.isVisible = false;
	local pause_switch;
	pause_switch = function(pause_btn)
		if(facemc.optionsmc)then
			facemc.optionsmc:removeSelf();
			facemc.optionsmc = nil;
			extra_options_mc.isVisible = false;
			return true
		end
		local wnd = newGroup(facemc);

		local dy = 44*scaleGraphics;
		
		extra_options_mc.isVisible = true;-- and not options_mobile;
		
		addRoundBtn(wnd, "music",  pause_btn.x, pause_btn.y - 12*scaleGraphics - 1*dy, "image/gui/btn_music.png", eliteSoundsIns.switchMusic, "image/gui/btn_music_off.png", eliteSoundsIns.getMusicBol);
		addRoundBtn(wnd, "sound",  pause_btn.x, pause_btn.y - 12*scaleGraphics - 2*dy, "image/gui/btn_sound.png", eliteSoundsIns.switchSound, "image/gui/btn_sound_off.png", eliteSoundsIns.getSoundBol);
		addRoundBtn(wnd, "saves",pause_btn.x, pause_btn.y - 12*scaleGraphics - 3*dy, "image/gui/btn_save.png", localGroup.show_saves);
		addRoundBtn(wnd, "credits",pause_btn.x, pause_btn.y - 12*scaleGraphics - 4*dy, "image/gui/btn_credits.png", show_credits);
		addRoundBtn(wnd, "changelog",pause_btn.x, pause_btn.y - 12*scaleGraphics - 5*dy, "image/gui/btn_version.png", show_versionlog);
		
		addRoundBtn(wnd, "discord",pause_btn.x, pause_btn.y - 12*scaleGraphics - 6*dy, "image/gui/discord.png", function()
			system.openURL("https://discord.gg/j5e7fYd");--https://discord.gg/j5e7fYd
		end);

		if(options_mobile)then
			local btnSizeY = math.max(pause_btn.y - 12*scaleGraphics - 7*dy, 30*scaleGraphics);
			local btn = addRoaylBtn(ts/2+ts*1, btnSizeY, "minus", function()
				_G.scaleGraphics = _G.scaleGraphics-0.1;
				if(scaleGraphics>2)then _G.scaleGraphics = _G.scaleGraphics-0.1; end
				show_msg(get_txt('scale')..": "..(scaleGraphics*100).."%")
				show_menu(true);
				require("eliteScale").saveScales();
				return
			end, "image/button/minus.png");
			wnd:insert(btn);
			
			local btn = addRoaylBtn(ts/2+ts*0, btnSizeY, "plus", function()
				_G.scaleGraphics = _G.scaleGraphics+0.1;
				if(scaleGraphics>2)then _G.scaleGraphics = _G.scaleGraphics+0.1; end
				show_msg(get_txt('scale')..": "..(scaleGraphics*100).."%")
				show_menu(true);
				require("eliteScale").saveScales();
				return
			end, "image/button/plus.png");
			wnd:insert(btn);
		end
		
		local lang_list_tw = 30*scaleGraphics;
		local lang_list_arr = language:getList();
		local lang_list_mc = language:showList(0, 0, lang_list_tw, 0, scaleGraphics);
		wnd:insert(lang_list_mc);
		lang_list_mc.x, lang_list_mc.y = _W/2-(#lang_list_arr-1)*lang_list_tw/2, _H - (12+options_save_border_h)*scaleGraphics - 12*scaleGraphics;
		function language:act()
			royal:exeLangListeners();
			show_menu();
		end
		
		facemc.optionsmc = wnd;
	end
	
	if(settings.saveBorderBot==nil)then
		settings.saveBorderBot=0;
	end
	if(settings.saveBorderBot~=0)then
		hintGroup.y = -settings.saveBorderBot;
	end

	local optionsX, optionsY = ts, _H-ts;
	local pause_btn = addRoundBtn(facemc, "options", optionsX, optionsY, "image/gui/btn_gear.png", pause_switch);
	pause_btn.disabled = nil;
	
	if(options)then
		pause_switch(pause_btn);
	end
	
	if(_G.save_obj.druid_admin)then
		if(mainGroup.uploadOnce~=true)then
			mainGroup.uploadOnce = true;
			royal:uploadTempCards("druid");
		end
	end
	
	function localGroup:closeWnd()
		if(facemc.wnd)then
			transition.to(facemc.wnd, {time=300, alpha=0, onComplete=transitionRemoveSelfHandler});
			facemc.wnd = nil;
		end
	end
	function localGroup:actEscape()
		if(facemc.wnd)then
			transition.to(facemc.wnd, {time=300, alpha=0, onComplete=transitionRemoveSelfHandler});
			facemc.wnd = nil;
		else
			show_exit();
		end
		return true;
	end
	function localGroup:actRight()
		localGroup:actEscape();
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end