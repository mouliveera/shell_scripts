
[home](/README.md)

Bash Includes
=============

I will try to keep this up to date as best as possible.

git.sh
------

Environment settings for git.

| setting | value |
|---------|-------|
| push.default | matching |

history.sh
----------

History setting to make your bash history larger and easier to traverse.

marks.sh
--------

mark is a tool written somewhere else on the internet. I found it in a stackoverflow thread long ago and forget the author (sadly). 

Basically, just run `mark $name` in a directory and it will store that short string in its db `~/.marks`. Then, when you run `jump $name` it will take you back to that directory. 

Good for traversing many nested directories.

ps1.sh
------

Updates your ps1 bash handler in the terminal. Includes colors, the current directory basename, and displays your `git` or `mercurial` branch in the local directory.
