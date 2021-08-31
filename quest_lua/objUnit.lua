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

function new(gType, gid, unit_obj, buttons)
	local unit_mc = require("objWarrior").new();
	unit_mc._type = gType;
	unit_mc._dead=false;
	unit_mc._hero=false;
	unit_mc._gid = gid;
	unit_mc.gid = gid;
	unit_mc._dir = 'n';
	unit_mc._thorns = 0;
	unit_mc._reload = 0;
	unit_mc._utype = 'unit';
	unit_mc.mtype = 'realunit';
	unit_mc._summoned = false;
	
	unit_mc._path = {};
	
	lvl_mc = nil;

	local unit_data = game_art.sets[unit_mc._type];
	unit_mc.unit_data = unit_data;
	local unit_deltas = game_art.deltas;
	unit_mc._air = false;
	
	function unit_mc:spriteSetXY(tx, ty)
		ty = ty-12;
		unit_mc._sprite_mc.x, unit_mc._sprite_mc.y = tx, ty;
		if(unit_mc._sprite_hair)then unit_mc._sprite_hair.x, unit_mc._sprite_hair.y = tx, ty; end
		if(unit_mc._sprite_scin)then unit_mc._sprite_scin.x, unit_mc._sprite_scin.y = tx, ty; end
		if(unit_mc._sprite_extra1)then unit_mc._sprite_extra1.x, unit_mc._sprite_extra1.y = tx, ty; end
		if(unit_mc._sprite_extra2)then unit_mc._sprite_extra2.x, unit_mc._sprite_extra2.y = tx, ty; end
		if(unit_mc._sprite_extra3)then unit_mc._sprite_extra3.x, unit_mc._sprite_extra3.y = tx, ty; end
	end
	function unit_mc:spriteSetScale(tx)
		unit_mc._sprite_mc.xScale = tx;
		if(unit_mc._sprite_hair)then unit_mc._sprite_hair.xScale = tx; end
		if(unit_mc._sprite_scin)then unit_mc._sprite_scin.xScale = tx; end
		if(unit_mc._sprite_extra1)then unit_mc._sprite_extra1.xScale = tx; end
		if(unit_mc._sprite_extra2)then unit_mc._sprite_extra2.xScale = tx; end
		if(unit_mc._sprite_extra3)then unit_mc._sprite_extra3.xScale = tx; end
	end
	function unit_mc:spriteSetSeq(id)
		if(unit_mc._sprite_mc.setSequence)then
			unit_mc._sprite_mc:setSequence(id);
		end
		if(unit_mc._sprite_mc.play)then
			unit_mc._sprite_mc:play();
		end
		if(unit_mc._sprite_hair)then unit_mc._sprite_hair:setSequence(id); unit_mc._sprite_hair:play(); end
		if(unit_mc._sprite_scin)then unit_mc._sprite_scin:setSequence(id); unit_mc._sprite_scin:play(); end
		if(unit_mc._sprite_extra1)then unit_mc._sprite_extra1:setSequence(id); unit_mc._sprite_extra1:play(); end
		if(unit_mc._sprite_extra2)then unit_mc._sprite_extra2:setSequence(id); unit_mc._sprite_extra2:play(); end
		if(unit_mc._sprite_extra3)then unit_mc._sprite_extra3:setSequence(id); unit_mc._sprite_extra3:play(); end
	end
	function unit_mc:spriteSetFrame(id)
		unit_mc._sprite_mc:setFrame(id);
		unit_mc._sprite_mc:play();
		if(unit_mc._sprite_hair)then unit_mc._sprite_hair:setFrame(id); unit_mc._sprite_hair:play(); end
		if(unit_mc._sprite_scin)then unit_mc._sprite_scin:setFrame(id); unit_mc._sprite_scin:play(); end
		if(unit_mc._sprite_extra1)then unit_mc._sprite_extra1:setFrame(id); unit_mc._sprite_extra1:play(); end
		if(unit_mc._sprite_extra2)then unit_mc._sprite_extra2:setFrame(id); unit_mc._sprite_extra2:play(); end
		if(unit_mc._sprite_extra3)then unit_mc._sprite_extra3:setFrame(id); unit_mc._sprite_extra3:play(); end
	end
	function unit_mc:getSprites()
		local list = {};
		table.insert(list, {id='base', mc=unit_mc._sprite_mc});
		if(unit_mc._sprite_scin)then table.insert(list, {id='scin', mc=unit_mc._sprite_scin}); end
		if(unit_mc._sprite_hair)then table.insert(list, {id='hair', mc=unit_mc._sprite_hair}); end
		if(unit_mc._sprite_extra1)then table.insert(list, {id='extra1', mc=unit_mc._sprite_extra1}); end
		if(unit_mc._sprite_extra2)then table.insert(list, {id='extra2', mc=unit_mc._sprite_extra2}); end
		if(unit_mc._sprite_extra3)then table.insert(list, {id='extra3', mc=unit_mc._sprite_extra3}); end
		return list;
	end
	function unit_mc:removeFilters()
		local list = unit_mc:getSprites();
		for i=1,#list do
			local item = list[i];
			-- if(filters[item.id])then
				local body_mc = item.mc;
				body_mc.fill.effect = nil;
				-- local arr = filters[item.id];
				-- for j=1,#arr do
					-- local prms = arr[j];
					-- body_mc.fill.effect[prms.prm1][prms.prm2] = prms.val;
				-- end
			-- end
		end
		unit_mc.filters = {};
	end
	function unit_mc:applyFilters(filters)
		local list = unit_mc:getSprites();
		for i=1,#list do
			local item = list[i];
			if(filters[item.id])then
				local body_mc = item.mc;
				body_mc.fill.effect = "filter.custom.eliteMulti";
				local arr = filters[item.id];
				for j=1,#arr do
					local prms = arr[j];
					body_mc.fill.effect[prms.prm1][prms.prm2] = prms.val;
				end
			end
		end
		unit_mc.filters = filters;
	end
	
	function unit_mc:setSS()
		pixelArtOn();
		if(unit_data.image == nil)then
			game_art:loadDataByObj(unit_data);
			if(unit_data.image == nil)then
				unit_mc._dead = true;
				return unit_mc
			end
		end
		-- print("ss2:", unit_data.image, unit_data.sequences);
		unit_mc._sprite_mc = display.newSprite(unit_data.image, unit_data.sequences);
		unit_mc:insert(unit_mc._sprite_mc);
		
		local set_name = unit_data.atlas_id;
		local sheetInfo = require('image.units.'..set_name);
		local data = sheetInfo:getSheet();
		
		local function trySprite(body_id)
			local attr_name = "_sprite_"..body_id;
			if(unit_data[attr_name]~=false)then
				local sprite_img = graphics.newImageSheet('image/units/'.. set_name.."_"..body_id..".png", data);
				if(sprite_img)then
					unit_mc[attr_name] = display.newSprite(sprite_img, unit_data.sequences);
					unit_mc:insert(unit_mc[attr_name]);
					unit_data[attr_name] = true;
				else
					unit_data[attr_name] = false;
				end
			end
		end
		trySprite("hair");
		trySprite("scin");
		trySprite("extra1");
		trySprite("extra2");
		trySprite("extra3");
		
		unit_mc:spriteSetXY(0, 0);
		if(options_debug)then
			local dark_mc = display.newRect(unit_mc, 0, -unit_mc._h/2, 12, unit_mc._h);
			dark_mc:setFillColor(0,191,255);
			dark_mc.alpha = 0.4;
			local dark_mc = display.newCircle(unit_mc, 0, 0, unit_mc._col_r);
			dark_mc:setFillColor(0,191,255);
			dark_mc.alpha = 0.4;
		end
		pixelArtOff();
	end
	
	-- function unit_mc:setSS()
		-- display.setDefault( "magTextureFilter", "nearest" );
		-- display.setDefault( "minTextureFilter", "nearest" );
		
		-- if(unit_data.image == nil)then
			-- game_art:loadDataByObj(unit_data);
			-- if(unit_data.image == nil)then
				-- unit_mc._dead = true;
				-- return unit_mc
			-- end
		-- end
		
		-- unit_mc._sprite_mc = display.newSprite(unit_data.image, unit_data.sequences);
		-- unit_mc._sprite_mc.x = 0;
		-- unit_mc._sprite_mc.y = 0;
		-- unit_mc:insert(unit_mc._sprite_mc);
		-- if(options_debug and false)then
			-- local dark_mc = display.newRect(unit_mc, 0, -unit_mc._h/2, 12, unit_mc._h);
			-- dark_mc:setFillColor(0,191,255);
			-- dark_mc.alpha = 0.4;
			-- local dark_mc = display.newCircle(unit_mc, 0, 0, unit_mc._col_r);
			-- dark_mc:setFillColor(0,191,255);
			-- dark_mc.alpha = 0.4;
		-- end
		
		-- display.setDefault( "magTextureFilter", "linear" );
		-- display.setDefault( "minTextureFilter", "linear" );
	-- end
	function unit_mc:getBody()
		return unit_mc._sprite_mc;
	end
	
	function unit_mc:getObj()
		return unit_obj;
	end
	
	--function unit_mc:getCenterPoint()
	--	return {x=unit_mc.x+unitOffsetX[unit_mc._type], y=unit_mc.y+unitOffsetY[unit_mc._type]}
	--end
	function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult;
	end
	function unit_mc:setDirByPath()
		if(#unit_mc._path>0)then
			if(unit_mc._path[1].x)then
				local dx = unit_mc._path[1].x - unit_mc.x;
				local dy = unit_mc._path[1].y - unit_mc.y;
				unit_mc:setDir(dx, dy)
			end
		end
	end
	local pi_half = math.pi/4;
	function unit_mc:setDir(dx, dy)
		local val=math.atan2(dx,dy);
		local side = 5+round(val/pi_half);
		--unit_mc._atan2 = math.atan2(dy,dx);
		unit_mc._dir =sides[side];
		unit_mc._side = side;
		unit_mc._adx = dx;
		unit_mc._ady = dy;
		unit_mc:refresSet();
	end
	
	function unit_mc:setAct(act)
		--idle go attack death muz
		if(act == "death")then
			if(unit_mc.name_dtxt)then
				unit_mc.name_dtxt:removeSelf();
				unit_mc.name_dtxt = nil;
			end
			if(unit_mc._stuned>0 or unit_mc._frozen>0)then
				unit_mc:turnCon(99999);
			end
		end
		
		if(unit_mc._stuned>0)then
			return false
		end
		
		-- if(unit_mc._dead or act == "death")then
			
		-- end
		
		if(unit_mc._morphing)then
			if(act == 'go')then
				if(unit_mc._act ~= 'going')then
					act = 'start';
				else
					act = 'going';
				end
			else
				if(unit_mc._act == 'going')then
					act = 'stop';
				end
			end
		end

		unit_mc._shooted = false;
		unit_mc._act = act;
		unit_mc:refresSet();
	end
	function unit_mc:attemptAttack(tar_mc, dx, dy)
		if(unit_mc._reload >0)then
			unit_mc:setAct('reload');
			return false;
		end
		unit_mc._reload = attack_reload_delay;
		unit_mc._tar = tar_mc;
		unit_mc:setDir(dx, dy);
		unit_mc:setAct('attack');
	end
	
	unit_mc.old_ani_set = '';
	function unit_mc:spritePlaying()
		if(unit_mc._sprite_mc==nil)then
			return false;
		end
		return unit_mc._sprite_mc.isPlaying;
	end
	if(unit_mc.zScale==nil)then
		unit_mc.zScale = 1;
	end
	function unit_mc:refresSet()
		if(unit_mc._dead or unit_mc.dead)then
			return
		end
		if(unit_mc._frozen>0 and unit_mc._act ~= "death")then
			return
		end
		if(unit_mc._act)then
			local new_ani_set = unit_mc._act.."_"..unit_mc._dir;
			if(unit_mc._act == 'attack' and unit_data.super_attack and (unit_mc._dmg_crit_ani or unit_mc._casted))then
				new_ani_set = 'super_attack'.."_"..unit_mc._dir;
				unit_mc._casted = false;
			end
			-- if(unit_mc._gtype=='farmer')then
				-- print("refresSet:", unit_mc.old_ani_set, new_ani_set);
			-- end
			if(unit_mc.old_ani_set == new_ani_set)then
				if(unit_mc._act == 'attack' or unit_mc:spritePlaying()==false)then
					-- unit_mc._sprite_mc:setFrame(1);
					-- unit_mc._sprite_mc:play();
					unit_mc:spriteSetFrame(1);
				end
			else
				local last_set_obj = string_split(new_ani_set,'_');
				local side_id = table.remove(last_set_obj, #last_set_obj);
				unit_mc.old_ani_set = new_ani_set;
	
				unit_mc.mscale = unit_mc.zScale;
				
				if(side_id == 'n')then
					side_id = 'w';
					new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					unit_mc.mscale = -unit_mc.zScale;
				elseif(side_id == 'ne')then
					side_id = 'sw';
					new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					unit_mc.mscale = -unit_mc.zScale;
				elseif(side_id == 'e')then
					side_id = 's';
					new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					unit_mc.mscale = -unit_mc.zScale;
				end
				
				local full_str = unit_data.atlas_id..'_'..new_ani_set;
				unit_mc.saved_ani_set = new_ani_set;
				-- print("deltas:", full_str, unit_deltas[full_str]);
				if(unit_deltas[full_str])then
					-- print("deltas:", unit_deltas[full_str].x*unit_mc.mscale, unit_deltas[full_str].y);
					-- unit_mc._sprite_mc.x,unit_mc._sprite_mc.y = unit_deltas[full_str].x*unit_mc.mscale, unit_deltas[full_str].y-12;
					unit_mc:spriteSetXY(unit_deltas[full_str].x*unit_mc.mscale, unit_deltas[full_str].y);
				else
					unit_mc:spriteSetXY(0, 6);
				end

				-- unit_mc._sprite_mc.xScale = unit_mc.mscale;
				unit_mc:spriteSetScale(unit_mc.mscale);
				unit_mc:spriteSetSeq(new_ani_set);
				-- unit_mc._sprite_mc:setSequence(new_ani_set);
				-- unit_mc._sprite_mc:play();
				
			end
		end
	end
	
	unit_mc._dmg = unit_data.dmg;
	unit_mc._chain = unit_data.chain;
	unit_mc._aoe = unit_data.aoe*math.pi/180;
	unit_mc._vamp = unit_data.vamp
	unit_mc._dmg_type = unit_data.dmg_type;
	unit_mc._r = unit_data.r;
	unit_mc._rr = unit_mc._r*unit_mc._r;
	unit_mc._col_r = unit_data.col_r;
	unit_mc._col_rr = unit_mc._col_r*unit_mc._col_r;
	unit_mc._s = unit_data.s/300;
	unit_mc._s_boost = 0;
	unit_mc._h = unit_data.h or 50;
	
	-- unit_mc.levitating = unit_data.levitating;
	-- print(unit_mc._type, unit_mc.levitating, unit_data.levitating);
	function unit_mc:levitating()
		return unit_data.levitating;
	end
	
	function unit_mc:usePerStats()--APPLYING Per Stats once. Have to be after all dress ups and perks.
		-- print("_usePerStats:", unit_mc._dmg_per, unit_mc._hp_per);
		if(unit_mc._hp_per)then
			unit_mc._hp = unit_mc._hp *(100 + unit_mc._hp_per)/100;
			unit_mc._hp_max = unit_mc._hp;
			unit_mc._hp_per = nil;
		end
		if(unit_mc._dmg_per)then
			unit_mc._dmg = unit_mc._dmg *(100 + unit_mc._dmg_per)/100;
			unit_mc._dmg_per = nil;
		end
		unit_mc._regen = unit_data.regen * (1+math.sqrt(unit_mc._hp_max)/10);
	end

	unit_mc._muzing = unit_data.muzic==true;
	
	if(unit_data.shadow)then
		unit_mc._shadow_mc = display.newImage(unit_mc, "image/unitsShadow/"..unit_data.shadow..".png");
		if(unit_mc._shadow_mc)then
			unit_mc._shadow_mc.x, unit_mc._shadow_mc.y = 0, 0;
			unit_mc:insert(1, unit_mc._shadow_mc);
		end
	end
	
	unit_mc._dmg_crit_c=unit_data.dmg_crit_c;
	unit_mc._dmg_crit_v=unit_data.dmg_crit_v;
	unit_mc._dmg_crit_ani = false;
	
	unit_mc._stun_c=unit_data.stun_c/100;
	unit_mc._stun_v=unit_data.stun_v;
	
	unit_mc._dmg_crit=unit_mc._dmg_crit_c>0;
	unit_mc._stun=unit_mc._stun_c>0;
	
	unit_mc._finisher = unit_data.finisher;
	unit_mc._armorreducion = unit_data.armorreducion;
	unit_mc._destroyer = unit_data.destroyer;
	unit_mc._magic_dmg = 0;
	unit_mc._true_dmg = 0;
	
	unit_mc._regen = unit_data.regen;
	unit_mc._healing = unit_data.healing;
	
	unit_mc._dframe = unit_data.damage_frame or 100;
	
	unit_mc._bspeed = unit_data.bullet_speed or 0;
	unit_mc._bart = unit_data.bullet_art;
	unit_mc._dmg_cast_self = unit_data.dmg_cast_self;
	unit_mc._dmg_cast_tar = unit_data.dmg_cast_tar;
	
	unit_mc._ulvl = unit_data.lvl;
	unit_mc._rush_bol = (unit_data._rush == true);
	unit_mc._hp_max = unit_data.hp;
	unit_mc._poison_power = unit_data.poison_power;

	unit_mc:setMP(unit_data.mana);
	
	for i=1,#unit_data.spells do
		unit_mc._spells[#unit_mc._spells+1] = unit_data.spells[i];
	end
		
	-- if(options_debug)then
		-- unit_mc:setMP(300);
		-- unit_mc._spells[#unit_mc._spells+1] = "blind";
	-- end
	
	unit_mc._auras = {};
	unit_mc._auras_bol = false;
	unit_mc._auras_reload = AURA_TIMER;
	
	unit_mc._armor = unit_data.armor;
	unit_mc._block = unit_data.block;
	unit_mc._dodge = unit_data.dodge;
	unit_mc._resist = unit_data.resist;
	unit_mc._potions = 0;
	
	unit_mc._holy = unit_data._holy;
	unit_mc._undead = unit_data._undead;
	unit_mc._giant = unit_data._giant;
	unit_mc._passive = unit_data._passive;
	unit_mc._morphing = unit_data._morphing;
	unit_mc._taxman = unit_data._taxman;
	--print("_unit_mc._holy:", unit_mc._holy)
	--print("_unit_mc._undead:", unit_mc._undead)
	unit_mc._weapon_type = unit_data.weapon_type;
	unit_mc._armor_type = unit_data.armor_type;
	unit_mc._repair = unit_data.repair;
	unit_mc._exp = 1;--boost to expirience
	


	
	unit_mc:setHP(unit_mc._hp_max)
	
	unit_mc._lvl = 1;
	unit_mc._xp = 0;
	unit_mc._xp_max = unit_mc._lvl*unit_mc._lvl*50;
	
	function unit_mc:starup()
		unit_mc:removeStar()
		
		unit_mc._bless6_mc = display.newImage(unit_mc, "image/icos/star.png");
		unit_mc._bless6_mc.x, unit_mc._bless6_mc.y = 0, -60;
		transition.from(unit_mc._bless6_mc, {time=400, alpha=0, y=-200});
	end
	function unit_mc:removeStar()
		if(unit_mc._bless6_mc)then
			unit_mc._bless6_mc:removeSelf();
			unit_mc._bless6_mc = nil;
		end
	end
	function unit_mc:levelup()
		unit_mc._lvl = unit_mc._lvl + 1;
		unit_mc._xp_max = unit_mc._lvl*unit_mc._lvl*50;
		
		unit_mc._dmg = unit_mc._dmg + unit_mc._ulvl;
		unit_mc._hp_max = unit_mc._hp_max + 5;
		
		if(unit_data.armor_type == "armor_no")then
			unit_mc._dmg = unit_mc._dmg + 2;
		end
		
		if(unit_mc._mp>0)then
			unit_mc._mp = unit_mc._mp + 10;
		end
		
		if(unit_mc._poison_power)then
			if(unit_mc._poison_power > 0)then
				unit_mc._poison_power = unit_mc._poison_power + 0.5;
			end
		end

		unit_mc._hp = unit_mc._hp_max;
		unit_mc:refreshHP();
		
		unit_mc._dmg_crit=unit_mc._dmg_crit_c>0;
		unit_mc._stun=unit_mc._stun_c>0;
	end
	function unit_mc:demote()
		unit_mc._muzing = false;
		while(#unit_mc._spells>0)do
			table.remove(unit_mc._spells, 1);
		end
		unit_mc:removeMP();
	end
	
	
	local unit = unit_mc;
	unit.hpbarW = 70;
	
	unit.energymax = 1;
	unit.energy = unit.energymax;
	unit.armor = 0;
	
	local stsmc = newGroup(unit);
	
	function unit:eventHandler()
		
	end
	function unit:addMsg()
		
	end
	function unit:refreshHP()
		-- print('refreshHP');
		unit:refreshStatuses();
		-- stsmc:toFront();
	end
	
	local statuses = {};
	
	stsmc.x, stsmc.y = 0, 28;
	unit.stsmc = stsmc;

	local function iniNewStat(attr, ico)
		if(unit[attr]==nil)then unit[attr]=0; end
		local shieldmc = newGroup(stsmc);
		local shieldico;
		function shieldmc:ico()
			if(shieldico==nil)then
				if(options_warnings_images)then
					shieldico = display.newImage(shieldmc, ico);
				end
				if(shieldico==nil)then
					shieldico = display.newImage(shieldmc, "image/mini/__noico.png");
				end
				if(shieldico)then
					shieldico:scale(1/2, 1/2);
					shieldmc:insert(1, shieldico);
				end
			end
		end
		local shieldtxt = newOutlinedText(shieldmc, 99, 6, 4, fontMain, 12, 1, 0, 1);
		shieldtxt:scale(1/2, 1/2);
		shieldtxt:setTextColor(0, 1, 0);
		table.insert(statuses, {mc=shieldmc, attr=attr, dtxt=shieldtxt});
		
		table.insert(buttons, shieldmc);
		shieldmc.w, shieldmc.h = 10*scaleGraphics, 10*scaleGraphics;
		shieldmc.hint = get_txt(attr).." - "..get_txt(attr.."_hint");
		function shieldmc:onOver()
			local val = unit[attr];
			if(val~=0)then
				local hint = getConditionDesc(attr, val, conditions[attr]);
				shieldmc.hint = hint;
			end
		end
	end
	iniNewStat("armor",			"image/mini/_armor.png");
	-- iniNewStat("str",			"image/mini/_rush.png");
	-- iniNewStat("strNext",		"image/mini/_rush2.png");
	iniNewStat("dex",			"image/mini/_dex.png");
	iniNewStat("nextCards",		"image/mini/_book.png");
	
	unit.card_played_this_turn = 0;
	for j=1,5 do
		unit["card_type_"..j.."_played"] = 0;
		unit["card_type_"..j.."_hand"] = 0;
	end
	unit["card_type_all_hand"] = 0;
			
	for attr,obj in pairs(conditions) do
		iniNewStat(attr, "image/mini/_"..attr..".png");
	end
	
	local function checkStances(exclude, stance, source)
		for attr,obj in pairs(conditions) do
			if(obj ~= exclude and obj.stance == stance)then
				if(unit[attr]>0)then
					unit:addStat(attr, -unit[attr], source);
				end
			end
		end
	end
		
	function unit:addStat(attr, val, source)
		-- print("addStat", attr, val, source)
		if(unit.ignoring[attr])then 
			unit:addMsg(get_txt("ignored")..": "..get_txt(attr), {1, 1, 1});
			return;
		end
			if(val)then
				if(val~=0 and val~="null")then
					if(conditions[attr])then
						if(conditions[attr].debuff)then
							if(unit.artifact>0)then
								unit.artifact = unit.artifact-1;
								unit:refreshHP();
								unit:addMsg(get_txt("prevented")..": "..get_txt(attr), {1, 1, 1});
								return false
							end
							unit:eventHandler("debuff", source);
							if(unit.parent)then
								unit.parent:callEvent("enemy_debuff", unit.gid, false, unit);
							end
						end
						if(conditions[attr].voodoo)then
							unit:eventHandler("voodoo", source);
							val = val + unit.voodoo;
						end
					end
					
					if(source)then
						if(source.charmdouble>0)then
							if(attr=="charm")then
								val = val*2;
							end
						end
						if(attr=="poison")then
							unit.poison_source = source;
							local sourceObj = source:getObj();
							if(sourceObj)then
								if(sourceObj.poisonadd)then
									val = val + sourceObj.poisonadd;
								end
							end
						end
					end
					
					if(unit[attr.."Add"])then
						val = val + unit[attr.."Add"];
					end
					-- print('addstat:', unit.current_card, attr);
					if(unit.current_card)then
						if(unit.current_card[attr]==nil)then
							unit:eventHandler(attr, unit);
							if(unit.current_card)then
								unit.current_card[attr] = true;
							end
						end
					else
						unit:eventHandler(attr, unit);
					end
					
					local con_obj = conditions[attr];
					
					if(unit[attr]==nil)then unit[attr]=0; end
					
					if(con_obj and val~=0 and unit[attr]==0)then
						if(con_obj.onAdd)then
							unit.parent:playCard(con_obj.onAdd, source, unit, false, false);
						end
						if(con_obj.stance)then
							checkStances(con_obj, con_obj.stance, source);
							unit:eventHandler("stanceNew", source);
							-- print("NEW STANCE");
						end
					end
					
					local val_old = unit[attr];
					unit[attr] = unit[attr] + val;
										
					unit:refreshHP();
					
					if(attr=='shifted')then
						unit_obj.shiftCardsTemp = nil;
						unit:prepareCard();
						unit:showNextMove();
					end
					
					
					local msg = true;
					if(con_obj)then
						if(con_obj.intend)then
							unit:showNextMove();
						end
						if(con_obj.hidden or con_obj.msg==false)then
							msg = false;
						end
						if(val<0 and unit[attr]==0)then
							-- print(attr, con_obj.onExpire, unit==source);
							if(con_obj.onExpire)then
								unit.parent:playCard(con_obj.onExpire, unit, unit, false, false);
							end
						end
						if(val~=0)then
							if(con_obj.refreshallintends and unit.parent and unit.parent.refreshAllIntends)then
								unit.parent:refreshAllIntends();
							end
						end
						if(con_obj.event)then
							if(con_obj.event == attr.."_mod_10")then
								for i=val_old+1,unit[attr] do
									if(i%10 == 0)then
										unit:eventHandler("mantra_mod_10", unit);
									end
								end
							end
						end
					end
					
					if(unit.updateAllCards)then
						unit:updateAllCards();
					end
					
					-- local txt = get_txt(attr);
					-- if(val<0)then
						-- txt=txt..""..val;
					-- else
						-- txt=txt.."+"..val;
					-- end
					if(msg)then
						unit:addMsg(val, {1, 1, 1}, attr.._G.card_counter, attr);
					end
				end
			end
		end
		function unit:tickStat(attr, val)
			if(val==nil)then val=1; end
			if(unit[attr])then
				if(unit[attr]>0)then
					unit[attr] = unit[attr]-val;
					
					if(unit[attr]<1)then
						-- unit:addMsg(get_txt('expired')..": "..get_txt(attr), {0, 0, 0});

						unit[attr] = 0;
					end
					
					unit:refreshHP();
					-- stsmc:toFront();
				end
			end
		end
		function unit:dropArmor()
			-- if(unit.barricade>0)then
				-- return
			-- end
			if(unit.armor>0)then
				unit.armor = 0;
				unit:refreshHP();
			end
		end
		
	function unit:refreshStatuses()
			local j = 0;
			local rm = 6;
			local imax = 0;
			for i=1,#statuses do
				local stat = statuses[i];
				local val = unit[stat.attr];
				
				local con_obj = conditions[stat.attr];
				stat.mc.isVisible = val~=0;
				if(con_obj)then
					if(con_obj.number==false)then
						stat.dtxt.isVisible = false;
					end
					stat.mc.isVisible = stat.mc.isVisible and (con_obj.hidden~=true or options_debug or (stat.attr=="pain" and unit:getTag()=="Demon") or (stat.attr=="petsmax" and unit:getTag()=="Shiva"));
				end
				
				if(stat.mc.isVisible)then
					stat.mc:ico();
					-- stat.mc.x = -unit.hpbarW/2 + 10 + j*20;
					
					stat.dtxt:setText(elite.getPrettyNumber(val));
					
					imax = imax+1;
				end
			end
			
			for i=1,#statuses do
				local stat = statuses[i];
				local con_obj = conditions[stat.attr];
				if(stat.mc.isVisible and con_obj and con_obj.stance)then
					if(imax<5)then
						stat.mc.x = (j - 1.5)*20;
					else
						stat.mc.x = (j%rm - rm/2 + 0.5)*20
					end
					stat.mc.y = math.floor(j/rm)*20;
					j = j+1;
				end
			end
			
			for i=1,#statuses do
				local stat = statuses[i];
				local con_obj = conditions[stat.attr];
				if(stat.mc.isVisible and (con_obj==nil or (con_obj and con_obj.stance==nil)))then
					if(imax<5)then
						stat.mc.x = (j - 1.5)*20;
					else
						stat.mc.x = (j%rm - rm/2 + 0.5)*20
					end
					stat.mc.y = math.floor(j/rm)*20;
					j = j+1;
				end
			end
	end
		
	function unit:clearStatuses()
		for i=1,#statuses do
			local stat = statuses[i];
			stat.mc.isVisible = false;
		end
	end
	
	unit.ignoring = {};
	function unit:addIgnore(attr)
		unit.ignoring[attr] = true;
	end
	function unit:turnIgnores()
		for attr,val in pairs(unit.ignoring) do
			unit.ignoring[attr] = nil;
		end
	end
	

	unit_mc:setSS()
	return unit_mc
end