module(..., package.seeall);

function new(tar)
	local gfx_mc = display.newGroup();
	if(tar)then
		tar:insert(gfx_mc);
	end
	
	function gfx_mc:addGfx(_x, _y, _id, scale)
		return addGfxEx(gfx_mc, _x, _y, _id, scale);
	end
	
	function gfx_mc:addGfxImage(path, _x, _y, ttl, tty, ttr, ttscale)
		local mc = display.newGroup();
		mc.xScale, mc.yScale = scaleGraphics/3, scaleGraphics/3;
		mc.x, mc.y = _x, _y;
		mc.isPlaying = true;
		mc.tta = true;
		mc.ttl = ttl;
		mc.tty = tty;
		mc.ttr=ttr;
		mc.ttscale=ttscale;
		local img = display.newImage(path);
		img.x, img.y = 0,0;
		mc:insert(img);
		gfx_mc:insert(mc);
		return mc;
	end
	
	function gfx_mc:addMiniTxt(_x, _y, txt)
		-- local mc = eliteText:newOutlinedText(gfxmc, txt, _x, _y, thisFont, 18, c1, c2);
		local mc = newOutlinedText(gfx_mc, txt, _x, _y, fontMain, 16*scaleGraphics, 1, 0, 1);
		mc.isPlaying = true;
		mc.tty = -3;
		mc.ttl = 48;
		mc.tta = true;
		return mc;
	end
	
	function gfx_mc:turn(dtime)
		for i=gfx_mc.numChildren, 1, -1 do
			local gmc = gfx_mc[i]
			if(gmc.ttr)then
				gmc.rotation = gmc.rotation+gmc.ttr;
			end
			if(gmc.ttscale)then
				gmc.xScale = gmc.xScale*(1-gmc.ttscale);
				gmc.yScale = gmc.yScale*(1-gmc.ttscale);
			end
			if(gmc.tta)then
				if(gmc.tty)then
					gmc.y = gmc.y+gmc.tty;
				end
				if(gmc.ttl<1)then
					if(gmc.alpha<0.001)then
						gmc.isPlaying = false;
						gmc.tta = false;
					else
						gmc.alpha = gmc.alpha*0.95;
					end
				else
					gmc.ttl = gmc.ttl-1;
				end
			end
			if(gmc.light)then
				gmc:turnHandler(dtime);
			end
			if(gmc.ttt)then
				if(gmc.ttl>1)then
					gmc.ttl = gmc.ttl-1;
					-- print("gfx_mc.numChildren:", gfx_mc.numChildren);
					if(gfx_mc.numChildren>5)then
						gmc.ttl = gmc.ttl-1;
					end
					if(gfx_mc.numChildren>10)then
						gmc.ttl = gmc.ttl-1;
					end
				else
					gmc.isPlaying = false;
					gmc.ttt = false;
				end
			end
			-- print("_gmc.isPlaying:", gmc.sequence, gmc.isPlaying);
			if(gmc.isPlaying==false)then
				gmc:removeSelf();
			end
		end
	end
	
	return gfx_mc
end