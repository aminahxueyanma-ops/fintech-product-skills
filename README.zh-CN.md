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

每个 skill 独占一个文件夹。把文件夹复制到你 agent 的 skills 目录：

```
# Claude Code（用户级）
~/.claude/skills/<skill-name>/

# 或项目级
<your-repo>/.claude/skills/<skill-name>/
```

然后按各 skill 自己的 `README.md`，把其 `SKILL.md` 里的占位符换成你的配置。

## 不含任何密钥

这些 skill 都不存储凭证。凡是需要访问外部服务（如 Jira）的地方，都是通过 **MCP server** 完成的，
认证发生在 MCP 层，而不在 skill 文件里。你填进 `SKILL.md` 的那些值（项目 key、cloud ID、组件 ID 等）
只是**标识符，不是钥匙**，可以安全提交到仓库。

## 许可证

[MIT](./LICENSE) —— 详见各 skill 的 README。

## 参与贡献

欢迎提 Issue 和 PR。
