# Jira Ticket Writer —— 一个 Agent Skill

[English](./README.md) | **中文**

把杂乱、半成品式的任务描述，变成规范、结构清晰的英文 Jira 工单，并直接在 Jira 里创建。
粘一段随手写的笔记（中文、英文或中英混杂都行），skill 会起草一条像样的 **Story** 或 **Bug**，
选好对应的 **Component**，自动定 **优先级（P0/P1/P2）**，再通过 Atlassian MCP 直接提交。

以 [Claude Agent Skill](https://docs.claude.com/en/docs/claude-code/skills) 形式构建。可在
Claude Code 以及其它支持 skills 的 agent 运行环境中使用。

## 它能做什么

- **看得懂杂乱输入** —— 一堆 bullet、聊天片段、中英混杂、模糊抱怨，它读的是意图，不是关键词。
- **只问一个澄清问题** —— 始终先确认需求由谁提出（姓名 + 角色），让工单有明确归属。
- **把工单结构化** —— Background / Business Value / Objective / Additional Notes，统一的行文风格，一律用英文。
- **自动分类** —— Story 还是 Bug、选哪个 Component、按一套明确可审计的框架定优先级（告别"什么都很紧急"）。
- **替你提交** —— 通过 Atlassian MCP 在 Jira 里创建工单，并返回工单号 + 链接。

## 前置要求

- 一个支持 skills 的 agent 运行环境（如 Claude Code）。
- 已连接 **Atlassian MCP**，且有在你项目里创建工单的权限。

## 认证

**这个 skill 不存储、也不需要任何 API key。** 它从不直接调用 Jira REST API，而是通过
**Atlassian MCP** 创建工单，认证完全发生在 MCP 层，不在这个 skill 里。

- **官方 Atlassian MCP 走 OAuth。** 在 agent 里连接一次、在浏览器授权你的 Atlassian 账号即可
  —— 不用粘贴 token，这里没有任何密钥要配。
- **你填进 `SKILL.md` 的那些值**（`<YOUR_PROJECT_KEY>`、`<YOUR_ATLASSIAN_CLOUD_ID>`、
  组件/优先级 ID）都是**标识符，不是凭证** —— 可以安全提交，哪怕是公开仓库。把它们当地址，而不是钥匙。
- **如果你用的是第三方 Jira MCP**（靠 API token 而非 OAuth），那 token 是配在
  **你自己的 MCP server 配置**里，绝不进这个 skill 文件。无论哪种方式，这个 skill 都不含密钥。

所以使用者要做的只有两件事：(1) 连接并授权 Atlassian MCP；(2) 把下面这些标识符填好。

## 安装

**最快 —— 无 git 历史**（需要 [Node.js](https://nodejs.org)）：

```bash
npx degit aminahxueyanma-ops/fintech-product-skills/jira-ticket-writer ~/.claude/skills/jira-ticket-writer
```

**用 git —— macOS / Linux：**

```bash
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
mkdir -p ~/.claude/skills
cp -r fintech-product-skills/jira-ticket-writer ~/.claude/skills/
```

**用 git —— Windows（PowerShell）：**

```powershell
git clone https://github.com/aminahxueyanma-ops/fintech-product-skills.git
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Copy-Item -Recurse "fintech-product-skills\jira-ticket-writer" "$HOME\.claude\skills\"
```

装到项目级的话，把 `~/.claude/skills/` 换成 `<your-repo>/.claude/skills/`。

## 配置（首次使用前必做）

这个 skill 自带一个**金融交易平台作为示例**，方便你看懂结构。使用前，打开 `SKILL.md`，
把占位符换成你自己项目的值：

| 占位符 | 是什么 | 去哪找 |
|---|---|---|
| `<YOUR_PROJECT_KEY>` | 你的 Jira 项目 key（如 `PROJ`） | Jira → Project settings → Details |
| `<YOUR_ATLASSIAN_CLOUD_ID>` | 你的 Atlassian 站点 cloud ID | Atlassian MCP `getAccessibleAtlassianResources`，或 `https://<your-domain>.atlassian.net/_edge/tenant_info` |
| `<your-domain>` | 你的 Atlassian 子域名 | `https://xxx.atlassian.net` 里的 `xxx` |
| **Component 表** | 你的组件 + ID | `/rest/api/3/project/<KEY>/components` |
| **Priority 表** | 你的优先级方案 ID | `/rest/api/3/priority` |

然后把 **Product Context**、**Component Selection**、**Priority Framework** 几节调整成
你自己产品和团队的惯例。完整说明在 `SKILL.md` 底部的
"Configure this for your project" 一节。

## 用法

装好并配置完，直接跟你的 agent 说话即可：

> 写个 jira 工单：官网的 contact-us 表单提交后不显示成功提示，用户老是重复提交

skill 会先问是谁提出的，然后起草，并在你确认后创建工单。

## 自定义优先级框架

内置的 P0/P1/P2 框架是刻意"有主见"的 —— 它就是为了遏制优先级虚高。核心规则：
**P0 只留给"生产环境已经出问题"或"leadership 明确确认最高优先级"的事。**
按你团队实际怎么分级，去 `SKILL.md` 里调整定义即可。

## 许可证

[MIT](../LICENSE)

## 参与贡献

欢迎提 Issue 和 PR —— 尤其欢迎不同的优先级框架、输出格式，或对接其它工单系统的适配。
