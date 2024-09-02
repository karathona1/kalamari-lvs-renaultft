ENT.Base = "lvs_renaultft"

ENT.PrintName = "FT (75mm BS)"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's WW1 Vehicles"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Light"

ENT.Spawnable			= true

ENT.MDL = "models/tank_ft_howi.mdl"

ENT.TrackLeftSubMaterialID = 2
ENT.TrackLeftSubMaterialMul = Vector(0,-0.001,0)
ENT.TrackRightSubMaterialID = 3
ENT.TrackRightSubMaterialMul = Vector(0,-0.001,0)

ENT.MaxVelocity = 220
ENT.MaxVelocityReverse = 110

ENT.PhysicsDampingSpeed = 4000

ENT.EngineCurve = 0.2
ENT.EngineTorque = 160

// used in cl_optics.lua
ENT.WeaponName = "SCHNEIDER 75mm"

//used in cl_tankview.lua
function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetWeaponSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "gunview" ) -- muzzle_turret
		local Muzzle = self:GetAttachment( ID )
		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * -7 - Muzzle.Ang:Forward() * 3 - Muzzle.Ang:Right() * 7
		end
	end

	return pos, angles, fov
end

function ENT:CalcViewDriver( ply, pos, angles, fov, pod )
	if pod ~= self:GetWeaponSeat() and not pod:GetThirdPersonMode() then
		pos = pos + pod:GetRight() * -44
	end

	if ply:lvsMouseAim() then
		angles = ply:EyeAngles()
		return self:CalcViewMouseAim( ply, pos, angles,  fov, pod )
	else
		return self:CalcViewDirectInput( ply, pos, angles,  fov, pod )
	end
end

function ENT:CalcViewPassenger(ply, pos, angles, fov, pod)
	if pod == self:GetGunnerSeat() and pod ~= self:GetWeaponSeat() then
		local ID = self:LookupAttachment( "gunview" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * -7 - Muzzle.Ang:Forward() * 3 - Muzzle.Ang:Right() * 7
		end
	elseif not pod:GetThirdPersonMode() then
		angles = pod:LocalToWorldAngles( ply:EyeAngles() )
	end

	return self:CalcTankView( ply, pos, angles, fov, pod )
end

//used in sh_turret.lua
ENT.TurretAimRate = 15

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -30
ENT.TurretPitchMax = 30
ENT.TurretPitchMul = 1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = -1
ENT.TurretYawMin = -30
ENT.TurretYawMax = 30
ENT.TurretYawOffset = 0

//resume shared
ENT.TurretSeatIndex = 1

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//CANNON
	local weapon = {}
	weapon.Icon = Material("weapons/cannon.png")
	weapon.Ammo = 60
	weapon.Delay = 5
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.2
	weapon.StartAttack = function( ent )
	
		if self:GetAI() then return end

		self:MakeProjectile()
	end
	weapon.FinishAttack = function( ent )
		local veh = ent:GetVehicle()
		if self:GetAI() then return end

		self:FireProjectile()
		veh:PlayAnimation("gun_recoil")
	end
	weapon.Attack = function( ent )
		if not self:GetAI() then return end

		self:MakeProjectile()
		self:FireProjectile()
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		ent:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, self.TurretSeatIndex )

	//NOTHING
	local weapon = {}
	weapon.Icon = Material("weapons/cross.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		local veh = ent:GetVehicle()
		if veh.SetTurretEnabled then
			veh:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent )
		local veh = ent:GetVehicle()
		if veh.SetTurretEnabled then
			veh:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, self.TurretSeatIndex )
end