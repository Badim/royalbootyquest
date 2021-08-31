----------
-- you have to declare moregames_callback
-- moregames_callback = function()
	-- director:changeScene("src.screenMenu");
-- end
-- require("moreEliteGames.ScreenMore").loadMoreGamesXML(); -- updating moregames_xml
-- local wnd_mc = require("moreEliteGames.ScreenMore").new(); -- show more games on screen
----------
print("screenMore 2.15"); -- parent - Royal Heroes
module(..., package.seeall);

--_W = display.contentWidth;
--_H = display.contentHeight;

local callbackExit;

function loadFile(fname)
	local path =  system.pathForFile(fname, system.DocumentsDirectory);
	local file = io.open( path, "r" );
	if (file) then
		local contents = file:read( "*a" );
		io.close( file )
		if(contents and #contents>0)then
			return contents;
		end
	end
	return nil
end
function saveFile(fname, save_str)
	local path = system.pathForFile( fname, system.DocumentsDirectory);
	local file = io.open(path, "w+b");
	if file then
		file:write(save_str);          
		io.close( file )
		print("Saving("..fname.."): ok!")
	else
		print("Saving("..fname.."): fail!")
	end
end

function moreGamesLoaderHandler(event)
	local function loadOfflineCopy()
		moregamesXml = xml:loadFile("moreEliteGames/moregames.xml");
	end
	
	local function try()
		moregamesXml = xml:ParseXmlText(event.response);
		local currentDate =  os.date( "*t" );
		if(Json)then
			saveFile("moredate", Json.Encode(currentDate));
			saveFile("morexml",  Json.Encode(moregamesXml));
		end
		if(json)then
			saveFile("moredate", json.encode(currentDate));
			saveFile("morexml",  json.encode(moregamesXml));
		end
	end
	
	if event.isError then
		print("__error:", event.isError)
		loadOfflineCopy();
	else
		if pcall(try) then
		else
			loadOfflineCopy();
		end
	end	
end

function loadMoreGamesXML(temp1, new_url)
	print("__loadMoreGamesXML:", new_url, temp1)
	local need_update = false;

	local date_json = loadFile("moredate");
	if(date_json)then
		local old_time
		if(Json)then old_time = Json.Decode(date_json); end
		if(json)then old_time = json.decode(date_json); end
		local new_time = os.date( "*t" );
		local days = math.abs(new_time.yday - old_time.yday);
		local years = math.abs(new_time.year  - old_time.year);
		if(days > 2 or years>0)then
			need_update = true;
		else
			local date_xml = loadFile("morexml");
			if(date_xml)then
				-- print("date_xml", date_xml:sub(1,1), date_xml:sub(1,1)=='{');
				if(date_xml:sub(1,1)=='{')then
					if(Json)then
						local temp_xml = Json.Decode(date_xml);
						moregamesXml = temp_xml;
					end
					if(json)then
						local temp_xml = json.decode(date_xml);
						moregamesXml = temp_xml;
					end
				end
			else
				need_update = true;
			end
		end
	else
		need_update = true;
	end
	
	if(need_update)then
		if(new_url)then
			network.request(new_url, "GET", moreGamesLoaderHandler);
		else
			network.request( "http://theelitegames.net/moreigames/moregames.xml", "GET", moreGamesLoaderHandler);
		end
	else
		if(ads_xml_set)then
			ads_xml_set(moregamesXml)
		end
	end
end

function setCallback(val)
	callbackExit = val;
end

local function getChildByName(thisxml, value)
	for i=1,#thisxml.child do
		if(thisxml.child[i].name == value)then
			return thisxml.child[i]
		end
	end
end

function getURL(tar_name)
	local thisBuild = 'ios'; --"ios"/"android"/"amazon"/"nook"
	if(optionsBuild)then
		thisBuild = optionsBuild;
		if(options_steam)then
			thisBuild = "win32";
		end
	end
	local games_xml = xml:get_xml_by_cname(moregamesXml, "games");
	if(games_xml)then
		for i = 1, #games_xml.child do
			local item_xml = games_xml.child[i];
			local item_name = item_xml.properties["name"];
			if(item_name == tar_name)then
				if(thisBuild == "ios" and item_xml.properties["url"])then
					return item_xml.properties["url"]
				elseif(thisBuild == "android" and item_xml.properties["androidurl"])then
					return item_xml.properties["androidurl"];
				elseif(thisBuild == "amazon" and item_xml.properties["amazonurl"])then
					return item_xml.properties["amazonurl"];
				elseif(thisBuild == "nook" and item_xml.properties["nookurl"])then
					return item_xml.properties["nookurl"];
				elseif(thisBuild == "samsung" and item_xml.properties["samsung"])then
					return item_xml.properties["samsung"];
				elseif(thisBuild and item_xml.properties[thisBuild])then
					return item_xml.properties[thisBuild]
				end
			end
		end
	end
	return nil;
end
function getBanner(target_mc)
	local localGroup = display.newGroup();
	
	local thisBuild = 'ios'; --"ios"/"android"/"amazon"/"nook"
	if(optionsBuild)then
		thisBuild = optionsBuild;
		if(options_steam)then
			thisBuild = "win32";
		end
	end
	local games_xml = xml:get_xml_by_cname(moregamesXml, "games");
	if(games_xml)then
		local games_list = {};
		for i = 1, #games_xml.child do
			local item_xml = games_xml.child[i];
			local item_name = item_xml.properties["name"];
			if(item_name == moregamesName)then
				item_xml.properties["banner"] = nil;
			end
			--print(thisBuild, item_xml.properties["url"], item_xml.properties["banner"])
			if(item_xml.properties["banner"])then
				if(thisBuild == "ios" and item_xml.properties["url"])then
					item_xml.properties["thisurl"] = item_xml.properties["url"];
					table.insert(games_list, item_xml);
				elseif(thisBuild == "android" and item_xml.properties["androidurl"])then
					item_xml.properties["thisurl"] = item_xml.properties["androidurl"];
					table.insert(games_list, item_xml);
				elseif(thisBuild == "amazon" and item_xml.properties["amazonurl"])then
					item_xml.properties["thisurl"] = item_xml.properties["amazonurl"];
					table.insert(games_list, item_xml);
				elseif(thisBuild == "nook" and item_xml.properties["nookurl"])then
					item_xml.properties["thisurl"] = item_xml.properties["nookurl"];
					table.insert(games_list, item_xml);
				elseif(thisBuild == "samsung" and item_xml.properties["samsung"])then
					item_xml.properties["thisurl"] = item_xml.properties["samsung"];
					table.insert(games_list, item_xml);
				elseif(thisBuild and item_xml.properties[thisBuild])then
					item_xml.properties["thisurl"] = item_xml.properties[thisBuild];
					table.insert(games_list, item_xml);
				end
			end
		end
		--print("_games_list:", #games_list)
		if(#games_list > 0)then
			local game_list_id = math.floor(math.random()*0.99999*#games_list)+1;
			local game_xml = games_list[game_list_id];
			local banner_url = game_xml.properties["banner"];
			local link = game_xml.properties["thisurl"];
			--print("_banner_url:", banner_url)
			local banner_mc = require("moreEliteGames.ItemBanner").new(banner_url, link);
			
			if(_W > 1600)then
				banner_mc.xScale, banner_mc.yScale = 2, 2;
			elseif(_W < 900)then
				banner_mc.xScale, banner_mc.yScale = 0.75, 0.75;
			elseif(_W < 800)then
				banner_mc.xScale, banner_mc.yScale = 0.5, 0.5;
			end
			banner_mc.x, banner_mc.y = _W/2, _H-90*banner_mc.yScale/2;
			if(target_mc)then
				target_mc:insert(banner_mc);
			end
			
			return banner_mc;
		end
	end
	return nil;
end

function new()
	local localGroup = display.newGroup();
	localGroup.name = "more";
	local shopGroup = display.newGroup();
	local gamesGroup = display.newGroup();
	
	local addOverOutBrightness = function(mc, body)
		if(body==nil)then body = mc; end
		function mc:onOver()
			if(body.fill)then
				body.fill.effect = "filter.brightness";
				body.fill.effect.intensity = 0.1;
			elseif(body.numChildren)then
				for i=1,body.numChildren do
					if(body[i].fill)then
						body[i].fill.effect = "filter.brightness";
						body[i].fill.effect.intensity = 0.1;
					end
				end
			end
		end
		function mc:onOut()
			if(body.fill)then
				body.fill.effect = nil;
			elseif(body.numChildren)then
				for i=1,body.numChildren do
					if(body[i].fill)then
						body[i].fill.effect = nil;
					end
				end
			end
		end
	end
	
	_G.more_games_looked = true;
	
	local scaleGraphics = scaleGraphics;
	
	local dxText = 250*scaleGraphics;
	local dyText = 30*scaleGraphics;
	local close = false; 
	local nameScreen = "";
	local urlGame = "";
	local fontMore = nil;
	
	local tfNameGame = nil;
	local tfDescShort = nil;
	local tfAddShort = nil;
	local txtDescShort = "";
	
	local login = {};
	local fileName = "gamesXml";
	
	local background = display.newRect( _W/2, _H/2, _W, _H );
	if(options_console)then
		background:setFillColor( 40/255, 121/255, 155/255);
	else
		background:setFillColor( 45/255, 132/255, 168/255);
	end
	localGroup:insert(background);
	
	if(removeHint)then
		removeHint();
	end
	
	local bgBorderUp = display.newImage("moreEliteGames/image/bgBorderUp.png", 0, 0 );
	bgBorderUp.xScale = _W/800;
	bgBorderUp.yScale = 0.5*scaleGraphics;
	bgBorderUp.x = bgBorderUp.width/2*bgBorderUp.xScale;
	bgBorderUp.y = bgBorderUp.height/2*bgBorderUp.yScale + options_save_border_h*scaleGraphics;
	localGroup:insert(bgBorderUp);
	local logoElitegames = display.newImage("moreEliteGames/image/logoElitegames.png", 0, 0 );
	logoElitegames.xScale = 0.5*scaleGraphics;
	logoElitegames.yScale = 0.5*scaleGraphics;
	logoElitegames.x = _W - logoElitegames.width/2*logoElitegames.xScale - options_save_border_w*scaleGraphics;
	logoElitegames.y = bgBorderUp.y;
	localGroup:insert(logoElitegames);
	
	local bgBorder = display.newImage("moreEliteGames/image/bgBorder.png", 0, 0 );
	bgBorder.xScale = _W/800;
	bgBorder.yScale = 0.5*scaleGraphics;
	bgBorder.x = bgBorder.width/2*bgBorder.xScale;
	bgBorder.y = _H - bgBorder.height/2*bgBorder.yScale - options_save_border_h*scaleGraphics;
	localGroup:insert(bgBorder);
	
	local bgSelectGames = display.newImage(localGroup, "moreEliteGames/image/bgSelectGames.png");
	bgSelectGames.xScale = 0.5*scaleGraphics;
	bgSelectGames.yScale = 0.5*scaleGraphics;
	bgSelectGames.x = 0;
	bgSelectGames.y = _H - bgSelectGames.height/2*bgSelectGames.yScale - options_save_border_h*scaleGraphics;
	bgSelectGames.isVisible = false;
	
	local toptxt = display.newText(localGroup, get_txt('more_games'), _W/2, 16*scaleGraphics, fontMore, 18*scaleGraphics);
	-- toptxt:setTextColor(248/255, 90/255, 24/255);
	-- toptxt:setTextColor(1/1, 1/2, 1/3);
	
	local tfAddD = 18*scaleGraphics;
	local tfStartY = 76;
	local tfAddShort1 = display.newText( "", 0, 0, fontMore, 16*scaleGraphics);
	tfAddShort1:setTextColor( 255,255,255 );
	tfAddShort1.y = tfStartY*scaleGraphics + options_txt_offset + tfAddD*1 + options_save_border_h*scaleGraphics;
	local tfAddShort2 = display.newText( "", 0, 0, fontMore, 16*scaleGraphics);
	tfAddShort2:setTextColor( 255,255,255 );
	tfAddShort2.y = tfStartY*scaleGraphics + options_txt_offset + tfAddD*2 + options_save_border_h*scaleGraphics;
	local tfAddShort3 = display.newText( "", 0, 0, fontMore, 16*scaleGraphics);
	tfAddShort3:setTextColor( 255,255,255 );
	tfAddShort3.y = tfStartY*scaleGraphics + options_txt_offset + tfAddD*3 + options_save_border_h*scaleGraphics;
	local tfAddShort4 = display.newText( "", 0, 0, fontMore, 16*scaleGraphics);
	tfAddShort4:setTextColor( 255,255,255 );
	tfAddShort4.y = tfStartY*scaleGraphics + options_txt_offset + tfAddD*4 + options_save_border_h*scaleGraphics;
	local tfAddShort5 = display.newText( "", 0, 0, fontMore, 16*scaleGraphics);
	tfAddShort5:setTextColor( 255,255,255 );
	tfAddShort5.y = tfStartY*scaleGraphics + options_txt_offset + tfAddD*5 + options_save_border_h*scaleGraphics;
	
	local tfAddShorts ={};
	table.insert(tfAddShorts , tfAddShort1);
	table.insert(tfAddShorts , tfAddShort2);
	table.insert(tfAddShorts , tfAddShort3);
	table.insert(tfAddShorts , tfAddShort4);
	table.insert(tfAddShorts , tfAddShort5);
	
	local _gameCurentX, _gameCurentY = nil, nil
	local function currentSelectGame(value)
		bgSelectGames.x = value;
		bgSelectGames.isVisible = true;
	end	
	
	local dtxt_body;
	local function currentDescGame(value)
		txtDescShort = value.descShort;

		tfNameGame.text = value.name;
		tfDescShort.text = txtDescShort;
		
		tfDescShort.size = 16*scaleGraphics;
		while(tfDescShort.width>_W)do
			tfDescShort.size = tfDescShort.size-1;
		end
		
		for i = 1, 5 do
			tfAddShorts[i].text = "";
		end
		
		tfNameGame.x = _W/2;
		tfNameGame.y = 50*scaleGraphics + options_txt_offset + options_save_border_h*scaleGraphics;
		tfDescShort.x = _W/2;
		tfDescShort.y = 74*scaleGraphics + options_txt_offset + options_save_border_h*scaleGraphics;
		urlGame = value.url;
			
		
		if(dtxt_body)then
			dtxt_body:removeSelf();
			dtxt_body = nil;
		end
		
		
		
		if(value.descBody)then
			dtxt_body = display.newText({parent=localGroup, text=value.descBody, fontSize=16*scaleGraphics, width=_W-60*scaleGraphics, x=_W/2, y=90*scaleGraphics});
			dtxt_body.anchorY = 0;
			dtxt_body.y = tfDescShort.y + 20*scaleGraphics;
			while(dtxt_body.height>_H-250*scaleGraphics and dtxt_body.size>6)do
				dtxt_body.size = dtxt_body.size-1;
			end
		else
			local min_width = 100;
			local addX = value.descAddX;
			for i = 1, #addX.child do
				local item_xml = value.descAddX.child[i];
				tfAddShorts[i].size = 16*scaleGraphics;
				tfAddShorts[i].text = item_xml.value;
				tfAddShorts[i].x = 20+tfAddShorts[i].width/2 + options_save_border_w*scaleGraphics;
				min_width = math.max(min_width, tfAddShorts[i].width);
			end

			while(min_width>_W-30)do
				min_width = 100;
				for i = 1, #addX.child do
					tfAddShorts[i].size = tfAddShorts[i].size-1;
					tfAddShorts[i].x = 20+tfAddShorts[i].width/2;
					min_width = math.max(min_width, tfAddShorts[i].width);
				end
			end
		end
	end
	
	-- Decription -- 
	tfNameGame = display.newText( '', 0, 0, fontMore, 22*scaleGraphics );
	tfNameGame:setTextColor( 255,255,255 );
	shopGroup:insert(tfNameGame);
	tfDescShort = display.newText( '', 0, 0, fontMore, 16*scaleGraphics );
	tfDescShort:setTextColor( 255,255,255 );
	shopGroup:insert(tfDescShort);
	--tfAddShort = display.newText( "", 0, 0, fontMore, 16*scaleGraphics );
	--tfAddShort:setTextColor( 255,255,255 );
	--shopGroup:insert(tfAddShort);
	shopGroup:insert(tfAddShort1);
	shopGroup:insert(tfAddShort2);
	shopGroup:insert(tfAddShort3);
	shopGroup:insert(tfAddShort4);
	shopGroup:insert(tfAddShort5);
	shopGroup:insert(gamesGroup);	
	
	local gamesItemsGroup = display.newGroup();
	gamesGroup:insert(gamesItemsGroup);
	
	local games_added_counter = 0;
	local buttons = {};
	local menu = buttons;
	
	local function parse()
		if(ads_xml_set)then
			ads_xml_set(moregamesXml)
		end
		if(moregamesXml == nil)then
			return
		end
		local gamesXml = getChildByName(moregamesXml, "games");
		if(gamesXml==nil)then
			return
		end
		local countGames = #gamesXml.child;
		local stepX = 100*scaleGraphics;
		local stepY = 100*scaleGraphics;
		
		-- clear content
		--print("_gamesItemsGroup.numChildren:",gamesItemsGroup.numChildren)
		while(gamesItemsGroup.numChildren > 0)do
			if(gamesItemsGroup[1])then
				gamesItemsGroup[1]._dead = true;
				gamesItemsGroup[1]:removeSelf();
			end
		end
		
		-- iPad
		countGames = math.floor(_W/(scaleGraphics*100));
		print("_countGames:",countGames)
		--if(_H/_W == 0.75)then
		--	if(countGames > 5)then
		--		countGames = 5;
		--	end
		--else
		--	if(countGames > 4)then
		--		countGames = 4;
		--	end
		--end
		
		----- create games -----
		local ix = 1;
		local thisBuild = 'ios';
		
		local function transitionRotateAgain(obj)
			obj.rotation = 0;
			transition.to(obj, { time=1700, rotation=360, onComplete=transitionRotateAgain});
		end
		local function get_fname(img)
			local r = nil;
			for token1 in string.gmatch(img, "[^/]+") do
				r=token1;
			end
			return r;
		end
		
		if(optionsBuild)then
			thisBuild = optionsBuild;
			if(options_steam)then
				thisBuild = "win32";
			end
		end
		local image_dt= 16*scaleGraphics;
		
		local new_list = {};
		if(#gamesXml.child>0)then
			if(#gamesXml.child>1)then
				for i = 2, #gamesXml.child do
					local item_xml = gamesXml.child[i];
					if(math.random()>0.5)then
						table.insert(new_list, 1, item_xml);
					else
						table.insert(new_list, item_xml);
					end
				end
			end
			table.insert(new_list, 1, gamesXml.child[1]);
		end
		
		for i = 1, #new_list do
			local _id = i;
			local item_xml = new_list[i];
			local _name = item_xml.properties["name"];
			local _tar = item_xml.properties["tar"];
			local _img = item_xml.properties["img"];
			local _url = nil;

			if(thisBuild == "ios")then
				if(item_xml.properties["url"])then
					_url = item_xml.properties["url"];
				end
			end
			if(thisBuild == "amazon")then
				if(item_xml.properties["amazonurl"])then
					_url = item_xml.properties["amazonurl"];
				end
			end
			if(thisBuild == "android")then
				if(item_xml.properties["androidurl"])then
					_url = item_xml.properties["androidurl"];
				end
			end
			if(thisBuild == "nook")then
				if(item_xml.properties["nookurl"])then
					_url = item_xml.properties["nookurl"];
				end
			end
			if(thisBuild == "samsung")then
				if(item_xml.properties["samsung"])then
					_url = item_xml.properties["samsung"];
				end
			end
			if(thisBuild)then
				if(item_xml.properties[thisBuild])then
					_url = item_xml.properties[thisBuild];
				end
			end
			if(options_steam)then
				if(item_xml.properties.steam)then
					_url = item_xml.properties.steam;
				end
			end
			
			if(_name == moregamesName)then
				_url = nil;
			end

			if(_url)then
				local _xml = item_xml;
				local _game = display.newGroup();--require("moreEliteGames.ItemGame").new(_id, stepX, _name, _tar, _img, _url, localGroup);
				_game._selected = false;
				_game.w, _game.h = stepX,stepX;
				_game._over = display.newImage(_game, "moreEliteGames/image/bgSelectGames.png");
				_game._over.xScale = 0.5*scaleGraphics;
				_game._over.yScale = 0.5*scaleGraphics;
				_game._over.alpha = 0;
				_game._over.blendMode = "add";
				_game._over.x, _game._over.y = 0,0;
				
			
				
				local icoLoading = display.newImage(_game, "moreEliteGames/image/icoLoading.png");
				transitionRotateAgain(icoLoading);
				icoLoading.x, icoLoading.y = 0,-10*scaleGraphics;
				
				local tfName = display.newText(_game, _name, 0, 0, nil, 10*scaleGraphics);
				tfName.anchorX, tfName.anchorY = 0.5,0.5;
				tfName.x, tfName.y = 0, stepX/2-12*scaleGraphics;
				
				local file_name = get_fname(_img);
				local path = system.pathForFile(file_name, system.DocumentsDirectory);
				
				local imgGame, icoNew;
				
				if(ix == 1)then
					icoNew = display.newImage(_game, "moreEliteGames/image/new.png");
					icoNew.xScale, icoNew.yScale = scaleGraphics*0.75,scaleGraphics*0.75;
					icoNew.x = -4*scaleGraphics + (stepX-image_dt)/2;
					icoNew.y = -6*scaleGraphics - (stepX-image_dt)/2;
				end
				
				local fhd = io.open(path);
				if(fhd)then
					imgGame = display.newImage(file_name, system.DocumentsDirectory);
					imgGame.width, imgGame.height = stepX-image_dt,stepX-image_dt;
					imgGame.x, imgGame.y = icoLoading.x, icoLoading.y;
					transition.from( imgGame, { time=600, alpha = 0 } )
					_game:insert(imgGame)
					icoLoading:removeSelf();
					if(icoNew)then
						_game:insert(icoNew);
					end
					--loadImage();
					
				else
					local function networkListener(event)
						print("_event:", event, localGroup._dead, _game._dead);
						if(localGroup._dead)then
							return false;
						end
						if(_game._dead)then
							return false;
						end

						if ( event.isError ) then
							imgGame = display.newImage("moreEliteGames/image/elite_100x100.png", 0, 0);
						else
							imgGame = display.newImage(file_name, system.DocumentsDirectory, 0, 0);
						end
						
						if(imgGame)then
							imgGame.width, imgGame.height = stepX-image_dt,stepX-image_dt;
							imgGame.x, imgGame.y = icoLoading.x, icoLoading.y;
							transition.from( imgGame, { time=400, alpha = 0, transition=easing.inQuad } );
							if(_game.insert)then
								_game:insert(imgGame);
							end
						end
						
						transition.to(icoLoading, {time=200, alpha=0, transition=easing.inQuad, onComplete=transitionRemoveSelfHandler});
						icoLoading = nil;
						
						if(icoNew and _game.insert)then
							_game:insert(icoNew);
						end
					end
					network.download(_img, "GET", networkListener, file_name, system.DocumentsDirectory);
				end

				_game.name = _name;
				_game.url = _url;
				_game.otherUrls = getChildByName(item_xml, "otherUrls");
				_game.descShort = getChildByName(item_xml, "descShort").value;
				_game.descAddX = getChildByName(item_xml, "descAddX");
				_game.x = (ix-1)*stepX + stepX/2;--(_W-current_max*stepX/2)/2+
				_game.y = math.floor(bgBorder.y);
				
				_game.w = 100*scaleGraphics;
				_game.h = 100*scaleGraphics;
				
				function _game:onOver()
					-- if(imgGame)then
						-- imgGame.fill.effect = "filter.brightness";
						-- imgGame.fill.effect.intensity = 0.1;
					-- end
					tfName:setTextColor(0,1,1);
				end
				function _game:onOut()
					-- if(imgGame)then
						-- imgGame.fill.effect = nil;
					-- end
					tfName:setTextColor(1);
				end
				
				-- print("_language:", language);
				if(language)then
					if(language.current_id)then
						local lang_id = get_name_id(language.current_id);
						local node = getChildByName(item_xml, "descShort_"..lang_id);
						if(node)then
							_game.descShort = node.value;
						end
						
						local node = getChildByName(item_xml, "descBody_"..lang_id);
						if(node)then
							_game.descBody = node.value;
						end
					end
				end
				
				_game.act = function()
					if(localGroup.selected_game==_game)then
						system.openURL(_game.url);
					else
						localGroup:selectGame(_game);
					end
				end
				
				gamesItemsGroup:insert(_game);
				table.insert(buttons, _game);
				
				ix= ix+1;
				games_added_counter=games_added_counter+1;

				if(ix>=countGames)then
					break;
				end
			end
		end
		--gamesItemsGroup.x = _W/2 - gamesGroup.width/2*gamesGroup.xScale;
		--gamesItemsGroup.y = math.floor(bgBorder.y);
		
		
		
		for i=1,gamesItemsGroup.numChildren do
			local _game = gamesItemsGroup[i];
			_game.x = (i-1)*stepX + (_W-stepX*gamesItemsGroup.numChildren)/2 + stepX/2;
		end
		
		if(gamesItemsGroup.numChildren>0)then
			_gameCurentX, _gameCurentY = gamesItemsGroup[1]:localToContent( 0, 0 ); -- localToGlobal
			currentSelectGame(_gameCurentX);
			currentDescGame(gamesItemsGroup[1]);
		end
		
		
	end
	
	parse();
	
	if(games_added_counter<1)then
		local tfName = display.newText(localGroup, 'COMING SOON!', 0, 0, nil, 20*scaleGraphics);
		tfName.x = _W/2;
		tfName.y = 18*scaleGraphics;
	end
	
	local function showHint(event)
		addHint(event.target.name);
	end
	
	local function getIt(event)
		-- if(event.phase == "ended") then
			-- if(bgBorderUp.height ~= nil and bgBorder.height ~= nil)then
				-- if(event.y > bgBorderUp.y + bgBorderUp.height/2*bgBorderUp.yScale and
					-- event.y < bgBorder.y - bgBorder.height/2*bgBorder.yScale)then
					-- system.openURL(urlGame);
				-- end
			-- end
		-- end
	end
	
	local pointer_mc = nil;
	if(options_console)then
		pointer_mc = display.newGroup();
		pointer_mc.i = 1;
		
		local function pointer_set(tar_mc)
			if(pointer_mc.pbody)then
				if(pointer_mc.pbody.removeSelf)then pointer_mc.pbody:removeSelf(); end;
				pointer_mc.pbody = nil;
			end
			local pbody = display.newRoundedRect(localGroup, 0, 0, tar_mc.w+2*scaleGraphics, tar_mc.h+2*scaleGraphics, 2*scaleGraphics);
			pbody:setFillColor(1,1,1,0.1);
			pointer_mc.blendMode = "add";
			pointer_mc:insert(pbody);
			pointer_mc.pbody = pbody;
			
			tar_mc.parent:insert(pointer_mc.pbody);
			pointer_mc.pbody.x, pointer_mc.pbody.y = tar_mc.x, tar_mc.y;
			
			transition.to(tar_mc._over, {time=180, alpha=1.0});
			if(pointer_mc.i_old)then
				if(menu[pointer_mc.i_old])then
					transition.to(menu[pointer_mc.i_old]._over, {time=180, alpha=0.0});
				end
			end
			
			
			
			pointer_mc.i_old = pointer_mc.i;
		end
		
		localGroup.pointer_refresh = function()
			if(menu[pointer_mc.i])then
				pointer_set(menu[pointer_mc.i]);
				--if(info_global_show)then info_global_show(menu[pointer_mc.i]); end;
				if(localGroup.selectGame)then
					localGroup:selectGame(menu[pointer_mc.i]);
				end
			end
		end
		localGroup:pointer_refresh();
	end
	
	local function onKeyEvent(evt)
		local phase = evt.phase;
		local keyName = evt.keyName;
		if(mapped_keys)then if(mapped_keys[keyName])then keyName=mapped_keys[keyName]; end; end
		if(phase == "up" and options_console==false)then
			if(keyName == "back")then
				localGroup:exitHandler(evt);
				return true;
			end
		end
		
		if(phase == "down" and options_console==true)then
			if(keyName == "back")then
				localGroup:exitHandler(evt);
				return true;
			end
			if (keyName == "buttonA" or keyName=="space") then -- O button (accept)
				system.openURL(urlGame);
				return true;
			end
			if(keyName == "buttonB" or keyName == "deleteBack")then
				localGroup:exitHandler(evt);
				return true;
			end
			
			local tar = menu[pointer_mc.i];
			if(tar==nil)then
				return false;
			end
			local tarx, tary = tar.x, tar.y;
			if(tar.localToContent)then
				tarx, tary = tar:localToContent(0, 0);
			end
				
			if(keyName=="left" or keyName=="leftShoulderButton1" or keyName=="leftShoulderButton2")then
				local minx, miny, nexti = -999999, 999999, nil;
					for i=1,#menu do
						local menux, menuy = menu[i].x, menu[i].y;
						if(menu[i].localToContent)then
							menux, menuy = menu[i]:localToContent(0, 0);
						end
						local dx = menux - tarx;
						local dy = math.abs(menuy - tary);
						if(dx<0 and dx>=minx)then
							if(dy<1)then
								minx, miny = dx, dy;
								nexti = i;
							end
						end
				end
				if(nexti)then
					sound_play("pack_click");
					pointer_mc.i = nexti;
					localGroup:pointer_refresh();
					return true
				end
			end
			
			if(keyName=="right" or keyName=="rightShoulderButton1" or keyName=="rightShoulderButton2")then
				local minx, miny, nexti = 999999, 999999, nil;
					for i=1,#menu do
						local menux, menuy = menu[i].x, menu[i].y;
						if(menu[i].localToContent)then
							menux, menuy = menu[i]:localToContent(0, 0);
						end
						local dx = menux - tarx;
						local dy = math.abs(menuy - tary);
						if(dx>0 and dx<=minx)then
							if(dy<1)then
								minx, miny = dx, dy;
								nexti = i;
							end
						end
					end
				if(nexti)then
						sound_play("pack_click");
						pointer_mc.i = nexti;
						localGroup:pointer_refresh();
				end
				return true
			end
		end
		return false;
	end
	
	function localGroup:exitHandler(evt)
		removeAllListeners();
		
		if(callbackExit)then
			callbackExit();
		elseif(moregames_callback)then
			moregames_callback();
		end
		
	end
	-- local function clickBack(evt)
		-- if(evt.phase == "ended") then
			-- exitHandler(evt);
		-- end
	-- end
	
	if(options_console)then
		local btnMenu = display.newImage("moreEliteGames/image/btnBack.png");
		btnMenu.xScale = 0.4*scaleGraphics;
		btnMenu.yScale = 0.4*scaleGraphics;
		btnMenu.x = options_save_border_w*scaleGraphics + 20*scaleGraphics;
		btnMenu.y = options_save_border_h*scaleGraphics + 15*scaleGraphics;
		localGroup:insert(btnMenu);
		
		
		
		local red_btn = display.newImage(localGroup, "gfx/console/"..options_device.."/red.png");
		red_btn.xScale = scaleGraphics/3;
		red_btn.yScale = scaleGraphics/3;
		red_btn.x = btnMenu.x + 30*scaleGraphics;
		red_btn.y = btnMenu.y;
	else
		local btnMenu = display.newImage("moreEliteGames/image/btnBack.png");
		btnMenu.name = "menu";
		btnMenu.scene = prevScreen;
		btnMenu.xScale, btnMenu.yScale  = 0.4*scaleGraphics, 0.4*scaleGraphics;
		btnMenu.x = btnMenu.width*btnMenu.xScale/2 + 5*scaleGraphics;
		btnMenu.y = bgBorderUp.y;
		localGroup:insert(btnMenu);
		
		local menuDtxt = display.newText(localGroup, get_txt('back'), btnMenu.x+4*scaleGraphics, btnMenu.y, native.systemFontBold, 14*scaleGraphics);
		while(menuDtxt.contentWidth>46*scaleGraphics and menuDtxt.size>5)do 
			menuDtxt.size = menuDtxt.size-1; 
		end
		
		-- btnMenu:addEventListener( "touch", clickBack );
		btnMenu.w, btnMenu.h = btnMenu.contentWidth, btnMenu.contentHeight;
		function btnMenu:onOver()
			-- if(btnMenu)then
				btnMenu.fill.effect = "filter.brightness";
				btnMenu.fill.effect.intensity = 0.1;
			-- end
			-- tfName:setTextColor(0,1,1);
		end
		function btnMenu:onOut()
			-- if(imgGame)then
				btnMenu.fill.effect = nil;
			-- end
			-- tfName:setTextColor(1);
		end
		btnMenu.act = function()
			localGroup:exitHandler();
		end
		table.insert(buttons, btnMenu);
	end
	
	if(options_console ~= true)then
		local btnBuy = display.newImage("moreEliteGames/image/btnGetIt.png", 0, 0 );
		-- btnBuy.name = "buy";
		btnBuy.xScale, btnBuy.yScale  = 0.4*scaleGraphics, 0.4*scaleGraphics;
		btnBuy.x = _W - btnBuy.width*btnBuy.xScale/2 - 10*scaleGraphics;
		btnBuy.y = bgBorder.y - bgBorder.height*bgBorder.yScale/2 - btnBuy.height*btnBuy.yScale/2 - 10*scaleGraphics;
		localGroup:insert(btnBuy);
		
		table.insert(buttons, btnBuy);
		btnBuy.w, btnBuy.h = btnBuy.contentWidth, btnBuy.contentHeight;
		addOverOutBrightness(btnBuy);
		function btnBuy:act()
			system.openURL(urlGame);
		end
		
		
		local menuDtxt = display.newText(localGroup, get_txt('moregames_opens_browser_getit'), btnBuy.x, btnBuy.y, native.systemFontBold, 20*scaleGraphics);
		while(menuDtxt.contentWidth>68*scaleGraphics and menuDtxt.size>5)do 
			menuDtxt.size = menuDtxt.size-1; 
		end
	end
	
	function localGroup:selectGame(game)
		local gameCurentX, gameCurentY = game:localToContent( 0, 0 ); -- localToGlobal
		currentSelectGame(gameCurentX);
		currentDescGame(game);
		localGroup.selected_game = game;
	end
	
	localGroup:insert(shopGroup);
	
	local function hit_test_rec(mc,w,h,tx,ty)
		if(tx>mc.x-w/2 and tx<mc.x+w/2)then
			if(ty>mc.y-h/2 and ty<mc.y+h/2)then
				return true
			end
		end
		return false
	end
	local function checkButtons(evt)
		for i=1,#buttons do
			local item_mc = buttons[i];
			if(hit_test_rec(item_mc, item_mc.w, item_mc.h, evt.x, evt.y))then
				if(item_mc._selected == false)then
					item_mc._selected = true;
					localGroup:selectGame(item_mc);
					transition.to(item_mc._over, {time=180, alpha=0.3});
				end
			else
				if(item_mc._selected)then
					item_mc._selected = false;
					transition.to(item_mc._over, {time=300, alpha=0.0});
				end
			end
		end
	end
	local function touchHandler(evt)
		local phase = evt.phase;
		if(phase=='began')then
			-- checkButtons(evt);
		elseif(phase=='moved')then
			-- checkButtons(evt);
		else
			-- for i=1,#buttons do
				-- local item_mc = buttons[i];
				-- if(item_mc._selected)then
					-- localGroup:selectGame(item_mc);
					-- item_mc._selected = false;
					-- transition.to(item_mc._over, {time=300, alpha=0.0});
				-- end
			-- end
		end
	end
	
	function removeAllListeners()
		localGroup._dead = true;
		localGroup:removeEventListener("touch", touchHandler);
		-- Runtime:removeEventListener( "touch", getIt );
		Runtime:removeEventListener( "key", onKeyEvent );
	end
	
	removeAllListeners();
	localGroup._dead = false;
	
	--if(options_console)then
		Runtime:addEventListener( "key", onKeyEvent )
	--else
		-- Runtime:addEventListener( "touch", getIt );
		localGroup:addEventListener("touch", touchHandler);
	--end
	
	require("moreEliteGames.injectScrGUI").inject(localGroup, buttons);
	
	return localGroup;
end