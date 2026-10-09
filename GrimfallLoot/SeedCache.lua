GFL_StartupModules=GFL_StartupModules or {}
GFL_StartupModules[#GFL_StartupModules+1]=function()
-- 插件目录内的离线物品缓存入口。
-- 此文件不是游戏运行时写入的文件；可由外部工具/重新打包填写已验证的物品名称和图标。
-- 在线新缓存仍由游戏保存到 WTF 下的 GrimfallLoot.lua。
GFL_SeedCache = GFL_SeedCache or {}
GFL_Saved = GFL_Saved or {}
GFL_Saved.cache = GFL_Saved.cache or {}
for id, row in pairs(GFL_SeedCache) do
 if type(id)=='number' and type(row)=='table' and type(row.name)=='string' then
  local existing=GFL_Saved.cache[id]
  if not existing or not existing.name or not existing.icon then
   local copy={}
   for key,value in pairs(row)do if type(value)=='string' or type(value)=='number' or type(value)=='boolean' or (key=='stats' and type(value)=='table') then copy[key]=value end end
   GFL_Saved.cache[id]=copy
  end
 end
end

end
