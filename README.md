# routeros
RouterOS scripts

Install github certs chain
```
/tool/fetch url=https://raw.githubusercontent.com/martindb/routeros/main/github.io.pem dst-path=github.io.pem;
/certificate/import file-name=github.io.pem passphrase="";
```

Install custom script
```
$ScriptInstallUpdate addresslist-ip-update "base-url=https://raw.githubusercontent.com/martindb/routeros/main/";
```
