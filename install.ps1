<#
.SYNOPSIS
  Install Fintech Product Skills into your Claude skills directory.

.DESCRIPTION
  Run from a clone of this repo. Installs all skills by default, or only the
  ones you name. Skills are copied to ~\.claude\skills\ unless -Dest is given.

.EXAMPLE
  .\install.ps1                        # install ALL skills
  .\install.ps1 jira-ticket-writer     # install one or more named skills
  .\install.ps1 -Dest .\my-repo\.claude\skills   # project-level install
#>
[CmdletBinding()]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Skills,

  [string]$Dest = (Join-Path $HOME ".claude\skills")
)

$ErrorActionPreference = "Stop"
$RepoDir = $PSScriptRoot

# Discover skills: any top-level folder containing a SKILL.md.
$AllSkills = Get-ChildItem -Path $RepoDir -Directory |
  Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } |
  Select-Object -ExpandProperty Name | Sort-Object

if (-not $AllSkills) {
  Write-Error "No skills found (no */SKILL.md under $RepoDir)."
  exit 1
}

# Pick which skills to install.
$ToInstall = if ($Skills) { $Skills } else { $AllSkills }

New-Item -ItemType Directory -Force $Dest | Out-Null

foreach ($skill in $ToInstall) {
  $src = Join-Path $RepoDir $skill
  if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
    Write-Warning "skip '$skill' - not a skill in this repo (available: $($AllSkills -join ', '))"
    continue
  }
  $target = Join-Path $Dest $skill
  if (Test-Path $target) { Remove-Item -Recurse -Force $target }
  Copy-Item -Recurse $src $Dest
  Write-Host "  installed '$skill' -> $target"
}

Write-Host ""
Write-Host "Done. Next: open each skill's SKILL.md and fill in the <PLACEHOLDER> values."
