module(..., package.seeall);

function new()
	local art = {};
	
	art.deltas={};
	local function handle_offsets(left_str, dx, dy)
		if(left_str:find("amazon", 1, true))then
					local txt_obj = string_split(left_str, 'amazon');
					local nleft_str = "amazon2"..table.concat(txt_obj, "");
					art.deltas[nleft_str]={x=dx, y=dy};
					local nleft_str = "amazon3"..table.concat(txt_obj, "");
					art.deltas[nleft_str]={x=dx, y=dy};
		end
		
		if(left_str:find("medusa_", 1, true) or left_str:find("mermaid_", 1, true))then
			if(left_str:find("_go", 1, true))then
				local txt_obj = string_split(left_str, "_go");
				local nleft_str = table.concat(txt_obj, "_reload");
				art.deltas[nleft_str]={};
				art.deltas[nleft_str].x, art.deltas[nleft_str].y = dx,dy;
			end
		else
			if(left_str:find("_attack", 1, true))then
				local txt_obj = string_split(left_str, "_attack");
				local nleft_str = table.concat(txt_obj, "_reload");
				art.deltas[nleft_str]={};
				art.deltas[nleft_str].x, art.deltas[nleft_str].y = dx,dy;
			end
		end
		
		if(left_str:find("mag_evil_idle", 1, true))then
			local txt_obj = string_split(left_str, 'idle');
			local nleft_str = table.concat(txt_obj, "pause");
			art.deltas[nleft_str]={};
			art.deltas[nleft_str].x, art.deltas[nleft_str].y = dx,dy;
		end
	end
	
	local function load_offsets(path_str, extrax)
		local path =  system.pathForFile(path_str, system.ResourceDirectory);
		local file = io.open( path, "r" );
		local ani_delta_file = file:read( "*a" );
		io.close( file );
		if(ani_delta_file)then
			local ani_arr = string_split(ani_delta_file, ";");
			for i=1,#ani_arr do
				local line_str=ani_arr[i];
				local line_arr=string_split(line_str, ":");
				local left_arr=string_split(line_arr[1],"/");
				local left_str=left_arr[#left_arr];
				
				local rigth_arr=string_split(line_arr[2],",");
				local dx,dy = rigth_arr[1]*extrax, -rigth_arr[2]/2;
				art.deltas[left_str]={};
				art.deltas[left_str].x, art.deltas[left_str].y = dx,dy;
				
				handle_offsets(left_str, dx, dy);
			end
		end
	end
		
	local function load_royal_offsets(path_str)
		local path =  system.pathForFile(path_str, system.ResourceDirectory);
		local file = io.open( path, "r" );
		local ani_delta_file = file:read( "*a" );
		io.close( file );
		if(ani_delta_file)then
			local ani_arr = string_split(ani_delta_file, ";");
			for i=1,#ani_arr do
				local line_str=ani_arr[i];
				if(#line_str>2)then
					local line_arr=string_split(line_str, ":");
					-- local left_arr=string_split(line_arr[1],"/");
					local left_str=line_arr[1];
					-- print('---')
					-- print(line_str, #line_str)
					-- print(line_arr[1])
					-- print(line_arr[2])
					
					local rigth_arr=string_split(line_arr[2],",");
					local dx,dy = rigth_arr[1]/1, -rigth_arr[2]/2;
					art.deltas[left_str]={};
					art.deltas[left_str].x, art.deltas[left_str].y = dx,dy;
					
					handle_offsets(left_str, dx, dy);
				end
			end
		end
	end
	
	function art:load_deltas()
		load_offsets("data/majesty_export.txt",0);
		load_offsets("data/majesty_export_2.txt",1);
		load_offsets("data/majesty_export_3.txt",1);
		
		load_royal_offsets("data/royal_deltas_4.txt");
	end
	
	return art;
end