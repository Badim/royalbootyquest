module(..., package.seeall);
-- eliteButton - Royal Booty Quest! 1.00

function new(par, buttons)
	local btn = newGroup(par);
	local callback;
	local hint_txt;
	local bg_mc;
	-- local tw,th = 10,10;
	function btn:addBG(img_path)
		local bg_mc = display.newImage(btn, img_path);
		bg_mc.x, bg_mc.y = 0,0;
		btn.body = bg_mc;
		
		table.insert(buttons, btn);
		btn.w, btn.h = bg_mc.contentWidth, bg_mc.contentHeight;
		-- print("btn.w, btn.h", btn.w, btn.h);
		btn.addBG = nil;
		
		elite.addOverOutBrightness(btn);
	end
	function btn:adjust()
		if(btn.body)then
			btn.w, btn.h = btn.body.contentWidth, btn.body.contentHeight;
			-- print("btn.w, btn.h", btn.w, btn.h);
		end
	end
	function btn:addHint(txt)
		hint_txt = txt;
	end
	function btn:addCallback(_callback)
		callback = _callback;
		btn.act = callback;
	end
	
	-- function touchHandler(evt)
		-- local phase = evt.phase;
		-- if(phase=='began' or phase=='moved')then
			-- if(addHint)then
				-- addHint(hint_txt)
				-- return true
			-- end
		-- end
		-- if(phase=='ended')then
			-- if(callback)then
				-- sound_play("pack_click");
				-- callback();
				-- return true
			-- end
		-- end
	-- end
	
	-- function btn:freeMe()
		-- btn:removeEventListener( "touch", touchHandler);
	-- end
	
	-- btn:removeEventListener( "touch", touchHandler);
	-- btn:addEventListener( "touch", touchHandler);
	return btn;
end