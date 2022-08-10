-- elite bug tracker v.1.11 - home: Royal Heroes 
-- added class=login_obj.class for Royal BOoty Quest
-- added findDupes
do
	if(moregamesName==nil)then
		show_msg("game name is not set!");
	end
	
	local json = require("json");
	local firebase = require('firebase'); -- arenabadim@gmail.com
	local bug_bg = firebase('https://royal-bugs.firebaseio.com/'); 
	
	local function submitCallback(db_name, event)
		if(event.isError)then
			print("Network error!");
		else
			
			local response_obj = json.decode(event.response);
			local bug_id = response_obj.name;
			print("bug reported:", bug_id);
			bug_bg:put(db_name..bug_id.."/timestamp", json.encode({[".sv"]= "timestamp"}), nil, function(event)
				if(event.isError)then
					print("Network error!");
				else
					print('submit3');
				end
			end);
		end
	end
	
	local iHandledTheError = true;
	local game_id = get_name_id(moregamesName);
	local ver_id = get_name_id(optionsVersion);
	ver_id = ver_id:gsub("%.", "_");
	local db_name = "bugs/"..game_id.."/"..ver_id.."/";
			
	local function myUnhandledErrorListener(event)
		if iHandledTheError then
			print("Handling the unhandled error", event.errorMessage);
			iHandledTheError = false;
			
			local scene1, scene2, dead;
			if(director)then
				local current_scene = director:getCurrHandler();
				if(current_scene)then
					scene1 = current_scene.name or current_scene.utype or 'undefined';
					dead = current_scene.dead;
					if(dead~=true)then
						dead = false;
					end
				end
				if(director.getOldSceneName)then
					scene2 = director:getOldSceneName();
				end
			end

			bug_bg:post(db_name, json.encode({text=event.errorMessage, stack=event.stackTrace, 
				version=optionsVersion, build=optionsBuild, scene_dead=dead, scene_cur=scene1, scene_prev=scene2, class=login_obj.class}), nil, function(event)
				submitCallback(db_name, event);
			end);
		else
			print("Not handling the unhandled error", event.errorMessage )
		end
		return true; --iHandledTheError
	end
	if(system.getInfo("environment") ~= "simulator")then
		Runtime:addEventListener("unhandledError", myUnhandledErrorListener);
	end
	if(royal==nil)then
		_G.royal = {};
	end
	function royal:reportBug(txt)
		local scene1, scene2, dead;
		if(director)then
			local current_scene = director:getCurrHandler();
			if(current_scene)then
				scene1 = current_scene.name or current_scene.utype or 'undefined';
				dead = current_scene.dead;
				if(dead~=true)then
					dead = false;
				end
			end
			if(director.getOldSceneName)then
				scene2 = director:getOldSceneName();
			end
		end
			
		bug_bg:post(db_name, json.encode({text=txt, 
			version=optionsVersion, build=optionsBuild, scene_dead=dead, scene_cur=scene1, scene_prev=scene2, class=login_obj.class}), nil, function(event)
			submitCallback(db_name, event);
		end);
	end
	
	if(system.getInfo("environment") == "simulator")then
		local fname = "bugs_version."..optionsBuild;
		local loadSavedVersion = loadFile(fname);
		local upload = true;
		if(loadSavedVersion)then
			local obj = json.decode(loadSavedVersion);
			local ver = obj.ver;
			if(ver>=optionsVersion)then
				upload = false;
			end
		end
		
		if(upload)then
			bug_bg:put("games/"..get_name_id(moregamesName).."/version", json.encode(optionsVersion), nil, function(event)
				
			end);
			bug_bg:put("games/"..get_name_id(moregamesName).."/"..optionsBuild, json.encode(optionsVersion), nil, function(event)
				
			end);
			
			local str = json.encode({ver = optionsVersion});
			saveFile(fname, str);
		end
		
		local function callbackFindDupes(e)
			-- print("_e.response:", e.response);
			local list = json.decode(e.response);
			local stacks = {};
			local texts = {};
			local i,t = 0,0;
			if(list)then
				for bugId,obj in pairs(list) do
					if(obj.stack or obj.text)then
						if((obj.stack and stacks[obj.stack]) or (obj.text and texts[obj.text]))then
							-- print('dup:', db_name..""..bugId);
							bug_bg:delete(db_name..bugId, nil, function(e) end);
						else
							stacks[obj.stack] = true;
							texts[obj.text] = true;
							i = i+1;
						end
					end
					t = t+1;
				end
				print('bugs:'..i.."/"..t);
			end
		end
		
		
		Runtime:addEventListener("key", function(e)
			-- print("print!", e.phase, e.keyName, e.phase=="down" and e.keyName=="p");
			if(e.phase=="down" and e.keyName=="o")then
				bug_bg:get(db_name, nil, callbackFindDupes);
			end
		end);
	end
	
	if(system.getInfo("environment") == "simulator")then
		local i = 1;
		Runtime:addEventListener("key", function(e)
			-- print("print!", e.phase, e.keyName, e.phase=="down" and e.keyName=="p");
			if(e.phase=="down" and e.keyName=="p")then
				display.save(mainGroup.parent, {filename="scr_"..optionsBuild.."_".._W.."x".._H.."_"..i..".png", baseDir=system.DocumentsDirectory});
				i = i+1;
			end
		end);
	end
end