# Cardboard

The [Google Cardboard SDK](https://github.com/googlevr/cardboard) for iOS, vendored as a
prebuilt static `CardboardSDK.xcframework` (device arm64; simulator arm64 + x86_64), with a
Swift wrapper (`Cardboard` module) that is the only thing the rest of the app imports.

Eden WebXR uses the SDK as a *library*: viewer parameters, per-eye projection and eye-offset
matrices, distortion meshes and the head tracker. The SDK's own distortion renderers and QR
scanner view controller are compiled in (the C API references them) but never called; the lens
warp is drawn by the WebXR shim inside the page (`docs/vr-cardboard-design.md`).

## Contents

| Path | What |
|---|---|
| `CardboardSDK.xcframework` | `libCardboardSDK.a` per slice = SDK (`sdk/**` minus `sdk/unity/**`) + protobuf C++ runtime, `cardboard.h`, `module.modulemap` |
| `Resources/sdk.bundle` | SDK runtime resources. `resolutions.csv` maps the device model to its screen DPI, which the SDK reads through `[NSBundle bundleForClass:]` (the app's main bundle for a static library), so the **app target** copies this bundle to the top level of the app. Without it every device is treated as 326 dpi and the warp is wrong on 460 dpi phones. |
| `Sources/Cardboard` | Swift wrapper: `CardboardViewerParams` (serialized viewer profile, QR payload parsing), `CardboardLens`, `CardboardHeadTracker`, `CardboardSDKInfo` (license texts for Settings → Acknowledgements) |
| `LICENSE`, `Sources/Cardboard/Resources/LICENSE-*.txt` | Apache License 2.0 (SDK) and BSD-3-Clause (protobuf runtime) |
| `BUILD-INFO.txt` | SDK tag, protobuf version, Xcode version and date of the vendored build |

## Rebuilding the binary

```bash
Tools/build-cardboard.sh            # clones the pinned tag, pod install, builds both slices
```

Requires Xcode 27 and CocoaPods (`brew install cocoapods`; the SDK's protobuf dependency is a
pod). The script pins the SDK tag, excludes the Unity XR plugin sources that share the SDK's
Xcode target (they depend on headers under the Unity Companion License and are not needed),
raises the deployment target to iOS 17, compiles as C++20 (the SDK's `screen_params.mm` uses
`std::string::starts_with`) and merges the SDK and protobuf archives into one library per slice.
Nothing in the SDK is patched.

## Licensing

Apache License 2.0 (Google LLC) for the SDK and BSD-3-Clause (Google Inc.) for the protobuf
runtime, both permissive. The upstream `LICENSE` file also carries the Unity Companion License
for `third_party/unity_plugin_api`; nothing from that directory is built or shipped. Both license
texts are shown in the app's Acknowledgements screen (`ThirdPartyNotices`).
