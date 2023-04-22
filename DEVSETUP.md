Development Setup
=================

To develop in a practice way I was trying different options for scripting in RouterOS.

Right now I'm using:
* [Visual Studio Code](https://code.visualstudio.com/download) as my main editor
  * [Mikrotik RouterOS script](https://marketplace.visualstudio.com/items?itemName=devMike.mikrotik-routeros-script) extension for coloring and code snipets
  * [ftp-sync](https://marketplace.visualstudio.com/items?itemName=lukasz-wronski.ftp-sync) extension (don't use the ftp-sync-improved, it doesn't work with mikrotik)

A very useful feature to config is to add ssh key to your mikrotik admin user, so you can use the ftp-sync extension with SCP protocol and can
login trought the Visual Studio Code terminal. Check [Mikrotik documentation about ssh access](https://help.mikrotik.com/docs/display/ROS/SSH).

My ftp-sync config uploads the .rsc file as soon as I save it, and then I can run it with `/import script-name.rsc` from the terminal connected to Mikrotik.

![Visual Studio Code demo](/images/vscode_helloworld.gif "Visual Studio Code demo")


### ftp-sync config
```
{
    "remotePath": "./",
    "host": "192.168.1.1",
    "username": "admin",
    "password": null,
    "port": 22,
    "secure": false,
    "protocol": "scp",
    "uploadOnSave": true,
    "passive": false,
    "debug": true,
    "privateKeyPath": "/PATH/TO/MY/HOME/.ssh/id_rsa",
    "passphrase": null,
    "agent": null,
    "allow": [
        "\\.rsc"
    ],
    "ignore": [
        "\\.vscode",
        "\\.git",
        "\\.DS_Store",
        "doc",
        "images"
    ],
    "generatedFiles": {
        "extensionsToInclude": [],
        "path": ""
    },
    "detailedSyncSummary": true
}
```

When the script is ready to be published, just push it to github and install/update with `$ScriptInstallUpdate` function as described in the [README.md](/README.md).

Share your development tips or setup in the [discussions](https://github.com/martindb/routeros/discussions)

Notes:
- ftp-sync extension seems a bit buggy extension. Basic functions works, but may be other functions don't work or stop working and you have to close VSCode window and start again.
