#!rsc by RouterOS
# RouterOS script: addresslist-ip-update
#
# update dinamic ips of address list if changed
# https://github.com/martindb/routeros/blob/main/doc/addresslist-ip-update.md

:local 0 "addresslist-ip-update";
:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }

:global SendNotification;
:global SymbolForNotification;
:global LogPrintExit2;
:global ParseKeyValueStore;
:global IsFullyConnected;

$LogPrintExit2 debug $0 "Init" false;

:if ([ $IsFullyConnected ] = true) do={
  :foreach ListEntry in=[/ip/firewall/address-list/find where comment~"fqdn=" !disabled] do={  
    :local ListEntryVal [ /ip/firewall/address-list/get $ListEntry ];
    :local Comment [ $ParseKeyValueStore ($ListEntryVal->"comment") ];
    :local Fqdn ($Comment->"fqdn");
    :local Notify ($Comment->"notify");
    :local OldIp ($ListEntryVal->"address");

    $LogPrintExit2 debug $0 ("Fqdn: $Fqdn - OldIp: $OldIp - Notify: $Notify") false;
    
    :do {
      :local NewIp [:resolve $Fqdn]
      $LogPrintExit2 debug $0 ("Fqdn: $Fqdn - OldIp: $OldIp - NewIp: $NewIp") false;
      :if ($NewIp != $OldIp) do={
          /ip/firewall/address-list/set $ListEntry address=$NewIp
          $LogPrintExit2 info $0 ("$Fqdn IP address changed: $OldIp -> $NewIp") false;
          :if ($Notify = true) do={
            $SendNotification ([$SymbolForNotification "warning-sign"] . "$Fqdn IP updated")  ("$0: $Fqdn IP address changed: $OldIp -> $NewIp");
          }
        }
    } on-error={
      $LogPrintExit2 warning $0 ("Unable to resolve $Fqdn") false;
      $SendNotification ([$SymbolForNotification "cross-mark"] . "Unable to resolve $Fqdn")  ("$0: can't update IP of $Fqdn");
    }
  }
}

$LogPrintExit2 debug $0 "End" false;
