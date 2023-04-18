#!rsc by RouterOS
# RouterOS script: wireguard-restart
#
# update dinamic ips of address list if changed
# https://github.com/martindb/routeros/blob/main/doc/wireguard-restart.md

:local 0 "wireguard-restart";
:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }

:global SendNotification;
:global SymbolForNotification;
:global LogPrintExit2;
:global ParseKeyValueStore;
:global IsFullyConnected;

:local Timeout 00:03:00;

$LogPrintExit2 debug $0 "Init" false;

:if ([$IsFullyConnected] = true) do={
  :foreach Interface in=[/interface/wireguard/peers/find where comment~"autorestart" !disabled] do={
    :local InterfaceVal [/interface/wireguard/peers/get $Interface];
    :local inter ($InterfaceVal->"interface");
    :local lasthand ($InterfaceVal->"last-handshake");
    $LogPrintExit2 debug $0 ("Wireguard peer $inter last-hadshake $lasthand") false;
    # Check timeout or nil
    :if ($lasthand > $Timeout or [:typeof $lasthand] = "nil") do={
      $LogPrintExit2 info $0 ("Restarting $inter") false;
      /interface/wireguard/peers/disable $Interface;
      :delay 5
      /interface/wireguard/peers/enable $Interface;
      :local Comment [$ParseKeyValueStore ($InterfaceVal->"comment")];
      :local Notify ($Comment->"notify");
      :if ($Notify = true) do={
        $SendNotification ([$SymbolForNotification "warning-sign"] . "Restarted " . $inter)  ("The wireguard peer was restarted because last-hanshake exceded timeout of " . $Timeout);
      }
    };
  };
}

$LogPrintExit2 debug $0 "End" false;
