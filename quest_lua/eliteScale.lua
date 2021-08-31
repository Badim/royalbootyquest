module(..., package.seeall);
-- elite Score hosted at Royal Heroes

local function loadScaleFile(fname)
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
local function saveScaleFile(fname, save_str)
	local path = system.pathForFile( fname, system.DocumentsDirectory);
	local file = io.open(path, "w");
	if file then
		file:write(save_str);          
		io.close(file);
		print("Saving("..fname.."): ok!")
	else
		print("Saving("..fname.."): fail!")
	end
end
local function getWindowMode()
	local val = native.getProperty("windowMode");
	if(val)then
		return val;
	else
		return 'default'
	end
end

function loadScales()
	local tdata = loadScaleFile("scale"..optionsBuild..".settings");
	if(tdata)then
		local decoded_data;
		local function try()
			decoded_data = json.decode(tdata);
		end
		if pcall(try) then
		else
			decoded_data = {};
		end
		return decoded_data;
	else
		return {};
	end
	return {};
end
function saveScales()
	local settings = loadScales();
	if(settings==nil)then settings={}; end
	settings[getWindowMode()] = _G.scaleGraphics;
	settings['gui_time'] = _G.CONST_BUILDING_FADEIN_TIME;
	settings['volume'] = audio.getVolume();
	settings['cursor'] = _G.options_cursor;
	settings['tutorials'] = _G.options_tutorials;
	if(_G.playerName)then settings['playerName'] = _G.playerName; end
	if(_G.playerPIN)then settings['playerPIN'] = _G.playerPIN; end
	local tdata = json.encode(settings);
	saveScaleFile("scale"..optionsBuild..".settings", tdata);
end

function default()
	_G.scaleDevice = 1;
	_G.scaleGraphics = 1;

	local min_wh = math.min(_G._W, _G._H);
	print("_min_wh:", min_wh);
	if(min_wh>=450)then
		_G.scaleGraphics = 1.5;
	end
	if(min_wh>=480)then
		_G.scaleGraphics = 1.6;
	end
	if(min_wh>=600)then
		_G.scaleGraphics = 2;
	end
	if(min_wh>=800)then
		_G.scaleGraphics = 2.5;
	end
	if(min_wh>=1000)then
		_G.scaleGraphics = 3;
	end
	if(min_wh>=1100)then
		_G.scaleGraphics = 3.5;
	end
	if(min_wh>=1500)then
		_G.scaleGraphics = 4;
	end
	
	if(min_wh>=1600)then
		_G.scaleGraphics = math.floor((_W/550)*2)/2;
	end
	
	if(_G._W..'x'.._G._H=='1280x1024')then
		_G.scaleGraphics = 2.5;
	end
	
	if(_G._W..'x'.._G._H=='1280x800' and options_desctop)then
		_G.scaleGraphics = 2;
	end
	
	local dpi = system.getInfo("androidDisplayApproximateDpi");
	if(_G._W..'x'.._G._H=='2048x1536')then--ipad retina
		_G.scaleGraphics = 4;
	end

	_G.scaleGraphics = _G.scaleGraphics*_G.scaleDevice;

	print('_device_original:',_G._W,_G._H);
	if(optionsBuild == "amazon")then
		if(_G._H == 1200)then
			_G._H = _G._H - 40;
		elseif(_G._H == 800)then
			_G._H = _G._H - 30;
		else
			_G._H = _G._H - 20;
		end
	end
	
	if(options_desctop)then
		_G.scaleGraphics = 2;
	end
	
	while(340*_G.scaleGraphics>_H)do
		_G.scaleGraphics = _G.scaleGraphics-0.1;
		print('DECRREASING DEFAULT SCALE!', _G.scaleGraphics)
	end
	
	print('_device_fixed:',_G._W,_G._H)
	print('_scales:',_G.scaleGraphics,_G.scaleDevice)
	print("_model:"..system.getInfo("platformName")..','..system.getInfo("model")..','..optionsBuild);
end

function init()
	_G._W = display.contentWidth;
	_G._H = display.contentHeight;
	_G.CONST_BUILDING_FADEIN_TIME = 1200;
	
	if(hintGroup)then
		if(hintGroup.tfHint)then
			hintGroup.tfHint:removeSelf();
			hintGroup.tfHint = nil;
		end
		if(hintGroup.dark_mc)then
			hintGroup.dark_mc:removeSelf();
			hintGroup.dark_mc = nil;
		end
	end
	
	local settings = loadScales();
	if(settings)then
		if(settings['volume'])then
			audio.setVolume(settings['volume']);
		end
		if(settings['tutorials']~=nil)then _G.options_tutorials = settings['tutorials']; end
		if(settings['playerName'])then
			_G.playerName = tostring(settings['playerName']);
		end
		if(settings['playerPIN'])then
			_G.playerPIN = tostring(settings['playerPIN']);
		end
		if(settings['gui_time'])then
			_G.CONST_BUILDING_FADEIN_TIME = tonumber(settings['gui_time']);
		end
		if(settings['cursor'])then
			_G.options_cursor = settings['cursor'];
		end
		if(settings[getWindowMode()])then
			_G.scaleGraphics = settings[getWindowMode()];
			return
		end
	end

	default();
end

function game()
	local zoom_val = 1;
	local function zoom(val)
		zoom_val = val;
	end
	
	if(_G._W..'x'.._G._H=='1280x1024')then
		zoom(1.50);
	elseif(_H==540)then
		zoom(0.80);
	elseif(_H==480)then
		zoom(0.75);
	elseif(_H>1500)then
		zoom(2.25);
	elseif(_H>1070)then
		zoom(1.5);
	elseif(_H>670)then
		zoom(1.10);
	elseif(_H<480)then
		if(_H>400)then
			zoom(0.75);
		else
			zoom(0.5);
		end
	else
		zoom(1.0);
	end
	
	local dpi = system.getInfo("androidDisplayApproximateDpi");
	--dpi = 640;--test value
	if(dpi)then
		--show_msg('dpi: '..tostring(dpi).."x"..tostring(scaleGraphics));--scaleGraphics
		if(dpi>=640)then
			zoom(1.75);
		elseif(dpi>=480)then
			zoom(1.5);
		end
		--240 vs 2
		--ldpi	120
		--mdpi	160
		--hdpi	240
		--xhdpi	320
		--xxhdpi	480
		--xxxhdpi	640
		--tvdpi	213
	end

	if(options_console)then
		local min_wh = math.min(_W, _H);
		if(min_wh == 720)then
			zoom(1);
		end
		if(min_wh == 1080)then
			zoom(1.5);
		end
	end
	
	return zoom_val;
end