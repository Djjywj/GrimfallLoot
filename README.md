# GrimfallLoot — Grimfall 装备查询

在游戏里查装备、看来源、收藏想要的装备。支持**简体中文 / English**，不用安装 AtlasLoot。

**[下载最新版](https://github.com/Djjywj/GrimfallLoot/releases/latest)** · 当前版本 **v1.4.8**

## 能做什么

- **查装备**：输入物品名称或 ID 搜索，查看装备信息和来源。
- **看副本掉落**：按资料片、副本、首领和难度浏览指南中的装备。
- **筛选装备**：按武器 / 护甲类型、部位、品质、装等及属性筛选，支持排序。
- **收藏装备**：右键加入收藏，右侧有单独的收藏栏，收藏多了可以向下滚动。
- **试穿和发链接**：Ctrl 点击试穿，Shift 点击发送物品链接。
- **自动读取信息**：后台读取装备名称和图标，不用一件件用鼠标划过。
- **切换语言**：点右上角语言按钮，选择中文或英文，再点“立即重载”。

来源窗口只显示副本、首领和难度，**不联动冒险指南，不提供跳转**。

## 怎么安装

1. 在 [下载页](https://github.com/Djjywj/GrimfallLoot/releases/latest) 下载 **`GrimfallLoot-v1.4.8.zip`**。
2. 退出游戏，解压，把 `GrimfallLoot` 文件夹放到 `游戏目录\Interface\AddOns\`。
3. 进入游戏，点小地图上的宝箱图标打开。也可以输入 `/gfl`。

升级时替换旧的 `GrimfallLoot` 插件文件夹。**不要删除 WTF**，已有缓存、收藏和语言设置保留。

## 常用操作

左键选中装备后，点 **“来源详情”** 查看出处。右键装备加入收藏，在右侧收藏栏右键取消收藏。列表和收藏栏都支持鼠标滚轮。

如果筛选后没有结果，可以先清空筛选或等待装备信息读取。没有读到的装等、品质和属性，不参与对应筛选。

## 缓存进度怎么算

进度显示 **已处理 / 总数**：读到信息算已处理，游戏没有返回信息也算已处理，但记为“未返回”，**不重试**。

整轮处理完就停止，成功数量和未返回数量分别显示。正常退出或重载后保存，下次登录不会重新处理已有记录。游戏自己的装备提示框仍可能按需读取信息。

## 使用前知道这几件事

适用于 **Grimfall 定制客户端**，接口版本 `30300`，其他服务器不保证兼容。

数据库来自客户端指南，包含 **18,613 个物品 ID**。它不是服务器全部装备，也不保证每一条来源与实际掉落一致，部分物品可能读不到。

英文模式只切换本插件的文字，不会把其他汉化插件或客户端提供的中文提示框改回英文。安装包不含 WTF、个人缓存、MPQ 或 DLL。

## English

An independent item browser for the custom Grimfall client. Search items by name or ID, browse journal sources, filter equipment and save favorites. No AtlasLoot dependency.

Download **`GrimfallLoot-v1.4.8.zip`** from [Releases](https://github.com/Djjywj/GrimfallLoot/releases/latest). Place the `GrimfallLoot` folder in `Interface\AddOns`, then open it with the minimap chest icon or `/gfl`. Keep WTF when upgrading.

- Left-click: select; **Sources**: view instance, boss and difficulty.
- Right-click: favorite / remove from Favorites.
- Shift-click: link an item; Ctrl-click: dress up.
- Scroll with the mouse wheel. Choose English or Chinese with the language button, then Reload now.

Progress includes cached and missing items as processed. Missing responses are skipped without retries. Save with a normal exit or UI reload. There is **no Adventure Guide navigation**.

The 18,613 IDs are from the client journal, not a complete server database or verified drop tables. Some items may be unavailable. Other clients and servers are not guaranteed to work.

## 数据来源

目录及部分中文物品名称整理自本项目使用的客户端文件和汉化包，相关数据归原作者所有。本项目不代表 Blizzard 或 Grimfall 官方，也不对第三方数据授予新的开源许可。
