GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
local L=GFL_L10N.Text
-- GrimfallLoot v1.3.1：独立 AtlasLoot 式查询界面。
local M,D=GFL_Model,GFL_DB
local UI,refresh,menu,shade,sourceWindow
local state={fp=1,kind=0,tier=0,instance=0,boss=0,diff=0,mode='all',query='',bp=1,lp=1,selected=0,classID=-1,subclassID=-1,slotID=-1,quality=-1,minLevel=nil,maxLevel=nil,stat='',statMin=0,sort='id'}
local function label(parent,x,y,w,h,s)
 local t=parent:CreateFontString(nil,'OVERLAY','GameFontNormalSmall');t:SetPoint('TOPLEFT',x,y);t:SetSize(w,h);t:SetJustifyH('LEFT');t:SetJustifyV('TOP');t:SetText(s or '');return t
end
local function button(parent,x,y,w,h,s,fn)
 local b=CreateFrame('Button',nil,parent,'UIPanelButtonTemplate');b:SetPoint('TOPLEFT',x,y);b:SetSize(w,h);b:SetText(s);b:SetScript('OnClick',fn)
 -- 旧客户端的模板按钮不一定继承父窗口后来设置的层级。
 if parent.GetFrameStrata then b:SetFrameStrata(parent:GetFrameStrata())end
 if parent.GetFrameLevel then b:SetFrameLevel(parent:GetFrameLevel()+5)end
 b:EnableMouse(true)
 parent.GFLButtons=parent.GFLButtons or {};table.insert(parent.GFLButtons,b)
 return b
end
local function solid(f)
 f:SetBackdrop({edgeFile='Interface\\DialogFrame\\UI-DialogBox-Border',edgeSize=24,insets={left=5,right=5,top=5,bottom=5}})
 local bg=f:CreateTexture(nil,'BACKGROUND');bg:SetAllPoints(f);bg:SetTexture(0.025,0.03,0.045,1);f.opaqueBackground=bg
end
local function closeMenu()if menu then menu:Hide()end;if shade then shade:Hide()end end
local function openMenu(owner,options,choose)
 closeMenu()
 if not shade then shade=CreateFrame('Frame',nil,UIParent);shade:SetAllPoints(UIParent);shade:SetFrameStrata('FULLSCREEN_DIALOG');shade:EnableMouse(false)end
 if not menu then
  menu=CreateFrame('Frame',nil,shade);menu:SetFrameStrata('FULLSCREEN_DIALOG');menu:SetFrameLevel(150);menu:EnableMouse(true);menu:EnableMouseWheel(true);solid(menu);menu.rows={}
  for i=1,12 do
   local k=i;menu.rows[i]=button(menu,8,-8-(i-1)*24,266,23,'',function()
    local o=menu.options[menu.offset+k-1];if o then closeMenu();menu.choose(o.value)end
   end)
  end
  menu.count=label(menu,12,-302,258,22,'')
  menu.bar=Grimfall_CreateVirtualScrollbar(menu,278,-10,282,function(v)menu.offset=v;menu.render()end)
  local function wheel(_,delta)menu.offset=math.min(math.max(1,#menu.options-11),math.max(1,menu.offset-delta*3));menu.render()end
  menu:SetScript('OnMouseWheel',wheel)
  for _,b in ipairs(menu.rows)do b:EnableMouseWheel(true);b:SetScript('OnMouseWheel',wheel)end
 end
 menu.options=options;menu.choose=choose;menu.offset=1;menu:SetSize(290,334);menu:ClearAllPoints()
 if owner.rightAnchor then menu:SetPoint('TOPRIGHT',owner,'BOTTOMRIGHT',0,-2)else menu:SetPoint('TOPLEFT',owner,'BOTTOMLEFT',0,-2)end
 menu.render=function()
  for i,b in ipairs(menu.rows)do local o=menu.options[menu.offset+i-1];if o then b:SetText(o.label);b:Show()else b:Hide()end end
  menu.count:SetText(menu.offset..'–'..math.min(#menu.options,menu.offset+11)..' / '..#menu.options..L(' · 滚轮滚动'));menu.bar:Update(menu.offset,math.max(1,#menu.options-11))
 end
 menu.render();shade:Show();menu:Show()
end
local function options(dictionary,first)
 local out={{value=-1,label=first}};local ids={};for id in pairs(dictionary)do ids[#ids+1]=id end;table.sort(ids)
 for _,id in ipairs(ids)do out[#out+1]={value=id,label=dictionary[id]}end;return out
end
local function dropdown(parent,x,y,w,key,getOptions,name)
 local b=button(parent,x,y,w,25,name,function(self)
  openMenu(self,getOptions(),function(v)state[key]=v;if key~='cacheMode'then state.lp=1 end
   if key=='cacheMode'then GFL_Cache:SetMode(v)end
   if key=='instance'then state.boss=0;state.bp=1;state.mode='browse';state.selected=0 end
   if key=='classID'then state.subclassID=-1 end
   if key=='tier' or key=='kind'then state.instance=0;state.boss=0;state.mode='all' end
   refresh()
  end)
 end)
 b.rightAnchor=x>640;b.defaultLabel=name;b.key=key;return b
end
local function field(parent,x,y,w,placeholder)
 local e=CreateFrame('EditBox',nil,parent,'InputBoxTemplate');e:SetPoint('TOPLEFT',x,y);e:SetSize(w,24);e:SetAutoFocus(false);e:SetText(placeholder or '')
 e:SetScript('OnEscapePressed',function(self)self:ClearFocus()end);return e
end
local function tooltipItem(self)
 if not self.item then return end
 local id=self.item;GameTooltip:SetOwner(self,'ANCHOR_RIGHT')
 if not pcall(GameTooltip.SetHyperlink,GameTooltip,'item:'..id..':0:0:0:0:0:0:0')then GameTooltip:SetText(L('物品 ID ')..id)end
 GameTooltip:AddLine(L('指南来源（非已验证掉率）：'),0.4,0.8,1)
 local src=M:Sources(id,0,0,0)
 if #src==0 then GameTooltip:AddLine(L('暂无来源数据'),1,0.7,0.3)end
 for i=1,math.min(3,#src)do GameTooltip:AddLine(src[i],1,1,1,true)end
 GameTooltip:AddLine(L('左键：选中；右键：收藏；Shift点击：发链接；Ctrl点击：试穿'),0.7,0.9,1,true);GameTooltip:Show()
end
local function details()
 if not UI or state.selected==0 then return end
 if not sourceWindow then
  local f=CreateFrame('Frame','GrimfallLootSources',UIParent);sourceWindow=f
  f:SetSize(800,470);f:SetPoint('CENTER');f:SetFrameStrata('FULLSCREEN_DIALOG');f:SetFrameLevel(200);f:EnableMouse(true);solid(f)
  f.title=label(f,22,-20,680,28,'');f.rows={};f.page=1
  f.close=button(f,720,-16,60,25,L('关闭'),function()f:Hide()end)
  if hooksecurefunc and type(CloseSpecialWindows)=='function' then
   pcall(hooksecurefunc,'CloseSpecialWindows',function()if f:IsShown()then f:Hide()end end)
  end
  f.render=function()
   local max=math.max(1,#f.sources-4);f.page=math.max(1,math.min(max,f.page))
   for i,row in ipairs(f.rows)do
    local s=f.sources[f.page+i-1];row.source=s
    if s then row.text:SetText(s.label)else row.text:SetText('')end
   end
   f.pager:SetText(f.page..'–'..math.min(#f.sources,f.page+4)..' / '..#f.sources..L(' 个来源 · 滚轮滚动'));f.bar:Update(f.page,max)
   for _,b in ipairs(f.GFLButtons or {})do
    b:SetFrameStrata(f:GetFrameStrata());b:SetFrameLevel(f:GetFrameLevel()+5);b:EnableMouse(true)
   end
  end
  for i=1,5 do
   local row={};f.rows[i]=row;row.text=label(f,24,-66-(i-1)*68,744,60,'')
  end
  f.bar=Grimfall_CreateVirtualScrollbar(f,782,-65,340,function(v)f.page=v;f.render()end)
  f:EnableMouseWheel(true)
  local function wheel(_,delta)f.page=f.page-delta;f.render()end
  f:SetScript('OnMouseWheel',wheel)
  f.pager=label(f,24,-412,730,24,'')
  label(f,24,-443,744,20,L('来源取自客户端指南；真实掉率未知。未注明难度不推断为全部难度。'))
  UISpecialFrames=UISpecialFrames or {};table.insert(UISpecialFrames,'GrimfallLootSources')
 end
 local name=M:ItemInfo(state.selected);sourceWindow.sources=M:SourceRecords(state.selected);sourceWindow.page=1
 sourceWindow.title:SetText(name..' · ID '..state.selected)
 sourceWindow:Show();sourceWindow.render();UI.details=sourceWindow
end
local function createUI()
 if UI then return end
 UI=CreateFrame('Frame','GrimfallLootFrame',UIParent);UI:SetSize(1230,680);UI:SetPoint('CENTER');UI:SetFrameStrata('DIALOG');UI:EnableMouse(true);UI:SetMovable(true);UI:RegisterForDrag('LeftButton');solid(UI)
 UI:SetScript('OnDragStart',function(self)self:StartMoving()end);UI:SetScript('OnDragStop',function(self)self:StopMovingOrSizing()end)
 UI:SetScript('OnHide',function()closeMenu();if sourceWindow then sourceWindow:Hide()end end)
 label(UI,22,-18,820,28,L('Grimfall 掉落查询 v1.3.1'))
 button(UI,1148,-16,60,25,L('关闭'),function()UI:Hide()end)
 button(UI,960,-16,175,25,GFL_L10N.language=='enUS' and 'Language: English' or '语言：简体中文',function(self)
  closeMenu();GFL_L10N.ShowLanguageDialog()
 end)
 UISpecialFrames=UISpecialFrames or {};table.insert(UISpecialFrames,'GrimfallLootFrame')
 UI.tier=dropdown(UI,20,-52,190,'tier',function()
  local out={{value=0,label=L('所有资料片')}};local ids={};for id in pairs(D.tiers)do ids[#ids+1]=id end;table.sort(ids);for _,id in ipairs(ids)do out[#out+1]={value=id,label=D.tiers[id][2]}end;return out
 end,L('资料片'))
 UI.instance=dropdown(UI,220,-52,318,'instance',function()
  local out={{value=0,label=L('全部副本')}};for _,id in ipairs(M:Instances(state.kind,state.tier))do out[#out+1]={value=id,label=D.instances[id][2]}end;return out
 end,L('副本'))
 UI.diff=dropdown(UI,548,-52,218,'diff',function()
  local out={{value=0,label=L('全部难度')},{value=-1,label=L('未注明难度')}};local ids={};for id in pairs(M.difficulties)do ids[#ids+1]=id end;table.sort(ids)
  for _,id in ipairs(ids)do out[#out+1]={value=id,label=M:DifficultyName(id)}end;return out
 end,L('难度'))
 UI.kind=dropdown(UI,776,-52,182,'kind',function()return {{value=0,label=L('所有副本')},{value=1,label=L('地下城')},{value=2,label=L('团队副本')}}end,L('副本类别'))
 UI.class=dropdown(UI,20,-87,182,'classID',function()return options(M.classNames,L('全部物品类型'))end,L('类型'))
 UI.subclass=dropdown(UI,212,-87,182,'subclassID',function()return options(state.classID==2 and M.weaponNames or state.classID==4 and M.armorNames or {},L('全部子类型'))end,L('子类型'))
 UI.slot=dropdown(UI,404,-87,182,'slotID',function()return options(M.slotNames,L('全部部位'))end,L('部位'))
 UI.quality=dropdown(UI,596,-87,172,'quality',function()return options({[0]=L('粗糙'),[1]=L('普通'),[2]=L('优秀'),[3]=L('精良'),[4]=L('史诗'),[5]=L('传说'),[6]=L('神器'),[7]=L('传家宝')},L('全部品质'))end,L('品质'))
 UI.sort=dropdown(UI,778,-87,180,'sort',function()return {{value='id',label=L('按ID排序')},{value='name',label=L('按名称排序')},{value='level',label=L('按装等从高到低')},{value='quality',label=L('按品质从高到低')},{value='stat',label=L('按所选属性从高到低')}}end,L('排序'))
 UI.search=field(UI,28,-123,306)
 local function search()state.query=UI.search:GetText()or'';state.mode='search';state.lp=1;state.selected=0;UI.search:ClearFocus();refresh()end
 UI.search:SetScript('OnEnterPressed',search);button(UI,344,-123,90,25,L('搜索/反查'),search)
 label(UI,448,-127,42,20,L('装等'));UI.minLevel=field(UI,492,-123,45);label(UI,545,-127,10,20,'–');UI.maxLevel=field(UI,559,-123,45)
 UI.stat=dropdown(UI,618,-123,160,'stat',function()return M.statOptions end,L('属性'))
 label(UI,784,-127,18,20,'≥');UI.statMin=field(UI,805,-123,60,'0')
 local function apply()
  state.minLevel=tonumber(UI.minLevel:GetText());state.maxLevel=tonumber(UI.maxLevel:GetText());state.statMin=tonumber(UI.statMin:GetText())or 0;state.lp=1;refresh()
 end
 UI.minLevel:SetScript('OnEnterPressed',apply);UI.maxLevel:SetScript('OnEnterPressed',apply);UI.statMin:SetScript('OnEnterPressed',apply)
 button(UI,878,-123,80,25,L('应用数值'),apply)
 button(UI,20,-158,120,25,L('全部物品'),function()state.mode='all';state.lp=1;refresh()end)
 button(UI,148,-158,95,25,L('收藏'),function()state.mode='favorites';state.lp=1;refresh()end)
 button(UI,251,-158,95,25,L('副本掉落'),function()state.mode='browse';state.lp=1;refresh()end)
 button(UI,354,-158,115,25,L('清空筛选'),function()
  state.classID=-1;state.subclassID=-1;state.slotID=-1;state.quality=-1;state.minLevel=nil;state.maxLevel=nil;state.stat='';state.statMin=0;state.sort='id';state.diff=0
  UI.minLevel:SetText('');UI.maxLevel:SetText('');UI.statMin:SetText('0');state.lp=1;refresh()
 end)
 UI.cacheButton=button(UI,478,-158,240,25,L('自动缓存'),function()if GFL_Saved.preload.enabled then GFL_Cache:Pause()else GFL_Cache:Start()end;refresh()end)
 UI.speed=dropdown(UI,730,-158,228,'cacheMode',function()return {{value='slow',label=L('慢速：2次/秒')},{value='normal',label=L('普通：5次/秒')},{value='fast',label=L('加速：10次/秒')},{value='turbo',label=L('高速：20次/秒（可能限流）')}}end,L('缓存速度'))
 UI.bossTitle=label(UI,22,-200,210,24,L('首领列表'));UI.lootTitle=label(UI,250,-200,706,24,L('掉落装备'));UI.bb={};UI.lb={}
 UI.bossArea=CreateFrame('Frame',nil,UI);UI.bossArea:SetPoint('TOPLEFT',20,-230);UI.bossArea:SetSize(230,336);UI.bossArea:EnableMouseWheel(true)
 UI.itemArea=CreateFrame('Frame',nil,UI);UI.itemArea:SetPoint('TOPLEFT',250,-229);UI.itemArea:SetSize(728,336);UI.itemArea:EnableMouseWheel(true)
 local function bossWheel(_,delta)state.bp=state.bp-delta*3;refresh()end
 local function itemWheel(_,delta)state.lp=state.lp-delta*3;refresh()end
 UI.bossArea:SetScript('OnMouseWheel',bossWheel);UI.itemArea:SetScript('OnMouseWheel',itemWheel)
 UI.bossBar=Grimfall_CreateVirtualScrollbar(UI.bossArea,216,0,330,function(v)state.bp=v;refresh()end)
 UI.itemBar=Grimfall_CreateVirtualScrollbar(UI.itemArea,714,0,330,function(v)state.lp=v;refresh()end)
 for i=1,12 do
  UI.bb[i]=button(UI.bossArea,0,-(i-1)*28,208,25,'',function(self)state.boss=self.id;state.mode='browse';state.lp=1;state.selected=0;refresh()end)
  UI.bb[i]:EnableMouseWheel(true);UI.bb[i]:SetScript('OnMouseWheel',bossWheel)
 end
 for i=1,16 do
  local column=math.floor((i-1)/8);local row=(i-1)%8
  local b=CreateFrame('Button',nil,UI.itemArea);b:SetPoint('TOPLEFT',column*358,-row*42);b:SetSize(348,40);b:SetHighlightTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight');b:RegisterForClicks('LeftButtonUp','RightButtonUp')
  b:EnableMouseWheel(true);b:SetScript('OnMouseWheel',itemWheel)
  b:SetFrameStrata(UI:GetFrameStrata());b:SetFrameLevel(UI.itemArea:GetFrameLevel()+5)
  b.icon=b:CreateTexture(nil,'ARTWORK');b.icon:SetSize(34,34);b.icon:SetPoint('LEFT',0,0)
  b.label=label(b,40,-1,258,20,'');b.meta=label(b,40,-21,303,17,'');b.number=label(b,296,-1,50,18,'')
  b:SetScript('OnEnter',tooltipItem);b:SetScript('OnLeave',function()GameTooltip:Hide()end)
  b:SetScript('OnClick',function(self,key)
   local id=self.item;if not id then return end
   if key=='RightButton'then if GFL_Saved.favorites[id]then GFL_Saved.favorites[id]=nil else GFL_Saved.favorites[id]=true end;refresh()
   elseif IsShiftKeyDown() and ChatEdit_InsertLink then ChatEdit_InsertLink(M:Link(id))
   elseif IsControlKeyDown() and DressUpItemLink then DressUpItemLink(M:Link(id))
   else state.selected=id;refresh()end
  end);UI.lb[i]=b
 end
 UI.bp=label(UI,22,-574,216,20,'');UI.lp=label(UI,250,-574,700,20,'')
 UI.selection=label(UI,22,-610,754,32,'');button(UI,800,-607,158,28,L('来源详情'),details)
 UI.foot=label(UI,22,-651,934,20,'')
 -- 独立收藏栏不受主列表的副本/品质/数值筛选影响。
 local divider=UI:CreateTexture(nil,'OVERLAY');divider:SetPoint('TOPLEFT',984,-14);divider:SetSize(1,650);divider:SetTexture(0.25,0.25,0.3,1)
 UI.favoriteTitle=label(UI,1000,-21,140,24,L('收藏装备'))
 UI.favoriteArea=CreateFrame('Frame',nil,UI);UI.favoriteArea:SetPoint('TOPLEFT',998,-62);UI.favoriteArea:SetSize(220,546);UI.favoriteArea:EnableMouseWheel(true)
 UI.fb={}
 local function favoriteWheel(_,delta)state.fp=state.fp-delta*3;refresh()end
 UI.favoriteArea:SetScript('OnMouseWheel',favoriteWheel)
 UI.favoriteBar=Grimfall_CreateVirtualScrollbar(UI.favoriteArea,208,0,542,function(v)state.fp=v;refresh()end)
 for i=1,13 do
  local b=CreateFrame('Button',nil,UI.favoriteArea);b:SetPoint('TOPLEFT',0,-(i-1)*42);b:SetSize(202,40);b:RegisterForClicks('LeftButtonUp','RightButtonUp');b:SetHighlightTexture('Interface\\QuestFrame\\UI-QuestTitleHighlight')
  b:SetFrameStrata(UI:GetFrameStrata());b:SetFrameLevel(UI.favoriteArea:GetFrameLevel()+5)
  b.icon=b:CreateTexture(nil,'ARTWORK');b.icon:SetSize(28,28);b.icon:SetPoint('LEFT',0,0)
  b.label=label(b,34,-1,164,20,'');b.meta=label(b,34,-21,164,17,'')
  b:SetScript('OnEnter',tooltipItem);b:SetScript('OnLeave',function()GameTooltip:Hide()end);b:EnableMouseWheel(true);b:SetScript('OnMouseWheel',favoriteWheel)
  b:SetScript('OnClick',function(self,key)
   local id=self.item;if not id then return end
   if key=='RightButton'then GFL_Saved.favorites[id]=nil;refresh()
   elseif IsShiftKeyDown()and ChatEdit_InsertLink then ChatEdit_InsertLink(M:Link(id))
   elseif IsControlKeyDown()and DressUpItemLink then DressUpItemLink(M:Link(id))
   else state.selected=id;refresh();details()end
  end);UI.fb[i]=b
 end
 UI.favoriteEmpty=label(UI,1000,-84,196,65,L('右键装备加入收藏。\n这里独立显示全部收藏。'))
 UI.favoriteCount=label(UI,998,-623,218,32,'');label(UI,998,-654,218,18,L('滚轮向下 · 右键取消收藏'))
 if UI.SetClampedToScreen then UI:SetClampedToScreen(true)end
 if UIParent.GetWidth and UIParent.GetHeight and UI.SetScale then UI:SetScale(math.min(1,(UIParent:GetWidth()-20)/1230,(UIParent:GetHeight()-20)/680))end
 local elapsedTotal=0
 local function progress()
  UI.cacheButton:SetText(L('缓存：')..GFL_Cache:StatusText())
  UI.speed:SetText(L('缓存速度：')..GFL_Cache:GetRate()..L('次/秒 ▼'))
 end
 GFL_Cache.onChanged=progress;progress()
 UI:SetScript('OnUpdate',function(_,elapsed)
  progress();elapsedTotal=elapsedTotal+elapsed
  if elapsedTotal>=2 then elapsedTotal=0;local ok,err=pcall(refresh);if not ok then GFL_Saved.preload.lastUIError=tostring(err)end end
 end)
 UI:Hide()
end
local function offset(p,maximum)return math.min(math.max(1,p),math.max(1,maximum))end
refresh=function()
 if not UI then return end
 local bosses={0};for _,id in ipairs(M:Bosses(state.instance))do bosses[#bosses+1]=id end
 state.bp=offset(state.bp,#bosses-11);UI.bp:SetText(state.bp..'–'..math.min(#bosses,state.bp+11)..' / '..#bosses);UI.bossBar:Update(state.bp,#bosses-11)
 for i,b in ipairs(UI.bb)do local id=bosses[state.bp+i-1];b.id=id
  if id~=nil then b:SetText((state.boss==id and '> 'or'')..(id==0 and L('全部首领')or D.encounters[id][2]));b:Show()else b:Hide()end
 end
 local list
 if state.mode=='favorites'then list=M:Favorites()
 elseif state.mode=='search'then list=M:Find(state.query)
 elseif state.mode=='browse' and state.instance~=0 then list=M:Loot(state.instance,state.boss,state.diff)
 else list=M.itemList end
 if state.mode~='browse' and state.diff~=0 then local out={};for _,id in ipairs(list)do for _,r in ipairs(M.byItem[id]or{})do if M:MatchDifficulty(r,state.diff)then out[#out+1]=id;break end end end;list=out end
 list=M:ApplyFilters(list,state);state.lp=offset(state.lp,math.ceil(#list/2)-7);UI.itemBar:Update(state.lp,math.ceil(#list/2)-7)
 UI.lp:SetText((#list==0 and 0 or(state.lp-1)*2+1)..'–'..math.min(#list,(state.lp-1)*2+16)..' / '..#list..L(' 个物品 · 滚轮滚动'))
 UI.lootTitle:SetText(state.mode=='browse'and(state.instance~=0 and D.instances[state.instance][2]or L('全部副本'))or state.mode=='search'and L('搜索/反查结果')or state.mode=='favorites'and L('收藏装备')or L('全部指南物品'))
 local visible={}
 for i,b in ipairs(UI.lb)do local id=list[(state.lp-1)*2+((i-1)%8)*2+math.floor((i-1)/8)+1];b.item=id
  if id then
   visible[#visible+1]=id;local name,c=M:ItemInfo(id);b.label:SetText((GFL_Saved.favorites[id]and'* 'or'')..name)
   local color=ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[c.quality or 1];if color then b.label:SetTextColor(color.r,color.g,color.b)else b.label:SetTextColor(1,1,1)end
   b.meta:SetText(M:Description(id)..(state.stat~=''and c.stats and type(c.stats[state.stat])=='number'and(' · '..M:StatName(state.stat)..' '..c.stats[state.stat])or''))
   b.number:SetText(id);b.icon:SetTexture(c.icon or'Interface\\Icons\\INV_Misc_QuestionMark');b:Show()
  else b:Hide()end
 end
 local favorites=M:Favorites();state.fp=offset(state.fp,#favorites-12);UI.favoriteBar:Update(state.fp,#favorites-12);UI.favoriteTitle:SetText(L('收藏装备 (')..#favorites..')')
 UI.favoriteCount:SetText((#favorites==0 and 0 or state.fp)..'–'..math.min(#favorites,state.fp+12)..' / '..#favorites..L(' 个收藏'))
 if #favorites==0 then UI.favoriteEmpty:Show()else UI.favoriteEmpty:Hide()end
 for i,b in ipairs(UI.fb)do local id=favorites[state.fp+i-1];b.item=id
  if id then
   visible[#visible+1]=id;local name,c=M:ItemInfo(id);b.label:SetText(name);b.meta:SetText('ID '..id..(c.level and(L(' · 装等 ')..c.level)or''));b.icon:SetTexture(c.icon or'Interface\\Icons\\INV_Misc_QuestionMark')
   local color=ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[c.quality or 1];if color then b.label:SetTextColor(color.r,color.g,color.b)else b.label:SetTextColor(1,1,1)end;b:Show()
  else b:Hide()end
 end
 GFL_Cache:Prioritize(visible);UI.cacheButton:SetText(L('缓存：')..GFL_Cache:StatusText());UI.speed:SetText(L('缓存速度：')..GFL_Cache:GetRate()..L('次/秒 ▼'))
 UI.tier:SetText((state.tier==0 and L('所有资料片')or D.tiers[state.tier][2])..' ▼');UI.instance:SetText((state.instance==0 and L('全部副本')or D.instances[state.instance][2])..' ▼')
 UI.diff:SetText(M:DifficultyName(state.diff)..' ▼');UI.kind:SetText((state.kind==0 and L('所有副本')or state.kind==1 and L('地下城')or L('团队副本'))..' ▼')
 UI.class:SetText((state.classID==-1 and L('全部类型')or M.classNames[state.classID]or L('类型'))..' ▼')
 UI.subclass:SetText((state.subclassID==-1 and L('全部子类型')or(state.classID==2 and M.weaponNames[state.subclassID]or M.armorNames[state.subclassID])or L('子类型'))..' ▼')
 UI.slot:SetText((state.slotID==-1 and L('全部部位')or M.slotNames[state.slotID])..' ▼')
 local qualityNames={[0]=L('粗糙'),[1]=L('普通'),[2]=L('优秀'),[3]=L('精良'),[4]=L('史诗'),[5]=L('传说'),[6]=L('神器'),[7]=L('传家宝')}
 UI.quality:SetText((state.quality==-1 and L('全部品质')or qualityNames[state.quality])..' ▼')
 local sortNames={id=L('按ID排序'),name=L('按名称排序'),level=L('装等从高到低'),quality=L('品质从高到低'),stat=L('属性从高到低')};UI.sort:SetText(sortNames[state.sort]..' ▼');UI.stat:SetText(M:StatName(state.stat)..' ▼')
 if state.selected~=0 then local src=M:Sources(state.selected,0,0,0);UI.selection:SetText('ID '..state.selected..'：'..(src[1]or L('暂无指南来源'))..(#src>1 and L('（更多来源见详情）')or''))
 elseif #list==0 then UI.selection:SetText(L('暂无符合结果。未缓存类型/数值不参与对应筛选，可等待缓存或清空筛选。'))
 else UI.selection:SetText(L('选中装备后查看来源；右键收藏，Shift点击发链接，Ctrl点击试穿。'))end
 UI.foot:SetText(L('18,613 个指南物品ID · 来源不保证实际掉落 · 未返回 ')..GFL_Cache.failedCount..L(' · 已处理 ')..(GFL_Cache.cached+GFL_Cache.failedCount)..'/18613'..L(' · 缓存成功 ')..GFL_Cache.cached)
end
local function toggle()createUI();if UI:IsShown()then UI:Hide()else UI:Show();refresh()end end
SLASH_GFL1='/gfl';SLASH_GFL2='/grimfallloot';SlashCmdList.GFL=function(msg)
 msg=(msg or''):gsub('^%s+',''):gsub('%s+$','')
 if msg=='close' or msg==L('关闭') then
  closeMenu();if sourceWindow then sourceWindow:Hide()end;if UI then UI:Hide()end
 elseif msg:match('^cache')then
  local action=msg:match('^cache%s+(%S+)')
  if action=='start'or action=='on'then GFL_Cache:Start()elseif action=='stop'or action=='off'then GFL_Cache:Pause()elseif action=='retry'then GFL_Cache:Status()elseif action=='slow'then GFL_Cache:SetMode('slow')elseif action=='normal'then GFL_Cache:SetMode('normal')elseif action=='fast'then GFL_Cache:SetMode('fast')elseif action=='turbo'then GFL_Cache:SetMode('turbo')else GFL_Cache:Status()end
  if UI then refresh()end
 elseif msg=='status'then print(L('GrimfallLoot v1.3.1：207 个掉落副本，1126 位首领，18613 个物品ID。'));GFL_Cache:Status()
 else createUI();if msg~=''then UI.search:SetText(msg);state.query=msg;state.mode='search';state.lp=1;state.selected=0;UI:Show();refresh()else toggle()end end
end
local entry=CreateFrame('Frame');entry:RegisterEvent('PLAYER_LOGIN');entry:SetScript('OnEvent',function()
 if entry.button then return end
 entry.button=Grimfall_CreateMinimapButton('GrimfallLootMinimap','Interface\\Icons\\INV_Misc_TreasureChest01',L('Grimfall 掉落查询'),L('装备查询、收藏和自动缓存。'),GFL_Saved.minimap,toggle,function(fallback)
  if fallback then SlashCmdList.GFL('status');return end
  return {{text=L('Grimfall 掉落查询'),isTitle=true,notCheckable=true},{text=L('打开窗口'),notCheckable=true,func=toggle},{text=L('暂停/继续缓存'),notCheckable=true,func=function()if GFL_Saved.preload.enabled then GFL_Cache:Pause()else GFL_Cache:Start()end end},{text=L('缓存进度'),notCheckable=true,func=function()GFL_Cache:Status()end}}
 end)
end)

end
