module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "editor";
	
	local background = display.newImage(localGroup, "image/background/book.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	localGroup.buttons = {};
	
	-----------------------------------------------------------
	local params = {};
	local pevents = {};
	do
		function table.val_to_str ( v )
		  if "string" == type( v ) then
			v = string.gsub( v, "\n", "\\n" )
			if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
			  return "'" .. v .. "'"
			end
			return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
		  else
			return "table" == type( v ) and table.tostring( v ) or
			  tostring( v )
		  end
		end

		function table.key_to_str ( k )
		  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
			return k
		  else
			return "[" .. table.val_to_str( k ) .. "]"
		  end
		end

		function table.tostring( tbl )
		  local result, done = {}, {}
		  for k, v in ipairs( tbl ) do
			table.insert( result, table.val_to_str( v ) )
			done[ k ] = true
		  end
		  for k, v in pairs( tbl ) do
			if not done[ k ] then
			  table.insert( result,
				table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
			end
		  end
		  return "{" .. table.concat( result, "," ) .. "}"
		end
		function join(s1,s2,s3,s4,s5)
			local str = s1;
			if(s2)then str = str.."	"..s2; end
			if(s3)then str = str.."	"..s3; end
			if(s4)then str = str.."	"..s4; end
			if(s5)then str = str.."	"..s5; end
			return str;
		end

		
		local function cardHandler(card)
			for attr,val in pairs(card) do
				if(attr~='tag' and attr~="onUpgrade")then
					if(params[attr]==nil)then
						params[attr] = {};
					end
					local prms = params[attr];
					if(type(val)=='table')then
						prms[tostring(json.encode(val))] = true;
					else
						prms[tostring(val)] = true;
					end
				end
			end
		end
		local function eventHandler(obj)
			-- table.insert(pevents, obj);
			-- if(pevents[obj.event]==nil)then
				-- pevents[obj.event] = {};
			-- end
			-- pevents[obj.event][json.encode(obj.play)] = true;
			-- local attr = "event";
			cardHandler({event = obj.event});
		end
		
		for i=1,#cards do
			local card = cards[i];
			cardHandler(card);
			if(card.onUpgrade)then
				cardHandler(card.onUpgrade);
			end
			if(card.charm)then
				local ucard = table.cloneByAttr(card);
				upgradeCard(ucard);
				print(i, card.tag..":", "energy:"..card.energy, getCardDesc(card));
				print(i, ucard.tag.."+:", "energy:"..ucard.energy, getCardDesc(ucard));
			end
		end
		
		for i=1,#enemies do
			for j=1,#enemies[i].cards do
				local card = enemies[i].cards[j];
				cardHandler(card);
			end
		end
		
		for attr,obj in pairs(pets) do 
			cardHandler(obj.passive);
			cardHandler(obj.active);
		end
		
		for attr,obj in pairs(conditions) do 
			if(obj.play)then
				cardHandler(obj.play);
			end
			if(obj.event and obj.play)then
				eventHandler(obj);
			end
		end
		
		for i=1,#relics do
			local robj = relics[i];
			if(robj.condition)then
				local obj = robj.condition;
				if(obj.play)then
					cardHandler(obj.play);
				end
				if(obj.event and obj.play)then
					eventHandler(obj);
				end
			end
		end
		
		-- for attr,obj in pairs(pevents) do
			-- for str,val in pairs(obj) do
				-- print(attr, str);
			-- end
		-- end
		
		local arr = {};
		table.insert(arr, "[stats]");
		table.insert(arr, "[values - values already on other cards]");
		for attr,val in pairs(params) do
			if(conditions[attr])then
			else
				if(get_txt_force(attr))then
					table.insert(arr, join(attr, '"'..get_txt(attr)..'"', get_txt(attr.."_hint")).."\r\n".."	"..join("","values:", table.concat(table.keys(val), ", ")).."\r\n");
				else
					table.insert(arr, join(attr, get_txt(attr.."_hint")).."\r\n".."	"..join("","values:", table.concat(table.keys(val), ", ")).."\r\n");
				end
				-- table.insert(arr, join("","values:", table.concat(table.keys(val), ", ")));
			end
		end
		
		table.sort(arr);
		
		
		table.insert(arr, "");
		table.insert(arr, "");
		table.insert(arr, "[conditions]");
		for attr,val in pairs(params) do
			
			if(conditions[attr])then
				local con = conditions[attr];
				if(con.expire~=nil)then
					table.insert(arr, join(attr, get_txt(attr), get_txt(attr.."_hint")));
					table.insert(arr, join("", "condition:", table.tostring(con))); -- {event="turn", expire=1, debuff=true, expireAtEnd=true, intend=true};
				end
			end
			-- table.insert(arr, join("","values:", table.concat(table.keys(val), ", ")));
		end
		table.insert(arr, "");
		table.insert(arr, "");
		table.insert(arr, "[powers]");
		for attr,val in pairs(params) do
			
			if(conditions[attr])then
				local con = conditions[attr];
				if(con.expire==nil)then
					table.insert(arr, join(attr, get_txt(attr), get_txt(attr.."_hint")));
					table.insert(arr, join("", "power:", table.tostring(con))); -- {event="turn", expire=1, debuff=true, expireAtEnd=true, intend=true};
				end
			end
			-- table.insert(arr, join("","values:", table.concat(table.keys(val), ", ")));
		end
		
		
		local str = table.concat(arr, "\r\n");
		saveFile("_prms.txt", str);
	end
	-----------------------------------------------------------
	local function iniBtn(mc, w, h, body, over)
		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = w or mc.width, h or mc.height;
		elite.addOverOutBrightness(mc);
		-- mc.val = mc.text;
		-- function mc:onOver()
			-- mc:setTextColor(0, 1, 0);
		-- end
		-- function mc:onOut()
			-- mc:setTextColor(1, 1, 1);
		-- end
	end
	
	-- local mycard_i = 1;
	local mycardsmc = newGroup(facemc);
	local wndmc = newGroup(gamemc);
	local attrsmc = newGroup(wndmc);
	local selectsmc = newGroup(wndmc);
		
	local mycards = {};
	local mypotions = {};
	local myitems = {};

	local myjson = loadFile("__mycards.json");
	if(myjson)then
		mycards = json.decode(myjson);
	else
		table.insert(mycards, {tag="New Attack",	class="none", rarity=1, ctype=CTYPE_ATTACK, range="enemy", energy=0, onUpgrade={}});
		table.insert(mycards, {tag="New Skill",		class="none", rarity=2, ctype=CTYPE_SKILL, range="self", energy=1, onUpgrade={}});
		table.insert(mycards, {tag="New Power",		class="none", rarity=3, ctype=CTYPE_POWER, range="self", energy=2, onUpgrade={}});
	end

	local myjson = loadFile("__mypotions.json");
	if(myjson)then
		mypotions = json.decode(myjson);
	else
		table.insert(mypotions,	{tag="Potion1 ",		class="none", rarity=1,  ctype="potion", range='enemy', dmg=20});
	end
	
	local myjson = loadFile("__myrelics.json");
	if(myjson)then
		myitems = json.decode(myjson);
	else
		table.insert(myitems,	{tag="Relic 1",	rarity=0, scin=109, ctype="relic", condition={event="battle_won", play={range="self"}}});
	end

	function mycardsmc:refresh()
		cleanGroup(mycardsmc);
		for i=1,#mycards do
			local card_obj = mycards[i];
			local item = newGroup(mycardsmc);
			item:scale(scaleGraphics/2, scaleGraphics/2);
			item.x, item.y = 20*scaleGraphics + (mycardsmc.numChildren)*34*scaleGraphics, 26*scaleGraphics;
			local body1 = display.newImage(item, "image/card_hide.png");
			body1:scale(1/4, 1/4);
			local body2 = display.newImage(item, "image/cards_ctype"..card_obj.ctype..".png");
			iniBtn(item);
			item.hint = card_obj.tag;
			item.act = function()
				gamemc:refreshCard(card_obj);
				attrsmc:refresh();
			end
		end

		local item = newGroup(mycardsmc);
		item:scale(scaleGraphics/2, scaleGraphics/2);
		item.x, item.y = 20*scaleGraphics + (mycardsmc.numChildren)*34*scaleGraphics, 26*scaleGraphics;
		local body1 = display.newImage(item, "image/button/plus.png");
		iniBtn(item);
		item.act = function()
			table.insert(mycards, {tag="New Attack",	class="none", rarity=1, ctype=CTYPE_ATTACK, range="enemy", energy=0, onUpgrade={}});
			mycardsmc:refresh();
		end
		
		for i=1,#mypotions do
			local card_obj = mypotions[i];
			local item = newGroup(mycardsmc);
			item:scale(scaleGraphics/2, scaleGraphics/2);
			item.x, item.y = 20*scaleGraphics + (mycardsmc.numChildren)*34*scaleGraphics, 26*scaleGraphics;
			local body1 = display.newImage(item, "image/potions/_unknow.png");
			iniBtn(item);
			item.act = function()
				gamemc:refreshCard(card_obj);
				attrsmc:refresh();
			end
		end
		
		local item = newGroup(mycardsmc);
		item:scale(scaleGraphics/2, scaleGraphics/2);
		item.x, item.y = 20*scaleGraphics + (mycardsmc.numChildren)*34*scaleGraphics, 26*scaleGraphics;
		local body1 = display.newImage(item, "image/button/plus.png");
		iniBtn(item);
		item.act = function()
			table.insert(mypotions,	{tag="Potion "..(#mypotions+1),		class="none", rarity=1,  ctype="potion", range='enemy', dmg=20});
			mycardsmc:refresh();
		end
		
		for i=1,#myitems do
			local card_obj = myitems[i];
			local item = newGroup(mycardsmc);
			item:scale(scaleGraphics/2, scaleGraphics/2);
			item.x, item.y = 20*scaleGraphics + (mycardsmc.numChildren)*34*scaleGraphics, 26*scaleGraphics;
			local body1 = display.newImage(item, "image/arts/item_"..(card_obj.scin or 102)..".png");
			iniBtn(item);
			item.act = function()
				gamemc:refreshCard(card_obj);
				attrsmc:refresh();
			end
		end
		
		local item = newGroup(mycardsmc);
		item:scale(scaleGraphics/2, scaleGraphics/2);
		item.x, item.y = 20*scaleGraphics + (mycardsmc.numChildren)*34*scaleGraphics, 26*scaleGraphics;
		local body1 = display.newImage(item, "image/button/plus.png");
		iniBtn(item);
		item.act = function()
			table.insert(myitems,	{tag="Relic "..(#myitems+1),	rarity=0, scin=109, ctype="relic", condition={event="battle_won", play={range="self"}}});
			mycardsmc:refresh();
		end
	end
	mycardsmc:refresh();
	
	local function iniTxtBtn(mc, w, h, body, over)
		table.insert(localGroup.buttons, mc);
		mc.w, mc.h = w or mc.width, h or mc.height;
		mc.val = mc.text;
		function mc:onOver()
			mc:setTextColor(0, 1, 0);
		end
		function mc:onOut()
			if(mc.red)then
				mc:setTextColor(1, 0, 0);
			else
				mc:setTextColor(1, 1, 1);
			end
		end
		mc:onOut();
	end
	
	do
		-- options_names_on
		
		local card_obj = mycards[1];
		local card_mc1, body;
		local card_mc2, body2;
		
		local hmc = display.newImage(gamemc, "image/cards_front_2.png", -9999, -9999);
		hmc:scale(0.95*scaleGraphics/2, 0.95*scaleGraphics/2);
		hmc.fill.effect = "filter.brightness";
		hmc.fill.effect.intensity = 2.0;
		hmc.alpha = 0.25;
		
		function gamemc:refreshCard(_card_obj)
			if(_card_obj)then 
				card_obj = _card_obj; 
			end
			if(card_mc1)then
				card_mc1:removeSelf();
				card_mc1 = nil;
			end
			if(card_mc2)then
				card_mc2:removeSelf();
				card_mc2 = nil;
			end
			
			
			hmc.isVisible = false;
			if(card_obj.ctype=="relic")then
				local hint = getRelicDesc(card_obj);
				card_mc1 = display.newText({parent=wndmc, text=get_name(card_obj.tag), x=130*scaleGraphics, y=80*scaleGraphics, fontSize=16*scaleGraphics});
				card_mc2 = display.newText({parent=wndmc, text=hint, width=220*scaleGraphics, x=130*scaleGraphics, y=100*scaleGraphics, fontSize=14*scaleGraphics});
				card_mc2.anchorY=0;
			elseif(card_obj.ctype=="potion")then
				card_mc1 = display.newText({parent=wndmc, text=get_name(card_obj.tag), x=130*scaleGraphics, y=80*scaleGraphics, fontSize=16*scaleGraphics});
				card_mc2 = display.newText({parent=wndmc, text=getCardDesc(card_obj), width=220*scaleGraphics, x=130*scaleGraphics, y=100*scaleGraphics, fontSize=14*scaleGraphics});
				card_mc2.anchorY=0;
			else
				hmc.isVisible = true;
				card_mc1, body = createCardMC(wndmc, card_obj);
				body:scale(1.5, 1.5);
				card_mc1.x, card_mc1.y = 70*scaleGraphics, 120*scaleGraphics;
				card_mc1:toBack();
				iniBtn(card_mc1);
				card_mc1.act = function()
					hmc.upgrade = false;
					hmc.x, hmc.y = card_mc1.x, card_mc1.y;
					hmc:toBack();
				end
				
				local uobj = table.cloneByAttr(card_obj);
				upgradeCard(uobj);
				
				card_mc2, body2 = createCardMC(wndmc, uobj);
				body2:scale(1.5, 1.5);
				card_mc2.x, card_mc2.y = 190*scaleGraphics, card_mc1.y;
				card_mc2:toBack();
				iniBtn(card_mc2);
				card_mc2.act = function()
					hmc.upgrade = true;
					hmc.x, hmc.y = card_mc2.x, card_mc2.y;
					hmc:toBack();
				end
			end
		end
		gamemc:refreshCard();
		
		params.range.ally = nil;
		params.range.owner = nil;
		params.range.party = nil;
		-- for attr,val in pairs(params.range) do
			-- print(attr,val)
		-- end
		
		
		
		local basic_attrs = {"class", "rarity", "ctype", "energy", "range"};
		local basic_min = #basic_attrs;
		function attrsmc:refresh()
			cleanGroup(attrsmc);
			local ii=1;
			
			if(card_obj.ctype=="relic")then
				local add = true;
				for i=1,#basic_attrs do
					local attr = basic_attrs[i];
					if(attr=='event')then
						add = false;
						break;
					end
				end
				if(add)then
					table.insert(basic_attrs, 'event');
				end
			end
			
			for i=1,#basic_attrs do
				local attr = basic_attrs[i];
				if(not(card_obj.ctype=="potion" and (attr=='ctype' or attr=='energy')) and not(card_obj.ctype=="relic" and (attr=='ctype' or attr=='energy')))then
					-- if(card_obj.ctype~="relic" or attr=='event')then
					-- -_W/2+50*scaleGraphics, _H/2 + 30*scaleGraphics*(i-#basic_attrs/2-0.5)
					local dtxt = display.newText(attrsmc, attr..":", 6*scaleGraphics, 190*scaleGraphics + 14*scaleGraphics*(ii), fontMain, 12*scaleGraphics);
					ii = ii+1;
					dtxt.anchorX = 0;
					
					if(i>basic_min)then
						iniTxtBtn(dtxt);
						dtxt.act = function()
							local target = card_obj;
							if(hmc.upgrade)then
								target = card_obj.onUpgrade;
							end
							if(card_obj.ctype=="relic")then
								target = card_obj.condition.play;
							end
							if(target)then
								target[attr] = nil;
							end
							table.remove(basic_attrs, i);
							attrsmc:refresh();
							selectsmc:refresh();
							gamemc:refreshCard();
						end
					end
					
					local vals = {};
					for val,bol in pairs(params[attr]) do
						table.insert(vals, val);
					end
					table.sort(vals);
					
					local dx = 2*scaleGraphics;
					local tx = dtxt.x + dtxt.width + dx;
					for j=1,#vals do
						local val = vals[j];
						local vtxt = display.newText(attrsmc, val, 6*scaleGraphics, dtxt.y, fontMain, 10*scaleGraphics);
						if(val:sub(1, 1)=="{")then
							vtxt.text = 't'..j;
							vtxt.hint = val;
						end
						if(val:sub(1, 1)=="[")then
							vtxt.text = 'a'..j;
							vtxt.hint = val;
						end
						if(attr=='event')then
							vtxt.text = j;
							vtxt.hint = val;
						end
						tx = tx + vtxt.width/2;
						vtxt.x = tx;
						tx = tx + vtxt.width/2 + dx;
						if(tostring(card_obj[attr])==val)then
							vtxt.red = true;
						end
						iniTxtBtn(vtxt);
						
						vtxt.act = function()
							-- print(val, type(val), val:sub(1, 1), val:sub(1, 1)=="{", val:sub(1, 1)=="[");
							local target = card_obj;
							if(hmc.upgrade)then
								target = card_obj.onUpgrade;
							end
							if(card_obj.ctype=="relic")then
								if(attr=='event')then
									target = card_obj.condition;
								else
									target = card_obj.condition.play;
								end
							end
							
							if(target)then
								if(val:sub(1, 1)=="{" or val:sub(1, 1)=="[")then
									target[attr] = json.decode(val);
								else
									target[attr] = val;
								end
							end
							gamemc:refreshCard();
						end
					end
				end
			end
		end
		attrsmc:refresh();
		
		local function addPrmsBtn(id, hint, tx, ty)
			local btn = display.newImage(wndmc, "image/ico_hero_lvls/Frame0"..id..".png", tx, ty);
			btn:scale(scaleGraphics/2, scaleGraphics/2);
			iniBtn(btn);
			btn.switch = true;
			btn.hint = hint;
			btn.act = function()
				btn.switch = not btn.switch;
				selectsmc:refresh();
				if(btn.switch)then
					btn.alpha = 1;
				else
					btn.alpha = 1/2;
				end
			end
			return btn;
		end
		local btn1 = addPrmsBtn(1, "simple", _W - 140*scaleGraphics, 20*scaleGraphics);
		local btn2 = addPrmsBtn(2, "expire==nil (powers or one time bonuses)", _W - 120*scaleGraphics, 20*scaleGraphics);
		local btn3 = addPrmsBtn(3, "expire==1 (conditions that decreased every turn)", _W - 100*scaleGraphics, 20*scaleGraphics);
		local btn4 = addPrmsBtn(4, "expire>1 (conditions for one turn)",_W - 80*scaleGraphics, 20*scaleGraphics);
		
		function selectsmc:refresh()
			cleanGroup(selectsmc);
			local params_list = {};
			local list1 = {};
			for attr,vals in pairs(params) do
				local r = conditions[attr]==nil;
				for i=1,#basic_attrs do
					if(basic_attrs[i]==attr)then
						r=false;
						break;
					end
				end
				if(r)then
					table.insert(list1, attr)
				end
			end
			table.sort(list1);
			
			local list2 = {};
			for attr,vals in pairs(params) do
				local r = false;
				if(conditions[attr])then
					r = conditions[attr].expire==nil;
				end
				for i=1,#basic_attrs do
					if(basic_attrs[i]==attr)then
						r=false;
						break;
					end
				end
				if(r)then
					table.insert(list2, attr)
				end
			end
			table.sort(list2);
			
			local list3 = {};
			for attr,vals in pairs(params) do
				local r = false;
				if(conditions[attr])then
					r = conditions[attr].expire==1;
				end
				for i=1,#basic_attrs do
					if(basic_attrs[i]==attr)then
						r=false;
						break;
					end
				end
				if(r)then
					table.insert(list3, attr)
				end
			end
			table.sort(list3);
			
			local list4 = {};
			for attr,vals in pairs(params) do
				local r = false;
				if(conditions[attr])then
					if(conditions[attr].expire)then
						r = conditions[attr].expire>1;
					end
				end
				for i=1,#basic_attrs do
					if(basic_attrs[i]==attr)then
						r=false;
						break;
					end
				end
				if(r)then
					table.insert(list4, attr)
				end
			end
			table.sort(list4);
			
			-- while(#list1>1)do
				-- table.insert(params_list, table.remove(list1, 1));
			-- end
			-- while(#list2>1)do
				-- table.insert(params_list, table.remove(list2, 1));
			-- end
			
			local dx = 2*scaleGraphics;
			local sx, sy = _W - dx, 40*scaleGraphics;
			
			local function doList(list)
				for i=1,#list do
					local attr = list[i];
					local vtxt = display.newText(selectsmc, attr, sx, sy, fontMain, 10*scaleGraphics);
					iniTxtBtn(vtxt);
					vtxt.act = function()
						table.insert(basic_attrs, attr);
						attrsmc:refresh();
						vtxt:removeSelf();
					end
					sx = sx - vtxt.width/2;
					vtxt.x = sx;
					sx = sx - vtxt.width/2 - dx;
					if(sx<400*scaleGraphics)then
						sx, sy = _W - dx, sy + 12*scaleGraphics;
					end
				end
			end
			
			
			if(btn1.switch)then
				doList(list1);
				sx, sy = _W - dx, sy + 20*scaleGraphics;
			end
			if(btn2.switch)then
				doList(list2);
				sx, sy = _W - dx, sy + 20*scaleGraphics;
			end
			if(btn3.switch)then
				doList(list3);
				sx, sy = _W - dx, sy + 20*scaleGraphics;
			end
			if(btn4.switch)then
				doList(list4);
				sx, sy = _W - dx, sy + 20*scaleGraphics;
			end
		end
		selectsmc:refresh();
		
	end
	-----------------------------------------------------------
	-- btn_save.png
	-- voice_off.png
	-----------------------------------------------------------
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
	
	local function onBack(e)
		show_start();
		return true
	end
	
	addRoaylBtn(_W - 20*scaleGraphics, 20*scaleGraphics, "exit", onBack, "image/button/cancel.png");
	
	addRoaylBtn(24*scaleGraphics + 0*50*scaleGraphics, _H-24*scaleGraphics, "save", function()
		saveFile("__mycards.json", json.encode(mycards));
		saveFile("__mypotions.json", json.encode(mypotions));
		saveFile("__myrelics.json", json.encode(myitems));
	
		local path = system.pathForFile(nil, system.DocumentsDirectory);
		show_msg('saves at '..tostring(path));
	end, "image/gui/btn_save.png");
	addRoaylBtn(24*scaleGraphics + 1*50*scaleGraphics, _H-24*scaleGraphics, "open", function()
		system.openURL(system.pathForFile(nil, system.DocumentsDirectory));
	end, "image/gui/voice_off.png");
	
	
	function localGroup:actEscape()
		return onBack();
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	function localGroup:removeAll()

	end
	
	return localGroup;
end