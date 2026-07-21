# Asterisk SSH WebUI — capability showcase

Безопасная демонстрация авторского WebUI для эксплуатации Asterisk через SSH.
Репозиторий содержит только обезличенные скриншоты и описание возможностей —
без исходного кода, конфигурации АТС, адресов инфраструктуры и учётных данных.

![Рабочее место оператора](screenshots/01-workspace-overview.png)

## Что демонстрирует проект

- единое рабочее место оператора с health/readiness/runtime-policy;
- PJSIP endpoint и trunk inventory;
- runtime очередей и явный owner/source-of-truth слой;
- RBAC и разделение простого/инженерного режима;
- безопасные изменения: pre-check, backup, validate, reload, acceptance, rollback;
- расписания и after-hours маршрутизация;
- operator runbook и evidence-first диагностика;
- DHCP/provisioning/notifier/XMPP как отдельные проверяемые подсистемы;
- адаптивный интерфейс для рабочего места и мобильного просмотра.

## Галерея

### PJSIP endpoint и trunk inventory

![Endpoint и trunk inventory](screenshots/02-endpoints-and-trunks.png)

### Runtime очередей и policy ownership

![Очереди и policy](screenshots/03-queues-runtime-policy.png)

### Карта слоёв и источников истины

![Карта системы](screenshots/04-system-source-of-truth-map.png)

### Операторский runbook

![Операторский runbook](screenshots/05-operator-runbook.png)

### Расписание и безопасное применение

![Расписание](screenshots/06-schedule-and-safe-change.png)

### Мобильное рабочее место

![Мобильный интерфейс](screenshots/07-mobile-operator-workspace.png)

## Архитектурный подход

```mermaid
flowchart LR
    UI[Operator / Admin WebUI] --> API[Go HTTP API]
    API --> Guard[RBAC + command/path allowlist]
    Guard --> SSH[Bounded SSH execution]
    SSH --> PBX[Asterisk CLI and configuration]
    API --> Policy[Runtime readiness and policy checks]
    API --> Evidence[Audit output and operator runbook]
    Policy --> UI
    Evidence --> UI
```

Главный принцип: интерфейс не подменяет эксплуатационную дисциплину. Опасное
изменение допускается только после pre-check и backup, а завершённым считается
после runtime/business acceptance с понятным rollback.

## Достоверность и безопасность демонстрации

Все кадры созданы Playwright при полном перехвате `/api/*` и использовании
синтетических данных. Приложение было запущено с недоступной loopback SSH-целью;
соединение с production АТС не выполнялось. Каждый скриншот явно помечен
`DEMO · SYNTHETIC DATA · NO PRODUCTION CONNECTION`.

Адреса из диапазонов `192.0.2.0/24` и `198.51.100.0/24` — специальные
документационные сети RFC 5737, а не реальные узлы.

## Как показывать на собеседовании

- Краткий сценарий: [docs/DEMO_SCRIPT_RU.md](docs/DEMO_SCRIPT_RU.md).
- Инженерные решения: [docs/ENGINEERING_NOTES_RU.md](docs/ENGINEERING_NOTES_RU.md).

## Правовой режим

Скриншоты демонстрируют проприетарное авторское ПО. Публикация этого showcase
не предоставляет право копировать, распространять или создавать производные
версии исходного продукта. © 2026 Игорь Рачков. All rights reserved.
