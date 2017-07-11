-- WIP, swap comment lines below to enable

local function radarblah(name)
--s_protect.command_radar = function(name)
	local player = minetest.get_player_by_name(name)
	local pos = s_protect.get_location(player:getpos())
	local data_cache

	local claims = s_protect.claims
	local function getter(x, ymod, z)
		data_cache = claims[x .."," .. (pos.y + ymod) .. "," .. z]
		return data_cache
	end
	local function colorize()
		--[[
		if not data_cache then
			-- Area not claimed
			return "^[colorize:#000:50"
		end
		if data_cache.owner == name then
			return "^[colorize:#0F0:180"
		end
		if table_contains(data_cache.shared, name) then
			return "^[colorize:#0F0:100"
		end
		if table_contains(data_cache.shared, "*all") then
			return "^[colorize:#0F9:100"
		end
		]]
		-- Claimed but not shared
		return "^[colorize:#000:180"
	end

	local img_0 = "simple_protection_radar.png"
	local img_u = "simple_protection_radar_up.png"
	local img_d = "simple_protection_radar_down.png"

	local parts = ""
	local ymods = { 0, -1, 1 }
	for z = 0, 8 do
	for x = 0, 8 do
		local ax = pos.x + x - 4
		local az = pos.z + z - 4
		if     getter(ax,  0, az) then
			parts = parts ..
				":" .. (x * 32) .. "," .. (z * 32) .. "="..img_0
			print("found one")
		elseif getter(ax, -1, az) then
			-- Check for claim below first
			parts = parts ..
				":" .. (x * 32) .. "," .. (z * 32) .. "="..img_d
		elseif getter(ax,  1, az) then
			-- Last, check upper area
			parts = parts ..
				":" .. (x * 32) .. "," .. (z * 32) .. "="..img_u
		end
	end
	end
	minetest.show_formspec(name, "covfefe",
		"size[6,6]" ..
		"image[0.5,0.5;6,6;" .. img_0 ..
		minetest.formspec_escape("^[combine:288x288" ..
	 		minetest.formspec_escape(parts)) ..
		"]"
	)
end