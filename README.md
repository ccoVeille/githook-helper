# Naive and native githook implementation in shell

## Inspired by <https://github.com/mjackson> gist

Code has been copied from <https://gist.github.com/mjackson/7e602a7aa357cfe37dadcc016710931b>
adapted a bit, then modification were made according to shellcheck recommendation

## Requirements

- sh

## How to use it

- Copy this file in your .git/hooks folder
- create symbolic links such as

```shell
ln -s ../multiple-git-hooks.sh .git/hooks/pre-commit
mkdir .git/hooks/pre-commit.d/
```

then place any hook you want to install in .git/hooks/pre-commit.d/ folder

the code will be run

You can do the same for any other hooks: post-commit, prepare-commit-msg,
pre-push ...

## Disclaimer

This project was a way for me to code something in pure shell without any dependencies

There are a lot of better projects than this one, such as <https://pre-commit.com/>

Please note this project use pre-commit to validate code
