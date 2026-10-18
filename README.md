# ThirdParty

Home for every vendored third-party component. Anything copyleft or share-alike *must* live here
(nothing else in the repository may be); permissive binaries live here too so that their license
files, build scripts and attribution stay together. Each component is its own self-contained
Swift package (Package.swift, LICENSE, README, resources), so each directory can be published
independently:

```bash
git subtree split --prefix=ThirdParty/<Name> -b <name>
git push <public-remote> <name>:main
```

Every component must also be registered in `ThirdPartyNotices.all` (EdenCore), which drives
Settings → Acknowledgements, and listed in the root `NOTICE.md`.

| Component | License | Notes |
|---|---|---|
| `URLShortenerList` | CC BY-SA 4.0 | data list; refresh from upstream, never hand-edit |
| `Cardboard` | Apache-2.0 (SDK) + BSD-3-Clause (protobuf runtime) | prebuilt `CardboardSDK.xcframework` from `Tools/build-cardboard.sh`; Swift wrapper is ours |
