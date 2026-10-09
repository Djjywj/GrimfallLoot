GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
local L=GFL_L10N.Text
-- 小地图按钮组件，使用游戏内置材质，不依赖其他插件。
local function create(name, icon, title, description, settings, click, menu)
 if not Minimap then return end
 settings.angle=settings.angle or 220
 local b=CreateFrame('Button',name,Minimap)
 b:SetSize(32,32);b:SetFrameStrata('MEDIUM');b:SetFrameLevel(Minimap:GetFrameLevel()+8)
 b:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
 local tex=b:CreateTexture(nil,'BACKGROUND');tex:SetTexture(icon);tex:SetSize(20,20);tex:SetPoint('CENTER',0,1)
 local border=b:CreateTexture(nil,'OVERLAY');border:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder');border:SetSize(54,54);border:SetPoint('TOPLEFT',0,0)
 b:RegisterForClicks('LeftButtonUp','RightButtonUp');b:RegisterForDrag('LeftButton')
 local function position()
  local rad=math.rad(settings.angle)
  b:ClearAllPoints();b:SetPoint('CENTER',Minimap,'CENTER',math.cos(rad)*82,math.sin(rad)*82)
 end
 position()
 b:SetScript('OnDragStart',function(self)
  self:SetScript('OnUpdate',function()
   local x,y=GetCursorPosition();local cx,cy=Minimap:GetCenter();local scale=Minimap:GetEffectiveScale()
   if cx and cy then settings.angle=math.deg(math.atan2(y/scale-cy,x/scale-cx));position() end
  end)
 end)
 b:SetScript('OnDragStop',function(self)self:SetScript('OnUpdate',nil)end)
 b:SetScript('OnClick',function(self,button)
  if button=='RightButton' and menu then
   if EasyMenu then
    self.dropdown=self.dropdown or CreateFrame('Frame',name..'Menu',UIParent,'UIDropDownMenuTemplate')
    EasyMenu(menu(),self.dropdown,'cursor',0,0,'MENU')
   else menu(true) end
  else click() end
 end)
 b:SetScript('OnEnter',function(self)
  GameTooltip:SetOwner(self,'ANCHOR_LEFT');GameTooltip:SetText(title)
  GameTooltip:AddLine(description,1,1,1,true)
  GameTooltip:AddLine(L('左键：打开  |  右键：菜单'),0.65,0.8,1)
  GameTooltip:AddLine(L('按住左键拖动：调整位置'),0.65,0.8,1);GameTooltip:Show()
 end)
 b:SetScript('OnLeave',function()GameTooltip:Hide()end)
 return b
end
Grimfall_CreateMinimapButton=create

end
