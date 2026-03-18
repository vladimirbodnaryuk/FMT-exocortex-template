<<<<<<< HEAD
# Онтология IWE

> Source-of-truth: `FMT-exocortex-template/ONTOLOGY.md`
> Pack-обоснование: [DP.IWE.001](https://github.com/TserenTserenov/PACK-digital-platform/blob/main/pack/digital-platform/02-domain-entities/DP.IWE.001-intelligent-working-environment.md)

## IWE (Intelligent Working Environment)

Персональная интегрированная среда для интеллектуальной работы: мышления, планирования, создания и развития при поддержке ИИ-систем, методологии и накопленных знаний. Развёртывается из этого шаблона через fork + setup.

**IWE — не инструмент, а среда.** Инструмент решает задачу. Среда формирует способ работы.

**Четыре архитектурных вида IWE** (ISO 42010 / TOGAF):

| Вид | Тип (FPF) | Элементы | Без них |
|-----|-----------|---------|---------|
| **Системы** | U.System | Claude Code, бот, MCP-серверы (knowledge-mcp, ddt), WakaTime, Git | Нет исполнения |
| **Описания** | U.Description | Экзокортекс (CLAUDE.md + memory/), Pack, промпты, методология (FPF/SPF) | ИИ = stateless, вайб-работа |
| **Роли** | U.RoleAssignment | Стратег (R1), Экстрактор (R2), Синхронизатор (R8), Пользователь | Хаос задач |
| **Артефакты** | U.Work | DS-strategy/, Pack-репо, проекты, Цифровой двойник | Нет результата |

Полная модель с таблицами по каждому виду: [LEARNING-PATH.md § 1.2](docs/LEARNING-PATH.md).

> **Почему 4 вида, а не плоский список?** IWE содержит элементы разных онтологических типов. Системы запускаются, описания загружаются, роли назначаются, артефакты производятся. Плоский список смешивает типы — категориальная ошибка (FPF A.7 Strict Distinction).

> **Почему IWE, а не «экзокортекс»?** Экзокортекс — описания и инструкции (Вид 2: Описания), один из четырёх видов. Называть всю среду «экзокортексом» = называть компьютер «жёстким диском». Подробнее: [DP.IWE.001 §2.1](https://github.com/TserenTserenov/PACK-digital-platform/blob/main/pack/digital-platform/02-domain-entities/DP.IWE.001-intelligent-working-environment.md).

## Экзокортекс (Exocortex)

Подсистема памяти и инструкций внутри IWE. Конфигурация взаимодействия пользователя с ИИ-системами через модульный CLAUDE.md и структурированную Memory.

**Состав:** CLAUDE.md + MEMORY.md + memory/*.md

## Пространства (Spaces)

| Пространство | Что | Обновление |
|-------------|-----|-----------|
| **Platform-space** | Шаблоны, промпты, протоколы, скрипты | Из upstream (update.sh) |
| **User-space** | Планы, MEMORY.md, стратегии, личные данные | Только локально |

**Ключевое различение:** Platform-space обновляется из upstream, User-space — никогда.

## Слои памяти (Memory Layers)

| Слой | Файл | Назначение | Лимит |
|------|------|-----------|-------|
| Layer 1 | `MEMORY.md` | Оперативная память: РП, навигация | ≤100 строк |
| Layer 2 | `CLAUDE.md` | Протоколы, правила, архитектура | ≤300 строк |
| Layer 3 | `memory/*.md` | Стабильные знания: различения, чеклисты, SOTA | ≤10 файлов, ≤100 строк каждый |

## Протоколы сессии

| Протокол | Фаза | Назначение |
|----------|------|-----------|
| **WP Gate** | Open | Блокирующая проверка: задача есть в плане? |
| **Ритуал согласования** | Open | Объявление работы + подтверждение |
| **Capture-to-Pack** | Work | Фиксация знаний на рубежах |
| **Close** | Close | Коммит, обновление статусов, backup |
| **Exit Protocol** | Close | Артефакт + статус + уведомление (для всех агентов) |

## Контуры системы (Platform Contours)

> Экзокортекс — часть 4-контурной системы. Ты получаешь шаблон (L3), настраиваешь под себя (L4) и подключаешься к платформе (L2).

```
L1: Ecosystem    — платформа + сообщество + все IWE пользователей + МИМ
  L2: Platform   — инфраструктура и сервисы (бот, MCP-серверы, Knowledge Index)
    L3: Template — этот шаблон (CLAUDE.md + memory/ + стратег + DS-strategy/)
      L4: Personal IWE — твой экземпляр (настроенный, с личными Pack и данными)
```

| Контур | Что для тебя | Как обновляется |
|--------|-------------|-----------------|
| **L1: Ecosystem** | Сообщество, семинары, контент | Ты участвуешь |
| **L2: Platform** | Бот, Knowledge Index, MCP | Обновляется разработчиком |
| **L3: Template** | Этот репо: формат, протоколы | `update.sh` (Platform-space) |
| **L4: Personal IWE** | Твоя работа, планы, знания | Только ты (User-space) |

**Опциональные сервисы (L3 рекомендует, L4 настраивает):**

| Сервис | Тип | Роль | Продукт |
|--------|-----|------|---------|
| knowledge-mcp | MCP-сервер | Поиск по Pack, guides, DS | Результаты hybrid search (~5400 документов) |
| ddt | MCP-сервер | Цифровой двойник ученика | Метамодель, цели, самооценка (IND.1-4) |
| WakaTime | Инструмент | Observability работы | Метрики времени по проектам |

> Подробная модель: [DS-ecosystem-development/11-platform-contours.md](https://github.com/TserenTserenov/DS-ecosystem-development)

## MCP — протокол доступа к знаниям

Claude Code подключается к 2 MCP-серверам платформы через HTTP (Cloudflare Workers). Конфигурация: `.claude/settings.local.json` → `mcpServers`. Обновляется через `update.sh`.

| MCP-сервер | URL | Инструменты |
|------------|-----|-------------|
| **knowledge-mcp** | `https://knowledge-mcp.aisystant.workers.dev/mcp` | `search`, `get_document`, `list_sources` |
| **ddt** | `https://digital-twin-mcp.aisystant.workers.dev/mcp` | `describe_by_path`, `read_digital_twin`, `write_digital_twin` |

> Поиск по руководствам: `knowledge-mcp search("запрос", source_type="guides")`. Отдельный guides-mcp не нужен.

**Принцип:** Одна база знаний — бот и экзокортекс работают с одними и теми же MCP-серверами. Поменял знание в Pack → и бот, и Claude Code сразу его видят.

## Иерархия принципов

```
Level 0: ZP (нулевые принципы)       ← аксиомы, фреймворка нет
    ↓ дисциплинируют
Level 1: FPF (первые принципы)       ← принципы + фреймворк (бандл)
    ↓ ограничивают
Level 2: SPF → Pack (вторые принципы) ← фреймворк + принципы (раздельно)
    ↓ определяют
Level 3: S2R и др. → DS              ← фреймворки + принципы (раздельно)
```

**Цепочка приоритетов (Fallback Chain):** DS (3-й) → Pack (2-й) → Base.Принципы (SPF → FPF → ZP)

## Типы репозиториев (3 типа)

| Тип | Подтип | Что содержит | Source-of-truth | Кто создаёт |
|-----|--------|-------------|-----------------|-------------|
| **Base** | Принципы | ZP, FPF, SPF — принципы и фреймворки | Да | Платформа |
| **Base** | Форматы | FMT-* — протоколы структуры | Да (для формата) | Платформа |
| **Pack** | — | Паспорт предметной области | Да | Пользователь |
| **DS** | instrument / governance / surface | Производные от Pack | Нет | Пользователь |

## Ролецентричная архитектура (DP.D.033)

Роль описывается **независимо от исполнителя**. Сначала: что делать, какие обязательства, какие рабочие продукты. Потом: кто исполняет (bash-скрипт, Claude, человек).

| Понятие | Определение |
|---------|-----------|
| **Роль** | Функция: ЧТО делать (обязательства, РП, методы) |
| **Исполнитель (holder)** | Система: КТО делает (Claude, bash, человек) |
| **Агент** | Исполнитель с автономностью (Grade 2+) |
| **Инструмент** | Исполнитель без автономности (Grade 0-1) |

**Нотация:** `Holder#Role:Context@Window` (FPF A.2)

Каталог: 21 платформенная роль (R1-R21) в DP.AGENT.001 §3.2. Cross-Pack: 35 ролей (§3.3).

**Контракт роли в шаблоне:** [roles/ROLE-CONTRACT.md](roles/ROLE-CONTRACT.md) — формальная спецификация структуры директории роли. Каждая роль описывается манифестом `role.yaml`, который обеспечивает автодискавери при установке (`setup.sh`) и обновлении (`update.sh`).

## Стратег (Strategist Agent)

Автоматический ИИ-агент, запускаемый по расписанию через launchd (macOS) или cron (Linux).

| Компонент | Путь | Назначение |
|-----------|------|-----------|
| Runner | `roles/strategist/scripts/strategist.sh` | Запуск Claude CLI с промптом |
| Промпты | `roles/strategist/prompts/*.md` | 9 сценариев (session-prep, strategy-session, day-plan, day-close, week-review...) |
| Расписание | `roles/strategist/scripts/launchd/*.plist` | LaunchAgent (утро + воскресенье) |
| Установщик | `roles/strategist/install.sh` | Копирование plist + загрузка |

## Стратегический хаб (DS-strategy)

Governance-хаб для управления задачами и стратегией.

| Компонент | Назначение |
|-----------|-----------|
| `current/` | Текущий WeekPlan, DayPlan |
| `docs/` | Strategy.md, Dissatisfactions.md, Session Agenda.md |
| `inbox/WP-*.md` | Файлы контекста РП: накопленная история работы между сессиями |
| `archive/` | Завершённые планы и контексты |
| `exocortex/` | Backup memory/ + CLAUDE.md |

**Паттерн:** Hub-and-Spoke — DS-strategy (хаб) координирует, WORKPLAN.md (споки) в каждом репо.

## Placeholder-переменные

| Переменная | Назначение | Когда |
|------------|-----------|-------|
| `vladimirbodnaryuk` | GitHub username | setup.sh |
| `/Users/admin/GIT` | Рабочая директория | setup.sh |
| `4` | Час запуска стратега (UTC) | setup.sh |
| `7:00 MSK` | Описание времени | setup.sh |
| `/opt/homebrew/bin/claude` | Путь к Claude CLI | setup.sh |
| `/Users/admin` | Домашняя директория | setup.sh |
| `-Users-admin-GIT` | Slug проекта Claude | setup.sh |

Подставляются один раз при развёртывании (setup.sh) и далее не меняются.

## Механизм обновлений

```
Авторская сторона (еженедельно):
  Авторские репо → template-sync.sh → FMT-exocortex-template (GitHub)

Пользовательская сторона (по запросу):
  FMT-exocortex-template → update.sh → git fetch upstream → merge
                                         ↓
                           CLAUDE.md → workspace root
                           memory/*.md → ~/.claude/projects/
                           (MEMORY.md НИКОГДА не перезаписывается)
```

**Platform-space (обновляется):** CLAUDE.md, 7 memory/*.md, промпты, скрипты.

**User-space (не обновляется):** MEMORY.md, DS-strategy/, личные планы.
=======
# Онтология: Экзокортекс-шаблон IWE

> Downstream-онтология по SPF.SPEC.002 §4.3.
> Ссылается на понятия Pack DP (Digital Platform) и SPF. Собственные понятия не вводит — только реализационные.
> **§1-4: Platform-space** (обновляется через `update.sh`). **§5-6: User-space** (только локально).

---

## 1. Upstream-зависимости

| Upstream | Уровень | Что используется |
|----------|---------|-----------------|
| SPF (SPF.SPEC.002) | Base | Виды сущностей, правила онтологии, аббревиатуры |
| PACK-digital-platform (DP) | Pack | Доменные понятия, различения, архитектура платформы |

---

## 2. Используемые понятия из Pack

> Ссылочные понятия из PACK-digital-platform. Определения — в Pack ontology.md. Здесь — как они используются в шаблоне.

| Термин (RU) | Term (EN) | Pack-понятие | Как используется в шаблоне |
|-------------|-----------|-------------|---------------------------|
| Среда (IWE) | Environment (IWE) | DP.CONCEPT.002 | Корневое понятие — шаблон развёртывает IWE |
| Экзокортекс-интерфейс | Exocortex Interface | DP.EXOCORTEX.001 | CLAUDE.md + memory/ — ядро шаблона |
| Platform-space | Platform-space | DP.D.011 | Файлы, обновляемые через update.sh (CLAUDE.md, memory/*.md) |
| User-space | User-space | DP.D.011 | Файлы пользователя (MEMORY.md, DS-strategy/, личные планы) |
| Экстракция знаний | Knowledge Extraction | DP.M.001 | Метод Capture-to-Pack в протоколе работы |
| Адаптивная персонализация | Adaptive Personalization | DP.M.004 | MCP ddt — цифровой двойник ученика |
| Цифровой двойник | Digital Twin | DP.CONCEPT.001 | MCP ddt — метамодель, цели, самооценка |
| Навигация знаний | Knowledge Navigation | DP.NAV.001 | MCP knowledge-mcp — hybrid search по Pack и guides |
| IPO-паттерн | IPO Pattern | DP.ARCH.001 | Контракт описания компонентов в CLAUDE.md |
| Архитектурная характеристика | Architectural Characteristic | DP.D.010 | АрхГейт (ЭМОГССБ) в CLAUDE.md §5 |
| Файл контекста РП | WP Context File | DP.EXOCORTEX.001 | inbox/WP-*.md в DS-strategy |
| Harness (упряжь) | Harness | DP.D.025 | IWE как harness для интеллектуальной работы |
| ИИ-система | AI System | DP.ROLE.001 | Claude Code, бот — исполнители ролей |
| ИТ-система | IT System | DP.SYS.001 | MCP-серверы, WakaTime — детерминированные компоненты |

---

## 3. Терминология реализации

> Собственные понятия шаблона, специфичные для реализации. Привязаны к понятиям Pack.

| Термин (RU) | Term (EN) | Определение | Pack-понятие |
|-------------|-----------|-------------|-------------|
| Слой памяти | Memory Layer | Уровень хранения инструкций экзокортекса (Layer 1: MEMORY.md, Layer 2: CLAUDE.md, Layer 3: memory/*.md) | DP.EXOCORTEX.001 |
| Контур системы | Platform Contour | Уровень вложенности IWE (L1 Ecosystem → L2 Platform → L3 Template → L4 Personal) | DP.ARCH.001 |
| Ритуал ОРЗ | ORZ Ritual | Реализация протокола сессии: Открытие → Работа → Закрытие | DP.M.003 |
| WP Gate | WP Gate | Блокирующая проверка наличия РП в плане перед началом работы | DP.EXOCORTEX.001 |
| Capture-to-Pack | Capture-to-Pack | Рубежная проверка: есть ли знание для записи в Pack | DP.M.001 |
| АрхГейт (ЭМОГССБ) | ArchGate | Обязательная оценка архитектурного решения по 7 характеристикам, порог ≥8 | DP.M.005 |
| Стратегический хаб | Strategy Hub | DS-strategy — governance-репо для планов, ревью, сессий | DP.ROLE.012 |
| Placeholder-переменная | Placeholder Variable | `{{VAR}}` — подставляется setup.sh при развёртывании шаблона | — (реализационное) |
| Контракт роли | Role Contract | role.yaml + промпты + скрипты в roles/<name>/ | DP.ROLE.001 |
| Hub-and-Spoke | Hub-and-Spoke | Паттерн координации: DS-strategy (хаб) ↔ WORKPLAN.md в каждом репо (споки) | DP.ROLE.012 |
| Творческий конвейер | Creative Pipeline | 4 стадии превращения мысли в публикацию: заметка → черновик → заготовка → пост. Каждый артефакт обязан продвинуться или быть закрыт в пределах TTL | DP.M.003 |
| Guard (страж) | Guard | Автоматическая проверка TTL-нарушений на стратегировании и Day Close | DP.EXOCORTEX.001 |
| DayPlan | DayPlan | Дневной план — артефакт Day Open. Handoff Стратег→Человек | DP.M.003 |
| WeekPlan | WeekPlan | Недельный план — артефакт стратегирования. Содержит РП, бюджеты, фокус | DP.M.003 |

---

## 4. Аббревиатуры (Platform-space)

> Аббревиатуры, используемые в шаблоне. Наследованные из upstream отмечены уровнем.

| Аббревиатура | Расшифровка (RU) | Full form (EN) | Уровень |
|-------------|-----------------|----------------|---------|
| FPF | Фреймворк первых принципов | First Principles Framework | FPF |
| SPF | Фреймворк вторых принципов | Second Principles Framework | SPF |
| UL | Единый язык | Ubiquitous Language | FPF (DDD) |
| BC | Ограниченный контекст | Bounded Context | FPF (DDD) |
| KE | Экстракция знаний | Knowledge Extraction | SPF |
| FM | Режим ошибки | Failure Mode | SPF |
| WP | Рабочий продукт | Work Product | SPF |
| IPO | Вход-Обработка-Выход | Input-Processing-Output | SPF |
| DP | Цифровая платформа | Digital Platform | Pack |
| IWE | Среда интеллектуальной работы | Intellect Work Environment | Pack |
| MCP | Протокол контекста модели | Model Context Protocol | Pack |
| ОРЗ | Открытие-Работа-Закрытие | Open-Work-Close | Pack |
| РП | Рабочий продукт (экземпляр) | Work Product (instance) | Pack |
| ЦД | Цифровой двойник | Digital Twin | Pack |
| ЭМОГССБ | 7 арх. характеристик | Evolvability, Scalability, Learnability, Generativity, Speed, Modernity, Security | Pack |
| DS | Downstream-репозиторий | Downstream Repository | Template |
| FMT | Формат (шаблон) | Format (Template) | Template |
| TTL | Срок жизни артефакта | Time To Live | Template |
| HD | Жёсткое различение | Hard Distinction | Template |
| SOTA | Современное состояние практик | State Of The Art | Template |
| SOP | Стандартная операционная процедура | Standard Operating Procedure | FPF |
| DDD | Предметно-ориентированное проектирование | Domain-Driven Design | FPF |
| CLI | Интерфейс командной строки | Command-Line Interface | общее |
| API | Программный интерфейс | Application Programming Interface | общее |
| LMS | Система управления обучением | Learning Management System | Pack |
| S2R | Формат «Системы-к-ролям» | Systems-to-Roles | SPF |
| PII | Персональные данные | Personally Identifiable Information | общее |
| RSS | Лента новостей | Really Simple Syndication | общее |
| TG | Telegram | Telegram | общее |
| ZP | Нулевые принципы | Zero Principles | Base |

---

<!-- ═══════════════════════════════════════════════════════ -->
<!-- USER-SPACE: Секции ниже НЕ обновляются через update.sh -->
<!-- ═══════════════════════════════════════════════════════ -->

## 5. Мой глоссарий

> Твои собственные понятия. Добавляй сюда термины, которые важны для твоей работы.
> Если термин окажется доменным (полезен другим пользователям) — Knowledge Extractor предложит добавить его в Pack.

| Термин (RU) | Term (EN) | Определение | Связь с Pack |
|-------------|-----------|-------------|-------------|
| _Пример: Утренний ритуал_ | _Morning Ritual_ | _Моя последовательность session-prep + day-plan_ | _DP.M.003 (протокол ОРЗ)_ |

---

## 6. Мои аббревиатуры

> Аббревиатуры, специфичные для твоей работы. Платформенные — в §4 выше.

| Аббревиатура | Расшифровка (RU) | Full form (EN) |
|-------------|-----------------|----------------|
| _ПР_ | _Пример расшифровки_ | _Example abbreviation_ |

---

_Downstream-онтология по SPF.SPEC.002 §4.3. Upstream: Pack DP (Digital Platform)_
>>>>>>> upstream/main
