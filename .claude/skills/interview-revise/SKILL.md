---
name: interview-revise
description: Generate a polished v1 manuscript and Word docx from a 经邦论策 interview folder. Reads the transcript, outline, and CV; applies the established host/guest voice rules, the 5-part structural template, content discipline, and the 4-character episode-title naming convention; outputs <Name>_访谈录_v1.md and 经邦论策_访谈录_<姓名>_v1.docx. Use when the user has a Zoom transcript ready and wants to draft the final 访谈录 (the "Drafting → Final" stage of the CES interview production workflow).
---

# /interview-revise — 《经邦论策》访谈录 v1 终稿生成

把一个完整的采访素材（逐字稿 + 大纲 + CV）整理为符合系列风格的 v1 终稿（markdown + Word docx），给嘉宾审阅。

## When to use

- 用户指向一个已完成录制的采访子文件夹（如 `05_2026_Pan/`、`06_2026_X/`），其中至少包含：
  - `采访记录.md` 或 `.vtt`（Zoom 逐字稿）
  - `经邦论策_采访大纲_*.md`（最新版大纲）
  - `CV_*.pdf` 或类似 CV 文件（嘉宾履历）
- 用户希望产出可发给嘉宾审阅的 v1 草稿

## Inputs

- 单参数：访谈子文件夹路径（绝对或相对）
- 缺省时主动询问用户

---

## Step 1: 读源材料

用 Read 工具（不要用 cat / head）读取：

- `<folder>/采访记录.md` 或 `.vtt` —— Zoom 逐字稿（可能 30k+ tokens，需分段读，用 offset/limit）
- `<folder>/经邦论策_采访大纲_*v2.md` 或同名最新版 —— 结构框架 + 人物画像
- `<folder>/CV_*.pdf` —— 论文标题、期刊、年份、合作者的**权威**来源

## Step 2: 读风格参考（绝对路径）

- `/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策/CLAUDE.md` —— 项目规则
- `/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策/期号雅称命名约定.md` —— 雅称命名规则
- `/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策/01_2026_Song/Song_访谈录_final.md` —— 风格参考
- `/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策/04_03_2026_Bai/Bai_访谈录_final.md` —— 风格参考
- `/Users/zfeng/Library/CloudStorage/OneDrive-Personal/Professional-works/CES/CES-Interviews-经邦论策/05_2026_Pan/Pan_访谈录_v1.md` —— 第 5 期校准样本（**最贴近所有风格不变量**）

---

## Step 3: 应用结构模板

完整 markdown 骨架（必须按这个层级生成）：

```markdown
# CES-[年份][4字雅称]：《经邦论策》专访[嘉宾姓名]教授

*《经邦论策》访谈录系列之[期数]*

*[3 个关键词，用 · 分隔]*

**嘉宾**：[姓名]教授（[完整 affiliation]）

**主持**：冯志钢教授（内布拉斯加大学奥马哈分校）

**出品**：中国留美经济学会

---

## 开场

**冯志钢**：CES 的读者朋友们，大家好，欢迎回到《经邦论策》。我是冯志钢。...
[嘉宾完整 bio + 人物画像句]
[嘉宾名]，欢迎您！

**[嘉宾]**：谢谢志钢，...

---

## 第一部分：[本部分主题]

### [小标题 1]

**冯志钢**：[Q1]

**[嘉宾]**：[A1]

### [小标题 2]

...

---

## 第二部分：...

...

## 第三部分：...

## 第四部分：...

## 第五部分：寄语后学

...

---

## 结语

**冯志钢**：[3–4 句排比总结嘉宾的学术品格 + 与雅称呼应的诗意收束]

**[嘉宾]**：[简短致谢]

---

*《经邦论策》由中国留美经济学会出品*
```

格式细节：

- `#` 标题（一处，含 4 字雅称）
- `##` 主部分（开场 + 第一/第二/第三/第四/第五部分 + 结语 = 共 7 处）
- `###` 小标题（每部分 2–4 个，**用 markdown header，不用 `**...**`**）
- `**冯志钢**：` / `**[嘉宾]**：` 标记说话人（中文冒号）
- `*斜体*` 用于：副标题、关键词行、出品方
- `---` 用于：主部分之间的分隔

---

## Step 4: 应用风格不变量

### 4.1 主持人冯志钢的声音规则

| 规则 | ❌ 避免 | ✅ 使用 |
|---|---|---|
| 试探 > 断言 | "让我归纳一下"、"让我厘清一下您的意思" | "我试着复述一下，看自己有没有理解到位"、"不知道我这样理解对不对？" |
| 自我披露要具体而克制 | "二三流学校"等贬义形容词 | "迈阿密大学这种…完全不在一个层级"、"自己能力有限，才只是稍稍开了点眼界" |
| 避免跨期重复 | 把同一个自陈段落（如"用 AI 做宏观"）拷贝到新一期 | 写前**先检查** Song / Bai / Pan 的 final 稿；如已出现过，换角度切入 |
| 简短桥接 > 长综合 | 用学术语言重述嘉宾刚说过的话 | 嘉宾长答后，主持人**最多一句**简洁桥接 |

**特别注意**：主持人对嘉宾的"私心问题"——比如主持人自己研究的深度展开（fiscal policy / time-consistent policy / 自己的 framework 等）——在终稿里**简化或删除**，最多保留一句"作为做宏观的同行……"作为铺垫。

### 4.2 嘉宾的声音规则

#### 保留 code-switching

嘉宾在录音里的英文金融术语**原样保留**：research、RA、friction、idea-driven、empirical-driven、playground、tenure、shock、global financial cycle 等。不翻译成中文。

#### 口语 → 典雅替换（举例）

| 录音里的口语 | 典雅化 |
|---|---|
| 把我抬得太高了 | 您过誉了 |
| 站着说话不腰疼 | 隔岸观火 |
| 把自己搞强大 | 做自己，不委屈自己（或类似温润表达） |
| 风凉话 | 隔岸观火 / 不够设身处地 |

#### 保留嘉宾"低调式自评"和真实细节

这些是人物塑造的关键，**必须保留**：
- "被自己 neglect 的 paper"
- "Bloomberg 没 cite 我们"
- "是 [合作者] 专门寄给我的签名本"
- "凭我那时候的背景，放在今天可能哪个 top program 都进不去"
- 类似的自我打趣 + 高山仰止式的反差

#### 去掉口头犹豫

录音里的"我，我，我..."、"就是说就是说"、"那个那个" 等——书面化中删除。

### 4.3 内容纪律

#### CV 校对（必做）

所有论文标题、期刊、年份、合作者**逐一对照 CV 修正**。VTT 转写常见错误样本：

| VTT 转写 | 正确版本 |
|---|---|
| "fent jumping" / "daffin" | "Affine Jump-Diffusions" |
| "kenog 的 our problem" | Kenneth Rogoff *Our Dollar, Your Problem* |
| "cancelen" | Kenneth Singleton |
| "calendar"（学者名） | 通常是 Hélène Rey（global financial cycle 框架） |
| "dynamic pricing"（书） | Darrell Duffie *Dynamic Asset Pricing Theory* |

#### 不虚构

转写没提到的事实不要写。如果需要某个事实但转写里没有，标注"待用户/嘉宾确认"，不要编造。

#### 删除

- 家常闲聊（家人、共同朋友、节日问候）
- 录制开始/结束时的调度安排（"7 月成都见"等）
- 嘉宾点评其他嘉宾的内容（除非是公开称赞且与主题相关）

#### 简化

- 主持人过长的"私心"展开 → 简化为一句铺垫
- 嘉宾对一个问题的反复绕回 → 取最清晰的那一版

---

## Step 5: 提议 4 字雅称（按 `期号雅称命名约定.md`）

三步流程：

1. **嘉宾气质关键词** —— 从大纲、CV、录音内容中提炼 3–4 个核心特征词
   - 例：潘军 = 高山仰止 · 温润如玉 · 超凡脱俗 · 专注

2. **前两字 → 时令/意象** —— 从当月可用项中选呼应嘉宾气质的
   - 月雅称对照见 `期号雅称命名约定.md`
   - 月雅称示例：孟夏（4月）、仲夏/蒲月（5月）、季夏/荷月（6月）、孟秋（7月）、仲秋/桂月（8月）...
   - 诗意意象：霁月、松风、清辉、空山、流光、寒泉...

3. **后两字 → 聚谈动词** —— 按嘉宾性格匹配
   - 内敛 / 含蓄 → 清赏、清音、清谈
   - 谦和 / 欢迎对话 → 共赏、共话
   - 叙事型 → 共话、夜话、闲话
   - 思辨型 → 问道、问学
   - 聚会感 → 雅集、围炉、听蝉

**输出**：给用户 **2–3 个候选 + 每个的命名理由（出处、契合点）**，让用户选定后再写入标题。

参考已用：
- 第 4 期：**孟夏清赏**（白艳，4 月）
- 第 5 期：**霁月共赏**（潘军，5 月；霁月光风，"奇文共欣赏"出处）

---

## Step 6: 生成产物

### 6.1 写 markdown 终稿

文件路径：
```
<folder>/<嘉宾英文姓>_访谈录_v1.md
```

例：`05_2026_Pan/Pan_访谈录_v1.md`

### 6.2 转 Word docx

```bash
/opt/homebrew/bin/pandoc "<folder>/<英文姓>_访谈录_v1.md" -o "<folder>/经邦论策_访谈录_<中文姓名>_v1.docx" --standalone
```

例：
```bash
/opt/homebrew/bin/pandoc "05_2026_Pan/Pan_访谈录_v1.md" -o "05_2026_Pan/经邦论策_访谈录_潘军_v1.docx" --standalone
```

### 6.3 pandoc 未装的兜底

```bash
arch -arm64 brew install pandoc
```

---

## Step 7: 输出报告

向用户简短汇报，包含：

1. **两份文件的路径与大小**
2. **选定的 4 字雅称及理由**（如已选定；否则列候选让用户选）
3. **关键的 CV 校正修复**（如有）—— 列出从 VTT 转写错误修复回正确名词的清单
4. **终稿前需用户/嘉宾再核实的少数事项**（如：未点名的合作学者、需核实的具体年份等）

---

## Notes

- **第 5 期 Pan_访谈录_v1.md 是当下最完整的风格样板**——结构、语气、典雅化、CV 校正都经过 25 轮反馈校准。新一期生成时**优先参考它**，其次是 Bai 和 Song。

- **不要**直接复制 Pan/Bai/Song 的具体内容到新期。结构和声音规则借鉴；每位嘉宾的具体内容必须完全来自该期的逐字稿。

- **逐字稿很大时**（>25k tokens）：分段读，每段用 Read 的 offset+limit；或先派一个 Explore subagent 做 summary，再逐段读关键段落。

- **CV 是 PDF**：用 Read 工具直接读 PDF。如 PDF 太大，用 `pages` 参数读特定页。

- **失败兜底**：如某项必备文件（CV、大纲、转写）缺失或损坏，**停下来向用户报告**，不要硬撑着继续。

- **新增内容（非转写来源）**：如必须从大纲补一段背景介绍（如开场白的 bio 段落），可以从大纲拷贝过来——但要明确标注，并避免在嘉宾 Q&A 里虚构嘉宾未说过的话。

- **完成后**：把这一期定下来的 4 字雅称写回 `期号雅称命名约定.md` 第二节"已用雅称记录"表格里，让命名约定文件保持最新。
