module(..., package.seeall);

_G.tutorials = {};

local scale = scaleGraphics/2;
local scene;

-- function tutorials:scale(_scale)
	-- scale = _scale;
-- end

function tutorials:restep()
	local last_title;
	local j = 1;
	for i=1,#tutorials do
		local obj = tutorials[i];
		if(obj.title~=last_title)then
			last_title = obj.title
			j = 1;
		else
			j = j+1;
		end
		obj.step = obj.title.."_"..j;
	end
end

local obj;
local wndmc;
local glow;

function tutorials:done(title)
	if(title)then
		if(obj)then
			if(obj.title==title)then
				-- its ok! lets procced
			else
				return
			end
		else
			return
		end
	end
	if(obj)then
		if(obj.callback)then
			obj:callback();
		end
	end

	for i=#tutorials,1,-1 do
		if(tutorials[i] == obj)then
			table.remove(tutorials, i);
			break;
		end
	end
	if(wndmc)then
		if(wndmc.parent)then
			wndmc:removeSelf();
		end
		wndmc = nil;
		save_obj.unlocks['tutorial_'..obj.step] = 1;
		print('tutorial_'..obj.step, save_obj.unlocks['tutorial_'..obj.step]);
		obj = nil;
	end
	
	if(glow)then
		if(glow.parent)then glow:removeSelf(); end
		glow = nil;
	end
	
	tutorials:step();
end

function tutorials:redraw()
	if(wndmc)then
		if(wndmc.parent)then
			wndmc:removeSelf();
		end
		wndmc = nil;
	end
	scale = scaleGraphics/2;
	if(obj==nil)then return; end
	local w,h = 400*scale, 150*scale;
	wndmc = newGroup(scene);
	wndmc.x, wndmc.y = _W/2, (200*scale + h/2);
	
	local wndbg = add_bg_title("bg_3", w, h, get_txt(obj.title));
	wndmc:insert(wndbg);
	wndbg.x, wndbg.y = 0,0;

	local ava = display.newImage(wndmc, "image/face_".."5"..".png");
	ava:scale(scale/2, scale/2);
	ava.x, ava.y = wndbg.w/2 - ava.contentWidth/2 - 3*scale, wndbg.h/2 - ava.contentHeight/2 - 3*scale;

	local aw = ava.contentWidth;

	local txt = display.newText({parent=wndmc, text=get_txt("tutorial_rbq_"..obj.step), 
		width=w-aw-12*scale, x = -aw/2+4*scale, align="center", fontSize=22*scale});


	if(obj.high)then
		local tarmc = links[obj.high];
		
		local function actTut()
			if(glow)then
				glow:removeSelf();
				glow = nil;
			end
			
			tarmc.actTut = nil;
			tutorials:done();
		end
		
		if(glow)then
			if(glow.parent)then
				glow:removeSelf();
			end
			glow = nil;
		end
		glow = newGroup(scene);
		glow.x, glow.y = -1000, -1000;
		local function turnTutorial(e)
			if(obj==nil or glow==nil or glow.parent==nil)then
				
				Runtime:removeEventListener('enterFrame', turnTutorial);
				return;
			end
			tarmc = links[obj.high];
			if(tarmc)then
				if(tarmc.localToContent)then
					glow.x, glow.y = tarmc:localToContent(0, 0);
					tarmc.actTut = actTut;
				end
			end
		end
		Runtime:addEventListener('enterFrame', turnTutorial);
		
		local item = display.newImage(glow, "image/glow_3.png");
		item:scale(scale, scale);
		anirotation(item, 50);
		
		local item = display.newImage(glow, "image/glow_3.png");
		item:scale(scale, scale);
		anirotation(item, -20);
		
		if(tarmc)then
			tarmc.actTut = actTut;
		end
	end
	if(obj.high==nil or obj.glow)then
		scene:iniBtn(wndmc, nil, nil, wndbg);
		wndmc.act = function()
			tutorials:done();
		end
	end
end
function tutorials:step()
	obj = tutorials[1];
	if(obj)then -- while to remove steps that were already checked
		while(save_obj.unlocks['tutorial_'..obj.step] and #tutorials>0)do
			if(obj.callback)then
				obj:callback();
			end
			table.remove(tutorials, 1);
			obj = tutorials[1];
			if(obj==nil)then
				break;
			end
		end
	end
	
	tutorials:redraw();
end
function tutorials:setScene(_scene)
	scene = _scene;
	if(scene.iniBtn==nil)then
		function scene:iniBtn(mc, w, h, body, over)
			table.insert(scene.buttons, mc);
			mc.w, mc.h = w or mc.width, h or mc.height;
			if(over or over==nil)then
				elite.addOverOutBrightness(mc, body);
			end
		end
	end
	tutorials:restep();
end