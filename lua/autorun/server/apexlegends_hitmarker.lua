util.AddNetworkString("apexlegends_hitmarker_hit")
util.AddNetworkString("apexlegends_hitmarker_kill")

local hit_other_already = {}
hook.Add("PlayerDeath", "PlayerDeath.ApexLegends_HitM", function(victim, inflictor, attacker)
	if victim == attacker then return end
	if not attacker or not attacker:IsPlayer() then return end

	local player_index = victim:EntIndex()
	net.Start("apexlegends_hitmarker_kill")
		net.WriteBool(victim.LastHitGroup and victim:LastHitGroup() == 1 or false)
		net.WriteBool(hit_other_already[player_index] and #hit_other_already[player_index] > 1 or false)
	net.Send(attacker)

	hit_other_already[player_index] = {}
end)

local hit_other = {}
hook.Add("OnNPCKilled", "OnNPCKilled.ApexLegends_HitM", function(npc, attacker, inflictor)
	if npc == attacker then return end
	if not attacker or not attacker:IsPlayer() then return end

	local npc_index = npc:EntIndex()
	net.Start("apexlegends_hitmarker_kill")
		net.WriteBool(false)
		net.WriteBool(hit_other_already[npc_index] and #hit_other_already[npc_index] > 1 or false)
	net.Send(attacker)
	
	hit_other_already[npc_index] = {}
end)

hook.Add("EntityTakeDamage", "EntityTakeDamage.ApexLegends_HitM", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if target == attacker then return end
	if not attacker:IsPlayer() then return end

	local should_hitm = false
	if not should_hitm and target:IsPlayer() then should_hitm = true end
	if not should_hitm and target:IsNPC() then should_hitm = true end

	if not should_hitm then return end

	local target_index = target:EntIndex()
	if not hit_other_already[target_index] then hit_other_already[target_index] = {} end
	hit_other_already[target_index][attacker] = true

	net.Start("apexlegends_hitmarker_hit")
	net.Send(attacker)
end)