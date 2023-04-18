Restart Wireguard stalled peers
===============================

> ℹ️ **Info**: This script can not be used on its own but requires the base
> installation of [RouterOS scripts](https://github.com/eworm-de/routeros-scripts/tree/main#routeros-scripts) from eworm-de.

Description
-----------

This script restarts (disable/enable) a wireguard peer interface if no handshake is ok in 3 minutes. If you want it will notify about the restart.
 I've created it because when my mikrotik restarts or there is a dinamic ip change, wireguard interfaces sometimes don't connect and 
stay in this state forever. Restart only happens if there is fully connectivity (default gateway is reachable, dns is resolving, time is in sync).


Requirements and installation
-----------------------------

Just install the script:

    $ScriptInstallUpdate wireguard-restart "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";

Then add a scheduler to run it periodically:

    /system/scheduler/add interval=3m name=wireguard-restart on-event="/system/script/run wireguard-restart;" start-time=startup;


Configuration
-------------

The wireguard peer to be checked/restarted needs `autorestart` word in the comment.
If you want to receive a notification every time it's restarted, add `notify` label also.
A typical comment should look like:

    "autorestart, notify"

Also notification settings are required for
[e-mail](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-email.md),
[matrix](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-matrix.md) and/or
[telegram](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-telegram.md).

---
[⬅️ Go back to main README](../README.md)  
[⬆️ Go back to top](#top)
