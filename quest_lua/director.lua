module( ..., package.seeall ); -- home - royal heroes 2.0

local old_mc = nil;
local old_name = nil;
function director:purgeListeners(attr)
	for i, v in pairs(Runtime) do
		-- or i=='_enterFrameTweens' i=='_tableListeners' or 
		if(i=='_functionListeners')then
			for ii, vv in pairs(v) do
				for iii, vvv in pairs(vv) do
					if(ii == attr)then
						-- print('removing:', i, ii, iii, type(vvv));
						Runtime:removeEventListener(attr, vvv);
					end
				end
			end
		end
	end
end
function director:cleanListeners() --this function will clean up some weird duplicates, that removeEventListener can NOT handle on its own
	for i, v in pairs(Runtime) do
		if(i=='_functionListeners')then
			for ii, vv in pairs(v) do
				for iii, vvv in pairs(vv) do
					for jjj, nnn in pairs(vv) do
						if(iii~=jjj and vvv==nnn)then
							vv[jjj] = nil;
						end
					end
				end
			end
		end
	end
end

local backbg;
function director:changeScene(prs, moduleName)
	if(moduleName==nil)then
		moduleName = prs;
		prs = nil;
	end
	if(old_mc)then
		if(old_mc.removeAll)then
			old_mc:removeAll();
			old_mc.removeAll = nil;
		end
		old_name = old_mc.name;
		old_mc.dead = true;
		old_mc:removeSelf();
		old_mc = nil;
	end

	old_mc = require(moduleName).new(prs);
	mainGroup.parent:insert(1, old_mc);
	if(director.border)then
		mainGroup.parent:insert(director.border);
	end
	
	if(backbg)then
		if(backbg.removeSelf)then
			backbg:removeSelf();
		end
	end
	backbg = display.newRect(_W/2, _H/2, _W*2, _H*2);
	backbg:setFillColor(0);
	backbg:toBack();
end
function director:getCurrHandler()
	return old_mc;
end
function director:getOldSceneName()
	return old_name;
end
function director:showSaveBorder()
	local border = display.newGroup();
	local sizew,sizeh = options_save_border_w*scaleGraphics, options_save_border_h*scaleGraphics;
	
	local rect = display.newRect(border, _W/2, sizeh/2, _W, sizeh);
	rect:setFillColor(0,1,0,0.3);
	local rect = display.newRect(border, _W/2, _H - sizeh/2, _W, sizeh);
	rect:setFillColor(0,1,0,0.3);
	
	local rect = display.newRect(border, sizew/2, _H/2, sizew, _H-sizeh*2);
	rect:setFillColor(0,1,0,0.3);
	local rect = display.newRect(border, _W-sizew/2, _H/2, sizew, _H-sizeh*2);
	rect:setFillColor(0,1,0,0.3);
	
	director.border = border;
	mainGroup.parent:insert(director.border);
end