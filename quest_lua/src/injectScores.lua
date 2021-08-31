module(..., package.seeall);

function inject(localGroup, bg, buttons, db_id)
	local scorestxts = newGroup(bg);
	localGroup.scorestxts = scorestxts;
	scorestxts.i = 0;
	
	if(db_id==nil)then db_id="scores"; end
	
	local scoresall = newGroup(scorestxts);
	local scorestop = newGroup(scorestxts);
	
	-- elite.setScrollable(scoresall);
	do
		local w,h = bg.w, bg.h-22*scaleGraphics;
		local textGroup = scoresall;
		local maskS = 266;
		local mask = graphics.newMask("image/masks/rect.png");
		textGroup:setMask(mask);
		
		textGroup.maskScaleX = w/maskS*2;
		textGroup.maskScaleY = h/maskS;
		
		-- textGroup.maskX, textGroup.maskY = -maskS/textGroup.maskScaleX/2, -h*maskS/textGroup.maskScaleY/2;
		textGroup.maskYBase = 0;
		textGroup.maskYBase = h/2 + 11;
		-- textGroup.maskYBase = h/textGroup.maskScaleY/2 + 34*scaleGraphics;
		textGroup.maskY = textGroup.maskYBase;
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
		if(options_mobile)then
			local sx, sy = 0,0;
			bg:addEventListener("touch", function(e)
				if(e.phase=="began")then
					sx, sy = e.x, e.y;
				else
					local dx, dy = e.x-sx, e.y-sy;
					textGroup:translate(0, dy);
					textGroup.maskY = textGroup.maskY - dy;
					sx, sy = e.x, e.y;
				end
			end);
		end
	end	
	
	local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
	local function addScoreTxt(tar, obj, val1, val2, val3, val4, val5, val6, val7, val8, val9)
		if(val1=="")then
			return
		end
		
		if(scorestxts.attr~=nil)then
			if(scorestxts.attr==1)then
				if(val1~=scorestxts.val)then
					return;
				end
			end
			if(scorestxts.attr==2)then
				if(val2~=scorestxts.val)then
					return;
				end
			end
			if(scorestxts.attr==3)then
				if(val3~=scorestxts.val)then
					return;
				end
			end
		end
		
		local y = scorestxts.i*16*scaleGraphics;
		
		if(scorestxts.i~=0)then
			local txt0 = display.newText(tar, scorestxts.i, -180*scaleGraphics, y, fontMain, 12*scaleGraphics);
			txt0:translate(-txt0.width/2, 0);
		else
			local ico = display.newText(tar, "☆", -180*scaleGraphics, y, fontMain, 12*scaleGraphics);
			ico:translate(-ico.width/2, 0);
			
			ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
			ico.act = function()
				ico.disabled = true;
				localGroup:fetchScores("score");
			end
			table.insert(buttons, ico);
			elite.addOverOutBrightness(ico);
		end
		
		local val1new = val1;
		if(#val1>12)then
			val1new = val1:sub(1,12).."...";
			print(val1new, val1, val1:sub(1,1), val1:sub(1,2), val1:sub(1,3), val1:sub(1,4), #val1, #val1new);
		end
		local txt1 = display.newText(tar, val1new, -170*scaleGraphics, y, nil, 12*scaleGraphics);
		txt1:translate(txt1.width/2, 0);
		
		if(player_name==val1)then
			txt1:setTextColor(1/2, 1, 1/2);
		end
		
		txt1.w, txt1.h = txt1.width, 20*scaleGraphics;
		txt1.act = function()
			if(scorestxts.refresh)then
				scorestxts:refresh(1, val1);
			end
		end
		table.insert(buttons, txt1);
		elite.addOverOutBrightness(txt1);
		
		local x2 = -60*scaleGraphics
		local ico = display.newImage(tar, "gfx/builds/"..val2..".png", x2, y);
		if(ico)then
			ico:scale(scaleGraphics/3, scaleGraphics/3);
			
			ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
			ico.act = function()
				if(scorestxts.refresh)then
					scorestxts:refresh(2, val2);
				end
			end
			table.insert(buttons, ico);
			elite.addOverOutBrightness(ico);
		else
			local txt2 = display.newText(tar, val2, x2, y, fontMain, 12*scaleGraphics);
		end
		
		do
			local x3 = -20*scaleGraphics;
			local hero_obj = getHeroObjByAttr("tag", val3);
			local ico, ico_val;
			if(hero_obj)then
				ico_val = hero_obj.scin;
			end
			if(ico_val)then
				pixelArtOn();
				ico = display.newImage(tar, "image/heads/"..ico_val..".png", x3, y);
				pixelArtOff();
				if(ico)then
					ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
					ico.act = function()
						scorestxts:refresh(3, val3);
					end
					table.insert(buttons, ico);
					elite.addOverOutBrightness(ico);
				end
			end
			if(ico_val and ico)then
				ico:scale(scaleGraphics/2, scaleGraphics/2);
			else
				local txt3 = display.newText(tar, val3, x3, y, fontMain, 12*scaleGraphics);
			end
		end
		
		do
			local x4 = 10*scaleGraphics;
			if(val4=="hpmax")then
				local ico = display.newImage(tar, "image/hp.png", x4, y);
				ico:scale(scaleGraphics/2, scaleGraphics/2);

				ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
				ico.act = function()
					localGroup:fetchScores('hpmax');
				end
				table.insert(buttons, ico);
				elite.addOverOutBrightness(ico);
			else
				local txt4 = display.newText(tar, val4, x4, y, fontMain, 12*scaleGraphics);
			end
		end
		do
			local x5 = 40*scaleGraphics;
			if(val5=="cards")then
				local ico = display.newImage(tar, "image/cards_book.png", x5, y);
				ico:scale(scaleGraphics/2, scaleGraphics/2);
				
				ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
				ico.act = function()
					localGroup:fetchScores('cards');
				end
				table.insert(buttons, ico);
				elite.addOverOutBrightness(ico);
			else
				local txt5 = display.newText(tar, val5, x5, y, fontMain, 12*scaleGraphics);
			end
		end
		do
			local x6 = 70*scaleGraphics;
			if(val6=="items")then
				local ico = display.newImage(tar, "image/relics0.png", x6, y);
				ico:scale(scaleGraphics/2, scaleGraphics/2);
			else
				local txt6 = display.newText(tar, val6, x6, y, fontMain, 12*scaleGraphics);
			end
		end
		local txt4 = display.newText(tar, val7, 100*scaleGraphics, y, fontMain, 12*scaleGraphics);
		local txt5 = display.newText(tar, val8, 140*scaleGraphics, y, fontMain, 12*scaleGraphics);
		local txt6 = display.newText(tar, val9, 180*scaleGraphics, y, fontMain, 12*scaleGraphics);
		
		if(system.getInfo("environment")=="simulator")then
			if(obj)then
				if(obj.version)then
					local txt6 = display.newText(tar, obj.version, -250*scaleGraphics, y, fontMain, 12*scaleGraphics);
				end
				if(obj.hpmaxex)then
					local txt6 = display.newText(tar, obj.hpmaxex, 260*scaleGraphics, y, fontMain, 12*scaleGraphics);
				end
				
				local ico = display.newImage(tar, "image/gui/btnMinus.png", 230*scaleGraphics, y);
				ico:scale(scaleGraphics/2, scaleGraphics/2);
					
				ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
				ico.act = function()
					print(obj.uid);
					for attr,val in pairs(obj) do
						print(attr, val);
					end
					
					royal.db:delete(db_id.."/"..obj.uid, nil, function(event)
						if(event.isError)then
							print("Network error!");
						else
							local data_obj = json.decode(event.response);
							print('deleted:', obj.uid, event.response, data_obj);
						end
					end)
				end
				table.insert(buttons, ico);
				elite.addOverOutBrightness(ico);
			end
		end
		
		scorestxts.i = scorestxts.i+1;
		scorestxts.y = -bg.h/2 + 18*scaleGraphics;
		-- print("_txts.i:", txts.i);
	end
	
	
	addScoreTxt(scorestop, nil, "name", "build", "hero", "hpmax", "cards", "items", "floors", "kills", "score");
	function localGroup:dropJoined()
		scorestxts.joined = nil;
	end
	function localGroup:handleScoresData(response, prm, sort, joined)
		local data_obj = json.decode(response);
		-- print("handleScoresData", sort.attr, sort.val);
		if(data_obj)then
			local list = {};
			for uid,obj in pairs(data_obj)do
				obj.uid = uid;
				if(sort==nil or obj[sort.attr]==sort.val)then
					table.insert(list, obj);
				end
			end
			
			
			if(joined and scorestxts.list and scorestxts.joined==joined)then
				for i=#list,1,-1 do
				-- while(#list>0)do
					-- local obj = table.remove(list, 1)
					table.insert(scorestxts.list, list[i]);
				end
			else
				scorestxts.list = list;
			end
			scorestxts.joined = joined;
			
			if(scorestxts.list)then
				table.sort(scorestxts.list, function(a, b)
					return a[prm]>b[prm];
				end);
			end
			
			function scorestxts:refresh(attr, val)
				if(scorestxts.attr==attr)then
					scorestxts.attr = nil;
					scorestxts.val = nil;
				else
					scorestxts.attr = attr;
					scorestxts.val = val;
				end
				if(scoresall and scoresall.numChildren~=nil)then
					scoresall.y = 0;
					scoresall.maskY = scoresall.maskYBase;
					
					scorestxts.i = 1;
					cleanGroup(scoresall);
					
					for i=1,#scorestxts.list do
						local obj = scorestxts.list[i];
						addScoreTxt(scoresall, obj, obj.nick, obj.build, obj.tag, tostring(obj.hpmax or ""), tostring(obj.cards or ""), tostring(obj.items or ""), obj.floors, obj.kills, obj.score);
					end
				end
			end
			scorestxts:refresh();
		end
		
		
	end
	
	function localGroup:showOwn()
		local load_str = loadFile("scores_local.json");
		if(load_str)then
			localGroup:handleScoresData(load_str);
		end
	end
	function localGroup:showOwnOnEmpty(joined)
		--local load_str = loadFile("scores_local.json");
		localGroup[joined.."callback"] = function()
			localGroup:showOwn();
		end
	end
	
	
	
	function localGroup:fetchQuery(query, prm, sort, joined)
		if(royal.db==nil)then
			local firebase = require('firebase');
			royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
		end
		
		if(joined)then
			if(localGroup[joined]==nil)then localGroup[joined]=0; end
			localGroup[joined] = localGroup[joined] + 1;
		end
		
		cleanGroup(scoresall);
		local txt1 = display.newText(scoresall, get_txt("loading"), 0, 50*scaleGraphics, fontMain, 14*scaleGraphics);
		
		royal.db:get(db_id, query, function(event)
			if(event.isError)then
				print("Network error!");
			else
				localGroup:handleScoresData(event.response, prm, sort, joined);
			end
			
			if(joined)then
				localGroup[joined] = localGroup[joined] - 1;
				if(localGroup[joined]<1)then
					if(scorestxts.list==nil or #scorestxts.list==0)then
						if(localGroup[joined.."callback"])then
							localGroup[joined.."callback"](prm, sort);
						end
					end
				end
			end
		end);
	end
	function localGroup:fetchScores(prm)
		if(royal.db==nil)then
			local firebase = require('firebase');
			royal.db = firebase('https://royal-booty-quest-58014585.firebaseio.com/');
		end
		
		cleanGroup(scoresall);
		local txt1 = display.newText(scoresall, get_txt("loading"), 0, 50*scaleGraphics, fontMain, 14*scaleGraphics);
		
		royal.db:get(db_id, '?orderBy="'..prm..'"&limitToLast=100', function(event)
			if(event.isError)then
				print("Network error!");
			else
				localGroup:handleScoresData(event.response, prm);
			end
		end);
	end
	
	if(save_obj.donation)then
		local ico = display.newImage(localGroup, "image/gui/win_"..save_obj.donation..".png");
		ico:scale(scaleGraphics/2, scaleGraphics/2);
		ico.x, ico.y = _W - ico.contentWidth/2, _H - ico.contentHeight/2;
	end
end