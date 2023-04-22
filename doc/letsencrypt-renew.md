Renew LetsEncrypt SSL certificate
=================================

> ℹ️ **Info**: This script can not be used on its own but requires the base
> installation of [RouterOS scripts](https://github.com/eworm-de/routeros-scripts/tree/main#routeros-scripts) from eworm-de.

Description
-----------

This script use the little documented command `/certificate/enable-ssl-certificate` to create or renew a public cert for your mikrotik.
LetsEncrypt provides free SSL certs valid for 90 days, so I run it every 80 days. You can specify your own fqdn or use the mikrotik cloud name.

I'm using the cert for my SSTP VPN so, after renewal the script also reset the cert in the service
(this seems to be enough to work with new cert, other services may need disable/enable also).

If there are problems with renewal, it try to let your old cert in place and sends notification about the error.
Also notify you every time it is successful.


Requirements and installation
-----------------------------

Just install the script:

    $ScriptInstallUpdate letsencrypt-renew "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";

Then add a scheduler to run it every 80 days:

    /system/scheduler/add interval=80d name=letsencrypt-renew on-event="/system/script/run letsencrypt-renew;";


Configuration
-------------

Letsencrypt needs to connect back to port TCP/80 (www service), so the script enables a firewall rule for it.
The rule must exists, and be disabled, with a specific comment `IP Services HTTP`.

    /ip/firewall/filter/add action=accept chain=input comment="IP Services HTTP" disabled=yes dst-port=80 protocol=tcp place-before=1

By default script generate the certificate for the mikrotik cloud fqdn (xxxxxx.sn.mynetname.net where xxxxxx is the serial number).
You can use a custom FQDN (it must resolve to your public ip!), so the certificate will be valid only for this custom name.
Set it in your `global-config-overlay` as:

    :global LetsEncryptCN "mycustom.domain.com";

and remember to reload de configs to take efect:

    /system/script/run global-config;

And finaly run the script to get your first cert:

    /system/script/run letsencrypt-renew;

Also notification settings are required for
[e-mail](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-email.md),
[matrix](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-matrix.md) and/or
[telegram](https://github.com/eworm-de/routeros-scripts/blob/main/doc/mod/notification-telegram.md).

Notes:
- Take in consideration that letencrypt has some [rate limits](https://letsencrypt.org/docs/rate-limits), and that there is a rate limit by domain, so if you use the default mynetname.net, you can have have chances to not be alowed to create it (renew is in other limit). Just try the next day or use a custom FQDN.

---
[⬅️ Go back to main README](../README.md)  
[⬆️ Go back to top](#top)
