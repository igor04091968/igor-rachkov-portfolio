#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

expected=(
  screenshots/01-workspace-overview.png
  screenshots/02-endpoints-and-trunks.png
  screenshots/03-queues-runtime-policy.png
  screenshots/04-system-source-of-truth-map.png
  screenshots/05-operator-runbook.png
  screenshots/06-schedule-and-safe-change.png
  screenshots/07-mobile-operator-workspace.png
)

for path in "${expected[@]}"; do
  [[ -s "$path" ]] || { printf 'missing=%s\n' "$path" >&2; exit 1; }
  file "$path" | rg -q 'PNG image data' || { printf 'not_png=%s\n' "$path" >&2; exit 1; }
done

if rg -n -i \
  '(BEGIN [A-Z ]*PRIVATE KEY|password[[:space:]]*=|passwd[[:space:]]*=|api[_ -]?key[[:space:]]*=|bearer[[:space:]]+[A-Za-z0-9._-]{12,}|ssh-rsa|ssh-ed25519)' \
  --glob '*.md' --glob '*.txt' --glob '*.json' --glob '*.yml' --glob '*.yaml' --glob '*.sh' \
  --glob '!scripts/verify_showcase.sh' .; then
  printf 'secret_scan=failed\n' >&2
  exit 1
fi

if rg -n -i '(DetMir|AWatch-rus|Северная нефтебаза|Отдела Телекоммуникаций СНБ)' \
  --glob '*.md' --glob '*.txt' --glob '*.json' --glob '*.yml' --glob '*.yaml' \
  --glob '!scripts/verify_showcase.sh' .; then
  printf 'organization_scan=failed\n' >&2
  exit 1
fi

if find . -type f \( -name '*.go' -o -name '*.env' -o -name '*.key' -o -name '*.pem' -o -name 'config*.json' \) -print -quit | rg -q .; then
  printf 'source_or_config_scan=failed\n' >&2
  exit 1
fi

printf 'screenshots=%s\nsecret_scan=ok\norganization_scan=ok\nsource_code=absent\n' "${#expected[@]}"
