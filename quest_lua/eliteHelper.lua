module(..., package.seeall);

if(_G.scaleGraphics==nil)then _G.scaleGraphics=2; end
if(_G.options_txt_offset==nil)then _G.options_txt_offset=0; end
-------------------------------
_G.elite = {};
-------------------------------
function _G.loadFile(fname, directory)
	if directory==nil then directory = system.DocumentsDirectory; end
	local path =  system.pathForFile(fname, directory);
	if(path)then
		local file = io.open( path, "r" );
		if (file) then
			local contents = file:read( "*a" );
			io.close(file);
			if(contents and #contents>0)then
				return contents;
			end
		end
	end
	return nil
end
function _G.saveFile(fname, save_str, directory)
	local path = system.pathForFile(fname, directory or system.DocumentsDirectory);
	local file = io.open(path, "w+b");
	if file then
		--local save_str = Json.Encode(login_obj);
		file:write(save_str);          
		io.close( file )
		print("Saving("..fname.."): ok!")
	else
		print("Saving("..fname.."): fail!")
	end
end
function elite.removeFile(fname, directory)
	local result, reason = os.remove(system.pathForFile(fname, directory or system.DocumentsDirectory));
	print("removeFile", fname, result, reason);
end
-----------------------------
table.length = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
table.count = function(source, val)
	local i=0;
	for j=1,#source do
		if(source[j]==val)then
			i=i+1;
		end
	end
	return i;
end
table.keys = function(source)
  local result = {}
  for k,v in pairs(source) do
    table.insert(result, k);
  end
  return result
end
table.keysEx = function(source, ex)
  local result = {}
  for k,v in pairs(source) do
	if(ex[k]==nil)then
		table.insert(result, k);
	end
  end
  return result
end
function table.shuffle(t)
  local n = #t
  while n > 2 do
    local k = math.random(n);
    t[n], t[k] = t[k], t[n];
    n = n - 1;
  end
  return t
end
table.random = function(source)
  return source[math.random(1, #source)]
end
table.randomByIndex = function(source)
	local t = {};
	for k,v in pairs(source) do
		table.insert(t, v);
	end
	return table.random(t);
end
table.randomByIndexEx = function(source)
	local t = {};
	for k,v in pairs(source) do
		table.insert(t, {k, v});
	end
	if(#t>0)then
		return table.random(t);
	end
end
table.randomByAttr = function(source, attr, val)
	for i=1,500 do
		local item = source[math.random(1, #source)];
		if(item[attr]==val)then
			return item;
		end
	end
	return nil;
end
table.clone = function(t)
	local n={};
	for i=1,#t do
		n[i]=t[i];
	end
	return n;
end
table.cloneByAttr = function(t)
	local n={};
	for i,j in pairs(t) do
		n[i]=j;
	end
	return n;
end
table.cloneEx = function(t,f)
	local n={};
	for i=1,#t do
		n[i]=f(t[i]);
	end
	return n;
end
table.purge = function(tab)
	for k in next,tab do tab[k] = nil end
end
table.superrandomswap = function(t, tag, p)
	local attrs = {};
	local objs = {};
	for attr, obj in pairs(t) do
		for i=1,#p do
			if(obj[tag] == p[i])then
				table.insert(attrs, attr);
				table.insert(objs, obj);
			end
		end
	end
	
	while(#attrs>0) do
		local attr = table.remove(attrs, math.random(1,#attrs));
		local obj = table.remove(objs, 1);
		t[attr] = obj;
	end
end
table.add = function(t, multy, exclude)
	print('<add>')
	for attr,val in pairs(t)do
		if(exclude~=attr)then
			if(type(val)=="number")then
				t[attr] = val+multy;
				print(attr, val, t[attr]);
			elseif(type(val)=="table")then
				table.add(val, multy, exclude);
			end
		end
	end
	print('</add>')
end
table.resortEx = function(t, attr, force)
	local n = {};
	for id,tobj in pairs(t) do
		tobj.id = id;
		if(tobj[attr]~=nil)then
			table.insert(n, tobj);
		end
	end
	table.sort(n, function(a, b)
		return a[attr] < b[attr];
	end);
	if(force)then
		for id,tobj in pairs(t) do
			if(tobj[attr]==nil)then
				table.insert(n, tobj);
			end
		end
	end
	return n;
end
	
_G.getTimer = system.getTimer;
_G.getSeconds = function()
	return os.time();
end

function _G.newGroup(parent)
	local mc = display.newGroup();
	parent:insert(mc);
	return mc
end
function _G.cleanGroup(mc)
	if(mc.numChildren)then
		while(mc.numChildren>0)do
			mc[1]:removeSelf();
		end
	end
end

	
function _G.numberToBoolean(val)
	return val~=0;
end
function _G.booleanToSwitch(bol)
	if(bol)then
		return 'on';
	else
		return 'off';
	end
end
function _G.booleanToNumber(bol)
	if(bol)then
		return 1;
	else
		return 0;
	end
end
	
	function _G.getDD(p1,p2)
		local dx=p2.x-p1.x;
		local dy=p2.y-p1.y;
		return dx*dx+dy*dy, dx, dy;
	end

	function _G.getRD(p1,p2)
		local dx=p2.x-p1.x;
		local dy=p2.y-p1.y;
		return math.max(math.abs(dx),math.abs(dy));
	end
	
	function _G.sign(x)
	  return (x<0 and -1) or 1
	end
	function _G.dAngleRadian(a1, a2)
		local da = a1-a2;
		if (da>math.pi) then
			da = -math.pi*2+da;
		elseif(da<-math.pi)then
			da = math.pi*2+da;
		end
		return da;
	end
	function _G.get_dd(p1, p2)
		local dx=p2.x-p1.x;
		local dy=p2.y-p1.y;
		return dx*dx+dy*dy;
	end
	function _G.get_dd_ex(x1,y1,x2,y2)
		local dx=x2-x1;
		local dy=y2-y1;
		return dx*dx+dy*dy;
	end
	function _G.distance(p1, p2)
		local dx=p2.x-p1.x;
		local dy=p2.y-p1.y;
		local dd=dx*dx+dy*dy;
		return math.sqrt(dd), dx, dy
	end
	function _G.distanceEx(x1,y1,x2,y2)
		local dx=x2-x1;
		local dy=y2-y1;
		local dd=dx*dx+dy*dy;
		return math.sqrt(dd), dx, dy
	end
	function _G.hit_test(mc, rr, tx, ty)
		if(mc.x and mc.y)then
			local dx, dy = mc.x - tx, mc.y - ty;
			local dd = dx*dx+dy*dy;
			if(dd<rr)then
				return true
			end
		end
		return false
	end
	function _G.hit_test_rec(mc,w,h,tx,ty)
		if(mc.x and mc.y)then
			if(tx>mc.x-w/2 and tx<mc.x+w/2)then
				if(ty>mc.y-h/2 and ty<mc.y+h/2)then
					return true
				end
			end
		end
		return false
	end
	function _G.hit_test_rec_ex(mcx, mcy, w, h, tx, ty)
		--if(mcx and mcy)then
			if(tx>mcx-w/2 and tx<mcx+w/2)then
				if(ty>mcy-h/2 and ty<mcy+h/2)then
					return true
				end
			end
		--end
		return false
	end
	
	function _G.pixelArtOn()
		display.setDefault("magTextureFilter", "nearest");
		display.setDefault("minTextureFilter", "nearest");
	end
	function _G.pixelArtOff()
		display.setDefault("magTextureFilter", "linear");
		display.setDefault("minTextureFilter", "linear");
	end
	
	_G.easings = {	easing.inSine, easing.outSine, easing.inOutSine, easing.outInSine, easing.inQuad, easing.outQuad, easing.inOutQuad, easing.outInQuad,
					easing.inCubic, easing.outCubic, easing.inOutCubic, easing.outInCubic, easing.inQuart, easing.outQuart, easing.inOutQuart, easing.outInQuart,
					easing.inBack, easing.outBack, easing.inOutBack, easing.outInBack,
					
	};
	
	function _G.anirotation(obj, rot_speed)
		if(rot_speed)then obj.rot_speed = rot_speed; end
		transition.to(obj, {time=1000, rotation=obj.rotation+obj.rot_speed, onComplete=anirotation});
	end

	function _G.transitionBlink(img, intensity)
		if(intensity==nil)then intensity=0.5; end
		img.fill.effect = "filter.brightness";
		transition.to(img.fill.effect, {time=100, intensity=intensity, transition=easing.inQuad, onComplete=function(obj)
			if(img.fill)then
				img.fill.effect = nil;
			end
		end});
	end
	function _G.transitionBlinkEx(img)
		-- body.fill.effect = "filter.custom.eliteMulti";
		-- body.fill.effect.brightness.intensity = 0.5;
		if(img.fill.effect==nil)then img.fill.effect = "filter.custom.eliteMulti"; end
		transition.to(img.fill.effect.brightness, {time=100, intensity=0.5, transition=easing.inQuad, onComplete=function(obj)
			if(img.fill)then
				img.fill.effect.brightness.intensity = 0;
			end
		end});
	end
	function _G.transitionBeat(obj, delay, again, maxS)
		if(obj.xScale==nil)then return; end
		maxS = maxS or 0.1;
		obj.scaleB = obj.xScale;
		transition.to(obj, {delay=delay, time=500, xScale=obj.xScale+maxS, yScale=obj.yScale+maxS, transition=easing.outQuad, onComplete=function(obj)
			if(obj.xScale==nil)then return; end
			transition.to(obj, {time=450, xScale=obj.scaleB, yScale=obj.scaleB, transition=easing.outQuad, onComplete=function(obj)
				if(again)then
					transitionBeat(obj, delay, again);
				end
			end});
		end});
	end
	
	function _G.fitTextFildByW(dtxt, w, ds)
		if(ds)then dtxt.size=ds; end
		while(dtxt.contentWidth>w and dtxt.size>5)do 
			dtxt.size = dtxt.size-1; 
		end
	end
	function _G.fitTextFildByH(dtxt, h, ds)
		if(ds)then dtxt.size=ds; end
		while(dtxt.contentHeight>h and dtxt.size>5)do 
			dtxt.size = dtxt.size-1; 
		end
	end
	
	function _G.fitTextFildByWH(dtxt, w, h, ds)
		if(ds)then dtxt.size=ds; end
		while((dtxt.contentWidth>w or dtxt.contentHeight>h) and dtxt.size>5)do 
			dtxt.size = dtxt.size-1; 
		end
	end

	function _G.string_split(str, pat)
		--table.concat(untranslated_words, "\r")
	   local t = {};  -- NOTE: use {n = 0} in Lua-5.0
	   local fpat = "(.-)" .. pat;
	   local last_end = 1
	   local s, e, cap = str:find(fpat, 1)
	   while s do
		  if s ~= 1 or cap ~= "" then
		 table.insert(t,cap)
		  end
		  last_end = e+1
		  s, e, cap = str:find(fpat, last_end)
	   end
	   if last_end <= #str then
		  cap = str:sub(last_end)
		  table.insert(t, cap)
	   end
	   return t
	end

	function _G.transitionRemoveSelfHandler(obj)
		if(obj)then
			if(obj.removeSelf)then
				obj:removeSelf();
			end
		end
	end

	function _G.add_bar(fname, tw, ys)
		--print("__tw:", tw);
		local mc =  display.newGroup();
		-- local ys = scaleGraphics/2;
		if(ys==nil)then ys = scaleGraphics/2; end
		if(tw<0.01)then
			mc.w = 2;
			mc.h = 2;
			return mc;
		end
		local b_l=display.newImage(mc, "image/"..fname.."_l.png");
		local b_r=display.newImage(mc, "image/"..fname.."_r.png");
		--print("___tw:", tw, b_l.width);
		if(tw<b_l.width)then
			b_r.width=tw/2;
			b_l.width=tw/2;
		end
		local tw_new = tw;
		if(tw>0)then
			tw_new = tw - b_r.width - b_l.width;
			local b_m=display.newImage(mc, "image/"..fname.."_m.png");
			b_m.width = tw_new;
			--b_m.x, b_m.y = 0,0;
			-- b_m.xScale = ys;
			b_m.yScale = ys;
		end
		
		-- b_l.xScale = ys;
		-- b_r.xScale = ys;
		
		b_r.x, b_r.y = tw_new/2+b_r.contentWidth/2,0;
		b_l.x, b_l.y = -tw_new/2-b_l.contentWidth/2,0;
		
		function mc:setFillColor(c1,c2,c3)
			for i=1,mc.numChildren do
				local item = mc[i];
				item:setFillColor(c1,c2,c3);
			end
		end
		
		b_l.yScale = ys;
		b_r.yScale = ys;
		
		mc.w = tw;
		mc.h = b_l.height*ys;
		return mc;
	end

	function _G.add_title(txt, sscale)
		if(sscale==nil)then sscale = 4; end
		local mc = display.newGroup();
		local b_c=display.newImage(mc, "image/gui/bar_title_m.png");
		b_c.xScale, b_c.yScale = scaleGraphics*sscale/2, scaleGraphics/2;
		b_c.x,b_c.y = 0,0;

		local dtxt=display.newText(mc, txt, 0, 0, fontMain, math.floor(11*scaleGraphics));
		dtxt.x,dtxt.y = 0, 0*scaleGraphics;
		mc.dtxt = dtxt;
		if(dtxt.width>b_c.contentWidth)then
			b_c.xScale = 1;
			b_c.width = dtxt.width+2;
		end
		
		local b_l=display.newImage(mc, "image/gui/bar_title_l.png");
		b_l.xScale, b_l.yScale = scaleGraphics/2, scaleGraphics/2;
		b_l.x,b_l.y = -(b_c.width*b_c.xScale + b_l.width*b_l.xScale)/2,0;
		local b_r=display.newImage(mc, "image/gui/bar_title_l.png");
		b_r.xScale, b_r.yScale = -scaleGraphics/2, scaleGraphics/2;
		b_r.x,b_r.y = (b_c.width*b_c.xScale - b_r.width*b_r.xScale)/2,0;
		
		function mc:setText(txt)
			dtxt.text = txt;
			
			-- b_c.contentHeight
		end
		return mc
	end

	function _G.add_bg(utype, tw, th, fill)
		tw = math.floor(tw);
		th = math.floor(th);
		local mc =  display.newGroup();
		mc.w, mc.h = tw,th;
		mc.x = tw/2;
		mc.y = th/2;

		local top = display.newImage("image/gui/"..utype.."_m.png");
		mc.bw = top.height;
		mc.bh = top.height;
		
		tw = tw - top.height*2;
		th = th - top.height*2;
		top:removeSelf();

		local parts = math.floor(tw/32);
		parts = math.max(1, parts);

		local topmc = display.newGroup();
		mc:insert(topmc);
		if(tw>0)then
			for i=1,parts do
				local top = display.newImage(topmc, "image/gui/"..utype.."_m.png");
				top.x, top.y = (i-0.5-parts/2)*(tw)/(parts), -th/2-top.height/2;
				top.xScale, top.yScale = tw/(top.width*parts),1;
				-- mc:insert(top);
			end
			for i=1,parts do
				local bot = display.newImage("image/gui/"..utype.."_m.png");
				bot.x, bot.y = (i-0.5-parts/2)*(tw)/(parts), th/2+bot.height/2;
				bot.xScale, bot.yScale = tw/(bot.width*parts),-1;
				mc:insert(bot);
			end
		end
		
		local parts = math.floor(th/32);
		parts = math.max(1, parts);
		if(th>0)then
			for i=1,parts do
				local left = display.newImage("image/gui/"..utype.."_m.png");
				left.x, left.y = -tw/2-left.height/2, (i-0.5-parts/2)*(th)/(parts);
				left.xScale, left.yScale =  th/(left.width*parts), 1;
				left.rotation = -90;
				mc:insert(left);
			end
			for i=1,parts do
				local right = display.newImage("image/gui/"..utype.."_m.png");
				right.x, right.y = tw/2+right.height/2, (i-0.5-parts/2)*(th)/(parts);
				right.xScale, right.yScale =  th/(right.width*parts), 1;
				right.rotation = 90;
				mc:insert(right);
			end
		end
		
		local tl = display.newImage("image/gui/"..utype.."_c.png");
		tl.x = -(tw/2+tl.width/2);
		tl.y = -(th/2+tl.height/2);
		mc:insert(tl);
		local tr = display.newImage("image/gui/"..utype.."_c.png");
		tr.xScale = -1;
		tr.x = (tw/2+tr.width/2);
		tr.y = -(th/2+tr.height/2);
		mc:insert(tr);
		
		local bl = display.newImage("image/gui/"..utype.."_c.png");
		bl.yScale = -1;
		bl.x = -(tw/2+bl.width/2);
		bl.y = (th/2+bl.height/2);
		mc:insert(bl);
		local br = display.newImage("image/gui/"..utype.."_c.png");
		br.xScale = -1;
		br.yScale = -1;
		br.x = (tw/2+br.width/2);
		br.y = (th/2+br.height/2);
		mc:insert(br);
		
		function mc:removeTop()
			tl:removeSelf();
			tr:removeSelf();
			topmc:removeSelf();
		end
			
		if(fill)then
			local bg_fill = display.newRect(mc, 0, 0, tw-mc.bw*0, th-mc.bh*0);
			bg_fill:setFillColor(0, 0, 0);
			bg_fill.x,bg_fill.y = 0,0;
		end
			
		return mc;
	end
	function _G.add_bg_title(utype, tw, th, txt, sscale)
		local mc = add_bg(utype, tw, th)

		local bg_fill = display.newRect(mc, 0, 0, tw-mc.bw, th-mc.bh);
		bg_fill:setFillColor(0, 0, 0);
		bg_fill.x,bg_fill.y = 0,0;

		if(txt~=nil and txt~='')then
			local title = add_title(txt, sscale);
			title.x, title.y = 0, -mc.h/2-1.5*scaleGraphics + options_txt_offset;
			mc.dtxt = title.dtxt;
			mc:insert(title);
			
			function mc:setText(txt)
				title:setText(txt);
			end
		end
		return mc;
	end
	function _G.add_price_bar(tw)
		local bar_mc = display.newGroup();
		local bar1 = add_bar("bar_money1", tw);
		bar1.alpha = 0.5;
		local bar2 = add_bar("bar_money2", tw);
		bar_mc:insert(bar1);
		bar_mc:insert(bar2);
		return bar_mc;
	end
	
	elite.removeMe = function (mc)
		if(mc)then
			if(mc.removeSelf)then
				mc:removeSelf();
			end
		end
	end

	elite.arrangeGroup = function(p, tw)
		for i=1,p.numChildren do
			local btn = p[i];
			btn.x = (i - p.numChildren/2 - 0.5)*tw
		end
	end
	elite.newPixelart = function(par, path, x, y)
		display.setDefault("magTextureFilter", "nearest");
		display.setDefault("minTextureFilter", "nearest");
		local ico = display.newImage(par, path, x, y);
		if(scaleGraphics)then
			if(ico)then
				ico:scale(scaleGraphics/2, scaleGraphics/2);
			end
		end
		display.setDefault("magTextureFilter", "linear");
		display.setDefault("minTextureFilter", "linear");
		return ico;
	end
	elite.getPrettyNumber = function(num)
		if(num>1000000000)then
			return math.floor(num/1000000000).."g";
		elseif(num>1000000)then
			return math.floor(num/1000000).."m";
		elseif(num>1000)then
			return math.floor(num/1000).."k";
		-- elseif(num>1000000000000)then
			
		end
		return num;
	end
	elite.setScrollable = function(mc)
		local function mouseHandler(e)
			if(mc.parent==nil)then
				Runtime:removeEventListener("mouse", mouseHandler);
				return
			end
			if(e.scrollY)then
				if(e.scrollY~=0)then
					mc:translate(0, -e.scrollY*scaleGraphics/2);
				end
			end
		end
		Runtime:addEventListener("mouse", mouseHandler);
	end
	elite.setDisabled = function(btn, val)
		local function setChildrenGrey(mc, bol)
			if(mc.numChildren)then
				for ii=1,mc.numChildren do
					local child = mc[ii];
					if(child.fill)then
						if(bol)then
							child.fill.effect = "filter.grayscale";
						else
							child.fill.effect = nil;
						end
					end
					if(child.numChildren)then
						setChildrenGrey(child, bol)
					end
				end
			end
		end
		
		if(val)then
			setChildrenGrey(btn, true);
			if(btn.dtxt)then btn.dtxt.alpha = 0.4;end
		else
			setChildrenGrey(btn, false);
			if(btn.dtxt)then btn.dtxt.alpha = 1.0;end
		end
		
		btn.disabled = val;
	end
	elite.add_notification = function(tar, tx, ty, val)
		local myCircle = display.newImage(tar, "gfx/notification.png");
		myCircle.xScale, myCircle.yScale = scaleGraphics/2,scaleGraphics/2;
		myCircle.x,myCircle.y = tx, ty;
		local dtxt = display.newText(tar, val, 0, 0, fontNumbers, math.floor(10*scaleGraphics));
		dtxt.anchorX, dtxt.anchorY = 0.5,0.5;
		dtxt.x,dtxt.y = myCircle.x, myCircle.y+txt_number_offset;
		return myCircle, dtxt;
	end
	elite.addSmallSwitcher = function(tar_mc, fname1, fname2, tx, ty, bol)
		local btn = newGroup(tar_mc);
		btn.xScale, btn.yScale = scaleGraphics/2, scaleGraphics/2;
		btn.x, btn.y = tx, ty
		local body;
		function btn:refresh()
			if(body)then
				body:removeSelf();
			end
			if(bol())then
				body=display.newImage(btn, fname1..".png");
			else
				body=display.newImage(btn, fname2..".png");
			end
		end
		btn:refresh();
		return btn;
	end

	elite.addCheckboxOption = function(par, txt, hint, width, tx, ty, fname1, fname2, buttons, bol, act)
		local itemmc = newGroup(par);
		itemmc.x, itemmc.y = tx, ty;
		local btn = elite.addSmallSwitcher(itemmc, fname1, fname2, width/2 - 12*scaleGraphics, 0, bol);
		local dtxt = display.newText(itemmc, txt, -width/2 + 6*scaleGraphics, 0, fontMain, 12*scaleGraphics);
		_G.fitTextFildByW(dtxt, width-24*scaleGraphics);
		dtxt.anchorX = 0;
		
		table.insert(buttons, itemmc);
		itemmc.w, itemmc.h = width, 20*scaleGraphics;
		elite.addOverOutBrightness(itemmc, btn);
		
		itemmc.hint = hint;
		itemmc.act = function()
			act();
			btn:refresh();
		end
	end
	elite.addOverOutBrightness = function(mc, body)
		if(body==nil)then body = mc; end
		function mc:onOver()
			if(body.fill)then
				body.fill.effect = "filter.brightness";
				body.fill.effect.intensity = 0.1;
			elseif(body.numChildren)then
				for i=1,body.numChildren do
					if(body[i].fill)then
						-- if(body[i].shader~=true)then
							body[i].fill.effect = "filter.brightness";
							body[i].fill.effect.intensity = 0.1;
						-- end
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

	function elite.addAniByMasks(mc, path, onComplete)
		local i = 1;
		
		local mask = graphics.newMask(path..i..".png");
		mc:setMask(mask);
		
		local st = getTimer();
		function mc.turn(e)
			if(mc.removeSelf==nil or mc.completed)then
				Runtime:removeEventListener("enterFrame", mc.turn);
				return
			end
			
			local dtime = getTimer() - st;
			if(dtime>100 - i*5)then
				st = getTimer();
				i = i+1;
				-- mask:removeSelf();
				
				-- local test = display.newImage(path..i..".png");
				if(i>=11)then
					if(onComplete)then
						onComplete(mc);
					end
					mc.completed = true;
					return
				end
				-- test:removeSelf();
				
				mask = graphics.newMask(path..i..".png");
				mc:setMask(mask);
			end
		end
		Runtime:addEventListener("enterFrame", mc.turn);
	end
	
	function elite.newNativeText(wnd, tx, ty, w, h, callback, stay)
		local txt = native.newTextField(tx, ty, w, h);
		local function textListener(event)
			if ( event.phase == "began" ) then
				
			elseif ( event.phase == "ended" or event.phase == "submitted" ) then
				-- print( event.target.text )
				callback(event.target.text);
				if(stay~=true)then
					txt:removeMe();
				end
			elseif ( event.phase == "editing" ) then
				-- print( event.newCharacters )
				-- print( event.oldText )
				-- print( event.startPosition )
				-- print( event.text )
				if(txt.maxsymbols)then
					local temp = event.text;          
					if(string.len(temp)>txt.maxsymbols)then
						temp=string.sub(temp, 1, txt.maxsymbols);
						event.text = temp;
						txt.text = temp;
					end
				end
				if(txt.nospaces)then
					local temp = event.text; 
					temp = temp:gsub(" ", "");
					event.text=temp;
					txt.text = temp;
				end
				if(txt.baned)then
					for i=1,#txt.baned do
						local val = txt.baned[i];
						local temp = event.text; 
						temp = temp:gsub(val, "");
						event.text=temp;
						txt.text = temp;
					end
				end
			end
		end

		local function handler(e)
			if(txt==nil or wnd.removeSelf==nil)then
				-- Runtime:removeEventListener("enterFrame", handler);
				txt:removeMe();
				return
			end
			txt.x, txt.y = wnd.x + tx, wnd.y + ty;
		end
		handler();
		
		function txt:removeMe()
			txt:removeEventListener("userInput", textListener);
			Runtime:removeEventListener("enterFrame", handler);
			txt:removeSelf();
			-- wnd.nativetxt = nil;
		end
		txt:addEventListener("userInput", textListener);
		Runtime:addEventListener("enterFrame", handler);
		return txt;
	end
	
	function elite:add_chains(tar, utype, tx, ty, chains_l)
		for iy=0,chains_l-1 do
			for ix=0,1 do
				local chain = display.newImage(tar, "image/"..utype..".png");
				chain.xScale, chain.yScale = scaleGraphics/2, scaleGraphics/2;
				chain.x, chain.y = tx, ty + (0.5 + iy)*chain.height*chain.yScale;
			end
		end
	end
	function elite:add_chains_h(tar, utype, tx, ty, th, index)
		local iy=0;
		local group = display.newGroup();
		if(index)then
			tar:insert(index, group);
		else
			tar:insert(group);
		end
		while(th>0)do
			local chain = display.newImage(group, "image/"..utype..".png");
			chain.xScale, chain.yScale = scaleGraphics/2, scaleGraphics/2;
			chain.x, chain.y = tx, ty + (0.5 + iy)*chain.height*chain.yScale;
			th = th - chain.yScale*chain.height;
			iy = iy + 1;
		end
		return group;
	end
	function elite:add_chains_pair(tar, utype, tx, ty, tw, th, index)
		local group = newGroup(tar);
		elite:add_chains_h(group, utype, tx-tw/2, ty, th, index);
		elite:add_chains_h(group, utype, tx+tw/2, ty, th, index);
		if(index)then
			group:toBack();
		end
		return group;
	end
	
	function _G.newOutlinedText(group, txt, tx, ty, font, size, color_in, color_out, d)
		local mc = display.newGroup();
		mc.text = txt;
		mc.x, mc.y = tx, ty;
		group:insert(mc);
		
		if(d==nil)then d=2; end
		for i=1,d do
			local txt1 = display.newText(mc, txt, i, 0, font, size);
			local txt2 = display.newText(mc, txt, -i, 0, font, size);
			local txt3 = display.newText(mc, txt, 0, i, font, size);
			local txt4 = display.newText(mc, txt, 0, -i, font, size);
			
			local txt1 = display.newText(mc, txt, i, i, font, size);
			local txt1 = display.newText(mc, txt, -i, -i, font, size);
			local txt1 = display.newText(mc, txt, i, -i, font, size);
			local txt1 = display.newText(mc, txt, -i, i, font, size);
		end
		local txt5 = display.newText(mc, txt, 0, 0, font, size);
		
		for i=1,mc.numChildren do
			mc[i]:setTextColor(color_out);
		end
			
		txt5:setTextColor(color_in);
		function mc:setAttr(attr, val)
			for i=1,mc.numChildren do
				mc[i][attr] = val;
			end
		end
		function mc:setText(txt)
			if(mc.numChildren)then
				for i=1,mc.numChildren do
					mc[i].text = txt;
				end
			end
			mc.text = txt;
		end
		function mc:setFillColor(c1, c2, c3)
			for i=1,mc.numChildren do
				mc[i]:setTextColor(c1, c2, c3);
			end
		end
		function mc:setTextColor(c1, c2, c3)
			if(txt5.setTextColor)then txt5:setTextColor(c1, c2, c3); end
		end
		function mc:getSize()
			return txt5.size;
		end
		function mc:setSize(val)
			for i=1,mc.numChildren do
				mc[i].size = val;
			end
		end
		function mc:getWidth()
			return txt5.width;
		end
		
		return mc
	end
	
function elite.add_glow_simple(tar, path, outline, color)
	local group=newGroup(tar);
	local outline = 1;
	for ix=-outline,outline do
		for iy=-outline,outline do
			local item_mc = display.newImage(group, path);
			if(not(ix==0 and iy==0))then
				if(item_mc)then
					item_mc.fill.effect = "filter.brightness";
					item_mc.fill.effect.intensity = 0.6;
					item_mc:setFillColor(color[1], color[2], color[3], color[4]);
					item_mc.x,item_mc.y = ix,iy;
				end
			end
		end
	end
	return group;
end

particleDesigner = require("particleDesigner");
function elite.add_emitter(tar_mc, p_arr) -- r g b x y speed angle
	tar_mc.emitter_dead = false;
	local emitter;
	if(tar_mc.emitter)then
		emitter = tar_mc.emitter;
	else
		emitter = particleDesigner.newEmitter("big_orange_flame.json");
	end
	emitter.particleLifespan = 0.55;
	emitter.particleLifespanVariance = 0.05;
	emitter.startParticleSize = 50;
	emitter.startParticleSizeVariance = 6;
	
	emitter.x,emitter.y = 0, 0;
	if(p_arr[4] and p_arr[5])then
		emitter.x,emitter.y = p_arr[4]/1, p_arr[5]/1;
	end
	
	emitter.sourcePositionVariancex=100;
	emitter.sourcePositionVariancey=10;
	emitter.angle = 360;
	emitter.angleVariance = 360;
	if(p_arr[7])then
		emitter.angle = p_arr[7]/1;
		emitter.angleVariance = 0;
	end
	
	emitter.speed = 30;
	if(p_arr[6])then
		emitter.speed = p_arr[6]/1
	end
	emitter.speedVariance = emitter.speed/5;
	emitter.gravityy = -150;

	emitter.startColorRed=0.1+0.9*p_arr[1];
	emitter.finishColorRed=0.1+0.6*p_arr[1];
	emitter.startColorVarianceRed=0;
	emitter.finishColorVarianceRed=0.1+0.3*p_arr[1];

	emitter.startColorGreen=0.1+0.9*p_arr[2];
	emitter.finishColorGreen=0.1+0.6*p_arr[2];
	emitter.startColorVarianceGreen=0;
	emitter.finishColorVarianceGreen=0.1+0.3*p_arr[2];

	emitter.startColorBlue=0.1+0.9*p_arr[3];
	emitter.finishColorBlue=0.1+0.6*p_arr[3];
	emitter.startColorVarianceBlue=0;
	emitter.finishColorVarianceBlue=0.1+0.3*p_arr[3];
				
	tar_mc:insert(emitter);
	tar_mc.emitter = emitter;
	return emitter
end

function elite.add_bar(tar, fname, tw, ys, c1, c2, c3)
	local mc =  newGroup(tar);
	if(ys==nil)then ys = scale/2; end
	if(tw<0.01)then
		mc.w = 2;
		mc.h = 2;
		function mc:setFillColor(c1,c2,c3) end
		function mc:refresh(p) end
		return mc;
	end
	local b_l=display.newImage(mc, "image/"..fname.."_l.png");
	local b_r=display.newImage(mc, "image/"..fname.."_r.png");
	--print("___tw:", tw, b_l.width);
	if(tw<b_l.width)then
		b_r.width=tw/2;
		b_l.width=tw/2;
	end
	local tw_new = tw;
	if(tw>0)then
		tw_new = tw - b_r.width - b_l.width;
		local b_m=display.newImage(mc, "image/"..fname.."_m.png");
		b_m.width = tw_new;
		--b_m.x, b_m.y = 0,0;
		-- b_m.xScale = ys;
		b_m.yScale = ys;
	end
	
	-- b_l.xScale = ys;
	-- b_r.xScale = ys;
	
	b_r.x, b_r.y = tw_new/2+b_r.contentWidth/2,0;
	b_l.x, b_l.y = -tw_new/2-b_l.contentWidth/2,0;
	
	
	b_l.yScale = ys;
	b_r.yScale = ys;
	
	local fill=display.newRect(mc, 0, 0, tw-6, b_r.contentHeight-2);
	fill:toBack();
	fill:setFillColor(c1, c2, c3);

	function mc:setFillColor(c1,c2,c3)
		-- for i=1,mc.numChildren do
			-- local item = mc[i];
			-- item:setFillColor(c1,c2,c3);
		-- end
		fill:setFillColor(c1,c2,c3);
	end
	
	function mc:refresh(p)
		if(fill.contentWidth==nil)then return; end
		if(p)then mc.p=p; end
		fill.xScale=math.max(mc.p, 0.0001);
		local dx=tw-fill.contentWidth;
		fill.x=-dx/2+3;
	end
	mc:refresh(1/2);
	
	mc.w = tw;
	mc.h = b_l.height*ys;
	return mc;
end
elite.get_time_txt = function(seconds, simple)
	local d=math.floor(seconds/60/60/24);
	seconds = seconds - d*60*60*24;
	local h=math.floor(seconds/60/60);
	seconds = seconds - h*60*60;
	local m=math.floor(seconds/60);
	s = seconds - m*60;
	
	local arr = {};
	local b = '';
	if(d>0)then table.insert(arr,string.format("%02d",d)..b..get_txt('days_sc')); if(simple)then return table.concat(arr,", "); end end
	if(h>0)then table.insert(arr,string.format("%02d",h)..b..get_txt('hours_sc')); if(simple)then return table.concat(arr,", "); end end
	if(m>0)then table.insert(arr,string.format("%02d",m)..b..get_txt('minutes_sc')); if(simple)then return table.concat(arr,", "); end end
	if(s>0 or #arr==0)then table.insert(arr,string.format("%02d",s)..b..get_txt('seconds_sc')); if(simple)then return table.concat(arr,", "); end end
	return table.concat(arr,", ");
end

elite.cashedItemsPerEvents = {};
elite.cashedConsPerEvents = {};

function elite.addVal(obj, attr, val)
	if(obj[attr])then
		obj[attr] = obj[attr]+val;
	else
		obj[attr] = val;
	end
end