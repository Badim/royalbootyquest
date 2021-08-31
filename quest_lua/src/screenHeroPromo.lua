module(..., package.seeall);

function new(scene_prms)	
	local localGroup = display.newGroup();
	localGroup.name = "promo";
	
	local brect = display.newRect(localGroup, _W/2, _H/2, _W*2, _H*2);
	brect:setFillColor(0);
	
	local background = display.newImage(localGroup, "image/background/tavern.jpg");
	background.alpha = 0.30;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	localGroup.buttons = {};
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	function localGroup:actEscape()
	-- local btn = display.newImage(facemc, "image/button/cancel.png", _W - 20*scaleGraphics, 20*scaleGraphics);
	-- btn:scale(scaleGraphics/2, scaleGraphics/2);
	-- elite.addOverOutBrightness(btn);
	-- btn.w, btn.h = btn.contentWidth, btn.contentHeight;
	-- table.insert(localGroup.buttons, btn);
	-- btn.act = function()
		show_start();
	-- end
	end
	
	local sx, sy = _W/2, _H-100*scaleGraphics;
	
	local avatar = display.newImage(facemc, "image/chibis/"..scene_prms.scin..".png");
	avatar:scale(scaleGraphics/4, scaleGraphics/4);
	avatar.x, avatar.y = _W/2, _H - avatar.contentHeight/2 + 10*scaleGraphics;
	transitionBlink(avatar, 0.2);
	
	
	function localGroup:iniBtn(path, tx, ty, hint, act)
		local btn = display.newImage(facemc, path);
		btn:scale(scaleGraphics/2, scaleGraphics/2);
		btn.x, btn.y = tx, ty;
		btn.w, btn.h = btn.contentWidth, btn.contentHeight;
		table.insert(localGroup.buttons, btn);
		elite.addOverOutBrightness(btn);
		-- btn.hint = hint;
		btn.act = act;
		return btn;
	end
	
	function localGroup:actSpace()
	-- local btn = localGroup:iniBtn("image/button/refresh.png", _W - 60*scaleGraphics, 20*scaleGraphics, get_txt('refresh'), function()
		if(avatar)then avatar:removeSelf(); end
		avatar = nil;
		
		if(math.random()>0.5 and false)then
			sy = _H-100*scaleGraphics;
			pixelArtOn();
			avatar = display.newImage(facemc, "image/unitsIco/"..scene_prms.scin..".png");
			avatar:scale(scaleGraphics*2, scaleGraphics*2);
			avatar.x, avatar.y = _W/2, _H - avatar.contentHeight/2-10*scaleGraphics;
			pixelArtOff();
		elseif(math.random()>0.5 or true)then
			sy = _H-100*scaleGraphics;
			avatar = display.newImage(facemc, "image/avatars/"..scene_prms.scin..".png");
			avatar:scale(scaleGraphics/2, scaleGraphics/2);
			avatar.x, avatar.y = _W/2, _H - avatar.contentHeight/2-0*scaleGraphics;
		else
			sy = _H-100*scaleGraphics;
			avatar = display.newImage(facemc, "image/chibis/"..scene_prms.scin..".png");
			avatar:scale(scaleGraphics/4, scaleGraphics/4);
			avatar.x, avatar.y = _W/2, _H - avatar.contentHeight/2-0*scaleGraphics;
		end
		gamemc:redraw(0, 180*scaleGraphics);
		if(avatar)then transitionBlink(avatar, 0.2); end
	-- end);
	end
	
	
	
	local lfs = require ( "lfs" )
	local path = system.pathForFile("temp/", system.ResourceDirectory);

	local pngFiles = {}
	if(path)then
		for file in lfs.dir ( path ) do
			if string.find(file, ".png") then
				if string.find(file, scene_prms.class.."_") then
					table.insert(pngFiles, file);
				end
			end
		end
	end
	table.shuffle(pngFiles);
	-- print(table.concat(pngFiles, ", "))
	
	local cardsmc = newGroup(gamemc);
	
	function gamemc:redraw(da, r)
		cleanGroup(cardsmc);
		
		local cards_l = math.min(#pngFiles, 10)
		for i=1,cards_l do
			local img = display.newImage(cardsmc, "temp/"..pngFiles[i]);
			img:scale(scaleGraphics/2, scaleGraphics/2);
			local a = (i - cards_l/2 - 0.5)*0.40-math.pi/2 + da;
			img.x, img.y = sx+r*math.cos(a), sy+r*math.sin(a)*0.8;
			local a = math.atan2(img.y-sy, img.x-sx);
			img.rotation = a*180/math.pi+90;
			-- local line = display.newLine(cardsmc, sx, sy, img.x, img.y);
			-- line:toBack();
		end
	end
	
	localGroup:addEventListener('touch1', function(e)
		local dx, dy = e.x - sx, e.y - sy;
		local d = math.sqrt(dx*dx + dy*dy);
		local a = math.atan2(dy, dx)+0.18;
		gamemc:redraw(a, d);
	end);
	gamemc:redraw(0, 180*scaleGraphics);
	
	local logomc = newGroup(facemc);
	logomc.x, logomc.y = _W/2, 50*scaleGraphics;
	local logobg = display.newImage(logomc, "image/gui/logo_bg.png");
	logobg:scale(scaleGraphics/2, scaleGraphics/2);
	-- logobg.x, logobg.y = _W/2, 50*scaleGraphics;
	
	local logo = display.newImage(logomc, "image/gui/logo1.png");
	logo:scale(scaleGraphics/2, scaleGraphics/2);
	-- logo.x, logo.y = logobg.x, logobg.y;
	logomc.act = function()
		logomc:removeSelf();
	end
	table.insert(localGroup.buttons, logomc);
	logomc.w, logomc.h = logobg.contentWidth, logobg.contentHeight;
	elite.addOverOutBrightness(logomc);
	
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end