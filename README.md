# ThirdParty

Home for anything bundled under a copyleft or share-alike license. Each component is its own
self-contained Swift package (Package.swift, LICENSE, README, resources) and nothing else in the
repository is allowed to be copyleft, so each directory here can be published independently:

```bash
git subtree split --prefix=ThirdParty/<Name> -b <name>
git push <public-remote> <name>:main
```

Every component must also be registered in `ThirdPartyNotices.all` (EdenCore), which drives
Settings → Acknowledgements, and listed in the root `NOTICE.md`.

| Component | License |
|---|---|
| `URLShortenerList` | CC BY-SA 4.0 |
