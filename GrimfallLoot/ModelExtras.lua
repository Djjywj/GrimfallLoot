GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
local L=GFL_L10N.Text
local M,D=GFL_Model,GFL_DB
local classNames={[0]=L('消耗品'),[2]=L('武器'),[3]=L('宝石'),[4]=L('护甲'),[7]=L('材料'),[9]=L('配方'),[12]=L('任务物品'),[15]=L('杂项')}
local classKeys={Weapon=2,['武器']=2,Armor=4,['护甲']=4,Consumable=0,['消耗品']=0,Gem=3,['宝石']=3,Recipe=9,['配方']=9,['Trade Goods']=7,['贸易品']=7,['商品']=7,Quest=12,['任务']=12,Miscellaneous=15,['杂项']=15}
local armorNames={[0]=L('其他护甲'),[1]=L('布甲'),[2]=L('皮甲'),[3]=L('锁甲'),[4]=L('板甲'),[6]=L('盾牌'),[7]=L('圣契'),[8]=L('神像'),[9]=L('图腾'),[10]=L('魔印')}
local weaponNames={[0]=L('单手斧'),[1]=L('双手斧'),[2]=L('弓'),[3]=L('枪'),[4]=L('单手锤'),[5]=L('双手锤'),[6]=L('长柄武器'),[7]=L('单手剑'),[8]=L('双手剑'),[10]=L('法杖'),[13]=L('拳套'),[14]=L('其他武器'),[15]=L('匕首'),[16]=L('投掷武器'),[18]=L('弩'),[19]=L('魔杖'),[20]=L('钓鱼竿')}
local subKeys={
 [4]={Cloth=1,['布甲']=1,Leather=2,['皮甲']=2,Mail=3,['锁甲']=3,Plate=4,['板甲']=4,Shields=6,['盾牌']=6,Miscellaneous=0},
 [2]={Axes=0,['One-Handed Axes']=0,['单手斧']=0,['Two-Handed Axes']=1,['双手斧']=1,Bows=2,['弓']=2,Guns=3,['枪']=3,Maces=4,['One-Handed Maces']=4,['单手锤']=4,['Two-Handed Maces']=5,['双手锤']=5,Polearms=6,['长柄武器']=6,Swords=7,['One-Handed Swords']=7,['单手剑']=7,['Two-Handed Swords']=8,['双手剑']=8,Staves=10,['法杖']=10,['Fist Weapons']=13,['拳套']=13,Daggers=15,['匕首']=15,Thrown=16,['投掷武器']=16,Crossbows=18,['弩']=18,Wands=19,['魔杖']=19,['Fishing Poles']=20,['钓鱼竿']=20},
}
local slotNames={[0]=L('无装备部位'),[1]=L('头部'),[2]=L('颈部'),[3]=L('肩部'),[4]=L('衬衣'),[5]=L('胸部'),[6]=L('腰部'),[7]=L('腿部'),[8]=L('脚部'),[9]=L('腕部'),[10]=L('手部'),[11]=L('戒指'),[12]=L('饰品'),[13]=L('单手武器'),[14]=L('盾牌'),[15]=L('远程'),[16]=L('背部'),[17]=L('双手武器'),[18]=L('容器'),[19]=L('战袍'),[20]=L('长袍'),[21]=L('主手'),[22]=L('副手'),[23]=L('副手物品'),[24]=L('弹药'),[25]=L('投掷'),[26]=L('远程武器'),[27]=L('箭袋'),[28]=L('圣物')}
local slots={INVTYPE_NON_EQUIP=0,INVTYPE_HEAD=1,INVTYPE_NECK=2,INVTYPE_SHOULDER=3,INVTYPE_BODY=4,INVTYPE_CHEST=5,INVTYPE_WAIST=6,INVTYPE_LEGS=7,INVTYPE_FEET=8,INVTYPE_WRIST=9,INVTYPE_HAND=10,INVTYPE_FINGER=11,INVTYPE_TRINKET=12,INVTYPE_WEAPON=13,INVTYPE_SHIELD=14,INVTYPE_RANGED=15,INVTYPE_CLOAK=16,INVTYPE_2HWEAPON=17,INVTYPE_BAG=18,INVTYPE_TABARD=19,INVTYPE_ROBE=20,INVTYPE_WEAPONMAINHAND=21,INVTYPE_WEAPONOFFHAND=22,INVTYPE_HOLDABLE=23,INVTYPE_AMMO=24,INVTYPE_THROWN=25,INVTYPE_RANGEDRIGHT=26,INVTYPE_QUIVER=27,INVTYPE_RELIC=28}
M.classNames=classNames;M.armorNames=armorNames;M.weaponNames=weaponNames;M.slotNames=slotNames
M.statOptions={{value='',label=L('不筛属性')},{value='ITEM_MOD_STRENGTH_SHORT',label=L('力量')},{value='ITEM_MOD_AGILITY_SHORT',label=L('敏捷')},{value='ITEM_MOD_STAMINA_SHORT',label=L('耐力')},{value='ITEM_MOD_INTELLECT_SHORT',label=L('智力')},{value='ITEM_MOD_SPIRIT_SHORT',label=L('精神')},{value='ITEM_MOD_CRIT_RATING_SHORT',label=L('暴击等级')},{value='ITEM_MOD_HASTE_RATING_SHORT',label=L('急速等级')},{value='ITEM_MOD_HIT_RATING_SHORT',label=L('命中等级')},{value='ITEM_MOD_ATTACK_POWER_SHORT',label=L('攻击强度')},{value='ITEM_MOD_SPELL_POWER_SHORT',label=L('法术强度')},{value='ITEM_MOD_DEFENSE_SKILL_RATING_SHORT',label=L('防御等级')},{value='ITEM_MOD_DODGE_RATING_SHORT',label=L('躲闪等级')},{value='ITEM_MOD_PARRY_RATING_SHORT',label=L('招架等级')},{value='ITEM_MOD_RESILIENCE_RATING_SHORT',label=L('韧性等级')},{value='ITEM_MOD_ARMOR_SHORT',label=L('护甲')} }
function M:StatName(key)for _,o in ipairs(self.statOptions)do if o.value==key then return o.label end end;return key end
function M:ItemInfo(id)
 local c=GFL_Saved.cache[id] or {}
 local saved=type(c.name)=='string' and c.name~='' and c.icon~=nil
 if GetItemInfo and not saved then
  local n,l,q,level,req,class,sub,stack,slot,tex,sell,classID,subID=GetItemInfo(id)
  if n then
   c.name=n;c.link=l;c.quality=q;c.level=level;c.minLevel=req;c.class=class;c.subclass=sub;c.slot=slot;c.icon=tex
   local meta=GFL_ItemMeta and GFL_ItemMeta[id]
   c.classID=type(classID)=='number' and classID or classKeys[class] or (meta and meta[1])
   c.subclassID=type(subID)=='number' and subID or (subKeys[c.classID] and subKeys[c.classID][sub]) or (meta and meta[2])
   c.slotID=slots[slot] or (meta and meta[3])
   if GetItemStats and type(l)=='string' and not c.statsChecked then
    local result={};local ok,s=pcall(GetItemStats,l,result)
    if ok then
     local src=type(s)=='table' and s or result;local values={}
     for key,value in pairs(src)do if type(key)=='string' and type(value)=='number'then values[key]=value end end
     if next(values)then c.stats=values;c.statsChecked=true end
    end
   end
   GFL_Saved.cache[id]=c
   if GFL_Cache and GFL_Cache.Observe then GFL_Cache:Observe(id)end
  end
 end
 if saved and GFL_Cache and not GFL_Cache.known[id] then GFL_Cache:Observe(id)end
 local cn=GFL_L10N.language=='zhCN' and c.name and GFL_NameCN and GFL_NameCN[c.name]
 return cn or (GFL_EnglishName and GFL_EnglishName[c.name]) or c.name or (L('物品 ID ')..id),c,c.name
end
function M:Meta(id)
 local c=GFL_Saved.cache[id] or {};local meta=GFL_ItemMeta and GFL_ItemMeta[id]
 return c.classID or (meta and meta[1]),c.subclassID or (meta and meta[2]),c.slotID or slots[c.slot] or (meta and meta[3])
end
function M:Description(id)
 local c=GFL_Saved.cache[id] or {};local cl,su,sl=self:Meta(id)
 local sub=cl==2 and weaponNames[su] or cl==4 and armorNames[su]
 return (c.level and L('装等 ')..c.level..'  ' or '')..(sub or classNames[cl] or c.subclass or c.class or L('类型未读取'))..(sl and ' · '..(slotNames[sl] or L('部位 ')..sl) or '')
end
function M:ApplyFilters(list,filters)
 local out={}
 for _,id in ipairs(list)do
  local c=GFL_Saved.cache[id] or {};local cl,su,sl=self:Meta(id);local yes=true
  if filters.classID~=-1 and filters.classID~=nil and cl~=filters.classID then yes=false end
  if filters.subclassID~=-1 and filters.subclassID~=nil and su~=filters.subclassID then yes=false end
  if filters.slotID~=-1 and filters.slotID~=nil then
   if filters.slotID==5 then if sl~=5 and sl~=20 then yes=false end
   elseif sl~=filters.slotID then yes=false end
  end
  if filters.quality~=-1 and filters.quality~=nil and c.quality~=filters.quality then yes=false end
  if filters.minLevel and filters.minLevel>0 and (not c.level or c.level<filters.minLevel)then yes=false end
  if filters.maxLevel and filters.maxLevel>0 and (not c.level or c.level>filters.maxLevel)then yes=false end
  if filters.stat and filters.stat~='' then
   local v=c.stats and c.stats[filters.stat]
   if type(v)~='number' or v<(filters.statMin or 0)then yes=false end
  end
  if yes then out[#out+1]=id end
 end
 local mode=filters.sort or 'id'
 if mode=='id' then return out end
 table.sort(out,function(a,b)
  local x,y=GFL_Saved.cache[a] or {},GFL_Saved.cache[b] or {}
  if mode=='name' then
   local na=(x.name and (GFL_L10N.language=='zhCN' and GFL_NameCN[x.name] or x.name))or '~';local nb=(y.name and (GFL_L10N.language=='zhCN' and GFL_NameCN[y.name] or y.name))or '~'
   if na~=nb then return na<nb end
  elseif mode=='level' or mode=='quality' or mode=='stat' then
   local va=mode=='stat' and (x.stats and x.stats[filters.stat]) or x[mode]
   local vb=mode=='stat' and (y.stats and y.stats[filters.stat]) or y[mode]
   if va~=vb then if va==nil then return false elseif vb==nil then return true else return va>vb end end
  end
  return a<b
 end)
 return out
end
function M:SourceRecords(id)
 local out,seen={},{}
 for _,r in ipairs(self.byItem[id] or {})do
  local e=D.encounters[r[2]];local i=D.instances[e[3]]
  if i then
   local label=i[2]..' · '..e[2]..'\n'..self:DiffText(r[4])
   if r[5]~=4294967295 then label=label..L(' · 阵营限制标记 ')..r[5]end
   if not seen[label] then seen[label]=true;out[#out+1]={instanceID=e[3],bossID=r[2],difficultyIDs=r[4],label=label}end
  end
 end
 return out
end

end
