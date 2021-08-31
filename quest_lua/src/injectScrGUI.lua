module(..., package.seeall);
-- inject 1.03 home ???

function inject(localGroup, buttons)
	local keys = {};
	
	local draging = nil;
	local removeMe, mouseE, mouseX, mouseY;
	
	function localGroup:getDraging()
		return draging;
	end
	
	-- stuff to ini - but from other classes
	if(hintGroup==nil)then hintGroup="map"; end
	if(get_dd_ex==nil)then
		function _G.get_dd_ex(x1,y1,x2,y2)
			local dx=x2-x1;
			local dy=y2-y1;
			return dx*dx+dy*dy;
		end
	end
	if(hit_test_rec_ex==nil)then
		function _G.hit_test_rec_ex(mcx, mcy, w, h, tx, ty)
			if(tx>mcx-w/2 and tx<mcx+w/2)then
				if(ty>mcy-h/2 and ty<mcy+h/2)then
					return true
				end
			end
			return false
		end
	end
	if(addHint==nil)then
		function _G.addHint()
		end
		function _G.removeHint()
		end
	end
	
	local function getNearestButton(list, gx, gy)
		local tar = nil;
		local mindd = 99999999999;
		for i=#list,1,-1 do
			local mc = list[i];
			if(mc.removeSelf)then
				local tx, ty = mc.x, mc.y;
				tx, ty = mc:localToContent(0, 0);
				local dd = get_dd_ex(tx, ty, gx, gy);
				
				local disabled = not mc.isVisible;
				if(mc.disabled)then
					if(mc.disabled==true or mc.disabled==false)then
						disabled = mc.disabled;
					else
						disabled = disabled or mc:disabled();
					end
				end
				
				if(dd<mindd and disabled==false)then
					if(mc.r)then
						local rr = mc.r*mc.r;
						if(dd<rr)then
							tar = mc;
							mindd = dd;
						end
					else
						if(hit_test_rec_ex(tx, ty, mc.w, mc.h, gx, gy))then
							tar = mc;
							mindd = dd;
						end
					end
				end
			else
				table.remove(list, i);
			end
		end
		return tar;
	end
	local function tryNearestButton(list, gx, gy)
		local tar = getNearestButton(list, gx, gy);
		if(tar)then
			if(tar._selected~=true)then
				tar._selected=true;
				if(tar.onOver)then
					tar:onOver();
				end
				addHint(tar.hint, 'map');
			end
		end
		for i=1,#list do
			local mc = list[i];
			if(mc~=tar)then
				if(mc._selected)then
					mc._selected = false;
					if(mc.onOut)then
						mc:onOut();
					end
				end
			end
		end
		if(tar==nil)then
			removeHint('map');
		end
		return tar
	end
	
	local oldX, oldY = 0, 0;
	local sX, sY = 0, 0;
	local function touchHandler(e)
		local phase = e.phase;
		local dx, dy = e.x-oldX, e.y-oldY;
		local gx, gy = e.x, e.y;
		oldX, oldY = e.x, e.y;

		if(phase=='began')then
			local tar = tryNearestButton(buttons, gx, gy);
			if(tar)then
				if(tar.dragable)then
					draging = tar;
					tar.__draging = true;
					if(draging.onPick)then
						draging:onPick();
					end
				end
			end
			sX, sY = e.x, e.y;
		elseif(phase=='moved')then
			mouseE = e;
			mouseX, mouseY = e.x, e.y;
		
			if(draging)then
				local ndx, ndy = dx, dy;
				if(draging.lockedX)then ndx = 0; end
				if(draging.lockedY)then ndy = 0; end
				if(draging.translate)then
					draging:translate(ndx, ndy);
				end
			else
				tryNearestButton(buttons, gx, gy);
			end
		else
			local sd = distanceEx(sX, sY, e.x, e.y);
			local r = nil;
			-- print("_e.x, e.y:", sd);
			if(sd<24)then
				local tar = tryNearestButton(buttons, gx, gy);
				if(tar)then
					if(tar.act)then
						r = tar:act(mouseX, mouseY);
						tar._selected = false;
						if(tar.onOut)then
							tar:onOut();
						end
						if(tar.actTut)then
							tar:actTut();
						end
					end
				end
			end
			if(draging)then
				draging.__draging = nil;
				if(draging.onDrop)then
					draging:onDrop();
				end
			end
			draging = nil;
			return r;
		end
	end
	localGroup:addEventListener('touch', touchHandler);
	
	local function keyHandler(e)
		if(e.phase=="down")then
			-- print("_inject:", e.keyName);
			if(e.keyName=="escape" or e.keyName=="back")then
				if(localGroup.actEscape)then
					localGroup:actEscape();
					return true;
				end
			end
			if(e.keyName=="space")then
				if(localGroup.actSpace)then
					localGroup:actSpace();
					return true;
				end
			end
		end
	end
	local function mouseHandler(e)
		if(localGroup.removeSelf==nil)then
			removeMe();
			return
		end
		mouseE = e;
		mouseX, mouseY = e.x, e.y;
		
		if(keys["mouseright"]~=true and e.isSecondaryButtonDown)then
			if(localGroup.actRight)then
				localGroup:actRight();
			end
		end
		keys["mouseright"] = e.isSecondaryButtonDown==true;
		
		-- print("_e:", e, e.scroll);
		-- for attr, val in pairs(e) do
			-- print(attr, val);
		-- end
		if(e.scrollY~=0)then
			if(localGroup.onScroll)then
				localGroup:onScroll(e.scrollY);
			end
		end
	end
	local function turnHandler(e)
		if(localGroup.removeSelf==nil)then
			removeMe();
			return
		end
		
		if(mouseE)then
			if(draging)then
				if(draging.onMove)then
					draging:onMove();
				end
			else
				tryNearestButton(buttons, mouseX, mouseY);
			end
			mouseE = nil;
		end
	end
	removeMe = function()
		Runtime:removeEventListener("mouse", mouseHandler);
		Runtime:removeEventListener("enterFrame", turnHandler);
		Runtime:removeEventListener("key", keyHandler);
	end
	Runtime:addEventListener("mouse", mouseHandler);
	Runtime:addEventListener("enterFrame", turnHandler);
	Runtime:addEventListener("key", keyHandler);
end