module(..., package.seeall);

function new(url, link)
	local localGroup = display.newGroup();
	local file_name;
	local imgGame;
	for token1 in string.gmatch(url, "[^/]+") do
		file_name = token1;
	end
	
	local bg_mc = display.newRect(localGroup, 0, 0, 728, 90);
	bg_mc.x, bg_mc.y = 0, 0;
	bg_mc.alpha = 0.5;
	bg_mc:setFillColor(140, 140, 140);
	
	local icoLoading = display.newImage("moreEliteGames/image/icoLoading.png", 0, 0 );
	icoLoading.x = bg_mc.x;
	icoLoading.y = bg_mc.y;
	localGroup:insert(icoLoading);
	
	local function animaLoading()
		transition.to( icoLoading, { time=500, rotation=180} );
		transition.to( icoLoading, { time=499, rotation=359, delay=500} );
		transition.to( icoLoading, { time=1, rotation=0, delay=999, onComplete=animaLoading} );
	end
	animaLoading();
	
	function imageReady()
		if(localGroup._dead)then
			return false;
		end
		if(imgGame)then
			imgGame.x, imgGame.y = 0,0;
			transition.from(imgGame, { alpha=0});
			localGroup:insert(imgGame);
		end
	end
	function networkListener(event)
		print("_localGroup._dead:", localGroup._dead)
		print("_url:", url, file_name);
		if(localGroup._dead)then
			return false;
		end
		print("__event.response:",event.response)
		print("___event.isError:", event.isError)
		print("____event.status:", event.status)
        if (event.isError) then
			--imgGame = display.newImage("moreEliteGames/image/elite_100x100.png", 0, 0);
        else
			imgGame = display.newImage(file_name, system.DocumentsDirectory, 0, 0);
        end
		imageReady();
	end
	
	
	local path = system.pathForFile(file_name, system.DocumentsDirectory);
	local fhd = io.open(path);
	
	if(fhd)then
		imgGame = display.newImage(localGroup, file_name, system.DocumentsDirectory , 0, 0);
		imageReady();
	else
		network.download(url, "GET", networkListener, file_name, system.DocumentsDirectory);
	end
	
	function select(event)
		if(event.phase == "ended")then
			system.openURL(link);
		end
	end
	localGroup:addEventListener("touch", select);
	
	return localGroup;
end