GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
local L=GFL_L10N.Text
-- 独立掉落查询模型；所有来源均来自用户客户端的指南数据。
GFL_Saved=GFL_Saved or {};GFL_Saved.cache=GFL_Saved.cache or {};GFL_Saved.favorites=GFL_Saved.favorites or {}
GFL_Saved.minimap=GFL_Saved.minimap or {angle=250}
local D=GFL_DB
local M={byBoss={},byItem={},instanceList={},itemList={},difficulties={}}
GFL_Model=M
local difficultyNames={[1]=L('普通地下城'),[2]=L('英雄地下城'),[3]=L('10人普通'),[4]=L('25人普通'),[5]=L('10人英雄'),[6]=L('25人英雄'),[7]=L('团队查找器'),[8]=L('史诗钥石'),[14]=L('普通团队'),[15]=L('英雄团队'),[16]=L('史诗团队'),[17]=L('团队查找器'),[23]=L('史诗地下城'),[24]=L('时空漫游地下城'),[33]=L('时空漫游团队')}
function M:DifficultyName(id)
 if id==0 then return L('全部难度') end
 if id==-1 then return L('未注明难度') end
 return (difficultyNames[id] or L('难度'))..' [ID '..id..']'
end
function M:DiffText(ds)
 if not ds or #ds==0 then return L('未注明难度') end
 local out={};for _,id in ipairs(ds) do out[#out+1]=self:DifficultyName(id) end
 return table.concat(out,' / ')
end
function M:MatchDifficulty(r,id)
 if id==0 then return true end
 if id==-1 then return #r[4]==0 end
 for _,v in ipairs(r[4]) do if v==id then return true end end
 return false
end
local seenItems,activeInst={},{}
for _,r in ipairs(D.records) do
 M.byBoss[r[2]]=M.byBoss[r[2]] or {};table.insert(M.byBoss[r[2]],r)
 M.byItem[r[3]]=M.byItem[r[3]] or {};table.insert(M.byItem[r[3]],r)
 if not seenItems[r[3]] then seenItems[r[3]]=true;M.itemList[#M.itemList+1]=r[3] end
 for _,id in ipairs(r[4]) do M.difficulties[id]=true end
 activeInst[D.encounters[r[2]][3]]=true
end
for id in pairs(activeInst) do if D.instances[id] then M.instanceList[#M.instanceList+1]=id end end
table.sort(M.itemList);table.sort(M.instanceList,function(a,b)return D.instances[a][2]<D.instances[b][2] end)
function M:Instances(kind,tier)
 local result={}
 for _,id in ipairs(self.instanceList) do
  local x=D.instances[id];local yes=tier==0
  for _,v in ipairs(x[5]) do if v==tier then yes=true end end
  if yes and (kind==0 or x[4]==kind) then result[#result+1]=id end
 end
 return result
end
function M:Bosses(instance)
 local result={}
 for id,x in pairs(D.encounters) do if x[3]==instance and self.byBoss[id] then result[#result+1]=id end end
 table.sort(result,function(a,b)
  local x,y=D.encounters[a],D.encounters[b]
  if x[4]==y[4] then return a<b end
  return x[4]<y[4]
 end)
 return result
end
function M:ItemInfo(id)
 local c=GFL_Saved.cache[id] or {}
 if GetItemInfo then
  local n,l,q,level,req,class,sub,stack,slot,tex=GetItemInfo(id)
  if n then
   c={name=n,link=l,quality=q,level=level,slot=slot,icon=tex};GFL_Saved.cache[id]=c
   if GFL_Cache and GFL_Cache.Observe then GFL_Cache:Observe(id) end
  end
 end
 local cn=GFL_L10N.language=='zhCN' and c.name and GFL_NameCN and GFL_NameCN[c.name]
 return cn or (GFL_EnglishName and GFL_EnglishName[c.name]) or c.name or (L('物品 ID ')..id),c,c.name
end
function M:Link(id)
 local name,c=self:ItemInfo(id)
 return c.link or ('|Hitem:'..id..':0:0:0:0:0:0:0|h['..name..']|h')
end
function M:Find(query)
 query=(query or ''):gsub('^%s+',''):gsub('%s+$','')
 local id=tonumber(query) or tonumber(query:match('item:(%d+)'))
 if id then
  if id>0 and id<100000000 and id==math.floor(id) then return {id},id end
  return {},id
 end
 if query=='' then return self.itemList end
 local needle=query:lower();local out={}
 for _,item in ipairs(self.itemList) do
  -- 名称搜索只使用已缓存/已从客户端读取到的名称，不批量向服务器请求。
  local c=GFL_Saved.cache[item];local n=c and c.name
  local cn=GFL_L10N.language=='zhCN' and n and GFL_NameCN and GFL_NameCN[n]
  if (n and n:lower():find(needle,1,true)) or (cn and cn:lower():find(needle,1,true)) then out[#out+1]=item end
 end
 if #out==0 then
  local seen={}
  for boss,rows in pairs(self.byBoss) do
   local e=D.encounters[boss];local ins=D.instances[e[3]]
   if e[1]:lower():find(needle,1,true) or e[2]:lower():find(needle,1,true)
    or (ins and (ins[1]:lower():find(needle,1,true) or ins[2]:lower():find(needle,1,true))) then
    for _,r in ipairs(rows) do if not seen[r[3]] then seen[r[3]]=true;out[#out+1]=r[3] end end
   end
  end
  table.sort(out)
 end
 return out
end
function M:Loot(instance,boss,diff)
 local out,seen={},{}
 if boss and boss~=0 and (not D.encounters[boss] or D.encounters[boss][3]~=instance) then return out end
 local function add(rows)
  for _,r in ipairs(rows or {}) do
   if self:MatchDifficulty(r,diff) and not seen[r[3]] then seen[r[3]]=true;out[#out+1]=r[3] end
  end
 end
 if boss and boss~=0 then add(self.byBoss[boss])
 else for _,bid in ipairs(self:Bosses(instance)) do add(self.byBoss[bid]) end end
 table.sort(out);return out
end
function M:Sources(id,instance,boss,diff)
 local out,seen={},{}
 for _,r in ipairs(self.byItem[id] or {}) do
  local e=D.encounters[r[2]];local i=D.instances[e[3]]
  if i and (not instance or instance==0 or e[3]==instance) and (not boss or boss==0 or r[2]==boss) and self:MatchDifficulty(r,diff or 0) then
   local line=i[2]..' · '..e[2]..' · '..self:DiffText(r[4])
   if r[5]~=4294967295 then line=line..L('（阵营限制标记 ')..r[5]..'）' end
   if not seen[line] then out[#out+1]=line;seen[line]=true end
  end
 end
 return out
end
function M:Favorites()
 local out={};for id,active in pairs(GFL_Saved.favorites) do
  if active and type(id)=='number' and id>0 and id<100000000 and id==math.floor(id) then out[#out+1]=id end
 end
 table.sort(out);return out
end

end
