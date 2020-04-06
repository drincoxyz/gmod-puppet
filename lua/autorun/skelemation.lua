local Player = FindMetaTable "Player"
local Entity = FindMetaTable "Entity"

Player._SetModel = Player._SetModel or Entity.SetModel
Player._GetModel = Player._GetModel or Entity.GetModel

function Player:SetModel(mdl)
	self:SetNW2String("visualModel", mdl)
end

function Player:GetModel()
	return self:GetNW2String "visualModel"
end

--[[
	Name: Player:SetAnimationModel
	Desc: Sets the player's animation model.

	Arguments

	[1] string - Animation model.
]]
function Player:SetAnimationModel(mdl)
	self:_SetModel(mdl)
end

--[[
	Name: Player:UpdateActivityList
	Desc: Updates the player's activity list.
]]
function Player:UpdateActivityList()
	local acts   = {}
	local lookup = {}

	for seqID, seqName in pairs(self:GetSequenceList()) do
		local actID = self:GetSequenceActivity(seqID)

		if actID > 0 then
			local actName = self:GetSequenceActivityName(seqID)
			
			acts[actID]     = actName
			lookup[actName] = actID
		end
	end

	self.activityList   = acts
	self.activityLookup = lookup
end

--[[
	Name: Player:GetActivityList
	Desc: Returns a list of all available activities the player can use.

	Returns

	[1] table - Activities.
]]
function Player:GetActivityList()
	return self.activityList or {}
end

--[[
	Name: Player:GetActivityLookup
	Desc: Returns a lookup table for the player's activity list.

	Returns

	[1] table - Activity lookup.
]]
function Player:GetActivityLookup()
	return self.activityLookup or {}
end

--[[
	Name: Player:LookupActivity
	Desc: Translates an activity name into an ID.

	Arguments

	[1] string - Activity name.

	Returns

	[1] number - Activity ID.
]]
function Player:LookupActivity(actName)
	return self:GetActivityLookup()[actName] or -1
end

--[[
	Name: Player:GetAnimationModel
	Desc: Returns the player's animation model.

	Returns

	[1] string - Animation model.
]]
function Player:GetAnimationModel()
	return self:_GetModel()
end

--[[
	Name: Player:GetLastAnimationModel
	Desc: Returns the player's last animation model.

	Returns

	[1] string - Last animation model.
]]
function Player:GetLastAnimationModel()
	return self.lastAnimMdl
end

--[[
	Name: Player:SetLastAnimationModel
	Desc: Sets the player's last animation model.

	Arguments

	[1] string - Last animation model.
]]
function Player:SetLastAnimationModel(anim)
	self.lastAnimMdl = anim
end

hook.Add("UpdateAnimation", "skelemation", function(pl)
	local anim     = pl:GetAnimationModel()
	local lastAnim = pl:GetLastAnimationModel()

	if anim != lastAnim then
		pl:UpdateActivityList()
		pl:SetLastAnimationModel(anim)
	end
end)