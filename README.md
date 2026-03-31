# Лабораторная работа №2 (вариант 1400)

Единый README для всего каталога `l2`: здесь и отчёт, и рабочая часть
для воспроизведения истории `git/svn`.

## Структура

- `main.tex`, `title.tex` - исходники отчёта в LaTeX.
- `main.pdf` - собранный отчёт.
- `lab/input/commits/` - архивы `commit0.zip ... commit14.zip` со снимками ревизий.
- `lab/scripts/` - скрипты воспроизведения истории:
  - `build_git.sh` - строит Git-историю варианта;
  - `build_svn.sh` - строит SVN-историю варианта;
  - `cleanup.sh` - удаляет сгенерированные артефакты;
  - `common.sh` - общие функции для сборочных скриптов.
- `lab/out/` - результаты работы скриптов (локальные репозитории и логи).

## Быстрый старт

Из корня проекта:

```bash
./lab/scripts/build_git.sh
./lab/scripts/build_svn.sh
```

После запуска появятся:

- `lab/out/git-repo` - локальный Git-репозиторий;
- `lab/out/svn/repo` и `lab/out/svn/wc` - SVN-репозиторий и рабочая копия;
- `lab/out/git-graph.txt` и `lab/out/svn/log.txt` - логи для проверки.

## Как пересобрать отчёт

```bash
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

## Примечания

- Состояния ревизий берутся строго из архивов `lab/input/commits/commitN.zip`.
- Для Git основная ветка в скриптах - `master`.
- В SVN есть служебные ревизии (`svn mkdir`, `svn copy`), поэтому номера SVN
  не совпадают один-к-одному с `r0...r14` из схемы.
