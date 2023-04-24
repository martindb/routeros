Notify every time Mikrotik is restarted
=======================================

> ℹ️ **Info**: This script can not be used on its own but requires the base
> installation of [RouterOS scripts](https://github.com/eworm-de/routeros-scripts/tree/main#routeros-scripts) from eworm-de.

Description
-----------

This script just send a notification when is called. As it is scheduled just to run on every startup, you will know it.

Requirements and installation
-----------------------------

Just install the script:

    $ScriptInstallUpdate startup-notify "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";

Then add a scheduler to run it periodically:

    /system/scheduler/add interval=0s name=startup-notify on-event="/system/script/run startup-notify;" start-time=startup;

Configuration
-------------

Just schedule it as described above and config the notification kind you want, check the specific documentation for it:

[e-mail](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-email.md),
[matrix](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-matrix.md) and/or
[telegram](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-telegram.md).

---
[⬅️ Go back to main README](../README.md)  
[⬆️ Go back to top](#top)
