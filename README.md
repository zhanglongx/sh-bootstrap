# sh-bootstrap

sh-bootstrap is a collection of scripts, user runtime file, etc. It's *ONLY* for personal use now.

## adduser

run with root or sudo.

ubuntu:

```bash
    $ adduser zhlx
    $ usermod -aG sudo zhlx
```

To avoid errors: 'BAD PASSWORD: The password is shorter than 8 characters'. Use the following:

```bash
	$ passwd --stdin <username>
```

## ssh-copy-id

```bash
    $ ssh-copy-id zhlx@<host>
```

Then edit ~/.ssh/config

```config
    Host <alias>
      HostName <host>
      [User zhlx]
      [ForwardX11 yes]
```

## install (debian)

```bash
    $ apt install vim git -y
```

## bootstrap

```bash
    $ wget -O - https://raw.githubusercontent.com/zhanglongx/sh-bootstrap/main/bootstrap.sh | bash
```
