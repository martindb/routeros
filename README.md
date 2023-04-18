RouterOS scripts
================

> ℹ️ **Info**: These set of scripts can not be used on its own but requires the base
> installation of [RouterOS scripts](https://github.com/eworm-de/routeros-scripts/tree/main#routeros-scripts) from eworm-de.

Install
-------

After you have the base installation you will need also to install the certificate chain from github:

```
/tool/fetch url=https://raw.githubusercontent.com/martindb/routeros/main/github.io.pem dst-path=github.io.pem;
/certificate/import file-name=github.io.pem passphrase="";
```

Then you should be able to install any of my scripts in this repo, for example:

```
$ScriptInstallUpdate addresslist-ip-update "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";
```

My custom scripts
-----------------

* [Update IPs in address lists](doc/addresslist-ip-update.md)


License and warranty
--------------------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
[GNU General Public License](COPYING.md) for more details.

---

Thanks [Christian Hesse](https://github.com/eworm-de) for sharing your work!
