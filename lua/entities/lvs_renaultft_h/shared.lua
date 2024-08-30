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

// used in cl_optics.lua
ENT.WeaponName = "CANON 75mm"

ENT.TurretSeatIndex = 1

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//CANNON
	local weapon = {}
	weapon.Icon = Material("weapons/cannon.png")
	weapon.Ammo = 24
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