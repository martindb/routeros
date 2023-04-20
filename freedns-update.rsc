#!rsc by RouterOS
# RouterOS script: freedns-update
#
# update freedns.afraid.org if public IP changed
# https://github.com/martindb/routeros/blob/main/doc/freedns-update.md

:local 0 "freedns-update";
:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }

:global CurrentIp;
:global FreeDnsKey;

:global SendNotification;
:global SymbolForNotification;
:global LogPrintExit2;
:global ParseKeyValueStore;
:global IsFullyConnected;

$LogPrintExit2 debug $0 "Init" false;

:if ([$IsFullyConnected] = true) do={
  :foreach Interface in=[/interface/find where comment~"freedns" !disabled] do={
    :local InterfaceVal [/interface/get $Interface];
    :local inter ($InterfaceVal->"name");
    :local NewIp [/ip/address/get [/ip/address/find interface=$inter] address];
    $LogPrintExit2 debug $0 ("Interface $inter - NewIp: $NewIp - CurrentIp: $CurrentIp") false;
    :if ($NewIp != $CurrentIp) do={
      $LogPrintExit2 info $0 ("$inter ip changed ($CurrentIp -> $NewIp)") false;
      :do {
        /tool/fetch url=("http://freedns.afraid.org/dynamic/update.php?$FreeDnsKey");
        :local Comment [$ParseKeyValueStore ($InterfaceVal->"comment")];
        :local Notify ($Comment->"notify");
        :if ($Notify = true) do={
          $SendNotification ([$SymbolForNotification "warning-sign"] . "New public IP")  ("The public ip of $inter changed from $CurrentIp to $NewIp");
        }
        :set $CurrentIp $NewIp;
      } on-error={
        $LogPrintExit2 warning $0 ("Unable to update FreeDNS IP for $inter") false;
        $SendNotification ([$SymbolForNotification "cross-mark"] . "FreeDNS error")  ("$0: Unable to update FreeDNS IP for $inter");
      }
    };
  };
}

$LogPrintExit2 debug $0 "End" false;
