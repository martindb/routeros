#!rsc by RouterOS
# RouterOS script: wireguard-restart
#
# restart wireguard peers if there is not handshake in last 3 minutes
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

:if ([ $IsFullyConnected ] = false) do={
  $LogPrintExit2 debug $0 ("System is not fully connected, not restarting.") false;
  :return false;
}

$LogPrintExit2 debug $0 "Init" false;

:foreach Interface in=[/interface/wireguard/peers/find where comment~"autorestart" !disabled] do={
  :local InterfaceVal [/interface/wireguard/peers/get $Interface];
  :local inter ($InterfaceVal->"interface");
  :local lasthand ($InterfaceVal->"last-handshake");
  $LogPrintExit2 debug $0 ("Wireguard peer $inter last-hadshake $lasthand") false;
  $LogPrintExit2 debug $0 ("typeof " . [:typeof $lasthand]) false;
  # Check timeout or nil
  :if ($lasthand > $Timeout or [:typeof $lasthand] != "time") do={
    $LogPrintExit2 warning $0 ("Restarting $inter") false;
    /interface/wireguard/peers/disable $Interface;
    :delay 5
    /interface/wireguard/peers/enable $Interface;
    :local Comment [$ParseKeyValueStore ($InterfaceVal->"comment")];
    :local Notify ($Comment->"notify");
    :if ($Notify = true and [:typeof $lasthand] = "time") do={
      $SendNotification ([$SymbolForNotification "warning-sign"] . "Restarted " . $inter)  ("The wireguard peer was restarted because last-hanshake exceded timeout of " . $Timeout);
    }
  };
};

$LogPrintExit2 debug $0 "End" false;
