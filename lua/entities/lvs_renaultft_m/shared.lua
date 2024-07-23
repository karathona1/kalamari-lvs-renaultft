ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "FT (37mm Canon)"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's WW1 Vehicles"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Light"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/tank_ft_male.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1300

ENT.SpawnNormalOffset = 40

//damage system
ENT.DSArmorIgnoreForce = 1800
ENT.CannonArmorPenetration = 3900

ENT.MaxVelocity = 190
ENT.MaxVelocityReverse = 120

ENT.EngineCurve = 0.2
ENT.EngineTorque = 200

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.FastSteerAngleClamp = 15
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

ENT.lvsShowInSpawner = true

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.EngineSounds = {
	{
		sound = "engine1.wav",
		Volume = 0.7,
		Pitch = 50,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "engineFT.wav",
		Volume = 0.7,
		Pitch = 50,
		PitchMul = 25,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
end

//puteaux 37mm gun
function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//CANNON
	local weapon = {}
	weapon.Icon = Material("weapons/cannon.png")
	weapon.Ammo = 230
	weapon.Delay = 4
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )

		//Gun
		local ID = ent:LookupAttachment( "gun_muzzle" )
		local veh = ent:GetVehicle()
		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= -Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.005,0.005,0.005)
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Force	= 1900
		bullet.HullSize = 1
		bullet.Damage	= 350
		bullet.SplashDamage = 150
		bullet.SplashDamageRadius = 100
		bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
		bullet.SplashDamageType = DMG_BLAST
		bullet.Velocity = 8000
		bullet.Attacker = ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )
		
		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 40000, bullet.Src )
		end

		ent:TakeAmmo( 1 )
		veh:PlayAnimation("gun_recoil")
		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		ent:EmitSound("lvs/vehicles/sherman/cannon_reload.wav", 75, 100, 1, CHAN_WEAPON )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Stop()
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment( "gun_muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos, 
				endpos = Muzzle.Pos + -Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	self:AddWeapon( weapon, 1 )

	//NOTHING
	local weapon = {}
	weapon.Icon = Material("weapons/cross.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, 1 )
end

ENT.ExhaustPositions = {
	{
		pos = Vector(-51,-28,48),
		ang = Angle(180,55,0),
	},
}