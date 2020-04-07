AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	local owner  = self:GetOwner()

	if IsValid(owner) then
		owner:SetPuppetEntity(self)

		self.GetPlayerColor = function()
			return IsValid(owner) and owner:GetPlayerColor() or Vector()
		end

		self:SetModel(owner:GetModel())
		self:SetSolid(SOLID_VPHYSICS)
		self:SetParent(owner)
		self:SetLocalPos(Vector())
		self:SetLocalAngles(Angle())
		self:AddEffects(EF_BONEMERGE)
		self:AddEffects(EF_BONEMERGE_FASTCULL)
		self:AddEffects(EF_PARENT_ANIMATES)
	end
end

function ENT:Draw()
	local owner = self:GetOwner()

	if IsValid(owner) then
		if owner:Alive() and !owner:IsDormant() and !owner:IsEffectActive(EF_NODRAW) and owner:ShouldDrawLocalPlayer() then
			local ownerEyeAng = owner:EyeAngles()
			local ownerEyeDir = ownerEyeAng:Forward()
			local eyePos      = self:EyePos()
	
			self:DrawModel()
			self:CreateShadow()
			self:SetEyeTarget(Vector(256, 0, 72))
		else
			self:DestroyShadow()
		end
	end
end

function ENT:Think()
	local owner = self:GetOwner()

	if IsValid(owner) then
		local mdl      = self:GetModel()
		local ownerMdl = owner:GetModel()

		if mdl != ownerMdl then
			self:SetModel(ownerMdl)
		end
	else
		if SERVER then
			self:Remove()
		end
	end

	self:NextThink(CurTime())

	return true
end