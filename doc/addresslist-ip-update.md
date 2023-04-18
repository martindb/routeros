Update IP in IPv4 Address Lists
===============================

> ℹ️ **Info**: This script can not be used on its own but requires the base
> installation of [RouterOS scripts](https://github.com/eworm-de/routeros-scripts/tree/main#routeros-scripts) from eworm-de.

Description
-----------

This script updates IP in firewall address lists. It checks if there is internet
to try to resolve the fqdn informed in the comments. If you want it will notify about
any updated entry.

Requirements and installation
-----------------------------

Just install the script:

    $ScriptInstallUpdate addresslist-ip-update "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";

Then add a scheduler to run it periodically:

    /system/scheduler/add interval=5m name=addresslist-ip-update on-event="/system/script/run addresslist-ip-update;" start-time=startup;

Configuration
-------------

The address lists entries to be checked/updated have to be added to a list with specific comment:

    /ip/firewall/address-list add comment="fqdn=google.com" address=0.0.0.0 list=testlist

If you want to receive a notification every time it's updated, add notify label to the comment:

    /ip/firewall/address-list add comment="notify, fqdn=google.com" address=0.0.0.0 list=testlist


Also notification settings are required for
[e-mail](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-email.md),
[matrix](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-matrix.md) and/or
[telegram](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-telegram.md).

---
[⬅️ Go back to main README](../README.md)  
[⬆️ Go back to top](#top)
