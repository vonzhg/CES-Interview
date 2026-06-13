# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **经邦论策** interview series — a CES (Chinese Economists Society) program where host **冯志钢 教授** (Zhigang Feng, University of Nebraska Omaha) interviews prominent economists. Each interview follows a standardized production workflow from research to published manuscript.

## Interview Workflow

Each interview progresses through these stages:

1. **Research** — Gather scholar's CV, web profile, publications, and background
2. **Outline (采访大纲)** — Structured 60-minute interview script with 5 acts
3. **Recording** — Zoom recording producing `.mp4`, `.m4a`, and `.vtt` transcript files
4. **Drafting (访谈录)** — Multiple versioned drafts (v1→v2→v3…) in `.docx`, with `.md` as working format
5. **Final (访谈录_final)** — Polished manuscript in both `.md` and `.docx`

## Folder Naming Convention

`MM_DD_YYYY_LastName` or `MM_YYYY_LastName` — date of interview + scholar's English last name. Example: `04_03_2026_Bai`.

## Interview Outline Format (采访大纲)

All outlines follow this exact structure — do not deviate:

- **Header**: `《经邦论策》访谈大纲（第X期）` with guest name/affiliation, host, date, keywords
- **Program Structure Table (节目结构)**: Time-segmented table with columns for 时间, 板块, 主题, 核心洞察
- **Detailed Script (详细访谈脚本)**:
  - **开场白** (00–05 min): Elaborate guest introduction with credentials, achievements, and narrative framing
  - **第一幕: 学术启蒙** (~10 min): Educational journey, PhD, mentors, formative experiences
  - **第二幕: 研究方法论** (~12 min): Research approach, topic selection, theory vs. empirics
  - **第三幕: 核心贡献** (~12 min): Deep dive into major publications and current work
  - **第四幕: 学术领导** (~10 min): Editing, publishing strategy, views on the profession
  - **第五幕: 寄语后学** (~8 min): Career advice, skill priorities, book recommendation
  - **结语** (~3 min): Poetic summary, inspirational takeaway, thanks

Questions must reference the scholar's actual papers and career milestones. Tone is formal academic Chinese with conversational warmth.

## Final Manuscript Format (访谈录_final)

Polished Q&A narrative in Chinese. Transforms raw interview into readable long-form article preserving the scholar's voice while ensuring accessibility for a general educated audience.

## Key File Types

| Extension | Purpose |
|-----------|---------|
| `经邦论策_采访大纲_[Name].md` | Interview outline/script |
| `[Name]_访谈录_final.md` | Final polished manuscript (Markdown) |
| `经邦论策_[Name]_访谈录_vN.docx` | Versioned draft manuscripts |
| `.vtt` | Zoom auto-generated transcripts (WebVTT) |
| `.mp4` / `.m4a` | Zoom video/audio recordings |

## Custom Skills

The series has two paired skills covering the **outline** and **revision** stages of the production workflow:

- **`/interview-outline [folder-path]`** — automates outline creation: reads existing outlines and final manuscripts as references, deep-researches the scholar, and generates a new 大纲 in the standard format.
- **`/interview-revise [folder-path]`** — automates v1 manuscript creation from a recorded interview folder (transcript + outline + CV). Applies the established host/guest voice rules, the 5-part structural template, content discipline, and the 4-character episode-title naming convention; outputs `<Name>_访谈录_v1.md` and `经邦论策_访谈录_<姓名>_v1.docx` (via pandoc). Skill file: `.claude/skills/interview-revise/SKILL.md`.

The naming convention referenced by `/interview-revise` lives at `期号雅称命名约定.md` at the project root.

## Completed Interviews

| Episode | Scholar | Folder | Status |
|---------|---------|--------|--------|
| 1 | Fang | `12_30_2025_Fang` | Final |
| 2 | Miao Jianjun (苗建军) | `01_03_2026_Miao` | Final |
| 3 | Song Zheng (宋铮) | `01_2026_Song` | Final |
| 4 | Bai Yan (白艳) | `04_03_2026_Bai` | Final |
| 5 | Pan Jun (潘军) | `05_2026_Pan` | Outline ready |
