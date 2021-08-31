module(..., package.seeall);

function inject(localGroup, buttons)
	local keys = {};
	
	local function hit_test_rec_ex(mcx,mcy,w,h,tx,ty)
		--if(mcx and mcy)then
			if(tx>mcx-w/2 and tx<mcx+w/2)then
				if(ty>mcy-h/2 and ty<mcy+h/2)then
					return true
				end
			end
		--end
		return false
	end
	local function get_dd_ex(x1,y1,x2,y2)
		local dx=x2-x1;
		local dy=y2-y1;
		return dx*dx+dy*dy;
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
				
				local disabled = false;
				if(mc.disabled)then
					if(mc.disabled==true or mc.disabled==false)then
						disabled = mc.disabled;
					else
						disabled = mc:disabled();
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
	
	local function touchHandler(e)
		local phase = e.phase;
		local gx, gy = e.x, e.y;
		if(phase=='began')then
			tryNearestButton(buttons, gx, gy);
		elseif(phase=='moved')then
			tryNearestButton(buttons, gx, gy);
		else
			local tar = tryNearestButton(buttons, gx, gy);
			if(tar)then
				if(tar.act)then
					tar:act();
					tar._selected = false;
					if(tar.onOut)then
						tar:onOut();
					end
				end
			end
		end
	end
	localGroup:addEventListener('touch', touchHandler);
	
	local removeMe, mouseE, mouseX, mouseY;
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
	end
	local function turnHandler(e)
		if(localGroup.removeSelf==nil)then
			removeMe();
			return
		end
		
		if(mouseE)then
			tryNearestButton(buttons, mouseX, mouseY);
			mouseE = nil;
		end
	end
	removeMe = function()
		Runtime:removeEventListener("mouse", mouseHandler);
		Runtime:removeEventListener("enterFrame", turnHandler);
	end
	Runtime:addEventListener("mouse", mouseHandler);
	Runtime:addEventListener("enterFrame", turnHandler);
end