# Лабораторная работа №2 (вариант 1400)

В этом репозитории есть:
- отчет в LaTeX;
- скрипты, которые воспроизводят историю ревизий для Git и SVN по архивам `commit0.zip ... commit14.zip`.

## Структура

- `main.tex`, `title.tex` - исходники отчета.
- `main.pdf` - собранный отчет (после компиляции).
- `lab/input/commits/` - входные архивы снимков ревизий.
- `lab/scripts/`:
  - `build_git.sh` - строит Git-историю;
  - `build_svn.sh` - строит SVN-историю;
  - `cleanup.sh` - удаляет сгенерированные артефакты;
  - `common.sh` - общие функции и проверки.
- `lab/out/` - результат работы скриптов.

## Зависимости

Нужны команды:
- `git`
- `svn`
- `svnadmin`
- `unzip`
- базовые POSIX-утилиты (`find`, `cp`, `rm`, `mktemp`)

Скрипты автоматически проверяют наличие зависимостей и всех архивов `commit0.zip ... commit14.zip` перед запуском.

## Запуск

Из корня проекта:

```bash
./lab/scripts/build_git.sh
./lab/scripts/build_svn.sh
```

После запуска появятся:
- `lab/out/git-repo` - локальный Git-репозиторий;
- `lab/out/git-graph.txt` - граф коммитов Git;
- `lab/out/svn/repo` и `lab/out/svn/wc` - SVN-репозиторий и рабочая копия;
- `lab/out/svn/log.txt` - полный лог SVN (все ревизии репозитория и отдельные секции по `trunk`, `branches/red-bottom`, `branches/blue`).

## Запуск в Windows

Если используете Windows, запускайте скрипты в Git Bash/MSYS2, а не через `C:\Windows\System32\bash.exe` (WSL).

Пример запуска через Git Bash:

```powershell
"C:\Program Files\Git\bin\bash.exe" -lc "cd /c/Users/John/Desktop/opi2 && ./lab/scripts/build_git.sh && ./lab/scripts/build_svn.sh"
```

## Пересборка отчета

```bash
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

## Очистка артефактов

```bash
./lab/scripts/cleanup.sh
```

## Примечания

- Состояния ревизий берутся строго из архивов `lab/input/commits/commitN.zip`.
- Для Git основная ветка в скриптах - `master`.
- В SVN есть служебные ревизии (`svn mkdir`, `svn copy`), поэтому номера SVN-ревизий не совпадают один-к-одному с `r0...r14`.
