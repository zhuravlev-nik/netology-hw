# Домашнее задание к занятию "`Инструменты Git`" - `Журавлев Николай`

### Задание

В клонированном репозитории:

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

2. Ответьте на вопросы.
    * Какому тегу соответствует коммит?
    * Сколько родителей у коммита b8d720? Напишите их хеши.
    * Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами v0.12.23 и v0.12.24.
    * Найдите коммит, в котором была создана функция func providerSource, её определение в коде выглядит так: func providerSource(...) (вместо троеточия перечислены аргументы).
    * Найдите все коммиты, в которых была изменена функция globalPluginDirs.
    * Кто автор функции synchronizedWriters?

В качестве решения ответьте на вопросы и опишите, как были получены эти ответы.

### Решение 1
1. `git show --quiet --format="%H %s" aefea` - хеш `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`


2.
    * `git show 85024d3` - тег `v0.12.23`
    * `git show --pretty=format:%P -s b8d720` - 2 родителя, хеши: `6cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b`
    * `git log --oneline v0.12.23..v0.12.24` - 
      ```
      33ff1c03bb (tag: v0.12.24) v0.12.24
      b14b74c493 [Website] vmc provider links
      3f235065b9 Update CHANGELOG.md
      6ae64e247b registry: Fix panic when server is unreachable
      5c619ca1ba website: Remove links to the getting started guide's old location
      06275647e2 Update CHANGELOG.md
      d5f9411f51 command: Fix bug when using terraform login on Windows
      4b6d06cc5d Update CHANGELOG.md
      dd01a35078 Update CHANGELOG.md
      225466bc3e Cleanup after v0.12.23 release
      ```
    * Функция была добавлена в коммите `8c928e83589d90a031f811fae52a81be7153e82f`
      ```
      git log -S 'func providerSource' --pretty=format:"%H %s"
      git show 8c928e83589d90a031f811fae52a81be7153e82f
      git log -S 'func providerSource' -- provider_source.go
      ```
    * `git log -S 'globalPluginDirs' --pretty=format:"%H %s"`
      ```
      7c4aeac5f30aed09c5ef3198141b033eea9912be stacks: load credentials from config file on startup (#35952)
      65c4ba736375607b6af6c035972f7f151232b6c6 Remove terraform binary
      125eb51dc40b049b38bf2ed11c32c6f594c8ef96 Remove accidentally-committed binary
      22c121df8631c4499d070329c9aa7f5b291494e1 Bump compatibility version to 1.3.0 for terraform core release (#30988)
      7c7e5d8f0a6a50812e6e4db3016ebfd36fa5eaef Don't show data while input if sensitive
      35a058fb3ddfae9cfee0b3893822c9a95b920f4c main: configure credentials from the CLI config file
      c0b17610965450a89598da491ce9b6b5cbd6393f prevent log output during init
      8364383c359a6b738a436d1b7745ccdce178df47 Push plugin discovery down into command package
      ```
    * Автор функции - Martin Atkins
      ```
      git log -S 'func synchronizedWriters' --pretty=format:"%H %an" --reverse

      5ac311e2a91e381e2f52234668b49ba670aa0fe5 Martin Atkins
      bdfea50cc85161dea41be0fe3381fd98731ff786 James Bardin
      ```
