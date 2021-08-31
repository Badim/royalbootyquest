module(..., package.seeall);

sides={}
table.insert(sides,'nw');
table.insert(sides,'w');
table.insert(sides,'sw');
table.insert(sides,'s');
table.insert(sides,'se');
table.insert(sides,'e');
table.insert(sides,'ne');
table.insert(sides,'n');
table.insert(sides,'nw');


function new()
	local st=getTimer();
	
	local ani_speed = 60;
	
	local art =  require("eliteDeltas").new();

	art.sets = {};
	art.list = {};
	art.links = {};
	art.decors = {};
	art.infos = {};
	art.byids = {};
	
	function _G.addGfxByID(tar, tx, ty, id, scale, hue, saturation)
		local item_obj = art.byids[id];
		if(scale==nil)then scale=1; end
		local mc = _G.addGfxEx(tar, tx, ty, item_obj.sprite_id, scale, hue, saturation);
		mc:setSequence(id);
		mc:play();
		
		if(item_obj.xfix)then
			mc.x = mc.x + item_obj.xfix*scale;
		end
		if(item_obj.yfix)then
			mc.y = mc.y + item_obj.yfix*scale;
		end
		
		return mc;
	end
	
	_G.missing_shaders = {};
	local _cached = {};
	function createImageShader(path, hue, saturate)
		local baseDir = system.ResourceDirectory;
		local filename = get_name_id(hue.."x"..saturate.."x"..path);
		-- print("createImageShader:", filename, _cached[filename]);
		if(_cached[filename])then
			return false;
		end
		local test;
		if(_cached[filename]==nil)then
			test = display.newImage("cache/"..filename, baseDir);
			if(test)then
				_cached[filename] = true;
				test:removeSelf();
				return false
			else
				_cached[filename] = false;
			end
		end
	
		local baseDir = system.DocumentsDirectory;
		local filename = get_name_id(hue.."x"..saturate.."x"..path);
		local test = display.newImage(filename, baseDir);
		if(test)then
			test:removeSelf();
			return false
		end
		
		local img = display.newImage(path);
		if(img==nil)then
			royal:reportBug("majestyArt77 missing base image: "..tostring(path));
		end
		img.fill.effect = "filter.hue";
		img.fill.effect.angle = hue;
		display.save(img, {filename=filename, baseDir=baseDir, captureOffscreenArea=true});
		img:removeSelf();
		
		local img = display.newImage(filename, baseDir);
		img.fill.effect = "filter.saturate";
		img.fill.effect.intensity = saturate;
		display.save(img, {filename=filename, baseDir=baseDir, captureOffscreenArea=true});
		img:removeSelf();
		
		-- local img = display.newImage(path);
		-- img.fill.effect = "filter.custom.eliteMulti";
		-- img.fill.effect.hue.angle = hue;
		-- img.fill.effect.saturate.intensity = saturate;		
		-- display.save(img, {filename=filename, baseDir=baseDir, captureOffscreenArea=true});
		-- img:removeSelf();
		return true
	end
	function _G.newShaderImage(tar, path, hue, saturation, force)
		if(force)then
			createImageShader(path, hue, saturation);
		end
		
		local fname = get_name_id(hue.."x"..saturation.."x"..path);
		
		-- print("newShaderImage", path, fname, _cached[path]);
		if(_cached[fname])then
			local img = display.newImage(tar, "cache/"..fname, system.ResourceDirectory);
			if(img)then
				return img;
			end
		end
		
		local img = display.newImage(tar, fname, system.DocumentsDirectory);
		if(img==nil)then
			img = display.newImage(tar, path, system.ResourceDirectory);
			print('MISSING:', fname);
			missing_shaders[fname] = {utype = "image", path=path, hue=hue, saturation=saturation};
		end
		return img;
	end
	function _G.addGfxEx(tar, _x, _y, _id, scale, hue, saturation)
		if(_x == nil or _y == nil)then
			print('addgfx - out of bounds', _x, _y, _id)
			return false;
		end
		if(scale==nil)then
			scale=1;
		end
		local item_obj = game_art.links[_id];
		-- print("addGfxEx:", item_obj, game_art.links, _id);
		-- local data = game_art.infos[_id]
		-- local image = graphics.newImageSheet('image/'.. _id..".png", data);
		local image = item_obj.image;
		if(hue or saturation)then
			local fname = get_name_id(_id.."_"..hue.."x"..saturation..".png");
			local newimage = graphics.newImageSheet(fname, system.DocumentsDirectory, game_art.infos[_id]);
			-- print("addGfxEx", image, _id.."_"..hue.."x"..saturation..".png")
			if(newimage)then
				image = newimage;
			else
				print('MISSING:', fname);
				missing_shaders[fname] = {utype = "atlas", id = _id, hue=hue, saturation=saturation};
			end
		end

		local mc = display.newSprite(image, item_obj.sequences);
		mc.xScale, mc.yScale = scale,scale;
		mc:setSequence(item_obj.id);
		mc:play();
		mc.x, mc.y = _x, _y;
		
		
		tar:insert(mc);
		return mc;
	end
	
	local sets_l = 0;
	local function crop_set_name(set_name,txt)
		txt = string_split(txt,'[\\/]+')[1]
		return string_split(txt,set_name..'_')[1];
	end
	local function check_move(txt)
		local txt_obj = string_split(txt,'_');
		if(txt_obj[1]=='go')then
			return 0;
		else
			return 1;
		end
	end
	function check_etxt(txt, tar_txt)
		local txt_obj = string_split(txt,'_');
		if(txt_obj[1]==tar_txt)then
			return true;
		else
			return false;
		end
	end

	local units_ani_speed = 90;
	function add(set_obj, set_name, last_set, set_start, set_l, xmirror)
		local last_set_obj = string_split(last_set,'_');
		local side_id = table.remove(last_set_obj, #last_set_obj);
		local group_id=table.concat(last_set_obj,"_");
		
		if(group_id=='super_attack' or last_set=='super_attack')then
			set_obj.super_attack = true;
		end
		if(group_id=='pause')then
			set_obj.pause_ani = true;
		end
		--if(side_id == 'w' or side_id == 'sw' or side_id == 's')then
		--	print(set_name, group_id, side_id);
		--end
		
		local sequenceData = {};
		sequenceData.name=last_set;
		sequenceData.xmirror = xmirror;
		sequenceData.start=set_start;
		sequenceData.count=set_l;
		if(check_etxt(last_set, "pause"))then
			sequenceData.time=units_ani_speed*set_l*1.9;	
		else
			sequenceData.time=units_ani_speed*set_l;	
		end
		sequenceData.loopCount = check_move(last_set);
		table.insert(set_obj.sequences, sequenceData);
		
		if(set_name=="renekton")then
			if(check_etxt(last_set, "idle"))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = "reload";
				local new_set_name = table.concat(txt_obj, "_");
				local sequenceData = {};
				sequenceData.name=new_set_name;
				sequenceData.xmirror = xmirror;
				sequenceData.start=set_start;
				sequenceData.count=1;
				sequenceData.time=units_ani_speed;	
				sequenceData.loopCount = check_move(last_set);
				table.insert(set_obj.sequences, sequenceData);
			end
		end
		
		if(set_name=="medusa" or set_name=="mermaid")then
			if(check_etxt(last_set, "go"))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = "reload";
				local new_set_name = table.concat(txt_obj, "_");
				local sequenceData = {};
				sequenceData.name=new_set_name;
				sequenceData.xmirror = xmirror;
				sequenceData.start=set_start;
				sequenceData.count=1;
				sequenceData.time=units_ani_speed;	
				sequenceData.loopCount = check_move(last_set);
				table.insert(set_obj.sequences, sequenceData);
			end
		elseif(set_name=="airgolem" or set_name=="airbow" or set_name=="airbow_blue" or set_name=="airsword" or set_name=="dragon" or set_name=="sandpriest" or set_name=="sandspear")then
			-- turning idle animation to reload for units that cant stand still
			set_obj.levitating = true;
			if(check_etxt(last_set, "idle"))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = "reload";
				local new_set_name = table.concat(txt_obj, "_");
				local sequenceData = {};
				sequenceData.name=new_set_name;
				sequenceData.start=set_start;
				sequenceData.xmirror = xmirror;
				sequenceData.count=set_l;
				sequenceData.time=units_ani_speed*set_l;	
				sequenceData.loopCount=0;
				table.insert(set_obj.sequences, sequenceData);
			end
		else
			if(last_set ~= 'attack')then
				if(check_etxt(last_set, "attack"))then
					local txt_obj = string_split(last_set, '_');
					txt_obj[1] = "reload";
					local new_set_name = table.concat(txt_obj, "_");
					local sequenceData = {};
					sequenceData.name=new_set_name;
					sequenceData.xmirror = xmirror;
					sequenceData.start=set_start;
					sequenceData.count=1;
					sequenceData.time=units_ani_speed;	
					sequenceData.loopCount = check_move(last_set);
					table.insert(set_obj.sequences, sequenceData);
				end
			end
		end
		
		if(last_set=='attack' or last_set=='muz' or last_set=='super_attack' or last_set=='death' or last_set=='go' or last_set=='mutationin' or last_set=='mutationout'
		or last_set=='going' or last_set=='start' or last_set=='stop' or last_set=='fly')then
			for i=1,#sides do
				local sequenceData = {};
				sequenceData.name=last_set.."_"..sides[i];
				sequenceData.xmirror = xmirror;
				sequenceData.start=set_start;
				sequenceData.count=set_l;
				sequenceData.time=units_ani_speed*set_l;	
				sequenceData.loopCount = check_move(last_set);
				table.insert(set_obj.sequences, sequenceData);
			end
		end

		if(check_etxt(last_set, "death"))then
			local txt_obj = string_split(last_set, '_');
			txt_obj[1] = "deathbody";
			local new_set_name = table.concat(txt_obj, "_");
		end
	end
	
	--local tasks = {};
	function art:setCloneAni(set_name, original_name, cloned_name)
		local set_obj = art.sets[set_name];
		--set_obj.sequences, sequenceData
		--print("_setCloneAni:", #set_obj.sequences, original_name, cloned_name);
		for i=1,#set_obj.sequences do
			local sequenceData = set_obj.sequences[i];
			local last_set = sequenceData.name;
			
			if(check_etxt(last_set, original_name))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = cloned_name;
				local new_set_name = table.concat(txt_obj, "_");
				--print("__setCloneAni:", #set_obj.sequences, last_set, new_set_name);
				local sequenceDataNew = {};
				sequenceDataNew.name=new_set_name;
				sequenceDataNew.start=sequenceData.start;
				sequenceDataNew.count=sequenceData.count;
				sequenceDataNew.time=sequenceData.time;	
				sequenceDataNew.loopCount = sequenceData.loopCount;
				table.insert(set_obj.sequences, sequenceDataNew);
			end
		end
	end
	
	-- http://theelitegames.net/html5/royalbootyquest/image/units/
	local sprites_list = {};
	local loading_list = {};
	art.loading_list = loading_list;
	function art:loading_bol()
		for attr,val in pairs(loading_list) do
			return true
		end
		return false
	end
	
	function art:releaseArt()
		for i=1,#art.list do
			local set_obj = art.list[i];
			if(set_obj.image)then
				set_obj.image = nil;
			end
		end
	end
	
	function art:loadDataByObj(set_obj)
		art:loadDataEx(set_obj, set_obj.sprite_id, set_obj.atlas_id);
	end
	
	function art:getSpriteImage(set_name, atl_name)
		local sheetInfo = require('image.units.'..atl_name);
		local data = sheetInfo:getSheet();
		
		local fname = 'image/units/'..set_name..".png";
		local file_name_arr = string_split(fname, "/");
		local file_name = table.concat(file_name_arr, "_");
		return graphics.newImageSheet(fname, data);
	end
	
	function art:loadDataEx(set_obj, set_name, atl_name)
		local sheetInfo = require('image.units.'..atl_name);
		local data = sheetInfo:getSheet();
		
		local fname = 'image/units/'..set_name..".png";
		-- local file_name_arr = string_split(fname, "/");
		-- local file_name = table.concat(file_name_arr, "_");
		if(optionsBuild=="html5")then
			local file_name = "unit_sprite_"..set_name..".png";
			if(sprites_list[set_name]==nil)then
				local sprite_obj = {};
				sprite_obj.path = file_name;
				sprite_obj.dir = system.DocumentsDirectory;
				sprites_list[set_name] = sprite_obj;
				
				local img = display.newImage(sprite_obj.path, sprite_obj.dir);
				if(img)then
					img:removeSelf();
				else
					if(loading_list[set_name])then return; end
					local function networkListener(e)
						if (e.isError) then
							show_msg('error: '..tostring(e.isError));
						else
							print('loaded: '..set_name);
						end
						loading_list[set_name] = nil;
					end
					local url;
					if(system.getInfo("environment")=="simulator")then
						url = "http://theelitegames.net/html5/royalbootyquest/image/units/"..set_name..".png"; -- my server =(
					else
						url = "image/units/"..set_name..".png"; -- local =)
					end
					network.download(url, "GET", networkListener, sprite_obj.path, sprite_obj.dir);
					loading_list[set_name] = true;
				end
			end

			local sprite_obj = sprites_list[set_name];
			set_obj.image = graphics.newImageSheet(sprite_obj.path, sprite_obj.dir, data);
		else
			set_obj.image = graphics.newImageSheet(fname, data);
		end
		
		if(set_obj.data_parsed)then
			return
		end
		
		if(#set_obj.sequences<1)then
			for key,value in pairs(sheetInfo.frameIndex) do
				data.frames[value].name = key;
			end
			
			local next_set = nil;
			local last_set = nil;
			local new_set = false;
			local set_l = 0;
			local set_start = 0;
			
			for i=1,#data.frames do
				new_set = false;
				local frame_name = data.frames[i].name;
				next_set = crop_set_name(atl_name, frame_name);
				if(next_set ~= last_set)then
					if(last_set)then
						add(set_obj, atl_name, last_set, set_start, set_l);
					end
					new_set = true;
					set_start = i;
					last_set = next_set;
					set_l =0;
				end
				set_l = set_l +1;
			end
			if(last_set)then
				add(set_obj, set_name, last_set, set_start, set_l);
			end
		end
		
		set_obj.data_parsed = true;
	end
	
	function art:newImage(par, file_name, x, y)
		local new_name = file_name:gsub("/", "_");
		print("_file_name:", new_name);
		local img = display.newImage(new_name, system.DocumentsDirectory);
		local function super()
			if(par.insert)then
				par:insert(img);
				if(x~=nil and y~=nil)then
					img:translate(x, y);
				end
			end
		end
		if(img)then
			super();
			return img;
		else
			local url;
			if(system.getInfo("environment")=="simulator")then
				url = "http://theelitegames.net/html5/royalbootyquest/"..file_name; -- my server =(
			else
				url = file_name; -- local =)
			end
			local function networkListener(e)
				if (e.isError) then
					show_msg('error: '..tostring(e.isError));
				else
					print('loaded: '..file_name);
					img = display.newImage(new_name, system.DocumentsDirectory);
					super();
				end
			end
			network.download(url, "GET", networkListener, new_name, system.DocumentsDirectory);
		end
	end
	
	function art:loadDataOld(set_name)
		local set_obj = art.sets[set_name];
		-- local sprite_id = set_obj.sprite_id;
		
		local sprite_path = 'image/units/'..set_name..".png";
		if(sprites_list[set_name]==nil)then
			local sprite_obj = {path=sprite_path, dir=nil};
			
			if(sprites_list[set_name]==nil)then
				local img = display.newImage(sprite_path);
				if(img)then
					img:removeSelf();
					sprites_list[set_name] = sprite_obj;
				end
			end
			
			local file_name = "unit_sprite_"..set_name..".png";
			if(sprites_list[set_name]==nil)then
				local img = display.newImage(file_name, system.DocumentsDirectory);--system.TemporaryDirectory
				if(img)then
					sprite_obj.path = file_name;
					sprite_obj.dir = system.DocumentsDirectory;
					img:removeSelf();
					sprites_list[set_name] = sprite_obj;
				end
			end
			if(sprites_list[set_name]==nil)then
				if(optionsBuild=="html5")then
					if(loading_list[set_name])then return; end
					local function networkListener(e)
						if (e.isError) then
							show_msg('error: '..tostring(e.isError));
						else
							print('loaded: '..set_name);
						end
						loading_list[set_name] = nil;
					end
					local url;
					if(system.getInfo("environment")=="simulator")then
						url = "http://theelitegames.net/html5/royalbootyquest/image/units/"..set_name..".png"; -- my server =(
					else
						url = "image/units/"..set_name..".png"; -- local =)
					end
					network.download(url, "GET", networkListener, file_name, system.DocumentsDirectory);
					loading_list[set_name] = true;
					return
				else
					show_msg('ERROR:missing textures is only for HTML5 build');
				end
			end
		end
		
		local sheetInfo = require('image.units.'..set_name);
		local data = sheetInfo:getSheet();
		
		local sprite_obj = sprites_list[set_name];
		if(sprite_obj.dir)then
			set_obj.image = graphics.newImageSheet(sprite_obj.path, sprite_obj.dir, data);
		else
			set_obj.image = graphics.newImageSheet(sprite_obj.path, data);
		end
		
		if(#set_obj.sequences<1)then
			for key,value in pairs(sheetInfo.frameIndex) do
				data.frames[value].name = key;
			end
			
			local next_set = nil;
			local last_set = nil;
			local new_set = false;
			local set_l = 0;
			local set_start = 0;
			
			for i=1,#data.frames do
				new_set = false;
				local frame_name = data.frames[i].name;
				next_set = crop_set_name(set_name,frame_name);
				if(next_set ~= last_set)then
					if(last_set)then
						add(set_obj, set_name, last_set, set_start, set_l, 1);
					end
					new_set = true;
					set_start = i;
					last_set = next_set;
					set_l =0;
				end
				set_l = set_l +1;
			end
			if(last_set)then
				add(set_obj, set_name, last_set, set_start, set_l, 1);
			end
		end
		
		--if(set_name == "mag_evil")then
		--	art:setCloneAni("mag_evil","idle","pause");
		--end
		if(set_obj.pause_ani ~= true)then
			art:setCloneAni(set_name,"idle","pause");
			set_obj.pause_ani = true;
		end
		--show_msg(get_txt(set_name)..' loaded.')
	end
	

	
	local UNIT_SMALL_SIZE = 16;
	local UNIT_STANDART_SIZE=20;
	local UNIT_STANDART_HUGE=30;
	
	local RANGE_MEELE = 30;
	local RANGE_MAGIC = 180;
	local RANGE_ARROW = 210;
	
	local SPEED_VERY_SLOW = 8;
	local SPEED_SLOW = 10;
	local SPEED_NORMAL = 12;
	local SPEED_FAST = 14;
	local SPEED_VERY_FAST = 16;
	
	function iniSet(set_name)
		sets_l = sets_l +1;
		
		local set_obj = {}
		set_obj.sequences = {};
		set_obj.id = set_name;
		set_obj.sprite_id = set_name;
		set_obj.atlas_id = set_name;
		
		set_obj.dmg = 0;
		set_obj.dr = 0;
		set_obj.chain = 1;
		set_obj.dmg_type = DAMAGE_TYPE_PHYSIC;
		set_obj.lvl=1;
		set_obj.align=ALIGN_NEIT;
		set_obj.r = UNIT_SMALL_SIZE;
		set_obj.s = SPEED_SLOW;
		set_obj.col_r=UNIT_SMALL_SIZE;
		set_obj.hp = 100;
		set_obj.cost = 10;
		set_obj.weapon_type="monster_stuff";
		set_obj.armor_type="monster_def";
		set_obj.shadow = "shadow_mid";
		
		set_obj.dmg_crit_c=0;
		set_obj.dmg_crit_v=150;
		set_obj.stun_c = 0;
		set_obj.stun_v = 2000;
		set_obj.armorreducion = 0;
		
		set_obj.lvl = 0;
		set_obj.aoe = 0;
		set_obj.finisher = 0;--extra % to units under 50%
		set_obj.magic_dmg = 0;--extra magic dmg
		set_obj.true_dmg=0;
		set_obj.vamp = 0;
		set_obj.destroyer = 100;--damage to building
		set_obj.giant_slayer = 1; --100% damage to giants
		set_obj.limit = 0;
		set_obj.house = '';
		set_obj.limit_per_house = 5;
		set_obj.regen = 0;
		set_obj.h = 50;
		set_obj.mana = 0;
		set_obj.poison_power = 0;
		set_obj.healing = 100;
		set_obj.armor = 0;
		set_obj.dodge = 0;
		set_obj.resist = 0;
		set_obj.survival = false; -- if unit should die - he ll tele to castle and lost his survival
		set_obj.repair = 0;
		set_obj.spells = {};
		set_obj.class = 0;--0-none, 1-warrior, 2-ranged, 3-mage, 4-creature, 5-healer
		
		set_obj._passive = false;
		
		art.sets[set_name] = set_obj
		table.insert(art.list, set_obj);
		
		return art.sets[set_name];
	end
	

	
	local unit_id = 1;
	function setStats(mc,align,lvl,dmg,r,s,hp,col_r,weapon_type,armor_type,cost)
		mc.uid = unit_id;
		mc.dmg = dmg;
		mc.dmg_type = DAMAGE_TYPE_PHYSIC;
		mc.lvl=lvl;
		mc.align=align;
		mc.r = r;
		mc.s = s;
		mc.col_r=col_r;
		mc.hp = hp;
		mc.cost = cost;
		mc.weapon_type=weapon_type;
		mc.armor_type=armor_type;

		unit_id=unit_id+1;
	end
	function setStatsEx(mc,offsetY,scale)
		mc.scale=scale;
	end
	
	local unit;
	
	unit = iniSet("giant_rat");
	setStats(unit, ALIGN_EVIL,0, 14, RANGE_MEELE, SPEED_FAST,70,UNIT_SMALL_SIZE,"monster_stuff","monster_def",400);
	setStatsEx(unit,0,1);
	unit.h = 30;
	unit.dodge = 35;
	unit._rush = true;
	unit._animal = true;
	
	unit = iniSet("skelet");
	setStats(unit, ALIGN_EVIL,1,20, RANGE_MEELE, SPEED_NORMAL,110,UNIT_STANDART_SIZE,"monster_stuff","monster_def",500);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("zombe");
	setStats(unit, ALIGN_EVIL,2,22, RANGE_MEELE, SPEED_VERY_SLOW,220,UNIT_STANDART_SIZE,"monster_stuff","monster_def",600);
	setStatsEx(unit,-20,1);
	unit._undead = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("spider");
	setStats(unit, ALIGN_EVIL,3,25, RANGE_MEELE, SPEED_FAST, 330, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 700);
	setStatsEx(unit,0,1);
	unit.poison_power = 5;
	unit.h = 40;
	unit._hunter = true;
	unit._animal = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("spiderling");
	setStats(unit, ALIGN_EVIL,3,25, RANGE_MEELE, SPEED_FAST, 330, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 700);
	setStatsEx(unit,0,1);
	unit.poison_power = 5;
	unit.h = 40;
	unit._hunter = true;
	unit._animal = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("vampire");
	setStats(unit, ALIGN_EVIL,4, 35, RANGE_MEELE*2, SPEED_NORMAL, 400,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 800);
	setStatsEx(unit,-20,1);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.resist = 30;
	unit._undead = true;
	unit.vamp = 50;
	
	
	unit = iniSet("medusa");
	setStatsEx(unit,-20,1);
	setStats(unit, ALIGN_EVIL,6, 32, RANGE_MEELE*1.1, SPEED_FAST, 440,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1400);
	unit.armor = 15;
	unit.resist = 40;
	unit.aoe = 360;
	unit._monster = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("garpy");
	setStatsEx(unit,-20,1);
	setStats(unit, ALIGN_EVIL,7, 64, RANGE_MEELE*1.5, SPEED_FAST, 460,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1100);
	unit.dodge = 40;
	unit._rush = true;
	unit._monster = true;
	unit.vamp = 30;
	unit.mana = 100;
	table.insert(unit.spells , "pull");
	unit.shadow = 'shadow_mid';
	
	
	unit = iniSet("goblin");
	setStats(unit, ALIGN_EVIL,3,30, RANGE_MEELE, SPEED_FAST,200,UNIT_STANDART_SIZE,"monster_stuff","monster_def",500);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 10;
	
	unit = iniSet("goblin_archer");
	setStats(unit, ALIGN_EVIL,3,20, RANGE_ARROW - 5, SPEED_FAST,90,UNIT_STANDART_SIZE,"monster_stuff","monster_def",650);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 20;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	
	unit = iniSet("goblin_shaman");
	setStats(unit, ALIGN_EVIL,4,30, RANGE_MAGIC, SPEED_NORMAL,230,UNIT_STANDART_SIZE,"monster_stuff","monster_def",750);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.dodge = 5;
	unit.resist = 35;
	unit.mana = 100;
	table.insert(unit.spells , "sheal");
	table.insert(unit.spells , "meteor");
	
	unit = iniSet("goblin_warrior");
	setStats(unit, ALIGN_EVIL,5,40, RANGE_MEELE, SPEED_NORMAL,320,UNIT_STANDART_SIZE,"monster_stuff","monster_def",800);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.armor = 20;
	unit.dodge = 5;
	
	unit = iniSet("tax_collector");
	setStats(unit, ALIGN_GOOD, 0, 0, RANGE_MEELE, SPEED_VERY_SLOW, 60, UNIT_STANDART_SIZE, "weapon_meele", "armor_mage", 300);
	unit._passive = true;
	unit._taxman = true;
	unit.reload = 5000;
	unit.limit = 1;
	unit.limit_per_house = 1;
	unit.house = 'castle';
	unit.class = 0;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("warrior");
	setStats(unit, ALIGN_GOOD,1, 20, RANGE_MEELE, SPEED_NORMAL,110,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",450);
	unit.armor = 10;
	unit.dodge = 0;
	unit.resist = 0;
	unit.limit = 8;
	unit.limit_per_house = 2;
	unit.house = 'castle';
	unit.class = CLASS_WARRIOR;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("paladin");
	setStats(unit, ALIGN_GOOD,3, 33, RANGE_MEELE, SPEED_FAST,195,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1250);
	unit._holy = true;
	unit.armor = 15;
	unit.dodge = 0;
	unit.resist = 10;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	--unit.mana = 150;
	--table.insert(unit.spells , "pull");
	unit.class = CLASS_WARRIOR;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("dwarrior");
	setStats(unit, ALIGN_GOOD,4, 30, RANGE_MEELE+10, SPEED_NORMAL,170,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1100);
	unit.armor = 10;
	unit.dodge = 10;
	unit.resist = 10;
	unit.aoe = 180;
	unit.damage_frame = 7;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.dmg_crit_c=0.2;
	unit.dmg_crit_v=150;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("ranger");
	setStats(unit, ALIGN_GOOD,1, 20, RANGE_ARROW, SPEED_FAST,85,UNIT_STANDART_SIZE,"weapon_bow","armor_ranger",350);
	unit._hunter=true;
	unit.armor = 5;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 3;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	--unit.bullet_trace = "spikes2";
	unit.bullet_speed = 5;
	unit.class = CLASS_RANGER;
	
	unit = iniSet("mag_blue");
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	
	unit = iniSet("mag_red");
	setStats(unit, ALIGN_GOOD,3, 50, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_red","armor_mage",1500);
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit_per_house = 2;
	unit.damage_frame = 11;
	unit.bullet_speed = 9;
	unit.bullet_art = "image/bullets/fireball.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "meteor");
	unit.class = CLASS_WIZARD;
	
	unit = iniSet("mag_black");
	local mag_black_sprites = unit['sprite'];
	setStats(unit, ALIGN_GOOD,4, 55, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_black","armor_mage",1750);
	unit.armor = 0;
	unit.dodge = 0;
	unit.resist = 30;
	unit.house = 'wizard_guild';
	unit.limit = 3;
	unit.limit_per_house = 0;
	unit.damage_frame = 11;
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.dmg_cast_self = "magic_drain_life_cast";
	unit.dmg_cast_tar = "magic_drain_life_target";
	unit.mana = 150;
	unit.vamp = 10;
	table.insert(unit.spells , "plague");
	unit.class = CLASS_WIZARD;
	
	unit = iniSet("gnom");
	setStats(unit, ALIGN_GOOD, 2, 25, RANGE_MEELE-5, SPEED_SLOW,120,UNIT_SMALL_SIZE,"weapon_meele","armor_meele", 500);
	unit.h = 40;
	unit.unlock = 900;
	unit.armor = 20;
	unit.dodge = 0;
	unit.resist = 40;
	unit.house = 'blacksmith';
	unit.destroyer = 200;
	unit.repair = 10;
	unit.giant_slayer = 2;
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("elf");
	setStats(unit, ALIGN_GOOD,3, 30, RANGE_ARROW+20, SPEED_VERY_FAST,75,UNIT_STANDART_SIZE,"weapon_bow","armor_mage",600);
	unit.dodge = 15;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 2;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_2.png";
	unit.bullet_speed = 6;
	unit.class = CLASS_RANGER;
	unit.dmg_crit_c=0.1;
	unit.dmg_crit_v=150;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("mag_evil");
	setStats(unit, ALIGN_EVIL, 5, 50, RANGE_MAGIC, SPEED_SLOW, 700, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 1000);
	setStatsEx(unit,-20, 1.2);
	--art.sets[unit['id']] = unit;
	--table.insert(art.list, unit);
	unit.boss = true;
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.armor = 10;
	unit.resist = 10;
	unit._undead = true;
	--unit.dmg_cast_self = "magic_drain_life_cast";
	--unit.dmg_cast_tar = "magic_drain_life_target";
	unit.vamp = 10;
	unit.mana = 200;
	table.insert(unit.spells , "plague");
	--table.insert(unit.spells , "revive");
	
	unit = iniSet("elf_evil");
	setStats(unit, ALIGN_EVIL, 9, 90, RANGE_ARROW+30, SPEED_VERY_FAST, 900,UNIT_STANDART_SIZE,"monster_stuff","monster_def",1200);
	unit._elf = true;
	unit.boss = true;
	unit.dodge = 50;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_2.png";
	unit.bullet_speed = 6;
	unit.mana = 200;
	table.insert(unit.spells , "plague");
	unit.shadow = 'shadow_mid';
	--table.insert(unit.spells , "revive");
	
	unit = iniSet("warrior_defender");
	setStats(unit, ALIGN_GOOD,5, 30, RANGE_MEELE, SPEED_NORMAL,210,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",700);
	unit.armor = 25;
	unit.dodge = 0;
	unit.resist = 15;
	unit.limit = 0;	
	unit.gold=9999;
	unit.class = CLASS_WARRIOR;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("minotaur");
	setStats(unit, ALIGN_EVIL,10, 100, RANGE_MEELE*1.5, SPEED_SLOW, 1300,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1600);
	unit.h = 60;
	unit.armor = 70;
	unit.aoe = 90;
	unit.destroyer = 400;
	unit._giant = true;
	unit._monster = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("orc_beast");
	setStats(unit, ALIGN_EVIL,10, 100, RANGE_MEELE*1.5, SPEED_SLOW, 1300,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1600);
	unit.h = 60;
	unit.armor = 70;
	unit.aoe = 90;
	unit.destroyer = 400;
	unit._giant = true;
	unit._monster = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("trol");
	setStats(unit, ALIGN_EVIL,12, 90, RANGE_MEELE*1.5, SPEED_SLOW, 1400,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1800);
	unit.h = 80;
	unit.regen = 5;
	unit.armor = 10;
	unit.resist = 30;
	unit._giant = true;
	unit._monster = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("mag_white");
	setStats(unit, ALIGN_GOOD,5, 50, RANGE_MAGIC*1.1, SPEED_SLOW, 120,UNIT_STANDART_SIZE,"staff_air","armor_mage",1500);
	unit.dodge = 35;
	--unit.house = 'wizard_guild';
	unit.limit = 0;
	unit.limit_per_house = 0;
	unit.damage_frame = 11;
	unit.bullet_speed = 24;
	--unit.bullet_art = "image/bullets/fireball.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.chain = 3;
	unit.mana = 250;
	table.insert(unit.spells , "morph");
	unit.class = CLASS_WIZARD;
	unit.gold=19999;
	
	unit = iniSet("barbarian");
	setStats(unit, ALIGN_GOOD,5, 50, RANGE_MEELE, SPEED_FAST, 260,UNIT_STANDART_SIZE,"weapon_meele","armor_no",1000);
	unit.dodge = 25;
	-- unit.house = 'warrior_guild';
	unit.damage_frame = 5;
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.dmg_crit_c=0.3;
	unit.dmg_crit_v=200;
	unit._barbar = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("bastard");
	setStats(unit, ALIGN_GOOD,5, 50, RANGE_MEELE, SPEED_FAST, 260,UNIT_STANDART_SIZE,"weapon_meele","armor_no",1000);
	unit.dodge = 25;
	unit.house = 'warrior_guild';
	unit.damage_frame = 5;
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.dmg_crit_c=0.3;
	unit.dmg_crit_v=200;
	unit._barbar = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("highelf");
	setStats(unit, ALIGN_GOOD,3, 36, RANGE_MEELE+10, SPEED_VERY_FAST,75,UNIT_STANDART_SIZE,"weapon_meele","armor_mage",700);
	unit.dodge = 30;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 4;
	--unit.damage_frame = 5;
	--unit.bullet_art = "image/bullets/arrow_2.png";
	--unit.bullet_speed = 6;
	unit.class = CLASS_WARRIOR;
	unit.dmg_crit_c=0.1;
	unit.dmg_crit_v=150;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("orc");
	setStats(unit, ALIGN_EVIL,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"monster_stuff","monster_def",900);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.armor = 40;
	
	unit = iniSet("goblin_sniper");
	setStats(unit, ALIGN_EVIL,4,25, RANGE_ARROW - 5, SPEED_FAST, 100,UNIT_STANDART_SIZE,"monster_stuff","monster_def",700);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 25;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_3.png";
	unit.bullet_speed = 6;
	unit.dmg_crit_c=0.1;
	unit.dmg_crit_v=150;
	
	unit = iniSet("dubolom");
	setStats(unit, ALIGN_EVIL, 14, 90, RANGE_MEELE, SPEED_VERY_SLOW, 3000, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 1800);
	unit.h = 80;
	unit.regen = 1;
	unit.armor = 99;
	unit._giant = true;
	unit._boss = true;
	
	unit = iniSet("knightarcher");
	setStats(unit, ALIGN_GOOD,2, 26, RANGE_ARROW+10, SPEED_NORMAL, 100,UNIT_STANDART_SIZE,"weapon_bow","armor_meele",500);
	unit.unlock = 1750;
	unit.armor = 8;
	unit.class = CLASS_RANGER;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	unit.house = 'castle';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.dmg_crit_c=0.08;
	unit.dmg_crit_v=140;
	unit.shadow = 'shadow_mid';
	
	-- unit = iniSet("bastard");
	-- setStats(unit, ALIGN_GOOD,5, 60, RANGE_MEELE, SPEED_FAST, 280,UNIT_STANDART_SIZE,"weapon_meele","armor_no",1000);
	-- unit.dodge = 25;
	--unit.house = 'warrior_guild';
	-- unit.damage_frame = 5;
	-- unit.limit = 0;
	-- unit.limit_per_house = 0;
	-- unit.class = CLASS_WARRIOR;
	-- unit.dmg_crit_c=0.3;
	-- unit.dmg_crit_v=225;
	-- unit.gold=19999;
	
	unit = iniSet("genie");
	setStats(unit, ALIGN_GOOD,5,50, RANGE_MAGIC-10, SPEED_NORMAL,160,UNIT_STANDART_SIZE,"staff_black","armor_no",900);
	unit.h = 60;
	unit.resist = 50;
	unit.dodge = 10;
	setStatsEx(unit,-20,1);
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/green.png";
	unit.bullet_speed = 4;
	unit.mana = 200;
	table.insert(unit.spells , "mass_resist");
	unit.gold = 29999;
	unit.limit = 0;
	unit.limit_per_house = 0;
	unit.class = CLASS_WIZARD;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("dragon");
	setStats(unit, ALIGN_EVIL, 15, 150, RANGE_MEELE*2, SPEED_VERY_SLOW, 9000, UNIT_STANDART_HUGE,"monster_stuff","monster_def", 5000);
	unit.h = 140;
	unit.regen = 1;
	unit.armor = 100;
	unit.resist = 100;
	unit._giant = true;
	unit._boss = true;
	--unit._monster = true;
	--unit.bullet_art = "image/bullets/green.png";
	--unit.bullet_speed = 4;
	unit.dmg_cast_self_ex = 'meteor';--_dmg_cast_self_ex
	--unit.damage_frame = 5;
	
	unit = iniSet("witch");
	setStats(unit, ALIGN_EVIL,10, 110, RANGE_MEELE, SPEED_NORMAL, 900,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 900);
	setStatsEx(unit,-20,1);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.resist = 190;
	unit._undead = true;
	unit.damage_frame = 5;
	unit.vamp = 10;
	unit.aoe = 180;
	unit.mana = 200;
	table.insert(unit.spells , "quake");
	table.insert(unit.spells , "srevive");
	unit.class = CLASS_WIZARD;
	unit.shadow = 'shadow_mid';
	unit.fly = true;
	
	unit = iniSet("skeletarcher");
	setStats(unit, ALIGN_EVIL, 3, 25, RANGE_ARROW-10, SPEED_NORMAL, 110, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 300);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	unit.class = CLASS_RANGER;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("skeletwarrior");
	setStats(unit, ALIGN_EVIL, 5, 30, RANGE_MEELE, SPEED_NORMAL, 250,UNIT_STANDART_SIZE,"monster_stuff","monster_def",400);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.shadow = 'shadow_mid';
		
	unit = iniSet("succubus");
	setStats(unit, ALIGN_GOOD, 5, 36, RANGE_MAGIC, SPEED_NORMAL,140, UNIT_STANDART_SIZE ,"staff_black", "armor_mage", 900);
	setStatsEx(unit,-20,1);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.shadow = 'shadow_mid';
	unit.resist = 66;
	unit.damage_frame = 5;
	unit.dr = 64;
	unit.mana = 200;
	table.insert(unit.spells , "push");
	unit.iap = 'hero_succubus';
	unit.limit = 0;
	unit.limit_per_house = 0;
	unit.class = CLASS_WIZARD;
	unit.vamp = 3;
	unit.dmg_cast_tar = "magic_energy_blast_target_front";
	
	unit = iniSet("ent");
	setStats(unit, ALIGN_EVIL,6, 95, RANGE_ARROW+10, SPEED_VERY_SLOW, 4000,UNIT_STANDART_SIZE,"monster_stuff","monster_def",5000);
	setStatsEx(unit,-20,1);
	unit.shadow = 'shadow_big';
	unit.h = 80;
	unit._giant = true;
	unit._boss = true;
	unit.dmg_cast_tar = "spikes3";
	
	unit = iniSet("skeletmage");
	setStats(unit, ALIGN_EVIL, 5, 30, RANGE_MEELE, SPEED_NORMAL, 250,UNIT_STANDART_SIZE,"monster_stuff","monster_def",400);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.shadow = 'shadow_mid';
	
	-- if(options_debug)then
	unit = iniSet("airgolem");
	setStats(unit, ALIGN_EVIL, 15, 150, RANGE_MEELE*2, SPEED_SLOW, 5000,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 5000);
	unit.h = 160;
	unit.regen = 1;
	unit.armor = 100;
	unit.resist = 100;
	unit._giant = true;
	unit._boss = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("golem");
	setStats(unit, ALIGN_EVIL, 15, 150, RANGE_MEELE*2, SPEED_SLOW, 5000,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 5000);
	unit.h = 80;
	unit.regen = 1;
	unit.armor = 100;
	unit.resist = 100;
	unit._giant = true;
	unit._boss = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("sorcerer");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("knight");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_small';

	unit = iniSet("ninja");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("divine");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("kitana");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("fortune");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("scout");
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("mummy");
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("monkeyqueen");
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("wizardess");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("oathbreaker");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("shiva");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("sila");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';
	
	unit = iniSet("demon");--sorcerer
	setStats(unit, ALIGN_GOOD, 1, 6, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 11;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	unit.class = CLASS_HEALER;
	unit.shadow = 'shadow_chi';

	unit = iniSet("airbow");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("airbow_blue");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("airsword");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("sandpriest");
	unit.h = 60;
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("sandspear");
	unit.h = 60;
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("gnome_axe");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("gnome_sekira");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("gnome_range");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("gnome_mage");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("gnome_rifle");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("dragonheads1");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_huge';
	unit = iniSet("dragonheads2");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_huge';
	unit = iniSet("dragonheads3");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_huge';
	
	unit = iniSet("knightmace");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("warrior_mace");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("veigar");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MAGIC, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.house = 'castle';
	unit.shadow = 'shadow_big';
	unit.h = 80;
	unit._giant = true;
	unit._boss = true;

	
	unit = iniSet("knightspear");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("knightsword");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("renekton");
	setStats(unit, ALIGN_GOOD, 15, 150, RANGE_MEELE*1.1, SPEED_FAST, 5000,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 5000);
	unit.h = 76;
	unit.regen = 1;
	unit.armor = 100;
	unit.resist = 100;
	unit._giant = true;
	unit.house = 'castle';
	unit.shadow = 'shadow_big';
	

	
	unit = iniSet("pirate");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("goblin_axe");
	setStats(unit, ALIGN_GOOD,3,36, RANGE_MEELE, SPEED_FAST,210,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit.dodge = 10;
	unit.house = 'castle';
	
	unit = iniSet("goblin_elder");
	setStats(unit, ALIGN_GOOD,3,36, RANGE_MEELE, SPEED_FAST,210,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit.dodge = 10;
	unit.house = 'castle';
	
	unit = iniSet("goblin_shield");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	
	unit = iniSet("goblin_sword");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	
	unit = iniSet("mermaid");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	
	unit = iniSet("angel");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("amazon");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("bigsmith");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.house = 'castle';
	
	unit = iniSet("nasus");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-24,1);
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_big';
	
	unit = iniSet("azir");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-40,1);
	unit.h = 68;
	unit.armor = 40;
	unit.house = 'castle';
	unit.shadow = 'shadow_big';
	
	-- unit = iniSet("bastard");
	-- setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	-- setStatsEx(unit,-20,1);
	-- unit.armor = 40;
	-- unit.house = 'castle';
	-- unit._barbar = true;
	
	
	
	unit = iniSet("goblin_swords");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	
	unit = iniSet("archer");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("warrior_hero");
	setStats(unit, ALIGN_GOOD,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",900);
	setStatsEx(unit,-20,1);
	unit.armor = 40;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("mingmage");
	setStats(unit, ALIGN_GOOD,3,36, RANGE_MEELE, SPEED_FAST,210,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit.dodge = 10;
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("worker");
	setStats(unit, ALIGN_GOOD,3,36, RANGE_MEELE, SPEED_FAST,210,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit.house = 'castle';
	
	unit = iniSet("midsmith");
	setStats(unit, ALIGN_GOOD,3,36, RANGE_MEELE, SPEED_FAST,210,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit.house = 'castle';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("orc_heavy");
	setStats(unit, ALIGN_GOOD,3,36, RANGE_MEELE, SPEED_FAST,210,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit.house = 'castle';
	
	unit = iniSet("dwarriorshadow");
	setStats(unit, ALIGN_GOOD,4, 30, RANGE_MEELE+10, SPEED_NORMAL,170,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1100);
	unit.armor = 10;
	unit.dodge = 10;
	unit.resist = 10;
	unit.aoe = 180;
	unit.damage_frame = 7;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.dmg_crit_c=0.2;
	unit.dmg_crit_v=150;
	unit.shadow = 'shadow_mid';
	-- end
	
	unit = iniSet("sheep");
	unit.h = 20;
	unit._food = true;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("tornado");
	unit.h = 50;
	unit._food = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("fox");
	unit.h = 20;
	unit._food = true;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("rabbit");
	unit.h = 20;
	unit._food = true;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("ram");
	unit.h = 20;
	unit._food = true;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("magic_camouflage");
	unit.h = 30;
	unit._food = false;
	
	
	unit = iniSet("ram_red");
	unit.h = 12;
	unit._food = true;
	unit.sprite_id = "ram_red";
	unit.atlas_id = "ram";
	
	unit = iniSet("witch_red");
	unit.h = 50;
	unit.sprite_id = "witch_red";
	unit.atlas_id = "witch";
	
	unit = iniSet("vampire_red");
	-- unit.h = 50;
	unit.sprite_id = "vampire_red";
	unit.atlas_id = "vampire";
	
	unit = iniSet("elf_grey");
	-- unit.h = 50;
	unit.sprite_id = "elf_grey";
	unit.atlas_id = "elf";
	
	-- unit = art:iniSet("vampire_red");
	-- unit.sprite_id = "vampire_red";
	-- unit.atlas_id = "vampire";
	
	
	unit = iniSet("azir_recolor");
	unit.h = 68;
	unit.sprite_id = "azir_recolor";
	unit.atlas_id = "azir";
	
	
	
	
	

	local function add_decor_obj(set_name, image, last_set, set_start, set_l, animation_order,sequences)
		--print("_add_decor_obj:", set_name, last_set, set_start, set_l)
		local this_ani_speed = 90;
		local this_order = animation_order;
		if(last_set == 'money')then
			this_ani_speed = 30;
		end
		if(last_set == 'wave')then
			this_ani_speed = 60;
		end
		if(last_set=="storm_cloud")then
			this_ani_speed = 80;
			this_order = 0;
		end
		if(last_set=="green5" or last_set=="tree_green5")then
			this_order = 1;
		end
		if(last_set=="magic_control_undead_target_effect")then
			this_order = 0;
		end
		if(last_set=="magic_shieldOfLight_target_back" or last_set=="magic_shieldOfLight_target_front")then
			this_ani_speed = 80;
			this_order = 0;
		end
		if(last_set=="castle_rov")then
			this_ani_speed = 160;
		end
		
		if(last_set=="attack_over" or last_set=="attack_off")then
			this_ani_speed = 50;
		end

		if(art[set_name] == nil)then
			art[set_name] = {};
		end
		table.insert(art[set_name], last_set);
		
		local item_obj = {};
		item_obj.image = image;
		item_obj.sequences = sequences;
		item_obj.sprite_id = set_name;
		item_obj.id = last_set;
		art.links[set_name] = item_obj;
		art.byids[last_set] = item_obj;
		table.insert(art.decors, item_obj);
		
		local sequenceData = {};
		sequenceData.name=last_set;
		sequenceData.start=set_start;
		sequenceData.count=set_l;
		sequenceData.time=this_ani_speed*set_l;	
		sequenceData.loopCount = this_order;
		table.insert(sequences, sequenceData);
	end

	
	function art:add_decor(set_name, animation_order)
		local sheetInfo = require('image.'..set_name);
		local data = sheetInfo:getSheet();
		local image = graphics.newImageSheet('image/'.. set_name..".png", data);
		art.infos[set_name] = data;
		
		local sequences = {};
		
		for key,value in pairs(sheetInfo.frameIndex) do
			data.frames[value].name = key;
		end
			
		local next_set = nil;
		local last_set = nil;
		local new_set = false;
		local set_l = 0;
		local set_start = 0;
		
		for i=1,#data.frames do
			new_set = false;
			local frame_name = data.frames[i].name;
			--next_set = set_name..'_'..frame_name; candle1
			next_set = crop_set_name(set_name,frame_name);
			if(next_set ~= last_set)then
				if(last_set)then
					add_decor_obj(set_name, image, last_set, set_start, set_l, animation_order, sequences);
				end
				new_set = true;
				set_start = i;
				last_set = next_set;
				set_l =0;
			end
			set_l = set_l +1;
		end
		if(last_set)then
			add_decor_obj(set_name, image, last_set, set_start, set_l, animation_order, sequences);
		end
	end
	
	function art:load_decor()
		art:add_decor("decor", 0);
		art:add_decor("decor_2", 0);
		art:add_decor("decor_4", 0);
	end
	function art:load_gfx()
		art.byids["magic_drain_life_cast"].yfix = -60;
		art.byids["magic_drain_life_target"].yfix = -70;
		
		art.byids["magic_poison_cast"].yfix = -70;
		
		art.byids["blast"].yfix = -30;
		
		art.byids["nova_in"].yfix = -40;
		art.byids["nova_out"].back = true;
		art.byids["sword_fall"].yfix = -140;
		
		art.byids["magic_wither_cast_front"].xfix = 15;
		art.byids["magic_wither_cast_front"].yfix = -70;
		
		art.byids["magic_shieldOfLight_target_back"].yfix = -12;
		art.byids["magic_shieldOfLight_target_front"].yfix = 12;
		
		art.byids["magic_teleport_target"].yfix = -100;
		
		art.byids["levelup"].yfix = -100;
		
		art.byids["magic_resurection_target_back"].yfix = 0;
		art.byids["magic_resurection_target_front"].yfix = -98;
	end
	--------------------------------
	if(options_debug)then
		local data_str = '';
		local var_names_list = {};
		local var_names_str = "uid,id,sprite_id,dmg,vamp,dmg_type,aoe,lvl,align,r,s,limit,house,limit_per_house,col_r,h,hp,mana,poison_power,cost,weapon_type,armor_type,armor,dodge,resist,offsetX,offsetY";
		var_names_str = var_names_str..',bullet_speed,bullet_art,damage_frame,_rush,_taxman,_passive,_holy,_undead,_goblin,_animal,_hunter,dmg_cast_self,dmg_cast_tar';
		local var_names_arr = string_split(var_names_str, ",");
		for i=1,#art.list do
			local unit_obj = art.list[i];
			local unit_vars = "";
			for j=1,#var_names_arr do
				local var_str =var_names_arr[j];
				if(unit_obj[var_str])then
					local var_val = unit_obj[var_str];
					if(var_val == true)then
						var_val = '1';
					end
					if(var_val == false)then
						var_val = '0';
					end
					unit_vars=unit_vars..var_str.."='"..var_val.."' ";
				end
			end
			local spells_str = "";
			if(unit_obj['spells'])then
				for i=1,#unit_obj['spells'] do
					if(i>1)then
						spells_str=spells_str..",";
					end
					spells_str=spells_str..unit_obj['spells'][i];
				end
				if(#unit_obj['spells']>0)then
					unit_vars=unit_vars.."spells".."='"..spells_str.."' ";
				end
			end
			--print(unit_obj.id, unit_vars);
			unit_vars = '<unit '..unit_vars..' />\r';
			data_str = data_str..unit_vars;
		end
		data_str = '<units>\r'..data_str..'\r</units>';
		--------------------------------
		
		--------------------------------
		data_str = '<data>\r'..data_str..'\r</data>';
		saveFile('units_data.xml', data_str);
	end
	
	
	
	art.perks={};
	function art:load_perks()
		-- load_perks("data/royal_perks.txt");
	end
	
	local load_i = 0;
	
	
	local function loadHandler(evt)
		if(load_i == 0)then
			load_i = load_i+1;
			art:load_decor();
			return
		end
		
		if(load_i == 1)then
			load_i = load_i+1;
			art:load_deltas();
			return
		end
		
		if(load_i == 2)then
			load_i = load_i+1;
			art:load_perks();
			return
		end
		
		ani_speed = 60;
		
		if(load_i == 3)then
			load_i = load_i+1;
			art:add_decor("gfx_all", 1);
			art:add_decor("gfx_hh", 1);
			return
		end
		
		if(load_i == 4)then
			load_i = load_i+1;
			art:load_gfx()
			return
		end
		
		if(options_debug)then
			show_msg('loading art: '..math.floor(getTimer()-st)..'ms');
		end
		print('loading art: '..math.floor(getTimer()-st)..'ms');
		
		if(art.onLoad)then
			art:onLoad();
			art.onLoad = nil
		end
		
		Runtime:removeEventListener("enterFrame", loadHandler);
	end
	
	Runtime:addEventListener("enterFrame", loadHandler);
	
	--show_msg('loading art: '..math.floor(getTimer()-st)..'ms');
	
	return art;
end