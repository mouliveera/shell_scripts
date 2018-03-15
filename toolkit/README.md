
MouliVeera Bash Toolkit
=====================

This is a tool I built for myself to help me with setting up bash environments on new systems. Feel free to use it.

Feel free to submit pull requests. I am open minded to changes as well, generally, especially from people who are better than me at Bash.

Warning!
--------

This toolkit is designed to overwrite your existing bash environment, so please do not run this unless you have safely backed up your bash environment. It will attempt to save your bash environment as `~/.bashrc.orig` but this will only work the first time you run setup. The following time it will overwrite it.

Setup
-----

You MUST have: 

- Linux
- MacOSX

This will not work on Windows. I have tested it on both Mac and Linux and it works fine. You might be able to have it work in `git_bash` on windows but I am not guaranteeing anything.

To setup:

```

git clone https://github.com/mveera/toolkit

cd toolkit
bash setup.sh
```

Voila!

Bash Includes
-------------

There are a number of bash scripts included here, which [you can learn about here](bash/includes/README.md).

Q/A
---

1. Why did you make this? Watabout zsh or "$x" new bash terminal environment sweetener.
  * `I like to make my own stuff. Bash environments are pretty eaasy to make, and it's fun to practice my bash skills.`

2. Why the `~/.bash_includes` directory?
  * `I accidentally overwrote a ton of cool tools I built into my bashrc the other day, and to prevent that from happening again, I created a non-standard directory from which I can source my scripts from the bashrc. Also, it's just a better way of organizing scripts. Large bashrc files are ugly.`


