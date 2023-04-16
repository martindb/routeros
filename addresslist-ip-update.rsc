#!rsc by RouterOS
# RouterOS script: addresslist-ip-update
#
# update dinamic ips of address list if changed
# https://github.com/martindb/routeros/blob/main/addresslist-ip-update

:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }
:global SendNotification;
:global SymbolForNotification;

:local listname devlist

:local content
:local newip
:local oldip

:foreach i in=[/ip firewall address-list find list="$listname" and disabled=no] do={
  :set content [/ip firewall address-list get $i comment]
  :set oldip [/ip firewall address-list get $i address]
  :do {
    :set newip [:resolve $content]
    :if ($newip != $oldip) do={
        /ip firewall address-list set $i address=$newip
        :log info "Hostname to IP action: $content ip address changed: $oldip -> $newip"
        $SendNotification ([$SymbolForNotification "warning-sign"] . "$content ip updated")  ("addresslist-ip-update: $content ip address changed: $oldip -> $newip");
      }
    } on-error={ 
      :log info "Unable to resolve $content"
      $SendNotification ([$SymbolForNotification "warning-sign"] . "Unable to resolve $content")  ("addresslist-ip-update can't update dinamic ip of " . $content);
    }
  }
}
