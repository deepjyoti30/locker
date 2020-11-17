# Locker

<img src=".github/locker.gif">

<div align="center">
<pre style="background: none !important;font-weight:bold!important;">
   __            _             
  / /  ___   ___| | _____ _ __ 
 / /  / _ \ / __| |/ / _ \ '__|
/ /__| (_) | (__|   <  __/ |   
\____/\___/ \___|_|\_\___|_|   

<br>
Just another naive locker for *nix
</pre>
<br/>

[![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-red?style=for-the-badge)]() [![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE.md)

</div>

## Why this

I was just reading a book and then I found out that we can change the permissions of a directory to none for all the users and that basically doesn't let any program except rm access the directory.

Hence, I created a small, naive script that just adds the ability to change those permissions with a password, which means that the dir can be __locked__ using the password.

## Dependencies

Are you kidding me? It's written in Shell, no dependencies, enjoy.

## Installation

- Clone the repo and enter the dir

   ```git clone https://github.com/deepjyoti30/locker && cd locker```

- Install using make

   ```make install```

## Usage

```console
Usage: locker OPERATION DIR [--help]

Positional arguments:

  OPERATION: Either of [lock] or [unlock] can be passed.
  DIR: Directory to operate on.

Optional arguments:

  --help: Show this message and exit

```

## Credits

Probably the book ```UNIX: concepts and applications``` by Sumitabha Das.
