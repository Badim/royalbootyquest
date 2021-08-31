module(..., package.seeall);
-- version 1.02 - home at Royal Heroes

if(_G.mainGroup==nil)then
	_G.mainGroup = display.newGroup();
end

_G.hintGroup = newGroup(_G.mainGroup);
function _G.removeHint(utype)
	if(hintGroup.utype == utype or utype==nil)then
		if(hintGroup.tfHint)then
			hintGroup.tfHint.isVisible = false;
		end
		if(hintGroup.dark_mc)then
			hintGroup.dark_mc.isVisible = false;
		end
	end
end
function _G.addHint(txt, utype)
	if(txt)then
		if(hintGroup.iy ~= hintGroup.y or hintGroup.displayH ~= _H or hintGroup.scaleGraphics ~= scaleGraphics)then
			if(hintGroup.tfHint)then
				hintGroup.tfHint:removeSelf();
				hintGroup.tfHint = nil;
			end
			if(hintGroup.dark_mc)then
				hintGroup.dark_mc:removeSelf();
				hintGroup.dark_mc = nil;
			end
		end
		
		if(hintGroup.tfHint)then
			hintGroup.tfHint.text = txt;
			hintGroup.tfHint.isVisible = true;
			hintGroup.dark_mc.isVisible = true;
		else
			local _this_h = 20*scaleGraphics - hintGroup.y;
			local dark_mc = display.newRect( 0, 0, _W, _this_h);
			dark_mc:setFillColor(0,0,0);
			dark_mc.alpha = 0.65;
			hintGroup:insert(dark_mc);
			local tfHint = display.newText( txt, 0, 0, fontMain, 16*scaleGraphics);
			tfHint:setTextColor( 255,255,255 );
			tfHint.x = _W/2;
			tfHint.y = _H - tfHint.height/2+options_txt_offset;
			dark_mc.x, dark_mc.y = tfHint.x, tfHint.y+2 -hintGroup.y/2;
			hintGroup:insert(tfHint);
			
			hintGroup.tfHint = tfHint;
			hintGroup.dark_mc = dark_mc;
			hintGroup.iy = hintGroup.y;
			hintGroup.displayH = _H;
			hintGroup.scaleGraphics = scaleGraphics;
		end
		hintGroup.utype = utype;
		mainGroup:insert(hintGroup);
	end
end