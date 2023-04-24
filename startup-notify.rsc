#!rsc by RouterOS
# RouterOS script: startup-notify
#
# just send a notification if it's executed
# https://github.com/martindb/routeros/blob/main/doc/startup-notify.md

:local 0 "startup-notify";
:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }

:global SendNotification;
:global SymbolForNotification;

$LogPrintExit2 debug $0 "Init" false;

$SendNotification ([$SymbolForNotification "warning-sign"] . "Mikrotik restarted")  ("Current uptime is " . [/system/resource/get uptime]);

$LogPrintExit2 debug $0 "End" false;
