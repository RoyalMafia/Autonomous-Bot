// -- Vars -- \\
local killedBy = {}
local found = false

util.AddNetworkString("AutoBotTableUpdate")
util.AddNetworkString("AutoBotRemoveWarns")

function tableInsert( p1, p2, p3, p4)

	toInsert          = {}
	toInsert.Attacker = p1
	toInsert.Victim   = p2
	toInsert.Kills    = p3
	toInsert.Time     = os.date("[%d/%m/%Y] %X")
	toInsert.Warns    = p5
	toInsert.TimeLeft = 180
	table.insert(killedBy, toInsert)

end

function onDeath( victim, inflictor, attacker)
	if victim == attacker or !attacker:IsPlayer() then return end

	if #killedBy > 0 then
		found = false

		for i = 1, #killedBy do

			if attacker == killedBy[i].Attacker then
				found = true
				killedBy[i].Kills = killedBy[i].Kills + 1
				killedBy[i].Time  = os.date("[%d/%m/%Y] %X")
				killedBy[i].Victim = victim

				if killedBy[i].Kills >= 3 then
					killedBy[i].Warns = killedBy[i].Warns + 1
					if killedBy[i].Warns == 1 then
						attacker:ChatPrint("You've been flagged as an RDM'er. Continuing will result in punishment.")
					elseif killedBy[i].Warns == 2 then
						attacker:Freeze(true)
						attacker:ChatPrint("You've been frozen for the following reason: RDM, an Admin is on their way.")
					elseif killedBy[i].Warns == 5 then
						attacker:Kick("You've been automatically kicked for RDM")
					end
				end

				if found then return end

			elseif !found and i == #killedBy then
				tableInsert(attacker, victim, 1, 0)
			end

		end

	elseif #killedBy == 0 then
		tableInsert(attacker, victim, 1, 0)
	end

end

hook.Add("PlayerDeath", "RDMCheck", onDeath)

timer.Create("UpdateTable", 1, 0, function()
	net.Start("AutoBotTableUpdate")
		net.WriteTable(killedBy)
	net.Broadcast()

	net.Receive("AutoBotRemoveWarns", function(len, pl)
		ToRemove = net.ReadInt(16)
		if killedBy[ToRemove].Attacker:IsPlayer() then
			if killedBy[ToRemove].Attacker:IsFrozen() then
				killedBy[ToRemove].Attacker:Freeze(false)
			end
			table.remove(killedBy, ToRemove)
		end
	end)
end)

timer.Create("WarnClear", 1, 0, function()
	for i = 1, #killedBy do
		if killedBy[i].TimeLeft != 0 then
			killedBy[i].TimeLeft = killedBy[i].TimeLeft - 1
		else
			table.remove(killedBy, i)
		end
	end
end)
