#!rsc by RouterOS
# RouterOS script: letsencrypt-renew
#
# renew letsencrypt ssl certificate and restart services
# https://github.com/martindb/routeros/blob/main/doc/letsencrypt-renew.md

:local 0 "letsencrypt-renew";
:global GlobalFunctionsReady;
:while ($GlobalFunctionsReady != true) do={ :delay 500ms; }

:global SendNotification;
:global SymbolForNotification;
:global LogPrintExit2;
:global ParseKeyValueStore;
:global IsFullyConnected;

:global LetsEncryptCN;
:local CommName;
:local WwwDisable false;
:local CertRenewed true;

$LogPrintExit2 debug $0 "Init" false;

# Custom or default dns name
:if ([:typeof $LetsEncryptCN] = "str") do={
  :set CommName ($LetsEncryptCN);
} else={
  :set CommName [/ip/cloud/get dns-name];
}

$LogPrintExit2 debug $0 ("LetsEncrypt cert for $CommName will be renewed") false;

# Check if exists the firewall rule to open port 80
:if ([:len [/ip/firewall/filter/find where comment="IP Services HTTP"]] = 0) do={
  $SendNotification ([$SymbolForNotification "cross-mark"] . "LetsEncrypt error")  ("$0: Rule for LetsEncrypt HTTP port not found");
  $LogPrintExit2 error $0 "Rule for LetsEncrypt HTTP port not found" true;
}

:if ([$IsFullyConnected] = true) do={
  # Current certificate backup and remove
  :if ([:len [/certificate/find where common-name=$CommName]] > 0) do={
    /certificate/export-certificate [/certificate/get [/certificate/find where common-name=$CommName] name] \
    file-name=("$0_bkp") type=pkcs12 export-passphrase=($0);
    /certificate/remove [/certificate/find where common-name=$CommName];
    $LogPrintExit2 debug $0 ("Backups of certificate with CN=$CommName") false;
  }

  # Ensure web service is enabled
  :if ([/ip/service/get www disabled] = true) do={ 
    $LogPrintExit2 debug $0 "Enable www service" false;
    :set WwwDisable true;
    /ip/service/set www disabled=no;
  }

  :do {
    # Enable firewall rule to open port 80
    /ip/firewall/filter/enable [/ip/firewall/filter/find where comment="IP Services HTTP"];
    # Ask for a new cert to letsencrypt
    /certificate/enable-ssl-certificate dns-name=$CommName;
    # Disable firewall rule to open port 80
    /ip/firewall/filter/disable [/ip/firewall/filter/find where comment="IP Services HTTP"];
  } on-error={
    # Disable firewall rule to open port 80
    /ip/firewall/filter/disable [/ip/firewall/filter/find where comment="IP Services HTTP"];
    # Restore previous cert from backup
    /certificate/import file-name=("$0_bkp") passphrase=($0);
    :set CertRenewed false;
    $SendNotification ([$SymbolForNotification "cross-mark"] . "LetsEncrypt error")  ("$0: Error renewing LetsEncrypt certificate. CHECK IT ASAP.");
    $LogPrintExit2 error $0 "LetsEncrypt renewal failed. CHECK IT ASAP." false;
  }

  # If cert was renewed, set it in SSTP server
  :if ($CertRenewed = true) do={
    /interface/sstp-server/server/set certificate=none;
    :delay 5;
    /interface/sstp-server/server/set certificate=[/certificate/get [/certificate/find where common-name=$CommName] name];
  }
  
  # Let www as was
  :if ($WwwDisable = true) do={ 
    /ip/service/set www disabled=yes;
    $LogPrintExit2 debug $0 "Disable www service" false;
  }

  $SendNotification ([$SymbolForNotification "warning-sign"] . "LetsEncrypt renewal OK")  ("LetsEncrypt ssl certificate ended for " . $CommName);

};

$LogPrintExit2 debug $0 "End" false;
