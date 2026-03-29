# Lab 2 Result Workspace

- `input/commits/` хранит входные архивы снимков.
- `scripts/` воспроизводит историю для `git` и `svn`.
- `out/` содержит сгенерированные репозитории и логи и не попадает в контроль версий.

Быстрый старт:

```bash
./scripts/build_git.sh
./scripts/build_svn.sh
```

После запуска будут созданы:

- `out/git-repo` — локальный Git-репозиторий с графом варианта 1400;
- `out/svn/repo` и `out/svn/wc` — локальный SVN-репозиторий и рабочая копия;
- `out/git-graph.txt` и `out/svn/log.txt` — текстовые логи для проверки результата.
