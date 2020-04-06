local Player = FindMetaTable "Player"

--[[
	Name: Player:GetVisualModelEntity
	Desc: Returns the player's visual model entity.

	Returns

	[1] Entity - Visual model entity.
]]
function Player:GetVisualModelEntity()
	return self.visualModelEnt or NULL
end

--[[
	Name: Player:CreateVisualModelEntity
	Desc: (Re)creates the player's visual model entity.
]]
function Player:CreateVisualModelEntity()
	local ent = self:GetVisualModelEntity()
	local mdl = self:GetModel()

	if IsValid(ent) then
		ent:Remove()
	end

	ent = ClientsideModel(mdl)

	if IsValid(ent) then
		ent:SetModel(mdl)
		ent:SetParent(self)
		ent:SetOwner(self)
		ent:SetLocalPos(Vector())
		ent:SetLocalAngles(Angle())
		ent:AddEffects(EF_BONEMERGE)
		ent:AddEffects(EF_BONEMERGE_FASTCULL)
		ent:AddEffects(EF_PARENT_ANIMATES)
		ent:Spawn()

		hook.Add("Think", ent, function(this)
			if !IsValid(self) or self:IsDormant() or this:GetModel() != self:GetModel() then
				this:Remove()
			end
		end)
	end

	self.visualModelEnt = ent
end

hook.Add("PrePlayerDraw", "skelemation", function(pl)
	local ent = pl:GetVisualModelEntity()

	if !IsValid(ent) then
		pl:CreateVisualModelEntity()
	end
end)