local killedBy = {}
local arrestedBy = {}

net.Receive("AutoBotTableUpdateRDM", function(pl, len)
	killedBy = net.ReadTable()
end)

net.Receive("AutoBotTableUpdateRDA", function(pl, len)
	arrestedBy = net.ReadTable()
end)

net.Receive("AutoBotWarn", function(pl, len)
	chat.AddText(Color(240,70,70), "[AutoBot Warn] ", Color(255,255,255), net.ReadString())
end)

surface.CreateFont( "F1", {font = "DermaLarge",size = 18,weight = 100,blursize = 0,scanlines = 0,})
surface.CreateFont( "F2", {font = "DermaLarge",size = 25,weight = 100,blursize = 0,scanlines = 0,})
surface.CreateFont( "F3", {font = "DermaLarge",size = 20,weight = 100,blursize = 0,scanlines = 0,})

function DrawMenu()
	local AMenu = vgui.Create( "DFrame" )
	AMenu:SetSize(300, 95)
	AMenu:Center()
	AMenu:MakePopup()
	AMenu:SetTitle( "" )
	AMenu:SetDraggable( false )
	AMenu:ShowCloseButton( false )

	AMenu.Paint = function()
		draw.RoundedBox( 0, 0, 0, AMenu:GetWide(), AMenu:GetTall(), Color( 30,30,30, 240 ) )
		draw.RoundedBox( 0, 0, 0, AMenu:GetWide(), 30, Color( 42,126,251,255 ) )

		draw.SimpleText("Auto Bot Menu", "F3", AMenu:GetWide()/2, 13, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local MenuCloseButton = vgui.Create("DButton")
	MenuCloseButton:SetParent( AMenu )
	MenuCloseButton:SetText( "" )
	MenuCloseButton:SetPos( AMenu:GetWide() - 40, 5 )
	MenuCloseButton:SetSize( 35, 20 )

	MenuCloseButton.Paint = function()

		if(MenuCloseButton:IsHovered()) then
			draw.RoundedBox(0,0,0, MenuCloseButton:GetWide(), MenuCloseButton:GetTall(), Color(30,30,30,150))
			draw.SimpleText("X", "F1", MenuCloseButton:GetWide()/2, MenuCloseButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0,0,0, MenuCloseButton:GetWide(), MenuCloseButton:GetTall(), Color(30,30,30,100))
			draw.SimpleText("X", "F1", MenuCloseButton:GetWide()/2, MenuCloseButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	end

	MenuCloseButton.DoClick = function ()
		AMenu:Close()
	end

	local RDMButton = vgui.Create("DButton", AMenu)
	RDMButton:SetPos( 5, 35)
	RDMButton:SetSize(AMenu:GetWide() - 10, 25)
	RDMButton:SetText("")

	RDMButton.Paint = function()
		if(RDMButton:IsHovered()) then
			draw.RoundedBox(0,0,0, RDMButton:GetWide(), RDMButton:GetTall(), Color(42,126,251,200))
			draw.SimpleText("RDM Logs", "F1", RDMButton:GetWide()/2, RDMButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0,0,0, RDMButton:GetWide(), RDMButton:GetTall(), Color(42,126,251,255))
			draw.SimpleText("RDM Logs", "F1", RDMButton:GetWide()/2, RDMButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	RDMButton.DoClick = function()
		AMenu:Close()
		RDMDrawTable()
	end

	local RDAButton = vgui.Create("DButton", AMenu)
	RDAButton:SetPos( 5, 65)
	RDAButton:SetSize(AMenu:GetWide() - 10, 25)
	RDAButton:SetText("")

	RDAButton.Paint = function()
		if(RDAButton:IsHovered()) then
			draw.RoundedBox(0,0,0, RDAButton:GetWide(), RDAButton:GetTall(), Color(42,126,251,200))
			draw.SimpleText("RDA Logs", "F1", RDAButton:GetWide()/2, RDAButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0,0,0, RDAButton:GetWide(), RDAButton:GetTall(), Color(42,126,251,255))
			draw.SimpleText("RDA Logs", "F1", RDAButton:GetWide()/2, RDAButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	RDAButton.DoClick = function()
		AMenu:Close()
		RDADrawTable()
	end

end

function RDMDrawTable()
	local PlayerTable = vgui.Create( "DFrame" )
	PlayerTable:SetSize( ScrW() / 1.8, ScrH() / 1.6 )
	PlayerTable:Center()
	PlayerTable:SetTitle( "" )
	PlayerTable:SetVisible( true )
	PlayerTable:SetDraggable( false )
	PlayerTable:ShowCloseButton( false ) 
	PlayerTable:MakePopup()
	PlayerTable.Paint = function()

		draw.RoundedBox( 0, 0, 0, PlayerTable:GetWide(), PlayerTable:GetTall(), Color( 30,30,30, 240 ) )
		draw.RoundedBox( 0, 0, 0, PlayerTable:GetWide(), 30, Color( 42,126,251,255 ) )

		draw.SimpleText("RDM Logs", "F3", PlayerTable:GetWide()/2, 13, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local DermaCloseButton = vgui.Create("DButton")
	DermaCloseButton:SetParent( PlayerTable )
	DermaCloseButton:SetText( "" )
	DermaCloseButton:SetPos( PlayerTable:GetWide() - 40, 5 )
	DermaCloseButton:SetSize( 35, 20 )

	DermaCloseButton.Paint = function()

		if(DermaCloseButton:IsHovered()) then
			draw.RoundedBox(0,0,0, DermaCloseButton:GetWide(), DermaCloseButton:GetTall(), Color(30,30,30,150))
			draw.SimpleText("X", "F1", DermaCloseButton:GetWide()/2, DermaCloseButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0,0,0, DermaCloseButton:GetWide(), DermaCloseButton:GetTall(), Color(30,30,30,100))
			draw.SimpleText("X", "F1", DermaCloseButton:GetWide()/2, DermaCloseButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	end

	DermaCloseButton.DoClick = function ()
		PlayerTable:Close()
	end

	local Scroll = vgui.Create( "DScrollPanel", PlayerTable )
	Scroll:SetSize( PlayerTable:GetWide() - 10, PlayerTable:GetTall() - 40 )
	Scroll:SetPos( 5, 35 )

	local PlayerList = vgui.Create( "DListView", Scroll )
	PlayerList:SetSize(PlayerTable:GetWide() + 7, PlayerTable:GetTall() - 40)
	PlayerList:SetMultiSelect( false )
	PlayerList:AddColumn( "Time" ) PlayerList:AddColumn( "Player" ) PlayerList:AddColumn( "Kills" ) PlayerList:AddColumn( "Warns" ) PlayerList:AddColumn( "Last Victim" ) PlayerList:AddColumn( "Time Left (secs)" )

	PlayerList.Paint = function() end

	for i = 1, #killedBy do
		PlayerList:AddLine(killedBy[i].Time, killedBy[i].Attacker:Nick(), killedBy[i].Kills, killedBy[i].Warns, killedBy[i].Victim:Nick(), killedBy[i].TimeLeft)

		PlayerList:GetLine(i).Paint = function()
			if PlayerList:GetLine(i):IsHovered() then
				draw.RoundedBox( 0, 0, 0, PlayerList:GetWide(), PlayerList:GetTall(), Color(42,126,251,255) )
			else
				draw.RoundedBox( 0, 0, 0, PlayerList:GetWide(), PlayerList:GetTall(), Color(42,126,251,230) )
			end
		end
	end

	PlayerList.OnRowRightClick = function()
		local ScoreboardMenu = vgui.Create("DMenu", PlayerList)
		ScoreboardMenu:AddOption("Remove Warns", function() 
			net.Start("AutoBotRemoveWarns")
				net.WriteString("RDM")
				net.WriteInt(PlayerList:GetSelectedLine(), 16)
			net.SendToServer()
			PlayerList:RemoveLine(PlayerList:GetSelectedLine())
		 end)

		if player.GetAll()[PlayerList:GetSelectedLine()]:IsFrozen() then
			ScoreboardMenu:AddOption("Unfreeze player", function()
				net.Start("AutoBotFreeze")
					net.WriteEntity(player.GetAll()[PlayerList:GetSelectedLine()])
					net.WriteBool(false)
				net.SendToServer()
			end)
		else
			ScoreboardMenu:AddOption("Freeze player", function()
				net.Start("AutoBotFreeze")
					net.WriteEntity(player.GetAll()[PlayerList:GetSelectedLine()])
					net.WriteBool(true)
				net.SendToServer()
			end)
		end
	
		ScoreboardMenu:Open() 

		ScoreboardMenu.Paint = function()
			draw.RoundedBox( 0, 0, 0, PlayerTable:GetWide(), PlayerTable:GetTall(), Color( 42,126,251,255 ) )
		end
	end
end

function RDADrawTable()
	local PlayerTable = vgui.Create( "DFrame" )
	PlayerTable:SetSize( ScrW() / 1.8, ScrH() / 1.6 )
	PlayerTable:Center()
	PlayerTable:SetTitle( "" )
	PlayerTable:SetVisible( true )
	PlayerTable:SetDraggable( false )
	PlayerTable:ShowCloseButton( false ) 
	PlayerTable:MakePopup()
	PlayerTable.Paint = function()

		draw.RoundedBox( 0, 0, 0, PlayerTable:GetWide(), PlayerTable:GetTall(), Color( 30,30,30, 240 ) )
		draw.RoundedBox( 0, 0, 0, PlayerTable:GetWide(), 30, Color( 42,126,251,255 ) )

		draw.SimpleText("RDA Logs", "F3", PlayerTable:GetWide()/2, 13, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local DermaCloseButton = vgui.Create("DButton")
	DermaCloseButton:SetParent( PlayerTable )
	DermaCloseButton:SetText( "" )
	DermaCloseButton:SetPos( PlayerTable:GetWide() - 40, 5 )
	DermaCloseButton:SetSize( 35, 20 )

	DermaCloseButton.Paint = function()

		if(DermaCloseButton:IsHovered()) then
			draw.RoundedBox(0,0,0, DermaCloseButton:GetWide(), DermaCloseButton:GetTall(), Color(30,30,30,150))
			draw.SimpleText("X", "F1", DermaCloseButton:GetWide()/2, DermaCloseButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0,0,0, DermaCloseButton:GetWide(), DermaCloseButton:GetTall(), Color(30,30,30,100))
			draw.SimpleText("X", "F1", DermaCloseButton:GetWide()/2, DermaCloseButton:GetTall()/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	end

	DermaCloseButton.DoClick = function ()
		PlayerTable:Close()
	end

	local Scroll = vgui.Create( "DScrollPanel", PlayerTable )
	Scroll:SetSize( PlayerTable:GetWide() - 10, PlayerTable:GetTall() - 40 )
	Scroll:SetPos( 5, 35 )

	local PlayerList = vgui.Create( "DListView", Scroll )
	PlayerList:SetSize(PlayerTable:GetWide() + 7, PlayerTable:GetTall() - 40)
	PlayerList:SetMultiSelect( false )
	PlayerList:AddColumn( "Time" ) PlayerList:AddColumn( "Player" ) PlayerList:AddColumn( "Arrests" ) PlayerList:AddColumn( "Warns" ) PlayerList:AddColumn( "Arrested" ) PlayerList:AddColumn( "Time Left (secs)" )

	PlayerList.Paint = function() end

	for i = 1, #killedBy do
		PlayerList:AddLine(arrestedBy[i].Time, arrestedBy[i].Arrestor:Nick(), arrestedBy[i].Arrests, killedBy[i].Warns, arrestedBy[i].Arrested:Nick(), arrestedBy[i].TimeLeft)

		PlayerList:GetLine(i).Paint = function()
			if PlayerList:GetLine(i):IsHovered() then
				draw.RoundedBox( 0, 0, 0, PlayerList:GetWide(), PlayerList:GetTall(), Color(42,126,251,255) )
			else
				draw.RoundedBox( 0, 0, 0, PlayerList:GetWide(), PlayerList:GetTall(), Color(42,126,251,230) )
			end
		end
	end

	PlayerList.OnRowRightClick = function()
		local ScoreboardMenu = vgui.Create("DMenu", PlayerList)
		ScoreboardMenu:AddOption("Remove Warns", function() 
			net.Start("AutoBotRemoveWarns")
				net.WriteString("RDA")
				net.WriteInt(PlayerList:GetSelectedLine(), 16)
			net.SendToServer()
			PlayerList:RemoveLine(PlayerList:GetSelectedLine())
		 end)

		if player.GetAll()[PlayerList:GetSelectedLine()]:IsFrozen() then
			ScoreboardMenu:AddOption("Unfreeze player", function()
				net.Start("AutoBotFreeze")
					net.WriteEntity(player.GetAll()[PlayerList:GetSelectedLine()])
					net.WriteBool(false)
				net.SendToServer()
			end)
		else
			ScoreboardMenu:AddOption("Freeze player", function()
				net.Start("AutoBotFreeze")
					net.WriteEntity(player.GetAll()[PlayerList:GetSelectedLine()])
					net.WriteBool(true)
				net.SendToServer()
			end)
		end
	
		ScoreboardMenu:Open() 

		ScoreboardMenu.Paint = function()
			draw.RoundedBox( 0, 0, 0, PlayerTable:GetWide(), PlayerTable:GetTall(), Color( 42,126,251,255 ) )
		end
	end

end

hook.Add( "OnPlayerChat", "DrawTableList", function( ply, strText, bTeam, bDead )

	strText = string.lower( strText )

	if strText == "!amenu" and ply == LocalPlayer() then
		DrawMenu()
		return true
	end

end)
