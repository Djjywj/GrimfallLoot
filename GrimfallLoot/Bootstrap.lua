-- 游戏在插件文件执行完后恢复SavedVariables，再发ADDON_LOADED。
local driver=CreateFrame('Frame');local started=false
function GFL_StartAddon()
 if started then return end
 started=true
 for _,initialize in ipairs(GFL_StartupModules or {})do initialize()end
 GFL_StartupModules=nil
 GFL_Saved.jumpDebug=nil;GFL_Saved.journalManualTrace=nil
 GFL_Saved.startup={version='1.4.9',language=GFL_L10N.language,restoredChoice=GFL_Language or GFL_Saved.language,cacheCount=GFL_Cache.cached}
end
driver:RegisterEvent('ADDON_LOADED');driver:RegisterEvent('PLAYER_LOGIN')
driver:SetScript('OnEvent',function(_,event,name)
 if event=='ADDON_LOADED'and type(name)=='string'and name:lower()=='grimfallloot' then GFL_StartAddon()
 elseif event=='PLAYER_LOGIN'then GFL_StartAddon()end
end)
