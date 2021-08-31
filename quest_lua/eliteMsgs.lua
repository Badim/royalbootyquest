print("eliteMsgs 1.91");
module(..., package.seeall);

function new()
	local _mc = display.newGroup();
	local _list = {};
	local old_time = system.getTimer();
	
	function _mc:remove_msg_by_string(str)
		for i=#_list,1,-1 do
			local msg_mc = _list[i];
			if(msg_mc.txt:find(str, 1))then
				msg_mc.ttl = -1;
			end
		end
	end
	
	function _mc:refresh()	
		old_time = system.getTimer();
		Runtime:removeEventListener("enterFrame", turn);
		Runtime:addEventListener("enterFrame", turn);
	end
	
	
	
	function _mc:show_msg(txt)
		for i=1,#_list do
			local msg_mc = _list[i];
			if(msg_mc.dtxt.text == txt)then
				msg_mc.ttl = -1;
				msg_mc.aspeed = msg_mc.aspeed*2;
			end
		end
		local dtxt = display.newText(txt, 0, 0, fontMain, 10*scaleGraphics);
		dtxt.y = options_txt_offset;
		--dtxt.anchorX = 0.5;
		
		dtxt:setTextColor( 250,250,250); 

		local dark_mc = display.newRoundedRect(0, 0, dtxt.width+2*scaleGraphics, 31, 4*scaleGraphics);
		--dark_mc.x = dark_mc.width/2;
		dark_mc:setFillColor(0,0,0);
		dark_mc.alpha = 0.8;
		
		local msg_mc=display.newGroup();
		msg_mc.ttl = 7000+#_list*100;
		msg_mc.x = _W/2;
		msg_mc.y = #_list*32;
		msg_mc:insert(dark_mc);
		msg_mc:insert(dtxt);
		msg_mc.dtxt = dtxt;
		msg_mc.aspeed = 1;
		
		msg_mc.txt = txt;
		
		table.insert(_list, msg_mc);
		_mc:insert(msg_mc);
		_mc:refresh();
	end
	
	local function clear()
		for i=#_list,1,-1 do
			local msg_mc = _list[i];
			if(msg_mc.alpha <=0)then
				local mc = table.remove(_list, i);
				mc:removeSelf();
			end
		end
		if(#_list>0)then
			for i=1,#_list do
				local msg_mc = _list[i];
				msg_mc.y = (i-1)*32;
			end
		end
	end
	
	function turn(evt)
		local dtime = system.getTimer() - old_time;
		old_time = system.getTimer();
		for i=1,#_list do
			local msg_mc = _list[i];
			msg_mc.ttl = msg_mc.ttl - dtime;
			if(msg_mc.ttl <0)then
				local new_alpha = msg_mc.alpha - dtime*msg_mc.aspeed/1500;
				if(new_alpha<0)then
					msg_mc.alpha = 0;
				else
					msg_mc.alpha = new_alpha;
				end
			end
		end
		
		clear();
		
		if(#_list>0)then
			if(_list[1].alpha <=0)then
				local mc = table.remove(_list, 1);
				mc:removeSelf();
				if(#_list>0)then
					for i=1,#_list do
						local msg_mc = _list[i];
						msg_mc.y = (i-1)*32;
					end
				end
			end
		end
		if(#_list == 0)then
			Runtime:removeEventListener("enterFrame", turn);
		end
	end
	
	_mc:addEventListener("touch", function(e)
		for i=1,#_list do
			local msg_mc = _list[i];
			msg_mc.ttl = msg_mc.ttl - 99999;
		end
	end);
	
	old_time = system.getTimer();
	Runtime:removeEventListener("enterFrame", turn);
	Runtime:addEventListener("enterFrame", turn);
	
	return _mc
end