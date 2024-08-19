Community Framework adds the Lexicon, which is an interface which combines Community Framework's Codex and Collections menu, replacing the vanilla Collections menu.

The benefit of using the Lexicon is you can have an unlimited number of collections and Codex categories. Adding new collections and/or categories is as simple as a single patch operation to the `collectionsgui.config` file. Such a patch operation may look like this:

```json
{ "op" : "add", "path" : "/tabs/collections/-", "value" : {
    "name" : "Unique Equipment",
    "data" : "thea_weapons",
    "icon" : "tab_thea_weapons.png"
  }
}
```

This patch operation will add the Unique Equipment collection to the Lexicon, from the Elithian Races Mod. The `name` key specifies what the collection should be called in the interface, the `data` key specifies which collection the interface will pull information from, and the `icon` key specifies what icon should be rendered in the interface. The `icon` key can be an absolute path, or if non-absolute will begin in `/interface/scripted/collections/icons/`.

Codex categories are added in the same way, except the `path` of the patch operation should point to `/tabs/codex/-` instead of `/tabs/collections/-`.