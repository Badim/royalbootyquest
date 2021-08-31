module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "end";
	
	-- firebase rules:
	-- {
	  -- /* Visit https://firebase.google.com/docs/database/security to learn more about security rules. */
	  -- "rules": {
		-- ".read": true,
		-- "scores":{
		  -- ".indexOn": ["score","floors","class","hpmax","cards","items","nick"],
		  -- "$scores_id": {
			-- ".write": true,
			-- ".validate":"!data.exists()",
			-- "nick" : {
			  -- ".validate" : "newData.isString() && newData.val().length < 14"
			-- },
			-- "score" : {
			  -- ".validate": "newData.isNumber() && newData.val() > 5"
			-- }
		 -- }
		-- }
	  -- }
	-- }

	
	local background = display.newImage(localGroup, "image/background/rallyScreen.jpg");
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
	
	local rb = display.newRect(gamemc, _W/2, _H/2, _W, _H);
	rb:setFillColor(0,0,0,0.3);
	
	local bgi = 14;
	local bg = add_bg_title("bg_3", 400*scaleGraphics, bgi*14*scaleGraphics + 26*scaleGraphics, get_txt('scores'));
	bg.x, bg.y = _W/2, _H/2;
	gamemc:insert(bg);
	
	local bg2 = add_bg_title("bg_3", (#_itemAchievement._list*26 + 16)*scaleGraphics, 36*scaleGraphics, get_txt('achievements'));
	bg2.x, bg2.y = _W/2, bg.y - bg.h/2 - 30*scaleGraphics;
	gamemc:insert(bg2);
	
	-- local obj = {};
	-- obj.item_id = item_id;
	-- obj.ico_patch=localGroup.icos_patch..item_id..'.png';
	-- obj.ios_id = ios_id;
	-- obj.steam_id = steam_lid or steam_id;
	-- _itemAchievement._list
	-- local unlocks = _itemAchievement:getAchievments();
	
	
	
	local achievements_unlocked = 0;
	local achsmc = newGroup(facemc);
	for i=1,#_itemAchievement._list do
		local obj = _itemAchievement._list[i];
		pixelArtOn();
		local mc = display.newImage(achsmc, "image/achs/"..obj.item_id..".png");
		if(mc==nil)then
			mc = display.newImage(achsmc, "image/achs/_noico.png");
		end
		mc:scale(scaleGraphics/2, scaleGraphics/2);
		pixelArtOff();
		-- if(unlocks[obj.item_id])then
		if(_itemAchievement:unlocked(obj.item_id))then
			achievements_unlocked = achievements_unlocked+1;
		else
			mc.fill.effect = "filter.grayscale";
			mc.alpha = 0.25;
		end
		mc.x, mc.y = bg.x + (i-#_itemAchievement._list/2-0.5)*26*scaleGraphics, bg2.y + 2*scaleGraphics;
	end
	
	local score_obj = {};
	local scores = 0;
	local txts = newGroup(bg);
	txts.i = 0;
	local function addItemTxt(val1, val2)
		local txt1 = display.newText(txts, val1, -120*scaleGraphics, txts.i*18*scaleGraphics, fontMain, 14*scaleGraphics);
		txt1:translate(txt1.width/2, 0);
		local txt2 = display.newText(txts, val2, 120*scaleGraphics, txts.i*18*scaleGraphics, fontMain, 14*scaleGraphics);
		txt2:translate(-txt2.width/2, 0);
		txts.i = txts.i+1;
		
		txts.y = -18*scaleGraphics*(txts.i-1)/2;
	end
	local function addScore(id, val, hidden)
		local count = getRunStat(id);
		score_obj[id] = count;
		scores = scores + count*val;
		if(hidden~=true or count>0 or options_cheats)then
			addItemTxt(get_txt("stat_"..id).." ("..count..")", count*val);
		end
	end
	addScore("floors", 5); -- Floors Climbed	Number of the Floor you reached (including the narrative Floor 51)	5 per floor
	addScore("kills", 2); -- Enemies Killed	For each normal encounter defeated	2 per enemy
	addScore("elites1", 10, true); -- Exordium Elites Killed	For each killed Elite in the Exordium	10 per Elite
	addScore("elites2", 20, true); -- City Elites Killed	For each killed Elite in the City	20 per Elite
	addScore("elites3", 30, true); -- Beyond Elites Killed	For each killed Elite in the Beyond	30 per Elite
	addScore("bosses", 50); -- Bosses Slain	For each defeated Boss	50 per Boss
	addScore("skulls", 20, true);
	-- Ascension	5% score per Ascension level	5% per level
	-- Champion	Defeat an Elite without taking damage.	25 per Elite
	-- Perfect	Defeat a Boss without taking damage.	50 per Boss
	-- Beyond Perfect	Defeat 3 bosses without taking damage (overrides Perfect).	200
	
	setRunStat("collector", 0); -- Collector	Have 4 copies of any non-starter card.	25 per set
	local collector, rarity = {}, {0,0,0,0};
	local highlander, curses = true, 0;
	for i=1,#login_obj.deck do
		local card = login_obj.deck[i];
		if(card.rarity>0)then
			if(collector[card.tag]==nil)then
				collector[card.tag] = 1;
			else
				collector[card.tag] = collector[card.tag]+1;
			end
		end
		
		local cr = card.rarity/1;
		if(rarity[cr]==nil)then
			rarity[cr] = 1;
		else
			rarity[cr] = rarity[cr]+1;
		end
		if(card.ctype==CTYPE_CURSE)then
			curses = curses+1;
		end
	end
	for attr,val in pairs(collector) do
		print("collector:", attr, val)
		if(val>=4)then
			addRunStat("collector");
		end
		if(val>1)then
			print("highlander fail:", attr, val)
			highlander = false;
		end
	end
	addScore("collector", 25, true);
	
	print("rarity:", rarity[0], rarity[1], rarity[2], rarity[3])
	if(rarity[3]==0)then -- Pauper	Have 0 rare cards.	50
		setRunStat("pauper", 0);
		addRunStat("pauper");
	end
	addScore("pauper", 50, true);
	
	if(highlander)then -- Highlander	Your deck contains no duplicates (excluding starter cards).	100
		setRunStat("highlander", #login_obj.deck);
	end
	addScore("highlander", 2, true);
	
	setRunStat("curses", 0);
	if(curses>4)then
		setRunStat("curses", curses);
	end
	addScore("curses", 20, true);
	
	-- Librarian	Deck size greater than 35 cards.	25
	-- Encyclopedian	Deck size greater than 50 cards (overrides Librarian).	50
	-- Overkill	Deal 99 damage with a single attack.	25
	-- Mystery machine	Traveled to 15+ ? rooms.	25
	-- I Like Shiny	Have 25 or more relics	50
	-- Well Fed	Increased your Max HP by 15 or more	25
	-- Stuffed	Increased your Max HP by 30 or more (overrides Well Fed)	50
	-- Money Money	Accrued 1,000 or more gold.	25
	-- Raining Money	Accrued 2,000 or more gold.	50
	-- I Like Gold	Accrued 3,000 or more gold.	75
	-- C-c-c-combo	Play 20 cards in a single turn.	25
	-- Cursed	Your deck contains 5 curses.	100
	
	-- On My Own Terms	Killed yourself.	50
	setLoginStat("scores", scores);
	if(txts.i<10)then
		addItemTxt("----------------------", "----------------------");
	end
	addItemTxt(get_txt("total"), scores);
	
	local tw, th = 60*scaleGraphics, 20*scaleGraphics;
	local submit = true;
	local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
	
	local function submitFirebase()
		if(royal.db==nil)then
			local firebase = require('firebase');
			royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
		end
		
		local relics_count = 0;
		for attr,val in pairs(login_obj.relics) do
			if(val)then
				relics_count = relics_count+1;
			end
		end

		score_obj.nick = player_name;
		score_obj.custom = save_obj.customName~=nil;
		score_obj.score=scores;
		score_obj.tag = login_obj.tag; 
		score_obj.class = login_obj.class; 
		score_obj.achievements=achievements_unlocked;
		score_obj.build = optionsBuild;
		score_obj.version = optionsVersion;
		score_obj.steam = options_steam;
		score_obj.cards = #login_obj.deck;
		score_obj.items = relics_count;
		score_obj.hpmax = login_obj.hpmax;
		score_obj.hpmaxex = login_obj.hpmaxex;
		score_obj.donation = save_obj.donation;

		submit = true;

		if(login_obj.cheat or login_obj.sandbox)then
			show_msg('modded profiles dont participate in global scores');
			return
		end
		
		do
			local load_str = loadFile("scores_local.json");
			local save_local_scores;
			if(load_str)then
				save_local_scores = json.decode(load_str);
			else
				save_local_scores = {};
				
			end
			table.insert(save_local_scores, score_obj);
			saveFile("scores_local.json", json.encode(save_local_scores));
		end
		
		if(score_obj.score<=10)then
			-- show_msg('score is too low to submit');
			return
		end
		
		if(login_obj.daily)then
			if(login_obj._ordinaldate)then
				royal.db:post("daily/"..login_obj._ordinaldate.."/scores", json.encode(score_obj), nil, function(event)
					print("post@daily", event.isError, event.phase, event.response);
					if(event.isError)then
						
					else
						show_msg(get_txt("submitted")..": "..get_txt("scores"));
					end
				end);
			end
		else
			royal.db:post("scores", json.encode(score_obj), nil, function(event)
				print("post@normal", event.isError, event.phase, event.response);
				if(event.isError)then
					if(#_G.scores_unsubmitted>2)then
						table.remove(_G.scores_unsubmitted, 1);
					end
					table.insert(_G.scores_unsubmitted, score_obj);
					local save_str = b64lib.b64(json.encode(scores_unsubmitted));
					saveFile('system.b64', save_str);
				else
					show_msg(get_txt("submitted")..": "..get_txt("scores"));
				end
			end);
		end
	end
	
	
	if(login_obj.dead)then
		submit = false;
		if(player_name)then
			submitFirebase();
		else
			show_msg('global: player not defined');
			_itemAchievement:refreshMyData(true);
		end
		
		
	end

	function facemc:addBtn(txt, tx, ty, tw, act)
		local btn = newGroup(facemc);
		btn.x, btn.y = tx, ty;
		
		local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		
		local body = add_bar("black_bar3", tw);
		btn:insert(body);
		body:toBack();
		
		body.act = act;
		table.insert(localGroup.buttons, body);
		elite.addOverOutBrightness(body);
		function body:disabled()
			return facemc.wnd~=nil;
		end
		return btn;
	end
	
	local sbmc;
	if(submit==false)then
		sbmc = facemc:addBtn(get_txt('submit'), bg.x, bg.y + bg.h/2 + 50*scaleGraphics, tw, function()
			player_name = save_obj.customName or _G.playerName or save_obj.playerName;
			if(player_name)then
				submitFirebase();
				sbmc:removeSelf();
				saveGame();
			end
		end);
		function sbmc:disabled()
			return player_name==nil;
		end
	end
	
	if(save_obj.customName~=nil or player_name==nil or options_cheats)then
		local itxt = elite.newNativeText(facemc, _W/2, bg.y + bg.h/2 + th, 80*scaleGraphics, 20*scaleGraphics, function(txt)
			save_obj.customName = txt;
			player_name = save_obj.customName or _G.playerName or save_obj.playerName;
			if(localGroup.refreshDebugInfo)then
				localGroup:refreshDebugInfo();
			end
		end, true);
		itxt.inputType = "no-emoji";
		itxt.text = player_name;
		itxt.maxsymbols = 12;
		itxt.nospaces = true;
		itxt.baned = {" ", "%.", "%/", "%\\"};
	end
	
	local function closeScreen()
		if(login_obj.dead)then
			show_start();
		else
			show_map();
		end
	end
	
	
	-- local i = 0;
	-- if(options_gamecenter)then
		-- local sbmc = facemc:addBtn(get_txt('local'), bg.x - bg.w/2 + tw*(1+i)/2, bg.y + bg.h/2 + th, tw, function() _itemAchievement:showScores(); end);
		-- i = i+2;
	-- end
	
	

	if(false)then
		if(royal.db==nil)then
			local firebase = require('firebase');
			royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
		end
		local nick = ':Four1Fool:';
		royal.db:get("scores", '?orderBy="'..'nick'..'"&equalTo="'..nick..'"', function(event)
			if(event.isError)then
				print("Network error!");
			else
				local data_obj = json.decode(event.response);
				print("Four1Fool:", data_obj);
				for uid,obj in pairs(data_obj)do
					print(uid, obj, obj.score, obj.nick, obj.hpmax);
					royal.db:delete("scores/"..uid, nil, function(event)
						if(event.isError)then
							print("Network error!");
						else
							local data_obj = json.decode(event.response);
							print(event.response, data_obj);
						end
					end)
				end
			end
		end);
	end
	
	
	local db_id = "scores";
	if(login_obj._ordinaldate)then
		db_id = "daily/"..login_obj._ordinaldate.."/scores";
	end
	require("src.injectScores").inject(localGroup, bg, localGroup.buttons, db_id);
	localGroup.scorestxts.isVisible = false;
	
	local sbmc = facemc:addBtn(get_txt('top100'), bg.x - bg.w/2 + tw/2, bg.y + bg.h/2 + th, tw, function()
		txts.isVisible = false;
		localGroup.scorestxts.isVisible = not txts.isVisible;
		if(not txts.isVisible)then
			txts.isVisible = false;
			
			localGroup:fetchScores('score');
		end
	end);
	
	if(player_name)then
		local myown = facemc:addBtn(get_txt('myOwn'), bg.x - bg.w/2 + tw/2, bg.y + bg.h/2 + th + 30*scaleGraphics, tw, function()
			txts.isVisible = false;
			localGroup.scorestxts.isVisible = not txts.isVisible;
			if(not txts.isVisible)then
				txts.isVisible = false;
				
				-- localGroup:fetchScores('score');
				localGroup:fetchQuery('?orderBy="nick"&equalTo="'..player_name..'"'..'&limitToLast=100', "score", "myown");
				localGroup:showOwnOnEmpty("myown");
			end
		end);
	end
	
	local gomc = facemc:addBtn(get_txt('close'), bg.x + bg.w/2 - tw/2, bg.y + bg.h/2 + th, tw, function()
		closeScreen()
	end);
	
	function localGroup:actEscape()
		closeScreen();
	end
	function localGroup:actRight()
		closeScreen();
	end

	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end