module(..., package.seeall);

function new(prms)	
	local localGroup = display.newGroup();
	localGroup.name = "mini";
	localGroup.dead = false;
	
	-- tavern.jpg
	local background = display.newImage(localGroup, "image/background/tavern.jpg");
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
	localGroup.animations = 0;
	
	addTopBar(facemc, localGroup.buttons);
	function facemc:addBtn(txt, tx, ty, act)
		local btn = add_bar("black_bar3", 52*scaleGraphics);
		local dtxt = display.newText(btn, get_txt(txt), 0, 0, fontMain, 15*scaleGraphics);
		-- dtxt:setFillColor(237/255, 198/255, 80/255);
		facemc:insert(btn);
		btn.x, btn.y = tx, ty;
		btn.act = function()
			btn.act = nil;
			act();
		end;
		table.insert(localGroup.buttons, btn);
		elite.addOverOutBrightness(btn);
		function btn:disabled()
			return facemc.wnd~=nil;
		end
		return btn;
	end
	
	local gomc = facemc:addBtn('>>>', _W-30*scaleGraphics, _H/2, show_map);
	
	local list = table.clone(cards);
	table.shuffle(list);
	table.shuffle(list);
	table.shuffle(list);
	
	if(prms.gtype=="wheel")then
		local options = {};
		table.insert(options, {txt="money", money=100*login_obj.map.lvl});
		table.insert(options, {txt="relic", relic=1});
		table.insert(options, {txt="heal", heal=1});
		
		table.insert(options, {txt="removecard", removecard=1});
		table.insert(options, {txt="dmg", dmg=10});
		
		for i=1,#list do
			local card = list[i];
			if(card.ctype==CTYPE_CURSE)then
				table.insert(options, {txt="curse", card=card.tag});
				break;
			end
		end
		
		table.shuffle(options);
		
		local radius = 120*scaleGraphics;
		
		local wheelmc = newGroup(gamemc);
		wheelmc.x, wheelmc.y = _W/2, _H/2+20*scaleGraphics;
		local wheelbase = display.newCircle(wheelmc, 0, 0, radius);
		wheelbase.strokeWidth = 4*scaleGraphics;
		wheelbase:setFillColor(0.3, 0.4, 0.5);
		wheelbase:setStrokeColor(1, 0.8, 0);
		
		local ad = math.pi*2/#options;
		
		local mcs = {};
		
		for i=1,#options do
			local item = options[i];
			local angle = i*ad;
			local tx, ty = radius*math.cos(angle), radius*math.sin(angle);
			local separator = display.newLine(wheelmc, 0, 0, tx, ty);
			separator.strokeWidth = 3*scaleGraphics;
			separator:setStrokeColor(1, 0.8, 0, 0.5);
			
			local angle = i*ad + ad/2;
			local tx, ty = radius*math.cos(angle), radius*math.sin(angle);
			local stxt = newOutlinedText(wheelmc, item.txt, tx/2, ty/2, fontMain, 12*scaleGraphics, 1, 0, 1);
			stxt.item = item;
			stxt:setTextColor(1, 0.8, 0);
			stxt.rotation = 180*angle/math.pi;
			table.insert(mcs, stxt);
		end
		
		wheelmc.rotation = 180*ad/math.pi/2;
		
		local wheelbase = display.newCircle(wheelmc, 0, 0, 10*scaleGraphics);
		wheelbase.strokeWidth = 4*scaleGraphics;
		wheelbase:setFillColor(0.3, 0.4, 0.5);
		wheelbase:setStrokeColor(1, 0.8, 0);
		
		local side = 20*scaleGraphics;
		local vertices = { -side/2, 0, side, -side, side, side }
		local pointer = display.newPolygon(facemc, wheelmc.x + radius + side/2, wheelmc.y, vertices );
		
		pointer.strokeWidth = 6*scaleGraphics;
		pointer:setFillColor(0.3, 0.4, 0.5);
		pointer:setStrokeColor(1, 0.8, 0);
		
		wheelmc.r = radius;
		table.insert(localGroup.buttons, wheelmc);
		
		local stxt = newOutlinedText(facemc, "000", _W/2, _H-10*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
		
		function wheelmc:act()
			if(wheelmc.aa)then
				if(wheelmc.av>5)then
					wheelmc.aa = 0;
				end
			else
				wheelmc.av = 0.1;
				wheelmc.aa = 0.3;
				wheelmc.ad = 0.98;
			end
		end
		
		gomc.isVisible = false;
		local function turnHandler(e)
			if(localGroup.dead)then
				Runtime:removeEventListener(turnHandler);
				return
			end
			
			if(wheelmc.av)then
				wheelmc.rotation = wheelmc.rotation + wheelmc.av;
				wheelmc.av = wheelmc.av + wheelmc.aa;
				wheelmc.av = wheelmc.av * wheelmc.ad;
				
				stxt:setText(math.floor(wheelmc.av*10));
				
				local min_dd = 999999;
				local tar = nil;
				for i=1,#mcs do
					mcs[i]:setTextColor(1, 0.8, 0);
					local tx, ty = mcs[i]:localToContent(0, 0);
					local dd = get_dd_ex(pointer.x, pointer.y, tx, ty);
					if(dd<min_dd)then
						tar = mcs[i];
						min_dd = dd;
					end
				end
				
				if(tar)then
					tar:setTextColor(1, 0.8, 1);
				end
				
				if(wheelmc.av<0.1)then
					Runtime:removeEventListener(turnHandler);
					
					wheelmc.av = 0;
					gomc.isVisible = true;
					stxt:setText("");
					
					local tx, ty = tar:localToContent(0, 0);
					function gomc:act()
						handle_action(tar.item, tx, ty, facemc);
						gomc.act = nil;
					end
					
					local arr = {"["..get_txt(tar.item.txt).."]"};
					handleOneAction(tar.item, arr);
					local text = table.remove(arr, 1);
					if(#arr>0)then
						text = text.." "..table.concat(arr, ", ")..".";
					end
					addHint(text);
					
				end
			end
		end
		Runtime:addEventListener("enterFrame", turnHandler);
		
	elseif(prms.gtype=="match" or true)then
		local options = {};

		for r=0,3 do
			for i=1,#list do
				local card = list[i];
				if(card.rarity==r and card.class==login_obj.class)then
					table.insert(options, card);
					table.insert(options, card);
					break;
				end
			end
		end
		
		for i=1,#list do
			local card = list[i];
			if(card.ctype==CTYPE_CURSE)then
				table.insert(options, card);
				table.insert(options, card);
				break;
			end
		end
		
		for i=1,#list do
			local card = list[i];
			if(card.class=="none" and card.rarity==2)then
				table.insert(options, card);
				table.insert(options, card);
				break;
			end
		end
		
		for i=1,#options do
			options[i] = table.cloneByAttr(options[i]);
		end
		
		table.shuffle(options);
		table.shuffle(options);
		table.shuffle(options);
		
		local topBarH = 110*scaleGraphics/2;
		local remainingH = _H - topBarH - 20*scaleGraphics;
		local thMax = math.floor(remainingH/3);
		
		local irow = 4;
		local sx, sy = _W/2, _H/2+76*scaleGraphics;
		local imax = #options;
		local card_scale = 2;
		local tw, th = 58*scaleGraphics*card_scale, 82*scaleGraphics*card_scale;
		
		local actions = 6;
		local stxt = newOutlinedText(facemc, actions, _W/2, _H-10*scaleGraphics, fontMain, 12*scaleGraphics, 1, 0, 1);
		
		while(th>thMax)do
			card_scale = card_scale-0.1;
			tw, th = 58*scaleGraphics*card_scale, 82*scaleGraphics*card_scale;
		end
		
		local cardsmc = newGroup(gamemc);
		for i=1,#options do
			local card_obj = options[i];
			
			local hide = display.newImage(gamemc, "image/card_hide.png");
			
			local cardmc, body, ntxt = createCardMC(cardsmc, card_obj); -- mc.card_obj = card_obj;
			cardmc.x, cardmc.y = sx - ((irow-(i-1)%irow)-irow/2-0.5)*tw, sy + (math.floor((i-1)/irow) - math.ceil(imax/irow)/2)*th;
			cardmc:scale(card_scale, card_scale);
			cardmc.isVisible = false
			cardmc.hide = hide;
			
			hide:translate(cardmc.x, cardmc.y);
			hide:scale(cardmc.xScale/2, cardmc.yScale/2);
			
			function hide:disabled()
				return localGroup.animations>0;
			end
			
			table.insert(localGroup.buttons, hide);
			hide.w, hide.h = tw, th;
			function hide:act()
				if(cardmc.isVisible)then
					return
				end
				if(actions<1)then
					return
				end
				actions = actions-1;
				stxt:setText(actions);
				cardsmc:insert(cardmc);
				cardmc.isVisible = true;
				cardmc.alpha = 0;
				
				localGroup.animations = localGroup.animations+1;
				transition.to(cardmc, {time=600, alpha=1, transition=easing.outQuad, onComplete=function(e)--xScale=scaleGraphics*1, yScale=scaleGraphics*1, 
					localGroup.animations = localGroup.animations-1;
					for j=cardsmc.numChildren,1,-1 do
						local mc = cardsmc[j];
						if(mc~=cardmc and mc~=nil)then
							if(mc.isVisible and mc.alpha>0.9)then
								if(mc.card_obj.tag == card_obj.tag)then
									cardmc.hide:removeSelf();
									mc.hide:removeSelf();
									
									-- cardmc:removeSelf();
									-- mc:removeSelf();
									facemc:insert(cardmc);
									facemc:insert(mc);
									
									localGroup.animations = localGroup.animations+1;
									local tx, ty = (cardmc.x + mc.x)/2, (cardmc.y + mc.y)/2-40*scaleGraphics;
									transition.to(cardmc, {time=500, x=tx, y=ty, transition=easing.outQuad, onComplete=function(obj)
										localGroup.animations = localGroup.animations-1;
										transition.to(cardmc, {delay=300, time=500, x=facemc.book.x, y=facemc.book.y, xScale=1/3, yScale=1/3, transition=easing.inQuad, onComplete=transitionRemoveSelfHandler});
										-- transition.to(cardmc, {time=500, x=tx, y=ty, transition=easing.inQuad, onComplete=function(obj)
										
										-- end})
									end});
									transition.to(mc, {time=500, x=tx, y=ty, transition=easing.outQuad, onComplete=transitionRemoveSelfHandler});
									
									-- card_obj
									-- table.insert(login_obj.deck, card_obj);
									addCardObj(card_obj);
									facemc:bookRefresh();
								else
									localGroup.animations = localGroup.animations+1;
									transition.to(mc, {delay=900, time=400, alpha=0, transition=easing.outQuad, onComplete=function(obj)
										localGroup.animations = localGroup.animations-1;
										obj.isVisible = false;
									end});
									transition.to(cardmc, {delay=900, time=400, alpha=0, transition=easing.outQuad, onComplete=function(obj)
										obj.isVisible = false;
									end});
								end
							end
						end
					end
				end});
			end
			function hide:onOver()
				hide.fill.effect = "filter.brightness";
				hide.fill.effect.intensity=0.1;
			end
			function hide:onOut()
				hide.fill.effect = nil;
			end
		end
		gamemc:insert(cardsmc);
	elseif(prms.gtype=="bandit" or true)then
		
	end
	
	require("src.injectScrGUI").inject(localGroup, localGroup.buttons);
	
	return localGroup;
end