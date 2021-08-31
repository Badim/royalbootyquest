module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "debug";
	
	local background = display.newImage(localGroup, "image/background/book.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	localGroup.buttons = {};
	local function addRoaylBtn(tx, ty, hint, act, img, scale)
		local btn = newGroup(facemc);
		btn:translate(tx, ty);
		local img = display.newImage(btn, img);
		if(scale==nil)then scale=1; end
		img:scale(scale*scaleGraphics/2, scale*scaleGraphics/2);
		
		btn.hint = get_txt(hint);
		btn.act = act;
		elite.addOverOutBrightness(btn, img);
		
		-- btn.w, btn.h = 140*scaleGraphics, 90*scaleGraphics;
		btn.w, btn.h = img.contentWidth, img.contentHeight;
		table.insert(localGroup.buttons, btn);
		return btn, img;
	end
	------------------------------------
	local savesmc = newGroup(gamemc);
	if(royal.forge==nil)then
		local firebase = require('firebase');
		royal.forge = firebase('https://cards-114b3.firebaseio.com/');
	end
	------------------------------------
	-- (wnd, tx, ty, w, h, callback, stay)
	local dtxt = display.newText(facemc, "Write about your problem and then hit button on left to upload your save for debuggin", 70*scaleGraphics, 45*scaleGraphics, fontMain, 12*scaleGraphics);
	dtxt:translate(dtxt.width/2, 0);
	local w = _W - 120*scaleGraphics;
	local itxt = elite.newNativeText(facemc, 70*scaleGraphics + w/2, 70*scaleGraphics, w, 20*scaleGraphics, function(txt)
		
	end, true);
	-- itxt.x = itxt.x+itxt.width/2;
	itxt.baned = {"%.", "%/", "%\\"};
	
	local upload = addRoaylBtn(40*scaleGraphics, 60*scaleGraphics, "upload", function()
		if(#itxt.text<10 or itxt.text == 'Write your problem here plz')then
			itxt.text = 'Write your problem here plz';
			return
		end
		if(mainGroup.hero_obj)then
			local fname = "save_"..mainGroup.hero_obj.class..".json";
			local save_file = loadFile(fname);
			if(save_file)then
				local obj = json.decode(save_file);
				obj.rloot = {};
				obj.cloot = nil;
				obj.game = nil;
				obj.build=optionsBuild;
				obj.version=optionsVersion;
				obj.problem = itxt.text;
				
				local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
				obj.player = player_name;
				
				royal.forge:post("saves", json.encode(obj), nil, function(event)
					if(event.isError)then
						print("Network error!");
						savesmc:refresh();
					else
						local response = json.decode(event.response);
						print("saves", event.response);
						show_msg('save uploaded:'..tostring(response.name));
						if(response.name)then
							royal.forge:put("saves/"..response.name.."/timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
								-- if(event.isError)then
									-- print("Network error!");
								-- else
									-- print("turned:", event.response);
								-- end
								savesmc:refresh();
							end);
						end
					end
				end);
			else
				show_msg('no save');
			end
		else
			show_msg('choose hero in start menu');
		end
	end, "image/gui/frame_wood_2.png");
	
	pixelArtOn();
	local scin = mainGroup.hero_obj.scin;
	local head = display.newImage(upload, "image/heads/"..scin..".png");
	head:scale(scaleGraphics*1, scaleGraphics*1);
	pixelArtOff();

	-- player
	
	function savesmc:refresh()
		savesmc.x, savesmc.y = 0, 0;
		cleanGroup(savesmc);
		royal.forge:get("saves", nil, function(event)
			if(localGroup.dead)then
				return
			end
			if(event.isError)then
				print("Network error!");
			else
				local response_obj = json.decode(event.response);
				local i = 1;
				local w = 60*scaleGraphics;
				if(response_obj==nil)then
					print('response:', event.response);
				end
				if(response_obj)then
					for saveId,obj in pairs(response_obj) do
						local itemmc = addRoaylBtn(i*w, 200*scaleGraphics, "save", function()
							if(system.getInfo("environment")=="simulator")then
								_G.login_obj = obj;
								show_msg('you loaded modded save - no global scores on this one');
								show_map();
							else
								show_msg('this is someone else save');
								show_msg('if you load it - it will remove yours');
								show_msg('I disabled this option for non-developers for now');
							end
						end, "image/gui/frame_wood_2.png");
						local hero_obj = getHeroObjByAttr("class", obj.class);
						savesmc:insert(itemmc);
						pixelArtOn();
						local scin = hero_obj.scin;
						local head = display.newImage(itemmc, "image/heads/"..scin..".png");
						head:scale(scaleGraphics*1, scaleGraphics*1);
						pixelArtOff();
						
						-- if(obj.player)then
							-- local dtxt = display.newText(itemmc, obj.player, 0, 32*scaleGraphics, fontMain, 12*scaleGraphics);
							-- fitTextFildByW(dtxt, w);
						-- end
						obj.cheat = true;
						if(obj.problem)then
							itemmc.hint = obj.problem;
						end
						
						if(system.getInfo("environment")=="simulator")then
							local ico = display.newImage(itemmc, "image/gui/btnMinus.png");
							ico:translate(16*scaleGraphics, -16*scaleGraphics);
							ico:scale(scaleGraphics/3, scaleGraphics/3);
							ico.hint = get_txt('remove');
							ico.w, ico.h = 20*scaleGraphics, 20*scaleGraphics;
							ico.act = function()
								cleanGroup(savesmc);
								royal.forge:delete("saves/"..saveId, nil, function(event)
									if(event.isError)then
										print("Network error!");
									else
										local data_obj = json.decode(event.response);
										print('deleted:', obj.uid, event.response, data_obj);
									end
									savesmc:refresh();
								end)
							end
							table.insert(localGroup.buttons, ico);
							elite.addOverOutBrightness(ico);
							
							if(obj.problem)then
								ico:setFillColor(1, 0, 0);
							end
						end
						
						local j=0;
						local function addPrms(attr, str)
							if(str==nil)then str=attr..": "; end
							if(obj[attr])then
								local val = obj[attr];
								if(type(obj[attr])=="table")then
									val = #obj[attr];
								end
								local dtxt = display.newText(itemmc, str..tostring(val), 0, 30*scaleGraphics+j*12*scaleGraphics, fontMain, 10*scaleGraphics);
								fitTextFildByW(dtxt, w);
							end
							j=j+1;
						end
						addPrms('player', "");
						addPrms('hp');
						addPrms('hpmax');
						addPrms('deck');
						addPrms('dead');
						addPrms('build', "");
						addPrms('version', "");
			
						i = i+1;
					end
				end
			end
		end);
	end
	savesmc:refresh();
	
	local sx, sy=0,0;
	background:addEventListener("touch", function(e)
		if(e.phase=="began")then
			sx, sy = e.x, e.y;
		else
			local dx, dy = sx-e.x, sy-e.y;
			sx, sy = e.x, e.y;
			savesmc:translate(-dx, 0);
		end
	end);
	------------------------------------
	
	local function onBack(e)
		show_start();
		return true
	end
	
	addRoaylBtn(_W - 20*scaleGraphics, 20*scaleGraphics, "exit", onBack, "image/button/cancel.png");

	function localGroup:actEscape()
		return onBack();
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	function localGroup:removeAll()

	end
	
	return localGroup;
end