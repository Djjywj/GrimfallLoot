# GrimfallLoot

Grimfall 装备查询插件，支持简体中文和英文。当前版本：**1.4.8**。

## 安装

在 **Releases** 下载 `GrimfallLoot-v1.4.8.zip`，退出游戏，解压后把 `GrimfallLoot` 文件夹放到：

```text
游戏目录\Interface\AddOns\
```

升级时替换旧的 `GrimfallLoot` 文件夹，**不要删除 WTF**，缓存和收藏都在里面。

点击小地图宝箱图标打开，也可以输入 `/gfl`。右上角切换中文或英文，点击“立即重载”后生效。

## 功能

- 按副本、首领、难度查看装备来源。
- 搜索物品，按类型、部位、品质、装等和属性筛选。
- 右键收藏，右侧收藏栏支持滚动。
- Shift 点击发物品链接，Ctrl 点击试穿。
- 后台读取装备信息，保存缓存。

进度显示的是 **已处理 / 总数**。读不到的物品记为未返回，也计入进度，不重试。处理完后停止，成功数和未返回数分别显示。正常退出或重载后保存，下次登录不会重新处理已有记录。

**没有冒险指南跳转功能**。来源窗口只显示副本、首领和难度。

## 注意

适用于 Grimfall 定制客户端，接口版本为 `30300`。其他服务器不保证兼容。

数据来自客户端指南，共 18,613 个物品 ID，不是服务器全部装备，也不保证与实际掉落一致。部分物品可能读不到。

包里不包含 WTF、账号信息、个人缓存、MPQ 或 DLL。英文模式不会修改其他汉化插件提供的中文提示框。

## English

Standalone item browser for the custom Grimfall client. English / Simplified Chinese UI.

Download `GrimfallLoot-v1.4.8.zip` from **Releases** and place the `GrimfallLoot` folder in `Interface\AddOns`. Keep your WTF folder when upgrading. Open with the minimap chest icon or `/gfl`.

Search items, browse sources, filter equipment and save favorites. Right-click to favorite, Shift-click to link, Ctrl-click to dress up. Use the language button, then Reload now.

Progress counts cached and missing items as processed. Missing items are skipped without retries. Save with a normal exit or UI reload. There is no Adventure Guide navigation.

The 18,613 item IDs come from the client journal, not a complete server database or verified drop tables. Some items may be unavailable. Other clients and servers are not guaranteed to work.

## 数据来源

目录及部分中文物品名称整理自本项目使用的客户端文件和汉化包，相关数据归原作者所有。本项目不代表 Blizzard 或 Grimfall 官方，也不对第三方数据授予新的开源许可。
