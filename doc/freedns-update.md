Updates freedns.afraid.org dyndns service
=========================================

> ℹ️ **Info**: This script can not be used on its own but requires the base
> installation of [RouterOS scripts](https://github.com/eworm-de/routeros-scripts/tree/main#routeros-scripts) from eworm-de.

Description
-----------

This script evaluates if the public ip has changed and update the A record in freedns.afraid.org DNS service.
Thi only happens if there is fully connectivity (default gateway is reachable, dns is resolving, time is in sync).


Requirements and installation
-----------------------------

Just install the script:

    $ScriptInstallUpdate freedns-update "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";

Then add a scheduler to run it periodically:

    /system/scheduler/add interval=5m name=freedns-update on-event="/system/script/run freedns-update;" start-time=startup;


Configuration
-------------

The interface that has the public IP to be updated needs `freedns` word in the comment.
If you want to receive a notification every time it's restarted, add `notify` label also.

FreeDNS key must be defined in global-config-overlay as:

    :global FreeDnsKey "XXX-YOUR-KEY-XXX";


A typical comment should look like:

    "freedns, notify"

Also notification settings are required for
[e-mail](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-email.md),
[matrix](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-matrix.md) and/or
[telegram](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-telegram.md).

---
[⬅️ Go back to main README](../README.md)  
[⬆️ Go back to top](#top)
