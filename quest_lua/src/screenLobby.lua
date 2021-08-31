module(..., package.seeall);

function new()	
	local localGroup = display.newGroup();
	localGroup.name = "lobby";
	
	local background = display.newImage(localGroup, "image/background/tavern.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	localGroup.buttons = {};
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	local heroesmc=newGroup(facemc);
	local onlinemc = newGroup(localGroup);
	
	if(royal.coop==nil)then
		local firebase = require('firebase');
		royal.coop = firebase('https://royal-coop.firebaseio.com/');
	end
	
	local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
	
	if(royal.lobbyData==nil)then
		royal.lobbyData = {players={}, games={}};
	end
	
	local lobbyData = royal.lobbyData;
	local lobbyPlayers = lobbyData.players;
	local myUserEntry; -- save_obj.lobbyId
	
	function localGroup:iniBtn(path, tx, ty, hint, act)
		local btn = display.newImage(facemc, path);
		btn:scale(scaleGraphics/2, scaleGraphics/2);
		btn.x, btn.y = tx, ty;
		btn.w, btn.h = btn.contentWidth, btn.contentHeight;
		table.insert(localGroup.buttons, btn);
		elite.addOverOutBrightness(btn);
		btn.hint = hint;
		btn.act = act;
		return btn;
	end
	function localGroup:actEscape()
		if(localGroup.games_list and save_obj.lobbyId)then
			local games_list = localGroup.games_list;
			for gameId, game_obj in pairs(games_list) do
				if(game_obj.hostID == save_obj.lobbyId)then
					royal.coop:delete("lobby/"..gameId, nil, function(event)
						if(event.isError)then
							print("Network error!");
						else
							-- royal.lobbyStatus = 1;
							-- gamesmc:update();
							print('game removed on exit');
						end
					end);
				else
					for plrId, pobj in pairs(game_obj.players) do
						if(save_obj.lobbyId == plrId)then
							royal.coop:delete("lobby/"..gameId.."/players/"..save_obj.lobbyId, nil, function(event)
								if(event.isError)then
									print("Network error!");
								else
									print('game exited on exit');
								end
							end);
						end
					end
				end
			end
		end
		
		if(save_obj.lobbyId)then
			royal.coop:delete("users/"..save_obj.lobbyId.."/timestamp", nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					print('exited lobby');
				end
			end);
		end
		show_menu();
	end
	localGroup:iniBtn("image/button/cancel.png", _W - 20*scaleGraphics, 20*scaleGraphics, get_txt('back'), function()
		localGroup:actEscape();
	end);
	

	function royal:getUserObj(userId, callback)
		royal.coop:get("users/"..userId.."/", nil, function(event)
			if(event.isError)then
				print("Network error!");
			else
				print("new:", event.response);
				local userObj = json.decode(event.response);
				if(userObj)then
					lobbyPlayers[userId] = userObj;
					userObj.userId = userId;
					if(userId==save_obj.lobbyId)then
						myUserEntry = lobbyPlayers[userId];
						heroesmc:refresh();
					end
					if(callback)then
						callback(lobbyPlayers[userId]);
					end
					-- local response_obj = json.decode(event.response);
					-- save_obj.lobbyId = response_obj.name;
					-- saveGlobalObj();
					-- royal.lobbyStatus = 1;
				end
			end
		end);
	end
	function royal:renewMe()
		if(save_obj.lobbyId and myUserEntry)then
			royal.coop:put("users/"..save_obj.lobbyId.."/timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					myUserEntry.timestamp = event.response;
				end
			end);
		end
	end
	function royal:updateMe(attr, val, callback)
		if(royal.lobbyStatus<1)then
			show_msg('error: status');
			return
		end
		if(save_obj.lobbyId==nil)then
			show_msg('error: lobbyId');
			return
		end
		if(myUserEntry==nil)then
			show_msg('error: myUserEntry');
			return
		end
		myUserEntry[attr] = val;
		-- local player_name = save_obj.customName or _G.playerName or save_obj.playerName;
		royal.coop:patch("users/"..save_obj.lobbyId.."/", json.encode({[attr]=val}), nil, function(event)
			if(event.isError)then
				print("Network error!");
			else
				print("new:", attr, myUserEntry[attr], event.response);
				-- local response_obj = json.decode(event.response);
				-- save_obj.lobbyId = response_obj.name;
				-- saveGlobalObj();
				-- royal.lobbyStatus = 1;
				if(callback)then
					callback(event.response);
				end
				
				royal:renewMe();
			end
		end);
	end
	
	-- local itxt = elite.newNativeText(facemc, _W/2, _H-26*scaleGraphics, 80*scaleGraphics, 20*scaleGraphics, function(txt)
		-- save_obj.customName = txt;
		-- player_name = save_obj.customName or _G.playerName or save_obj.playerName;
		-- royal:updateMe("nick", player_name);
		-- if(localGroup.refreshDebugInfo)then
			-- localGroup:refreshDebugInfo();
		-- end
	-- end);
	-- itxt.inputType = "no-emoji";
	-- itxt.text = player_name;
	-- itxt.maxsymbols = 12;
	-- itxt.nospaces = true;
	-- itxt.baned = {" ", "%.", "%/", "%\\"};

	-- royal.coop:get("users", nil, function(event)
		-- if(event.isError)then
			-- print("Network error!");
		-- else
			-- print("users:", event.response);
			-- local data_obj = json.decode(event.response);
		-- end
	-- end);
	local function joinGame(gameId, callback)
		royal.coop:put("lobby/"..gameId.."/players/"..save_obj.lobbyId, json.encode({ready=0}), nil, function(event)					
			if(event.isError)then
				print("Network error!");
			else
				
			end
			if(callback)then
				callback();
			end
		end);
		
		royal:renewMe();
	end
	
	local function load_battle(gameId)
		royal.coop:get("games/"..gameId, nil, function(event)
			if(event.isError)then
				print("Network error!");
			else
				if(localGroup.dead)then return; end
				localGroup.dead = true;
				login_restart();
				local hero_obj = getHeroObjByAttr("tag", myUserEntry.hero);
				login_ini(hero_obj);
				local game_obj = json.decode(event.response);
				show_battle({ptype="elite", lvl=3, pve=true, game=game_obj, myUserEntry=myUserEntry, party={tag="Stage 1", lvl=3, units=game_obj.enemies}});
			end
		end);
	end
	
	local gamesmc = newGroup(gamemc);
	elite.setScrollable(gamesmc);
	function gamesmc:update(gameId)
		if(gamesmc.loading)then
			return;
		end
		if(localGroup.resetTimers)then
			localGroup:resetTimers();
		end
		cleanGroup(gamesmc);
		gamesmc.loading = true;
		royal.coop:get("lobby", nil, function(event)
			gamesmc.loading = false;
			if(event.isError)then
				print("Network error!");
			else
				if(gamesmc.parent==nil)then
					return
				end
				-- print("lobby:", event.response);
				local games_list = json.decode(event.response);
				print(event.response, games_list, type(event.response), type(games_list));
				if(games_list)then
					localGroup.games_list = games_list;
					local game_exist = false;
					for gameId, game_obj in pairs(games_list) do
						if(gameId==lobbyData.gameId)then
							game_exist = true;
							break;
						end
					end
					if(game_exist==false)then
						lobbyData.gameId = nil;
					end
					
					for gameId, game_obj in pairs(games_list) do
						if(game_obj.hostNick==nil)then
							games_list[gameId] = nil;
						elseif(lobbyData.gameId)then
							if(gameId~=lobbyData.gameId)then
								games_list[gameId] = nil;
							end
						end
					end
					
					-- ver
					-- timestamp
					local games_arr = {};
					for gameId, game_obj in pairs(games_list) do
						table.insert(games_arr, {id=gameId, obj=game_obj});
					end
					table.sort(games_arr, function(a, b)
						local obj1 = a.obj;
						local obj2 = b.obj;
						if(obj1.ver == obj2.ver)then
							return (obj1.timestamp or 0)/1 > (obj2.timestamp or 0)/1;
						else
							return obj1.ver/1 > obj2.ver/1;
						end
					end);
					
					-- local i=1;
					-- for gameId, game_obj in pairs(games_list) do
					for i=1,#games_arr do
						local gameId, game_obj = games_arr[i].id, games_arr[i].obj;
						local mc = newGroup(gamesmc);
						local playersmc = newGroup(mc);
						local players_l = 0;
						mc.gameId = gameId;
						game_obj.gameId = gameId;
						mc.x, mc.y = _W/2, 110*scaleGraphics + (i-1)*48*scaleGraphics;
						
						local leave = display.newImage(mc, "image/gui/btn_close.png");
						leave.isVisible = false;
						leave:scale(scaleGraphics/4, scaleGraphics/4);
						leave.x, leave.y = -_W/2 + 50*scaleGraphics, 0;
						elite.addOverOutBrightness(leave);
						leave.hint = get_txt("leave");
						leave.w, leave.h = leave.contentWidth, leave.contentHeight;
						table.insert(localGroup.buttons, leave);
						leave.act = function()
							if(game_obj.hostID == myUserEntry.userId)then
								royal.coop:delete("lobby/"..gameId, nil, function(event)
									if(event.isError)then
										print("Network error!");
									else
										royal.lobbyStatus = 1;
										gamesmc:update();
									end
								end);
							else
								royal.coop:delete("lobby/"..gameId.."/players/"..save_obj.lobbyId, nil, function(event)
									if(event.isError)then
										print("Network error!");
									else
										royal.lobbyStatus = 1;
										gamesmc:update();
									end
								end);
							end
						end
						
						
						
						local start = newGroup(mc); --display.newImage(mc, "image/gui/btn_next.png"); -- btn_restore.png
						start.body = display.newImage(start, "image/gui/btn_restore.png"); -- btn_restore.png
						start.isVisible = false;
						start.hint = get_txt("start");
						start:scale(scaleGraphics/4, scaleGraphics/4);
						start.x, start.y = _W/2 - 50*scaleGraphics, 0;
						elite.addOverOutBrightness(start);
						start.w, start.h = start.contentWidth, start.contentHeight;
						table.insert(localGroup.buttons, start);
						start.act = function()
							if(game_obj.enemies==nil)then
								show_msg('this_game_is_weird');
								return
							end
							if(game_obj.hostID == myUserEntry.userId)then
								if(players_l<2)then
									show_msg('too_few_ppl');
									return
								end
								cleanGroup(gamesmc);
								mc:updatePlayers(function()
									local new_game_obj = {state='starting', turn=1, players_l=players_l, players={}, enemies=game_obj.enemies};
									new_game_obj.gameId = gameId;
									new_game_obj.hostID = game_obj.hostID;
									local _p=1;
									for arrI,obj in pairs(game_obj.players) do
										new_game_obj.players[arrI] = {_p=_p};
										_p = _p+1;
									end
									
									royal.coop:put("games/"..gameId.."/", json.encode(new_game_obj), nil, function(event)
										if(event.isError)then
											print("Network error!");
										else
											-- mc:updateState();
										end
									end);
								
									royal.coop:patch("lobby/"..gameId.."/", json.encode({state='battle'}), nil, function(event)
										if(event.isError)then
											print("Network error!");
										else
											mc:updateState();
										end
									end);
								end);
							else
								mc:updateState();
							end
						end
						
						local enemiesmc = newGroup(mc);
						local mcbg = add_bar("black_bar", 66*scaleGraphics, scaleGraphics/2);
						enemiesmc:insert(mcbg);
						enemiesmc.x = -_W/2 + 190*scaleGraphics;
						if(game_obj.enemies)then
							for i=1,#game_obj.enemies do
								local enemy_tag = game_obj.enemies[i];
								local enemy_obj = getEnemyObjByTag(enemy_tag);
								local scin = enemy_obj.scin or "warrior";
								local head = display.newImage(enemiesmc, "image/unitsIco/"..scin..".png");
								head:scale(scaleGraphics/2, scaleGraphics/2);
								head.x = (i-#game_obj.enemies/2-0.5)*30*scaleGraphics;
								head.y = -4*scaleGraphics;
							end
						end
						
						if(game_obj.players==nil)then game_obj.players={}; end;
						
						for arrI,obj in pairs(game_obj.players) do
							if(arrI==save_obj.lobbyId)then
								lobbyData.gameId = gameId;
								royal.lobbyStatus = 3;
								start.isVisible = true;
							end
							players_l = players_l+1;
						end
						local txt = display.newText(mc, 'host: '..game_obj.hostNick, -_W/2 + 64*scaleGraphics, -8*scaleGraphics, fontMain, 12*scaleGraphics);
						txt:translate(txt.width/2 , 0);
						local txt = display.newText(mc, 'players: '..players_l, -_W/2 + 64*scaleGraphics, 2*scaleGraphics, fontMain, 10*scaleGraphics);
						txt:translate(txt.width/2 , 0);
						local txt = display.newText(mc, 'ver: '..(game_obj.ver or 'old'), -_W/2 + 64*scaleGraphics, 12*scaleGraphics, fontMain, 10*scaleGraphics);
						txt:translate(txt.width/2 , 0);
						
						if(myUserEntry)then
							if(myUserEntry.timestamp and game_obj.timestamp)then
								local time_val = math.floor((myUserEntry.timestamp - game_obj.timestamp)/1000);
								-- print("game_time:", i, time_val, myUserEntry.timestamp, game_obj.timestamp);
								local time_str = time_val.. "s";
								if(time_val>60)then
									time_str = math.floor(time_val/60) .. "m";
								else
									time_str = (time_val) .. "s";
								end
								local txt = display.newText(mc, time_str, -_W/2 + 124*scaleGraphics, 12*scaleGraphics, fontMain, 10*scaleGraphics);
								txt:translate(txt.width/2 , 0);
							end
						end
						
						if(game_obj.hostID==save_obj.lobbyId)then
							lobbyData.gameId = gameId;
							royal.lobbyStatus = 2;
							
							if(start.body)then
								start.body:removeSelf();
								start.body = nil;
							end
							start.body = display.newImage(start, "image/gui/btn_next.png"); -- btn_restore.png
						end
						localGroup:refreshDebugInfo();
						-- local head = display.newImage(mc, "image/unitsIco/airbow.png", 10*scaleGraphics, 0);
						-- head:scale(scaleGraphics/2, scaleGraphics/2);
						
						-- lobbyData = {players={}, games={}};
						function mc:refreshPlayers()
							print("refreshPlayers");
							if(playersmc.parent==nil)then
								return
							end
							if(game_obj.players==nil)then
								return
							end
							cleanGroup(playersmc);
							local i=1;
							players_l = 0;
							
							for arrI,obj in pairs(game_obj.players) do
							-- for i=1,#game_obj.players do
								-- local obj = game_obj.players[i];
								local playerObj = lobbyPlayers[arrI];
								if(playerObj and playerObj.nick)then
									players_l = players_l+1;
									local heroObj = getHeroObjByAttr("tag", playerObj.hero);
									local itemmc = newGroup(playersmc);
									itemmc.x, itemmc.y = -_W/2 + 260*scaleGraphics + 100*scaleGraphics*(i-1), 0;
									i = i+1;
									local txt = display.newText(itemmc, playerObj.nick, 34*scaleGraphics, 0, fontMain, 10*scaleGraphics);
									txt:translate(txt.width/2, 0);
									if(heroObj)then
										local ico = elite.newPixelart(itemmc, "image/heads/"..heroObj.scin..".png");
									end
									local rico = newGroup(itemmc);
									rico.x, rico.y = 20*scaleGraphics, 0;
									local body = display.newImage(rico, "image/gui/ready"..obj.ready..".png");
									rico:scale(scaleGraphics/2, scaleGraphics/2);
									if(arrI == save_obj.lobbyId)then
										lobbyData.gameId = gameId;
										royal.lobbyStatus = 3;
										start.isVisible = true;
										leave.isVisible = true;

										rico.act = function()
											rico.disabled = true;
											local newr = 1;
											if(obj.ready==1)then
												newr = 0;
											end
											royal.coop:patch("lobby/"..gameId.."/players/"..arrI.."/", json.encode({ready=newr}), nil, function(event)
												rico.disabled = false;
												if(event.isError)then
													print("Network error!");
												else
													if(body.removeSelf)then
														body:removeSelf();
													end
													obj.ready = newr;
													body = display.newImage(rico, "image/gui/ready"..obj.ready..".png");
												end
												mc:updatePlayers();
											end);
										end
										elite.addOverOutBrightness(rico);
										rico.w, rico.h = rico.contentWidth, rico.contentHeight;
										table.insert(localGroup.buttons, rico);
									end
								end
							end
							-- print('fa', playersmc.numChildren)
						end
						function mc:updateState()
							start.disabled = true;
							royal.coop:get("lobby/"..gameId.."/state/", nil, function(event)
								-- print('game_state:', event.isError, event.response)
								start.disabled = nil;
								if(event.isError)then
									
								else
									game_obj.state = json.decode(event.response);
									if(game_obj.state=='battle')then
										start.disabled = true;
										load_battle(gameId);
									else
										if(localGroup.timerUpdateState)then
											timer.cancel(localGroup.timerUpdateState);
										end
										localGroup.timerUpdateState = timer.performWithDelay(4000, mc.updateState);
									end
								end
							end);
						end
						function mc:updatePlayers(callback)
							royal.coop:get("lobby/"..gameId.."/players/", nil, function(event)
								print("players:", event.isError, event.response);
								if(event.isError)then
									
								else
									game_obj.players = json.decode(event.response);
									mc:refreshPlayers();
									if(callback)then
										callback();
									end
									
									if(localGroup.timerUpdatePlayers)then
										timer.cancel(localGroup.timerUpdatePlayers);
									end
									localGroup.timerUpdatePlayers = timer.performWithDelay(10000, mc.updatePlayers);
								end
							end);
						end
						-- print("fetch?:", lobbyData.gameId, gameId, lobbyData.gameId==gameId);
						if(lobbyData.gameId==gameId)then
							for arrI,obj in pairs(game_obj.players) do
							-- for i=1,#game_obj.players do
								-- local obj = game_obj.players[i];
								local playerObj = lobbyPlayers[arrI];
								if(playerObj==nil)then
									royal:getUserObj(arrI, function(playerObj)
										mc:refreshPlayers();
									end);
								end
							end
							mc:refreshPlayers();
							mc:updateState();
						end
						
						enemiesmc.w, enemiesmc.h = mcbg.w, mcbg.h;
						table.insert(localGroup.buttons, enemiesmc);
						elite.addOverOutBrightness(enemiesmc, mcbg);
						enemiesmc.hint = get_txt("join");
						function enemiesmc:disabled()
							return royal.lobbyStatus~=1;
						end
						enemiesmc.act = function()
							if(players_l>2)then
								show_msg('too_much_ppl');
								return
							end
							if(game_obj.state~="lobby")then
								show_msg('game_already_started');
								return
							end
							if(royal.lobbyStatus~=1)then
								show_msg('you_already_in_some_game');
								return
							end
							if(royal.lobbyStatus==1 and game_obj.state=="lobby" and players_l<2)then
								royal.lobbyStatus=3;
								joinGame(gameId, function()
									gamesmc:update(gameId);
								end);
							end
						end
						
						i=i+1;
					end
				end
			end
		end);
	end
	
	-- royal.coop:post("users", json.encode(score_obj), nil, function(event)
	-- end);
	-- patch put
	
	-- royal.lobbyStatus
	-- 1 - online
	-- 2 - host
	-- 3 - player
	
	royal.lobbyStatus = 0;
	
	local function updateMe()
		royal.lobbyStatus = 1;
		royal:getUserObj(save_obj.lobbyId, function()
			royal:updateMe("ver", optionsVersion);
			royal:updateMe("build", optionsBuild);
			onlinemc:refresh();
		end);
		royal:renewMe();
		-- royal:updateMe("nick", player_name);
	end
	local function registerMe()
		royal.lobbyStatus = 0;
		local user_obj = {};
		user_obj.nick = player_name;
		user_obj.ver = optionsVersion;
		royal.coop:post("users", json.encode(user_obj), nil, function(event)
			if(event.isError)then
				show_msg("(users)Network error!");
			else
				-- print("new:", event.response);
				local response_obj = json.decode(event.response);
				save_obj.lobbyId = response_obj.name;
				saveGlobalObj();
				updateMe();
			end
			gamesmc:update();
		end);
	end
	
	if(save_obj.lobbyId==nil)then
		registerMe();
	else
		royal.coop:get("users/"..save_obj.lobbyId.."/", nil, function(event)
			if(event.isError)then
				print("Network error!");
			else
				-- print("new:", event.response);
				local userObj = json.decode(event.response);
				if(userObj)then -- user already in database
					updateMe();
					gamesmc:update();
				else -- this used was removed, probably by admin
					registerMe();
				end
			end
		end);
	end
	
	function onlinemc:refresh()
		if(myUserEntry)then
			if(myUserEntry.timestamp)then
				royal.coop:get("users/", '?orderBy="timestamp"&startAt='..(myUserEntry.timestamp - 5*60*1000), function(event)
					if(localGroup.dead)then
						return
					end
					if(event.isError)then
						print("Network error!");
					else
						local response_obj = json.decode(event.response);
						-- print("onlinemc:", event.response, response_obj)
						if(response_obj)then
							cleanGroup(onlinemc);
							local i = 0;
							for uid,obj in pairs(response_obj) do
								-- {"build":"win32","hero":"Frontier","nick":"mr.Badim","timestamp":1557280309933,"ver":"0.948"}}
								local itemmc = newGroup(onlinemc);
								itemmc.x, itemmc.y = 30*scaleGraphics + i*50*scaleGraphics, _H-30*scaleGraphics;
								-- local itembg = add_bar("black_bar", 48*scaleGraphics, scaleGraphics/2);
								-- itemmc:insert(itembg);
								-- add_bg(utype, tw, th, fill)
								local itembg = add_bg("bg_3", 48*scaleGraphics, 36*scaleGraphics, true);
								itembg.x, itembg.y = 0, 0;
								itemmc:insert(itembg);
								if(obj.hero)then
									local heroObj = getHeroObjByAttr("tag", obj.hero);
									local head = elite.newPixelart(itemmc, "image/heads/"..heroObj.scin..".png");
									head.x = -8*scaleGraphics;
									head.y = 4*scaleGraphics;
									head:scale(scaleGraphics/2, scaleGraphics/2);
								end
								if(obj.build)then -- gfx\builds
									local head = elite.newPixelart(itemmc, "gfx/builds/"..obj.build..".png");
									head.x = 8*scaleGraphics
									head.y = 4*scaleGraphics;
									head:scale(scaleGraphics/4, scaleGraphics/4);
								end
								if(obj.nick)then
									local dtxt = display.newText(itemmc, obj.nick, 0, -10*scaleGraphics, fontMain, 8*scaleGraphics);
								end
								i = i+1;
							end
						end
					end
				end);
			end
		end
	end
	onlinemc:refresh();

	local btn = localGroup:iniBtn("image/button/refresh.png", _W - 60*scaleGraphics, 20*scaleGraphics, get_txt('refresh'), function()
		gamesmc:update();
		royal:renewMe();
		onlinemc:refresh();
	end);
	function btn:disabled()
		return gamesmc.loading==true;
	end
	
	local btn = localGroup:iniBtn("image/button/plus.png", _W - 100*scaleGraphics, 20*scaleGraphics, get_txt('create'), function()
		if(facemc.wnd)then
			return
		end
		local txt_arr = {};
		table.insert(txt_arr, get_txt('create'));
		table.insert(txt_arr, "");
		table.insert(txt_arr, "");
		table.insert(txt_arr, "");
		table.insert(txt_arr, "");
		table.insert(txt_arr, "");
		table.insert(txt_arr, "");
		table.insert(txt_arr, "");
		local selmc = display.newRoundedRect(facemc, 0, 0, 76*scaleGraphics, 32*scaleGraphics, 6*scaleGraphics);
		selmc:setFillColor(1/2, 1/2, 1/2, 2/3);
		selmc.isVisible = false;
		local cnfr_mc = royal.show_wnd_question(facemc, localGroup.buttons, txt_arr, function()
			if(royal.lobbyStatus==1)then
				if(royal.lobbyStatus~=1)then
					show_msg('already in some game');
					return
				end
				if(myUserEntry==nil)then
					show_msg('dont know you');
					return
				end
				if(myUserEntry.hero==nil)then
					show_msg('pick your hero first');
					return
				end
				if(selmc.units==nil or selmc.isVisible == false)then
					show_msg('pick_enemies_first');
					return
				end
				units = selmc.units;
				
				royal.coop:post("lobby", json.encode({hostID=save_obj.lobbyId, hostNick=myUserEntry.nick, ver=optionsVersion, enemies=units, state="lobby", players={}}), nil, function(event)
					if(event.isError)then
						print("Network error!");
					else
						print("new:", event.response);
						local response_obj = json.decode(event.response);
						local gameId = response_obj.name;
						lobbyData.gameId = gameId;
						joinGame(gameId, function()
							gamesmc:update();
						end);
						
						royal.coop:put("lobby/"..gameId.."/timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
							if(event.isError)then
								print("Network error!");
							else
								print("turned:", event.response);
							end
						end);
					end
				end);
			end
				
			facemc.wnd = nil;
		end, function()
			facemc.wnd = nil;
		end);
		
		cnfr_mc:insert(selmc);
		local listmc = newGroup(cnfr_mc);
		local list = {"Jaw Worms", "Cult Slime", "Walkers", "Pastries2", "Byrds", "Heroes Party"};
		-- "Byrds" "Heroes Party"
		-- if()then
		-- else
		-- end
		local k=1;
		for i=-1,1,2 do
			for j=-1,1,1 do
			local mc = newGroup(listmc);
			mc.x, mc.y = cnfr_mc.w/2 + i*44*scaleGraphics, cnfr_mc.h/2 + j*40*scaleGraphics;
			local party_tag = list[k];
			local enemies=getEnemySquadByTag(party_tag);

			local enemiesmc = newGroup(mc);
			local units = enemies.units;
			for j=1,#units do
				local enemy_obj = getEnemyObjByTag(units[j]);
				local scin = enemy_obj.scin or "warrior";
				local head = display.newImage(mc, "image/unitsIco/"..scin..".png");
				head:scale(scaleGraphics/2, scaleGraphics/2);
				head.x = (j - #units/2 - 0.5)*30*scaleGraphics;
				head.y = -4*scaleGraphics;
			end
			
			local mcbg = add_bar("black_bar", (10 + 30*#units)*scaleGraphics, scaleGraphics/2);
			mcbg.x, mcbg.y = 0;
			mc:insert(mcbg);
			mcbg:toBack();

			mc.w, mc.h = mc.contentWidth, mc.contentHeight;
			table.insert(localGroup.buttons, mc);
			elite.addOverOutBrightness(mc, mcbg);
			mc.hint = get_txt('host')..": "..table.concat(units, ", ")..".";
			mc.act = function()
				selmc.isVisible = true;
				selmc.x, selmc.y = mc.x, mc.y;
				selmc.units = units;				
			end
			k = k+1;
		end
		end
						
		facemc.wnd = cnfr_mc;
	end);
	function btn:disabled()
		return facemc.wnd~=nil;
	end
	-- local btn = localGroup:iniBtn("image/button/ok.png", _W - 100*scaleGraphics, 20*scaleGraphics, get_txt('bot'), function()
		-- royal.bot = not royal.bot;
		-- print("_royal.bot:", royal.bot);
	-- end);
	
	-- ok.png
	
	-- local thisScale = scaleGraphics;
	-- thisScale = math.min(math.floor((_W-50*scaleGraphics)/#heroes/40), scaleGraphics);
	local chains_h = 30*scaleGraphics;
	
	for i=1,#heroes do
		local hero_obj = heroes[i];

		local mc = newGroup(heroesmc);
		mc.x, mc.y = _W/2 + 40*(i-#heroes/2-0.5)*scaleGraphics, chains_h;
		local scin = hero_obj.scin;
		
		-- elite:add_chains_h(heroesmc, "gui/chain4", mc.x-8*thisScale, -3*thisScale, chains_h, 1);
		-- elite:add_chains_h(heroesmc, "gui/chain4", mc.x+8*thisScale, -3*thisScale, chains_h, 1);
		
		local mcbg = add_bar("black_bar", 28*scaleGraphics, scaleGraphics/2);
		mc:insert(mcbg);
		
		local headmc = newGroup(mc);
		local head = elite.newPixelart(headmc, "image/heads/"..scin..".png");
		-- local head = display.newImage(headmc, "image/heads/"..scin..".png");
		-- head:scale(scaleGraphics/2, scaleGraphics/2);
		links['select_hero_'..hero_obj.tag] = mc;
		
		mc.w, mc.h = mc.contentWidth, mc.contentHeight;
		table.insert(localGroup.buttons, mc);
		elite.addOverOutBrightness(mc, mcbg);
		mc.hint = get_txt('select')..": "..hero_obj.tag;
		mc.act = function()
			royal:updateMe("hero", hero_obj.tag, function()
				-- royal:getUserObj(save_obj.lobbyId, function()
					-- show_msg('user acknowledged');
				-- end);
				heroesmc:refresh();
				onlinemc:refresh();
			end);
		end
	end
	
	heroesmc.sel1 = display.newRoundedRect(heroesmc, 0, 0, 29*scaleGraphics, 28*scaleGraphics, 5*scaleGraphics);
	heroesmc.sel1:setFillColor(0, 0, 0, 0);
	heroesmc.sel1.strokeWidth = 3*scaleGraphics;
	heroesmc.sel1:setStrokeColor(1, 0, 0);
	function heroesmc:refresh()
		if(heroesmc.parent==nil)then
			return
		end
		if(myUserEntry and myUserEntry.hero)then
			local headmc = links['select_hero_'..myUserEntry.hero];
			heroesmc.sel1:toBack();
			heroesmc.sel1.x, heroesmc.sel1.y = headmc.x, headmc.y;
		end
	end
	function localGroup:resetTimers()
		if(localGroup.timerUpdateState)then
			timer.cancel(localGroup.timerUpdateState);
			localGroup.timerUpdateState = nil;
		end
		if(localGroup.timerUpdatePlayers)then
			timer.cancel(localGroup.timerUpdatePlayers);
			localGroup.timerUpdatePlayers = nil;
		end
	end
	function localGroup:removeAll()
		localGroup:resetTimers();
	end

	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end