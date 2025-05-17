local hitm_color = {
	[0] = Color(255, 255, 255, 255), -- hit
	[1] = Color(255, 50, 50, 255) -- kill
}
local hitm_time, hitm_type = 0, 0
local hitm_icon = Material("ap_hitmarker/hitmarker_L.png")
local hitm_lerp = 0
local function Draw_HitMarker()
	if hitm_time < CurTime() then return end

	local cur_time = hitm_time - CurTime()
	if cur_time < 0.1 then
		hitm_lerp = Lerp(FrameTime() * 4, hitm_lerp, 0)
	end

	local scr_w, scr_h = ScrW(), ScrH()
	local size = 64 + (scr_h * 0.05)
	size = hitm_type == 1 and size * 1.75 or size
	size = size - (100 / LocalPlayer():GetFOV()) * 5 -- fov scale
	size = size * hitm_lerp

	local x, y = scr_w / 2 - size / 2, scr_h / 2 - size / 2
	surface.SetMaterial(hitm_icon)
	surface.SetDrawColor(hitm_color[hitm_type])
	surface.DrawTexturedRect(x, y, size, size)
end
hook.Add("HUDPaint", "HUDPaint.ApexLegends_HitM", Draw_HitMarker)

local function refresh_hitm()
	hitm_lerp = 1
	hitm_time = hitm_type == 1 and CurTime() + 0.6 or CurTime()
	hitm_time = CurTime() + 0.4
end
net.Receive("apexlegends_hitmarker_hit", function()
	refresh_hitm()

	hitm_type = 0
	surface.PlaySound("apexlegends_hitmarker/flesh_bulletimpact_1p_vs_3p.ogg")
end)


local sound_headkill = {
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_01.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_02.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_03.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_04.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_05.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_06.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_1p_vs_3p_2ch_v1_07.ogg"
}
local sound_headkill_other = {
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_3p_vs_1p__2ch_v1_01.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_3p_vs_1p__2ch_v1_02.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_3p_vs_1p__2ch_v1_03.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_3p_vs_1p__2ch_v1_04.ogg",
	"apexlegends_hitmarker/imp_bullet_generic_headkillshot_human_3p_vs_1p__2ch_v1_05.ogg"
}
local sound_kill = {
	"apexlegends_hitmarker/imp_bullet_lightballistic_killshot_human_1ch_v1_01.ogg",
	"apexlegends_hitmarker/imp_bullet_lightballistic_killshot_human_1ch_v1_02.ogg",
	"apexlegends_hitmarker/imp_bullet_lightballistic_killshot_human_1ch_v1_03.ogg",
	"apexlegends_hitmarker/imp_bullet_lightballistic_killshot_human_1ch_v1_04.ogg"
}
net.Receive("apexlegends_hitmarker_kill", function()
	local is_headshot = net.ReadBool()
	local is_other = net.ReadBool()
	refresh_hitm()

	hitm_type = 1
	if is_headshot then
		surface.PlaySound(is_other and sound_headkill_other[math.random(#sound_headkill_other)] or sound_headkill[math.random(#sound_headkill)])
	else
		surface.PlaySound(sound_kill[math.random(#sound_kill)])
	end
end)