# Eden WebXR Browser

Eden WebXR Browser brings [WebXR](https://immersiveweb.dev) to iPhone and iPad. It is a web
browser built on Apple's WebKit (the same engine as Safari) that adds the `navigator.xr` API
pages expect: augmented reality through ARKit and virtual reality through a Google Cardboard
viewer. Sites built with three.js, A-Frame, Babylon.js, `<model-viewer>` and similar frameworks
run as they do in other WebXR browsers, with no app-specific code.

Eden WebXR Browser is made by [Eden Networks Ltd](https://eden.net.nz), New Zealand.

## Features

* **Augmented reality (`immersive-ar`)** with ARKit world tracking: hit testing, anchors, DOM
  overlay, light estimation and the camera image composited behind the page's transparent WebGL
  canvas. Native controls let you leave a session at any time.
* **Virtual reality (`immersive-vr`)** on iPhone with a Google Cardboard viewer: sensor-fusion
  head tracking, stereo rendering and the lens distortion of the paired viewer. Pair any viewer
  by scanning its QR code; a tap on the screen is the viewer's button.
* **Inline WebXR** sessions and the WebXR Device API surface frameworks rely on, kept to the
  current W3C drafts.
* **A full browser**: normal and private tabs with a tab grid, bookmarks and history, find in
  page, pop-up blocking, "request desktop site", QR code scanning with a careful link policy,
  address-bar suggestions from the search engine of your choice, and website access to the
  camera, microphone and location only after you allow it per site.
* **Privacy first**: no accounts, no advertising, no third-party analytics or crash reporting.
  Browsing data stays on the device. The app contacts Eden's own server once a day for the
  message of the day, with no identifier; the [privacy policy](privacy.md) has the details.
* **Message of the day** with announcements and tips, shown once per day at most.

## Reporting a problem

Please use the [issue tracker](https://github.com/edennz/edennz-webxr-browser-public/issues) of
this repository. The *Problem report* template asks for what we need to tell a problem in the
app from a problem with a site's WebXR content: the page address, what happened, whether the
same page works in another browser, and your device, iOS and app versions. The **Report a
Problem** entry in the app's **…** menu opens that form with the page and version details
already filled in.

This is a public tracker: please leave passwords, private links and personal information out
of reports.

## What this repository contains

The app itself is not open source. This repository holds the third-party components that the
app bundles, published here so that each one's source, license and attribution are available
in full:

| Directory | What it is | License |
|---|---|---|
| `Cardboard/` | The [Google Cardboard SDK](https://github.com/googlevr/cardboard) as a prebuilt `CardboardSDK.xcframework`, with the Swift wrapper that Eden WebXR Browser uses (`BUILD-INFO.txt` records the SDK tag and the build settings) | Apache-2.0 (SDK), BSD-3-Clause (protobuf runtime), the wrapper under the same Apache-2.0 terms |
| `URLShortenerList/` | A Swift package wrapping a community-maintained list of URL-shortener hosts, used by the QR link policy | CC BY-SA 4.0 (the list), see its README for attribution |
| `.github/` | The issue templates for this tracker | — |

Each directory is a self-contained Swift package with its own `LICENSE` and `README.md`. The
same notices are shown in the app under Settings → Acknowledgements.

This repository is produced automatically from the app's private source tree (the
`ThirdParty/` directory is published whenever it changes), so pull requests here cannot be
merged directly. Issues are welcome; for changes to a vendored component, open an issue and we
will carry the change over.
