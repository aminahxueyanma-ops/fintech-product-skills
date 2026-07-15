# Fintech Product Skills（金融产品 Agent Skills 合集）

[English](./README.md) | **中文**

一套面向**产品与研发工作**的 [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills)，
源自真实的金融 / 支付产品实践，但都写成了**通用、可复用**的模板，任何团队都能套用。每个 skill
都是自包含的、不含任何密钥，通过替换占位符即可配置（仓库里不会提交任何 API key）。

## Skills 列表

| Skill | 作用 |
|---|---|
| [`jira-ticket-writer`](./jira-ticket-writer) | 把杂乱、中英混杂的任务描述，变成规范、结构化的英文 Jira 工单——自动判断 Story/Bug、选择 Component、定优先级（P0/P1/P2），并通过 Atlassian MCP 直接创建。 |
| [`sprint-demo-memo`](./sprint-demo-memo) | 把一个跑完的 sprint 变成面向全公司的 demo memo——拉取 Jira 工单、判断哪些可以 demo（排除合规/交易监控规则变更）、按主题分组、用口语化风格起草，并发布到 Confluence。 |

_更多 skill 陆续加入——本仓库是产品/研发类 agent skill 的合集伞。_

## 安装一个 skill

每个 skill 独占一个文件夹。把 `<skill-name>` 换成你想要的 skill（如 `jira-ticket-writer`）。

**最省事 —— 用安装脚本**（clone 一次，然后运行）：

```bash
# macOS / Linux
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
cd fintech-product-skills
./install.sh                    # 装全部  ·  或：  ./install.sh jira-ticket-writer
```

```powershell
# Windows（PowerShell）
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
cd fintech-product-skills
.\install.ps1                   # 装全部  ·  或：  .\install.ps1 jira-ticket-writer
```

脚本默认装到 `~/.claude/skills/`。想装到项目级，就指定目标目录：
`DEST=./my-repo/.claude/skills ./install.sh`（PowerShell 用 `-Dest`）。

---

想手动装？从下面几种里挑一个：

**只拉单个 skill、无 git 历史**（需要 [Node.js](https://nodejs.org)）：

```bash
npx degit aminahxueyanma-ops/fintech-product-skills/<skill-name> ~/.claude/skills/<skill-name>
```

**用 git —— macOS / Linux：**

```bash
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
mkdir -p ~/.claude/skills
cp -r fintech-product-skills/<skill-name> ~/.claude/skills/
```

**用 git —— Windows（PowerShell）：**

```powershell
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Copy-Item -Recurse "fintech-product-skills\<skill-name>" "$HOME\.claude\skills\"
```

> **一次装全部 skill：** 把复制单个 `<skill-name>` 换成整仓库 ——
> `npx degit aminahxueyanma-ops/fintech-product-skills ~/.claude/skills-src`（再把里面的 skill
> 文件夹移进 `~/.claude/skills/`），或 clone 后直接 `cp -r fintech-product-skills/*/ ~/.claude/skills/`。
>
> **想装到项目级而非用户级：** 把 `~/.claude/skills/` 换成 `<your-repo>/.claude/skills/`。

然后按各 skill 自己的 `README.md`，把其 `SKILL.md` 里的占位符换成你的配置。

## 不含任何密钥

这些 skill 都不存储凭证。凡是需要访问外部服务（如 Jira）的地方，都是通过 **MCP server** 完成的，
认证发生在 MCP 层，而不在 skill 文件里。你填进 `SKILL.md` 的那些值（项目 key、cloud ID、组件 ID 等）
只是**标识符，不是钥匙**，可以安全提交到仓库。

## 许可证

[MIT](./LICENSE) —— 详见各 skill 的 README。

## 参与贡献

欢迎提 Issue 和 PR。
