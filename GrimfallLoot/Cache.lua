GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
local L=GFL_L10N.Text
-- v1.3.1：进度独立通知，缓存完成/本轮结束持久保存。
GFL_Saved.preload=GFL_Saved.preload or {}
local S=GFL_Saved.preload
if S.enabled==nil then S.enabled=true end
S.failed=S.failed or {};S.mode=S.mode or 'normal'
local M=GFL_Model
local W={known={},cached=0,failedCount=0,pending={},priority={},priorityHead=1,queued={},cursor=1,finished=false,started=false,requested=0,total=#M.itemList,reconcileCursor=1}
local rates={slow=2,normal=5,fast=10,turbo=20}
GFL_Cache=W
function W:GetRate()return rates[S.mode]or 5 end
function W:PendingLimit()return math.min(32,math.max(12,self:GetRate()*2))end
local function ready(id)
 local c=GFL_Saved.cache[id]
 return type(c)=='table'and type(c.name)=='string'and c.name~=''and c.icon~=nil
end
local function say(t)print(L('|cff66bbffGrimfall自动缓存|r ')..t)end
local function now()return GetTime and GetTime()or W.time or 0 end
function W:Notify()
 S.cached=self.cached;S.total=self.total;S.failedCount=self.failedCount;S.processed=self.cached+self.failedCount
 if type(self.onChanged)=='function'then pcall(self.onChanged,self)end
end
local function finish(complete,announce)
 local wasComplete=S.completed==true
 W.finished=true;S.completed=complete;S.roundEnded=true;S.processingComplete=true;S.enabled=false
 W.pending={};W.priority={};W.priorityHead=1;W.queued={}
 if complete then S.failed={};W.failedCount=0 end
 W:Notify()
 if announce then
  if complete and not wasComplete then say(L('已完成全部缓存：')..W.cached..'/'..W.total..L('。自动缓存已停止；/reload或正常退出后保存，下次登录不再请求。'))
  elseif not complete then say(L('已完成处理：')..(W.cached+W.failedCount)..'/'..W.total..L('；缓存成功 ')..W.cached..L('，未返回 ')..W.failedCount..L('。已停止，不再重试。'))end
 end
end
-- 登录只核对已保存表，不向服务器取信息；不能只相信旧完成标记。
for _,id in ipairs(M.itemList)do
 if ready(id)then W.known[id]=true;W.cached=W.cached+1;S.failed[id]=nil
 elseif S.failed[id]then W.failedCount=W.failedCount+1 end
end
if W.cached==W.total then finish(true,false)
elseif W.cached+W.failedCount==W.total then finish(false,false)
else S.completed=false;S.roundEnded=false;S.processingComplete=false;W:Notify()end
function W:Observe(id)
 if not ready(id)then return false end
 local changed=false
 if M.byItem[id]and not self.known[id]then self.known[id]=true;self.cached=self.cached+1;changed=true end
 if S.failed[id]then S.failed[id]=nil;if M.byItem[id]then self.failedCount=math.max(0,self.failedCount-1);changed=true end end
 self.pending[id]=nil
 if self.cached==self.total then finish(true,not self.finished or not S.completed)
 elseif changed then self:Notify()end
 return true
end
-- 兼容别的插件/旧接口直接更新保存表：分批核对，只看本地表，不额外查询。
function W:Reconcile(limit)
 for _=1,limit or 256 do
  local id=M.itemList[self.reconcileCursor]
  if not id then self.reconcileCursor=1;return end
  self.reconcileCursor=self.reconcileCursor+1
  if ready(id)and not self.known[id]then self:Observe(id)end
 end
end
local function read(id)
 if ready(id)then return W:Observe(id)end
 local ok,err=pcall(M.ItemInfo,M,id)
 if not ok then S.lastReadError=tostring(err)end
 return W:Observe(id)
end
local function eligible(id)return id and not ready(id)and not S.failed[id]and not W.pending[id]and not W.queued[id]end
function W:Prioritize(ids)
 if not S.enabled or self.finished then return end
 for _,id in ipairs(ids)do if eligible(id)then self.priority[#self.priority+1]=id;self.queued[id]=true end end
end
local function markFailed(id,reason)
 if not S.failed[id]and M.byItem[id]then W.failedCount=W.failedCount+1 end
 S.failed[id]=reason or L('未返回');W.pending[id]=nil;W:Notify()
end
function W:Start()
 if self.cached==self.total then finish(true,false);say(L('已完成全部缓存，无需再读取。'));return end
 if self.cached+self.failedCount==self.total then finish(false,false);say(L('已完成处理，不再重试未返回物品。'));return end
 S.enabled=true;S.roundEnded=false;S.completed=false;self.started=true;self.finished=false
 if self.cursor>#M.itemList then self.cursor=1 end
 self:Notify();say(L('已开启：只请求还没有缓存、也没有失败记录的物品。'))
end
function W:Pause()S.enabled=false;self:Notify();say(L('已暂停新请求，已发出的回复仍会保存。'))end
function W:SetMode(mode)
 S.mode=rates[mode]and mode or 'normal';self:Notify();say(L('每秒最多 ')..self:GetRate()..L(' 次请求。'))
 if self:GetRate()>5 then say(L('高速可能卡顿、限流或断线；异常时请降速。'))end
end
function W:StatusText()
 local processed=math.min(self.total,self.cached+self.failedCount)
 if self.finished then return L('处理完成 ')..processed..'/'..self.total end
 local label=not S.enabled and L('暂停')or(InCombatLockdown and InCombatLockdown())and L('战斗暂停')or L('处理中')
 return label..' '..processed..'/'..self.total
end
function W:Status()
 local n=0;for _ in pairs(self.pending)do n=n+1 end
 say(self:StatusText()..L('；缓存成功 ')..self.cached..L('；等待 ')..n..L('；未返回 ')..self.failedCount..L('；本次发出 ')..self.requested..L(' 次请求。'))
end
local function nextID()
 while W.priorityHead<=#W.priority do
  local id=W.priority[W.priorityHead];W.priorityHead=W.priorityHead+1;W.queued[id]=nil
  if not ready(id)and not S.failed[id]and not W.pending[id]then return id end
 end
 W.priority={};W.priorityHead=1
 for _=1,80 do
  local id=M.itemList[W.cursor];if not id then return nil end
  W.cursor=W.cursor+1
  if not ready(id)and not S.failed[id]and not W.pending[id]then return id end
 end
end
local tooltip
local function request(id)
 if C_Item and type(C_Item.RequestLoadItemDataByID)=='function'then
  local ok,result=pcall(C_Item.RequestLoadItemDataByID,id);if ok and result~=false then return true end
 end
 if not tooltip then tooltip=CreateFrame('GameTooltip','GrimfallLootQueryTooltip',UIParent,'GameTooltipTemplate')end
 if not tooltip or not tooltip.SetHyperlink then return false,L('客户端没有可用物品查询接口')end
 local ok,err=pcall(function()
  tooltip:SetOwner(UIParent,'ANCHOR_NONE');if tooltip.ClearLines then tooltip:ClearLines()end
  tooltip:SetHyperlink('item:'..id..':0:0:0:0:0:0:0');tooltip:Hide()
 end)
 if not ok then pcall(tooltip.Hide,tooltip);return false,tostring(err)end
 return true
end
local frame=CreateFrame('Frame');W.frame=frame
frame:RegisterEvent('PLAYER_LOGIN');pcall(frame.RegisterEvent,frame,'GET_ITEM_INFO_RECEIVED')
frame:SetScript('OnEvent',function(_,event,id)
 if event=='PLAYER_LOGIN'then W.loginWait=3
 elseif event=='GET_ITEM_INFO_RECEIVED'and type(id)=='number'then read(id)end
end)
local acc,progressAcc=0,0
frame:SetScript('OnUpdate',function(_,elapsed)
 W.time=(W.time or 0)+elapsed;progressAcc=progressAcc+elapsed
 if progressAcc>=0.25 then progressAcc=0;W:Reconcile(256);W:Notify()end
 if W.loginWait then
  W.loginWait=W.loginWait-elapsed;if W.loginWait>0 then return end
  W.loginWait=nil;W.started=true
  if S.completed then say(L('已完成全部缓存：')..W.cached..'/'..W.total..L('，本次登录不再请求。'))
  elseif W.finished then say(L('使用已保存缓存：')..W.cached..'/'..W.total..L('，未返回 ')..W.failedCount..L('；不会自动重新请求。'))
  elseif S.enabled then say(L('继续缓存尚未读取的物品；输入 /gfl cache 查看进度。'))end
 end
 if not W.started then return end
 acc=acc+elapsed;local interval=1/W:GetRate();if acc<interval then return end;acc=0
 -- 完成状态不再遍历/启动查询；只有本地计数通知仍工作。
 if W.finished and not next(W.pending)then return end
 for id,sent in pairs(W.pending)do if not read(id)and now()-sent>=6 then markFailed(id,L('未返回；跳过，不重试'))end end
 if W.cached==W.total then finish(true,false);return end
 local n=0;for _ in pairs(W.pending)do n=n+1 end
 if W.cursor>#M.itemList and W.priorityHead>#W.priority and n==0 then finish(false,true);return end
 if not S.enabled or(InCombatLockdown and InCombatLockdown())or n>=W:PendingLimit()then return end
 local id=nextID()
 if id and not read(id)then
  local ok,err=request(id);W.requested=W.requested+1
  if ok then if not read(id)then W.pending[id]=now()end
  else markFailed(id,err);if tostring(err):find(L('没有可用'),1,true)then S.enabled=false;say(L('查询接口不可用，已暂停。'))end end
 elseif not id and W.cursor>#M.itemList and W.priorityHead>#W.priority and n==0 then finish(false,true)end
end)

end
