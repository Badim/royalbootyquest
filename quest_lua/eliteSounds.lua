module(..., package.seeall);
print("eliteSounds	1.82"); -- home Royal Heroes

local function loadSoundFile(fname)
	local path =  system.pathForFile(fname, system.DocumentsDirectory);
	local file = io.open( path, "r" );
	if (file) then
		local contents = file:read( "*a" );
		io.close(file);
		if(contents and #contents>0)then
			return contents;
		end
	end
	return nil
end
local function saveSoundFile(fname, save_str)
	local path = system.pathForFile( fname, system.DocumentsDirectory);
	local file = io.open(path, "w");
	if file then
		file:write(save_str);          
		io.close(file);
		print("Saving("..fname.."): ok!");
	else
		print("Saving("..fname.."): fail!");
	end
end

function new()
	local _mc = display.newGroup();
	local _sounds_on = true;
	local _musics_on = true;
	local _voice_on = false;
	local _last_music = nil;
	local _backgroundMusic = nil;
	
	local _voiceHandler = nil;
	local _voiceLastId = nil;
	
	local _sounds = {};
	local _packs = {};
	
	local _loading_sounds = {};
	local loadCallback = nil;
	
	function _mc:getMusicVal()
		return _last_music, _backgroundMusic;
	end
	
	function _mc:saveSettings()
		local settings = {};
		settings._sounds_on=_sounds_on;
		settings._musics_on=_musics_on;
		settings._voice_on=_voice_on;
		settings._volume = audio.getVolume();
		
		local tdata;
		if(Json)then
			tdata = Json.Encode(settings);
		else
			tdata = json.encode(settings);
		end
		
		saveSoundFile("sound.settings", tdata);
	end
	function _mc:loadSettings()
		local tdata = loadSoundFile("sound.settings");
		if(tdata)then
			local settings
			if(Json)then
				settings = Json.Decode(tdata);
			else
				settings = json.decode(tdata);
			end
			if(settings)then
				_sounds_on=settings._sounds_on;
				_musics_on=settings._musics_on;
				_voice_on=settings._voice_on;
				if(settings._volume)then
					audio.setVolume(settings._volume)
				end
			end
		end
	end
	
	function turn(evt)
		if(#_loading_sounds == 0)then
			Runtime:removeEventListener("enterFrame", turn);
			if(loadCallback)then
				loadCallback();
			end
		end
	end
	function _mc:getSoundBol()
		return _sounds_on;
	end
	function _mc:getMusicBol()
		return _musics_on;
	end
	function _mc:getVoiceBol()
		return _voice_on;
	end
	function _mc:setSoundBolTemp(val)
		_sounds_on = val;
	end
	function _mc:setMusicBolTemp(val)
		_musics_on = val;
		if(_musics_on)then
			_mc:music_continue();
		else
			_mc:music_stop();
		end
	end
	function _mc:setVoiceBol(val)
		_voice_on = val;
		_mc:saveSettings();
	end
	function _mc:setSoundBol(val)
		_sounds_on = val;
		_mc:saveSettings();
	end
	function _mc:setMusicBol(val)
		_musics_on = val;
		if(_musics_on)then
			_mc:music_continue();
		else
			_mc:music_stop();
		end
		_mc:saveSettings();
	end
	
	function _mc:switchVoice()
		local val = (_voice_on == false);
		_mc:setVoiceBol(val);
		_mc:voice_stop();
		return _voice_on;
	end
	function _mc:switchSound()
		local val = (_sounds_on == false);
		_mc:setSoundBol(val)
		return _sounds_on;
	end
	function _mc:switchMusic()
		local val = (_musics_on == false);
		_mc:setMusicBol(val);
		return _musics_on;
	end
	
	function _mc:setLoadCallback(val)
		loadCallback = val;
		Runtime:addEventListener("enterFrame", turn);
	end
	
	function _mc:add_sound(val, asStream, packid, ext)
		--print("_add_sound:",val,asStream)
		if(ext == nil)then ext = 'mp3'; end
		if(asStream)then
			_sounds[val] = audio.loadStream("sounds/"..val.."."..ext);
		else
			_sounds[val] = audio.loadSound("sounds/"..val.."."..ext);
			--table.insert(_loading_sounds, val);
		end
		if(packid)then
			_mc:add_pack(packid, val)
		end
		
		return _sounds[val];
	end
	
	function _mc:music_play_once(val)
	end

	function _mc:voice_stop()
		if(_voiceHandler)then
			audio.stop(_voiceHandler);
			_voiceHandler = nil;
		end
	end
	function _mc:voice_play(val, ext)
		if(val==nil)then return end
		if(ext==nil)then ext='mp3'; end
		if(_voice_on==false)then return end
		if(_sounds[val]==nil)then _sounds[val] = audio.loadStream("vfx/"..val.."."..ext); end
		
		-- if(_voiceLastId~=val and _voiceLastId~=nil and _sounds[val]~=nil)then
			-- audio.dispose(_sounds[val]);
			-- _sounds[val] = nil;
		-- end
		_mc:voice_stop();
		if(_sounds_on)then
			_voiceLastId = val;
			_voiceHandler = audio.play(_sounds[val]);
		end
		
		return _sounds[val];
	end
	
	local _ambientMusic = nil;
	function _mc:ambient_stop()
		if(_ambientMusic)then
			audio.stop(_ambientMusic);
			_ambientMusic = nil;
		end
	end
	function _mc:ambient_play(val)
		if(_ambientMusic)then
			_mc:ambient_stop();
		end
		if(_musics_on)then
			if(_sounds[val])then
				-- print('PLAY!', val, _sounds[val])
				_ambientMusic = audio.play( _sounds[val], { loops=-1 });
			end
		end
	end
	
	function _mc:music_stop()
		--print("__music_stop:backgroundMusic:",_backgroundMusic)
		if(_backgroundMusic)then
			audio.stop(_backgroundMusic);
			_backgroundMusic = nil;
		end
	end
	function _mc:music_play(val)
		if(_backgroundMusic)then
			if(val == _last_music)then
				print('ERROR#:this_music_already_playing!')
				return
			end
		end
		_last_music = val;
		if(_musics_on)then
			_mc:music_stop();
			if(_sounds[val])then
				_backgroundMusic = audio.play( _sounds[val], { loops=-1 });
			end
		end
	end
	function _mc:music_continue()
		if(_last_music)then
			local val = _last_music;
			if(_musics_on)then
				if(_sounds[val])then
					_backgroundMusic = audio.play( _sounds[val], { loops=-1 });
					print("__music_continue:backgroundMusic:",_backgroundMusic)
				end
			end
		end
	end
	
	function _mc:sound_check(val)
		return _packs[val] or _sounds[val];
	end
	
	function _mc:sound_play(val)
		print("sound_play:", _sounds_on, val);
		if(_sounds_on)then
			if(_packs[val])then
				local packid = val;
				local sid = math.floor(#_packs[packid]*math.random()*0.999)+1;
				val = _packs[packid][sid];	
			end
			--print("_sound_play:", val);
			if(_sounds[val])then
				audio.play(_sounds[val]);
			end
		end
	end
	function _mc:add_pack(packid, val)
		if(_packs[packid] == nil)then
			_packs[packid] = {};
		end
		table.insert(_packs[packid], val);
	end
	
	_mc:loadSettings();
	--[[
	if(optionsBuild == "samsung")then
		local function onKeyEvent(evt)
			local phase = evt.phase
			local keyName = evt.keyName
			
			if(phase == "down")then
			 if(keyName == "volumeUp") then
				  local masterVolume = audio.getVolume()
				  if ( masterVolume < 1.0 ) then
					 masterVolume = masterVolume + 0.1
					 audio.setVolume( masterVolume )
				  end
				  show_msg('volume '..tostring(math.floor(masterVolume*10)))
				  return true
			   elseif(keyName == "volumeDown") then
				  local masterVolume = audio.getVolume()
				  if ( masterVolume > 0.0 ) then
					 masterVolume = masterVolume - 0.1
					 audio.setVolume( masterVolume )
				  end
				  show_msg('volume '..tostring(math.floor(masterVolume*10)))
				  return true
			   end
			end
			return false
		end
		
		Runtime:addEventListener("key", onKeyEvent);
	end
	]]--
	
	function _G.music_continue()
		_mc:music_continue();
	end
	function _G.music_stop()
		_mc:music_stop();
	end
	function _G.music_play(val)
		_mc:music_play(val);
	end
	function _G.sound_play(val)
		_mc:sound_play(val);
	end
	return _mc;
end