if(_G.corona_fail)then return; else _G.corona_fail = true; end

_W = display.contentWidth;
_H = display.contentHeight;

fontMain = native.systemFont;

_G.scaleGraphics = 2;
-- _G.gameScale = 2;
_G.leadersScale = 2;

optionsBuild = "win32";-- "ios"/"android"/"amazon"/"samsung"/"ouya"/"gamestick"/"xiaomi"/"win32"/"mac"/"razerforge"/"winphone"/"html5"/"linux"
optionsPublisher = "elitegames";--"elitegames"/"iplayjoy"/"ubinuri"/"realgames"(win32)
optionsVersion = "0.987";

options_steam = true and (optionsBuild=="win32" or optionsBuild=="mac") and optionsPublisher == "elitegames";

options_console = optionsBuild=="ouya" or optionsBuild=="gamestick" or optionsBuild=="xiaomi";
options_desctop = optionsBuild=="mac" or optionsBuild=="win32" or optionsBuild=="html5" or optionsBuild=="linux";
options_mobile = options_console==false and options_desctop==false;
options_web = optionsBuild=="html5";
options_shop_enabled = true;

options_warnings_images = true;

options_txt_offset = 0; -- 0 for debug, 2 for release on devices
txt_number_offset = 0;
options_save_border_w,options_save_border_h = 0,0;
if(options_console)then options_save_border_w,options_save_border_h = 30,20; else options_save_border_w,options_save_border_h = 0,0; end;

options_debug = false;
options_editor = false;
options_cheats = false and system.getInfo("environment")=="simulator";
options_adult = true;
options_sfx = false;

options_gamecenter = ((optionsBuild == "ios") or (optionsBuild == "android")) and optionsPublisher=="elitegames";
options_moregames = (optionsPublisher == "elitegames");
moregamesName="Royal Booty Quest";
moregamesDays=256+7;
moregamesYear=2018;
		
require("eliteHelper");
json = require "json";
xml = require( "eliteXML" ).newParser();

_G.language = require("eliteLang").new();
language:setDefLangFiles(fontMain, fontNumbers);
language:add_lang_xml("en");
language:add_lang_xml("fr");
language:add_lang_xml("es");
language:add_lang_xml("de");
language:add_lang_xml("ko");
language:add_lang_xml("jp");
language:add_lang_xml("pt");
language:add_lang_xml("pl");
language:add_lang_xml("ru");
language:add_lang_xml('zh_cn');
language:add_lang_xml('zh_tw');
language:loadSettings(system.getPreference("locale", "language"));

_G.cards = {};
_G.heroes = {};
_G.conditions = {};
_G.royal = {};
_G.potions = {};

require("data_cards");

require("data_conditions");
require("data_enemies");
require("data_relics");

require("eliteHints");
local msgs_mc = require("eliteMsgs").new();
function show_msg(txt)
	mainGroup.parent:insert(msgs_mc);
	msgs_mc:show_msg(txt);
	msgs_mc.x, msgs_mc.y = 0,12+options_save_border_h*scaleGraphics;
end

_G.game_art = require("majestyArt").new();
game_art:add_decor("stuff2", 1);
game_art:add_decor("stuff3", 1);

director = require("director");
eliteText = require("eliteText" ).new();
eliteSoundsIns = require( "eliteSounds" ).new();
require("eliteLoading").new(mainGroup);

_G.links = {};

_G.b64lib = require("eliteBase64").new();
local encodedString = b64lib.b64("Hello {('%!&jQ')} World");
local decodedString = b64lib.unb64(encodedString);
print( "_b64:", encodedString, decodedString);



-- print("_settings1:", settings, _G.settings);
_G._itemAchievement = require("eliteAchievements").new("image/achs/","image/achs/__noico.png", 46);--item_id, ios_id, google_id, steam_id, steam_lid
_itemAchievement:addItemGCID( 1, "rbq.boss11", "CgkItPeF_98XEAIQEQ", "NEW_ACHIEVEMENT_1_0"); -- Witch
_itemAchievement:addItemGCID( 2, "rbq.boss12", "CgkItPeF_98XEAIQEg", "NEW_ACHIEVEMENT_1_1"); -- Troll
_itemAchievement:addItemGCID( 3, "rbq.boss13", "CgkItPeF_98XEAIQEw", "NEW_ACHIEVEMENT_1_2"); -- Veigar
_itemAchievement:addItemGCID( 4, "rbq.boss21", "CgkItPeF_98XEAIQFA", "NEW_ACHIEVEMENT_1_3"); -- Minotaur
_itemAchievement:addItemGCID( 5, "rbq.boss22", "CgkItPeF_98XEAIQFQ", "NEW_ACHIEVEMENT_1_4"); -- Necros
_itemAchievement:addItemGCID( 6, "rbq.boss23", "CgkItPeF_98XEAIQFg", "NEW_ACHIEVEMENT_1_5"); -- Knight
_itemAchievement:addItemGCID( 7, "rbq.boss31", "CgkItPeF_98XEAIQFw", "NEW_ACHIEVEMENT_1_6"); -- Genie
_itemAchievement:addItemGCID( 8, "rbq.boss32", "CgkItPeF_98XEAIQGA", "NEW_ACHIEVEMENT_1_7"); -- Sand Priest
_itemAchievement:addItemGCID( 9, "rbq.boss33", "CgkItPeF_98XEAIQGQ", "NEW_ACHIEVEMENT_1_8"); -- Air Golems
_itemAchievement:addItemGCID(10, "rbq.boss41", "CgkItPeF_98XEAIQGg", "NEW_ACHIEVEMENT_1_9"); -- Air Bender
-- Find and kill the final Boss.
_itemAchievement:addItemGCID(11, "rbq.hero1", "CgkItPeF_98XEAIQGw", "NEW_ACHIEVEMENT_1_11"); -- Frontier
_itemAchievement:addItemGCID(12, "rbq.hero2", "CgkItPeF_98XEAIQHA", "NEW_ACHIEVEMENT_1_12"); -- Miss Fortune
_itemAchievement:addItemGCID(13, "rbq.hero3", "CgkItPeF_98XEAIQHQ", "NEW_ACHIEVEMENT_1_13"); -- Shiva
_itemAchievement:addItemGCID(14, "rbq.hero4", "CgkItPeF_98XEAIQHg", "NEW_ACHIEVEMENT_1_14"); -- Demon
_itemAchievement:addItemGCID(15, "rbq.hero5", "CgkItPeF_98XEAIQHw", "NEW_ACHIEVEMENT_1_15"); -- Blood Mage
_itemAchievement:addItemGCID(16, "rbq.hero6", "CgkItPeF_98XEAIQIA", "NEW_ACHIEVEMENT_1_16"); -- Shaman
-- _itemAchievement:addItemGCID(17, "rbq.hero7", "CgkIzLiZ0cYXEAIQBg", "NEW_ACHIEVEMENT_1_0"); 
-- _itemAchievement:addItemGCID(18, "rbq.hero8", "CgkIzLiZ0cYXEAIQBg", "NEW_ACHIEVEMENT_1_0"); 
-- _itemAchievement:addItemGCID(19, "rbq.hero9", "CgkIzLiZ0cYXEAIQBg", "NEW_ACHIEVEMENT_1_0"); 

-- _itemAchievement:addItemGCID(31, "rbq.set1", "temp", "temp");

-- unlock all cards for any hero
-- unloc all relics
--------------------------
-- mods
--------------------------
local str = loadFile("stuff/_mods_list.json", system.ResourceDirectory);
local arr = json.decode(str);
_G.log_texts = {};
for i=1,#arr do
	local entry = arr[i];
	-- print(entry.author, entry.pack);
	local cards_counter_new = 0;
	local heroes_counter = 0;
	local conditions_counter = 0;
	local relics_counter = 0;
	
	local hero_str = loadFile("stuff/hero_"..entry.pack..".json", system.ResourceDirectory);
	if(hero_str)then
		local hero_obj = json.decode(hero_str);
		table.insert(heroes, hero_obj);
		heroes_counter = heroes_counter+1;
	end
	
	local conditions_str = loadFile("stuff/conditions_"..entry.pack..".json", system.ResourceDirectory);
	if(conditions_str)then
		local conditions_obj = json.decode(conditions_str);
		for attr,obj in pairs(conditions_obj) do
			-- if(conditions[attr]==nil)then
				conditions[attr] = obj;
				conditions_counter = conditions_counter+1;
			-- end
		end
	end
	
	for j=1,9 do
		local cards_str = loadFile("stuff/cards_"..entry.pack.."_"..j..".json", system.ResourceDirectory);
		if(cards_str)then
			local cards_obj = json.decode(cards_str);
			print("_cards_str:", cards_str);
			for i=1,#cards_obj do
				local obj = cards_obj[i];
				if(cards_indexes[obj.tag])then
					for k=#cards,1,-1 do
						if(cards[k].tag==obj.tag)then
							table.remove(cards, k);
						end
					end
				end
				-- if(cards_indexes[obj.tag]==nil)then
					table.insert(cards, obj);
					cards_indexes[obj.tag] = obj;
					cards_counter_new = cards_counter_new+1;
					_G.language:addEnWord(get_name_id(obj.tag), obj.tag);
				-- end
			-- for attr,obj in pairs(cards_obj) do
				-- print(obj.tag, cards_indexes[obj.tag]);
				-- cards_indexes
				-- cards
				-- conditions[attr] = obj;
			end
		else
			break;
		end
	end
	
	-- relics
	local relics_str = loadFile("stuff/relics_"..entry.pack..".json", system.ResourceDirectory);
	if(relics_str)then
		local cards_obj = json.decode(relics_str);
		for i=1,#cards_obj do
			local robj = cards_obj[i];
			
			if(relics_indexes[robj.tag])then
				for k=#relics,1,-1 do
					if(relics[k].tag==robj.tag)then
						table.remove(relics, k);
					end
				end
			end
			
			-- if(relics_indexes[robj.tag]==nil)then
				table.insert(relics, robj);
				relics_indexes[robj.tag] = robj;
				relics_counter = relics_counter+1;
			-- end
		end
	end
	
	local str = loadFile("stuff/potions_"..entry.pack..".json", system.ResourceDirectory);
	if(str)then
		local list = json.decode(str);
		for i=1,#list do
			local potion = list[i];
			table.insert(potions, potion);
			print('added', potion.tag);
		end
	end
	
	table.insert(log_texts, 'loaded mod "'..entry.pack..'" by '..entry.author..", cards: "..cards_counter_new..", heroes:"..heroes_counter..", relics:"..relics_counter..", cons:"..conditions_counter);
end

for i=1,#potions do
	potions_indexes[potions[i].tag] = potions[i];
	print('indexed', potions[i].tag);
end

local function saveCardsToJson(attr1, val1, attr2, val2, res2)
	local list = {};
	for i=1,#cards do
		local card = cards[i];
		-- print(card.tag, card[attr1], val1, card[attr1]==val1)
		if((card[attr1]==val1) and (card[attr2]==val2)==res2)then
			-- print("cards_indexes['"..card.tag.."'].onUpgrade = {};")
			table.insert(list, card)
		end
	end
	if(val2=="all")then
		val2=1;
	end
	saveFile("cards_"..val1.."_"..val2..".json", json.prettify(json.encode(list)));
end
saveCardsToJson("class", "red", "ctype",	CTYPE_ATTACK, true);
saveCardsToJson("class", "red", "ctype",	CTYPE_SKILL, true);
saveCardsToJson("class", "red", "ctype",	CTYPE_POWER, true);
saveCardsToJson("class", "blue", "ctype", CTYPE_ATTACK, true);
saveCardsToJson("class", "blue", "ctype", CTYPE_SKILL, true);
saveCardsToJson("class", "blue", "ctype", CTYPE_POWER, true);
saveCardsToJson("class", "green", "ctype", CTYPE_ATTACK, true);
saveCardsToJson("class", "green", "ctype", CTYPE_SKILL, true);
saveCardsToJson("class", "green", "ctype", CTYPE_POWER, true);
saveCardsToJson("class", "violet", "ctype", CTYPE_ATTACK, true);
saveCardsToJson("class", "violet", "ctype", CTYPE_SKILL, true);
saveCardsToJson("class", "violet", "ctype", CTYPE_POWER, true);
saveCardsToJson("class", "blood", "ctype", CTYPE_ATTACK, true);
saveCardsToJson("class", "blood", "ctype", CTYPE_SKILL, true);
saveCardsToJson("class", "blood", "ctype", CTYPE_POWER, true);
saveCardsToJson("class", "fire", "ctype", CTYPE_ATTACK, true);
saveCardsToJson("class", "fire", "ctype", CTYPE_SKILL, true);
saveCardsToJson("class", "fire", "ctype", CTYPE_POWER, true);

-- saveCardsToJson("class", "green", "ctype",	"all", false);
saveCardsToJson("class", "none","ctype",	"all", false);
saveCardsToJson("class", "any","ctype",	"all", false);
saveFile("conditions_badim.json", json.prettify(json.encode(conditions)));
saveFile("relics_badim.json", json.prettify(json.encode(relics)));
saveFile("events_red.json", json.prettify(json.encode(events)));

for attr,obj in pairs(conditions) do
	if(obj.play)then
		if(obj.play.dmg)then
			if(obj.play.strX==nil)then
				obj.play.strX=0;
			end
			if(obj.play.dtype==nil)then
				obj.play.dtype=_G.DTYPE_DIRECT;
			end
		end
		if(obj.play.armor)then
			if(obj.play.dexX==nil)then
				obj.play.dexX=0;
			end
		end
	end
end
for i=1,#relics do
	local obj = relics[i];
	if(obj.quest)then
		if(obj.quest.proceed==nil)then
			obj.quest.proceed = false;
		end
	end
end

_G.scores_unsubmitted = {}
_G.save_obj = { -- save_obj.stats
	stats = {},	class = nil, version=optionsVersion,
	energy = 100, energymax=100, diamonds=1,
	unlocks = {}, -- save_obj.unlocks
};
_G.login_obj = {
	deck = {}, stats = {}, relics={},
	game = {deck={}, draw={}, hand={}, trash={}, turn=1},
	cloot = {}, rloot = {}, eloot = {},
	map = {lvl=1, width=800, height=300, points={}, point=nil},
	energymax=3, drawPower = 5, drawPowerStart = 0,
	hp=80, hpmax=80,
	tag="Red", money=99,
	scin="divine", class="red",
	potions_max = 3, potions = {}, hiddentreasure=0, 
};
_G.settings = {
	cardScaleMin = 0.5,
	cardScaleMax = 1,
	confirmationMin = 0,
	relicNames = true,
	saveBorderBot = 0,
	manaTop = false,
	dragAndDrop = true,
};

require("scrTutorial");

-- Extra decorative stuff.
_G.eliteShop = require("eliteGamesStore").new();
eliteShop:addItem('pack_silver',	{cost="$4.99",	consumable=true, donate=1});
eliteShop:addItem('pack_gold',		{cost="$9.99",	consumable=true, donate=2});
eliteShop:addItem('pack_amber',		{cost="$19.99",	consumable=true, donate=3});
eliteShop:addItem('hammers_pack',	{cost="$4.99",	consumable=true, hammers=100});
eliteShop:addItem('diamonds_pack',	{cost="$9.99",	consumable=true, diamonds=5});
-- eliteShop:addItem('rich',		{cost="$49.99",	consumable=false, rich=1, donate=3});
-- eliteShop:addItem('richer',		{cost="$99.99",	consumable=false, rich=2, donate=3});

eliteShop:addItemShopId('pack_silver',	eliteShop.CONST_SHOP_GOOGLE, "rbq.pack_silver");
eliteShop:addItemShopId('pack_gold',	eliteShop.CONST_SHOP_GOOGLE, "rbq.pack_gold");
eliteShop:addItemShopId('pack_amber',	eliteShop.CONST_SHOP_GOOGLE, "rbq.pack_amber");
-- eliteShop:addItemShopId('rich',			eliteShop.CONST_SHOP_GOOGLE, "rbq.rich");
-- eliteShop:addItemShopId('richer',		eliteShop.CONST_SHOP_GOOGLE, "rbq.richer");
eliteShop:addItemShopId('hammers_pack',	eliteShop.CONST_SHOP_GOOGLE, "rbq.hammers");
eliteShop:addItemShopId('diamonds_pack',eliteShop.CONST_SHOP_GOOGLE, "rbq.diamonds");

eliteShop:addItemShopId('pack_silver',	eliteShop.CONST_SHOP_APPLE, "rbq.pack_silver");
eliteShop:addItemShopId('pack_gold',	eliteShop.CONST_SHOP_APPLE, "rbq.pack_gold");
eliteShop:addItemShopId('pack_amber',	eliteShop.CONST_SHOP_APPLE, "rbq.pack_amber");
eliteShop:addItemShopId('hammers_pack',	eliteShop.CONST_SHOP_APPLE, "rbq.hammers");
eliteShop:addItemShopId('diamonds_pack',eliteShop.CONST_SHOP_APPLE, "rbq.diamonds");

function fillRelicLoot()
	for i=1,#relics do
		local robj = relics[i];
		if(robj.rarity>0 and robj.rarity<5 and login_obj.relics[robj.tag]==nil)then
			if(robj.lbl==nil or login_obj.tags[robj.lbl])then
				if(robj.relicupgrade==nil or login_obj.relics[robj.relicupgrade])then
					table.insert(login_obj.rloot, robj.tag);
				end
			end
		end
	end
	table.shuffle(login_obj.rloot);
	table.shuffle(login_obj.rloot);
	print('relic loot shuffled:', #login_obj.rloot);
end
function getRelicLoot(rarity, strict)
	print("_getRelicLoot:", rarity, strict);
	local rid;
	local shuffle = false;
	
	if(login_obj.rloot==nil)then login_obj.rloot={}; end
	if(#login_obj.rloot==0)then
		fillRelicLoot();
	end
	
	if(rarity)then
		shuffle = true;
		for i=#login_obj.rloot,1,-1 do
			local robj = relics_indexes[login_obj.rloot[i]];
			if(robj)then
				if(robj.rarity==rarity or (strict==false and robj.rarity<rarity))then
					if(login_obj.relics[rid]~=true)then
						rid = table.remove(login_obj.rloot, i);
						shuffle = false;
						break;
					end
				end
			end
		end
	end
	
	if(rid==nil)then
		rid = table.remove(login_obj.rloot, 1);
		while(login_obj.relics[rid] and #login_obj.rloot>0)do
			rid = table.remove(login_obj.rloot, 1);
		end
	end
	
	if(#login_obj.rloot==0 or shuffle)then
		fillRelicLoot();
	end
		
	return rid;
end
function handleLoginObj(obj, facemc)
	for attr,val in pairs(obj) do
		if(val==true or val==false)then
			login_obj[attr] = val;
		elseif(login_obj[attr])then
			login_obj[attr] = login_obj[attr] + val;
			if(attr=="hpmax")then
				login_obj.hp = login_obj.hp + val;
				if(login_obj.hpmaxex==nil)then
					login_obj.hpmaxex = login_obj[attr];
				end
				login_obj.hpmaxex = login_obj.hpmaxex + val;
			end
		else
			login_obj[attr] = val;
		end
		if(attr=="shop_remove_card")then
			login_obj.removecard_cost = 50;
			login_obj.removecard_inc = 0;
		end
		if(attr == "colorblind")then
			royal:fillCardLoot(); -- colorblind
		end
	end
	if(facemc)then
		facemc:refreshRelics();
		facemc:moneyRefresh();
		facemc:hpRefresh();
	end
end
function removeRelic(rid, facemc)
	if(login_obj.relics[rid])then
		login_obj.relics[rid] = nil;
		return true
	end
end
function addRelic(rid, facemc)
	if(rid==nil)then
		return
	end
	local id = get_name_id(rid);
	if(login_obj.sandbox~=true)then
		save_obj.unlocks['item_'..id] = 2;
	end
			
	if(login_obj.relics[rid]==true)then
		show_msg('error:this relic already taken');
		return false;
	end
	login_obj.relics[rid] = true;
	local robj = relics_indexes[rid];
	if(robj.skull)then
		addRunStat("skulls", 1);
	end
	if(robj.login)then
		handleLoginObj(robj.login, facemc);
		-- for attr,val in pairs(robj.login) do
			-- if(login_obj[attr])then
				-- login_obj[attr] = login_obj[attr] + val;
			-- else
				-- login_obj[attr] = val;
			-- end
		-- end
		-- if(facemc)then
			-- facemc:refreshRelics();
			-- facemc:moneyRefresh();
			-- facemc:hpRefresh();
		-- end
	end
	if(robj.condition)then
		if(robj.condition.event=="consume")then
			login_obj.consume = true;
		end
	end
	if(robj.relicupgrade)then
		login_obj.relics[robj.relicupgrade] = nil;
	end
	
	if(robj.quest)then
		handle_action(robj.quest, _W/2, _H/2, facemc);
	end
	if(robj.cards)then
		for i=1,#robj.cards do
			addCard(robj.cards[i]);
		end
	end
		-- local item_obj = robj.quest;
		-- if(item_obj.relic)then
			-- if(relics_indexes[item_obj.relic])then
				-- addRelic(item_obj.relic, facemc);
			-- elseif(#login_obj.rloot>0)then
				-- for i=1,item_obj.relic do
					-- local rid = getRelicLoot();
					-- addRelic(rid, facemc);
					-- facemc:refreshRelics();
				-- end
			-- end
		-- end
	-- end
end
function handleEvent(etype, facemc)
	print('loginEvent:', etype);
	for rid, bol in pairs(login_obj.relics) do
		local robj = relics_indexes[rid];
		if(robj.condition)then
			if(robj.condition.event==etype)then
				if(robj.condition.login)then
					handleLoginObj(robj.condition.login, facemc);
				end
				if(robj.condition.quest)then
					handle_action(robj.condition.quest, _W/2, _H/2, facemc);
				end
				-- if(robj.condition.play)then
					-- if(robj.condition.once==nil or robj.condition.once==true)then
						-- gamemc:playCard(robj.condition.play, target, unit, false);
						-- if(robj.condition.once==true)then
							-- robj.condition.once=false;
						-- end
					-- end
				-- end
				
				-- if(robj.condition.transfer)then
					-- local attr = robj.condition.transfer;
					-- local val = target[attr];
					-- local new_card = {range=robj.condition.range};
					-- new_card[attr] = val;
					-- if(val~=0)then
						-- if(unit.gid == stats.turn_gid)then
							-- gamemc:playCard(new_card, target, unit);
						-- else
							-- unit:addNextCard(new_card);
						-- end
					-- end
				-- end
			end
		end
	end
end


royal.cards_log = {};
function royal:get_lvl_xp(lvl)
	return math.floor(math.pow(lvl, 1.8)*28/5)*5;
end

function royal:addExp(class, val)
	addRunStat("exp", val);
	local xp = addLoginStat(class.."_exp", val);
	local lvl = getLoginStat(class.."_lvl");
	
	local xp_min = royal:get_lvl_xp(lvl+1);
	if(xp>xp_min or lvl==0)then
		addLoginStat(class.."_lvl", 1);
		return true;
	end
	return false;
end
function royal:getRelicCount()
	local relics_count = 0;
	for attr,val in pairs(login_obj.relics) do
		if(val)then
			relics_count = relics_count+1;
		end
	end
	return relics_count;
end
function royal:add_tiles_extra(tar, tfile, tx, ty, ew, eh)
	local extra_size = 32;
	local mRandom=math.random;
	for ix=-ew+1,ew-1 do
		for iy=-eh+1,eh-1 do
			local nx, ny = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
			local tile_mc;
			if(mRandom()>0.6 or (ix==0 and iy==0))then
				tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_center.png");
			end
			if(tile_mc == nil)then
				tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_base.png");
			end
			tile_mc.x, tile_mc.y = nx, ny;
			tile_mc.xScale, tile_mc.yScale = (mRandom(0,1)-0.5)*2, (mRandom(0,1)-0.5)*2;
		end
	end
	
	for ix=-ew+1,ew-1 do
		local iy = -eh;
		local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_side.png");
		tile_mc.xScale, tile_mc.yScale = 1, 1;
		tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	end
	for ix=-ew+1,ew-1 do
		local iy = eh;
		local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_side.png");
		tile_mc.xScale, tile_mc.yScale = -1, -1;
		tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	end
	
	for iy=-eh+1,eh-1 do
		local ix = -ew;
		local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_side.png");
		tile_mc.xScale, tile_mc.yScale = -1, 1;
		tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	end
	for iy=-eh+1,eh-1 do
		local ix = ew;
		local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_side.png");
		tile_mc.xScale, tile_mc.yScale = 1, -1;
		tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	end
	
	local ix, iy = ew, -eh;
	local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_angle.png");
	tile_mc.xScale, tile_mc.yScale = 1, (mRandom(0,1)-0.5)*2;
	tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	local ix, iy = -ew, eh;
	local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_angle.png");
	tile_mc.xScale, tile_mc.yScale = -1, (mRandom(0,1)-0.5)*2;
	tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	
	local ix, iy = -ew, -eh;
	local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_top.png");
	tile_mc.xScale, tile_mc.yScale = (mRandom(0,1)-0.5)*2, 1;
	tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
	local ix, iy = ew, eh;
	local tile_mc = display.newImage(tar, "image/tiles_extra/"..tfile.."_top.png");
	tile_mc.xScale, tile_mc.yScale = (mRandom(0,1)-0.5)*2, -1;
	tile_mc.x, tile_mc.y = -(ix*extra_size/1 - iy*extra_size/1) + tx, (iy*extra_size/2 + ix*extra_size/2) + ty;
end
function royal:getConsumeHint()
	local arr = {tag='Consume'};
	
	-- arr.login = {hpmax=2};
	-- arr.quest = {potion=1, proceed=false};
	-- table.insert(arr, );
	
	-- table.insert(relics, {tag="Bowl HPMax", 		rarity=1, scin=86, condition={event="consume", login={hpmax=2}}});
	-- table.insert(relics, {tag="Bowl Potion",	 	rarity=2, scin=87, condition={event="consume", quest={potion=1, proceed=false}}});
	
	local attrs = {'login', 'quest'};
	-- relics
	-- login_obj.relics
	for rid, bol in pairs(login_obj.relics) do
		if(bol)then
			local robj = relics_indexes[rid];
			if(robj.condition)then
				if(robj.condition.event=="consume")then
					for i=1,#attrs do
						local ctype = attrs[i];
						if(robj.condition[ctype])then
							if(arr[ctype]==nil)then
								arr[ctype] = {};
							end
							for attr,val in pairs(robj.condition[ctype]) do
								print(ctype, attr, val, type(val));
								if(type(val)~='number' or arr[ctype][attr]==nil)then
									arr[ctype][attr] = val;
								else
									arr[ctype][attr] = arr[ctype][attr] + val;
								end
							end
						end
					end
				end
			end
		end
	end
						
	return getRelicDesc(arr);
end
function royal:clearCardsLog()
	-- while(#royal.cards_log>0)do -- lets remove all new cards - they already were animated
		-- table.remove(royal.cards_log, 1);
	-- end
	for i=#royal.cards_log,1,-1 do
		local obj = royal.cards_log[i];
		if(obj.force~=true)then
			table.remove(royal.cards_log, i);
		end
	end
end	
function addCardAni(card_obj, force)
	table.insert(royal.cards_log, {obj=card_obj, force=force});
end
function addCardObj(card_obj)
	if(login_obj.curses_negated==nil)then login_obj.curses_negated=0; end
	if(login_obj.curses_negated>0 and card_obj.ctype==CTYPE_CURSE)then
		login_obj.curses_negated = login_obj.curses_negated-1;
		return false
	end
	if(card_obj.ctype==CTYPE_CURSE)then
		handleEvent("cursed");
	end
	if(card_obj.ctype==CTYPE_ATTACK and login_obj.autoupgradeattacks)then upgradeCard(card_obj); end
	if(card_obj.ctype==CTYPE_SKILL and login_obj.autoupgradeskills)then upgradeCard(card_obj); end
	if(card_obj.ctype==CTYPE_POWER and login_obj.autoupgradepowers)then upgradeCard(card_obj); end
	
	if(card_obj.addRelic)then
		addRelic("Stance Keeper");
	end
	
	table.insert(login_obj.deck, card_obj);
	addCardAni(card_obj);
	
	if(login_obj.sandbox~=true)then
		save_obj.unlocks['card_'..get_name_id(card_obj.tag)] = 2;
	end
end
function addCard(cid)
	local card_obj = table.cloneByAttr(cards_indexes[cid]);
	addCardObj(card_obj);
end
function countCardsByTag(tag)
	local count = 0;
	for i=#login_obj.deck,1,-1 do
		local card_obj = login_obj.deck[i];
		if(tag == card_obj.tag)then
			count = count+1;
		end
	end
	return count;
end
function removeCardByTag(tag)
	local count = 0;
	for i=#login_obj.deck,1,-1 do
		local card_obj = login_obj.deck[i];
		if(tag == card_obj.tag)then
			count = count+1;
			table.remove(login_obj.deck, i);
			removeCardAni(card_obj);
		end
	end
	return count;
end

function map_rebuild(lvl)
	login_obj.hp = login_obj.hpmax;
	login_obj.eloot = {};
	
	local map = login_obj.map;
	map.lvl = lvl;
	
	map.tag = "act"..lvl.."_tag";
	map.point = nil;
	
	local points = map.points;
	while(#points>0)do table.remove(points, 1); end
	
	map.width = 100;
	local empty_w = 100;
	
	local helper = {};
	local function addPoint(id, ptype, plvl, txi, ty, hidden, nxt1, nxt2)
		local tx = txi*empty_w;
		
		map.width = math.max(map.width, tx+100);
		if(ptype=="boss" or ptype=="elite" or ptype=="quest")then
			plvl = map.lvl;
		end
		
		local point = {id=id, ptype=ptype, lvl=plvl, xi=txi, tx=tx, ty=ty, x=tx+math.random(-16, 16), y=ty+math.random(-16, 16), 
			nxt1=nxt1, nxt2=nxt2, par=par, hidden=hidden};
		table.insert(points, point);
		helper[tx.."x"..ty] = point;
		
		
		local battle_lvl = plvl;
		local lvl_try=200;
		local while_exit = 500;
		
		if(ptype=="battle")then
			local party = table.random(parties);
			while(party.lvl~=battle_lvl and while_exit>0)do
				party = table.random(parties);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 200;
					battle_lvl = battle_lvl-1;
				end
				while_exit = while_exit-1;
			end
			point.party = table.cloneByAttr(party);
		end
		if(ptype=="elite")then
			local party = table.random(elites);
			while(party.lvl~=battle_lvl and while_exit>0)do
				party = table.random(elites);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 100;
					battle_lvl = battle_lvl-1;
				end
				while_exit = while_exit-1;
			end
			point.party = table.cloneByAttr(party);
		end
		if(ptype=="boss")then
			local party = table.random(bosses);
			while(party.lvl~=battle_lvl and while_exit>0)do
				party = table.random(bosses);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 100;
					battle_lvl = battle_lvl-1;
				end
				while_exit = while_exit-1;
			end
			point.party = table.cloneByAttr(party);
		end
	end
	
	if(map.lvl==4 and login_obj.ascend~=true)then
		local n1 = addPoint(1, "shop", map.lvl, 1, 0, false, 2);
		local n2 = addPoint(2, "elite", map.lvl, 2, 0, false, 3);
		local n3 = addPoint(3, "boss", map.lvl, 3, 0, false);
		map.height = 500;
		return
	end

	local points_variants = {"battle", "battle", "battle", "battle", "battle", "battle", "battle"};--, "quest", "quest", "quest", "quest"};
	local rest_i = 9;
	local prev_point = nil;
	local prev_connection = 1;
	
	local line_l = 15;
	addPoint(1, "boss",	map.lvl, (line_l+1), 0, false, nil);

	local function add_line(lineY, nbhY)
		local hidden_counter = 0;
		local same_type, same_i = 0, 1;
		for i=1,line_l do
			local id = #points+1;
			local nid1 = id+1;
			local ptype = table.random(points_variants);
			for j=1,20 do
				if((ptype==prev_point and ptype~="battle") or ((i<5 or i==line_l-1) and ptype=="rest") or (ptype=="treasure" and (i+1)==rest_i) or (i<5 and ptype=="elite"))then
					ptype = table.random(points_variants);
				end
			end
			-- print(lineY, i, same_i, same_type, ptype);
			-- while(same_i>=5 and ptype==prev_point)do
				-- ptype = table.random(points_variants);
			-- end
			
			local hidden = (math.random(0, 2)==0 and ptype~='rest' and hidden_counter<3) or ptype=="treasure" or ptype=="quest";
			-- local hidden = false;
			
			if(i==1)then
				ptype = "battle";
				hidden = false;
			end
			
			if(i==rest_i)then
				ptype = "treasure";
				hidden = false;
			end
			local lvl=map.lvl;
			if(i>rest_i)then
				lvl=map.lvl+1;
			end
			if(i==line_l)then
				nid1 = 1;
				ptype = "rest";
				hidden = false;
			end
			prev_point = ptype;
			
			if(hidden)then
				hidden_counter = hidden_counter+1;
			else
				hidden_counter = 0;
			end
			
			if(same_type==ptype)then
				same_i = same_i+1;
			else
				same_i = 1;
				same_type = ptype;
			end

			addPoint(id, ptype,	lvl, i, lineY, hidden, nid1, nid2);
		end
	end
	add_line(-150);
	add_line(-50);
	add_line(50);
	add_line(150);
	
	-- local rests = math.random(6, 8);
	-- local elites = math.random(4, 5);
	-- local shops = math.random(3, 5);
	-- local treasures = math.random(3,5);
	
	local function swapPoints(ptype1, ptype2, count, minx, hidden)
		local list = {};
		for i=1,#points do
			local p = points[i];
			if(p.ptype==ptype1 and p.xi>=minx)then
				table.insert(list, p);
			end
		end
		local tryes = 500;
		while(count>0)do -- helper[tx.."x"..ty] = point;
			local ok = true;
			if(#list>0)then
				local p = table.remove(list, math.random(1, #list));
				local pl, pr = helper[(p.tx-empty_w).."x"..p.ty], helper[(p.tx+empty_w).."x"..p.ty];
				
				if(pl)then
					if(pl.ptype==ptype2)then
						ok = false;
					end
				end
				if(pr)then
					if(pr.ptype==ptype2)then
						ok = false;
					end
				end
				
				if(ok)then
					p.ptype = ptype2;
					if(hidden>0)then
						hidden = hidden-1;
						p.hidden = true;
					else
						p.hidden = false;
					end
				end
			end
			if(ok)then
				count = count-1;
			end
			tryes = tryes-1;
			if(tryes<0)then
				break;
			end
		end
	end
	swapPoints("battle", "quest", math.random(19, 21), 2, 99);
	swapPoints("quest", "rest", math.random(5, 6), 3, 0); -- 6
	swapPoints("battle", "elite", math.random(4, 5), 3, 1); -- 
	swapPoints("quest", "shop", math.random(3, 4), 2, 1); -- 4
	swapPoints("quest", "treasure", math.random(3, 4), 2, 9); -- 5
	if(login_obj.forgerest~=true)then
		swapPoints("quest", "forge", 1, 2, 0);
	end
	
	for i=1,#points do
		local point = points[i];
		local battle_lvl = point.lvl;
		if(point.ptype=="elite" and point.hidden==false)then
			local party = table.random(elites);
			local while_exit = 500;
			local lvl_try=300;
			while(party.lvl~=battle_lvl and while_exit>0)do
				party = table.random(elites);
				lvl_try = lvl_try-1;
				if(lvl_try<0)then
					lvl_try = 200;
					battle_lvl = battle_lvl-1;
				end
				while_exit = while_exit-1;
			end
			point.party = table.cloneByAttr(party);
		end
	end
	
	if(save_obj.act4 and login_obj.relics["Skull Green"]~=true)then
		local list = {};
		for i=1,#points do
			local point = points[i];
			if(point.ptype=="elite" and point.hidden~=true)then
				table.insert(list, point);
			end
		end
		if(#list>0)then
			local point = table.random(list);
			point.skull = true;
		end
	end
	
	for i=1,line_l do
		local tx = i*empty_w;
		for j=1,4 do
			local ty = -150 + (j-1)*empty_w;
			local point = helper[tx.."x"..ty];
			if(math.random()>0.6)then
				local ttx = tx + empty_w;
				local tty;
				if(math.random()>0.5)then
					tty = ty-100;
				else
					tty = ty+100;
					
				end
				
				local p3, p4 = helper[tx.."x"..tty], helper[ttx.."x"..ty];
				if(p3 and p4)then
					if(p3.nxt2==p4.id)then
						break;
					end
				end
				
				local npoint = helper[ttx.."x"..tty];
				if(npoint)then
					point.nxt2 = npoint.id;
				end
			end
		end
	end

	map.height = 500;
end
function get_wins_by_classes()
	local winsByClass = 0;
	for i=1,#heroes do
		local hero_obj = heroes[i];
		local win = getLoginStat("wins"..hero_obj.class);
		if(win>0)then
			winsByClass = winsByClass+1;
		end
	end
	return winsByClass;
end

function login_restart(dead)
	login_obj.potions_max = 3;
	login_obj.potions = {};
	login_obj.map = {lvl=1, width=800, height=300, points={}, point=nil};
	login_obj.exhaust_fail = 0;
	login_obj.energymax = 3;
	login_obj.cardsreward = 3;
	login_obj.restheal = 0;
	login_obj.resthealper5cards = 0;
	login_obj.treasureextrarelic = 0;
	login_obj.easyenemies = 0;
	login_obj.cardonbattle = 1;
	login_obj.consume = false;
	login_obj.removeatrest = false;
	login_obj.norest = false;
	login_obj.nosmith = false;
	login_obj.dead = dead or false;
	login_obj.eloot = {};
	login_obj.money_bonus = 0;
	login_obj.money_heals = 0;
	login_obj.lives = 0;
	login_obj.extraenergy = 0;
	login_obj.elitelootitems = 1;
	login_obj.hpmaxex = 0;
	
	login_obj.colorblind = false;
	login_obj.relicstoheal = false;
	login_obj.potionless = false;
	login_obj.forgerest = false;
	login_obj.sandbox = false;
	login_obj.ascend = false;
	login_obj.cheat = false;
	login_obj.daily = false;
	login_obj._ordinaldate = nil;

	login_obj.curses_negated = 0;
	login_obj.cardontreasure = 0;

	login_obj.autoupgradeattacks = false;
	login_obj.autoupgradeskills = false;
	login_obj.autoupgradepowers = false;
	-- login_obj.shop_remove_card
	login_obj.removecard_cost = 75;
	login_obj.removecard_inc = 25;
	
	-- local map = login_obj.map;
	
	login_obj.cards_scale_game = 1;
	
	login_obj.hiddentreasure = 0;
	login_obj.hiddennoenemies = 0;
	
	-- login_obj.enemystr = 0;
	-- login_obj.enemyregen = 0;
	-- login_obj.enemydemon = 0;
	-- login_obj.enemyhpper = 0;
	-- login_obj.enemybeatofdeath = 0;
	login_obj.mods = {};
	login_obj.herobonus = {};
	login_obj.enemiesbonus = {};
	login_obj.handicaps = nil;
	login_obj._cleandeck = nil;
	
	login_obj.weak = 0;
	login_obj.str = 0;
	login_obj.voodoo = 0;
	login_obj.poisonadd = 0;
	login_obj.emptychest = 0;
	
	settings.hideRelics = false;
	
	if(save_obj.rich==1)then login_obj.relics["Rich"] = true; end
	if(save_obj.rich==2)then login_obj.relics["Richer"] = true; end
	
	for i=1,#relics do
		local robj = relics[i];
		if(robj.rest)then
			if(robj.condition)then
				if(robj.condition.login)then
					for attr,val in pairs(robj.condition.login) do
						login_obj[attr] = 0;
					end
				end
			end
		end
	end
end
login_restart(true);

function login_ini(hero_obj)
	login_obj.hp=hero_obj.hp/1;
	login_obj.hpmax=hero_obj.hp/1;
	login_obj.tag=hero_obj.tag;
	login_obj.money=hero_obj.money;
	login_obj.scin = hero_obj.scin;
	login_obj.class = hero_obj.class;
	login_obj.tags = {};
	if(hero_obj.tags)then
		for i=1,#hero_obj.tags do
			local lbl = hero_obj.tags[i];
			login_obj.tags[lbl]=true;
		end
	end
	
	print("login_ini:", hero_obj.class);
	
	login_obj.deck = {};
	for j=1,#hero_obj.deck do
		local ctype = hero_obj.deck[j];
		
		if(cards_indexes[ctype])then
			table.insert(login_obj.deck, table.cloneByAttr(cards_indexes[ctype]));
		else
			print("missing card:", tostring(ctype));
			show_msg("missing card:"..tostring(ctype));
		end
	end
	
	login_obj.relics = {};
	login_restart();
end

function getAddDmgByAttr(list, attr, val)
	local dmg = 0;
	for i=1,#list do
		local obj = list[i];
		if(obj[attr] == val)then
			dmg = dmg+1;
		end
	end
	return dmg;
end
function getAddDmg(list, card_obj)
	local dmg = 0;
	if(card_obj.addDmgByCard)then
		local str = card_obj.addDmgByCard[1]:lower();
		for i=1,#list do
			local obj = list[i];
			local tag = obj.tag:lower();
			if(tag:find(str))then
				dmg = dmg + card_obj.addDmgByCard[2];
			end
		end
	end
	return dmg;
end
function getStatCountingRnd(card_obj, attr)
	local val = card_obj[attr] or 0;
	if(card_obj[attr.."Rnd"])then
		val = val + math.random(0, card_obj[attr.."Rnd"]);
	end
	return val;
end


function royal.getRelicNameByRid(rid)
	local robj = relics_indexes[rid];
	if(robj)then
		return royal.getRelicName(robj);
	else
		show_msg('cant_find:'..tostring(rid))
	end
	return 'unknow('..tostring(rid)..')'
end
function royal.getRelicName(robj)
	-- print('getRelicName', _G.settings.relicNames, );
	if(save_obj['item_nick_'..robj.tag])then
		return save_obj['item_nick_'..robj.tag];
	end
	if(_G.settings.relicNames)then
		local scin = robj.scin;
		local art_xml = get_xml_by_attr(arts_xml, 'type', tostring(scin));
		if(art_xml)then
			return get_name(art_xml.properties.tag);
		end
	end
	return get_name(robj.tag);
end
function saveSettings()
	local save_str = json.encode(settings);
	saveFile("settings.json", save_str);
end

function addTopBar(facemc, buttons, mana_bol)
	-- local bottom = display.newImage(facemc, "image/gui_game_border.png");
	-- bottom.width = _W;
	-- bottom.yScale = -_G.scaleGraphics/2;
	-- bottom.x, bottom.y = _W/2, bottom.contentHeight/2;
	-- bottom.alpha = 0;
	-- _G.topY = bottom.y;
	_G.topY = 22*scaleGraphics;
	
	local chainedBarX = 32*_G.scaleGraphics;
	-- if(optionsBuild == "ios")then
		-- chainedBarX =  chainedBarX + 22*scaleGraphics;
	-- end
	function facemc:addChainedBar(tw)
		chainedBarX = chainedBarX + tw/2;
		
		local bar = add_bar("black_bar3", tw);
		facemc:insert(bar);
		bar.x, bar.y = chainedBarX, topY;
		
		chainedBarX = chainedBarX + tw/2 + 4*_G.scaleGraphics;
		
		elite:add_chains_pair(facemc, "gui/chain4", bar.x, -4*scaleGraphics, tw-14*scaleGraphics, topY, 1);
		return bar;
	end
	
	local mbar = facemc:addChainedBar(24*scaleGraphics + math.max(3, #tostring(login_obj.money))*8*scaleGraphics);
	local moneyico = display.newImage(facemc, "image/money.png");
	moneyico.x, moneyico.y = mbar.x - mbar.w/2 + 12*_G.scaleGraphics, topY;
	moneyico:scale(_G.scaleGraphics/2, _G.scaleGraphics/2);
	facemc.moneyico = moneyico;
	local moneytxt = newOutlinedText(facemc, login_obj.money, moneyico.x, moneyico.y, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
	function facemc:moneyRefresh()
		if(moneytxt.contentWidth)then
			moneytxt:setText(login_obj.money);
			moneytxt.x = moneyico.x + moneytxt.contentWidth/2 + 10*_G.scaleGraphics;
		end
	end
	facemc:moneyRefresh();
	
	local hptxt = newOutlinedText(facemc, login_obj.hpmax.."/"..login_obj.hpmax, 0, topY, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
	local hpbar = facemc:addChainedBar(24*scaleGraphics + hptxt.width);
	local moneyico = display.newImage(facemc, "image/hp.png");
	moneyico.x, moneyico.y = hpbar.x - hpbar.w/2 + 12*_G.scaleGraphics, topY;
	moneyico:scale(_G.scaleGraphics/2, _G.scaleGraphics/2);
	hptxt:toFront();
	
	function facemc:hpRefresh()
		if(hptxt.contentWidth==nil)then
			return
		end
		if(login_obj.hp>login_obj.hpmax)then
			login_obj.hp = login_obj.hpmax;
		end
		hptxt:setText(login_obj.hp.."/"..login_obj.hpmax);
		hptxt.x = moneyico.x + hptxt.contentWidth/2 + 10*_G.scaleGraphics;
		
	end
	facemc:hpRefresh();
	
	if(mana_bol)then
		local mptxt = newOutlinedText(facemc, "???", 0, topY, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
		local mpbar = facemc:addChainedBar(50*scaleGraphics);
		local manaico = display.newImage(facemc, "image/mini/energy.png");
		manaico.x, manaico.y = mpbar.x - mpbar.w/2 + 12*_G.scaleGraphics, topY;
		manaico:scale(_G.scaleGraphics/2, _G.scaleGraphics/2);
		mptxt:toFront();
		
		function facemc:mpRefresh()
			local gameobj = login_obj.game;
			mptxt:setText(gameobj.energy.."/"..login_obj.energymax);
			mptxt.x = manaico.x + mptxt.contentWidth/2 + 10*_G.scaleGraphics;
			
		end
		-- facemc:mpRefresh();
	end
	
	-- facemc.book = newGroup(facemc);
	-- facemc.book.x, facemc.book.y = _W - 64*_G.scaleGraphics, 22*_G.scaleGraphics;
	-- local body = display.newImage(facemc.book, "image/deck.png");
	-- body:scale(_G.scaleGraphics/8, _G.scaleGraphics/8);
	-- facemc.book.dtxt = newOutlinedText(facemc.book, #login_obj.deck, 0, 0, fontMain, 18*_G.scaleGraphics, 1, 0, 1);
	
	-- facemc.book.act = function(e)
		-- showCardPick(facemc, facemc.parent.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, false);
	-- end
	-- table.insert(facemc.parent.buttons, facemc.book);
	-- facemc.book.w, facemc.book.h = 30*_G.scaleGraphics, 40*_G.scaleGraphics;
	-- function facemc.book:onOver()
		-- facemc.book.dtxt:setTextColor(0, 1, 0);
	-- end
	-- function facemc.book:onOut()
		-- facemc.book.dtxt:setTextColor(1, 1, 1);
	-- end
	-- function facemc.book:disabled()
		-- return facemc.wnd~=nil;
	-- end
	-- function facemc:bookRefresh()
		-- facemc.book.dtxt:setText(#login_obj.deck);
	-- end
	
	
	-- local hpbar = add_bar("black_bar3", 44*scaleGraphics);
	-- facemc:insert(hpbar);
	-- hpbar.x, hpbar.y = _W - 120*_G.scaleGraphics, topY;
	
	
	-- elite:add_chains_pair(facemc, "gui/chain4", hpbar.x, -4*scaleGraphics, 32*scaleGraphics, topY, 2);
	
	local hpbar = facemc:addChainedBar(44*scaleGraphics);
	local body = display.newImage(facemc, "image/deck.png");
	body:scale(_G.scaleGraphics/18, _G.scaleGraphics/18);
	body.x, body.y = hpbar.x - hpbar.w/2 + 12*_G.scaleGraphics, topY;
	
	facemc.book = hpbar;
	facemc.book.dtxt = newOutlinedText(facemc, #login_obj.deck, hpbar.x + 6*scaleGraphics, hpbar.y, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
	-- function facemc:moneyRefresh()
		-- if(moneytxt.contentWidth)then
			-- moneytxt:setText(login_obj.money);
			-- moneytxt.x = moneyico.x + moneytxt.contentWidth/2 + 10*_G.scaleGraphics;
		-- end
	-- end
	-- facemc:moneyRefresh();
	
	facemc.book.act = function(e)
		showCardPick(facemc, facemc.parent.buttons, facemc.book.x, facemc.book.y, login_obj.deck, false, false);
	end
	table.insert(facemc.parent.buttons, facemc.book);
	elite.addOverOutBrightness(facemc.book, hpbar);
	function facemc.book:disabled()
		return facemc.wnd~=nil;
	end
	function facemc:bookRefresh()
		facemc.book.dtxt:setText(#login_obj.deck);
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
			if(btn.onRefresh)then
				btn:onRefresh();
			end
		end
		btn:refresh();
		
		btn.hint=get_txt(title);
		btn.act = function()
			if(act)then
				act();
			end
			btn:refresh();
		end
		table.insert(buttons, btn);
		btn.w, btn.h = 40*scaleGraphics, 40*scaleGraphics;
		elite.addOverOutBrightness(btn);

		function btn:disabled()
			return tar.wnd~=nil;
		end
		return btn;
	end

	local pause_switch;
	local pauseBol = false;
	pause_switch = function(forse)
		if(forse==false or forse==nil)then
			if(facemc.wnd)then
				if(facemc.wnd.onCloseExt)then
					facemc.wnd.onCloseExt();
				end
				facemc.wnd:removeSelf();
				facemc.wnd = nil;
				if(facemc.refreshHand)then
					facemc:refreshHand()
				end
				pauseBol = false;
				return true
			end
		end
		
		if(forse==true or forse==nil)then
			if(facemc.wnd)then
				return true
			end
			if(facemc.insert==nil)then
				return true
			end
			local wnd = newGroup(facemc);
			local wndbg = display.newRect(wnd, _W/2, _H/2, _W, _H);
			wndbg:setFillColor(0,0,0,0.75);

			function facemc:showCardsLib(class)
				if(wnd.wndEx)then
					if(wnd.wndEx.removeSelf)then
						wnd.wndEx:removeSelf();
					end
					wnd.wndEx = nil;
				end
				
				if(wnd.insert==nil)then
					return
				end
				
				local extramc = newGroup(wnd);
				wnd.wndEx = extramc;
				
				if(system.getInfo("environment")=="simulator" and false)then
					local temp = {};
					local tempI = 14077818;
					local oldscale = _G.scaleGraphics;
					_G.scaleGraphics = 4;
					for i=1,#cards do
						if(cards[i].class==class)then
							local card_obj = cards[i];
							local cardmc, body = createCardMC(extramc, card_obj, nil, card_obj.class);
							local baseDir = system.TemporaryDirectory;
							local fname = card_obj.class.."_"..card_obj.ctype..card_obj.rarity.."_"..card_obj.tag..".png";
							display.save(cardmc, {filename=fname, baseDir=baseDir, captureOffscreenArea=true});
							cardmc:removeSelf();
							if(card_obj.ctype==CTYPE_SKILL)then
								table.insert(temp, "[previewimg="..tempI..";sizeOriginal,floatLeft;"..fname.."][/previewimg]");
								tempI = tempI+1;
							end
						end
					end
					local str = table.concat(temp, "");
					saveFile("__"..class..".txt", str, system.TemporaryDirectory);
					_G.scaleGraphics = oldscale;
				end

				local list = {};
				for i=1,#cards do
					if(cards[i].class==class)then
						table.insert(list, cards[i]);
					end
				end
				
				
				
				local listmc = showCardPick(extramc, facemc.buttons, facemc.book.x, facemc.book.y, list, false, false, function(new_card, mc)
				
				end);
				
				local cardsmc = listmc.cards;
				for i=1,cardsmc.numChildren do
					local mc = cardsmc[i];
					if(mc.card_obj)then
						local id = get_name_id(mc.card_obj.tag);
						if(save_obj.unlocks['card_'..id]~=2)then
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
				end
			end
			function facemc:showTutorial()
				if(wnd.wndEx)then
					wnd.wndEx:removeSelf();
					wnd.wndEx = nil;
				end
				local extramc = newGroup(wnd);
				local page = 1;
				
				-- local rct = display.newRect(extramc, 0, 0, _W, _H);
				-- rct:setFillColor(0, 0, 0, 2/3);
				-- (tar, utype, tx, ty, tw, th, index)
				elite:add_chains_pair(extramc, "gui/chain4", 0, -_H/2-2*scaleGraphics, 260*scaleGraphics, _H/2);
				
				local bg = add_bg_title("bg_3", 500*scaleGraphics, 240*scaleGraphics, get_txt('tutorial'));
				bg.x, bg.y = 0, 0;
				extramc:insert(bg);
				extramc.x, extramc.y = _W/2, _H/2;
				
				local c = display.newImage(extramc, "image/gui/bg_out_stat.png");
				c:translate(bg.w/2 + 11, bg.h/2 - c.contentHeight/2);
				local c = display.newImage(extramc, "image/gui/bg_out_stat.png");
				c.xScale = -1;
				c:translate(-(bg.w/2 + 11), bg.h/2 - c.contentHeight/2);
				
				local pagemc = newGroup(extramc);
				local function showPage()
					bg:setText(get_txt('tutorial').." "..page.."/3");
					save_obj["tutorial"..page]=true;
					
					cleanGroup(pagemc);
					local img = display.newImage(pagemc, "tutorial/page"..page..".jpg");
					if(img)then
						img:scale(scaleGraphics/3, scaleGraphics/3);
						img.x = -bg.w/2 + img.contentWidth/2 + 10*scaleGraphics;
					
						local tw = bg.w - img.contentWidth - 20*scaleGraphics;
						local dtxt = eliteText:newText(get_txt("tutorial_rbq_"..page), tw, 14*scaleGraphics, false, true);
						dtxt.x, dtxt.y = bg.w/2 - tw - 10*scaleGraphics, -dtxt.h/2 - 10*scaleGraphics;
						pagemc:insert(dtxt);
					end
				end
				showPage();
				
				function bg:act()
					if(page<3)then
						page = page+1;
						showPage();
					else
						-- extramc:removeSelf();
						if(wnd.onClose)then
							wnd:onClose();
						else
							facemc:showResize();
						end
						-- facemc.wnd = nil;
					end
				end
				table.insert(facemc.buttons, bg);
				elite.addOverOutBrightness(bg);
				
				wnd.wndEx = extramc;
			end
			function facemc:showResize()
				if(wnd.wndEx)then
					if(wnd.wndEx.removeSelf)then
						wnd.wndEx:removeSelf();
					end
					wnd.wndEx = nil;
				end
				if(wnd.insert==nil)then
					return
				end
				local extramc = newGroup(wnd);
				
				elite:add_chains_pair(extramc, "gui/chain4", _W/2, -4*scaleGraphics, 200*scaleGraphics, _H/2);
				local bg = add_bg_title("bg_3", 300*scaleGraphics, 280*scaleGraphics, get_txt('resize'));
				bg.x, bg.y = _W/2, _H/2;
				extramc:insert(bg);
				
				-- print('TODO: pause resize GUI')
				if(false)then
				local function addRoaylBtn(par, tx, ty, hint, act, img, scale)
					local btn = newGroup(par);
					btn:translate(tx, ty);
					local img = display.newImage(btn, img);
					if(scale==nil)then scale=1; end
					img:scale(scale*scaleGraphics/2, scale*scaleGraphics/2);
					
					btn.hint = get_txt(hint);
					btn.act = act;
					elite.addOverOutBrightness(btn, img);

					btn.w, btn.h = img.contentWidth, img.contentHeight;
					table.insert(buttons, btn);
					return btn, img;
				end
				local btnSizeY = 30*scaleGraphics;
				local btn = addRoaylBtn(extramc, _W/2 - 20*scaleGraphics, btnSizeY, "minus", function()
					_G.scaleGraphics = _G.scaleGraphics-0.1;
					_G.scaleGraphics = math.round(_G.scaleGraphics*20)/20;
					resizeForce();
					-- if(scaleGraphics>2)then _G.scaleGraphics = _G.scaleGraphics-0.1; end
					-- Runtime:dispatchEvent({name="resize"});
					-- show_msg(get_txt('scale')..": "..(scaleGraphics*100).."%")
					-- show_start(true);
					require("eliteScale").saveScales();
					return
				end, "image/button/minus.png");
				
				local btn = addRoaylBtn(extramc, _W/2 + 20*scaleGraphics, btnSizeY, "plus", function()
					_G.scaleGraphics = _G.scaleGraphics+0.1;
					_G.scaleGraphics = math.round(_G.scaleGraphics*20)/20;
					resizeForce();
					-- if(scaleGraphics>2)then _G.scaleGraphics = _G.scaleGraphics+0.1; end
					-- Runtime:dispatchEvent({name="resize", target=Runtime});
					-- show_msg(get_txt('scale')..": "..(scaleGraphics*100).."%")
					-- show_start(true);
					require("eliteScale").saveScales();
					return
				end, "image/button/plus.png");
				end
				
				local function addCtrl(title, tx, ty, tar, attr)
					local mc = newGroup(extramc);
					mc:translate(tx, ty);
					local dtxt = display.newText(mc, get_txt(title), 0, -14*scaleGraphics, fontMain, 12*scaleGraphics);
					local ptxt = display.newText(mc, (settings[attr]*100).."%", 0, 0*scaleGraphics, fontMain, 12*scaleGraphics);
					
					local function addCtrlBtn(tx, ty, ipath, act)
						local img = display.newImage(mc, ipath, tx, ty);
						img:scale(scaleGraphics/2, scaleGraphics/2);
						elite.addOverOutBrightness(img);
						
						img.act = act;
						table.insert(buttons, img);
						img.w, img.h = 20*scaleGraphics, 20*scaleGraphics;
					end
					
					local function adjustBtnxY()
						-- if(facemc.energyBtn)then
							-- facemc.energyBtn.y = math.min(_H - 172*_G.settings.cardScaleMin*scaleGraphics - 10*scaleGraphics, _H - 90*scaleGraphics);
							-- facemc.turnBtn.y = facemc.energyBtn.y;
						-- end
						if(facemc.parent)then
							if(facemc.parent.resize)then
								facemc.parent:resize();
							end
						end
					end
					addCtrlBtn(-26*scaleGraphics, 0, "image/gui/btnMinus.png", function()
						settings[attr] = settings[attr]-0.05;
						tar.xScale, tar.yScale = settings[attr], settings[attr];
						ptxt.text = (settings[attr]*100).."%";
						saveSettings();
						
						if(facemc.refreshHand)then
							facemc:refreshHand();
							adjustBtnxY();
							
						end
					end);
					addCtrlBtn(26*scaleGraphics, 0, "image/gui/btnPlus.png", function()
						settings[attr] = settings[attr]+0.05;
						tar.xScale, tar.yScale = settings[attr], settings[attr];
						ptxt.text = (settings[attr]*100).."%";
						saveSettings();
						
						if(facemc.refreshHand)then
							facemc:refreshHand();
							adjustBtnxY();
						end
					end);
				end
				
				local card_obj = cards_indexes["Strike"];
				local mc, body, ntxt = createCardMC(extramc, card_obj);
				body.xScale, body.yScale = settings.cardScaleMax, settings.cardScaleMax;
				mc.x, mc.y = _W/2+70*scaleGraphics, _H/2 -16*scaleGraphics;
				addCtrl("over", mc.x, _H/2 + 92*scaleGraphics, body, "cardScaleMax");
				
				local card_obj = cards_indexes["Strike"];
				local mc, body, ntxt = createCardMC(extramc, card_obj);
				mc.x, mc.y = _W/2-70*scaleGraphics, _H/2 -16*scaleGraphics;
				addCtrl("default", mc.x, _H/2 + 92*scaleGraphics, body, "cardScaleMin");
				
				local dtxt = display.newText(extramc, get_txt('custom_class_type_card_colors'), _W/2, _H/2 + bg.h/2 - 30*scaleGraphics, fontMain, 8*scaleGraphics);
				
				local hero_obj = getHeroObjByAttr("class", login_obj.class);
				if(hero_obj)then
					local pickermc = newGroup(extramc); -- cards_ctype1_.png
					for i=1,6 do
						local ico = display.newImage(pickermc, "image/cards_ctype"..i.."_.png");
						ico:scale(scaleGraphics/2, scaleGraphics/2);
						ico.x = _W/2 + 28*scaleGraphics*(i - 7/2);
						ico.y = _H/2 + bg.h/2 - 14*scaleGraphics;
						
						-- hero_obj.hue "hue" saturate saturation
						-- save_obj['custom_ccc_'..hero_obj.class..'_'..i]
						
						-- save_obj['custom_scin_'..hero_obj.class.."_cards"..set_id] = custom_cards;
						-- custom_cards[effect.prm1] = body_mc.fill.effect[effect.prm1][effect.prm2];
						
						-- img.fill.effect = "filter.hue";
						-- img.fill.effect.angle = hue;

						-- img.fill.effect = "filter.saturate";
						-- img.fill.effect.intensity = saturate;
						
						-- if(custom_filters.hue)then hue = custom_filters.hue; end
						-- if(custom_filters.saturate)then saturation = custom_filters.saturate; end
						
						ico.fill.effect = "filter.hue";
						ico.fill.effect.angle = -hero_obj.hue;
						if(save_obj['custom_ccc_'..hero_obj.class..'_'..i])then
							ico.fill.effect.angle = save_obj['custom_ccc_'..hero_obj.class..'_'..i].hue;
						end
		
		
						ico.act = function()
							if(ico.fill.effect.angle ~= -hero_obj.hue)then
								save_obj['custom_ccc_'..hero_obj.class..'_'..i] = nil;
								ico.fill.effect.angle = -hero_obj.hue;
							else
								save_obj['custom_ccc_'..hero_obj.class..'_'..i] = {hue=math.random(1, 360)};
								ico.fill.effect.angle = save_obj['custom_ccc_'..hero_obj.class..'_'..i].hue;
							end
							
							-- if(facemc.refreshHand)then
								-- facemc:refreshHand(true);
							-- end
							if(facemc.remakeCards)then
								facemc:remakeCards();
							end
						end
						-- ico.hint = get_txt('custom_class_type_card_colors');
						
						ico.w, ico.h = 24*scaleGraphics, 24*scaleGraphics;
						table.insert(buttons, ico);
					end
				end
				
				wnd.wndEx = extramc;
			end
			
			-- facemc:showTutorial();
			facemc:showResize();
			
			local cntrlsmc = newGroup(wnd);
			local dy = 44*scaleGraphics;
			elite:add_chains_pair(cntrlsmc, "gui/chain4", _W - 22*scaleGraphics, -4*scaleGraphics, 16*scaleGraphics, dy*4 - 10*scaleGraphics);
			
			addRoundBtn(cntrlsmc, "continue", _W - 22*scaleGraphics, 22*scaleGraphics + 0*dy, "image/gui/btn_next.png", pause_switch);
			addRoundBtn(cntrlsmc, "tutorial", _W - 22*scaleGraphics, 22*scaleGraphics + 1*dy, "image/gui/btn_high_on.png", facemc.showTutorial);
			addRoundBtn(cntrlsmc, "music", _W - 22*scaleGraphics, 22*scaleGraphics + 2*dy, "image/gui/btn_music.png", eliteSoundsIns.switchMusic, "image/gui/btn_music_off.png", eliteSoundsIns.getMusicBol);
			addRoundBtn(cntrlsmc, "sound", _W - 22*scaleGraphics, 22*scaleGraphics + 3*dy, "image/gui/btn_sound.png", eliteSoundsIns.switchSound, "image/gui/btn_sound_off.png", eliteSoundsIns.getSoundBol);
			local dbtn1 = addRoundBtn(cntrlsmc, "library", _W - 22*scaleGraphics, 22*scaleGraphics + 4*dy, "image/gui/deck_color.png", function()
				facemc:showCardsLib(login_obj.class);
			end);
			local dbtn2 = addRoundBtn(cntrlsmc, "library", _W - 22*scaleGraphics, 22*scaleGraphics + 5*dy, "image/gui/deck_color.png", function()
				facemc:showCardsLib("none");
			end);
			addRoundBtn(cntrlsmc, "exit", _W - 22*scaleGraphics, 22*scaleGraphics + 6*dy, "image/gui/btn_restore.png", function() show_start(); end);
			
			
			-- local img = display.newImage(dbtn, "image/gui/deck_color_.png");
			function dbtn1:onRefresh()
				local class = login_obj.class;
				local hue, saturation = 0, 1;
				local hero_obj = getHeroObjByAttr("class", class);
				if(hero_obj)then
					if(hero_obj.hue)then
						hue = -hero_obj.hue;
					end
				end
				if(class=="none")then
					hue, saturation = 0, 0;
				end
				local cfront = newShaderImage(dbtn1, "image/gui/deck_color_.png", hue, saturation, true);
			end
			dbtn1:onRefresh();
			
			function dbtn2:onRefresh()
				local cfront = newShaderImage(dbtn2, "image/gui/deck_color_.png", 0, 0, true);
			end
			dbtn2:onRefresh();
			
			function facemc:pauseHideCtrls(onClose)
				cleanGroup(cntrlsmc);
				wnd.onClose = onClose;
			end
			
			facemc.wnd = wnd;
			pauseBol = true;
		end
	end
	
	local pauseX = _W - 22*scaleGraphics;
	local pauseChains = elite:add_chains_pair(facemc, "gui/chain4", pauseX, -4*scaleGraphics, 16*scaleGraphics, topY, 1);
	local pause_btn = addRoundBtn(facemc, "pause", pauseX, 22*scaleGraphics, "image/gui/btn_pause.png", pause_switch);
	function facemc:pause_switch(force)
		pause_switch(force);
	end
	
	function facemc:refreshGUI()
		pauseX = _W - 22*scaleGraphics;
		pause_btn.xScale, pause_btn.yScale = scaleGraphics/2, scaleGraphics/2;
		pause_btn.x, pause_btn.y = pauseX, 22*scaleGraphics;
		pauseChains.x, pauseChains.y = pauseX, -4*scaleGraphics;
	end
	
	local relicsbar = facemc:addChainedBar(40*scaleGraphics);
	local rich_status = save_obj.rich or (save_obj.donation or 0);
	local body = display.newImage(facemc, "image/relics"..rich_status..".png", relicsbar.x - relicsbar.w/2 + 12*_G.scaleGraphics, relicsbar.y);
	body:scale(scaleGraphics/2, scaleGraphics/2);
	
	local rcounttxt = newOutlinedText(facemc, royal:getRelicCount(), relicsbar.x + 6*scaleGraphics, relicsbar.y, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
	local relicsmc = newGroup(facemc);
	relicsbar.hint = get_txt("items");
	relicsbar.act = function(e)
		-- cleanGroup(relicsmc);
		-- facemc:refreshRelics()
		settings.hideRelics = not settings.hideRelics;
		if(settings.hideRelics)then
			cleanGroup(relicsmc);
		else
			facemc:refreshRelics();
		end
		
		if(facemc.parent)then
			if(facemc.parent.regroup)then
				facemc.parent:regroup()
			end
		end
		
		saveSettings();
	end
	table.insert(facemc.parent.buttons, relicsbar);
	elite.addOverOutBrightness(relicsbar, relicsbar);
	function relicsbar:disabled()
		return facemc.wnd~=nil;
	end

	local relic1txt = newOutlinedText(facemc, "", 0, 80*_G.scaleGraphics, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
	relic1txt:setTextColor(237/255, 198/255, 80/255);
	local relic2txt = newOutlinedText(facemc, "", 0, 96*_G.scaleGraphics, fontMain, 10*_G.scaleGraphics, 1, 0, 1);
	
	function facemc:getRelicMC(tag)
		for i=relicsmc.numChildren,1,-1 do
			local rmc = relicsmc[i];
			if(rmc.tag==tag)then
				return rmc;
			end
		end
	end
	function facemc:refreshRelicsIndicators(hero)
		for i=1,relicsmc.numChildren do
			local rmc = relicsmc[i];
			print(i, rmc.imc)
			if(rmc.imc)then
				rmc:refresh();
			end
		end
	end
	function facemc:refreshRelics(hero)
		local j=0;
		cleanGroup(relicsmc);
		if(settings.hideRelics)then
			return
		end
		
		local dx = 40*scaleGraphics;
		for i=1,#relics do
			local robj = relics[i];
			if(login_obj.relics[robj.tag] and robj.hidden~=true)then
				local scin = robj.scin or 100;
				local rmc = newGroup(relicsmc);
				rmc.tag = robj.tag;
				rmc.x, rmc.y = 20*scaleGraphics + j*dx, 56*scaleGraphics;
				local ico = display.newImage(rmc, "image/arts/item_"..scin..".png");
				ico:scale(scaleGraphics/2, scaleGraphics/2);
				
				function rmc:refresh()
					if(rmc.imc and rmc.imc.removeSelf)then
						rmc.imc:removeSelf();
						rmc.imc = nil;
					end
					if(hero and robj.indicatorHero)then
						local val = hero[robj.indicatorHero] or 0;
						if(val>0)then
							local imc = newGroup(rmc);
							imc.x, imc.y = 10*scaleGraphics, 10*scaleGraphics;
							local ibg = display.newRoundedRect(imc, 0, 0, 10*scaleGraphics, 10*scaleGraphics, 2*scaleGraphics);
							ibg:setFillColor(0,0,0,1/3);
							local itxt = display.newText(imc, val, 0, 0, fontNumbers, 10*scaleGraphics);
							itxt:setTextColor(8/9);
							
							if(robj.max and robj.rest)then
								if(getRunStat("_"..robj.rest)>=robj.max)then
									itxt:setTextColor(236/255, 197/255, 80/255);
								end
							end
							rmc.imc = imc;
						-- else
							-- ico.fill.effect = "filter.grayscale";
						end
					elseif(robj.indicator)then
						if(login_obj[robj.indicator]==nil)then
							login_obj[robj.indicator] = 0;
						end
						local val = login_obj[robj.indicator];
						if(val>0)then
							local imc = newGroup(rmc);
							imc.x, imc.y = 10*scaleGraphics, 10*scaleGraphics;
							local ibg = display.newRoundedRect(imc, 0, 0, 10*scaleGraphics, 10*scaleGraphics, 2*scaleGraphics);
							ibg:setFillColor(0,0,0,1/3);
							local itxt = display.newText(imc, val, 0, 0, fontNumbers, 10*scaleGraphics);
							itxt:setTextColor(8/9);
							
							if(robj.max and robj.rest)then
								if(getRunStat("_"..robj.rest)>=robj.max)then
									itxt:setTextColor(236/255, 197/255, 80/255);
								end
							end
							rmc.imc = imc;
						else
							ico.fill.effect = "filter.grayscale";
						end
					end
				end
				rmc:refresh();
				
				table.insert(buttons, rmc);
				rmc.w, rmc.h = 30*scaleGraphics, 30*scaleGraphics;

				local name = get_name(robj.tag);
				
				if(_G.settings)then
					if(_G.settings.relicNames)then
						local art_xml = get_xml_by_attr(arts_xml, 'type', tostring(scin));
						if(art_xml)then
							name = get_name(art_xml.properties.tag);--.." ("..name..")";
						end
					end
				end
				
				if(robj.lbl)then
					name = name.." ("..robj.lbl..")"
				end
				local hint = getRelicDesc(robj);
				function rmc:disabled()
					return facemc.wnd~=nil;
				end
				function rmc:onOver()
					relic1txt:setText(name);
					relic2txt:setText(hint);

					relic1txt.x = math.min(math.max(rmc.x, relic1txt.width/2), _W-relic1txt.width/2);
					relic2txt.x = math.min(math.max(rmc.x, relic2txt.width/2), _W-relic2txt.width/2);
					
					if(options_mobile)then
						addHint(hint);
					end
				end
				function rmc:onOut()
					relic1txt:setText("");
					relic2txt:setText("");
				end
				function rmc:act()
					rmc:onOver();
					if(robj.condition and robj.login==nil and robj.quest==nil)then

						local txt_arr = {};
						table.insert(txt_arr, get_txt('confirming'));
						local txt = get_txt('removing_by_name'):gsub("NAME", name)
						table.insert(txt_arr, txt);
						table.insert(txt_arr, hint);
						local cnfr_mc = royal.show_wnd_question(facemc, facemc.buttons, txt_arr, function()
							removeRelic(robj.tag, facemc);
							facemc:refreshRelics();
						end, function()
							
						end);
						cnfr_mc.x, cnfr_mc.y = _W/2 - cnfr_mc.w/2, _H/2 - cnfr_mc.h/2;
					else
						show_msg(get_txt("removing_not_possible"));
					end
				end
				
				j=j+1;
			end
		end
		
		local l = relicsmc.numChildren;
		local w = _W-10*scaleGraphics;
		local resort = false;
		while(dx*l>w and dx>10)do
			dx = dx-1;
			resort = true;
		end
		if(resort)then
			local sx = (_W - dx*(l-1))/2;
			for i=1,relicsmc.numChildren do
				local rmc = relicsmc[i];
				rmc.x, rmc.y = sx + (i-1)*dx, 56*scaleGraphics;
			end
		end
		
		rcounttxt:setText(royal:getRelicCount());
	end
	facemc:refreshRelics();
	
	function facemc:blinkRelicByAttr(attr1, attr2)
		print('TODO:blink!', attr1, attr2);
	end
	
	
	
	-- potions_max = 3, potions = {"Block Potion", "Explosive Potion", "Fire Potion"},
	-- login_obj.potions_max
	-- local pbar = add_bar("black_bar3", 74*scaleGraphics);
	-- facemc:insert(pbar);
	-- pbar.x, pbar.y = (150 + 24*2)*scaleGraphics, topY;
	-- elite:add_chains_pair(facemc, "gui/chain4", pbar.x, -4*scaleGraphics, 38*scaleGraphics, topY, 2);
	local pbar = facemc:addChainedBar(74*scaleGraphics);
	local potionsmc = newGroup(facemc);
	facemc.potionsmc = potionsmc;
	facemc.potionsX = pbar.x;
	
	function facemc:refreshPotions()	
		if(login_obj.potions==nil)then login_obj.potions={}; end
		print("potions:", #login_obj.potions, login_obj.potions_max);
		if(#login_obj.potions > login_obj.potions_max)then
			table.remove(login_obj.potions, #login_obj.potions);
			print("", 'too much potions! lets loose one.');
		end
		refreshPotions(facemc, buttons);
	end
	facemc:refreshPotions();
	
	
	
	function facemc:showScores()
		local scores = 0;
		local function addScore(id, val)
			scores = scores + getRunStat(id)*val;
			-- addItemTxt(get_txt("stat_"..id).." ("..getRunStat(id)..")", getRunStat(id)*val);
		end
		addScore("floors", 5); -- Floors Climbed	Number of the Floor you reached (including the narrative Floor 51)	5 per floor
		addScore("kills", 2); -- Enemies Killed	For each normal encounter defeated	2 per enemy
		addScore("elites1", 10); -- Exordium Elites Killed	For each killed Elite in the Exordium	10 per Elite
		addScore("elites2", 20); -- City Elites Killed	For each killed Elite in the City	20 per Elite
		addScore("elites3", 30); -- Beyond Elites Killed	For each killed Elite in the Beyond	30 per Elite
		addScore("bosses", 50); -- Bosses Slain	For each defeated Boss	50 per Boss
		addScore("skulls", 20);
		-- scores=math.random(1,99);
		
		local scrbar = facemc:addChainedBar(34*scaleGraphics + 5*scaleGraphics*string.len(tostring(scores)));
		local moneyico = display.newImage(facemc, "image/scores1.png");
		moneyico.x, moneyico.y = scrbar.x - scrbar.w/2 + 12*_G.scaleGraphics, topY;
		moneyico:scale(_G.scaleGraphics/2, _G.scaleGraphics/2);
		local scoretxt = newOutlinedText(facemc, scores, scrbar.x + scrbar.w/2 - 2*scaleGraphics, moneyico.y, fontMain, 12*_G.scaleGraphics, 1, 0, 1);
		scoretxt:translate(-scoretxt.width/2, 0);
		
		scrbar.act = function(e)
			show_end();
		end
		table.insert(facemc.parent.buttons, scrbar);
		elite.addOverOutBrightness(scrbar, scrbar);
		function scrbar:disabled()
			return facemc.wnd~=nil;
		end
	end
end
function refreshPotions(facemc, buttons)
	local potionsmc = facemc.potionsmc;
	cleanGroup(potionsmc);
	if(save_obj.potions==nil)then save_obj.potions={}; end
	
	for i=1,login_obj.potions_max do
		local mc = newGroup(potionsmc); 
		mc.x, mc.y = facemc.potionsX + (i - login_obj.potions_max/2 - 0.5)*24*scaleGraphics, topY;
		
		local ico;
		local potion_id = login_obj.potions[i];
		if(potion_id)then
			ico = display.newImage(mc, "image/potions/"..get_name_id(potion_id)..".png");
		else
			ico = display.newImage(mc, "image/potions/_empty.png");
		end
		if(ico==nil)then
			ico = display.newImage(mc, "image/potions/_unknow.png");
		end
		ico:scale(scaleGraphics/2, scaleGraphics/2);
		mc.potion_id = potion_id;
		mc.ico = ico;
		mc.id = i;
		
		if(mc.potion_id)then
			local card_obj = _G.potions_indexes[mc.potion_id] or save_obj.potions[mc.potion_id];

			local ico = mc.ico;
			function mc:onOver()
				ico.fill.effect = "filter.brightness";
				ico.fill.effect.intensity=0.1;
			end
			function mc:onOut()
				ico.fill.effect = nil;
			end
			print("_card_obj:", mc.potion_id, card_obj);
			mc.hint = get_name(mc.potion_id).." ("..getCardDesc(card_obj)..")";
		else
			mc.hint = get_txt("potion_slot");
			-- mc.hint = get_txt("potion_slot_hint");
		end
		
		table.insert(buttons, mc);
		mc.w, mc.h = 20*scaleGraphics, 20*scaleGraphics;
	end
end
function addBtn(tar, buttons, txt, tx, ty, act)
	local btn = newGroup(tar);
	btn.x, btn.y = tx, ty;
	local btnbg = display.newRect(btn, 0, 0, 60*scaleGraphics, 20*scaleGraphics);
	btnbg:setFillColor(1/3);
	local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 16*scaleGraphics);
	btn.act = act;
	function btn:onOver()
		dtxt:setTextColor(5/6);
	end
	function btn:onOut()
		dtxt:setTextColor(1);
	end
	table.insert(buttons, btn);
	btn.w, btn.h = btnbg.width, btnbg.height;
	return btn;
end

function transformCard(card_obj, mc)
	local tag = card_obj.tag;
	local ctype = card_obj.ctype;
	local class = card_obj.class;
	
	local new_card = table.random(cards);
	while(new_card.tag==tag or (new_card.class~=class and class~="any") or (new_card.class~=login_obj.class and class=="any") or new_card.class=="any")do
		new_card = table.random(cards);
	end
	-- print("transformCard:", new_card.class, class)
	
	for attr,val in pairs(card_obj) do
		card_obj[attr] = nil;
	end
	for attr,val in pairs(new_card) do
		card_obj[attr] = val;
	end
	
	if(card_obj.ctype==CTYPE_ATTACK and login_obj.autoupgradeattacks)then upgradeCard(card_obj); end
	if(card_obj.ctype==CTYPE_SKILL and login_obj.autoupgradeskills)then upgradeCard(card_obj); end
	if(card_obj.ctype==CTYPE_POWER and login_obj.autoupgradepowers)then upgradeCard(card_obj); end
	
	addCardAni(card_obj);

	if(mc)then mc:update(); end
	return true
end
function upgradeCard(card_obj, mc, event)
	if(card_obj.lvl==nil)then card_obj.lvl=1; end
	if(card_obj.lvl>1 and card_obj.unlimited~=true)then return false; end
	card_obj.lvl = card_obj.lvl+1;
	
	-- print(card_obj.tag, card_obj.onUpgrade);
	if(card_obj.onUpgrade)then
		for attr,val in pairs(card_obj.onUpgrade) do
			if(val==null)then
				val = nil;
			end
			-- print(card_obj.tag, card_obj.lvl, attr, val);
			if(attr=="energy")then
				if(val==X or card_obj[attr]==X)then
					card_obj[attr] = X;
				else
					card_obj[attr] = math.min(val, card_obj[attr]);
				end
			else
				card_obj[attr] = val;
			end
		end
	end
	
	if(event)then
		addCardAni(card_obj);
	end
	
	if(mc and mc.removeSelf)then mc:update(); end
	return true
end
function removeCardAni(card_obj)
	print("TODO:removeCardAni", card_obj.tag);
end
function royal:fillCardLoot()
	login_obj.cloot = {};
	for i=1,#cards do
		local cobj = cards[i];

		-- "state":"hidden"
		local hero_obj = getHeroObjByAttr("class", cobj.class);
		local state = "ok";
		if(hero_obj)then
			state = hero_obj.state;
		end
		
		if(cobj.class==login_obj.class or (login_obj.colorblind and state~="hidden" and cobj.class~="negative" and cobj.class~="none"))then
			if(cobj.rarity>0)then
				for j=cobj.rarity,3 do
					table.insert(login_obj.cloot, cobj.tag);
					for k=cobj.rarity,3 do
						table.insert(login_obj.cloot, cobj.tag);
					end
				end
			end
		end
	end
	print("loot options:", #login_obj.cloot);
end
function _G.getCardLoot(cardsreward, rarity, class, upgradeable)
	local loot = {};
	if(login_obj.cloot==nil)then
		royal:fillCardLoot();
	end
	if(#login_obj.cloot==0)then
		royal:fillCardLoot(); -- colorblind
	end
	if(#login_obj.cloot==0)then
		show_msg("Maybe she have all cards with RARITY=0? or none at all?");
		show_msg("This hero have no cards to pick from");
		show_map();
		return
	end
	for i=1,cardsreward do
		local tag;
		local again = true;
		local save = 2000;
		while(again and save>0)do
			tag = table.random(login_obj.cloot);
			again = false;
			if(#loot>0)then
				for j=1,#loot do
					if(loot[j]==tag)then
						again = true;
					end
				end
			end
			if(cards_indexes[tag]==nil)then -- check if card is obsolete
				again = true;
			end
			if(class~=nil and class~=cards_indexes[tag].class)then
				if(login_obj.colorblind~=true)then
					again = true;
				end
			end
			
			if(rarity~=nil)then
				local card_obj = cards_indexes[tag];
				if(card_obj)then
					if(card_obj.rarity~=rarity)then
						again = true;
					end
				else
					again = true;
				end
			end
			save = save-1;
		end
		table.insert(loot, tag);
		local card_obj = cards_indexes[tag];
		-- print('loot card:', save, card_obj.tag, card_obj.rarity, rarity, card_obj.rarity==rarity);
	end
	
	local list = {};
	local upgraded = #loot-1;
	for i=1,#loot do
		local ctype = loot[i];
		if(cards_indexes[ctype])then
			local card_obj = table.cloneByAttr(cards_indexes[ctype]);
			if(upgraded>0 and login_obj.map.lvl>1 and math.random()>0.5 and upgradeable~=false)then
				upgradeCard(card_obj);
				upgraded = upgraded-1;
			end
			table.insert(list, card_obj);
		end
	end
	return list;
end

function showCardPick(facemc, buttons, sx, sy, list, amount, upgradeable, callback, onClose, force, prms)
	if(facemc.insert==nil)then -- hapens when called after leaveing the screen. forge * loading data
		return false
	end
	if(force==nil)then force=true; end
	if(list==nil)then
		print('something went wrong!');
		return false
	end
	
	local cardDY = 160*scaleGraphics;
	if(prms)then
		if(prms.cardDY)then
			cardDY = cardDY + prms.cardDY;
		end
		if(prms.limit)then
			if(prms.limit<#list)then
				local newlist = {};
				for i=#list,(#list-prms.limit)+1,-1 do
					table.insert(newlist, list[i]);
				end
				list = newlist;
			end
		end
	end
	
	if(upgradeable)then
		local temp = {};
		for i=1,#list do
			local card = list[i];
			if(card.lvl==nil)then card.lvl=1; end
			if(card.lvl<2 or card.unlimited)then
				if(card.class~="negative")then
					table.insert(temp, card);
				end
			end
		end
		list = temp;
	end
	if(#list<1)then
		show_msg(get_txt("nothing_to_pick_from"));
		return false
	end
	if(amount=="rnd")then
		local card_obj = table.random(list);
		callback(card_obj, nil);
		return true
	end
	if(amount==nil or amount==false)then amount=1; end
	if(amount=="all")then
		for i=1,#list do
			local card_obj = list[i];
			callback(card_obj, nil);
		end
		return true
	end
	if(callback)then
		if(amount >= #list and force)then
			for i=1,#list do
				local card_obj = list[i];
				callback(card_obj, nil);
			end
			return true
		end
	end
	
	local wnd = newGroup(facemc);
	local rect = display.newRect(wnd, _W/2, _H/2, _W, _H+20*scaleGraphics);
	rect:setFillColor(0, 0, 0, 0.4);
	
	wnd.onClose = onClose;
	function wnd:closeMe()
		if(wnd.onClose)then
			wnd:onClose();
		end
		facemc.wnd = nil;
		if(wnd.removeSelf)then
			wnd:removeSelf();
		end
	end
	-- print("_callback:", callback)
	if(callback==nil)then
		facemc.parent.actEscape = wnd.closeMe;
		facemc.parent.actRight = wnd.closeMe;
	end
	
	local cards = newGroup(wnd);
	local selcsmc = newGroup(cards);
	local selected = {};
	function wnd:refreshSelected()
		cleanGroup(selcsmc);
		for i=1,#selected do
			local sel_obj = selected[i];
			local card_obj, mc = sel_obj.obj, sel_obj.mc;
			local hmc = display.newImage(selcsmc, "image/cards_front_2.png", mc.x, mc.y);
			hmc:scale(1.05*scaleGraphics/2, 1.05*scaleGraphics/2);
			hmc.fill.effect = "filter.brightness";
			hmc.fill.effect.intensity = 2.0;
		end
		
		-- wnd.confirm_btn:
		-- print('fa')
		-- print(wnd.confirm_btn)
		-- print(wnd.confirm_btn.dtxt)
		-- print(wnd.confirm_btn.numChildren, #selected==amount, not #selected==amount)
		elite.setDisabled(wnd.confirm_btn, ((#selected==amount)==false and force==true) or (force==false and #selected>amount));
		
		if(wnd.refreshAmount)then
			wnd:refreshAmount();
		end
	end

	local rawMax = math.floor((_W-50*scaleGraphics)/(120*scaleGraphics));
	rawMax = math.min(rawMax, #list);
	
	local ii=1;
	for i=1,#list do
		local card_obj = list[i];
		
		if(card_obj.onUpgrade or upgradeable~=true)then
			local mc, body = createCardMC(cards, card_obj, nil, card_obj.class);
			mc.x, mc.y = sx, sy;
			
			local tx, ty = _W/2 + 120*scaleGraphics*((ii-1)%rawMax-rawMax/2+0.5) - 10*scaleGraphics, 100*scaleGraphics + math.floor((ii-1)/rawMax)*cardDY;
			-- mc.disabled = true;
			
			body.xScale, body.yScale = 1/2, 1/2;
			mc.tran = true;
			transition.to(mc, {time=400+ii*50, x=tx, y=ty, xScale=2, yScale=2, onComplete=function(obj)
				mc.tran = nil;
			end});
			
			mc.act = function(e)
				if(wnd.confirm_btn)then
					for j=1,#selected do
						if(selected[j].obj==card_obj)then
							table.remove(selected, j);
							wnd:refreshSelected();
							return
						end
					end
					table.insert(selected, {obj=card_obj, mc=mc});
					wnd:refreshSelected();
				else
					if(callback and amount==1 and upgradeable)then
						-- wnd:closeMe();
						-- facemc.wnd = nil;
						wnd.isVisible = false;
						
						local uobj = table.cloneByAttr(card_obj);
						upgradeCard(uobj);
						
						local cnfr_bg = display.newRect(facemc, _W/2, _H/2, _W, _H);
						cnfr_bg:setFillColor(0, 0, 0, 0.7);
						local cnfr_mc = add_bg_title("bg_3", math.min(300*scaleGraphics, _W-100*scaleGraphics), 190*scaleGraphics, get_txt('question_upgrade'));
						facemc:insert(cnfr_mc);
						cnfr_mc.x, cnfr_mc.y = _W/2, _H/2;
						
						local mc1, body1 = createCardMC(cnfr_mc, card_obj, nil, card_obj.class);
						
						body1.xScale, body1.yScale = 1/2, 1/2;
						body1:scale(scaleGraphics, scaleGraphics);
						while(cnfr_mc.h-40*scaleGraphics<body1.contentHeight)do
							body1:scale(0.99, 0.99);
						end
						mc1:translate(-(10*scaleGraphics + body1.contentWidth/2), -10*scaleGraphics);
						
						local mc2, body2 = createCardMC(cnfr_mc, uobj, nil, uobj.class);
						body2.xScale, body2.yScale = 1/2, 1/2;
						body2:scale(scaleGraphics, scaleGraphics);
						while(cnfr_mc.h-40*scaleGraphics<body2.contentHeight)do
							body2:scale(0.99, 0.99);
						end
						mc2:translate((10*scaleGraphics + body2.contentWidth/2), -10*scaleGraphics);
						
						local btn1_mc = display.newImage(cnfr_mc, "image/button/ok.png", -50*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
						btn1_mc:scale(scaleGraphics/2, scaleGraphics/2);
						elite.addOverOutBrightness(btn1_mc);
						table.insert(buttons, btn1_mc);
						btn1_mc.w, btn1_mc.h = 30*scaleGraphics, 30*scaleGraphics;
						btn1_mc.act = function()
							callback(card_obj, mc);
							wnd:closeMe();
							
							cnfr_bg:removeSelf();
							cnfr_mc:removeSelf();
							facemc.wnd = nil;
							facemc.cnfr_mc = nil;
						end
						
						local btn2_mc = display.newImage(cnfr_mc, "image/button/cancel.png", 50*scaleGraphics, cnfr_mc.h/2 - 20*scaleGraphics);
						btn2_mc:scale(scaleGraphics/2, scaleGraphics/2);
						elite.addOverOutBrightness(btn2_mc);
						table.insert(buttons, btn2_mc);
						btn2_mc.w, btn2_mc.h = 30*scaleGraphics, 30*scaleGraphics;
						btn2_mc.act = function()
							local function once(e)
								wnd.isVisible = true;
								Runtime:removeEventListener("enterFrame", once);
							end
							Runtime:addEventListener("enterFrame", once);
							
							cnfr_bg:removeSelf();
							cnfr_mc:removeSelf();
							facemc.cnfr_mc = nil;
						end
						
						local hint = newOutlinedText(cnfr_mc, ">>>", 0, 0, fontMain, 10*scaleGraphics, 1, 0, 1);
						
						facemc.cnfr_mc = cnfr_mc;
						
						return true;
					end
					
					if(callback)then
						callback(card_obj, mc);
					end
					
					wnd:closeMe();
				end
			end
			table.insert(buttons, mc);
			mc.w, mc.h = 100*scaleGraphics, 150*scaleGraphics;
			
			function mc:disabled()
				-- print("disabled:", card_obj.tag, facemc.cnfr_mc, facemc.wnd, mc.tran)
				return facemc.cnfr_mc~=nil or mc.tran~=nil;
			end

			local temp;
			function mc:onOver()
				mc.ntxt:setTextColor(1, 0.5, 0.5);
				if(upgradeable)then
					if(temp==nil)then
						local uobj = table.cloneByAttr(card_obj);
						upgradeCard(uobj);
						temp, body = createCardMC(cards, uobj, nil, card_obj.class);
						body.xScale, body.yScale = 1/2, 1/2;
						temp.x, temp.y = mc.x, mc.y;
						temp:scale(2, 2);
					end
				end
				
				mc:showExtraHints();
			end
			function mc:onOut()
				mc:update();
				
				if(temp)then
					temp:removeSelf();
					temp=nil;
				end
				
				mc:hideExtraHints();
			end
			ii = ii+1;
		end
	end
	
	local list_lines = math.ceil((ii-1)/rawMax);
	
	function wnd:addHint(hint)
		addHint(hint);
	end
	
	local options = {};
	local optionsmc = newGroup(wnd);
	local maxY = _H - 60*scaleGraphics;--100*scaleGraphics + math.floor((#list-1)/rawMax)*160*scaleGraphics;
	function wnd:addOption(txt, act)
		table.insert(options, {txt=txt, act=act});
		-- cleanGroup(optionsmc);
		
		local btn = newGroup(optionsmc);
		-- btn.x, btn.y = _W/2, _H - 80*scaleGraphics;
		local btn_w = 92*scaleGraphics;
		local bar = add_bar("black_bar", btn_w);
		btn:insert(bar);
		
		btn.dtxt = display.newText(btn, txt, 0, 0, fontMain, 18*scaleGraphics);
		function btn:act()
			if(act)then
				act();
			end
			wnd:closeMe();
		end
		
		elite.addOverOutBrightness(btn, bar);
		table.insert(buttons, btn);
		btn.w, btn.h = 100*scaleGraphics, 20*scaleGraphics;
		
		for i=1,optionsmc.numChildren do
			local btn1 = optionsmc[i];
			btn1.x, btn1.y = _W/2 + (i-optionsmc.numChildren/2-0.5)*100*scaleGraphics, maxY;--_H - 80*scaleGraphics;
			btn1.alpha = 0;
			-- btn1.disabled = true;
			transition.to(btn1, {delay=300+#list*40, time=400, alpha=1, transition=easing.inQuad, onComplete=function(obj)
				-- btn1.disabled = false;
			end});
		end
		return btn;
	end
	
	if(type(amount) == "number")then
		-- if(amount>settings.confirmationMin or 0)then
		if(amount>1)then
			wnd.confirm_btn = wnd:addOption(get_txt('confirm'), function()
				for i=1,#selected do
					local sel_obj = selected[i];
					local card_obj, mc = sel_obj.obj, sel_obj.mc;
					if(callback)then
						callback(card_obj, mc);
					end
				end
			end);
			wnd.amounttxt = display.newText(wnd, #selected.."/"..amount, _W/2, maxY+20*scaleGraphics, fontMain, 12*scaleGraphics);
			function wnd:refreshAmount()
				wnd.amounttxt.text = #selected.."/"..amount;
				if(force)then
					if(#selected==amount)then
						wnd.amounttxt:setTextColor(1/8, 1, 1/4);
					else
						wnd.amounttxt:setTextColor(1, 1/4, 1/8);
					end
				end
			end
			wnd:refreshAmount();
			wnd:refreshSelected();
		end
	end
	
	print("_list_lines:", list_lines, list_lines>2);
	if(list_lines>2)then
		local function fitY()
			cards.y = math.min(cards.y, 0);
			cards.y = math.max(cards.y, -(cards.height - _H + 100*scaleGraphics));
		end
		local function mouseHandler(e)
			if(facemc.removeSelf==nil)then
				Runtime:removeEventListener("mouse", mouseHandler);
				return
			end

			if(cards)then
				if(cards.y)then
					if(e.scrollY~=0)then
						if(e.scrollY>0)then
							cards.y = cards.y-20*scaleGraphics;
						else
							cards.y = cards.y+20*scaleGraphics;
						end
						fitY();
					end
				end
				-- print("_cards.y:", cards.y, cards.height-_H);
			end
		end
		Runtime:addEventListener("mouse", mouseHandler);
		
		local touchX, touchY = 0, 0;
		rect:addEventListener('touch', function(e)
			if(e.phase=="began")then
				touchX, touchY = e.x, e.y;
			elseif(e.phase=="moved")then
				local dx, dy = e.x-touchX, e.y-touchY;
				touchX, touchY = e.x, e.y;
				cards.y = cards.y + dy;
				cards.y = math.min(cards.y, 0);
				fitY();
			else
			end
			-- return true;
		end);
	end

	wnd.cards = cards;
	facemc.wnd = wnd;
	return wnd;
end

function getRelicDesc(robj)
	if(robj.hint)then
		return get_txt(robj.hint);
	end
	local hint_id = get_txt(get_name_id(robj.tag).."_hint");
	local hint = "";
	if(get_txt_force(hint_id))then
		hint = get_txt(hint_id);
	end
	
	local arr = {};
	if(robj.relicupgrade)then
		local txt = get_txt("relicupgradetxt");
		txt = txt:gsub("NAME", get_name(robj.relicupgrade));
		table.insert(arr, txt);
	end
	if(robj.cards)then
		for i=1,#robj.cards do
			local txt = robj.cards[i];
			if(i==1)then
				txt = "Add: "..txt;
			end
			table.insert(arr, txt);
		end
	end
	if(robj.quest)then
		local qarr = {};
		handleOneAction(robj.quest, qarr);
		
		if(#qarr>0)then
			table.insert(arr, table.concat(qarr, ", "));
		else
			for attr,val in pairs(robj.quest) do
				if(attr=="relic" or attr=="curse" or attr=="upgradeskills" or attr=="upgradeattacks")then
					table.insert(arr, get_txt("quest_"..attr..val));
				elseif(attr=="change")then
					local txt = get_txt("change_deck_"..tostring(val.filter[1]).."_"..tostring(val.filter[2]).."_"..tostring(val.filter[3]).."_"..val.amount);
					table.insert(arr, txt);
				elseif(attr=="proceed")then
				else
					table.insert(arr, get_txt(attr).." "..val);
				end
			end
		end
	end
	if(robj.login)then
		for attr,val in pairs(robj.login) do
			if(attr=="norest" or attr=="nosmith")then
				table.insert(arr, get_txt(attr..tostring(val)));
			elseif(get_txt_force(attr.."_hint"))then
				table.insert(arr, get_txt(attr.."_hint"));
			elseif(get_txt_force("login_"..attr))then
				local txt = get_txt("login_"..attr);
				if(txt:find("VAL")~=nil)then
					txt = txt:gsub("VAL", tostring(val))
				end
				table.insert(arr, txt);
			elseif(get_txt_force(attr))then
				local txt = get_txt(attr);
				if(txt:find("VAL")~=nil)then
					txt = txt:gsub("VAL", tostring(val))
				end
				table.insert(arr, txt);
			else
				table.insert(arr, get_txt(attr)..": "..tostring(val));
			end
		end
	end
	if(robj.condition)then
		if(robj.condition.event and robj.condition.play)then
			if(get_txt_force("event_"..robj.condition.event))then
				table.insert(arr, get_txt("event_"..robj.condition.event)..": "..getCardDesc(robj.condition.play));
			else
				local txt = get_txt("event_generic");
				txt = txt:gsub("EVENT", get_txt(robj.condition.event));
				table.insert(arr, txt..": "..getCardDesc(robj.condition.play));
			end
		end
		if(robj.condition.event and robj.condition.transfer)then
			local txt = get_txt("transfer_"..robj.condition.event.."_"..robj.condition.range);
			txt = txt:gsub("CONDITION", get_txt(robj.condition.transfer));
			table.insert(arr, txt);
		end
		if(robj.condition.event and robj.condition.login)then
			local once = true;
			for attr,val in pairs(robj.condition.login) do
				if(once)then
					local txt1 = get_txt("event_"..robj.condition.event);
					local txt2 = get_txt(attr);
					if(robj.rest)then
						txt1 = get_txt("rest_extra");
					end
					-- if(robj.rest)then
					-- table.insert(arr, get_txt("rest_extra")..": "..getCardDesc(robj.condition.play));
					-- table.insert(arr, get_txt("rest_extra"):gsub("VAL", getCardDesc(robj.condition.play)));
					-- else
					
					if(txt2:find("VAL")~=nil)then
						table.insert(arr, txt1..": "..txt2:gsub("VAL", "+"..val));
					else
						table.insert(arr, txt1..": ".."+"..tostring(val).." "..txt2);
					end
				else
					table.insert(arr, get_txt(attr)..": "..tostring(val));
				end
				once = false;
			end
		end
		if(robj.condition.event and robj.condition.quest)then
			local qarr = {};
			handleOneAction(robj.condition.quest, qarr);
			table.insert(arr, get_txt("event_"..robj.condition.event)..": "..table.concat(qarr, ", "));
		end
	end
	
	if(#arr>0)then
		hint = table.concat(arr, ", ");
	else
		hint = get_txt(hint_id);
	end
	return hint, arr;
end
function getConditionDesc(attr, val, obj, valRnd, force, exclude)
	local hint = val.." "..get_txt(attr);
	if(valRnd)then
		hint = val.."-"..valRnd.." "..get_txt(attr);
	end
	local hinted = false;
	if(conditions[attr])then
		hinted = conditions[attr].hinted==true;
		if(conditions[attr].number == false)then
			hint = get_txt(attr);
		end
	end
	if(exclude)then
		if(exclude[attr])then
			return hint;
		end
		exclude[attr] = true;
	end
	-- print("desc:", attr, val, obj, valRnd, hinted);
	-- if(attr=='charm' or attr=='vulnerable' or attr=='poison' or attr=='weak' or attr=='draining')then
	if(attr=='vulnerable' or (hinted and force~=true))then
		-- table.insert(desc_arr, val.." "..get_txt(attr));
		-- local force_txt = get_txt_force(attr.."_hint");
		-- if(force_txt)then
			-- if(force_txt:find("VAL"))then
				-- hint = hint:gsub("VAL", getConditionDesc(attr, val, obj, nil, true, exclude));
			-- end
		-- end
	elseif(attr=="doubleplay" or attr=="doubletap" or attr=="doubleskill" or attr=="doublepower" or attr=="dmgmultiply" or attr=="doubleheavytap" or attr=="preventdmg")then
		-- table.insert(desc_arr, get_txt(attr..(val)));
		hint = get_txt(attr..(val));
	else
		if(val~=0 and val~=null and val~=nil)then
			if(obj)then
				if(obj.play)then
					if(obj.event=="turn")then
						-- table.insert(desc_arr, get_txt(obj.event..tostring(obj.expireAtEnd or false))..": "..getCardDesc(obj.play, hero, val, extra_hints));
						hint = get_txt(obj.event..tostring(obj.expireAtEnd or false))..": "..getCardDesc(obj.play, hero, val, extra_hints, nil, exclude);
					else

						if(get_txt_force("event_"..obj.event))then
							hint = get_txt("event_"..obj.event)..": "..getCardDesc(obj.play, hero, val, extra_hints, nil, exclude);
						else
							local txt = get_txt("event_generic");
							txt = txt:gsub("EVENT", get_txt(obj.event));
							hint = get_txt("event_"..obj.event)..": "..getCardDesc(obj.play, hero, val, extra_hints, nil, exclude);
						end

						-- hint = get_txt("event_"..obj.event)..": "..getCardDesc(obj.play, hero, val, extra_hints, nil, exclude);
					end
				elseif(obj.onExpire)then
					-- conditions.timewarp = {onExpire={range="self", str=2, timewarp=12, msg=false, stealturn=true}};	
					-- Every time you play a total of 12 cards (carrying over between turns), your turn is immediately ended. The Time Eater gains 2 Strength, then takes its turn.
					hint = get_txt("event_expire");
					hint = hint:gsub("VAL", getCardDesc(obj.onExpire, hero, 1, extra_hints, nil, exclude));
				elseif(get_txt_force(attr.."_hint"))then
					-- table.insert(desc_arr, get_txt(attr.."_hint"));
					hint = get_txt(attr.."_hint");
					hint = hint:gsub("VAL", val);
				-- else
					-- add_item(attr);
				elseif(get_txt_force(attr) and val<0)then
					hint = get_txt(attr);
					hint = hint:gsub("+VAL", val);
				end
			end
		end
	end
	
	-- print("_hint:", hint) con_times="Deal VAL CON TIMES times"
	
	return hint;
end
function getCardDesc(card_obj, hero, multy, extra_hints, enemy, exclude)
	local ctype = card_obj.tag;
	-- print("getCardDesc", ctype)
	-- local card_prms = cards_indexes[ctype];
	
	local desc_arr = {};
	if(exclude==nil)then exclude={}; end
	if(extra_hints==nil)then extra_hints={}; end
	
	-- if(card_obj.energy=="x")then
		-- table.insert(desc_arr, "Spend all energy");
	-- end
	if(card_obj.times==nil)then card_obj.times=1; end
	if(card_obj.lvl==nil)then card_obj.lvl=1; end
	-- print("_desc:", ctype, multy);
	
	local function add_item(attr, ehint, sameAttr)
		if(card_obj[attr])then
			if(card_obj[attr]~=0)then
				local val = card_obj[attr];
				if(extra_hints and ehint)then
					table.insert(extra_hints, ehint);
				end
				if(attr=="dmg")then 
					if(card_obj.dmgPerUpgrade)then
						val = val + card_obj.dmgPerUpgrade*(card_obj.lvl-1);
					end
					if(hero)then 
						if(card_obj.strX==nil)then card_obj.strX=1; end
						val = val + hero.str * card_obj.strX;
						if(card_obj.energy==0 and card_obj.ctype==CTYPE_ATTACK)then -- wristblade
							if(hero.wristblade>0)then
								val = val+hero.wristblade;
							end
						end
						if(hero.dmgOnce)then
							val = val+hero.dmgOnce;
						end
						if(hero.weak>0)then
							val = val*0.75;
						end
					end
					if(enemy)then
						if(enemy.vulnerable)then
							if(enemy.vulnerable~=0)then
								val = val * 1.5;
							end
						end
						if(enemy.vulnerability)then
							if(enemy.vulnerability~=0)then
								val = val * (100 + enemy.vulnerability)/100;
							end
						end
						if(enemy.charm)then
							if(enemy.charm~=0)then
								val = val + enemy.charm;
							end
						end
					end
					if((hero and hero.wrath>0) or (enemy and enemy.wrath>0))then
						val = val*2;
					end
					val = math.floor(val);
				end
				if(attr=="armor")then
					if(hero)then 
						val = val + hero.dex;
						if(hero.frail>0)then
							val = math.floor(val*0.75);
						end
					end
				end
				
				if(multy and multy~="X")then
					val = val*multy;
				end
				if(attr=="strMlt")then
					table.insert(desc_arr, get_txt('str').." x"..card_obj[attr]);
					return
				end
				
				if(card_obj[attr.."Rnd"])then
					val = val.."-"..(val+card_obj[attr.."Rnd"]);
				end
				if(sameAttr)then
					attr = sameAttr;
				end
				if(attr=="dmg" and card_obj.dtype==DTYPE_TRUE)then
					-- table.insert(desc_arr, "("..get_txt("dmg_true")..")");
					attr = "dmg_true";
					if(extra_hints)then
						table.insert(extra_hints, "dmg_true");
					end
				end
				if(card_obj.energy==X and attr~='harm')then
					local txt;-- = get_txt(attr.."_times");
					
					if(get_txt_force(attr.."_times"))then
						txt = get_txt(attr.."_times");
					else
						txt = get_txt("con_times");
						txt = txt:gsub("CON", get_txt(attr));
					end
					-- con_times="Deal VAL CON TIMES times"
					
					txt = txt:gsub("VAL", val);
					if(card_obj.extraX)then
						txt = txt:gsub("TIMES", "X+"..card_obj.extraX);
					else
						txt = txt:gsub("TIMES", "X");
					end
					table.insert(desc_arr, txt); --Deal 7 damage X times
				elseif(tonumber(card_obj.times)>1)then
					table.insert(desc_arr, val.."x"..card_obj.times.." "..get_txt(attr));
				else
					table.insert(desc_arr, val.." "..get_txt(attr));
				end
			end
		end
	end
	-- add_item("armorToDmg");
	-- add_item("targetArmorToDmg");
	add_item("harmToBlock");
	
	add_item("dmg");
	add_item("poison");
	
	
	add_item("heal");
	add_item("healTarget", "heal", "heal");
	add_item("armor", "armor");
	add_item("armorToTarget", "armor", "armor");
	-- add_item("vulnerable");
	add_item("vulnerableSelf");
	add_item("woundsToDeck");
	add_item("woundsToHand");
	-- add_item("weak");
	
	add_item("harm", "harm");
	
	-- print(card_obj.tag, card_obj["str"],card_obj["strNext"] , card_obj["str"]==card_obj["strNext"], card_obj["str"]~=nil, card_obj["str"]==card_obj["strNext"] and card_obj["str"]~=nil)
	if(card_obj["strNext"]~=nil and card_obj["str"]==-card_obj["strNext"])then
		if(card_obj["str"]<0)then
			local txt = get_txt('strRmvOnce');
			txt = txt:gsub("VAL", -card_obj["str"]);
			table.insert(desc_arr, txt);
		else
			local txt = get_txt('strAddOnce');
			txt = txt:gsub("VAL", card_obj["str"]);
			table.insert(desc_arr, txt);
		end
	else
		add_item("str", "str");
		add_item("strNext", "str");
	end
	
	add_item("dex", "dex");
	-- add_item("draw");
	add_item("strMlt", "str");
	-- add_item("armorMlt");
	-- add_item("energyAdd");
	add_item("feed", "feed");
	add_item("scry", "scry");
	-- add_item("hpmax");
	add_item("armorFromEnergyMax");
	-- add_item("drawPlayExhaust");
	add_item("hpleft");
	-- add_item("poisonMlt", "poison");
	add_item("armorPerCardInHand");
	
	-- if(card_obj.played_cards_3)then
		-- local txt = get_txt("playedXcards");
		-- txt = txt:gsub("VAL", 3);
		-- table.insert(desc_arr, txt..": "..getCardDesc(card_obj.played_cards_3, hero, multy, extra_hints));
	-- end
	if(card_obj.onEvent)then
		local txt = get_txt("event_"..card_obj.onEvent.event);
		table.insert(desc_arr, txt..": "..getCardDesc(card_obj.onEvent.play, hero, multy, extra_hints));
		if(hero and card_obj.onEvent.event=="played_cards_3")then
			table.insert(desc_arr, "("..hero.card_played_this_turn.."/3)");
		end
		if(hero and card_obj.onEvent.event=="played_cards_6")then
			table.insert(desc_arr, "("..hero.card_played_this_turn.."/6)");
		end
	end
	
	
	local function add_stem(attr, ehint)
		if(card_obj[attr])then
			local val = card_obj[attr]*(multy or 1);
			local ahint = attr..tostring(val);
			
			-- print(card_obj.tag, attr, val, ahint, card_obj.energy, card_obj.energy==X)
			if(card_obj.energy==X)then
				if(card_obj.extraX)then
					val = "X+"..card_obj.extraX;
				else
					val = "X";
				end
				local txt = get_txt(attr.."X"):gsub("VAL", val);
				table.insert(desc_arr, txt);
				return
			end
			
			if(get_txt_force(ahint))then
				table.insert(desc_arr, get_txt(ahint));
			else
				if(get_txt_force(attr.."X"))then
					local txt = get_txt(attr.."X"):gsub("VAL", val);
					table.insert(desc_arr, txt);
				else
					table.insert(desc_arr, get_txt(ahint));
				end
			end
			if(extra_hints and ehint)then
				table.insert(extra_hints, ehint);
			end
		end
	
	end
	add_stem("draw");
	add_stem("potion");
	add_stem("peek");
	add_stem("energyAdd")
	add_stem("poisonMlt", "poison");
	add_stem("drawPlayExhaust");
	add_stem("chooseOneRandom");
	add_stem("armorMlt");
	add_stem("charmMlt", "charm");
	add_stem("battlefervorMlt", "battlefervor");
	add_stem("energyMlt");
	
	add_stem("deckToDmg");
	add_stem("drawToDmg");
	add_stem("drawUntil");
	
	add_stem("evoke");
	add_stem("evokePassive");
	
	
	
	-- add_stem("preventdmg");
	
	
	if(card_obj.deckToEnergy)then
		local txt = get_txt('deckToEnergy');
		txt = txt:gsub("VAL", card_obj.deckToEnergy);
		table.insert(desc_arr, txt);
	end
	
	if(card_obj.hpmax)then
		local txt = get_txt('login_hpmax');
		txt = txt:gsub("VAL", card_obj.hpmax);
		table.insert(desc_arr, txt);
	end
	
	if(card_obj.label)then
		table.insert(desc_arr, card_obj.label);
	end
	
	if(card_obj.pets)then
		local txt = get_txt('summons_VAL');
		
		-- table.insert(extra_hints, "summons");
		table.insert(extra_hints, "evoke");
		
		
		local jmax = 1;
		if(type(multy)=="number")then
			jmax = multy;
		end
		
		local list = {};
		for i=1,#card_obj.pets do
			local ptype = card_obj.pets[i];
			local pobj = pets[ptype];
			-- print(i, ptype, pobj)
			for j=1,jmax do
				if(pobj)then
					table.insert(list, get_txt(pobj.scin));
					
					if(extra_hints)then
						-- local ehint = getCardDesc(pobj.passive).." / "..getCardDesc(pobj.active);
						-- table.insert(extra_hints, getCardDesc(pobj.passive));
						-- table.insert(extra_hints, getCardDesc(pobj.active));
						local scin = pobj.scin;
						table.insert(extra_hints, scin.."_passive");
						table.insert(extra_hints, scin.."_active");
						
						if(get_txt_force(scin.."_passive_hint")==nil)then
							language:addCurWord(scin.."_passive", get_txt(scin).." - "..get_txt('passive'));
							language:addCurWord(scin.."_passive_hint", getCardDesc(pobj.passive));
						end
						if(get_txt_force(scin.."_active_hint")==nil)then
							language:addCurWord(scin.."_active", get_txt(scin).." - "..get_txt('evoke'));
							language:addCurWord(scin.."_active_hint", getCardDesc(pobj.active));
						end
					end
				else
					table.insert(list, get_txt(ptype));
				end
			end
		end

		txt = txt:gsub("VAL", table.concat(list, ", "));
		if(card_obj.energy==X)then
			if(card_obj.extraX)then
				txt=txt..get_txt("_times"):gsub("TIMES", "X+"..card_obj.extraX);
			else
				txt=txt..get_txt("_times"):gsub("TIMES", "X");
			end
		end
		table.insert(desc_arr, txt);
	end
	if(card_obj.onPet)then
		local obj = card_obj.onPet;
		local txt = get_txt('onPet'..tostring(obj.unique or ""));
		table.insert(desc_arr, txt..": "..getCardDesc(obj.onCount, hero, multy, extra_hints));
		if(obj.evoke)then
			table.insert(desc_arr, get_txt('evokeAll'));
		end
		-- onPet={onCount={range="enemy", dmg=4}}
		-- onPet={onCount={range="enemy", draw=1}, unique=true}
			-- local obj = card_obj.onPet;
			-- local unique = {};
			-- for i=1,#source.pets do
				-- local pet = source.pets[i];
				-- if(obj.unique~=true or unique[pet.tag]~=true)then
					-- unique[pet.tag] = true
					-- gamemc:playCard(obj.onCount, tar, source, true);
				-- end
			-- end
	end
	
	if(card_obj.strX)then
		if(card_obj.strX/1>1)then
			local txt = get_txt('strX_hint');
			txt = txt:gsub("X", card_obj.strX);
			table.insert(desc_arr, txt);
		end
	end
	if(card_obj.cursesAdd)then
		local txt = get_txt('curse_add_txt');
		txt = txt:gsub("ATTR", get_txt(card_obj.cursesAdd));
		table.insert(desc_arr, txt);
	end
	
	if(card_obj.dmgByAttrFromSource)then
		local txt = get_txt("dmgByAttrFromSource");
		if(hero)then
			txt = txt:gsub("VAL", get_txt(card_obj.dmgByAttrFromSource).."("..(hero[card_obj.dmgByAttrFromSource]*card_obj.times + hero.str).." "..get_txt('dmg')..")");
		else
			if(card_obj.times>1)then
				txt = get_txt("dmgByAttrFromSourceTimes");
				txt = txt:gsub("VAL", get_txt(card_obj.dmgByAttrFromSource));
				txt = txt:gsub("TIMES", card_obj.times);
			else
				txt = txt:gsub("VAL", get_txt(card_obj.dmgByAttrFromSource));
			end
		end
		table.insert(desc_arr, txt);
	end
	if(card_obj.dmgByAttrFromTarget)then
		table.insert(desc_arr, "Deal damage equal to enemy "..get_txt(card_obj.dmgByAttrFromTarget));
	end
	if(card_obj.harmByAttr)then
		table.insert(desc_arr, "Deal damage equal to "..get_txt(card_obj.harmByAttr));
	end
	
	for attr,obj in pairs(conditions) do
		if(card_obj[attr]~=nil and card_obj[attr]~=null and card_obj[attr]~=0)then
			if(extra_hints and card_obj[attr]~=0 and card_obj[attr]~=null)then
				table.insert(extra_hints, attr);
			end
			if(extra_hints and obj.stance)then
				table.insert(extra_hints, "stance");
			end
			local val = card_obj[attr];
			if(multy and multy~="X")then
				val = val*multy;
			end
			local valRnd = card_obj[attr.."Rnd"];
			if(attr~="strNext" and attr~="str" and attr~="poison")then
				-- print(attr, val, card_obj.times, card_obj.energy)
				if(card_obj.energy==X)then
					local value = val;
					if(card_obj.extraX)then
						val = "X+"..card_obj.extraX;
					else
						val = "X";
					end
					if(type(value)=="number")then
						if(value>1)then
							val = value.."*"..val;
						end
					end
				end
				local hint = getConditionDesc(attr, val, obj, valRnd, nil, exclude);
				table.insert(desc_arr, hint);
			end
		end
	end
	
	-- if(card_obj.times>1)then
		-- local txt = get_txt("_times"):gsub("TIMES", card_obj.times);
		-- table.insert(desc_arr, txt);
	-- end
	
	-- event_turnEnd="At the end of each Turn"
	local check = 0;
	for i=1,#desc_arr do
		-- print(i, desc_arr[i]);
		-- string.find('my string', 'no-cache')
		if(string.find(desc_arr[i], get_txt('event_turnEnd')))then
			check = check+1;
			if(check>1)then
				desc_arr[i] = desc_arr[i]:gsub(get_txt('event_turnEnd')..": ", "");
			end
		end
	end
	
	local function add_item_string(attr, ehint)
		if(card_obj[attr])then
			table.insert(desc_arr, get_txt(attr..(card_obj[attr])));
			if(extra_hints and ehint)then
				table.insert(extra_hints, ehint);
			end
		end
	end
	add_item_string("ignore");
	
	-- onConditions={range="self", action="purge", attr="voodoo", val=true, onCount={range="enemy", dmg=10}}
	if(card_obj.onConditions)then
		local obj = card_obj.onConditions;
		if(obj.action=="add")then
			local txt = get_txt("onConditions_"..obj.action.."_"..obj.attr.."_"..tostring(obj.val));
			txt = txt:gsub("VAL", obj.add);
			table.insert(desc_arr, txt);
		elseif(obj.action=="purge" and obj.attr=="stance")then
			table.insert(desc_arr, get_txt("onConditions_purge_stance")); -- this will cover all kind of stance(color/set of stances are not included in this translation)
		elseif(obj.action)then
			local txt = get_txt("onConditions_"..obj.action.."_"..obj.attr.."_"..tostring(obj.val));
			table.insert(desc_arr, txt);
		else
			local txt = get_txt("onConditions_"..obj.attr.."_"..tostring(obj.val));
			table.insert(desc_arr, txt);
		end
		
		if(obj.onCount)then
			table.insert(desc_arr, get_txt('for_each')..": "..getCardDesc(obj.onCount, hero, multy, extra_hints));
		end
		
		if(card_obj.times>1)then
			local txt = get_txt("do_this_VAL_times");
			txt = txt:gsub("VAL", card_obj.times);
			table.insert(desc_arr, txt);
		end
	end
	
	if(card_obj.choose)then
		local variants = {};
		for i=1,#card_obj.choose do
			table.insert(variants, getCardDesc(card_obj.choose[i], hero, multy, extra_hints));
		end
		table.insert(desc_arr, table.concat(variants, " OR "));
	end
	
	if(card_obj.rndCards)then
		local variants = {};
		for i=1,#card_obj.rndCards do
			table.insert(variants, getCardDesc(card_obj.rndCards[i], hero, multy, extra_hints));
		end
		table.insert(desc_arr, table.concat(variants, " OR "));
	else
		if(card_obj.range)then
			if(card_obj.range=="rnd" or card_obj.range=="rndmiss" or card_obj.range=="minhp")then
				table.insert(desc_arr, get_txt("to_"..card_obj.range));
			end
			if(card_obj.range=="enemies")then
				if((card_obj.armor~=nil and card_obj.armor~=0) or card_obj.pets)then
					table.insert(desc_arr, get_txt("for_each_enemy"));
				else
					if(get_txt("to_"..card_obj.range)~="")then
						table.insert(desc_arr, get_txt("to_"..card_obj.range));
					end
				end
			end
		end
	end
	
	
	if(card_obj.getAddDmgByAttr)then
		-- getAddDmgByAttr(list, attr, val)
		-- table.insert(desc_arr, "Deals an additional VAL damage for every attack in hand");
		local obj = card_obj.getAddDmgByAttr;
		local txt = get_txt("getAddDmgByAttr_"..obj.list..obj.attr..obj.val);
		txt = txt:gsub("VAL", obj.dmg);
		table.insert(desc_arr, txt);
	end
	
	if(card_obj.hand)then
		local obj = card_obj.hand
		-- hand={action="exhaust", ctype=CTYPE_ATTACK, value=false, onCount={armor=5}}
		-- hand={action="exhaust", ctype=CTYPE_ATTACK, value=false}
		-- hand={action="exhaust", ctype='all', value=false, onCount={dmg=7}}
		if(obj.tag)then
			local hint = get_txt('hand_'..card_obj.hand.action.."_NAME_"..tostring(obj.value));
			hint = hint:gsub("NAME", get_name(obj.tag));
			if(obj.onCount)then
				table.insert(desc_arr, hint..', '..get_txt('for_each_card')..": "..getCardDesc(obj.onCount, hero, multy, extra_hints));
			else
				table.insert(desc_arr, hint);
			end
		else
			local hint = get_txt('hand_'..card_obj.hand.action.."_"..tostring(obj.ctype)..'_'..tostring(obj.value));
			if(obj.onCount)then
				table.insert(desc_arr, hint..', '..get_txt('for_each_card')..": "..getCardDesc(obj.onCount, hero, multy, extra_hints));
			else
				table.insert(desc_arr, hint);
			end
		end
	end
	local function onUseHandler(obj, cmd, prevhint)
		prevhint = prevhint or "";
		if(obj.target)then
			local hint_val = obj.action.."_"..obj.target;
			-- onUse={action="copy", target="hand", filter={"ctype", CTYPE_SKILL, false}, amount=1}
			-- onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount="rnd"}
			-- onUse={action="rehand", target="trash", filter={"ctype", "all", false}}
			-- onUse={action="plus", target="dmg", val=4} -- onUse={action="minus", target="dmg", val=4}
			
			if(obj.filter)then
				hint_val = hint_val.."_"..tostring(obj.filter[1]).."_"..tostring(obj.filter[2]).."_"..tostring(obj.filter[3]);
			end
			hint_val = hint_val:lower();
			if(obj.amount~=nil and obj.amount~=1 and obj.amount~="1")then
				hint_val = hint_val.."_"..obj.amount;
			end
			if(obj.to)then
				hint_val = hint_val.."_to_"..obj.to;
			end
			if(obj.play)then
				hint_val = hint_val.."_play"..obj.play;
			end

			if(obj.action=="copy")then	 
				if(obj.nextTurn)then
					hint_val = hint_val.."_nextTurn";
				end
				if(obj.copies==nil)then
					obj.copies=1;
				end
				if(obj.copies>1)then
					hint_val = hint_val.."_x"..obj.copies;
				end
			end
			-- print(card_obj.tag, cmd, hint_val, get_txt_force(hint_val))
			if(get_txt_force(hint_val))then
				if(obj.action=="change")then
					if(obj.changePick)then
						for iattr,ival in pairs(obj.changePick) do
							table.insert(desc_arr, prevhint..get_txt(hint_val)..": "..get_txt(obj.action.."_"..iattr):gsub("VAL", ival));
						end
					else
						table.insert(desc_arr, prevhint..get_txt(hint_val));
					end
				else
					if(cmd=="onUse")then
						table.insert(desc_arr, prevhint..get_txt_force(hint_val));
					else
						table.insert(desc_arr, prevhint..get_txt(cmd)..": "..get_txt_force(hint_val));
					end
				end
			elseif(obj.val and obj.action~="transform")then
				local txt = obj.val
				if(obj.val>0)then
					if(obj.action=="minus")then
						txt = "-"..txt;
					else
						txt = "+"..txt;
					end
				end
				if(obj.permanent)then
					-- table.insert(desc_arr, get_txt(cmd).."("..get_txt('permanently').."): "..get_txt_force(hint_val));
					table.insert(desc_arr, prevhint..get_txt(cmd).." ("..get_txt('permanently')..'): '..txt.." "..get_txt(obj.target));
				else
					table.insert(desc_arr, prevhint..get_txt(cmd)..': '..txt.." "..get_txt(obj.target));
				end
			else
				table.insert(desc_arr, prevhint..get_txt(hint_val));
			end
			
			if(obj.onNegativeCard)then
				table.insert(desc_arr, prevhint..get_txt('onNegativeCard'));
			end
			if(obj.refund)then
				table.insert(desc_arr, prevhint..get_txt('refund_card'));
			end
			if(obj.onCount)then
				if(obj.amount==1 or obj.amount==nil)then
					table.insert(desc_arr, prevhint..getCardDesc(obj.onCount, hero, multy, extra_hints));
				else
					table.insert(desc_arr, prevhint..get_txt('for_each')..": "..getCardDesc(obj.onCount, hero, multy, extra_hints));
				end
			end
			if(obj.tempRetain)then
				table.insert(desc_arr, prevhint..get_txt('onUseTempRetain'));
			end
		else
			local hint_val = get_txt(cmd);
			table.insert(desc_arr, prevhint..get_txt(hint_val)..": "..getCardDesc(obj.play, hero, multy, extra_hints));
		end
	end
	if(card_obj.onUse)then--get_txt_force(txt)
		local obj = card_obj.onUse;
		onUseHandler(obj, "onUse");
	end
	if(card_obj.onDraw)then--get_txt_force(txt)
		local obj = card_obj.onDraw;
		onUseHandler(obj, "onDraw");
	end
	if(card_obj.nulify)then
		table.insert(desc_arr, get_txt("nulify").." "..get_txt(card_obj.nulify));
	end
	if(card_obj.ifDraw)then
		local obj = card_obj.ifDraw;
		local txt = get_txt("if_draw_card");
		txt = txt:gsub("TYPE", get_txt("card_type_"..obj.ctype));
		table.insert(desc_arr, txt..": "..getCardDesc(obj, hero, multy, extra_hints));
		-- If the card is a skill gain 3(5) Block
		-- if(card_obj.ctype == ifDraw.ctype)then
					-- gamemc:playCard(ifDraw, hero, hero, true);
				-- end
	end
	if(card_obj.missingHP)then
		if(card_obj.missingHP.attr)then
			-- hero
			-- table.insert(desc_arr, card_obj.missingHP.attr.."/"..(card_obj.missingHP.val*100).." "..get_txt('missing_hp'));
			local txt = get_txt("missing_hp_to_attr");
			txt = txt:gsub("VAL", (card_obj.missingHP.val*100));
			txt = txt:gsub("ATTR", get_txt(card_obj.missingHP.attr));
			table.insert(desc_arr, txt);
		end
		if(card_obj.missingHP.dmg)then
			table.insert(desc_arr, get_txt("missing_hp_to_dmg"));
		end
	end
	if(card_obj.consumePain)then
		if(card_obj.consumePain.attr)then
			-- table.insert(desc_arr, card_obj.consumePain.attr.."/"..(card_obj.consumePain.val*100).." "..get_txt('missing_hp'));
			local txt = get_txt('consume_pain_txt');
			txt = txt:gsub("XXX", 1/card_obj.consumePain.val);
			txt = txt:gsub("ATTR", get_txt(card_obj.consumePain.attr));
			-- "Consume XXX pain to get 1 ATTR"
			table.insert(desc_arr, txt);
			if(extra_hints)then table.insert(extra_hints, "pain"); end
		end
	end
	if(card_obj.addCards)then
		-- addCards={hand={"Shiv","Shiv","Shiv"}}
		local function foo(val)
			if(card_obj.addCards[val])then
				local list = {};
				for i=1,#card_obj.addCards[val] do
					if(card_obj.addCards.upgrade)then
						table.insert(list, get_name(card_obj.addCards[val][i]).."+");
					else
						table.insert(list, get_name(card_obj.addCards[val][i]));
					end
				end
				table.insert(desc_arr, get_txt('add').." "..table.concat(list, ", ").." to "..get_txt(val.."_hint"));
			end
		end
		foo('draw');
		foo('deck');
		foo('hand');
	end
	local function handleCardsAttrsManipulations(txt, obj)
		local list = {};
		for attr,val in pairs(obj)do
			if(attr=="permanent")then
			elseif(type(val)=="number" and val<0)then
				table.insert(list, get_txt(attr).." "..tostring(val));
			else
				table.insert(list, get_txt(attr).." +"..tostring(val));
			end
		end
		txt = txt:gsub("PRMS", table.concat(list, ", "));
		table.insert(desc_arr, txt);
	end
	if(card_obj.onKill)then
		if(card_obj.onKill.onUse)then
			-- local txt = get_txt("event_kill")..": "..getCardDesc(card_obj.onKill.onUse, hero, multy, extra_hints);
			-- table.insert(desc_arr, get_txt("event_kill")..": ");
			onUseHandler(card_obj.onKill.onUse, "onUse", get_txt("event_kill")..": ")
		else
			handleCardsAttrsManipulations(get_txt("onKillHint_"..tostring(card_obj.onKill.permanent or false)), card_obj.onKill);
		end
		-- local txt = get_txt("onKillHint_"..tostring(card_obj.onKill.permanent or false));
		-- local list = {};
		-- for attr,val in pairs(card_obj.onKill)do
			-- if(attr~="permanent")then
				-- table.insert(list, get_txt(attr).." +"..tostring(val));
			-- end
		-- end
		-- txt = txt:gsub("PRMS", table.concat(list, ", "));
		-- table.insert(desc_arr, txt);
	end
	if(card_obj.onRetain)then
		handleCardsAttrsManipulations(get_txt("onRetain"), card_obj.onRetain);
		-- local txt = get_txt("onRetain");
		-- local list = {};
		-- for attr,val in pairs(card_obj.onRetain)do
			-- if(attr~="permanent")then
				-- table.insert(list, get_txt(attr).." +"..tostring(val));
			-- end
		-- end
		-- txt = txt:gsub("PRMS", table.concat(list, ", "));
		-- table.insert(desc_arr, txt);
	end
	if(card_obj.ifSelf)then
		if(card_obj.ifSelf.czero)then
			table.insert(desc_arr, get_txt('ifTarget')..' '..get_txt('does NOT have')..' '..(card_obj.ifSelf.czero)..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
		elseif(card_obj.ifSelf.hpLessEx)then
			local txt = get_txt("ifTargetHpLessEx");
			txt = txt:gsub("VAL", card_obj.ifSelf.hpLessEx);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy, extra_hints));
		elseif(card_obj.ifSelf.hpLess)then
			local txt = get_txt("ifTargetHpLess");
			txt = txt:gsub("VAL", card_obj.ifSelf.hpLess);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy, extra_hints));
		elseif(card_obj.ifSelf.hpMore)then
			local txt = get_txt("ifTargetHpMore");
			txt = txt:gsub("VAL", card_obj.ifSelf.hpMore);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy, extra_hints));
		elseif(card_obj.ifSelf.more)then
			if(card_obj.ifSelf.more==0 or card_obj.ifSelf.more=="0")then
				local txt = get_txt('ifSelfHaveMoreCONThen0');
				txt = txt:gsub('CON', card_obj.ifSelf.condition);
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
			else
				local txt = get_txt('ifTargetHaveMoreCONThenVAL');
				txt = txt:gsub('VAL', card_obj.ifSelf.more);
				txt = txt:gsub('CON', card_obj.ifSelf.condition);
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
			end
		elseif(card_obj.ifSelf.condition and card_obj.ifSelf.val)then
			if(card_obj.ifSelf.condition=="dead" and card_obj.ifSelf.val==true)then
				local txt = get_txt('event_kill');
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
			elseif(card_obj.ifSelf.condition=="played_last_card_ctype")then
				local txt = get_txt('ifSelfPlayedLast');
				txt = txt:gsub("CTYPE", get_txt("card_type_"..card_obj.ifSelf.val));
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
			else
				local txt = get_txt('ifSelfCONequalVAL');
				txt = txt:gsub('VAL', tostring(card_obj.ifSelf.val));
				txt = txt:gsub('CON', card_obj.ifSelf.condition);
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
			end
		elseif(card_obj.ifSelf.intend)then
			table.insert(desc_arr, get_txt("ifTargetIntend_"..card_obj.ifSelf.intend)..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
		else
			local txt = get_txt('ifTargetHas');
			txt = txt:gsub('CON', get_txt(card_obj.ifSelf.condition));
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifSelf.play, hero, multy));
		end
		if(card_obj.ifSelf.otherwise)then
			table.insert(desc_arr, get_txt("otherwise")..": "..getCardDesc(card_obj.ifSelf.otherwise, hero, multy));
		end
	end
	if(card_obj.ifEnemy)then
		if(card_obj.ifEnemy.czero)then
			table.insert(desc_arr, get_txt('ifTarget')..' '..get_txt('does NOT have')..' '..(card_obj.ifEnemy.czero)..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy));
		elseif(card_obj.ifEnemy.hpLessEx)then
			local txt = get_txt("ifTargetHpLessEx");
			txt = txt:gsub("VAL", card_obj.ifEnemy.hpLessEx);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy, extra_hints));
		elseif(card_obj.ifEnemy.hpLess)then
			local txt = get_txt("ifTargetHpLess");
			txt = txt:gsub("VAL", card_obj.ifEnemy.hpLess);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy, extra_hints));
		elseif(card_obj.ifEnemy.hpMore)then
			local txt = get_txt("ifTargetHpMore");
			txt = txt:gsub("VAL", card_obj.ifEnemy.hpMore);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy, extra_hints));
		elseif(card_obj.ifEnemy.more)then
			local txt = get_txt('ifTargetHaveMoreCONThenVAL');
			txt = txt:gsub('VAL', card_obj.ifEnemy.more);
			txt = txt:gsub('CON', card_obj.ifEnemy.condition);
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy));
		elseif(card_obj.ifEnemy.condition and card_obj.ifEnemy.val)then
			if(card_obj.ifEnemy.condition=="dead" and card_obj.ifEnemy.val==true)then
				local txt = get_txt('event_kill');
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy));
			else
				local txt = get_txt('ifTargetCONequalVAL');
				txt = txt:gsub('VAL', tostring(card_obj.ifEnemy.val));
				txt = txt:gsub('CON', card_obj.ifEnemy.condition);
				table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy));
			end
		elseif(card_obj.ifEnemy.intend)then
			table.insert(desc_arr, get_txt("ifTargetIntend_"..card_obj.ifEnemy.intend)..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy));
		else
			local txt = get_txt('ifTargetHas');
			txt = txt:gsub('CON', get_txt(card_obj.ifEnemy.condition));
			table.insert(desc_arr, txt..": "..getCardDesc(card_obj.ifEnemy.play, hero, multy));
		end
		if(card_obj.ifEnemy.otherwise)then
			table.insert(desc_arr, get_txt("otherwise")..": "..getCardDesc(card_obj.ifEnemy.otherwise, hero, multy));
		end
	end
	if(card_obj.create)then
		-- table.insert(desc_arr, get_txt('create')..': '..get_txt(card_obj.create.attr.."_"..tostring(card_obj.create.val)).." x"..card_obj.create.count);
		local txt;-- = get_txt('create'..'_'..card_obj.create.attr.."_"..tostring(card_obj.create.val).."_x"..card_obj.create.count);
		if(card_obj.create.val)then
			local hint = 'create'..'_'..card_obj.create.attr.."_"..tostring(card_obj.create.val).."_x"..card_obj.create.count;
			if(card_obj.create.class=="all")then
				hint = hint.."_classAll";
			end
			if(card_obj.create.pick)then
				hint = hint.."_pickX";
			end
			if(card_obj.create.attr=="tag")then
				local hint = "create_card_by_name_class"..card_obj.create.class;
				txt = get_txt(hint);
				-- 'TAG' into your TARGET
				txt = txt:gsub("TAG", card_obj.create.val);
				if(card_obj.create.target)then
					txt = txt:gsub("TARGET", get_txt(card_obj.create.target.."_hint"));
				else
					txt = txt:gsub("TARGET", get_txt("hand_hint"));
				end

				if(card_obj.create.change)then
					local change_arr = {};
					for attr2,val2 in pairs(card_obj.create.change) do
						if(val2 == "ENERGY")then
							-- new_card[attr2] = gameobj.energy + (card_obj.create.changeX or 0);
							if(card_obj.create.changeX)then
								table.insert(change_arr, get_txt(attr2) .."=".. get_txt(string.lower(val2)) .."+".. (card_obj.create.changeX or 0));
							else
								table.insert(change_arr, get_txt(attr2) .."=".. get_txt(string.lower(val2)) );
							end
							
						else
							-- new_card[attr2] = val2 + (card_obj.create.changeX or 0);
							table.insert(change_arr, val2 + (card_obj.create.changeX or 0).." "..get_txt(attr2));
						end
					end
					txt = txt.." ("..table.concat(change_arr, ", ")..")";
				end
			else
				txt = get_txt(hint);
			end
			
			if(card_obj.create.pick)then
				txt = txt:gsub("PICK", card_obj.create.pick);
			end
		else
			txt = get_txt("create_class_hero_x"..card_obj.create.count);
		end
		if(card_obj.create.upgrade)then
			txt = txt.." ("..get_txt('upgraded')..")";
		end
		if(card_obj.create.energyTemp)then
			local atxt = get_txt("change_energyTemp");
			atxt = atxt:gsub("VAL", card_obj.create.energyTemp);
			txt = txt.." ("..atxt..")";
		end
		if(card_obj.energy==X)then
			if(card_obj.extraX)then
				txt=txt..get_txt("_times"):gsub("TIMES", "X+"..card_obj.extraX);
			else
				txt=txt..get_txt("_times"):gsub("TIMES", "X");
			end
		end
		table.insert(desc_arr, txt);
		-- Add X random (upgraded) colorless cards into your hand X times
		-- add a random card to your hand X times
	end
	if(card_obj.onExhaust)then
		table.insert(desc_arr, get_txt('onExhaust')..": "..getCardDesc(card_obj.onExhaust, hero, multy, extra_hints));
	end
	if(card_obj.onTurn)then
		table.insert(desc_arr, get_txt('onTurn')..": "..getCardDesc(card_obj.onTurn, hero, multy, extra_hints));
	end
	if(card_obj.onDiscard)then
		table.insert(desc_arr, get_txt('onDiscard')..": "..getCardDesc(card_obj.onDiscard, hero, multy, extra_hints));
	end
	if(card_obj.once)then
		table.insert(desc_arr, getCardDesc(card_obj.once, hero, multy, extra_hints));
	end
	if(card_obj.after)then
		table.insert(desc_arr, getCardDesc(card_obj.after, hero, multy, extra_hints));
	end
	if(card_obj.addDmgByCard)then
		-- table.insert(desc_arr, get_txt('addDmgByCard')..':');
		-- table.insert(desc_arr, card_obj.addDmgByCard[1].." +"..card_obj.addDmgByCard[2]..'x'..getAddDmg(login_obj.deck, card_obj)/card_obj.addDmgByCard[2]);
		local txt = get_txt("addDmgByCard");
		txt = txt:gsub("VAL", card_obj.addDmgByCard[1]);
		txt = txt:gsub("DMG", card_obj.addDmgByCard[2]);
		txt = txt:gsub("TOTAL", card_obj.addDmgByCard[2]..'x'..getAddDmg(login_obj.deck, card_obj)/card_obj.addDmgByCard[2]);
		table.insert(desc_arr, txt);
		-- table.insert(desc_arr, card_obj.addDmgByCard[2]..'x'..getAddDmg(login_obj.deck, card_obj)/card_obj.addDmgByCard[2]);
	end
	if(card_obj.dmgByEnemiesCount)then
		local txt = get_txt("dmgByEnemiesCount");
		txt = txt:gsub("DMG", card_obj.dmgByEnemiesCount);
		table.insert(desc_arr, txt);
	end
	if(card_obj.playable)then
		table.insert(desc_arr, get_txt('rule_'..card_obj.playable..'_hint'));
	end
	if(card_obj.discount)then
		table.insert(desc_arr, get_txt('discount_by_'..card_obj.discount));
	end
	
	if(card_obj.nextTurn)then
		card_obj.nextTurn.energy = card_obj.energy;
		card_obj.nextTurn.extraX = card_obj.extraX;
		table.insert(desc_arr, get_txt('next_turn')..": "..getCardDesc(card_obj.nextTurn, hero, multy, extra_hints));
		
		if(card_obj.energy==X)then
			if(card_obj.extraX)then
				-- txt=txt..get_txt("_times"):gsub("TIMES", "X+"..card_obj.extraX);
				-- do_this_VAL_times
				local txt = get_txt("do_this_VAL_times");
				txt = txt:gsub("VAL", "X+"..card_obj.extraX);
				table.insert(desc_arr, txt);
			-- else
				-- txt=txt..get_txt("_times"):gsub("TIMES", "X");
			end
		end
	end

	local function add_str(attr)
		if(card_obj[attr])then
			table.insert(desc_arr, get_txt(attr));
			table.insert(extra_hints, attr);
		end
	end
	-- add_str("firecard");
	-- Can be upgraded any number of times
	
	add_str("armorFromDraw");
	add_item_string("event");
	add_item_string("eventAll");
	add_item_string("rewriteOnUseAction");
	add_str("onlyKeepZero");
	add_str("cleanse");
	add_str("shuffle");
	add_str("innate");
	add_str("vamp");
	add_str("vamparmor");
	add_str("exhaust");
	add_str("endTurn");
	-- add_str("enemySkipTurn");
	add_str("ethereal");
	add_str("retain");
	add_str("suicide");
	add_str("escape");
	add_str("unlimited");
	add_str("evokeReSummon");
	add_str("drainEnergy");
	
	
	if(card_obj.rnd)then
		table.insert(desc_arr, card_obj.rnd[1].."%: "..getCardDesc(card_obj.rnd[2], hero, multy, extra_hints));
	end

	return table.concat(desc_arr, ", ");
end
function getHeroObjByAttr(attr, val)
	for i=1,#heroes do
		if(heroes[i][attr]==val)then
			return heroes[i];
		end
	end
end

_G.card_paths = {};
function createCardMC(tar, card_obj, hero, class, thisScale)
	local ctype = card_obj.tag;
	local card_prms = cards_indexes[ctype];
	local mc = newGroup(tar);
	mc.card_obj = card_obj;
		
	local body = newGroup(mc);
	if(thisScale==nil)then
		thisScale = scaleGraphics;
	end

	body:scale(_G.settings.cardScaleMin, _G.settings.cardScaleMin);
	mc.body = body;
	local holder = display.newImage(body, "image/cards_back.png");
	holder:scale(thisScale/2, thisScale/2);
	mc._scale = thisScale;
	
	if(card_obj.energy)then
		if(type(card_obj.energy)=="number")then
			if(card_obj.energy>9)then
				card_obj.energy=9;
			end
		end
	end

	local ico;
	-- if(options_warnings_images)then
		local card_class = class or card_obj.class;
		
		if(card_class=="any")then
			card_class = login_obj.class;
		end
		
		-- if(class or login_obj.class)then
			-- ico = display.newImage(body, "image/cards/"..(class or login_obj.class).."/"..get_name_id(ctype)..".png");
			-- if(ico == nil)then
		
		local ico_group = newGroup(body);
		if(optionsBuild=="html5")then
			local fname;
			if(card_obj.icon)then
				fname = "image/cards/"..card_obj.icon..".jpg";
			else
				fname = "image/cards/"..card_class.."/"..get_name_id(ctype)..".jpg";
			end
			
			ico = game_art:newImage(ico_group, fname);
		else
			if(card_obj.icon)then
				ico = display.newImage(ico_group, "image/cards/"..card_obj.icon..".jpg");
			end
			if(ico==nil)then
				ico = display.newImage(ico_group, "image/cards/"..card_class.."/"..get_name_id(ctype)..".jpg");
			end
		end
		
		if(ico and card_obj.hue)then
			ico.fill.effect = "filter.hue";
			ico.fill.effect.angle = card_obj.hue;
		end
		
		
		
			-- end
		-- end
		-- if(ico==nil)then
			-- ico = display.newImage(body, "image/cards/"..get_name_id(ctype)..".png");
		-- end
		-- if(ico)then
			ico_group:scale(thisScale/2, thisScale/2);
		-- end

		-- if(ico)then
			ico_group.x, ico_group.y = 0, -41*thisScale;
		-- end
	-- end
	
	local hue, saturation = 0, 1;
	local hero_obj = getHeroObjByAttr("class", card_class);
	if(hero_obj)then
		if(hero_obj.hue)then
			hue = -hero_obj.hue;
		end
	end
	if(class=="none")then
		hue, saturation = 0, 0;
	end
	
	if(hero_obj)then
		local set_id = save_obj['custom_scin_'..hero_obj.class.."_set"] or 1;
		local custom_filters = save_obj['custom_scin_'..hero_obj.class.."_cards"..set_id];
		
		-- save_obj['custom_ccc_'..hero_obj.class..'_'..i] = {hue=math.random(1, 360)};
		-- ico.fill.effect.angle = save_obj['custom_ccc_'..hero_obj.class..'_'..i].hue;
		if(save_obj['custom_ccc_'..hero_obj.class..'_'..card_obj.ctype])then
			hue, saturation = 0, 1;
			local custom_filters = save_obj['custom_ccc_'..hero_obj.class..'_'..card_obj.ctype];
			if(custom_filters.hue)then hue = custom_filters.hue; end
			if(custom_filters.saturate)then saturation = custom_filters.saturate; end
		elseif(custom_filters)then
			hue, saturation = 0, 1;
			if(custom_filters.hue)then hue = custom_filters.hue; end
			if(custom_filters.saturate)then saturation = custom_filters.saturate; end
		end
	end

	local cfront = newShaderImage(body, "image/cards_front_2.png", hue, saturation, true);
	cfront:scale(thisScale/2, thisScale/2);

	
	
	local energymc;
	
	local emitter = elite.add_emitter(body, {0.8,0.7,0.1, 0, -5}) -- r g b x y speed angle
	emitter:scale(thisScale/2, thisScale/2);
	emitter:stop();
	function mc:emitter(bol)
		if(bol)then
			emitter:start();
		else
			emitter:stop();
		end
	end
	
	local holder = display.newImage(body, "image/cards_rarity_"..card_obj.rarity..".png", 0, 2*thisScale);
	if(holder)then holder:scale(thisScale/2, thisScale/2); end
	
	local typemc = display.newImage(body, "image/cards_ctype"..card_obj.ctype..".png");
	if(typemc)then
		typemc.y = 67*thisScale;
		typemc:scale(thisScale/2, thisScale/2);
	else
		royal:reportBug("main(3756)missing ctype for card:"..card_obj.tag);
	end
	
	
	-- local etxt = display.newText(body, card_obj.energy, -32*scaleGraphics, -60*scaleGraphics, fontMain, 24*scaleGraphics);
	-- etxt:setTextColor(85/255, 71/255, 45/255);
	
	-- local ntxt = display.newText(body, get_name(ctype), 0, 0*scaleGraphics, fontMain, 14*scaleGraphics);
	local ntxt = newOutlinedText(body, "NAME", 0, -2*thisScale, fontMain, 13*thisScale, 1, 0, 1);
	ntxt.c = {1, 1, 1};
	-- local ctxt = display.newText(body, get_txt("card_type_"..card_prms.ctype), 0, 69*scaleGraphics, fontMain, 10*scaleGraphics);
	-- ctxt:setTextColor(85/255, 71/255, 45/255);
	mc.ntxt = ntxt;
	
	mc.extra_hints = {};
	-- local text = getCardDesc(card_obj, hero, nil, mc.extra_hints);
	-- local dtxt = display.newText(body, "DESC", 0*scaleGraphics, 10*scaleGraphics, 74*scaleGraphics, 60*scaleGraphics, fontMain, 9*scaleGraphics);
	-- dtxt.anchorY = 0;
	-- dtxt:setTextColor(85/255, 71/255, 45/255);
	
	-- local energybg = display.newImage(body, "image/cards_energy_green.png");
	
	if(card_obj.lvl==nil)then card_obj.lvl=1; end
	if(type(card_obj.lvl)~="number")then card_obj.lvl = 1; end
	function mc:updateTitleText()
		if(card_obj==nil or card_obj.lvl==nil)then
			return
		end
		if(ntxt.setTextColor==nil)then
			return
		end
		
		if(card_obj.lvl>1)then
			ntxt:setText(get_name(ctype).."+");
			ntxt.c = {50/255, 230/255, 50/255};
		else
			ntxt:setText(get_name(ctype));
			ntxt:setTextColor(50/255, 230/255, 50/255);
		end
		ntxt:setTextColor(ntxt.c[1], ntxt.c[2], ntxt.c[3]);
		while(ntxt.width>74*thisScale)do
			ntxt:setSize(ntxt:getSize()-1);
		end
	end
	function mc:author()
		if(mc.atxt)then
			mc.atxt:removeSelf();
			mc.atxt = nil;
		end
		if(mc.lmc)then
			mc.lmc:removeSelf();
			mc.lmc = nil;
		end
		if(mc.tmc)then
			mc.tmc:removeSelf();
			mc.tmc = nil;
		end
		if(card_obj.author)then
			local atxt = card_obj.author;
			if(card_obj.timestamp)then
				atxt = atxt.." / "..elite.get_time_txt(getSeconds() - card_obj.timestamp/1000, true).."";
			end
			mc.atxt = newOutlinedText(body, atxt, 50*thisScale, 84*thisScale, fontMain, 10*thisScale, 1, 0, 1);
			mc.atxt:translate(-mc.atxt.width/2, 0);
		end
		if(card_obj._likes)then
			mc.lmc = newGroup(body);
			local lico = display.newImage(mc.lmc, "image/mini/__up.png", -50*thisScale + 8*thisScale, 84*thisScale);
			lico:scale(thisScale/2, thisScale/2);
			local ltxt = newOutlinedText(mc.lmc, card_obj._likes, lico.x, lico.y, fontMain, 10*thisScale, 1, 0, 1);
		end
		if(card_obj._merged)then
			mc.tmc = newGroup(body);
			local lico = display.newImage(mc.tmc, "image/mini/_barricade.png", -50*thisScale + 8*thisScale, 84*thisScale);
			if(mc.lmc)then
				lico.x = lico.x + 14*thisScale
			end
			lico:scale(thisScale/2, thisScale/2);
			local ltxt = newOutlinedText(mc.tmc, card_obj._merged, lico.x, lico.y, fontMain, 10*thisScale, 1, 0, 1);
		end
	end
	function mc:update(enemy)
		if(hero)then
			if(hero.entangled>0)then
				if(card_obj.ctype==CTYPE_ATTACK)then
					
				end
			end
			if(hero.corruption>0)then
				if(card_obj.ctype==CTYPE_SKILL)then
					card_obj.energy = 0;
					card_obj.exhaust = true;
				end
			end
			if(hero.candleblue>0)then
				if(card_obj.ctype==CTYPE_CURSE)then
					card_obj.playable = nil;
					card_obj.harm = 1;
					card_obj.exhaust = true;
				end
			end
			if(hero.candlered>0)then
				if(card_obj.ctype==CTYPE_STATUS)then
					card_obj.playable = nil;
					card_obj.exhaust = true;
				end
			end
			-- conditions.entangled = {expire=1, expireAtEnd=true, debuff=true, hinted=true};
			-- conditions.corruption = {event="played_"..CTYPE_SKILL, number=false, rewrite={ctype=CTYPE_SKILL, attrs={energy=0, exhaust=true}}};
			-- conditions.candleblue	= {event="played_"..CTYPE_CURSE, number=false, rewrite={ctype=CTYPE_CURSE, attrs={playable=null, harm=1, exhaust=true}}};
			-- conditions.candlered	= {event="played_"..CTYPE_STATUS,number=false, rewrite={ctype=CTYPE_STATUS,attrs={playable=null, exhaust=true}}};
		end
		mc:updateTitleText();
		-- fitTextFildByW(ntxt, 36*scaleGraphics, 14*scaleGraphics);
		-- if(card_obj.discount)then
		
		if(tonumber(card_obj.energy) and tonumber(card_obj.energy)>9)then
			card_obj.energy = 9;
		end
		
		local energy = card_obj.energyTemp or card_obj.energyTillUse or card_obj.energy;
		if(tonumber(energy) and tonumber(energy)>9)then
			energy = 9;
		end
		-- end
		-- if(hero)then
			-- if(hero.enlightenment>0)then
				-- if(card_obj.energy~='x')then
					-- if(card_obj.energy>1)then
						-- energy = 1;
					-- end
				-- end
			-- end
		-- end
		
		if(energymc)then
			energymc:removeSelf();
		end
		-- energymc = display.newImage(body, "image/cards_energy_"..energy..".png");
		-- if(class)then
		
		
		-- end
		-- if()then
		-- end
		-- print(class, hue)
		if(card_obj.playable=="unplayable")then
			energy = "_";
		end
		if(hero)then
			if(hero.entangled>0)then
				if(card_obj.ctype==CTYPE_ATTACK)then
					energy = "_";
				end
			end
		end
		-- if(hue)then
			energymc = newShaderImage(body, "image/cards_energy_"..energy..".png", hue, saturation, true);
		-- else
			-- energymc = display.newImage(body, "image/cards_energy_"..energy..".png");
		-- end
		if(energymc)then 
			energymc:scale(thisScale/2, thisScale/2);
			energymc.y = -3*thisScale;
		end
		
		
		
		if(mc.dtxt)then
			mc.dtxt:removeSelf();
			mc.dtxt = nil;
		end
		mc.dtxt = display.newText(body, "DESC", 0*thisScale, 10*thisScale, 74*thisScale, 0, fontMain, 9*thisScale);
		mc.dtxt.anchorY = 0;
		
		
		mc.extra_hints = {};
		local text = getCardDesc(card_obj, hero, nil, mc.extra_hints, enemy);
		mc.dtxt.text = text;
		
		local dtxt = mc.dtxt;
		while(dtxt.height>46*thisScale and dtxt.size>5)do 
			dtxt.size = dtxt.size-1; 
		end
	end
	mc:update();
	
	function mc:showExtraHints()
		if(tar.insert==nil)then return; end
		
		mc:hideExtraHints(true);
		
		local hintsGroup = newGroup(tar);
		hintsGroup.mtype="ehint";
		hintsGroup.cardmc = mc;
		
		for i=#mc.extra_hints,1,-1 do
			for j=#mc.extra_hints,1,-1 do
				if(i~=j and mc.extra_hints[i]==mc.extra_hints[j])then
					table.remove(mc.extra_hints, j);
					break;
				end
			end
		end
		
		if(mc.x==nil)then
			return
		end
		
		local j = 1;
		for i=1,#mc.extra_hints do
			local attr = mc.extra_hints[i];
			if(get_txt_force(attr.."_hint"))then
				local ehintmc = newGroup(hintsGroup);
				ehintmc.x, ehintmc.y = mc.x + 116*thisScale, mc.y + (j-2)*52*scaleGraphics;
				if(holder.contentWidth)then
					if(mc.x + 116*scaleGraphics + holder.contentWidth/2>_W)then
						ehintmc.x = mc.x - 116*scaleGraphics;
					end
				end
				
				local bgmc = add_bg("bg_3", 114*scaleGraphics, 50*scaleGraphics, true);
				bgmc.x, bgmc.y = 0, 0;
				ehintmc:insert(bgmc);
				
				local dtxt1 = display.newText(ehintmc, get_txt(attr), 0*scaleGraphics, -15*scaleGraphics, fontMain, 9*scaleGraphics);
				dtxt1:setTextColor(237/255, 198/255, 80/255);
				
				local dtxt2 = display.newText(ehintmc, get_txt(attr.."_hint"), 2*scaleGraphics, 7*scaleGraphics, 106*scaleGraphics, 28*scaleGraphics, fontMain, 8*scaleGraphics);						
				j = j+1;
			end
		end
	end
	function mc:hideExtraHints(force)
		if(tar.numChildren==nil)then return; end
		for i=tar.numChildren,1,-1 do
			local ehintmc = tar[i];
			if(ehintmc.mtype=="ehint")then
				if(ehintmc.cardmc==mc or force)then
					ehintmc:removeSelf();
				end
			end
		end
	end
	
	-- print("_ctype:", ctype);
	
	
	return mc, body, ntxt;
end

require("main_quest");

function show_fade_gfx(callback, extra)
	if(_G.changingscene)then
		return;
	end
	local fade_in = display.newRect(mainGroup.parent, _W/2, _H/2, _W, _H);
	fade_in:setFillColor(0.1);
	fade_in.alpha = 0;
	fade_in.alpha_speed = 0.02;
	removeHint();
	
	_G.changingscene = true;
	
	local scene_mc = director:getCurrHandler();
	if(scene_mc)then
		if(scene_mc.onCloseHandler)then
			scene_mc:onCloseHandler();
		end
	end
	
	local function turnHandler2(e)
		fade_in.alpha = fade_in.alpha - 0.01;
		fade_in.alpha = fade_in.alpha * 0.95;
		if(fade_in.alpha<=0)then
			fade_in:removeSelf();
			Runtime:removeEventListener('enterFrame', turnHandler2);
		end
	end
	
	local function turnHandler1(e)
		fade_in.alpha = fade_in.alpha + fade_in.alpha_speed;
		fade_in.alpha_speed = fade_in.alpha_speed + 0.005;
		if(fade_in.alpha>=1)then
			fade_in.alpha = 1;
			
			if(extra)then
				if(extra())then
					return
				end
			end
			
			callback();
			mainGroup.parent:insert(fade_in);
			
			local scene_mc = director:getCurrHandler();
			local scene_info = newGroup(scene_mc);
			
			function scene_mc:refreshDebugInfo()
				cleanGroup(scene_info);
				local scene_name = scene_mc.name or 'undefined';
				eliteSoundsIns:ambient_play("amb_"..scene_name);
				
				local sx = 0;
				-- if(optionsBuild == "ios")then
					-- sx = 22*scaleGraphics;
				-- end
				
				local scene_dtxt = newOutlinedText(scene_info, scene_name.."/", 0, 6*scaleGraphics, nil, 8*scaleGraphics, 1, 0, 1);
				
				if(scene_name=="battle" or scene_name=="map")then
					if(login_obj.map)then
						scene_dtxt:setText(scene_dtxt.text.."act"..tostring(login_obj.map.lvl).."/");
					end
				end
				
				-- print(scene_name, scene_name=="end", _G.playerName, save_obj.playerName);
				if(scene_name=="lobby")then
					if(royal.lobbyStatus)then
						if(save_obj.customName)then
							scene_dtxt:setText(scene_dtxt.text.."status:"..tostring(royal.lobbyStatus).."/");
						end
					end
				end
				if(scene_name=="end" or scene_name=="lobby")then
					-- _itemAchievement._google_status
					-- _G.playerName
					-- save_obj.playerName
					-- if(_itemAchievement._google_status)then
						-- scene_dtxt:setText(scene_dtxt.text..tostring(_itemAchievement._google_status).."/");
					-- end
					local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
					if(player_name)then
						scene_dtxt:setText(scene_dtxt.text..tostring(player_name).."/");
					end
					-- if(save_obj.customName)then
						-- scene_dtxt:setText(scene_dtxt.text..tostring(save_obj.customName).."/");
					-- end
					-- if(_G.playerName)then
						-- scene_dtxt:setText(scene_dtxt.text..tostring(_G.playerName).."/");
					-- end
					-- if(save_obj.playerName)then
						-- scene_dtxt:setText(scene_dtxt.text..tostring(save_obj.playerName).."/");
					-- end
				end
				scene_dtxt.x = sx+scene_dtxt.width/2;
				
				local scene_dtxt = newOutlinedText(scene_info, "v"..optionsVersion..optionsBuild:sub(1,1), 0, 16*scaleGraphics, nil, 8*scaleGraphics, 1, 0, 1);
				scene_dtxt.x = sx+scene_dtxt.width/2;
				
				local scene_dtxt = newOutlinedText(scene_info, math.round(scaleGraphics*100).."%", 0, 26*scaleGraphics, nil, 8*scaleGraphics, 1, 0, 1);
				scene_dtxt.x = sx+scene_dtxt.width/2;
			end
			scene_mc:refreshDebugInfo();

			Runtime:removeEventListener('enterFrame', turnHandler1);
			Runtime:addEventListener('enterFrame', turnHandler2);
			_G.changingscene = nil;
		end
	end
	Runtime:addEventListener('enterFrame', turnHandler1);
end

function show_menu(options)
	show_fade_gfx(function()
		director:changeScene(options, "src.screenMenu");
		music_play("music_menu"..math.random(1, 1));
	end);
end
function show_start(options)
	show_fade_gfx(function()
		director:changeScene(options, "src.screenStart");
		music_play("music_menu"..math.random(1, 1));
	end);
end
function show_skulls(winsByClass, callback)
	show_fade_gfx(function()
		director:changeScene({winsByClass=winsByClass, callback=callback}, "src.screenSkulls");
	end);
end
function show_map()
	show_fade_gfx(function()
		director:changeScene("src.screenMap");
		music_play("music_menu"..math.random(2, 2));
	end);
end
function show_forge()
	show_fade_gfx(function()
		director:changeScene("src.screenForge");
	end);
end
function show_end()
	show_fade_gfx(function()
		director:changeScene("src.screenEnd");
	end);
end
function show_more()
	show_fade_gfx(function()
		director:changeScene("moreEliteGames.ScreenMore");
	end);
end
function show_lobby()
	show_fade_gfx(function()
		director:changeScene('src.screenLobby');
	end);
end
function show_battle(map_point)
	if(pixelArtOn)then pixelArtOn(); end
	
	if(map_point.party)then
		local function loadUnitSprite(enemy_scin)
			if(enemy_scin)then
				local set_obj = game_art.sets[enemy_scin];
				if(set_obj)then
					if(set_obj.image==nil)then
						game_art:loadDataByObj(set_obj);
					end
				end
			end
		end
		local party_units = map_point.party.units;
		for i=1,#party_units do
			local enemy_id = party_units[i];
			local enemy_obj = getEnemyObjByTag(enemy_id);
			if(enemy_obj)then
				local enemy_scin = enemy_obj.scin;
				loadUnitSprite(enemy_scin);

				for j=1,#enemy_obj.cards do
					local card_obj = enemy_obj.cards[j];
					if(card_obj.summon)then
						if(card_obj.summon.list)then
							for k=1,#card_obj.summon.list do
								local enemy_id = card_obj.summon.list[k];
								local enemy_obj = getEnemyObjByTag(enemy_id);
								local enemy_scin = enemy_obj.scin;
								loadUnitSprite(enemy_scin);
							end
						end
					end
					
				end
			end
		end
	end
	
	local enemy_scin = "warrior";
	local set_obj = game_art.sets[enemy_scin];
	if(set_obj)then
		if(set_obj.image==nil)then
			game_art:loadDataByObj(set_obj);
		end
	end
	
	for attr,obj in pairs(pets) do
		local set_obj = game_art.sets[obj.scin];
		if(set_obj)then
			if(set_obj.image==nil)then
				game_art:loadDataByObj(set_obj);
			end
		end
	end
	
	show_fade_gfx(	function() 
		if(pixelArtOff)then pixelArtOff(); end
		login_obj.game = {deck={}, draw={}, hand={}, trash={}, turn=1};
		local prms = {map_point=map_point};
		director:changeScene(prms, "src.screenBattle"); end, 
	function() 
		return game_art:loading_bol(); 
	end);
		
	music_play("music_game"..math.random(1, 5));--music_menu2
end
function show_shop()
	show_fade_gfx(function()
		director:changeScene("src.screenShop");
	end);
end
function show_mini(gtype)
	show_fade_gfx(function()
		director:changeScene({gtype=gtype}, "src.screenMini");
	end);
end
function show_event(map_point, event_obj, once)
	show_fade_gfx(function()
		director:changeScene({map_point=map_point, event_obj=event_obj}, "src.screenEvent");
	end);
end
function show_destiny()
	local event = {tag="Destiny", avatar="maid", actions={}};
	local function addEventOption(startup)
		-- print("_startup:", startup.tag, startup._picked, startup.reAddHandicap);
		if(startup._picked~=true)then
			local obj = {};--txt="["..(#event.actions+1).."]"
			for attr,val in pairs(startup) do
				obj[attr] = val;
			end
			obj._tracking = startup;
			table.insert(event.actions, obj);
		end
		if(startup._picked and startup.reAddHandicap)then
			local reAddHandicap = startup.reAddHandicap;
			startup.reAddHandicap = nil;
			
			local new_option = table.cloneByAttr(startup);
			table.add(new_option, reAddHandicap, "times");
			new_option.reAddHandicap = reAddHandicap;
			new_option._picked = nil;
			table.insert(login_obj.handicaps, new_option);
		end
	end
	if(login_obj.handicaps==nil)then
		login_obj.handicaps = table.clone(handicaps);
	end
	for i=1,#login_obj.handicaps do
		addEventOption(login_obj.handicaps[i]);
	end
	table.shuffle(event.actions);
	while(#event.actions>4)do
		table.remove(event.actions, 1);
	end
	for i=1,#event.actions do
		event.actions[i].txt = "["..i.."]";
	end
	show_event(nil, event);
end
function show_rest()
	show_fade_gfx(function()
		director:changeScene("src.screenRest");
		addLoginStat("rests");
	end);
end
_G.options_save_fname = "save04";
function saveGlobalObj()
	save_obj.version = optionsVersion;
	save_obj.achievements = _itemAchievement:getAchievments();
	local save_str = json.encode(save_obj);
	saveFile(options_save_fname..".json", save_str);
end
function saveGame()
	login_obj.version = optionsVersion;
	local save_str = json.encode(login_obj);
	saveFile("save_"..login_obj.class..".json", save_str);
	
	saveGlobalObj()
end
function saveCloud()
	if(settings.playerName==nil)then
		show_msg('Player Name not defined.');
		return
	end
	if(settings.playerPIN==nil)then
		show_msg('Player PIN not defined.');
		return
	end
	local loading = 0;
	-- for i=1,3 do
	local i = 0;
	local function loadCloudHandler(e)
		print(i, e.phase, e.response, e.isError);
		if(e.isError)then
			show_msg('uploading('..i..'): '..tostring(e.phase)..", "..tostring(e.isError)..", "..tostring(e.response));
		else
			if(e.phase=='ended')then
				show_msg(get_txt('cloud_synced'));
			else
				print('uploading('..i..'): '..tostring(e.phase));
			end
		end
		loading = loading-1;
		if(loading<1)then
			-- hide_loading();
			-- show_menu();
			-- show_msg(get_txt('saves_uploaded'));
		end
	end
	
	local path = system.pathForFile(options_save_fname..".json", system.DocumentsDirectory);
	local file = io.open( path, "r" );
	if (file) then
		local contents = file:read( "*a" );
		if(contents and #contents>0)then
			local prms = {};
			local user_id = settings.playerName; user_id=user_id:lower();
			-- local encodedString = b64lib.b64("Hello {('%!&jQ')} World");
			-- local decodedString = b64lib.unb64(encodedString);
			
			local new_obj = json.decode(contents);
			if(new_obj.version==nil)then
				show_msg("Cloud Save failed(1): local save corrupted");
				return
			end
			if(new_obj.unlocks==nil)then
				show_msg("Cloud Save failed(2): local save corrupted");
				return
			end

			contents = b64lib.b64(contents);
			prms.body = "user_id="..user_id.."&pin="..settings.playerPIN.."&sid="..i.."&save="..contents; -- user_id=uid_itxt.text, pin=pid_itxt.text, sid=1
			network.request("http://theelitegames.net/rbqsaves/save.php", "POST", loadCloudHandler, prms);
			loading = loading+1;
		end
	end
	-- end
	
	if(loading>0)then
		-- require("eliteScale").saveScales();
		-- show_loading(10000);
		-- localGroup:removeNatives();
	end
end
function loadCloud(facemc)
	if(settings.playerName==nil)then
		show_msg('Player Name not defined.');
		return
	end
	if(settings.playerPIN==nil)then
		show_msg('Player PIN not defined.');
		return
	end
	local loading = 0;
	local i = 0;
	-- for i=1,3 do
	local prms = {};
	local function loadCloudHandler(e)
		if(facemc.insert==nil)then
			return
		end
		if(e.isError)then
			show_msg(tostring(i)..": "..tostring(e.response));
		else
			local path = system.pathForFile(options_save_fname..".cloud", system.DocumentsDirectory);
			local file = io.open(path, "r");
			if(file)then
				local contens = file:read("*a");
				io.close( file );
				if(contens)then
					contens = contens:sub(4, #contens);
					-- for si=1,math.min(10,#contens) do
						-- local b = string.byte(contens, si)
						-- print(si, b, string.char(b));
					-- end
					
					local check = contens:sub(1, 20);
					check = check:lower();
					-- print("_check:", check);
					if(check:find("error", 1)~=nil)then
						show_msg(contens);
					else
						local new_str = b64lib.unb64(contens);
						local new_obj = json.decode(new_str);

						local unlocks = #table.keys(new_obj.unlocks);
						local old_unlocks = #table.keys(save_obj.unlocks);
						
						local txt_arr = {};
						table.insert(txt_arr, get_txt('confirming'));
						table.insert(txt_arr, get_txt("version")..":"..save_obj.version.." >>> "..new_obj.version);
						table.insert(txt_arr, get_txt("unlocks")..":"..old_unlocks.." >>> "..unlocks);
						-- act4
						-- winsByClass
						-- stats.bosses stat_bosses="Bosses Slain"
						if(save_obj.stats.bosses and new_obj.stats.bosses)then
							table.insert(txt_arr, get_txt("stat_bosses")..":"..save_obj.stats.bosses.." >>> "..new_obj.stats.bosses);
						end
						local cnfr_mc = royal.show_wnd_question(facemc, facemc.buttons, txt_arr, function()
							_G.save_obj = new_obj;
							saveGame();
						end, function()
							
						end);
						cnfr_mc.x, cnfr_mc.y = _W/2 - cnfr_mc.w/2, _H/2 - cnfr_mc.h/2;
					end
				end
			end
		end
		
		loading = loading-1;
		if(loading<1)then
			-- show_menu();
			hide_loading();
			-- show_msg(get_txt('saves_downloaded'));
		end
	end
	
	local user_id = settings.playerName; user_id=user_id:lower();
	prms.body = "user_id="..user_id.."&pin="..settings.playerPIN.."&sid="..i;
	prms.response = {
		filename = options_save_fname..".cloud",
		baseDirectory = system.DocumentsDirectory
	}
	network.request("http://theelitegames.net/rbqsaves/load.php?time"..getSeconds(), "POST", loadCloudHandler, prms);
	loading = loading+1;
	-- end
	
	require("eliteScale").saveScales();
	show_loading(10000);
	
	-- localGroup:removeNatives();
end

function loadGame(force)
	local load_str = loadFile("settings.json");
	if(load_str)then
		_G.settings = json.decode(load_str);
		if(settings.fullscreen)then
			native.setProperty("windowMode", "fullscreen");
		end
	else
		if(options_desctop and optionsBuild=="linux")then
			native.setProperty("windowMode", "fullscreen");
		end
	end

	local save_str = loadFile(options_save_fname..".json");
	if(save_str)then
		_G.save_obj = json.decode(save_str);
		_itemAchievement:setAchievments(save_obj.achievements);
	elseif(force)then
		_G.save_obj = force;
	end
	
	if(system.getInfo("environment")=="simulator")then
		_G.save_obj.druid_admin = false;
	end
	_G.save_obj.druid_admin = false;
	
	-- if(optionsVersion=="0.709")then
		-- local save_str = loadFile("save03.json");
		-- if(save_str)then
			-- local obj = json.decode(save_str);
			-- if(obj.dead~=true)then
				-- print('save restored for', obj.class);
				-- save_obj.unlocks['hero_'..obj.class] = true;
				-- saveFile("save_"..obj.class..".json", save_str);
				-- saveFile("save03.json", json.encode({dead=true}));
			-- end
		-- end
	-- end

	-- table.insert(_G.scores_unsubmitted, score_obj);
	-- local save_str = b64lib.b64(json.encode(scores_unsubmitted));
	-- saveFile('system.b64', save_str);
	
	local load_str = loadFile('system.b64');
	if(load_str)then
		local load_arr = b64lib.unb64(load_str);
		_G.scores_unsubmitted = json.decode(load_arr);
	end
end

local function storeGetItem(item_id)
	-- print("_storeGetItem:", item_id);
	local item_obj = eliteShop:getItem(item_id);
	_G.save_obj.noads = true;
	-- print(item_obj.donate, _G.save_obj.donation);
	if(item_obj.donate)then
		if(_G.save_obj.donation==nil)then
			_G.save_obj.donation = item_obj.donate;
		else
			_G.save_obj.donation = math.max(_G.save_obj.donation, item_obj.donate);
		end
	end
	
	if(item_obj.hammers)then
		if(save_obj.hammers==nil)then save_obj.hammers=0; end
		save_obj.hammers = save_obj.hammers + item_obj.hammers;
	end
	if(item_obj.diamonds)then
		save_obj.diamonds = save_obj.diamonds + item_obj.diamonds;
	end
	
	if(item_obj.rich)then
		if(save_obj.rich==nil)then save_obj.rich=0; end
		save_obj.rich = math.max(save_obj.rich, item_obj.rich);
		
		if(save_obj.rich==1)then login_obj.relics["Rich"] = true; end
		if(save_obj.rich==2)then login_obj.relics["Richer"] = true; end
	end
	
	saveGame();
end
eliteShop:buyHandlerSet(storeGetItem);
eliteShop:setAutoShop();

local effect = require("eliteShaderMulti");
graphics.defineEffect(effect);


function royal:addLangListener(act)
	if(royal.langs == nil)then
		royal.langs = {};
	end
	table.insert(royal.langs, act);
end
function royal:exeLangListeners()
	if(royal.langs)then
		for i=1,#royal.langs do
			royal.langs[i]();
		end
	end
end

royal.show_wnd_question = function(tar_mc, buttons, txt_arr, callback, onClose, _bgW)
	if(tar_mc._msg_bol)then
		if(tar_mc.wnd)then
			if(tar_mc.wnd.removeSelf)then
				tar_mc.wnd:removeSelf();
			end
		end
	end
	local txt_mc;
	local msg_mc = newGroup(tar_mc);
	local bg_w, bg_h = _bgW or 250*scaleGraphics, 90*scaleGraphics;
	
	local title_str = table.remove(txt_arr, 1);
	
	if(#txt_arr>0)then
		txt_mc = eliteText:newText(table.concat(txt_arr, "%e"), bg_w - 20*scaleGraphics, 14*scaleGraphics, false, true);
		txt_mc.x, txt_mc.y = (bg_w - txt_mc.w)/2, 20*scaleGraphics;
		msg_mc:insert(txt_mc);
		bg_h = bg_h + txt_mc.h;
	end
	
	local rect = display.newRect(msg_mc, 0, 0, _W*2, _H*2);
	rect:setFillColor(0,0,0,0.7);
	
	local background = display.newGroup();
	local bg_fill = display.newRect(background, 13, 13, bg_w-13*2, bg_h-13*2);
	bg_fill.x, bg_fill.y = 13+bg_fill.width/2, 13+bg_fill.height/2;
	bg_fill:setFillColor(0, 0, 0);
	
	local border_mc = add_bg("bg_in", bg_w, bg_h);
	background:insert(border_mc);
	msg_mc:insert(background);
	if(tar_mc.width==nil)then
		msg_mc.x, msg_mc.y = _W/2 - bg_w/2, _H/2 - bg_h/2;
	else
		msg_mc.x, msg_mc.y = tar_mc.width/2 - bg_w/2, tar_mc.height/2 - bg_h/2;
	end

	local text_sy = 14*scaleGraphics;
	local title_dtxt = display.newText("9999", 0, 0, fontMain, 16*scaleGraphics);
	title_dtxt.text = title_str;
	title_dtxt.x = bg_w/2;
	title_dtxt.y = text_sy;
	msg_mc:insert(title_dtxt);
	
	text_sy = text_sy + 10*scaleGraphics;

	if(txt_mc)then
		msg_mc:insert(txt_mc);
	end
	
	function msg_mc:setText(i, val)
		txt_arr[i] = val;
		txt_mc:removeSelf();
		txt_mc = eliteText:newText(table.concat(txt_arr, "%e"), bg_w - 20*scaleGraphics, 14*scaleGraphics, false, true);
		txt_mc.x, txt_mc.y = (bg_w - txt_mc.w)/2, 20*scaleGraphics;
		msg_mc:insert(txt_mc);
	end
	
	local ok_mc = require('eliteButton').new(tar_mc, buttons);
	if(options_console)then
		ok_mc:addBG("gfx/console/"..options_device.."/green.png");
		ok_mc.xScale, ok_mc.yScale = scaleGraphics/3, scaleGraphics/3;
	else
		ok_mc:addBG("image/button/ok.png");
		ok_mc.xScale, ok_mc.yScale = scaleGraphics/2, scaleGraphics/2;
	end
	ok_mc:adjust();
	
	local function closeMe()
		tar_mc._msg_bol = false;
		if(msg_mc.removeSelf and msg_mc.parent)then
			transition.to(msg_mc,{alpha=0, time=300, transition=easing.inQuad, onComplete=transitionRemoveSelfHandler})
		end
		tar_mc.wnd = nil;
	end
	
	ok_mc:addHint(get_txt('ok'))
	ok_mc.hint = get_txt('ok');
	ok_mc:addCallback(function()
		if(callback)then
			callback();
		end
		ok_mc.act = nil;
		closeMe();
	end);
	
	ok_mc.x = bg_w/2 - bg_w/4;
	ok_mc.y = bg_h - 20*scaleGraphics;
	msg_mc:insert(ok_mc);
	local can_ok
	if(callback)then
		can_ok = require('eliteButton').new(tar_mc, buttons);--display.newImage("image/button/cancel.png");
		if(options_console)then
			can_ok:addBG("gfx/console/"..options_device.."/red.png");
			can_ok.xScale, can_ok.yScale = scaleGraphics/3, scaleGraphics/3;
		else
			can_ok:addBG("image/button/cancel.png");
			can_ok.xScale, can_ok.yScale = scaleGraphics/2, scaleGraphics/2;
		end
		can_ok:addHint(get_txt('cancel'));
		can_ok.hint = get_txt('cancel');
		can_ok:addCallback(function()
			if(onClose)then
				onClose();
			end
			can_ok.act = nil;
			closeMe();
		end);
		
		can_ok.x = bg_w/2 + bg_w/4;
		can_ok.y = ok_mc.y;
		msg_mc:insert(can_ok);
		can_ok:adjust();
	else
		ok_mc.x = bg_w/2;
	end
	tar_mc._msg_bol = true;
	tar_mc.wnd = msg_mc;
	-- print("_tar_mc:", tar_mc, tar_mc.insert);
	tar_mc:insert(msg_mc);
	msg_mc.w, msg_mc.h = bg_w,bg_h;
	
	function msg_mc:addOption(id, act) -- Blue(x) button / restart icon
		local mc = require('eliteButton').new(tar_mc, buttons);
		if(options_console)then
			mc:addBG("gfx/console/"..options_device.."/blue.png");
			mc.xScale, mc.yScale = scaleGraphics/3, scaleGraphics/3;
		else
			mc:addBG("image/button/restart.png");
			mc.xScale, mc.yScale = scaleGraphics/2, scaleGraphics/2;
		end
		
		-- mc:addHint(get_txt('ok'))
		mc.hint = get_txt(id);
		mc:addCallback(function()
			act();
			closeMe();
		end);
		
		msg_mc.act_x = function()
			if(can_ok)then
				can_ok:act();
			end
		end
		
		mc.x = bg_w/2;
		mc.y = bg_h - 20*scaleGraphics;
		msg_mc:insert(mc);
	end
	
	if(options_console)then
		ok_mc.y = bg_h-24*scaleGraphics
		local ok_dtxt = display.newText(msg_mc, get_txt('ok'), 0, 30, fontMain, 10*scaleGraphics);
		ok_dtxt.x, ok_dtxt.y = ok_mc.x, ok_mc.y+18*scaleGraphics;
		if(callback and can_ok)then
			can_ok.y = ok_mc.y;
			local ok_dtxt = display.newText(msg_mc, get_txt('cancel'), 0, 30, fontMain, 10*scaleGraphics);
			ok_dtxt.x, ok_dtxt.y = can_ok.x, can_ok.y+18*scaleGraphics;
		end
	end
	
	msg_mc.act_a = function()
		ok_mc:act();
	end
	msg_mc.act_b = function()
		if(can_ok)then
			can_ok:act();
		end
	end
		
	msg_mc.x, msg_mc.y = _W/2 - msg_mc.w/2, _H/2 - msg_mc.h/2;
	return msg_mc
end

local function resizeHandler()
	_G.topY = 20*scaleGraphics;
	
	local function try()
		require("eliteScale").init();
	end
	
	if pcall(try) then
    else
		require("eliteScale").default();
    end
end
resizeHandler();

function _G.resizeForce()
	local scene_mc = director:getCurrHandler();
	if(scene_mc)then
		if(scene_mc.name=='start')then
			show_start();
		elseif(scene_mc.name=='menu')then
			show_menu();
		elseif(scene_mc.name=='end')then
			show_end();
		elseif(scene_mc.name=='rest')then
			show_rest();
		-- elseif(scene_mc.name=='shop')then
			-- show_shop();
		elseif(scene_mc.name=='battle')then
			scene_mc:remakeCards();
			scene_mc:resize();
			scene_mc:refreshDebugInfo();
		elseif(scene_mc.name=='more')then	
			show_more();
		elseif(scene_mc.name=='map')then
			show_map();
		else
			if(_W and _H)then
				show_msg('resized:'..tostring(_W)..'x'..tostring(_H));
			end
			show_msg('this screen dosent supporting resize - main menu or map does');
		end
	end
end
local function onResize(event)
	if(_W==display.contentWidth and _H==display.contentHeight)then
		print('already same size');
		return-- corona html5 does resize on "focusIn" event
	end
	resizeHandler();
	if(msgs_mc.remove_msg_by_string)then
		msgs_mc:remove_msg_by_string("resized");
		msgs_mc:remove_msg_by_string("screen");
	end
	resizeForce();
end

moregames_callback = function()
	show_menu();
end

royal:addLangListener(function(e)
	for attr,obj in pairs(pets) do 
		if(options_debug~=true)then
			-- summoned_frost="Sheeps Summoned"
			-- summoned_lightning=""
			-- local txt = get_txt("summoned_VAL"):gsub("VAL", get_txt(obj.scin));
			language:addCurWord("summoned_"..attr, get_txt("summoned_VAL"):gsub("VAL", get_txt(obj.scin)));
		end
	end
end);

_itemAchievement.highscoresIds = {};
	local highscoresIds = _itemAchievement.highscoresIds;
	function _itemAchievement:submitScore2(id, val)
		local table_id = _itemAchievement.highscoresIds[id];
		if(table_id)then
			_itemAchievement:submitScore(table_id, val);
		end
	end
	function _G.submitScoresExt(id, val)
		if(val)then
			local table_id = _itemAchievement.highscoresIds[id];
			-- print("submitScoresExt", id, val, table_id);
			if(table_id)then
				_itemAchievement:submitScore(table_id, val);
			end
		end
	end
	
	function _G.addLoginStat(id, val)--save_obj.stats
		if(val==nil)then val=1; end
		if(save_obj.stats==nil)then save_obj.stats={}; end
		if(save_obj.stats[id])then
			save_obj.stats[id] = save_obj.stats[id] + val;
		else
			save_obj.stats[id] = val;
		end
		submitScoresExt(id, save_obj.stats[id]);
		return save_obj.stats[id];
	end
	function _G.setLoginStat(id, val)
		if(save_obj.stats==nil)then save_obj.stats={}; end
		save_obj.stats[id] = val;
		submitScoresExt(id, save_obj.stats[id]);
	end
	function _G.getLoginStat(id)
		if(save_obj.stats==nil)then save_obj.stats={}; end
		return save_obj.stats[id] or 0;
	end
	
	function _G.setRunStat(id, val)
		id = "run_"..id;
		login_obj.stats[id] = val;
	end
	function _G.addRunStat(id, val)
		id = "run_"..id;
		if(val==nil)then val=1; end
		if(login_obj.stats[id])then
			login_obj.stats[id] = login_obj.stats[id] + val;
		else
			login_obj.stats[id] = val;
		end
	end
	function _G.getRunStat(id)
		id = "run_"..id;
		if(login_obj.stats[id]==nil)then login_obj.stats[id] = 0; end
		return login_obj.stats[id];
	end


local steps = {};
local function addStep(callback)
	table.insert(steps, callback);
end

addStep(function()
end);
addStep(function()
end);
addStep(function()
end);
addStep(function()
end);
addStep(function()
	require "eliteBugtracker";
end);
addStep(function()
	Runtime:addEventListener("resize", onResize);
end);
addStep(function()
	loadGame();
	if(_itemAchievement.ini)then
		_itemAchievement:ini();
	end
end);
addStep(function()
	if(save_obj.version/1<0.946)then
		local unlocked_heroes = 0;
		for i=1,#heroes do
			local hero_obj = heroes[i];
			if(save_obj.unlocks['hero_'..hero_obj.class])then
				unlocked_heroes = unlocked_heroes+1;
			end
			save_obj.unlocks['hero_'..hero_obj.class] = nil;
			local lvl = getLoginStat(hero_obj.class.."_lvl");
			_G.save_obj.diamonds = _G.save_obj.diamonds + math.floor(lvl/3);
		end
		if(unlocked_heroes==0)then
			_G.save_obj.diamonds = 1;
		end
		print("_unlocked_heroes:", unlocked_heroes);
	end
	print("__G.save_obj.diamonds:", _G.save_obj.diamonds)
end);	
addStep(function()
	display.setStatusBar(display.HiddenStatusBar);
	native.setProperty("androidSystemUiVisibility", "immersiveSticky");
	native.setProperty("preferredScreenEdgesDeferringSystemGestures", true);
end);
addStep(function()
	_G.units_xml = xml:loadFile('data/units.xml');
	_G.arts_xml = get_xml_by_cname(units_xml, 'arts');
end);
addStep(function()
	local moregames_mc = require("moreEliteGames.ScreenMore");
	if(options_moregames)then
		moregames_mc.loadMoreGamesXML();
	end
end);
addStep(function()
	eliteSoundsIns:add_sound('music_menu1', true);
	eliteSoundsIns:add_sound('music_menu2', true);
	
	eliteSoundsIns:add_sound('music_game1', true);
	eliteSoundsIns:add_sound('music_game2', true);
	eliteSoundsIns:add_sound('music_game3', true);
	eliteSoundsIns:add_sound('music_game4', true);
	eliteSoundsIns:add_sound('music_game5', true);
	
	eliteSoundsIns:add_sound('amb_rest', true);
	eliteSoundsIns:add_sound('amb_shop', true);
end);
addStep(function()
	eliteSoundsIns:add_sound('rest_brew');
	eliteSoundsIns:add_sound('rest_sleep');
	eliteSoundsIns:add_sound('rest_smith');
	
	eliteSoundsIns:add_sound('potion_self');
	eliteSoundsIns:add_sound('potion_enemy');
	eliteSoundsIns:add_sound('potion_enemies');
	
	eliteSoundsIns:add_sound('shop_buy_card');
	eliteSoundsIns:add_sound('shop_buy_potion');
	eliteSoundsIns:add_sound('shop_buy_relic');
	eliteSoundsIns:add_sound('shop_remove_card');
	
	eliteSoundsIns:add_sound('click_approve');
	eliteSoundsIns:add_pack('pack_click','click_approve');
end);
addStep(function()
	local function onSystem(evt)
		print("_evt.type1:", evt.type, _G.app_state);
		if(_G.suspended_obj==nil)then _G.suspended_obj={}; end
		_G.app_state = evt.type;
		if evt.type == "applicationStart" then

		elseif evt.type == "applicationExit" then
			Runtime:removeEventListener("system", onSystem);
			-- saveData();
		elseif evt.type == "applicationSuspend" then
			-- _G.suspended_obj['sound'] = eliteSoundsIns:getSoundBol();
			-- _G.suspended_obj['music'] = eliteSoundsIns:getMusicBol();
			-- eliteSoundsIns:setSoundBolTemp(false);
			-- eliteSoundsIns:setMusicBolTemp(false);
		elseif evt.type == "applicationResume" then
			-- eliteSoundsIns:setSoundBolTemp(_G.suspended_obj['sound']);
			-- eliteSoundsIns:setMusicBolTemp(_G.suspended_obj['music']);
			native.setProperty("androidSystemUiVisibility", "immersiveSticky");
		end
	end
	Runtime:addEventListener("system", onSystem);
end);
addStep(function()
	hide_loading();
end);
addStep(function()
	show_menu();
	royal:exeLangListeners();
end);

game_art.onLoad = function()
	-- for attr,obj in pairs(conditions) do
		-- if(card_obj[attr]~=nil and card_obj[attr]~=null and card_obj[attr]~=0)then
			-- if(extra_hints and card_obj[attr]~=0 and card_obj[attr]~=null)then
				-- table.insert(extra_hints, attr);
			-- end
			-- local val = card_obj[attr];
			-- if(multy)then
				-- val = val*multy;
			-- end
			-- local valRnd = card_obj[attr.."Rnd"];
			-- if(attr~="strNext")then
				-- local hint = getConditionDesc(attr, val, obj, valRnd);
				-- table.insert(desc_arr, hint);
			-- end
		-- end
		-- if(attr=="accuracy" or attr=="spike")then
			-- local val = card_obj[attr];
			-- print(attr);
			-- local hint = getConditionDesc(attr, "X", obj, nil, true);
			-- print(attr, hint);
		-- end
	-- end

	if(options_debug)then
		for i=1,#enemies do
			local enemy = enemies[i];
			if(enemy.scin)then
				if(get_txt_force(enemy.scin))then
				else
					show_msg('scin missing translation:'..enemy.scin);
				end
			else
				show_msg('enemy missing scin:'..enemy.tag);
			end
		end
	end
	
	-- table.insert(loading_steps, function()

		
	-- end);
	
	-- local function loadMusic()
	
		
	-- end
	-- local function loadSounds()
		
	-- end
	
	
	-- achievements
	-- 0
	-- build
	-- ""
	-- class
	-- ""
	-- score
	-- 0
	-- version
	-- 0
	
	-- db:put("scores", json.encode(obj), nil, function(event)
		-- print(event.isError, event.phase, event.response);
	-- end);
	
	

	
	
	-- _itemAchievement:addItemGCID(item_id, ios_id, google_id, steam_id, steam_lid)
	-- _G.TABLE_ID_SCORES, _G.TABLE_ID_PLAYERLVL, _G.TABLE_ID_BESTY, _G.TABLE_ID_ROOSETER, _G.TABLE_ID_GOLD = nil;-- submitScoresExt(TABLE_ID_GOLD, old_money+reward_money);
	if(optionsBuild == "ios")then
		-- _G.TABLE_ID_SCORES = "rh.scores";
		-- _G.TABLE_ID_GOLD = "rh.gold";
		-- _G.TABLE_ID_PLAYERLVL = "rh.level";
		highscoresIds.scores = "rbq.scores";
		highscoresIds.act = "rbq.act";
		highscoresIds.decksize = "rbq.decksize";--++
		
		highscoresIds.wins = "rbq.wins";--++
		highscoresIds.winsred = "rbq.winsred";
		highscoresIds.winsgreen = "rbq.winsgreen";
		highscoresIds.winsmech = "rbq.winsmech";
		highscoresIds.winsviolet = "rbq.winsviolet";
		highscoresIds.winsblood = "rbq.winsblood";
		highscoresIds.winsvoodoo = "rbq.winsvoodoo";
		highscoresIds.winsblue = "rbq.winsblue";
		highscoresIds.winsfire = "rbq.winsfire";
		
		highscoresIds.kills = "rbq.kills";--++
		highscoresIds.elites = "rbq.elites";--++
		highscoresIds.bosses = "rbq.bosses";--++
		highscoresIds.rests = "rbq.rests";--++
	end
	if(optionsBuild == "android")then
		highscoresIds.scores = "CgkItPeF_98XEAIQAQ";
		highscoresIds.act = "CgkItPeF_98XEAIQAg";--++
		highscoresIds.decksize = "CgkItPeF_98XEAIQAw";--++
		
		highscoresIds.wins = "CgkItPeF_98XEAIQBA";--++
		highscoresIds.winsred = "CgkItPeF_98XEAIQBQ";
		highscoresIds.winsgreen = "CgkItPeF_98XEAIQBg";
		highscoresIds.winsmech = "CgkItPeF_98XEAIQBw";
		highscoresIds.winsviolet = "CgkItPeF_98XEAIQDA";
		highscoresIds.winsblood = "CgkItPeF_98XEAIQCA";
		highscoresIds.winsvoodoo = "CgkItPeF_98XEAIQCw";
		highscoresIds.winsblue = "CgkItPeF_98XEAIQCQ";
		highscoresIds.winsfire = "CgkItPeF_98XEAIQCg";
		
		highscoresIds.kills = "CgkItPeF_98XEAIQDQ";--++
		highscoresIds.elites = "CgkItPeF_98XEAIQDg";--++
		highscoresIds.bosses = "CgkItPeF_98XEAIQEA";--++
		highscoresIds.rests = "CgkItPeF_98XEAIQDw";--++
	end
	if(optionsBuild == "win32")then
		highscoresIds.scores = "Scores";
		
		-- _G.TABLE_ID_SCORES = "Scores";
		-- _G.TABLE_ID_GOLD = "Gold";
		-- _G.TABLE_ID_PLAYERLVL = "CgkIzLiZ0cYXEAIQDg";
	end
	
	
	
	
	
	local events_msg_str = loadFile("data/lang_events_msg_en.tsv", system.ResourceDirectory);
	if(events_msg_str)then
		-- print("_events_msg_str:", events_msg_str);
		for line_str in events_msg_str:gmatch("[^\r\n]+") do
			local words = string_split(line_str, "	");
			
			if(words[1])then
				-- print(words[1]:sub(1, 1), table.concat(words, "|"))
				local first_letter = words[1]:sub(1, 1)
				if(first_letter and first_letter~="" and first_letter~="[")then
					-- print(table.concat(words, "|"))
					local id = words[1];
					local msg = words[2];
					for i=1,#events do
						local event = events[i];
						if(id:lower() == event.tag:lower() and event.msg==nil)then
							local event_id = get_name_id(event.tag);
							_G.language:addEnWord(event_id.."_msg", msg);
							event.msg = get_txt(event_id.."_msg")
						end
					end
				end
			end
			-- for word in line_str:gmatch("[^\t]+") do
				-- print(word)
			-- end
		end
	end
	
	
	

	
	
end

if(system.getInfo("environment")=="simulator")then
	show_msg("options: "..optionsBuild..", "..optionsPublisher..", "..optionsVersion..", steam:"..tostring(options_steam)..", "..scaleGraphics);
	if(_G.playerName==nil)then
		_G.playerName = "Debug";
	end
end

function royal.add_glow(tar, path, outline, color)
	local group=newGroup(tar);
	local outline = 1;
	for ix=-outline,outline do
		for iy=-outline,outline do
			local item_mc = display.newImage(group, path);
			if(not(ix==0 and iy==0))then
				if(item_mc)then
					item_mc.fill.effect = "filter.brightness";
					item_mc.fill.effect.intensity = 0.6;
					item_mc:setFillColor(color[1], color[2], color[3]);
					item_mc.x,item_mc.y = ix,iy;
				end
			end
		end
	end
	return group;
end
function royal:downloadTempCards(class)
	if(royal.forge==nil)then
		local firebase = require('firebase');
		royal.forge = firebase('https://cards-114b3.firebaseio.com/');
	end
	local query = '?orderBy="class"&equalTo="'..class..'"';--..'&limitToLast=200'
	local cards_updated = 0;
	local cards_new = 0;
	royal.forge:get("cardstemp/", query, function(event)
		if(event.isError)then
			print("Network error!");
		else
			print("_event.response:", event.response);
			local response = json.decode(event.response);
			if(response)then
				for tag,card_obj in pairs(response) do
					print(tag, card_obj);
					
					-- cards
					-- cards_indexes
	
					if(cards_indexes[tag])then
						cards_updated = cards_updated+1;
						
						for i=#cards,1,-1 do
							if(cards[i].tag == tag)then
								table.remove(cards, i);
							end
						end
						
						table.insert(cards, card_obj);
						cards_indexes[tag] = card_obj;
					else
						cards_new = cards_new+1;
						table.insert(cards, card_obj);
						cards_indexes[tag] = card_obj;
					end
				end
			end
		end
		show_msg("updated: "..cards_updated..", ".."new: "..cards_new);
	end);
end
function royal:uploadTempCards(class)
	if(royal.forge==nil)then
		local firebase = require('firebase');
		royal.forge = firebase('https://cards-114b3.firebaseio.com/');
	end
	local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
	local sobj = {uploaded=0};
	for i=1,#cards do
		local card_obj = cards[i];
		if(card_obj.class == class)then
			sobj.uploaded = sobj.uploaded+1;
			local data_json = json.encode(card_obj);
			royal.forge:put("cardstemp/"..card_obj.tag.."/", data_json, nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					
					print("event:", event.response);
					print("json:", json.decode(event.response));
					local response = json.decode(event.response);
				end
			end);
		end
	end
	show_msg('cards uploaded: '..tostring(sobj.uploaded));
end

if(#steps>0)then
	show_loading();
	local steps_max = #steps;
	
	
	local hpbar = elite.add_bar(loading_wnd, "gui/rm_bar2", _W/2, scaleGraphics/2, 0.1, 0.2, 0.9);
	hpbar.x, hpbar.y = _W/2, _H-30*scaleGraphics;

	if(hpbar.refresh)then
		hpbar:refresh((steps_max-#steps)/steps_max);
	end
	
	local function stepsHandler(e)
		if(#steps>0)then
			local step = table.remove(steps, 1);
			step();
			
			loading_set_text("");
			if(hpbar.refresh)then
				hpbar:refresh((steps_max-#steps)/steps_max);
			end
		else
			Runtime:removeEventListener("enterFrame", stepsHandler);
		end
	end
	Runtime:addEventListener("enterFrame", stepsHandler);
end

if((options_debug or options_cheats) and system.getInfo("environment")=="simulator")then
	profiling = require("eliteProfiling").new();
	profiling.x = _W-140;
	profiling.y = profiling.h/2;
end