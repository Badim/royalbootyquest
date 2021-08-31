module(..., package.seeall);

function new()
	local _mc = display.newGroup();
	
	local fps_val =0;
	local fps_t = 0;
	local memUsageMax=0;
	local textureMemMax =0;

	local _this_w = 130;
	local _this_h = 150;
	
	local dark_mc = display.newRect(_mc, 0, 0, _this_w, _this_h);
	dark_mc.x, dark_mc.y = 0,0;
	dark_mc:setFillColor(0,0,0);
	dark_mc.alpha = 0.8;
	
	local tfDebug5 = display.newText( _mc,"", 0, -30, nil, 20 );
	tfDebug5:setTextColor( 250,250,250); 
	local tfMemory1 = display.newText(_mc, "", 0, 0, nil, 20 );
	tfMemory1:setTextColor( 250,250,250); 
	local tfMemory2 = display.newText(_mc, "", 0, 30, nil, 20 );
	tfMemory2:setTextColor( 250,250,250); 
	
	local code_max = 0;
	local tfMemory3 = display.newText(_mc,  "---", 0, 60, nil, 20 );
	tfMemory3:setTextColor( 250,250,250); 
	
	local listeners_max = 0;
	local tfMemory4 = display.newText(_mc,  "---", 0, 90, nil, 20 );
	tfMemory4:setTextColor( 250,250,250); 
	
	_mc.h = _this_h;
	

	
	local list = {tfDebug5, tfMemory1, tfMemory2, tfMemory3, tfMemory4};
	for i=1,#list do
		local mc = list[i];
		mc.y = 30*(i-1) - (#list-1)*30/2;
	end
	
	local old_time = system.getTimer();
	function turn()
		local dtime = system.getTimer() - old_time;
		old_time = system.getTimer();
		fps_val = fps_val+1;
		fps_t = fps_t + dtime;
		if(fps_t > 1000)then
			fps_t = fps_t - 1000;
			tfDebug5.text = 'fps: '..fps_val;
			fps_val =0;
			-------
			local curUsage = math.floor(collectgarbage("count")/1024);
			memUsageMax = math.max(curUsage,memUsageMax);
			local curTextureMemMax = math.floor(system.getInfo( "textureMemoryUsed" ) / (1024*1024));
			textureMemMax = math.max(curTextureMemMax,textureMemMax);
			tfMemory1.text=( "core: " .. curUsage..'/'..memUsageMax );
			tfMemory2.text=( "tex: " .. curTextureMemMax..'/'..textureMemMax );
			-------
			local counter = 0;
			for i, v in pairs(_G) do
				counter = counter+1;
				if(type(v)=='table')then
					for ii, vv in pairs(v) do
						counter = counter+1;
					end
				end
			end
			code_max = math.max(counter, code_max);
			tfMemory3.text=("G: " .. counter..'/'..code_max );
			-------
			local lcounter = 0;
			for i, v in pairs(Runtime) do
				-- or i=='_enterFrameTweens' --i=='_tableListeners' or 
				if(i=='_functionListeners')then
					for ii, vv in pairs(v) do
						for iii, vvv in pairs(vv) do
							lcounter = lcounter+1;
						end
					end
				end
			end
			listeners_max = math.max(lcounter, listeners_max);
			tfMemory4.text=("L: " .. lcounter..'/'..listeners_max);
		end
	end
	
	Runtime:addEventListener( "enterFrame", turn );

	return _mc
end