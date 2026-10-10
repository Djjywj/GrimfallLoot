GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
GFL_Saved=GFL_Saved or {}
local language=GFL_Language or GFL_Saved.language
if language~='enUS' and language~='zhCN' then
 -- 不读取系统/客户端语言：英文客户端安装中文补丁仍可能报告enUS。
 language='zhCN'
end
GFL_Saved.language=language
GFL_L10N={language=language}
local english={}
english["关闭"]="Close"
english["所有资料片"]="All expansions"
english["资料片"]="Expansion"
english["全部副本"]="All instances"
english["副本"]="Instance"
english["全部难度"]="All difficulties"
english["未注明难度"]="Difficulty unspecified"
english["难度"]="Difficulty"
english["所有副本"]="All instances"
english["地下城"]="Dungeons"
english["团队副本"]="Raids"
english["副本类别"]="Instance type"
english["全部物品类型"]="All item types"
english["类型"]="Type"
english["全部子类型"]="All subtypes"
english["子类型"]="Subtype"
english["全部部位"]="All slots"
english["部位"]="Slot"
english["粗糙"]="Poor"
english["普通"]="Common"
english["优秀"]="Uncommon"
english["精良"]="Rare"
english["史诗"]="Epic"
english["传说"]="Legendary"
english["神器"]="Artifact"
english["传家宝"]="Heirloom"
english["全部品质"]="All qualities"
english["品质"]="Quality"
english["按ID排序"]="Sort by ID"
english["按名称排序"]="Sort by name"
english["按装等从高到低"]="Item level: high to low"
english["按品质从高到低"]="Quality: high to low"
english["按所选属性从高到低"]="Selected stat: high to low"
english["排序"]="Sort"
english["搜索/反查"]="Search / Sources"
english["装等"]="iLvl"
english["属性"]="Stat"
english["应用数值"]="Apply values"
english["全部物品"]="All items"
english["收藏"]="Favorites"
english["副本掉落"]="Instance loot"
english["清空筛选"]="Clear filters"
english["自动缓存"]="Auto cache"
english["慢速：2次/秒"]="Slow: 2/sec"
english["普通：5次/秒"]="Normal: 5/sec"
english["加速：10次/秒"]="Fast: 10/sec"
english["高速：20次/秒（可能限流）"]="Turbo: 20/sec (may be throttled)"
english["缓存速度"]="Cache speed"
english["首领列表"]="Bosses"
english["掉落装备"]="Loot"
english["来源详情"]="Sources"
english["收藏装备"]="Favorites"
english["滚轮向下 · 右键取消收藏"]="Scroll down; right-click to remove"
english["缓存："]="Cache: "
english["缓存速度："]="Speed: "
english["次/秒 ▼"]="/sec ▼"
english["全部首领"]="All bosses"
english["搜索/反查结果"]="Search results"
english["全部指南物品"]="All journal items"
english["全部类型"]="All types"
english["装等从高到低"]="iLvl descending"
english["品质从高到低"]="Quality descending"
english["属性从高到低"]="Stat descending"
english["暂无指南来源"]="No journal source"
english["（更多来源见详情）"]=" (more sources in details)"
english["暂无来源数据"]="No source data"
english["指南来源（非已验证掉率）："]="Journal sources (not verified drop rates):"
english["跳转指南首领"]="Open boss in guide"
english["来源取自客户端指南；真实掉率未知。未注明难度不推断为全部难度。"]="Sources: client journal; actual drop rates unknown. Unspecified does not mean all difficulties."
english["选中装备后查看来源；右键收藏，Shift点击发链接，Ctrl点击试穿。"]="Select an item for sources. Right-click: favorite; Shift: link; Ctrl: dress up."
english["左键：选中；右键：收藏；Shift点击：发链接；Ctrl点击：试穿"]="Left: select; Right: favorite; Shift: link; Ctrl: dress up"
english["暂无符合结果。未缓存类型/数值不参与对应筛选，可等待缓存或清空筛选。"]="No matches. Unknown types/stats are excluded by filters. Wait for cache or clear filters."
english["Grimfall 掉落查询"]="Grimfall Loot"
english["装备查询、收藏和自动缓存。"]="Item search, favorites and automatic caching."
english["打开窗口"]="Open window"
english["暂停/继续缓存"]="Pause / resume cache"
english["缓存进度"]="Cache progress"
english["重试未返回物品"]="Retry missing items"
english["普通地下城"]="Normal dungeon"
english["英雄地下城"]="Heroic dungeon"
english["10人普通"]="10-player normal"
english["25人普通"]="25-player normal"
english["10人英雄"]="10-player heroic"
english["25人英雄"]="25-player heroic"
english["团队查找器"]="Raid Finder"
english["史诗钥石"]="Mythic Keystone"
english["普通团队"]="Normal raid"
english["英雄团队"]="Heroic raid"
english["史诗团队"]="Mythic raid"
english["史诗地下城"]="Mythic dungeon"
english["时空漫游地下城"]="Timewalking dungeon"
english["时空漫游团队"]="Timewalking raid"
english["消耗品"]="Consumable"
english["武器"]="Weapon"
english["宝石"]="Gem"
english["护甲"]="Armor"
english["材料"]="Trade Goods"
english["配方"]="Recipe"
english["任务物品"]="Quest item"
english["杂项"]="Miscellaneous"
english["其他护甲"]="Miscellaneous armor"
english["布甲"]="Cloth"
english["皮甲"]="Leather"
english["锁甲"]="Mail"
english["板甲"]="Plate"
english["盾牌"]="Shield"
english["圣契"]="Libram"
english["神像"]="Idol"
english["图腾"]="Totem"
english["魔印"]="Sigil"
english["单手斧"]="One-Handed Axe"
english["双手斧"]="Two-Handed Axe"
english["弓"]="Bow"
english["枪"]="Gun"
english["单手锤"]="One-Handed Mace"
english["双手锤"]="Two-Handed Mace"
english["长柄武器"]="Polearm"
english["单手剑"]="One-Handed Sword"
english["双手剑"]="Two-Handed Sword"
english["法杖"]="Staff"
english["拳套"]="Fist Weapon"
english["其他武器"]="Miscellaneous weapon"
english["匕首"]="Dagger"
english["投掷武器"]="Thrown"
english["弩"]="Crossbow"
english["魔杖"]="Wand"
english["钓鱼竿"]="Fishing Pole"
english["无装备部位"]="No equipment slot"
english["头部"]="Head"
english["颈部"]="Neck"
english["肩部"]="Shoulder"
english["衬衣"]="Shirt"
english["胸部"]="Chest"
english["腰部"]="Waist"
english["腿部"]="Legs"
english["脚部"]="Feet"
english["腕部"]="Wrist"
english["手部"]="Hands"
english["戒指"]="Finger"
english["饰品"]="Trinket"
english["单手武器"]="One-Hand"
english["远程"]="Ranged"
english["背部"]="Back"
english["双手武器"]="Two-Hand"
english["容器"]="Bag"
english["战袍"]="Tabard"
english["长袍"]="Robe"
english["主手"]="Main Hand"
english["副手"]="Off Hand"
english["副手物品"]="Held in Off Hand"
english["弹药"]="Ammo"
english["投掷"]="Thrown"
english["远程武器"]="Ranged"
english["箭袋"]="Quiver"
english["圣物"]="Relic"
english["不筛属性"]="No stat filter"
english["力量"]="Strength"
english["敏捷"]="Agility"
english["耐力"]="Stamina"
english["智力"]="Intellect"
english["精神"]="Spirit"
english["暴击等级"]="Critical Strike Rating"
english["急速等级"]="Haste Rating"
english["命中等级"]="Hit Rating"
english["攻击强度"]="Attack Power"
english["法术强度"]="Spell Power"
english["防御等级"]="Defense Rating"
english["躲闪等级"]="Dodge Rating"
english["招架等级"]="Parry Rating"
english["韧性等级"]="Resilience Rating"
english["类型未读取"]="Type not cached"
english["未返回"]="Missing"
english["已完成全部缓存，无需再读取。"]="All items cached. No further loading needed."
english["已有结果和未返回记录；需要重试时输入 /gfl cache retry。"]="This pass has ended. Use /gfl cache retry for missing items."
english["已开启：只请求还没有缓存、也没有失败记录的物品。"]="Enabled: request uncached items without previous failures only."
english["已暂停新请求，已发出的回复仍会保存。"]="New requests paused. Pending replies will still be saved."
english["已完成全部缓存，没有需要重试的物品。"]="All items cached. Nothing to retry."
english["只重新尝试尚未缓存的物品；已缓存结果不会重新请求。"]="Retrying uncached items only. Cached items will not be requested again."
english["高速可能卡顿、限流或断线；异常时请降速。"]="High speed may cause lag, throttling or disconnection. Reduce speed if needed."
english["暂停"]="Paused"
english["战斗暂停"]="Paused in combat"
english["读取中"]="Loading"
english["客户端没有可用物品查询接口"]="No available item query API"
english["继续缓存尚未读取的物品；输入 /gfl cache 查看进度。"]="Resuming uncached items. Use /gfl cache to view progress."
english["等待超时；可手动重试"]="Timed out; manual retry available"
english["没有可用"]="No available"
english["查询接口不可用，已暂停。"]="Query API unavailable; paused."
english["请脱离战斗后再跳转指南。"]="Leave combat before opening the guide."
english["该来源没有有效的指南首领编号。"]="This source has no valid journal boss ID."
english["未找到指南窗口，请先按Shift+J打开。"]="Guide window not found. Open it with Shift+J first."
english["指南已打开，但未找到可用的副本/首领界面回调。请 /reload 后发 SavedVariables/GrimfallLoot.lua，继续匹配真实按钮。"]="Guide opened, but no instance/boss UI callback was found. Use /reload and send SavedVariables/GrimfallLoot.lua for further adaptation."
english["左键：打开  "]="  右键：菜单|Left: open | Right: menu"
english["按住左键拖动：调整位置"]="Drag with left mouse button to reposition"
english["左键：打开  |  右键：菜单"]="Left: open | Right: menu"
english[" · 滚轮滚动"]=" · Mouse wheel to scroll"
english["物品 ID "]="Item ID "
english[" 个来源 · 滚轮滚动"]=" sources · Scroll with mouse wheel"
english["Grimfall 掉落查询 v1.3.1"]="Grimfall Loot v1.4.9"
english["右键装备加入收藏。\n这里独立显示全部收藏。"]="Right-click items to add favorites.\nAll favorites appear here."
english[" 个物品 · 滚轮滚动"]=" items · Mouse wheel to scroll"
english["收藏装备 ("]="Favorites ("
english[" 个收藏"]=" favorites"
english[" · 装等 "]=" · iLvl "
english["18,613 个指南物品ID · 来源不保证实际掉落 · 未返回 "]="18,613 journal items · Actual drops unverified · Missing "
english[" · /gfl cache retry 重试"]=" · /gfl cache retry to retry"
english["GrimfallLoot v1.3.1：207 个掉落副本，1126 位首领，18613 个物品ID。"]="GrimfallLoot v1.4.9: 207 loot instances, 1126 bosses, 18613 item IDs."
english["（阵营限制标记 "]=" (faction restriction flag "
english["装等 "]="iLvl "
english["部位 "]="Slot "
english[" · 阵营限制标记 "]=" · Faction restriction flag "
english["|cff66bbffGrimfall自动缓存|r "]="|cff66bbffGrimfall cache|r "
english["已完成全部缓存："]="All items cached: "
english["。自动缓存已停止；/reload或正常退出后保存，下次登录不再请求。"]=". Auto cache stopped. /reload or exit normally to save; no new requests next login."
english["本轮已结束：已缓存 "]="Pass ended: cached "
english["，未返回 "]=", missing "
english["。已停止，不会每次登录自动重试；可用 /gfl cache retry 手动重试。"]=". Stopped; no automatic retry next login. Use /gfl cache retry manually."
english["每秒最多 "]="Up to "
english[" 次请求。"]=" requests/sec."
english["已全部完成 "]="Complete "
english["已结束 "]="Pass ended "
english["（未返 "]=" (missing "
english["；等待 "]="; pending "
english["；未返回 "]="; missing "
english["；本次发出 "]="; requested this session "
english["，本次登录不再请求。"]="; no requests this login."
english["使用已保存缓存："]="Using saved cache: "
english["；不会自动重新请求。"]="; no automatic new requests."
english["已执行指南选择："]="Guide selection attempted: "
english['已完成处理：']='Processing complete: '
english['；缓存成功 ']='; cached '
english['。已停止，不再重试。']='. Stopped; no retries.'
english['已完成处理，不再重试未返回物品。']='Processing complete. Missing items will not be retried.'
english['处理完成 ']='Complete '
english['处理中']='Processing'
english['未返回；跳过，不重试']='No response; skipped without retry'
english[' · 已处理 ']=' · Processed '
english[' · 缓存成功 ']=' · Cached '
function GFL_L10N.Text(s)
 if language=='enUS' then return ((english[s] or s):gsub('（',' ('):gsub('）',')'):gsub('：',': '):gsub('；','; ')) end
 return (s:gsub('v1%.3%.1','v1.4.9'))
end
if language=='enUS' then
 for _,dictionary in ipairs({GFL_DB.instances,GFL_DB.encounters,GFL_DB.tiers}) do
  for _,record in pairs(dictionary)do record[2]=record[1]end
 end
end
SLASH_GFLLANG1='/gflang'
SlashCmdList.GFLLANG=function(msg)
 msg=(msg or ''):lower():gsub('%s+','')
 local lang=(msg=='en' or msg=='enus' or msg=='english') and 'enUS' or (msg=='zh' or msg=='zhcn' or msg=='cn') and 'zhCN'
 if not lang then print('Language: '..language..'. /gflang en | /gflang zh');return end
 GFL_Saved.language=lang;GFL_Language=lang
 if StaticPopupDialogs and type(StaticPopup_Show)=='function' then
  local key=lang=='zhCN' and 'GFL_RELOAD_ZH' or 'GFL_RELOAD_EN'
  StaticPopupDialogs[key]={
   text=lang=='zhCN' and '已选择简体中文。点击“立即重载”应用语言。\n缓存和收藏会保留。' or 'English selected. Click Reload now to apply.\nYour cache and favorites will be preserved.',
   button1=lang=='zhCN' and '立即重载' or 'Reload now',
   button2=lang=='zhCN' and '稍后' or 'Later',
   OnAccept=function()
    GFL_Saved.language=lang;GFL_Language=lang
    if type(ReloadUI)=='function'then ReloadUI()end
   end,
   timeout=0,whileDead=true,hideOnEscape=true,preferredIndex=3,
  }
  StaticPopup_Show(key)
 else
  if lang=='enUS' then print('English selected. Type /reload to apply.') else print('已选择中文。输入 /reload 生效。')end
 end
end

if language=='enUS' then
 GFL_EnglishName={}
 local ambiguous={}
 for en,zh in pairs(GFL_NameCN or {})do
  if GFL_EnglishName[zh] and GFL_EnglishName[zh]~=en then ambiguous[zh]=true else GFL_EnglishName[zh]=en end
 end
 for zh in pairs(ambiguous)do GFL_EnglishName[zh]=nil end
end

local languageWindow
function GFL_L10N.ShowLanguageDialog()
 if not languageWindow then
  local f=CreateFrame('Frame','GrimfallLootLanguageWindow',UIParent);languageWindow=f
  f:SetSize(370,130);f:SetPoint('CENTER');f:SetFrameStrata('FULLSCREEN_DIALOG');f:SetFrameLevel(500);f:EnableMouse(true)
  f:SetBackdrop({bgFile='Interface\\Buttons\\WHITE8X8',edgeFile='Interface\\DialogFrame\\UI-DialogBox-Border',edgeSize=24,insets={left=5,right=5,top=5,bottom=5}})
  if f.SetBackdropColor then f:SetBackdropColor(0.025,0.03,0.045,1)end
  local title=f:CreateFontString(nil,'OVERLAY','GameFontNormal');title:SetPoint('TOP',0,-20);title:SetText('选择语言 / Choose language')
  local function b(x,label,lang)
   local o=CreateFrame('Button',nil,f,'UIPanelButtonTemplate');o:SetSize(150,32);o:SetPoint('TOPLEFT',x,-55);o:SetText(label);o:SetFrameStrata('FULLSCREEN_DIALOG');o:SetFrameLevel(510);o:EnableMouse(true)
   o:SetScript('OnClick',function()f:Hide();SlashCmdList.GFLLANG(lang)end);return o
  end
  f.chinese=b(25,'简体中文','zhCN');f.english=b(195,'English','enUS')
  local close=CreateFrame('Button',nil,f,'UIPanelButtonTemplate');close:SetSize(70,22);close:SetPoint('BOTTOM',0,12);close:SetText('关闭 / Close');close:SetFrameStrata('FULLSCREEN_DIALOG');close:SetFrameLevel(510);close:SetScript('OnClick',function()f:Hide()end)
  UISpecialFrames=UISpecialFrames or {};table.insert(UISpecialFrames,'GrimfallLootLanguageWindow')
 end
 languageWindow:Show()
end

end
