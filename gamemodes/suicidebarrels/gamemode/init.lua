AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "cl_antiradar.lua" )
AddCSLuaFile( "cl_targetid.lua" ) 
AddCSLuaFile( "cl_hudpickup.lua" )
AddCSLuaFile( "cl_deathnotice.lua" ) -- Fretta
AddCSLuaFile( "vgui/vgui_gamenotice.lua" ) -- Fretta
AddCSLuaFile( "cl_spawnmenu.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "obj_player_extend.lua" )
AddCSLuaFile( "gravitygun.lua" )
AddCSLuaFile( "player_shd.lua" )
AddCSLuaFile( 'sh_roundtimer.lua' )

include( 'player.lua' )
include( 'cl_init.lua' )
include( 'shared.lua' )
include( 'sh_roundtimer.lua' )


/*---------------------------------------------------------
n0st4lg1c
---------------------------------------------------------*/

/*---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Carries out actions when the player dies 		 
---------------------------------------------------------*/
function GM:DoPlayerDeath( ply, attacker, dmginfo ) 

	if ( ply:Team() == TEAM_BARRELS or ply:Team() == TEAM_HUMANS ) then
		ply:CreateRagdoll()
	elseif ( ply:Team() == TEAM_SPECTATOR ) then
		ply:Spawn()
	end
	
	if (ply:Team() == TEAM_BARRELS and attacker:Team() == TEAM_HUMANS ) then
		ply:AddDeaths(1)
		ply:AddFrags(-1)
		attacker:AddFrags(humanKillScore)
	elseif (ply:Team() == TEAM_HUMANS and attacker:Team() == TEAM_BARRELS ) then
		ply:AddDeaths(1)
		attacker:AddFrags(barrelKillScore)	
	else
		return
	end
	
end

function GM:StartFrettaVote()
   if GAMEMODE.m_bVotingStarted or GAMEMODE:InGamemodeVote() then return end
      -- manually set what would be the result of a GM vote otherwise
      GAMEMODE.WinningGamemode = "suicidebarrels"

      GAMEMODE.m_bVotingStarted = true

      GAMEMODE:ClearPlayerWants()
      
      GAMEMODE:StartMapVote()
end

/*---------------------------------------------------------
   Name: gamemode:OnNPCKilled( entity, attacker, inflictor )
   Desc: The NPC has died
---------------------------------------------------------*/
function GM:OnNPCKilled( ent, attacker, inflictor )

	// Convert the inflictor to the weapon that they're holding if we can.
	if ( inflictor && attacker == inflictor && (inflictor:IsPlayer() || inflictor:IsNPC()) ) then
	
		inflictor = inflictor:GetActiveWeapon()
		if ( attacker == NULL ) then inflictor = attacker end
	
	end
	
	local InflictorClass = "World"
	local AttackerClass = "World"
	
	if ( inflictor && inflictor != NULL ) then InflictorClass = inflictor:GetClass() end
	if ( attacker  && attacker != NULL ) then AttackerClass = attacker:GetClass() end

	if ( attacker && attacker:IsPlayer() ) then
	
		umsg.Start( "PlayerKilledNPC" )
		
			umsg.String( ent:GetClass() )
			umsg.String( InflictorClass )
			umsg.Entity( attacker )
		
		umsg.End()
		
	return end
	
	umsg.Start( "NPCKilledNPC" )
	
		umsg.String( ent:GetClass() )
		umsg.String( InflictorClass )
		umsg.String( AttackerClass )
	
	umsg.End()

end