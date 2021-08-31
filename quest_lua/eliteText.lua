module(..., package.seeall);

function new()
	local localGroup = display.newGroup();
	
	local function get_line_pure_w(line_obj)
		local line_pure_w=0;
		for j=1,#line_obj do
			local item_mc = line_obj[j];
			local word_width=item_mc.w;
			line_pure_w=line_pure_w+word_width;
		end
		return line_pure_w;
	end
	
	local function string_split_ext3(t, str, pat)
		local next_word = "";
		local next_stop = str:find(pat, 1, true);
		if(next_stop==nil)then
			table.insert(t,str)
			return t;
		end
		next_word=str:sub(1, next_stop-1);
		table.insert(t,next_word);

		local nstr=str:sub(next_stop + #pat, #str);
		string_split_ext3(t, nstr, pat)
	end
	local function string_split_ext2(str, pat)
		local t = {};
		string_split_ext3(t, str, pat)
		return t
	end
	
	local function string_split_ext(str, pat, plain)
		if(plain==nil)then
			plain = false;
		end
		local t = {};
		   local fpat = "(.-)" .. pat;
		   local last_end = 1
		   local s, e, cap = str:find(fpat, 1, plain)
		   while s do
			  if s ~= 1 or cap ~= "" then
			 table.insert(t,cap)
			  end
			  last_end = e+1
			  s, e, cap = str:find(fpat, last_end, plain)
		   end
		   if last_end <= #str then
			  cap = str:sub(last_end)
			  table.insert(t, cap)
		   end
		return t
	end
	
	function localGroup:newOutlinedText(group, txt, tx, ty, font, size, color_in, color_out, d)
		local mc = display.newGroup();
		mc.x, mc.y = tx, ty;
		group:insert(mc);

		if(d==nil)then d=2; end
		for i=1,d do
			local txt1 = display.newText(mc, txt, d, 0, font, size);
			local txt2 = display.newText(mc, txt, -d, 0, font, size);
			local txt3 = display.newText(mc, txt, 0, d, font, size);
			local txt4 = display.newText(mc, txt, 0, -d, font, size);
		end
		
		for i=1,mc.numChildren do
			mc[i]:setTextColor(color_out);
		end
		
		local txt5 = display.newText(mc, txt, 0, 0, font, size);
		txt5:setTextColor(color_in);
		function mc:setText(txt)
			for i=1,mc.numChildren do
				mc[i].text = txt;
			end
		end
		function mc:setTextColor(c1,c2,c3)
			txt5:setTextColor(c1,c2,c3);
		end
		function mc:getSize()
			return txt1.size;
		end
		function mc:setSize(val)
			-- txt1.size = val;
			-- txt2.size = val;
			-- txt3.size = val;
			-- txt4.size = val;
			-- txt5.size = val;
			for i=1,mc.numChildren do
				mc[i].size = txt;
			end
		end
		
		return mc
	end
	
	function localGroup:newText(txt_str, txt_width, size, lining, centering)
		local mc = display.newGroup();
		mc.w = txt_width;
		
		local lines = {};
		--[[
		local temp_arr=string_split_ext(txt_str, "\r");
		print("__temp_arr:", #temp_arr)
		txt_str=table.concat(temp_arr,"%e");
		
		local temp_arr=string_split_ext(txt_str, "\n");
		print("__temp_arr:", #temp_arr)
		txt_str=table.concat(temp_arr,"%e");
		]]--
		local txt_arr=string_split_ext(txt_str, " ");
		--print("___txt_arr:", #txt_arr);
		
		local line_obj={};
		table.insert(lines, line_obj)
		
		local h_size=math.floor(size*5/4);
		
		local c1,c2,c3 = 255,255,255;
		local coloring=false;
		
		local xd=0;
		local nx=xd;
		local ny=h_size;
		local space_size=size/4;
		
		local function switchColor(tc1,tc2,tc3)
			coloring = not coloring;
			if(coloring)then
				c1,c2,c3 = tc1,tc2,tc3;
			else
				c1,c2,c3 = 255,255,255;
			end
		end
		local function doNewLine()
			nx=xd;
			ny=ny+h_size;
			line_obj={};
			table.insert(lines, line_obj)
		end
		
		local function doNewWord(word)
			if(word=="")then
				return;
			end
			--if(word=="%e")then
			--	doNewLine()
			--	return
			--end
			
			local word_arr=string_split_ext2(word, "%e");
			if(#word_arr>1)then
				for j=1,#word_arr do
					doNewWord(word_arr[j]);
					if(j<#word_arr)then
						doNewLine();
					end
				end
				return;
			end
				
				local item_mc = display.newGroup();
				mc:insert(item_mc);

				local dtxt=display.newText(item_mc,word,0,0,fontMain,size);
				dtxt:setTextColor(c1, c2, c3);
				local word_width=dtxt.width;
				dtxt.anchorX, dtxt.anchorY = 0.5,0.5;
				dtxt.x,dtxt.y = 0,0;
				
				item_mc.dtxt=dtxt;
				item_mc.w,item_mc.h = word_width,dtxt.height;
				
				if(nx+word_width+space_size>txt_width)then
					doNewLine()
				end
				
				item_mc.x=nx+word_width/2;
				item_mc.y=ny;
				
				table.insert(line_obj, item_mc)

				nx=nx+word_width+space_size;
			--end
		end
		for i=1,#txt_arr do
			local word=txt_arr[i];
			
			if(word:find("%y%", 1, true))then
				local word_arr=string_split_ext2(word, "%y%");
				for j=1,#word_arr do
					doNewWord(word_arr[j]);
					if(j<#word_arr)then
						switchColor(200,200,0);
					end
				end
			elseif(word:find("%g%", 1, true))then
				local word_arr=string_split_ext2(word, "%g%");
				for j=1,#word_arr do
					doNewWord(word_arr[j]);
					if(j<#word_arr)then
						switchColor(0,200,0);
					end
				end
			elseif(word:find("%b%", 1, true))then
				local word_arr=string_split_ext2(word, "%b%");
				for j=1,#word_arr do
					doNewWord(word_arr[j]);
					if(j<#word_arr)then
						switchColor(0, 1/2, 1);
					end
				end
			elseif(word:find("%r%", 1, true))then
				local word_arr=string_split_ext2(word, "%r%");
				for j=1,#word_arr do
					doNewWord(word_arr[j]);
					if(j<#word_arr)then
						switchColor(200,0,0);
					end
				end
			else
				doNewWord(word);
			end
		end

		for i=1,#lines do
				local line_obj = lines[i];
				local space_size=size/4;
				if(lining)then
					space_size=(txt_width - get_line_pure_w(line_obj))/#line_obj;
				end
				if(centering)then
					xd = (txt_width - get_line_pure_w(line_obj) - space_size*(#line_obj-1))/2;
				end
				if(space_size<30*scaleGraphics or centering)then
					local nx=xd;
					for j=1,#line_obj do
						local item_mc = line_obj[j];
						local word_width=item_mc.w;
						item_mc.x=nx+word_width/2;
						nx=nx+word_width+space_size;
					end
				end
		end
		if(options_debug)then
			local line_mc = display.newLine(mc, 0, h_size, txt_width, #lines*h_size);
			line_mc.strokeWidth = 3;
			line_mc.alpha = 0.5;
		
			local line_mc = display.newLine(mc, txt_width, h_size, 0, #lines*h_size);
			line_mc.strokeWidth = 3;
			line_mc.alpha = 0.5;
		end
		mc.h = (#lines)*h_size;
		return mc
	end
	
	return localGroup;
end