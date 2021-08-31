module(..., package.seeall)
if(_G.cons_names==nil)then
	_G.cons_names = {};
	table.insert(_G.cons_names, "_bless");
	table.insert(_G.cons_names, "_curse");
	table.insert(_G.cons_names, "_frozen");
	table.insert(_G.cons_names, "_poison");
	table.insert(_G.cons_names, "_rush");
	table.insert(_G.cons_names, "_slow");
	table.insert(_G.cons_names, "_shield");
	table.insert(_G.cons_names, "_protect");
	table.insert(_G.cons_names, "_broken");
	table.insert(_G.cons_names, "_burned");
	
	table.insert(_G.cons_names, "_blinded");
	table.insert(_G.cons_names, "_stuned");
	table.insert(_G.cons_names, "_root");
end

function new()
	local unit_mc = display.newGroup();
	unit_mc._xp = 0;
	unit_mc._kills = 0;
	unit_mc._deads = 0;
	unit_mc._ulvl = 5;
	unit_mc._col_r = 10;
	unit_mc._base_bol = false;
	unit_mc._ondead_bol = false;
	unit_mc._boss = false;

	unit_mc._dmg_crit=false;
	unit_mc._dmg_crit_c=0;
	unit_mc._dmg_crit_v=150;
	unit_mc._insta_kill = 0;
	
	function unit_mc:addXp(val)

	end
	----------- HitPoints ------------
	function unit_mc:setHP(val)
		unit_mc._hp = val;
	end
	local hp_bar_mc = display.newGroup();
	local hp_bar_mc_up = false;
	local hp_bar_back = nil;
	local hp_bar_line = nil;
	function unit_mc:hideHP()
		if(hp_bar_back)then
			hp_bar_back:removeSelf();
			hp_bar_line:removeSelf();
			hp_bar_back = nil;
		end
		hp_bar_mc_up = false;
	end
	function unit_mc:refreshHP()
		if(hp_bar_back)then
			hp_bar_back:removeSelf();
			hp_bar_line:removeSelf();
		end
		
		local bar_w = unit_mc._col_r+20;
		--hp_bar_mc.y = -60;
		hp_bar_mc.y = -(unit_mc._h+10)

		
		hp_bar_back = display.newLine( hp_bar_mc, -bar_w/2, 0, bar_w/2, 0 );
		hp_bar_back:setStrokeColor(0.8, 0.8, 0.8);
		hp_bar_back.strokeWidth = 4;
		
		hp_bar_line = display.newLine( hp_bar_mc, -bar_w/2, 0, bar_w/2 - bar_w*(1 - unit_mc._hp/unit_mc._hp_max), 0);
		
		if(unit_mc._armor>0)then
			hp_bar_line:setStrokeColor(0, 0, 0.8);
		elseif(unit_mc._poison > 0)then
			hp_bar_line:setStrokeColor(0, 0.8, 0);
		elseif(unit_mc._slow>0)then
			hp_bar_line:setStrokeColor(0, 0, 0.8);
		else
			hp_bar_line:setStrokeColor(0.8, 0, 0);
		end
		hp_bar_line.strokeWidth = 4;
		hp_bar_mc:insert(hp_bar_back)
		hp_bar_mc:insert(hp_bar_line)
		unit_mc:insert(hp_bar_mc);
		
		hp_bar_mc_up = true;
		hp_bar_mc.alpha = 1;
		hp_bar_mc.xScale = unit_mc.xScale;
		hp_bar_mc.time = getTimer()+2000;
	end
	function unit_mc:heal(val)
		if(unit_mc._hp < unit_mc._hp_max)then
			unit_mc._hp = unit_mc._hp+ val;
			if(unit_mc._hp > unit_mc._hp_max)then
				unit_mc._hp = unit_mc._hp_max;
			end
			unit_mc:refreshHP();
			return true;
		end
		return false;
	end
	function unit_mc:turnHP(dtime)
		if(hp_bar_mc_up)then
			if(getTimer()>hp_bar_mc.time)then
				if(hp_bar_mc.alpha>0)then
					local new_val = hp_bar_mc.alpha - 0.002*dtime;
					if(new_val>0)then
						hp_bar_mc.alpha = new_val;
					else
						hp_bar_mc.alpha = 0;
					end
					return
				end
				if(hp_bar_back)then
					hp_bar_back:removeSelf();
					hp_bar_line:removeSelf();
					hp_bar_back = nil;
				end
				hp_bar_mc_up = false;
			end
		end
	end
	----------- MANA ------------
	unit_mc._spells = {};--unit_data.spells;
	function unit_mc:setMP(val)
		unit_mc._mp = val;
		unit_mc._mp_max = val;
		unit_mc._mp_reg = 1/180;
	end
	function unit_mc:removeMP()
		unit_mc._mp = 0;
		unit_mc._mp_max = 0;
		unit_mc._mp_reg = 0;
		while(#unit_mc._spells>0)do
			table.remove(unit_mc._spells,1);
		end
		unit_mc._muzing = false;
	end
	local mp_bar_mc = display.newGroup();
	local mp_bar_mc_up = false;
	local mp_bar_back = nil;
	local mp_bar_line = nil;
	function unit_mc:hideMP()
		if(mp_bar_back)then
			mp_bar_back:removeSelf();
			mp_bar_line:removeSelf();
			mp_bar_back = nil;
		end
		mp_bar_mc_up = false;
	end
	function unit_mc:refreshMP()
		if(unit_mc._mp_max == 0)then
			return;
		end
		if(mp_bar_back)then
			mp_bar_back:removeSelf();
			mp_bar_line:removeSelf();
		end
		
		local bar_w = unit_mc._col_r+20;
		mp_bar_mc.y = -54;
		
		mp_bar_back = display.newLine( mp_bar_mc, -bar_w/2, 0, bar_w/2, 0 );
		mp_bar_back:setStrokeColor(0.8, 0.8, 0.8);
		mp_bar_back.strokeWidth = 4;
		
		mp_bar_line = display.newLine( mp_bar_mc, -bar_w/2, 0, bar_w/2 - bar_w*(1 - unit_mc._mp/unit_mc._mp_max), 0);
		mp_bar_line:setStrokeColor(0, 0, 0.8);
		mp_bar_line.strokeWidth = 4;
		--mp_bar_mc:insert(mp_bar_back)
		--mp_bar_mc:insert(mp_bar_line)
		unit_mc:insert(mp_bar_mc);
		
		mp_bar_mc_up = true;
		mp_bar_mc.alpha = 1;
		mp_bar_mc.xScale = unit_mc.xScale;
		mp_bar_mc.time = getTimer()+2000;
	end
	function unit_mc:turnMP(dtime)
		if(unit_mc._mp_max>0)then
			if(unit_mc._mp < unit_mc._mp_max)then
				unit_mc._mp = unit_mc._mp + unit_mc._mp_reg*dtime;
				if(unit_mc._mp>unit_mc._mp_max)then
					unit_mc._mp = unit_mc._mp_max;
				end
				--[[
				if(mp_bar_mc_up)then
					if(mp_bar_line)then
						mp_bar_line:removeSelf();
						
						mp_bar_line = display.newLine( mp_bar_mc, -bar_w/2, 0, bar_w/2 - bar_w*(1 - unit_mc._mp/unit_mc._mp_max), 0);
						mp_bar_line:setColor(0, 0, 200);
						mp_bar_line.width = 4;
						--mp_bar_mc:insert(mp_bar_line)
					end
				end
				]]--
			end
		end
		if(mp_bar_mc_up)then
			if(getTimer()>mp_bar_mc.time)then
				if(mp_bar_mc.alpha>0)then
					local new_val = mp_bar_mc.alpha - 0.002*dtime;
					if(new_val>0)then
						mp_bar_mc.alpha = new_val;
					else
						mp_bar_mc.alpha = 0;
					end
					return
				end
				if(mp_bar_back)then
					mp_bar_back:removeSelf();
					mp_bar_line:removeSelf();
					mp_bar_back = nil;
				end
				mp_bar_mc_up = false;
			end
		end
	end
	----------- Conditions ------------
	unit_mc._cons = {};
	for i=1,#_G.cons_names do
		unit_mc[_G.cons_names[i]] = 0;
	end

	function unit_mc:refreshIcos()
		local temp_arr = {};
		for i=1,#_G.cons_names do
			local attr = _G.cons_names[i];
			if(unit_mc[attr]>0 and unit_mc._dead~=true)then
				if(unit_mc[attr..'_ico']==nil)then
					local ico = display.newImage(unit_mc, "image/mini/"..attr..".png");
					if(ico)then
						ico.xScale, ico.yScale = 3/4,3/4;
						ico.y = -unit_mc._h-8;
						unit_mc[attr..'_ico'] = ico;
						transition.from(unit_mc[attr..'_ico'], {alpha=0, time=300, transition=easing.inQuad});
					end
				end
				table.insert(temp_arr, unit_mc[attr..'_ico']);
			elseif(unit_mc[attr..'_ico'])then
				transition.to(unit_mc[attr..'_ico'], {alpha=0, time=300, transition=easing.inQuad, onComplete=transitionRemoveSelfHandler})
				unit_mc[attr..'_ico'] = nil;
			end
		end
		for i=1,#temp_arr do
			temp_arr[i].x = 23*(i-#temp_arr/2-0.5);
		end
	end
	
	function unit_mc:refreshBases()
		if(unit_mc._dmg_base == nil)then unit_mc._dmg_base = unit_mc._dmg; end
		if(unit_mc._armor_base == nil)then unit_mc._armor_base = unit_mc._armor; end
		if(unit_mc._dodge_base == nil)then unit_mc._dodge_base = unit_mc._dodge; end
	end
	
	function unit_mc:addCon(con)
		unit_mc:refreshBases();
		if(con._act == 'heal' or con._act == 'sheal')then
			if(unit_mc._poison>0)then
				unit_mc._poison = 0;
				unit_mc:refreshHP();
				unit_mc:refreshIcos();
			end
			if(unit_mc._hp<unit_mc._hp_max)then
				unit_mc._hp = unit_mc._hp + con._power;
				if(unit_mc._hp>unit_mc._hp_max)then
					unit_mc._hp=unit_mc._hp_max;
				end
				unit_mc:refreshHP();
			end
			return true
		end
		if(unit_mc.antimagic)then
			return false;
		end
		if(con._ttl)then
			if(unit_mc._boss)then
				con._ttl = con._ttl/5;
			elseif(unit_mc._raged)then
				con._ttl = con._ttl/2;
			end
		end
		
		if(con._act == 'burn')then
			unit_mc._burned = unit_mc._burned+1;
			unit_mc._regen = unit_mc._regen/2;
			unit_mc._armor = unit_mc._armor/2;
			unit_mc._hp = unit_mc._hp - con._power;
			unit_mc:refreshHP();
			if(unit_mc._parent.addGfx and con._power>0)then
				local item = unit_mc._parent:addGfx(unit_mc.x, unit_mc.y, "skull_red");
				if(item)then
					item.tty = -2;
				end
			end
			unit_mc:refreshIcos();
			return true
		end
		
		table.insert(unit_mc._cons, con);
		
		if(con._act == 'boost')then
			--print('_boost:', unit_mc._type,"_con["..con._attr.."]:", con._attr);
			unit_mc[con._attr] = unit_mc[con._attr] + con._val;
		elseif(con._act == 'freeze')then
			unit_mc._frozen = unit_mc._frozen+1;
			if(unit_mc._freeze_mc == nil)then
				local rnd = math.floor(math.random()*2) + 1;
				unit_mc._freeze_mc = addGfxEx(unit_mc, 0, -15, "ice_"..rnd);
				unit_mc._freeze_mc.alpha = 0;
				transition.to(unit_mc._freeze_mc, {time=500, alpha=1});
				local body = unit_mc:getBody();
				if(body)then
					body:pause()
				end
			end
		elseif(con._act == "plague" or con._act == "poison")then
			unit_mc._poison = unit_mc._poison + 1;
			unit_mc:refreshHP();
		elseif(con._act == 'root')then
			unit_mc._root = unit_mc._root+1;
		elseif(con._act == 'stun')then
			unit_mc._stuned = unit_mc._stuned +1;
			--if(unit_mc._stuned == 1)then
			--	if(unit_mc._stun_mc)then unit_mc._stun_mc:removeSelf(); unit_mc._stun_mc=nil; end
			--	unit_mc._stun_mc = addGfxEx(unit_mc, 0, -20-unit_mc._h, "stun_stars");
			--	unit_mc._stun_mc.alpha = 0;
			--	transition.to(unit_mc._stun_mc, {time=300, alpha=1});
			--	local body = unit_mc:getBody();
			--	if(body)then if(body.pause)then body:pause(); end end
			--end
		elseif(con._act == 'slow')then
			unit_mc._slow = unit_mc._slow + 1;
			if(unit_mc._slow == 1)then
				unit_mc._s = unit_mc._s - 0.02;
			end
		elseif(con._act == 'blind')then
			unit_mc._blinded = unit_mc._blinded+1;
		elseif(con._act == 'rush')then
			unit_mc._rush = unit_mc._rush + 1;
			unit_mc._dmg_crit_v = unit_mc._dmg_crit_v + 50;
			unit_mc._dodge = unit_mc._dodge + 10;
			unit_mc._dmg = unit_mc._dmg + 10;
		elseif(con._act == "curse" or con._act == "scurse")then
			if(unit_mc._curse == 0)then
				unit_mc._dmg = unit_mc._dmg - 20;
				unit_mc._s = unit_mc._s - 0.02;
			end
			unit_mc._curse = unit_mc._curse + 1;
			--image/mini/cursed.png
			--image/mini/bless.png
			--image/mini/charged.png
			--image/mini/protect.png
			--addGfxEx(unit_mc, 0, -20-unit_mc._h, "stun_stars");
		elseif(con._act == "bless")then
			if(unit_mc._bless == 0)then
				unit_mc._dmg = unit_mc._dmg + con._power;
				unit_mc._armor = unit_mc._armor + con._power;
				unit_mc._resist = unit_mc._resist + con._power;
			end
			unit_mc._bless = unit_mc._bless+1;
		elseif(con._act == "protect")then
			if(unit_mc._protect==0)then
				unit_mc._armor = unit_mc._armor + 30;
				unit_mc._resist = unit_mc._resist + 30;
				unit_mc._regen = unit_mc._regen + con._power;
			end
			unit_mc._protect = unit_mc._protect+1;
			
			--if(unit_mc._shield_mc == nil)then
			--	unit_mc._shield_mc = addGfxEx(unit_mc, 0, -20, "shield");
			--	unit_mc._shield_mc.xScale, unit_mc._shield_mc.yScale = unit_mc.xScale,unit_mc.yScale;
			--	unit_mc._shield_mc.alpha = 0;
			--	transition.to(unit_mc._shield_mc, {time=500, alpha=1});
			--end
		elseif(con._act == "shield")then
			if(unit_mc._shield==0)then
				unit_mc._thorns = unit_mc._thorns + 50;
			end
			unit_mc._shield=unit_mc._shield+1;
			--if(unit_mc._shield_mc == nil)then
			--	unit_mc._shield_mc = addGfxEx(unit_mc, 0, -20, "shield");
			--	unit_mc._shield_mc.xScale, unit_mc._shield_mc.yScale = unit_mc.xScale,unit_mc.yScale;
			--	unit_mc._shield_mc.alpha = 0;
			--	transition.to(unit_mc._shield_mc, {time=500, alpha=1});
			--end
		end
		unit_mc:refreshIcos();
	end
	function unit_mc:removeCon(con)
		if(con._act == 'boost')then
			unit_mc[con._attr] = unit_mc[con._attr] - con._val;
		elseif(con._act == 'freeze')then
			unit_mc._frozen = unit_mc._frozen-1;
			if(unit_mc._frozen < 1)then
				if(unit_mc._freeze_mc)then
					transition.to(unit_mc._freeze_mc, { time=300, alpha=0, onComplete=transitionRemoveSelfHandler});
					unit_mc._freeze_mc = nil;
					local body = unit_mc:getBody();
					if(body and unit_mc._dead~=true)then
						body:play();
					end
				end
			end
		elseif(con._act == "plague" or con._act == "poison")then
			if(unit_mc._poison>0)then
				unit_mc._poison = unit_mc._poison - 1;
			end
			unit_mc:refreshHP();
		elseif(con._act == 'root')then
			unit_mc._root = unit_mc._root-1;
		elseif(con._act == 'slow')then
			unit_mc._slow = unit_mc._slow - 1;
			if(unit_mc._slow == 0)then
				unit_mc._s = unit_mc._s + 0.02;
			end
		elseif(con._act == 'stun')then
			unit_mc._stuned = unit_mc._stuned-1;
		elseif(con._act == 'blind')then
			unit_mc._blinded = unit_mc._blinded-1;
		elseif(con._act == 'rush')then
			unit_mc._rush = unit_mc._rush - 1;
			if(unit_mc._rush == 0)then
				unit_mc._dmg_crit_v = unit_mc._dmg_crit_v - 50;
				unit_mc._dodge = unit_mc._dodge - 10;
				unit_mc._dmg = unit_mc._dmg - 10;
			end
		elseif(con._act == "curse" or con._act == "scurse")then
			unit_mc._curse = unit_mc._curse - 1;
			if(unit_mc._curse == 0)then
				unit_mc._dmg = unit_mc._dmg + 20;
				unit_mc._s = unit_mc._s + 0.02;
			end
		elseif(con._act == "bless")then
			unit_mc._bless = unit_mc._bless-1;
			if(unit_mc._bless==0)then
				unit_mc._dmg = unit_mc._dmg - con._power;
				unit_mc._armor = unit_mc._armor - con._power;
				unit_mc._resist = unit_mc._resist - con._power;
			end
		elseif(con._act == "protect")then
			unit_mc._protect = unit_mc._protect-1;
			if(unit_mc._protect==0)then
				unit_mc._armor = unit_mc._armor - 30;
				unit_mc._resist = unit_mc._resist - 30;
				unit_mc._regen = unit_mc._regen - con._power;
				if(unit_mc._regen<0)then
					unit_mc._regen = 0;
				end
			end
		elseif(con._act == "shield")then
			unit_mc._shield=unit_mc._shield-1;
			if(unit_mc._shield<1)then
				unit_mc._thorns = unit_mc._thorns - 50;
			end
		end
		unit_mc:refreshIcos();
	end
	function unit_mc:turnCon(dtime)
		for i=#unit_mc._cons,1,-1 do
			local con = unit_mc._cons[i];
			con._ttl = con._ttl - dtime;
			if (con._ttl<0) then
				unit_mc:removeCon(con);
				table.remove(unit_mc._cons, i);
			end
		end
	end

	return unit_mc
end