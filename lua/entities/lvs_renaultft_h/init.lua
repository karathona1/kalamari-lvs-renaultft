AddCSLuaFile("shared.lua")
include("shared.lua")

AddCSLuaFile("cl_init.lua")

function ENT:MakeProjectile( ent )

	local ID = self:LookupAttachment( "gun_muzzle" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return end
	local Driver = self:GetDriver()
	local projectile = ents.Create( "lvs_fth_howitzer" )

	local ang = Muzzle.Ang
	projectile:SetPos( Muzzle.Pos )
	ang:RotateAroundAxis(ang:Right(), 180)
	projectile:SetAngles( ang )
	projectile:SetParent( self, ID )
	projectile:Spawn()
	projectile:Activate()
	projectile:SetModel("models/misc/88mm_projectile.mdl")
	projectile:SetAttacker( IsValid( Driver ) and Driver or self )
	projectile:SetEntityFilter( self:GetCrosshairFilterEnts() )
	projectile:SetSpeed( Muzzle.Ang:Forward() * 2500 )
	projectile:SetDamage( 400 )
	projectile:SetRadius( 150 )

	projectile.UpdateTrajectory = function( bomb )
		bomb:SetSpeed( bomb:GetForward() * 2500 )
	end

	if projectile.SetMaskSolid then
		projectile:SetMaskSolid( true )
	end

	self._ProjectileEntity = projectile
end

function ENT:FireProjectile( ent )
	local ID = self:LookupAttachment( "gun_muzzle" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle or not IsValid( self._ProjectileEntity ) then return end

	self._ProjectileEntity:Enable()
	self._ProjectileEntity:SetCollisionGroup( COLLISION_GROUP_NONE )

	local effectdata = EffectData()
		effectdata:SetOrigin( self._ProjectileEntity:GetPos() )
		effectdata:SetEntity( self._ProjectileEntity )
	util.Effect( "lvs_haubitze_trail", effectdata )

	local effectdata = EffectData()
	effectdata:SetOrigin( Muzzle.Pos )
	effectdata:SetNormal( -Muzzle.Ang:Forward() )
	effectdata:SetEntity( self )
	util.Effect( "lvs_muzzle", effectdata )

	local PhysObj = self:GetPhysicsObject()
	if IsValid( PhysObj ) then
		PhysObj:ApplyForceOffset( Muzzle.Ang:Forward() * 125000, Muzzle.Pos )
	end

	self:TakeAmmo()
	self:SetHeat( 1 )
	self:SetOverheated( true )

	self._ProjectileEntity = nil

	if not IsValid( self.SNDTurretHowi ) then return end

	self.SNDTurretHowi:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

	self:EmitSound("lvs/vehicles/wespe/cannon_reload.wav", 65, 100, 1, CHAN_WEAPON )
end
