module(..., package.seeall);
-- eliteLoading 1.000, main project - Royal Heroes

function new(parentGroup)
	local localGroup = display.newGroup();
	
	--words to translate:
	--loading
	--error
	--press_any_to_continue
	--tap_to_close
	
	--globals:
	--loading_wnd
	--loaderShow
	--loaderClose
	--show_loading
	--hide_loading
	
	--local loading_wnd;
	_G.loading_set_text = function(txt)
		if(_G.loading_wnd)then
			local fade_mc = _G.loading_wnd;
			fade_mc.dtxt.text = txt;
		end
	end
	_G.show_loading = function(ttl, appeartime)
		if(_G.loading_wnd)then
			return
		end
		if(ttl==nil)then ttl=13000;end
		if(appeartime==nil)then appeartime=500; end
		local fade_mc = display.newGroup();
		_G.loading_wnd=fade_mc;
		parentGroup.parent:insert(fade_mc);
		local fade_in = display.newRect(fade_mc, _W/2, _H/2, _W, _H);
		fade_in:setFillColor(0,0,0);
		local loading_dtxt = display.newText(fade_mc, get_txt('loading'), 0, 30, fontMain, 24*scaleGraphics);
		loading_dtxt.anchorX, loading_dtxt.anchorY = 0.5,0.5;
		loading_dtxt:setTextColor(1,1,1);
		loading_dtxt.x, loading_dtxt.y = _W/2, _H - 40*scaleGraphics;
		transition.from(fade_mc, {alpha=0, time=appeartime, transition=easing.inQuad});
		fade_mc.dtxt = loading_dtxt;
		if(ttl~=0)then
			timer.performWithDelay(ttl,function()
				if(fade_mc.dead ~= true and fade_mc.removeSelf)then
					loading_dtxt.text = get_txt('error');
					local loading_dtxt = display.newText(fade_mc, "---", 0, 30, fontMain, 12*scaleGraphics);
					loading_dtxt.anchorX, loading_dtxt.anchorY = 0.5,0.5;
					loading_dtxt:setTextColor( 1,1,1);
					loading_dtxt.x, loading_dtxt.y = _W/2, _H - 20*scaleGraphics;
					
					if(options_console)then
						loading_dtxt.text = get_txt('press_any_to_continue');
					else
						loading_dtxt.text = get_txt('tap_to_close');
					end
					
					function error_key_handler(evt)
						if(evt.phase=='down')then
							hide_loading();
							Runtime:removeEventListener( "key", error_key_handler);
						end
					end
					fade_mc:addEventListener( "touch", function(evt)
						if(evt.phase=='ended')then
							Runtime:removeEventListener( "key", error_key_handler);
							hide_loading();
						end
					end);
					
					Runtime:addEventListener( "key", error_key_handler);
				end
			end);
		end
	end
	_G.loader_add_logo = function(path)
		if(_G.loading_wnd)then
			local img = display.newImage(_G.loading_wnd, path);
			img.x, img.y = _W/2, _H/2;
		end
	end
	_G.hide_loading = function(act)
		if(_G.loading_wnd)then
			_G.loading_wnd.dead = true;
			transition.to(_G.loading_wnd,{alpha=0, time=300, transition=easing.inQuad, onComplete=function(obj)
				if(act)then
					act();
				end
				transitionRemoveSelfHandler(obj);
				_G.loading_wnd = nil;
			end});
		end
	end
	_G.loaderShow = function()
		show_loading();
	end
	_G.loaderClose = function(act)
		hide_loading(act)
	end
	
	return localGroup;
end