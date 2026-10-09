GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
-- 无箭头垂直滚动条：固定数量可见行，滚动位置交给调用方。
function Grimfall_CreateVirtualScrollbar(parent,x,y,height,onChanged)
 local b=CreateFrame('Slider',nil,parent)
 b:SetPoint('TOPLEFT',x,y);b:SetSize(10,height);b:SetOrientation('VERTICAL');b:SetValueStep(1)
 if parent.GetFrameStrata then b:SetFrameStrata(parent:GetFrameStrata())end
 if parent.GetFrameLevel then b:SetFrameLevel(parent:GetFrameLevel()+8)end
 b:EnableMouse(true);b:EnableMouseWheel(true)
 local bg=b:CreateTexture(nil,'BACKGROUND');bg:SetAllPoints(b);bg:SetTexture(0.13,0.15,0.18,1)
 b:SetThumbTexture('Interface\\Buttons\\WHITE8X8')
 if b.GetThumbTexture then local t=b:GetThumbTexture();if t then t:SetSize(10,28);t:SetVertexColor(0.82,0.68,0.25,1)end end
 b.minimum=1;b.maximum=1;b.updating=false
 b:SetScript('OnValueChanged',function(self,v)
  if not self.updating and type(v)=='number'then onChanged(math.max(self.minimum,math.min(self.maximum,math.floor(v+0.5))))end
 end)
 b:SetScript('OnMouseWheel',function(self,delta)
  local v=self.GetValue and self:GetValue()or self.current or 1
  onChanged(math.max(self.minimum,math.min(self.maximum,v-delta*3)))
 end)
 function b:Update(position,maximum)
  self.updating=true;self.minimum=1;self.maximum=math.max(1,maximum or 1);self.current=math.max(1,math.min(self.maximum,position or 1))
  self:SetMinMaxValues(1,self.maximum);self:SetValue(self.current);self.updating=false
  if self.maximum>1 then self:Show()else self:Hide()end
 end
 b:Update(1,1);return b
end

end
