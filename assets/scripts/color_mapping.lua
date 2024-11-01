-- Functions and tables for mesh vertex color mapping data.
-- Take mesh buffer with vertex color data and map out/index triangle faces(indices) and color value data for realtime manipulation

local M = {}
local Table_Insert = table.insert

M.mesh_maps = {}
M.mesh_color_streams = {}


function M.map_vertex_colors(mesh_url)
	local function new_color(col,ind)
		local new_data = {
				color = col,
				index = {ind}
						}
		return new_data
	end
	local mesh = go.get(mesh_url, "vertices")
	local mbuffer = resource.get_buffer(mesh)
	local color_flag = pcall(buffer.get_stream,mbuffer,hash("color")) -- color stream flag

	if color_flag then 

		if M.mesh_maps[mesh_url] == nil then

			M.mesh_maps[mesh_url] = {}
			local color_stream = buffer.get_stream(mbuffer, hash("color"))
			local tri_count = 0
			local count = #color_stream
			------------------  Stash mesh buffer for later use  --------------------------
			M.mesh_color_streams[mesh_url] = {} ; M.mesh_color_streams[mesh_url].color = color_stream
			-------------------------------------------------------------------------------

			for i = 1, count, 12 do

				tri_count = tri_count + 1
				local color = vmath.vector4(color_stream[i],color_stream[i+1],color_stream[i+2],color_stream[i+3])

				if M.mesh_maps[mesh_url][1] == nil then -- Add initial data to table if empty

					Table_Insert(M.mesh_maps[mesh_url],new_color(color,i))

				else

					local map_count = #M.mesh_maps[mesh_url]
					for i2 = 1 , #M.mesh_maps[mesh_url] do

						if M.mesh_maps[mesh_url][i2].color == color then -- Match color: add i to current item index table
							Table_Insert(M.mesh_maps[mesh_url][i2].index,i)
							break
						elseif i2 == map_count then
							Table_Insert(M.mesh_maps[mesh_url],new_color(color,i))
							break
						end

					end

				end

			end

		else
			print(mesh_url..": COLOR DATA FOR THIS MODEL HAS ALREADY BEEN ADDED")
		end

	else
		print(mesh_url..": MESH DOES NOT CONTAIN A VERTEX COLOR STREAM")
	end

end


function M.color_on_mesh(mesh_url, mapped_id, color)

	if M.mesh_color_streams[mesh_url] then
		if mapped_id <= #M.mesh_maps[mesh_url] then
			local transfer_color = {color.x, color.y, color.z, color.w, color.x, color.y, color.z, color.w, color.x, color.y, color.z, color.w,}
		
			for i = 1, #M.mesh_maps[mesh_url][mapped_id].index do
		
				local triangle = M.mesh_maps[mesh_url][mapped_id].index[i]
				for i2 = 1 , 12 do
		
					if i2 == 1 then
						M.mesh_color_streams[mesh_url].color[triangle] = transfer_color[i2]
					else
						M.mesh_color_streams[mesh_url].color[triangle+(i2-1)] = transfer_color[i2]
					end
		
				end
		
			end

		else
			print(mesh_url..": ONLY HAS "..#M.mesh_maps[mesh_url].." MAPPED COLORS. YOU TRIED TO COLOR INDEX "..mapped_id)
		end

	else
		print(mesh_url.." HAS NOT BEEN MAPPED AND CANNOT BE COLORED, USE m.map_vertex_colors(mesh_url) TO MAP MESH FIRST.")
	end
end


function M.mesh_info(mesh_url)

	if M.mesh_maps[mesh_url] then

		local chars = string.find(mesh_url,"#",1,true)+1
		local mesh_name = string.sub(mesh_url,chars)
		local count = #M.mesh_color_streams[mesh_url].color
		local verts = count / 4
		local triangles = count/12
		local color_count = #M.mesh_maps[mesh_url]
		print(mesh_name.."-( Vertices:"..verts.." | Triangle-faces:"..(triangles).." Mapped-colors:"..color_count.." )")
		for i = 1 , color_count do
			print("Indexed Color "..i.." = ( "..M.mesh_maps[mesh_url][i].color.x..", "..M.mesh_maps[mesh_url][i].color.y..", "..M.mesh_maps[mesh_url][i].color.z.." )" )
		end

	else
		print(mesh_url,"HAS NOT BEEN MAPPED OR HAS ALREADY BEEN REMOVED, USE m.map_vertex_colors(mesh_url) TO CREATE DATA FOR THIS MESH FIRST.")
	end

end


function M.remove_mesh(mesh_url)

	if M.mesh_maps[mesh_url] then

		M.mesh_maps[mesh_url] = nil
		M.mesh_color_streams[mesh_url] = nil

	else
		print("NO DATA FOR "..mesh_url.." TO REMOVE!")
	end

end


return M