print("eliteAchievement  2.4, resetting _G.setting(corona thing)"); -- home - RBQ
module(..., package.seeall);

function new(icos_patch, pfile, b_size)
	local localGroup = display.newGroup();
	local unlockAchievments = {};
	local unlockRewardsPer = {};
	local arIcoAchiev = {};
	local gamecenterIDS={};
	local rewardsSubmitedSuccess = {};
	local arTfAchiev = {};
	local arValue = {};
	local _value = nil;
	local _timerAchiev = nil;
	local _timerNext = nil;
	local _countAchiv = 0;
	local _show = true;
	localGroup._list = {}

	localGroup.def_ico_pfile = pfile;
	localGroup.icos_patch = icos_patch;
	local steamworks;-- = require( "plugin.steamworks" )
	if(b_size==nil)then b_size=46; end
	
	localGroup._google_status = -1;
	local gameNetwork = nil;
	local gpgs = nil;
	if(options_gamecenter)then
		if(optionsBuild == "android")then
			gpgs = require( "plugin.gpgs" );
		else
			gameNetwork = require "gameNetwork";
		end
	end
	
	function _G.submitScoresExt(name, val)
		if(name)then
			localGroup:submitScore(name, val);
		end
	end
	
	function localGroup:showScores()
		if(gpgs)then
			gpgs.leaderboards.show();
		end
		if(gameNetwork)then
			gameNetwork.show("leaderboards");
		end
	end
	
	function localGroup:submitScore(name, val)
		local function initCallback( event )
			-- if event.data then
				--native.showAlert( "Success!", "", { "OK" } )
				--show_msg("_submitScoresExt("..name.."):".. tostring(val).." Success!");
			-- end
		end
		if(gpgs)then
			gpgs.leaderboards.submit( {leaderboardId = name, score=val, listener=initCallback} );
		end
		if(gameNetwork)then
			gameNetwork.request("setHighScore", {localPlayerScore = { category=name, value=val},listener=initCallback});
		end
		-- local steamworks = _itemAchievement:getSteamworks();
		if(steamworks)then
			steamworks.requestSetHighScore( {
				leaderboardName = name,
				value = val,
				listener = function(e) end,
			} );
		end

	end
	
	function localGroup:getIcoPatch(value)
		return localGroup.def_ico_pfile;
	end
	function localGroup:getSteamworks()
		return steamworks;
	end
	
	function localGroup:getRewardsSubmitedSuccess()
		return rewardsSubmitedSuccess;
	end
	function localGroup:setRewardsSubmitedSuccess(val)
		rewardsSubmitedSuccess = val;
	end
	
	local function eliteAchievementReqestHandler(evt)
		local gs_id = evt.data.identifier;
		if(unlockRewardsPer[gs_id] == 100)then
			rewardsSubmitedSuccess[gs_id] = true;
			if(options_debug)then
				show_msg('reward_unlocked:'..gs_id)
			end
		end
	end
	
	function localGroup:refreshMyData(force)
		local function setPlayerName(val, force)
			_G.playerName = val;
			save_obj.playerName = val;
			
			if(force)then
				localGroup._google_status = 9;
				if(_G.playerName)then show_msg('Welcome '.._G.playerName..'!'); end
				save_obj.google_ok = true;
			else
				if(_G.playerName)then show_msg('Welcome '.._G.playerName..'!'); end
			end
		end
		local function loadLocalPlayerCallback( event )
			localGroup._google_status = 6;
			setPlayerName(event.data.alias, force);
		end
		
		if(gpgs)then
			localGroup._google_status = 5;
			-- show_msg('Who is here? (debug)');
			gpgs.getAccountName({listener=function(event)
				if(event.isError)then
					show_msg('error@who:'..tostring(event.errorCode).."/"..tostring(event.errorMessage));
				else
					show_msg('answer@who:'..tostring(event.name).."/"..tostring(event.accountName));
					-- event.name
					-- event.isError
					-- event.errorMessage
					-- event.errorCode
					-- event.accountName
				
					localGroup._google_status = 6;
					setPlayerName(event.accountName, force);
				end
			end});
		end
		if(gameNetwork)then
			localGroup._google_status = 5;
			gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } );
		end
	end
	
	local function initCallback( event )
		if event.data then
			--native.showAlert( "Success!", "", { "OK" } )
		end
	end
	
	
	if(options_steam and optionsPublisher=="elitegames")then
		steamworks = require("plugin.steamworks");
		
		local function onSteamOverlayStatusChanged( event )
			-- show_msg( "Steam overlay phase: " .. event.phase )
		end
		steamworks.addEventListener( "overlayStatus",  onSteamOverlayStatusChanged );
		
		local function onAchievementInfoUpdated( event )
			local achievementInfo = steamworks.getAchievementInfo( event.achievementName )
			-- show_msg( "Achievement Progress Updated" ..achievementInfo.localizedName);
			print( "  Localized Name: " .. achievementInfo.localizedName )
			print( "  Localized Description: " .. achievementInfo.localizedDescription )
			print( "  Is Unlocked: " .. tostring(achievementInfo.unlocked) )
		end
		steamworks.addEventListener( "achievementInfoUpdate", onAchievementInfoUpdated )

		-- local function onSteamUserInfoUpdated( event )
			-- local userInfo = steamworks.getUserInfo( event.userSteamId )
			-- show_msg( "Steam user info:" .. event.userSteamId);
			-- if ( userInfo ) then
				-- show_msg( "Steam user info:" .. userInfo.name);
				-- print( "User Name: " .. userInfo.name )
				-- print( "User Nickname: " .. userInfo.nickname )
				-- print( "Steam Level: " .. tostring(userInfo.steamLevel) )
				-- print( "Status: " .. userInfo.status )
			-- end
		-- end
		-- steamworks.addEventListener( "userInfoUpdate", onSteamUserInfoUpdated );
		
		function localGroup:ini()
			local userInfo = steamworks.getUserInfo();
			if(userInfo)then
				show_msg( "Welcome " .. userInfo.name.."!");
				_G.playerName = userInfo.name;
				save_obj.playerName = userInfo.name;
			end
		end
	end
	
		if(optionsBuild=="ios" or optionsBuild=="android")then
			local function initCallback( event )
				if event.data then
					localGroup:refreshMyData();
				end
			end
			-- local function loadLocalPlayerCallback( event )
				-- _G.playerName=event.data.alias;
				-- login_obj.playerName=event.data.alias;
				-- show_msg('Welcome '..login_obj.playerName..'.!')
				-- localGroup._google_status = 9;
				-- login_obj['google_ok'] = true;
			-- end
			local function gameNetworkLoginCallback( event )
				if not event.isError then
					localGroup._google_status = 4;
					loggedIntoGC = true
				else
					show_msg("GPGS.err1#Code: "..tostring(event.errorCode).."/"..tostring(event.errorMessage));
					localGroup._google_status = -1;
				end
					
				localGroup:refreshMyData(true);

				return true
			end
			
			function localGroup:iniGoogle()
				localGroup._google_status = 3;
				
				if(gpgs)then
					gpgs.login( { userInitiated=true, listener=gameNetworkLoginCallback } );
					return
				end
				if(gameNetwork)then
					gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } );
					return
				end

				localGroup._google_status = -1;
			end
			
			local function gpgsInitCallback( event )
				localGroup._google_status = 2;
				--localGroup:iniGoogle()
				if(login_obj)then
					if(login_obj['google_ok'])then
						localGroup:iniGoogle();
					end
				end
			end
			local function onSystemEvent(event)
				if (event.type == "applicationStart" and (gameNetwork or gpgs)) then
					if(optionsBuild=="ios" and gameNetwork)then
						gameNetwork.init( "gamecenter", {listener=initCallback} )
					elseif(optionsBuild == "android" and gpgs)then
						localGroup._google_status = 1;
						gpgs.init( gpgsInitCallback );
					end
					Runtime:removeEventListener( "system", onSystemEvent )
				end
				return true
			end
			Runtime:addEventListener( "system", onSystemEvent);
		end
	
	local function nextAchievement()
		if(_timerNext ~= nil)then
			timer.cancel(_timerNext);
			_timerNext = nil;
		end
		
		localGroup:show(arValue[1]);
	end
	
	local function hideAchievement()
		if(_timerAchiev ~= nil)then
			timer.cancel(_timerAchiev);
			_timerAchiev = nil;
		end
		transition.to( arIcoAchiev[_value], { time=500, alpha = 0 } );
		transition.to( arTfAchiev[_value], { time=500, alpha = 0 } );
		_countAchiv = _countAchiv - 1;
		_show = true;
		table.remove(arValue, 1);
		_timerNext = timer.performWithDelay( 500, nextAchievement, 1);
		
	end
	
	local function showAchievement(_value)
		transition.to( arIcoAchiev[_value], { time=500, alpha = 1 } );
		transition.to( arTfAchiev[_value], { time=500, alpha = 1 } );
		_timerAchiev = timer.performWithDelay( 2000, hideAchievement, 1);
	end
	
	function localGroup:show(value)
		if(_show == true and _countAchiv>0)then
			_show = false;
			_value = value;
			showAchievement(_value);
		end
	end
	
	-- local function network_submit_achievement(gs_id, per)
		-- if(options_gamecenter and gameNetwork)then
			-- local showBanner = (per == 100) and false;
				
			-- gameNetwork.request( "unlockAchievement",
			-- {
					-- achievement =
					-- {
							-- identifier=gs_id,
							-- percentComplete=per,
							-- showsCompletionBanner=false,
					-- },
					-- listener=eliteAchievementReqestHandler
			-- });
			-- if(options_debug)then
				-- eliteAchievementReqestHandler({data={identifier=gs_id}});
			-- end
		-- end
	-- end
	
	function localGroup:progresAchievement(value, per)
		-- to make sure that value is [0..100]
		per = math.max(per,0);
		per = math.min(per,100);
		
		per = math.floor(per*100)/100;
		
		local gs_id = gamecenterIDS[value];
		if(gs_id)then
			unlockRewardsPer[gs_id] = per;
			-- network_submit_achievement(gs_id, per);
		end
	end
	function localGroup:unlocked(id)
		return (unlockAchievments[id]==1);
	end
	function localGroup:createIco(obj)
		local ico = display.newGroup();
		local size_t = 30;
		local bg_mc = display.newRoundedRect(ico, 0, 0, size_t,size_t, 10);
		bg_mc.x,bg_mc.y = 0,0;
		if(localGroup.bg_alpha)then
			bg_mc.alpha = localGroup.bg_alpha;
		end
		
		bg_mc:setFillColor(0,0,0,200);
		bg_mc.strokeWidth = 3;
		if(unlockAchievments[obj.item_id]==1)then
			bg_mc:setStrokeColor(0, 250, 0,120)
		else
			bg_mc:setStrokeColor(250, 0, 0,120)
		end
		
		ico.unlocked = (unlockAchievments[obj.item_id]==1);
		
		local body = display.newImage(ico, localGroup.icos_patch .. obj.item_id .. '.png');
		if(body == nil)then
			body=display.newImage(ico, localGroup:getIcoPatch(value));
		end
		body.xScale, body.yScale = 0.50, 0.50;
		body.x, body.y = 0,0;
		ico.xScale, ico.yScale = 1*scaleGraphics, 1*scaleGraphics;
		ico._body = body;
		return ico
	end
	
	function localGroup:createAchievement(value)
		if(gamecenterIDS[value])then
		else
			print('ERROR:I DONT HAVE THIS REWARD:',value)
			return false
		end
		
		if(login_obj)then
			if(login_obj.cheat or login_obj.sandbox or login_obj.daily)then
				return false;
			end
		end
		
		local gs_id = gamecenterIDS[value];
		unlockRewardsPer[gs_id] = 100;
		
		-- if(rewardsSubmitedSuccess[gs_id] ~= true)then
			-- network_submit_achievement(gs_id, 100);
		-- end
		
		-- print("createAchievement:", value, gs_id);
		if(gameNetwork)then
			gameNetwork.request("unlockAchievement", {achievement = {identifier=gs_id, percentComplete=100, showsCompletionBanner=false},
				listener=eliteAchievementReqestHandler
			});
		end
		if(gpgs)then
			gpgs.achievements.unlock( {achievementId=gs_id} );
		end
		if(steamworks)then
			steamworks.setAchievementUnlocked(gs_id);
		end
		
		if(unlockAchievments[value] == 1)then
			return;
		end
		
		-- if(gs_id)then
			-- analytics_mc:rewardGet(gs_id);
		-- end
		
		unlockAchievments[value] = 1;
		localGroup:setAchievments(unlockAchievments);
		_countAchiv = _countAchiv + 1;
		table.insert(arValue, value);
		
		local ico = display.newGroup();
		arIcoAchiev[value] = ico;
		
		local size_t = b_size;
		local bg_mc = display.newRoundedRect(ico, 0, 0, size_t,size_t, 10);
		bg_mc.x,bg_mc.y = 0,0;
		bg_mc:setFillColor(0,0,0,200);
		bg_mc.strokeWidth = 3;
		bg_mc:setStrokeColor(0, 250, 0,120)
		if(localGroup.bg_alpha)then
			bg_mc.alpha = localGroup.bg_alpha;
		end
		
		local body = display.newImage(ico, localGroup.icos_patch..value..'.png');
		if(body == nil)then
			body=display.newImage(ico, localGroup:getIcoPatch(value));
		end
		body.x, body.y = 0,0;
		
		ico.x, ico.y = 0, 0;
		ico.xScale, ico.yScale = 1*scaleGraphics, 1*scaleGraphics;
		ico.alpha = 0.01;
		localGroup:insert(ico);
		
		localGroup.y = _H - localGroup.height/2 - 10*scaleGraphics ;
		
		localGroup:show(arValue[1]);
	end
	
	function localGroup:addItemGCID(item_id, ios_id, google_id, steam_id, steam_lid)
		-- gamecenterIDS[item_id] = ios_id;
		if(optionsBuild=="ios")then
			gamecenterIDS[item_id] = ios_id;
		end
		if(optionsBuild=="android")then
			gamecenterIDS[item_id] = google_id;
		end
		if(optionsBuild=="win32" or optionsBuild=="mac")then
			gamecenterIDS[item_id] = steam_id;
		end
		table.insert(unlockAchievments, 0);
		
		local obj = {};
		obj.item_id = item_id;
		obj.ico_patch=localGroup.icos_patch..item_id..'.png';
		obj.ios_id = ios_id;
		obj.steam_id = steam_lid or steam_id;
		table.insert(localGroup._list, obj);
	end
	
	function localGroup:setAchievments(value)
		if(value)then
			local newAch = #unlockAchievments - #value;
			if(newAch > 0)then
				for i = 1, newAch do
					table.insert(value, 0);
				end
			end
			unlockAchievments = value;
		end
	end
	function localGroup:getAchievments()
		return unlockAchievments;
	end
	
	function localGroup:getUnlocked()
		local unlocked = 0
		for i=1, #unlockAchievments do
			local a=unlockAchievments[i]
			if(a==1)then
				unlocked=unlocked+1;
			end
		end
		return unlocked;
	end
	
	localGroup.x = _W/2;
	return localGroup;
end