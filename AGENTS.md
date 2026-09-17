# AGENTS.md - 系统资源仓库开发指南

本文件为在 system_resources 仓库中工作的智能编码代理提供指导。

## 概述

`system_resources` 组件（`@ohos/system_resources`，版本 4.0）属于 OpenHarmony `global` 子系统。这是一个**纯资源包**——仓库中不存在任何 C/C++、JS 或 TS 源代码。该组件提供两个交付物：

1. **系统字体**（`fonts/`）——HarmonyOS Sans 字体家族（15 个 TTF + 3 个符号配置 JSON），以预构建 etc 文件形式安装，支持按产品/设备选择。
2. **SystemResources HAP**（`systemres/`）——一个已签名的单例 HAP（`ohos.global.systemres`，版本 3.0.1），包含分层参数资源（颜色、浮点数、字符串、模式、符号、主题）、244 个 SVG + 19 个 PNG 媒体资源，以及 1072 个权限定义，覆盖 76 个语言/设备限定词目录。

- **组件**：`system_resources`，子系统 `global`
- **域**：`os`，**标签**：`["resources"]`
- **许可证**：Apache License 2.0（`LICENSE`）、HarmonyOS Sans 字体许可协议（`LICENSE_Fonts`）
- **ROM**：792KB，**RAM**：700KB
- **无测试、无 lint、无代码风格配置**——这是一个纯数据包

## 构建系统

本项目使用 GN（Generate Ninja）构建系统。所有构建配置均在 GN 文件中，不存在可编译的源代码。

### 构建命令

```bash
# 构建整个 system_resources 组件（在 OpenHarmony 根目录执行，如 ~/openharmony）
./build.sh --product-name rk3568 --ccache --build-target system_resources

# 仅构建 SystemResources HAP
./build.sh --product-name rk3568 --ccache --build-target //base/global/system_resources/systemres:systemres_hap

# 仅构建字体目标
./build.sh --product-name rk3568 --ccache --build-target //base/global/system_resources:ohos_fonts
```

### GN 构建目标

| 目标 | 路径 | 类型 | 说明 |
|------|------|------|------|
| `systemres_hap` | `systemres:systemres_hap` | `ohos_hap` | SystemResources HAP 包 |
| `ohos_fonts` | `:ohos_fonts` | `ohos_shared_headers` | 聚合所有字体预构建依赖 |
| `HarmonyOS_Sans` 等 | `:HarmonyOS_Sans` | `ohos_prebuilt_etc` | 各字体预构建（18 个条目） |
| `copy_preview_fonts` | `:copy_preview_fonts` | `ohos_copy` | 复制字体到 previewer/common/bin/fonts/ |
| `copy_preview_fonts_ext` | `:copy_preview_fonts_ext` | `ohos_copy` | 复制字体 + fontconfig 到 previewer/resources/fonts/ |

### 构建特性（来自 `systemres.gni`）

| 特性开关 | 默认值 | 说明 |
|----------|--------|------|
| `system_resources_support_ext` | `false` | 启用来自 vendor 路径的扩展资源 |
| `system_resources_font_feature_product` | `"default"` | 产品选择（`"default"` 或 `"watch"`） |
| `system_resources_font_feature_cfp_enable` | `false` | 为 true 时，从字体依赖中移除 `HarmonyOS_Sans_SC` |

### 组件依赖（来自 `bundle.json`）

- `ets_frontend`（组件依赖，无三方依赖）

## 仓库结构

```
system_resources/
├── AGENTS.md
├── BUILD.gn                             # 字体预构建 + ohos_fonts + copy 目标
├── bundle.json                          # 组件清单
├── systemres.gni                        # 特性开关、字体列表、证书路径
├── OAT.xml                              # OSS 审计配置
├── LICENSE                              # Apache 2.0
├── LICENSE_Fonts                        # HarmonyOS Sans 字体许可协议
├── README.md / README_zh.md             # 英文/中文 README
├── .gitee/
│   └── PULL_REQUEST_TEMPLATE.zh-CN.md   # PR 自检清单
├── .gitattributes                       # 二进制文件的 Git LFS 规则
├── fonts/                               # 系统字体文件（15 个 TTF + 3 个 JSON）
│   ├── HarmonyOS_Sans.ttf               # 拉丁文基础（Thin–Black 权重）
│   ├── HarmonyOS_Sans_Italic.ttf
│   ├── HarmonyOS_Sans_Condensed.ttf
│   ├── HarmonyOS_Sans_Condensed_Italic.ttf
│   ├── HarmonyOS_Sans_Naskh_Arabic.ttf
│   ├── HarmonyOS_Sans_Naskh_Arabic_UI.ttf
│   ├── HarmonyOS_Sans_SC.ttf            # 简体中文（20.6 MB，LFS）
│   ├── HarmonyOS_Sans_TC.ttf            # 繁体中文（9.9 MB）
│   ├── HarmonyOS_Sans_Digit.ttf
│   ├── HarmonyOS_Sans_Digit_Medium.ttf
│   ├── HMOSColorEmojiCompat.ttf         # 彩色表情（16.8 MB，LFS）
│   ├── HMOSColorEmojiFlags.ttf
│   ├── HMSymbolVF.ttf                   # 符号可变字体（LFS）
│   ├── HMSymbolVF_watch.ttf             # 手表别名 → HMSymbolVF.ttf
│   ├── HarmonyOS_Sans_Notdef.ttf
│   ├── hm_symbol_config.json            # 符号字形映射
│   ├── hm_symbol_config_next.json       # 新一代符号配置（LFS）
│   └── hm_symbol_config_next_watch.json # 手表别名 → hm_symbol_config_next.json
└── systemres/                           # SystemResources HAP 包
    ├── BUILD.gn                         # HAP 构建（ohos_hap, ohos_resources, ohos_app_scope）
    ├── SystemResources.p7b             # HAP 签名配置文件
    ├── AppScope/                        # 应用级 scope
    │   ├── app.json                     # bundleName: ohos.global.systemres, version 3.0.1
    │   └── resources/
    │       ├── base/element/string.json # 应用名称: "System"
    │       ├── base/media/ohos_app_icon.png
    │       └── zh_CN/element/string.json # 应用名称: "系统"
    └── main/                           # 模块级资源
        ├── module.json                  # HAP 清单（~9867 行，1072 个 definePermissions）
        └── resources/                   # 76 个语言/设备限定词目录
            ├── base/                   # 默认资源（13 个 element 文件 + 241 个媒体）
            ├── dark/                   # 深色主题媒体（20 个资源）
            ├── phone/ tablet/ tv/ car/ 2in1/ wearable/ # 设备形态
            ├── <locale>/element/       # 60+ 语言区域（string.json, plurals.json）
            └── zz_ZX/                  # 伪语言区域，用于国际化测试
```

## 任务路径速查

| 任务 | 关键路径 |
|------|----------|
| 新增/修改系统字符串 | `systemres/main/resources/base/element/string.json`（默认）+ 各语言 `string.json` |
| 新增/修改系统颜色 | `systemres/main/resources/base/element/color.json` + `color_dark.json`（深色主题） |
| 新增/修改浮点尺寸 | `systemres/main/resources/base/element/float.json` |
| 新增/修改符号字形 | `systemres/main/resources/base/element/symbol.json` + `fonts/hm_symbol_config.json` |
| 新增/修改主题 | `systemres/main/resources/base/element/theme.json` |
| 新增媒体资源（图标） | `systemres/main/resources/base/media/`（优先 SVG，栅格图用 PNG） |
| 新增深色主题媒体资源 | `systemres/main/resources/dark/media/` |
| 新增权限定义 | `systemres/main/module.json` → `definePermissions` 数组 |
| 新增/修改系统字体 | `fonts/` + `systemres.gni` → `sys_fonts_list` |
| 修改字体产品选择 | `systemres.gni` → 每个字体条目的 `support_devices` |
| 修改 HAP 签名配置 | `systemres.gni` → `certificate_profile_path` |
| 新增语言区域 | `systemres/main/resources/<locale>/element/`，包含 `string.json` + `plurals.json` |

## 资源元素文件

位于 `systemres/main/resources/base/element/`：

| 文件 | 内容 | 示例 |
|------|------|------|
| `string.json` | UI 字符串键值对 | `"ohos_id_text_font_family_regular": "sans-serif"` |
| `string_sys.json` | 系统内部字符串 | 权限标签/描述 |
| `plurals.json` | 复数字符串 | 按数量选择（one, few, many, other） |
| `color.json` | 颜色值（十六进制） | `"ohos_id_color_foreground": "#ff182431"` |
| `color_dark.json` | 深色主题颜色 | 深色模式覆盖 |
| `color_sys.json` | 系统内部颜色 | |
| `color_transparent.json` | 透明色变体 | |
| `float.json` | 尺寸/透明度值 | `"ohos_id_alpha_content_primary": "0.9"` |
| `float_sys.json` | 系统内部尺寸 | |
| `pattern.json` | UI 模式定义 | 可复用样式组合 |
| `id_defined.json` | 显式 ID 声明 | |
| `symbol.json` | 符号字形码位 | `"ohos_wifi": "0xF0000"`、`"ohos_trash": "0xF0001"` |
| `theme.json` | 主题配置 | |

## 字体配置

### 字体列表（`systemres.gni` → `sys_fonts_list`）

18 个字体条目（16 个唯一 + 2 个手表别名）。每个条目包含：
- `font_name`：GN 目标名（也是安装名）
- `font_path`：`fonts/` 中的 TTF/JSON 文件路径
- `support_devices`：`["default"]`、`["watch"]` 或两者——控制哪个产品加载该字体
- `alias_name`：手表变体使用别名覆盖默认输出名（如 `HMSymbolVF_watch` → `HMSymbolVF.ttf`）

### 字体安装

字体通过 `ohos_prebuilt_etc()` 安装到 `fonts/` 目录。`ohos_fonts` 目标将所有字体依赖聚合为共享头文件。

### Fontconfig 引用

`systemres.gni` 引用外部 fontconfig 文件：
- `//third_party/skia/m133/src/ports/skia_ohos/config/fontconfig.json`
- `//third_party/skia/m133/src/ports/skia_ohos/config/fontconfig_ohos.json`

这些文件由 Skia 的字体渲染管线消费，不在本仓库中构建。

## SystemResources HAP

### HAP 清单（`systemres/main/module.json`）

- **包名**：`ohos.global.systemres`
- **模块类型**：`entry`，**单例**：true（singleton 定义在 `AppScope/app.json` 中）
- **设备类型**：`default, tv, car, wearable, tablet, 2in1`
- **版本**：`versionCode: 3`、`versionName: "3.0.1"`、`minAPIVersion: 20`、`targetAPIVersion: 20`（均在 `AppScope/app.json` 中）
- **definePermissions**：1072 个权限定义——这是**系统权限注册表的权威来源**

### 应用配置（`systemres/AppScope/app.json`）

以下字段定义在 `AppScope/app.json` 中，**不在** `module.json` 中：
- `bundleName`：`ohos.global.systemres`
- `singleton`：`true`
- `vendor`：`ohos`
- `versionCode`：`3`、`versionName`：`3.0.1`
- `minAPIVersion`：`20`、`targetAPIVersion`：`20`
- `icon`：`$media:ohos_app_icon`、`label`：`$string:ohos_app_name`

每个权限定义包含：
- `name`：权限名（如 `ohos.permission.ANSWER_CALL`）
- `grantMode`：`system_grant`、`user_grant` 或 `manual_settings`
- `availableLevel`：`normal`、`system_basic` 或 `system_core`（仅这 3 个值）
- `since`：引入的 API 版本
- `deprecated`：是否已废弃
- `provisionEnable`：是否通过证书预置
- `distributedSceneEnable`：是否启用分布式场景
- `label` / `description`：字符串资源引用（如 `$string:ohos_lab_answer_call`）。**可选**——仅 1072 个权限中的 68 个包含此字段（通常仅面向用户的权限）

### HAP 构建（`systemres/BUILD.gn`）

- `ohos_app_scope("main_app_res")` — AppScope 资源 + app.json
- `ohos_resources("main_res")` — main/resources，依赖 main_app_res
- `ohos_hap("systemres_hap")` — 最终 HAP；`hap_name: "SystemResources"`、`module_install_dir: "app/ohos.global.systemres"`
- 签名：本地使用 `SystemResources.p7b`；当 `sign_hap_py_path` 已定义时，使用 vendor `certificate_profile_path`，`key_alias: "OHSystemResources"`、`compatible_version: "9"`

### 资源限定词目录

`systemres/main/resources/` 下有 76 个目录：

- **基础/默认**：`base/` — 所有设备的默认资源
- **深色主题**：`dark/` — 深色模式媒体覆盖
- **设备形态**：`phone`、`tablet`、`tv`、`tv-dark`、`car`、`2in1`、`2in1-dark`、`wearable`
- **手表语言变体**：`ar-wearable`、`et-wearable`、`lv-wearable`、`mk-wearable`、`th-wearable`、`tr-wearable`
- **语言区域**（60+）：`ar`、`be`、`bg`、`bn`、`bo_CN`、`cs`、`da`、`de`、`el`、`en_GB`、`es`、`es_US`、`et`、`fa`、`fi`、`fil`、`fr`、`he`、`hi`、`hr`、`hu`、`id`、`in`、`it`、`iw`、`ja`、`ka`、`ka_GE`、`kk`、`km`、`ko`、`lo`、`lt`、`lv`、`mk`、`ms`、`my`、`my_MM`、`nb`、`nl`、`pl`、`pt`、`pt_PT`、`ro`、`ru`、`sk`、`sl`、`sr_Latn`、`sv`、`th`、`tl`、`tr`、`ug`、`uk`、`uz`、`vi`、`zh_CN`、`zh_HK`、`zh_TW`
- **伪语言区域**：`zz_ZX` — 国际化测试（用于识别未翻译/硬编码的字符串）

## OAT.xml（OSS 审计）

- **许可证文件**：`LICENSE_Fonts`（HarmonyOS Sans 字体许可协议）
- **二进制文件过滤器**：`fonts/.*` 从二进制文件策略中排除；`*.png` 描述为"自研的二进制图片"
- **项目策略**：HarmonyOS Sans 字体许可协议应用于所有路径

## Git LFS

`.gitattributes` 为大型二进制文件配置了 Git LFS：
- 通用类型：`*.tgz`、`*.apk`、`*.jar`、`*.mp4`、`*.zip`、`*.so`、`*.bin` 等
- 特定大文件：`fonts/HMOSColorEmojiCompat.ttf`、`fonts/HarmonyOS_Sans_SC.ttf`、`fonts/HMSymbolVF.ttf`、`fonts/hm_symbol_config_next.json`

## 知识路由

### 编辑前，请声明任务类别、已读文件和适用的约束。

| 任务类别 | 需读文件 | 约束 |
|----------|----------|------|
| 新增/修改资源值 | `systemres/main/resources/base/element/<type>.json` + 语言变体 | 见约束：资源命名 |
| 新增权限定义 | `systemres/main/module.json` → `definePermissions` | 见约束：权限定义 |
| 新增/修改字体 | `systemres.gni` → `sys_fonts_list`、`fonts/` | 见约束：字体管理 |
| 修改 HAP 构建 | `systemres/BUILD.gn`、`systemres.gni` | 见约束：HAP 签名 |
| 新增语言区域 | 以现有语言 `element/` 目录为模板 | 必须提供 `string.json` + `plurals.json` |

### 词汇表

| 术语 | 含义 | 位置 |
|------|------|------|
| HAP | Harmony Ability Package — 可安装的应用包 | `systemres/BUILD.gn` |
| AppScope | 应用级资源 scope（图标、应用名） | `systemres/AppScope/` |
| definePermissions | module.json 中的系统权限注册表 | `systemres/main/module.json` |
| sys_fonts_list | systemres.gni 中的字体定义数组 | `systemres.gni` |
| support_devices | 每个字体的产品过滤器（`default`/`watch`） | `systemres.gni` |
| cfp_enable | 移除 HarmonyOS_Sans_SC 的特性开关 | `systemres.gni` |
| qualifier | 语言/设备目录名（如 `zh_CN`、`dark`） | `systemres/main/resources/` |
| zz_ZX | 国际化测试用伪语言区域 | `systemres/main/resources/zz_ZX/` |
| inner_kits | 导出给其他组件的内部 API 头文件依赖 | `bundle.json` → `build.inner_kits` |
| ohos_hap | 构建 Harmony Ability Package 的 GN 模板 | `systemres/BUILD.gn` |
| ohos_resources | 编译资源文件的 GN 模板 | `systemres/BUILD.gn` |
| ohos_app_scope | 应用级 scope 资源的 GN 模板 | `systemres/BUILD.gn` |
| ohos_prebuilt_etc | 安装预构建文件的 GN 模板 | `BUILD.gn` |
| ohos_shared_headers | 共享头文件依赖的 GN 模板 | `BUILD.gn` |
| ohos_copy | 复制文件到输出目录的 GN 模板 | `BUILD.gn` |

## 约束 — 禁止 / 需确认

### 禁止

- **禁止**使用 `ohos` 前缀添加资源名——新系统资源不得使用 `ohos` 前缀（依据 PR 模板清单）
- **禁止**对开源和闭源系统资源使用相同的名称
- **禁止**将资源配置用作功能开关——资源仅用于展示，不能控制流程
- **禁止**手动编辑 `SystemResources.p7b` 签名配置文件——它是二进制证书
- **禁止**修改 `LICENSE_Fonts`——它是 HarmonyOS Sans 字体的法律协议
- **禁止**在未经确认的情况下更改 `bundle.json` 组件名（`system_resources`）或子系统（`global`）

### 需确认

- **需确认**在 `module.json` 中新增或删除权限定义——权限影响整个系统的安全模型
- **需确认**删除或重命名已存在的资源 ID——下游应用可能引用它
- **需确认**在 `sys_fonts_list` 中新增或删除字体——影响所有设备的字体渲染
- **需确认**更改 `certificate_profile_path`——影响 HAP 签名
- **需确认**修改 ROM 关键资源——每次修改 ROM 增量不得超过 1KB（依据 PR 模板清单）
- **需确认**更改 `system_resources_font_feature_product` 默认值——影响所有产品
- **需确认**更改已有权限定义的 `since` 字段——它是 API 版本契约

### 不变式

- HAP `module.json` 是权威的系统权限注册表（1072 个条目）——此处变更影响全系统
- 资源值仅用于展示——绝不能控制运行时行为
- `ohos_fonts` 目标是 `inner_kits` 头文件依赖——其他组件依赖它
- 手表设备变体使用 `alias_name` 覆盖默认输出——更改别名会破坏手表字体加载

## 验证

### 构建验证

```bash
# 完整组件构建
./build.sh --product-name rk3568 --ccache --build-target system_resources

# 仅 HAP 构建
./build.sh --product-name rk3568 --ccache --build-target //base/global/system_resources/systemres:systemres_hap

# 仅字体构建
./build.sh --product-name rk3568 --ccache --build-target //base/global/system_resources:ohos_fonts
```

### 提交前检查清单

- [ ] 构建无错误
- [ ] 如果新增资源 ID：验证不与 `base/element/*.json` 中已有 ID 冲突
- [ ] 如果新增语言区域：同时提供 `string.json` 和 `plurals.json`
- [ ] 如果修改/删除资源：评估对下游应用的兼容性影响
- [ ] 如果新增字体：在 `systemres.gni` 的 `sys_fonts_list` 中添加条目并设置正确的 `support_devices`
- [ ] 如果新增权限：提供 `label` 和 `description` 字符串引用
- [ ] ROM 增量不超过 1KB（依据 `.gitee/PULL_REQUEST_TEMPLATE.zh-CN.md`）
- [ ] 新资源名不使用 `ohos` 前缀
- [ ] PR 描述遵循 `.gitee/PULL_REQUEST_TEMPLATE.zh-CN.md` 清单

### 完成定义

任务完成需满足：
1. 构建无错误
2. PR 描述遵循 `.gitee/PULL_REQUEST_TEMPLATE.zh-CN.md` 清单
3. 所有提交前检查清单项已验证
4. 最终回复说明：改了什么、涉及哪些文件、适用哪些清单项

### 降级方案

如果无法运行构建（无 OpenHarmony 构建环境）：
1. 验证所有修改的 `.json` 文件的 JSON 有效性：`python3 -m json.tool <file>`
2. 验证修改的 `.gn`/`.gni` 文件的 GN 语法：`gn format --check <file>`（如果 GN 可用）
3. 在 PR 描述中说明构建未经验证，并列出需要构建验证的文件

## PR 流程

本仓库使用 `.gitee/PULL_REQUEST_TEMPLATE.zh-CN.md` 作为 PR 模板。模板包含：

1. **修改描述** — 描述变更及新增资源的使用场景
2. **自测试结果** — 自测结果并附截图（不涉及时说明"不涉及"）
3. **系统资源合入自检 checklist**：
   - [ ] 新增 ID 是否通过审核
   - [ ] 对比修改前后 ROM 增量是否超过 1KB
   - [ ] 如果是资源的修改或者删除，请自查影响范围，是否涉及兼容性变更
   - [ ] 资源仓的配置都是用作资源展示，不能用作开关控制
   - [ ] 新增系统资源命名不允许带 ohos 前缀
   - [ ] 开源和闭源系统资源不能使用同一个名字
