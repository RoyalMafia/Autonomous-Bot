// -- Vars -- \\
local killedBy = {}
local arrestedBy = {}
local found = false

// -- Net MSGs -- \\
util.AddNetworkString("AutoBotTableUpdateRDM")
util.AddNetworkString("AutoBotTableUpdateRDA")
util.AddNetworkString("AutoBotRemoveWarns")
util.AddNetworkString("AutoBotWarn")
util.AddNetworkString("AutoBotFreeze")

// -- Functions -- \\
function tableInsert( insertInto, p1, p2, p3, p4 )

	if insertInto == killedBy then
		toInsert          = {}
		toInsert.Attacker = p1
		toInsert.Victim   = p2
		toInsert.Kills    = p3
		toInsert.Time     = os.date("[%d/%m/%Y] %X")
		toInsert.Warns    = p4
		toInsert.TimeLeft = 180
	end

	if insertInto == arrestedBy then
		toInsert 		  = {}
		toInsert.Arrested = p1
		toInsert.Arrests  = p2
		toInsert.Arrestor = p3
		toInsert.Warns    = p4
		toInsert.Time     = os.date("[%d/%m/%Y] %X")
		toInsert.TimeLeft = 180
	end

	table.insert( insertInto, toInsert)

end

function removePlayer(removeFrom, id)
	if removeFrom == killedBy then
		if killedBy[id].Attacker:IsFrozen() then
			killedBy[id].Attacker:Freeze(false)
		end
	end

	if removeFrom == arrestedBy then
		if arrestedBy[id].Arrestor:IsFrozen() then
			arrestedBy[id].Arrestor:Freeze(false)
		end
	end

	table.remove(removeFrom, id)
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
						net.Start("AutoBotWarn") 
							net.WriteString("You've been flagged as an RDM'er. Continuing will result in punishment.")
						net.Send(attacker)
					elseif killedBy[i].Warns == 2 then
						net.Start("AutoBotWarn") 
							net.WriteString("You've been frozen for the following reason: RDM, an Admin is on their way.")
						net.Send(attacker)
						attacker:Freeze(true)
					elseif killedBy[i].Warns == 5 then
						attacker:Kick("You've been automatically kicked for RDM")
					end
				end

				if found then return end

			elseif !found and i == #killedBy then
				tableInsert(killedBy, attacker, victim, 1, 0)
			end

		end

	elseif #killedBy == 0 then
		tableInsert(killedBy, attacker, victim, 1, 0)
	end

end

function onArrest( criminal, time, actor )
	if !actor:IsPlayer() then return end

	if #arrestedBy > 0 then
		found = false

		for i = 1, #arrestedBy do

			if actor == arrestedBy[i].Arrestor then
				found = true
				arrestedBy[i].Arrests = arrestedBy[i].Arrests + 1
				arrestedBy[i].Time  = os.date("[%d/%m/%Y] %X")
				arrestedBy[i].Arrested = criminal

				if arrestedBy[i].Arrests >= 3 then
					arrestedBy[i].Warns = arrestedBy[i].Warns + 1
					if arrestedBy[i].Warns == 1 then
						net.Start("AutoBotWarn") 
							net.WriteString("You've been flagged as an RDA'er. Continuing will result in punishment.")
						net.Send(actor)
					elseif arrestedBy[i].Warns == 2 then
						net.Start("AutoBotWarn") 
							net.WriteString("You've been frozen for the following reason: RDA, an Admin is on their way.")
						net.Send(actor)
						actor:Freeze(true)
					elseif arrestedBy[i].Warns == 5 then
						actor:Kick("You've been automatically kicked for RDA")
					end
				end

				if found then return end

			elseif !found and i == #killedBy then
				tableInsert(arrestedBy, criminal, 1, actor, 0)
			end

		end

	elseif #arrestedBy == 0 then
		tableInsert(arrestedBy, criminal, 1, actor, 0)
	end
end

// -- Hooks -- \\
hook.Add("PlayerDeath", "RDMCheck", onDeath)
hook.Add("playerArrested", "RDACheck", onArrest)

// -- Timers -- \\
timer.Create("UpdateTable", 1, 0, function()
	net.Start("AutoBotTableUpdateRDM")
		net.WriteTable(killedBy)
	net.Broadcast()

	net.Start("AutoBotTableUpdateRDA")
		net.WriteTable(arrestedBy)
	net.Broadcast()

	for i = 1, #killedBy do
		if killedBy[i].TimeLeft != 0 then
			killedBy[i].TimeLeft = killedBy[i].TimeLeft - 1
		else
			removePlayer(killedBy, i)
		end
	end

	for i = 1, #arrestedBy do
		if arrestedBy[i].TimeLeft != 0 then
			arrestedBy[i].TimeLeft = arrestedBy[i].TimeLeft - 1
		else
			removePlayer(arrestedBy, i)
		end
	end
end)

// -- Net Receive -- \\
net.Receive("AutoBotRemoveWarns", function(len, pl)
	string = net.ReadString()
	num = net.ReadInt(16)
	
	if string == "RDM" then
		removePlayer(killedBy, num)
	end

	if string == "RDA" then
		removePlayer(arrestedBy, num)
	end
end)

net.Receive("AutoBotFreeze", function(len, pl)
	net.ReadEntity():Freeze(net.ReadBool())
end)
