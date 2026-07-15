# Sprint Demo Memo —— 一个 Agent Skill

[English](./README.md) | **中文**

把一个跑完的 sprint，变成一份面向全公司、可以直接讲的 **demo memo**，并一键发布到 Confluence。
这个 skill 会从 Jira 拉取本 sprint 已部署的工单，判断哪些值得 demo，按主题分组，并全部用
"能直接念出来"的口语化英文起草 —— 所以这份 memo 同时也是你现场 demo 的讲稿。

以 [Claude Agent Skill](https://docs.claude.com/en/docs/claude-code/skills) 形式构建。可在
Claude Code 以及其它支持 skills 的 agent 运行环境中使用。

## 它能做什么

- **拉取 sprint** —— 通过 Atlassian MCP 从 Jira 抓取 Done/Deployed 的 Story + Bug 工单。
- **判断哪些能 demo** —— 把每条工单分为 **Business**（要展示）、**Technical / 不可 demo**
  （只进附录）、**Sensitive**（合规 / 交易监控规则变更 —— 完全排除，连附录都不放）。
- **按主题分组**，并在开写前跟你确认分组。
- **用 demo 语气起草** —— 短句、不堆企业黑话、缩写首次出现就展开，每个功能一个"人话故事"
  （What changed / Why it matters / FAQ）。
- **可选生成讲稿** —— 一份独立的、按时间和步骤编排的朗读稿，并与 memo 保持同步。
- **发布到 Confluence** —— 带"页面是否已存在"的检查，以及"写入前必须确认"这一步。

## 前置要求

- 一个支持 skills 的 agent 运行环境（如 Claude Code）。
- 已连接 **Atlassian MCP**，且有读 Jira、读写 Confluence 的权限。

## 认证

**这个 skill 里不含任何 API key。** 它通过 **Atlassian MCP** 读 Jira、写 Confluence，认证发生在
MCP 层（OAuth），不在 skill 文件里。你填进 `SKILL.md` 的那些值 —— 项目 key、cloud ID、
Confluence space ID、父页面 ID —— 都是**标识符，不是凭证**，可以安全提交。

## 安装

**最快 —— 无 git 历史**（需要 [Node.js](https://nodejs.org)）：

```bash
npx degit aminahxueyanma-ops/fintech-product-skills/sprint-demo-memo ~/.claude/skills/sprint-demo-memo
```

**用 git —— macOS / Linux：**

```bash
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
mkdir -p ~/.claude/skills
cp -r fintech-product-skills/sprint-demo-memo ~/.claude/skills/
```

**用 git —— Windows（PowerShell）：**

```powershell
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Copy-Item -Recurse "fintech-product-skills\sprint-demo-memo" "$HOME\.claude\skills\"
```

装到项目级的话，把 `~/.claude/skills/` 换成 `<your-repo>/.claude/skills/`。

## 配置（首次使用前必做）

这个 skill 自带一个**金融 / 支付产品作为示例**。打开 `SKILL.md`，把占位符换成你自己的值：

| 占位符 | 是什么 |
|---|---|
| `<YOUR_PROJECT_KEY>` / `<KEY>` | 你的 Jira 项目 key（如 `PROJ`） |
| `<YOUR_ATLASSIAN_CLOUD_ID>` | 你的 Atlassian 站点 cloud ID |
| `<YOUR_CONFLUENCE_SPACE_ID>` | 要发布到的 Confluence space |
| `<YOUR_PARENT_PAGE_ID>` | demo memo 所在的父页面 / 文件夹 |

然后把 **主题列表**、**格式标准**、**语气规则** 调整成你团队的风格。完整说明在
`SKILL.md` 的 "Configure this for your project" 一节。

## 关于合规排除逻辑

这个 skill 把**合规 / 交易监控（TM）规则变更视为永不可 demo** —— memo 正文和附录里都排除，
因为面向全公司的 demo 不该披露"什么会触发风控标记"。它会保留对合规工作流的*工具/UX*改进
（新增筛选器、导出按钮），但排除*规则逻辑*本身。对任何受监管的业务，这都是个稳妥的默认；
你可以在 Step 2 里按自己公司的披露政策调整边界。

## 用法

> sprint 跑完了 —— 帮我整理 sprint 42 的 demo memo

skill 会拉取工单，带你走完分类和分组，起草 memo（需要的话连讲稿一起），并在你确认后发布到 Confluence。

## 许可证

[MIT](../LICENSE)
