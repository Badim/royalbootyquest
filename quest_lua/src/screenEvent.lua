module(..., package.seeall);

function new(scene_prms)	
	local localGroup = display.newGroup();
	localGroup.name = "event";
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	localGroup.buttons = {};
	facemc.buttons = localGroup.buttons;
	
	gamemc.dead = false;
	
	addTopBar(facemc, localGroup.buttons);
	
	local map_point = scene_prms.map_point;
	local event_obj = scene_prms.event_obj;
	if(event_obj==nil)then
		event_obj = table.random(events);
		for i=1,#events do
			if(events[i].lvl2==nil)then
				events[i].lvl2 = events[i].lvl;
			end
		end
		
		local tryes = 100;
		while(tryes>0 and event_obj.lvl~=login_obj.map.lvl and event_obj.lvl2~=login_obj.map.lvl and event_obj.lvl~="any")do
			tryes = tryes-1;
			event_obj = table.random(events);
		end
		if(map_point.tag)then
			for i=1,#events do
				if(events[i].tag == map_point.tag)then
					event_obj = events[i];
				end
			end
		end
	end
	local event_id = get_name_id(event_obj.tag);
	
	if(options_cheats)then
		local btn = display.newImage(facemc, "image/button/refresh.png");
		btn:scale(scaleGraphics/2, scaleGraphics/2);
		btn.x, btn.y = _W-btn.contentWidth/2, _H - btn.contentHeight/2;
		table.insert(localGroup.buttons, btn);
		btn.w, btn.h = btn.contentWidth, btn.contentHeight;
		elite.addOverOutBrightness(btn);
		btn.act = function()
			local new_obj = table.random(events);
			show_event(scene_prms.map_point, new_obj);
		end
	end
	
	local wndW, wndH = _W-100*scaleGraphics, _H - 180*scaleGraphics;
	local dltW = 30*scaleGraphics;
	
	local title = event_obj.tag;
	if(get_txt_force(event_id))then
		title = get_txt(event_id);
	end
	
	local wndmc = add_bg_title("bg_3", wndW, wndH, title, 6);
	wndmc.x, wndmc.y = _W/2, _H/2;
	gamemc:insert(wndmc);
	
	if(event_obj.avatar)then
		local ico = display.newImage(wndmc, "image/avatars/"..event_obj.avatar..".png");
		if(ico)then
			ico:scale(scaleGraphics/2, scaleGraphics/2);
			ico:translate(-wndW/2 + ico.contentWidth/2 + dltW, wndH/2 - ico.contentHeight/2 - 2*scaleGraphics);
			facemc.ico = ico;
		end
	else
		local ico = display.newImage(wndmc, "image/events/"..event_id..".png");
		if(ico==nil)then
			ico = display.newImage(wndmc, "image/events/_event.png");
		end
		ico:scale(scaleGraphics/2, scaleGraphics/2);
		ico:translate(-wndW/2 + ico.contentWidth/2 + dltW, wndH/2 - ico.contentHeight/2 - 10*scaleGraphics);
		facemc.ico = ico;
	end
	
	facemc.msgtxt = newGroup(wndmc); --newOutlinedText(wndmc, "", 0, -wndmc.h/2 + 30*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
	facemc._dtxt = nil
	function facemc.msgtxt:setText(txt)
		if(facemc._dtxt)then
			if(facemc._dtxt.parent)then
				facemc._dtxt:removeSelf();
				facemc._dtxt = nil;
			end
		end
		
		local dtxt = eliteText:newText(txt, wndW - 20*scaleGraphics, 12*scaleGraphics, false, false);
		dtxt.x, dtxt.y = -dtxt.w/2, -wndmc.h/2 + 10*scaleGraphics;
		wndmc:insert(dtxt);
		facemc._dtxt = dtxt;
		
		print("dtxt:", dtxt.y, dtxt.h, dtxt.y + dtxt.h);
		print("ico:", facemc.ico.y, facemc.ico.contentHeight, facemc.ico.y - facemc.ico.contentHeight/2);
		
		-- dtxt:-240	0	-240
		-- ico:	10	460	-220
		if(facemc.ico)then
			while(dtxt.y + dtxt.h > facemc.ico.y - facemc.ico.contentHeight/2 and facemc.ico.xScale>0.1)do
				facemc.ico:scale(0.95, 0.95);
				facemc.ico.y = wndH/2 - facemc.ico.contentHeight/2 - 10*scaleGraphics;
				print('fa')
			end
		end
	end
	
	if(options_cheats)then
		facemc.msgtxt:setText("Vo_Ov");
	end
	if(event_obj.msg)then
		facemc.msgtxt:setText(event_obj.msg);
	end

	facemc.extramc = newGroup(facemc);
	
	local optionW = wndW - 128*scaleGraphics - dltW*2;
	local actionsmc = newGroup(wndmc);
	actionsmc.x = (wndW - optionW)/2 - dltW;
	function facemc:handleActions(opts)
		cleanGroup(actionsmc);
		actionsmc.y = 0;
		
		local iy = 1;
		for i=1,#opts do
			local item_obj = opts[i];
			local optmc = add_bar("bar_xp2", optionW);
			optmc.y = iy * 22 * scaleGraphics;
			iy = iy + 1;
			optmc.yScale = optmc.yScale*1.1;
			optmc:setFillColor(1, 1, 1);
			actionsmc:insert(optmc);
			
			local arr = {item_obj.txt};
			-- print("event1:", item_obj.tag);
			handleOneAction(item_obj, arr);

			if(item_obj.rnd)then
				if(item_obj.rnd.hidden~=true)then
					local prefix = item_obj.rnd.chance.."%: ";
					handleOneAction(item_obj.rnd, arr, prefix);
				end
			end

			if(item_obj.search)then
				local txt = get_txt("event_search_txt");
				if(facemc.search==nil)then
					facemc.search = item_obj.search;
					facemc.loots = table.cloneByAttr(event_obj.loots);
				end
				txt = txt:gsub("VAL", facemc.search);
				table.insert(arr, txt);
			end
			local prefix = table.remove(arr, 1);
			local text = prefix;
			if(#arr>0)then
				text = prefix.." "..table.concat(arr, ", ")..".";
			end

			local txt = newOutlinedText(actionsmc, text, optmc.x, optmc.y-1*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
			item_obj.dtxt = txt;
			-- print("_width1:", #arr, txt.width, txt.width > optmc.contentWidth);
			if(txt.width > optmc.contentWidth)then
				optmc.yScale = optmc.yScale*2;
				optmc.y = optmc.y + 5*scaleGraphics;
				iy = iy + 0.5;

				local txt2 = newOutlinedText(actionsmc, "text", optmc.x, optmc.y-1*scaleGraphics + 6*scaleGraphics, fontMain, 10*scaleGraphics, 1, 0, 1);
				item_obj.dtxt2 = txt2;
				
				item_obj.dtxt:setText(prefix);
				item_obj.dtxt2:setText(table.concat(arr, ", "));
				
				item_obj.dtxt.y  =  optmc.y-7*scaleGraphics;
				item_obj.dtxt2.y =  optmc.y+7*scaleGraphics;
				-- print("_width2:", #arr, txt.width, txt.width > optmc.contentWidth);
				if((txt.width > optmc.contentWidth or item_obj.dtxt2.width > optmc.contentWidth) and #arr > 1)then
					local arr1 = table.remove(arr, 1);
					item_obj.dtxt:setText(prefix.." "..arr1);
					item_obj.dtxt2:setText(table.concat(arr, ", "));
				end
			end
			
			if(item_obj.price)then
				if(item_obj.price.cost)then
					if(item_obj.price.cost.relic)then
						if(login_obj.relics[item_obj.price.cost.relic]==nil)then
							txt.alpha = 0.5;
						end
					end
					if(item_obj.price.cost.money)then
						if(login_obj.money<item_obj.price.cost.money)then
							txt.alpha = 0.5;
						end
					end
					if(item_obj.price.cost.card)then
						if(countCardsByTag(item_obj.price.cost.card)<1)then
							txt.alpha = 0.5;
						end
					end
				end
			end
			
			if(item_obj.disabled)then
				if(options_cheats)then
					txt:setTextColor(0.9, 0.2, 0.1);
					item_obj.disabled = nil;
				else
					txt.alpha = 0.5;
				end
				optmc:setFillColor(1/4, 1/4, 1/4);
			end
			
			optmc.act = function(e)
				if(txt.alpha<0.9 or item_obj.disabled==true)then
					return
				end
				handle_action(item_obj, optmc.x, optmc.y, facemc);
			end
			table.insert(localGroup.buttons, optmc);
			optmc.w, optmc.h = optionW, math.max(optmc.contentHeight, 20*scaleGraphics);
			if(item_obj.hint)then
				optmc.hint = item_obj.hint;
			end
			function optmc:disabled()
				return facemc.wnd~=nil;
			end
			function optmc:onOver()
				if(txt.alpha<0.9 or item_obj.disabled==true)then
					return
				end
				txt:setTextColor(1/2, 1, 1/2);
			end
			function optmc:onOut()
				txt:setTextColor(1, 1, 1);
			end
		end
		
		-- print("_actionsmc.height:", actionsmc.height);
		if(actionsmc.numChildren>0)then
			actionsmc.y = wndmc.h/2 - actionsmc.height - 2*scaleGraphics - actionsmc[1].y;
		end
		-- actionsmc.y = wndmc.h/2;
		
		-- local sx, sy = actionsmc.x, actionsmc.y;
		-- local aw, ah = actionsmc.width/2, actionsmc.height/2;

		-- local l = display.newLine(wndmc, sx-aw, sy-ah, sx+aw, sy+ah);
		-- local l = display.newLine(wndmc, sx-aw, sy+ah, sx+aw, sy-ah);
	end
	
	local opts = event_obj.actions;
	facemc:handleActions(opts);
	
	function localGroup:onCloseHandler()
		for i=1,actionsmc.numChildren do
			actionsmc[i].disabled = true;
		end
	end
	
	function localGroup:actEscape()
		facemc:pause_switch();
		return true;
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end