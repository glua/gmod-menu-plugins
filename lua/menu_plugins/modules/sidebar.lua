local PANEL = {}

local OUT = true
local IN = false

function PANEL:Init()
	self:SetSize(ScrW()*.175, ScrH()*.75)
	self:Center()
	self:SetPos(ScrW(), select(2, self:GetPos()))

	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetTitle("")

	self.textentry = vgui.Create("DTextEntry", self)
	self.textentry:Dock(BOTTOM)
	self.textentry.OnEnter = function(self2)
		if not self.curoption then return end
		menup.options.setOption(self.curoption[1], self.curoption[2], self2:GetText())
	end

	self.tree = vgui.Create("DTree", self)
	self.tree:Dock(FILL)
	self.tree.OnNodeSelected = function(self2, node)
		local parent = node:GetParentNode()
		if parent == self2:Root() then return end
		self.textentry:SetText(menup.options.getOption(parent:GetText(), node:GetText()))
		self.curoption = {parent:GetText(), node:GetText()}
	end

	self.out = false
	self:KillFocus()

	self.plugins = {}
end

function PANEL:Moove(outin)
	if outin == OUT and not self.out then
		self:MoveTo(ScrW(), select(2, self:GetPos()), .1, 0, 2)
		self.out = true
	elseif outin == IN and self.out then
		self:MoveTo(ScrW() - self:GetWide(), select(2, self:GetPos()), .1, 0, 2)
		self.out = false
	end
end

function PANEL:Think()
	self.posx, self.posy = self:GetPos()
	self.sizex, self.sizey = self:GetSize()
	local mx, my = gui.MouseX(), gui.MouseY()
	self.hovered = mx > self.posx-(self.out and self:GetWide()*.1 or self:GetWide()*.2)

	if self.hovered then
		self:Moove(IN)
	elseif not self.hovered then
		self:Moove(OUT)
	end
end

function PANEL:AddOption(plugin, option, type)
	if not self.plugins[plugin] then
		self.plugins[plugin] = {}
		self.plugins[plugin].options = {}
		self.plugins[plugin].node = self.tree:AddNode(plugin, "icon16/wrench.png")
	end
	self.plugins[plugin].node:AddNode(option, "icon16/information.png")
end

derma.DefineControl("menupSidebar", "Sidebar for Menu Plugins", PANEL, "DFrame")

hook.Add("MenuValid", "MenuP_CreateSidebar", function()
	menup.sidebar = vgui.Create("menupSidebar")
	menup.sidebar:MakePopup()

	for plugin, options in pairs(menup.options.getTable()) do
		for option, _ in pairs(options) do
			menup.sidebar:AddOption(plugin, option)
		end
	end
end)
