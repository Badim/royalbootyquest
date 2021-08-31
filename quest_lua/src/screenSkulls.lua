module(..., package.seeall);

function new(scene_prms)	
	local winsByClass = scene_prms.winsByClass;
	-- local callback = scene_prms.callback;
	
	local localGroup = display.newGroup();
	localGroup.name = "skulls";
	
	local background = display.newImage(localGroup, "image/background/wizardguild.jpg");
	background.alpha = 0.40;
	local this_scale = math.max(_W/background.width, _H/background.height);
	background.xScale = this_scale;
	background.yScale = this_scale;
	background.x=_W/2;
	background.y=_H/2;
	
	local gamemc = newGroup(localGroup);
	local facemc = newGroup(localGroup);
	
	localGroup.buttons = {};
	facemc.buttons = localGroup.buttons;
	
	gamemc.dead = false;
	
	if(winsByClass==nil)then
		winsByClass = 0;
		for i=1,#heroes do
			local hero_obj = heroes[i];
			local win = getLoginStat("wins"..hero_obj.class);
			if(win>0)then
				winsByClass = winsByClass+1;
			end
		end
	end

	save_obj.winsByClass = winsByClass;

	local skulls = newGroup(facemc);
	skulls.x, skulls.y = _W/2, _H/2;
	skulls.w = 60*scaleGraphics;
	-- local bar = addBar(skulls.w);
	-- skulls.x, skulls.y = bar.x, bar.y;
	
	local list = {"Skull Blue", "Skull Red", "Skull Green"};
	local parts = {	{red=25/255, green=161/255, blue=224/255}, -- Blue
					{red=224/255, green=88/255, blue=25/255}, -- Red
					{red=62/255, green=224/255, blue=25/255}};-- Green
	
	for i=1,3 do
		local skull = newGroup(skulls);
		local body = display.newImage(skull, "image/map/skull"..i..".png");
		body:scale(scaleGraphics/2, scaleGraphics/2);
		local rid = list[i];
		if(save_obj.act4)then
			local a, r1, r2 = i*math.pi*2/3 - math.pi/2, 40*scaleGraphics, 24*scaleGraphics;
			skull.x, skull.y = r1*math.cos(a), r1*math.sin(a);
			skull.tx, skull.ty = r2*math.cos(a), r2*math.sin(a);
			skull.rotation = a*180/math.pi + 90;
			if(login_obj.relics[rid])then
				local prt = parts[i];
				local emitterParams = {
					startColorAlpha = 1,
					maxParticles = 256,
					
					startParticleSizeVariance = 4.00,
					startParticleSize = 4.00,
					finishParticleSize = 4.00,
					finishParticleSizeVariance = 4.00,
					
					maxRadiusVariance = 72.63,
					
					startColorRed = 0.8373094,
					startColorGreen = 0.3031555,
					startColorBlue = 0.3031555,
					
					finishColorRed = 1,
					finishColorGreen = 1,
					finishColorBlue = 1,
					
					yCoordFlipped = -1,
					blendFuncSource = 770,
					rotatePerSecondVariance = 153.95,
					particleLifespan = 0.7237,
					
					blendFuncDestination = 1,
					textureFileName = "pixel.png",
					startColorVarianceAlpha = 1,
					
					duration = -1,
					gravityx = 150,
					gravityy = -50,
					speedVariance = 30,
					tangentialAcceleration = -180,
					tangentialAccelVariance = 180,
					angleVariance = 0,
					angle = 0,
				};
				
				emitterParams.startColorRed = prt.red;
				emitterParams.startColorGreen = prt.green;
				emitterParams.startColorBlue = prt.blue;
				emitterParams.finishColorRed = prt.red*2;
				emitterParams.finishColorGreen = prt.green*2;
				emitterParams.finishColorBlue = prt.blue*2;

				local emitter = display.newEmitter(emitterParams);
				emitter.x = 4*scaleGraphics;
				emitter.y = 1*scaleGraphics;
				skull:insert(emitter);
				
				local emitterParams = {
					startColorAlpha = 1,
					maxParticles = 256,
					
					startParticleSizeVariance = 4.00,
					startParticleSize = 4.00,
					finishParticleSize = 4.00,
					finishParticleSizeVariance = 4.00,
					
					maxRadiusVariance = 72.63,
					
					startColorRed = 0.8373094,
					startColorGreen = 0.3031555,
					startColorBlue = 0.3031555,
					
					finishColorRed = 1,
					finishColorGreen = 1,
					finishColorBlue = 1,
					
					yCoordFlipped = -1,
					blendFuncSource = 770,
					rotatePerSecondVariance = 153.95,
					particleLifespan = 0.7237,
					
					blendFuncDestination = 1,
					textureFileName = "pixel.png",
					startColorVarianceAlpha = 1,
					
					duration = -1,
					gravityx = -150,
					gravityy = -50,
					speedVariance = 30,
					tangentialAcceleration = 180,
					tangentialAccelVariance = 180,
					angleVariance = 0,
					angle = 0,
				};
				
				emitterParams.startColorRed = prt.red;
				emitterParams.startColorGreen = prt.green;
				emitterParams.startColorBlue = prt.blue;
				emitterParams.finishColorRed = prt.red*2;
				emitterParams.finishColorGreen = prt.green*2;
				emitterParams.finishColorBlue = prt.blue*2;

				local emitter = display.newEmitter(emitterParams);
				emitter.x =-4*scaleGraphics;
				emitter.y = 1*scaleGraphics;
				skull:insert(emitter);
			end
		else
			skull.x, skull.y = (i - 3/2 - 0.5)*18*scaleGraphics, 0;
			if(save_obj.winsByClass<i)then
				body.fill.effect = "filter.grayscale";
			end
		end
	end
	
	if(save_obj.winsByClass>2)then
		if(save_obj.act4~=true)then
			show_msg(get_txt('act4_is_unlocked'));
		end
		save_obj.act4 = true;
	end
	saveGame();
	
	if(save_obj.act4~=true)then
		show_msg(get_txt('act4_is_locked'));
	end
	
	
	local stage = 1;
	local rotation = 4;
	local function turnHandler(e)
		if(stage==1)then
			for i=1,skulls.numChildren do
				local skull = skulls[i];
				if(skull.tx==nil)then
					Runtime:removeEventListener("enterFrame", turnHandler);
					return
				end
				local dx, dy = skull.tx-skull.x, skull.ty-skull.y;
				local d = math.sqrt(dx*dx+dy*dy);
				skull:translate(dx/16, dy/16);
				if(d<2)then
					skull.x = skull.tx;
					skull.y = skull.ty;
					stage = 2;
				end
			end
		end
		if(stage==2)then
			transition.to(skulls, {time=5000, rotation=180, transition=easing.inOutQuad, onComplete=function(obj)
				
			end});
			stage = stage+1;
		end
	end
		
	if(save_obj.act4)then
		local skulls_found = 0;
		local list = {"Skull Blue", "Skull Red", "Skull Green"};
		for i=1,#list do
			local rid = list[i];
			if(login_obj.relics[rid])then
				skulls_found = skulls_found+1;
			end
		end
		-- print("_skulls_found:", skulls_found, getRunStat("skulls_help"));
		
		if(skulls_found<3 and getRunStat("skulls_help")<1)then
			local counter = 0;
			local cheat = display.newCircle(facemc, 0, 0, 30*background.xScale);
			cheat:translate(background.x + 342*background.xScale, background.y - 222*background.yScale);
			cheat:setFillColor(1, 0, 0, 0.01);
			cheat:addEventListener('touch', function(e)
				counter = counter+1;
				-- print("_counter:", counter);
				if(counter>20)then
					local list = {"Skull Blue", "Skull Red", "Skull Green"};
					for i=1,#list do
						local rid = list[i];
						login_obj.relics[rid] = true;
					end
					addRunStat("skulls_help", 1);
					show_map();
				end
				return true
			end);
		end
	end

	background:addEventListener('touch', function(e)
		if(e.phase=="began")then
			if(background.done)then
				if(scene_prms.callback)then
					scene_prms.callback();
				elseif(login_obj.dead)then
					show_end();
				else
					show_map();
				end
			else
			
			
				if(scene_prms.callback)then
					-- scene_prms.callback();
				elseif(login_obj.dead)then
					-- show_end();
				else
					show_map();
					return
				end
			
				background.done = true;
				local dtxt = display.newText(facemc, get_txt('continue'), _W/2, _H - 20*scaleGraphics, fontMain, 12*scaleGraphics);
				if(save_obj.act4)then
					Runtime:removeEventListener("enterFrame", turnHandler);
					Runtime:addEventListener("enterFrame", turnHandler);
				end
			end
		end
	end);
	
	function localGroup:removeAll()
		Runtime:removeEventListener("enterFrame", turnHandler);
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end