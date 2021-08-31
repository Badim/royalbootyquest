module(..., package.seeall);
print("eliteLang 2.3");-- original at "Royal Heroes", extended at RBQ

-----------------------------
function _G.get_txt(txt)
	return language:get_txt(txt);
end
function _G.get_name_id(txt)
	txt = txt:gsub("`", "");
	txt = txt:gsub("’", "");
	txt = txt:gsub("'", "");
	txt = txt:gsub("#", "");
	txt = txt:gsub(" ", "_");
	txt = txt:gsub("-", "_");
	txt = txt:gsub("%/", "");
	return txt:lower();
end
function _G.get_name(txt)
	local txt=get_txt(get_name_id(txt));
	local arr = string_split(txt, "_");
	txt = table.concat(arr," ");
	return txt;
end
function _G.get_txt_force(txt, en)
	return language:get_txt_force(txt, en);
end
------------------------------

-- local function loadFile(fname)
	-- local path =  system.pathForFile(fname, system.DocumentsDirectory);
	-- local file = io.open( path, "r" );
	-- if (file) then
		-- local contents = file:read( "*a" );
		-- if(contents and #contents>0)then
			-- return contents;
		-- end
	-- end
	-- return nil
-- end
-- local function saveFile(fname, save_str)
	-- local path = system.pathForFile( fname, system.DocumentsDirectory);
	-- local file = io.open(path, "w+b");
	-- if file then
		-- file:write(save_str);          
		-- io.close( file )
		-- print("Saving("..fname.."): ok!")
	-- else
		-- print("Saving("..fname.."): fail!")
	-- end
-- end

function new()
	local localGroup = display.newGroup();
	localGroup.langObj = nil;
	localGroup.current_id = nil;
	
	localGroup.langs_list = {};
	localGroup.langs_obj = {};
	
	local lang_names ={}
	lang_names.en="English";
	lang_names.pt="Portuguese";
	lang_names.br="Brazilian";
	lang_names.fr="French";
	lang_names.de="German";
	lang_names.es="Spanish";
	lang_names.it="Italian";
	lang_names.tr="Turkish";
	lang_names.ru="Russian";
	lang_names.jp="Japanese";
	lang_names.ko="Korean";
	lang_names.da="Danish";
	lang_names["zh_tw"]="Chinese-Traditional"
	lang_names["zh_cn"]="Chinese-Simplified"
	localGroup.lang_names = lang_names;
	
	local steam_names = {};
	steam_names["zh_tw"]="tchinese"
	steam_names["zh_cn"]="schinese"
	
	function localGroup:saveSettings()
		local settings = {};
		settings.current_id = localGroup.current_id;
		saveFile("lang.settings", json.encode(settings));
	end
	function localGroup:loadSettings(def)
		local tdata = loadFile("lang.settings");
		if(tdata)then
			local settings = json.decode(tdata);
			if(settings)then
				localGroup:setLanguage(settings.current_id);
				return
			end
		end
		if(def==nil or localGroup.langs_obj[def]==nil)then
			def = 'en';
		end
		localGroup:setLanguage(def);
		return
	end
	
	function localGroup:setDefLangFiles(fontName, fontNumbers)
		localGroup.fontName = fontName;
		localGroup.fontNumbers = fontNumbers;
	end
	
	function localGroup:add_lang_xml(id, fontName, fontNumbers)
		local lang_obj = {};
		lang_obj.id = id;
		lang_obj.fontName=fontName;
		lang_obj.fontNumbers=fontNumbers;
		table.insert(localGroup.langs_list, lang_obj);
		localGroup.langs_obj[id] = lang_obj;
	end
	
	function localGroup:saveSteamAchievementsLangFile(name_str, hint_add, name_rep, hint1, hint2)
		local file_obj = {};
		table.insert(file_obj, '"lang"');
		table.insert(file_obj, "{");
		for i=1,#localGroup.langs_list do
			local lang_obj = localGroup.langs_list[i];
			local lang_id = lang_obj.id;
			
			local lang_xml = xml:loadFile('data/lang_'..lang_id..'.xml');
			local words_obj = lang_xml.properties;
			local save_obj = {};
			
			-- table.insert(save_obj, '"Language"	"'..lang_names[lang_id]:lower()..'"');
			if(steam_names[lang_id])then
				table.insert(save_obj, '"'..steam_names[lang_id]:lower()..'"');
			else
				table.insert(save_obj, '"'..lang_names[lang_id]:lower()..'"');
			end
			table.insert(save_obj, "{");
			table.insert(save_obj, '"Tokens"');
			table.insert(save_obj, "{");
			
			for j=1,#_itemAchievement._list do
				local ach_obj = _itemAchievement._list[j];

				local attr;
				if(name_str)then
					attr = name_str..j;
				end
				if(name_rep)then
					attr = name_rep:gsub("XX", j);
				end
				if(words_obj[attr])then
					table.insert(save_obj, '"'..ach_obj.steam_id..'_NAME"	"'..words_obj[attr]..'"');
				end
				if(hint_add)then
					if(words_obj[attr..hint_add])then
						table.insert(save_obj, '"'..ach_obj.steam_id..'_DESC"	"'..words_obj[attr..hint_add]..'"');
					else
						print('missing!', attr..hint_add);
					end
				end
				if(hint1 and hint2)then
					local attr1 = hint1:gsub("XX", j);
					local attr2 = hint2:gsub("XX", j);
					if(words_obj[attr2]~="" and words_obj[attr2]~=nil)then
						table.insert(save_obj, '"'..ach_obj.steam_id..'_DESC"	"'..words_obj[attr1].." "..words_obj[attr2]..'"');
					elseif(words_obj[attr1])then
						table.insert(save_obj, '"'..ach_obj.steam_id..'_DESC"	"'..words_obj[attr1]..'"');
					end
				end
				
			end
			
			table.insert(save_obj, "}");
			table.insert(save_obj, "}");
			-- print(#save_obj);
			if(#save_obj>10)then
				table.insert(file_obj, table.concat(save_obj, "\r\n"));
			end
		end
		table.insert(file_obj, "}");
		-- print(table.concat(file_obj, "\r\n"))
		local save_str = table.concat(file_obj, "\r\n");
		saveFile('steam_achievements_all.vdf', save_str);
	end
	
	function localGroup:addEnWord(attr, val)
		localGroup.langObjEn[attr] = val;
	end
	function localGroup:addCurWord(attr, val)
		if(localGroup.langObj[attr] == nil)then
			localGroup.langObj[attr] = val;
		end
	end
	
	function localGroup:getList()
		return localGroup.langs_list;
	end
	
	

	
	local function touchHandler(evt)
			local phase = evt.phase;
			local mouse_xy = {x=evt.x - localGroup.list_mc.x, y=evt.y - localGroup.list_mc.y};
			if(phase=='began' or phase=='moved')then
				local someoneSelected = false;
				for i=1, localGroup.items_mc.numChildren do 
					local item_mc = localGroup.items_mc[i];
					local dd = get_dd(item_mc, mouse_xy);
					if(dd<localGroup._item_rr)then
						someoneSelected = true;
						if(lang_names[item_mc.obj.id])then
							addHint(lang_names[item_mc.obj.id]);
						else
							addHint(item_mc.obj.id);
						end
						if(item_mc._selected == false)then
							item_mc._selected = true;
							transition.to(item_mc._over, {time=180, alpha=0.3});
						end
					else
						if(item_mc._selected == true)then
							removeHint();
							item_mc._selected = false;
							transition.to(item_mc._over, {time=280, alpha=0.0});
						end
					end
				end
			else
				for i=1, localGroup.items_mc.numChildren do 
					local item_mc = localGroup.items_mc[i];
					if(item_mc._selected == true)then
						localGroup:setLanguage(item_mc.obj.id);
						item_mc._selected = false;
						transition.to(item_mc._over, {time=280, alpha=0.0});
						if(localGroup.act)then
							localGroup.act();
						end
					end
				end
			end
	end
	
	localGroup._open = false;
	function localGroup:closeList()
		localGroup._open = false;
		if(localGroup.list_mc)then
			if(localGroup.list_mc.removeSelf)then
				localGroup.list_mc:removeEventListener("touch", touchHandler);
				localGroup.list_mc:removeSelf();
				localGroup.list_mc.removeSelf = nil;
				localGroup.list_mc = nil;
			end
		end
	end
	localGroup._item_rr = 26*26;
	
	function localGroup:getPrevLangId()
		for i=1,#localGroup.langs_list do
			local item_obj = localGroup.langs_list[i];
			if(localGroup.current_id == item_obj.id)then
				if(i>1)then
					return localGroup.langs_list[i-1];
				else
					return localGroup.langs_list[#localGroup.langs_list];
				end
			end
		end
	end
	
	function localGroup:getNextLangId()
		for i=1,#localGroup.langs_list do
			local item_obj = localGroup.langs_list[i];
			if(localGroup.current_id == item_obj.id)then
				if(i<#localGroup.langs_list)then
					return localGroup.langs_list[i+1];
				else
					return localGroup.langs_list[1];
				end
			end
		end
	end
	
	
	
	function localGroup:showList(sx, sy, dx, dy, scale, act)
		localGroup:closeList();
		localGroup._open = true;
		
		localGroup.act = act;
		
		local list_mc = display.newGroup();
		localGroup.list_mc = list_mc;
		
		local bg_w = 100;
		local bg_h = -(dy*(#localGroup.langs_list+0.5)+sy);

		--local myRoundedRect = display.newRoundedRect(list_mc, -bg_w/2, -bg_h-sy/2, bg_w, bg_h, bg_w/2 - 1);
		--myRoundedRect:setFillColor(0,0,0,75);
		
		local items_mc = display.newGroup();
		list_mc:insert(items_mc);
		localGroup.items_mc = items_mc;
		
		for i=1,#localGroup.langs_list do
			local item_obj = localGroup.langs_list[i];
			local item_mc = display.newGroup();
			local item_bg_w, item_bg_h = 80, 50;
			local body_mc = display.newImage(item_mc, "gfx/langs/lang_"..item_obj.id..".png");
			item_mc._selected = false;
			if(body_mc)then
				body_mc.x, body_mc.y = 0,0;
				body_mc.xScale, body_mc.yScale = scale/2, scale/2;
				--item_mc._over = display.newImage(item_mc, "gfx/langs/lang_"..item_obj.id..".png");
				item_mc._over = display.newRect(item_mc, 0, 0, body_mc.width, body_mc.height);
				item_mc._over.blendMode = "add";
				item_mc._over.alpha = 0;
				item_mc._over.x, item_mc._over.y = 0,0;
				item_mc._over.xScale, item_mc._over.yScale = scale/2, scale/2;
			end
			
			item_obj.mc = item_mc;
			item_mc.obj = item_obj;
			items_mc:insert(item_mc);
			item_mc.x, item_mc.y = sx+dx*(i-1), sy+dy*(i-1);
			
			item_mc.w, item_mc.h = item_bg_w*scale, item_bg_h*scale;
			
			--item_mc.alpha = 0;
			--transition.to(item_mc, {time=200, alpha=1});
		end
		
		function list_mc:closeList()
			localGroup:closeList();
		end
		
		list_mc:removeEventListener("touch", touchHandler);
		list_mc:addEventListener("touch", touchHandler);
		return list_mc;
	end
	
	local en_xml = xml:loadFile('data/lang_'..'en'..'.xml');
	localGroup.langObjEn = en_xml.properties;

	function localGroup:setLanguage(id)
		local obj=localGroup.langs_obj[id];
		if(obj==nil)then
			if(id == 'zh')then
				localGroup:setLanguage("zh_cn");
			else
				print(id..' is not supported.');
			end
			return
		end
		
		if(obj.fontName)then
			_G.fontMain = obj.fontName;
		elseif(localGroup.fontName)then
			_G.fontMain = localGroup.fontName;
		end
		if(obj.fontNumbers)then
			_G.fontNumbers = obj.fontNumbers;
		elseif(localGroup.fontNumbers)then
			_G.fontNumbers = localGroup.fontNumbers;
		end
		
		if(_G.hintGroup)then
			if(_G.hintGroup.dark_mc)then
				_G.hintGroup.dark_mc:removeSelf();
				_G.hintGroup.dark_mc = nil;
			end
			if(_G.hintGroup.tfHint)then
				_G.hintGroup.tfHint:removeSelf();
				_G.hintGroup.tfHint = nil;
			end
		end
		
		print('fonts:', _G.fontMain, _G.fontNumbers);
		
		local lang_xml = xml:loadFile('data/lang_'..id..'.xml');
		localGroup.langObj = lang_xml.properties;
		localGroup.current_id = id;
		
		localGroup:saveSettings();
		
		for i=1,5 do
			local fname = "data/lang_"..id..i..".tsv";
			local extra = loadFile(fname, system.ResourceDirectory);--lang_ru1.tsv
			-- print('extra', id, extra);
			if(extra)then
				-- print('fa')
				local arr = {};
				for line in string.gmatch(extra, '[^\r\n]+') do 
					for tab in string.gmatch(line, '[^\t]+') do 
						arr[#arr+1] = tab;
					end
					print('add:', arr[1], arr[2], (arr[1] and arr[2])~=nil);
					if(arr[1] and arr[2])then
						localGroup:addCurWord(arr[1], arr[2]);
					end
					while(#arr>0)do
						arr[#arr] = nil;
					end
					-- local tab1, tab2 = string.gmatch(line, '[^\t]+')
					-- print(tab1, tab2)
				end
				-- The pattern '\t' will match a tab, '\t+' will match one or more. And '[^\t]+' will match non-tab characters.
			end
		end
		
		if(options_debug and id~='en')then
			local untranslated_words ={};
			local tempObj = {};
			
			for key, val in pairs(localGroup.langObjEn) do  -- Table iteration.
				if(localGroup.langObj[key] == nil)then
					if(tempObj[key]~=nil and tempObj[key]~="")then
						table.insert(untranslated_words, key..'	'..tempObj[key]);
					elseif(val ~=  "")then
						table.insert(untranslated_words, key..'	'..val);
					end
				end
			end
			table.sort(untranslated_words);
			local save_str = table.concat(untranslated_words, "\r");
			saveFile('lang_un_'..id..'_en.txt', save_str);
			
			local arr = {};
			if(lang_names[id])then
				table.insert(arr, string.upper("system").."	"..string.upper(lang_names.en).."	"..string.upper(lang_names[id]));
			end
			for key, val in pairs(localGroup.langObjEn) do  -- Table iteration.
				if(localGroup.langObj[key])then
					table.insert(arr, key.."	"..val.."	"..language.langObj[key]);
				end
			end
			table.sort(arr);
			saveFile("lang_full_"..language.current_id..".txt", table.concat(arr, "\r\n"));

			if(id=="jp" or id=="pl")then
				local ru_xml = xml:loadFile('data/lang_'..'ru'..'.xml');
				local langObjRu = ru_xml.properties;
				local untranslated_words ={};
				for key, val in pairs(langObjRu) do  -- Table iteration.
					if(localGroup.langObj[key] == nil and localGroup.langObjEn[key])then
						if(val ~=  "")then
							table.insert(untranslated_words, key..'	'..localGroup.langObjEn[key]..'	'..val);
						end
					end
				end
				table.sort(untranslated_words);
				local save_str = table.concat(untranslated_words, "\r");
				saveFile('lang_un_'..id..'_ru.txt', save_str);
			end
		end
		
		
	end
	
	function localGroup:get_txt_force(txt, en)
		if(localGroup.langObj)then
			if(localGroup.langObj[txt])then
				return localGroup.langObj[txt];
			end
		end
		if(en)then
			if(localGroup.langObjEn[txt])then
				return localGroup.langObjEn[txt];
			end
		end
		return nil
	end
	function localGroup:get_txt(txt)
		if(localGroup.langObj)then
			if(localGroup.langObj[txt] == nil)then
				if(localGroup.langObjEn[txt] == nil)then
					return txt;
				else
					return localGroup.langObjEn[txt]
				end
			else
				return localGroup.langObj[txt];
			end
		else
			return txt;
		end
	end
	
	function localGroup:get_bol(txt)
		return (localGroup.langObj[txt] ~= nil)
	end
	
	return localGroup;
end