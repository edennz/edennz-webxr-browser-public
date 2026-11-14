---
title: Privacy Policy
permalink: /privacy/
---

# Eden WebXR Browser Privacy Policy

_Last updated: 2026-11-14. Applies to Eden WebXR Browser version 1.x._

Eden WebXR Browser is a web browser for iPhone and iPad published by **Eden Networks Ltd**,
5 Hurst Seager Lane, Christchurch 8081, New Zealand ("we", "us"). This policy explains what the
app does with information. The short version: **the app sends us nothing about you or your
browsing, and everything it remembers stays on your device.** The one request it makes to us is
a daily check for a new message of the day, which carries no identifier and is described below.
If you choose, that check also tells us your device model and iOS version.

## What the app stores on your device

* **Browsing history** (page addresses, titles, visit times) so you can revisit pages.
* **Bookmarks** you save.
* **Open tabs**, so they are restored when you reopen the app.
* **Settings** (search engine, homepage, privacy options, the paired VR viewer).
* **Website data** (cookies, caches, local storage) created by the websites you visit, managed
  by Apple's WebKit engine exactly as in Safari.

You can delete all of this at any time: Library → History → Clear, swipe to delete bookmarks,
and Settings → Clear Website Data. Private tabs store nothing after they are closed. Deleting
the app deletes everything.

We cannot see any of this data. It is not backed up to our servers, and no server of ours
receives it.

## Camera

Eden WebXR Browser asks for camera access for these features:

* **Augmented reality (WebXR):** when a website starts an AR session, the camera image is shown
  behind the page and used by Apple's ARKit to track the device's position. Camera images are
  processed live on the device, are **never saved and never sent anywhere**, and are **not made
  available to the website** as images. Websites receive only the device's position, the
  estimated lighting, the surfaces you point at and, when they ask for them, the positions of
  your hand joints and the depth map, both described below.
* **Hand tracking (WebXR):** when a website's AR session uses hand tracking, the app finds your
  hands in the camera image on your device and gives the website the positions of your hand
  joints, nothing else; no camera image leaves your device. Settings → WebXR lets you turn
  hand tracking off, or keep it on without using the camera.
* **Depth sensing (WebXR):** on devices with a LiDAR scanner, a website's AR session can ask for
  depth sensing. The website then receives, for as long as the session runs, a low-resolution map
  of how far away the surfaces in front of the camera are. It contains distances only, no image
  and no color, and it shows the shape of the space around you. The app does not save it or send
  it anywhere else; what a website does with it is covered by that website's own privacy policy.
  Settings → WebXR lets you turn depth sensing off.
* **QR code scanning:** the camera is used to read a QR code so the link in it can be opened.
  Nothing is stored.
* **Websites' video and voice features:** a website (for example a video-chat page) can ask to
  use the camera or microphone. iOS first asks whether Eden WebXR Browser may use them, and the
  browser then asks whether that particular website may. Audio and video go directly to the
  website you allowed; the app itself never records or stores them.

You can withdraw camera or microphone access in iOS Settings → Privacy & Security.

## Virtual reality

During a VR session with a Cardboard viewer, the app reads the device's motion sensors to follow
where you are looking. The readings are used live and are never stored or transmitted. If you
pair a viewer by scanning its QR code and the code holds a short link rather than the viewer's
settings, the app follows that link over an encrypted connection, without cookies, to read the
settings, and keeps them on your device. This happens only when you scan a code.

## Message of the day

Once a day, the first time you open or return to the app, it asks our server whether there is a
new announcement to show you. The request travels over an encrypted connection with no cookies
and no account or device identifier. It carries only the number of the last message you were
shown, whether this is the app's first check of the calendar month, the app version and, if you
share them (see below), your device model and iOS version.

Our server records each request with its date, the country and region it came from as
determined by our hosting provider (Cloudflare) from the connection, the data center that
answered, and the app version. It does not store your IP address, and the records contain
nothing that identifies you or your device. We use them to count how many devices use the app
each day and each month, and where. Records are deleted after 13 months. If the check fails,
the app simply tries again the next day.

Cloudflare, which runs our server, also keeps short-lived operational logs of the requests it
handles. These can include the IP address of the connection and the details of the request. We
keep them switched on so that we can investigate and respond to security incidents and service
problems, and we use them for nothing else. Cloudflare deletes them automatically after at most
7 days, and we do not copy them into our records.

### Sharing device information

On the third time you open the app, it asks whether you would like to help improve it by sharing
your device's model (for example "iPhone16,1") and iOS version. If you agree, the daily check
includes them and our server records them with the other details of that check. We use them to
decide which devices and iOS versions to test and support. They contain nothing that identifies
you or tells your device apart from others of the same model. If you decline, the app does not ask
again. You can change your choice at any time in Settings → About → Share Device Information;
turning it off stops sharing from the next check. Because the records cannot be linked to you,
we cannot find and delete the ones already made; they are deleted with the other records.

## Reporting a problem

**Report a Problem** in the … menu opens, in a browser tab, a new issue form on our public
GitHub repository, with the page address you were on, your device model, your iOS version and
the app version already filled in. To fill them in, the app puts those details in the link it
opens, so GitHub receives them when the form loads. Nothing is published until you submit the
form, and you can change or remove any of it first. Reports are public and are handled by GitHub
under its own privacy policy, so please leave personal information out of them.

## Search suggestions

As you type in the address bar, Eden WebXR Browser can show suggestions from your chosen search
engine. To do this it sends the text you have typed so far to that search engine (for example
DuckDuckGo) over an encrypted connection, without cookies or any account identifier. The search
engine handles that request under its own privacy policy. We never see it. Suggestions are not
requested in private tabs, and you can turn them off in Settings → Search Suggestions. Matches
from your bookmarks, history and open tabs are found on your device only.

## Fraudulent website warning

Eden WebXR Browser uses the fraudulent website warning built into iOS, the same one Safari uses.
Before a website opens, iOS checks it against lists of websites suspected of phishing or of
spreading malware, and if the website is on one, the app shows a warning in its place. To make
the check, iOS may send information calculated from the website's address to Google Safe
Browsing and to Apple. Apple states that the address itself is never shared with the safe
browsing provider, and that Google may log your IP address when this information is sent. If
your device's region (iOS Settings → General → Language & Region) is set to China mainland or
Hong Kong, Tencent Safe Browsing may also be used, and Tencent may likewise log your IP address.
These checks are made by iOS, not by the app, and are handled under
[Apple's description of Safari and privacy](https://www.apple.com/legal/privacy/data/en/safari/)
and the safe browsing providers' own policies. The app receives nothing from them and we never
see them.

The warning is on by default, as in Safari, and applies to private tabs too. You can turn it off
in Settings → Privacy → Fraudulent Website Warning. With it off, websites are not checked and no
warning is shown. The change applies to every open tab from its next page load.

## Location

Eden WebXR Browser never asks for your location for its own purposes. A website can ask for it
through the standard web geolocation feature. When that happens iOS first asks whether Eden
WebXR Browser may use your location at all, and the browser then asks whether that particular
website may have it. Your location is only passed to a website you have allowed, is not stored
by the app, and never reaches us. You can withdraw the app-level permission in iOS Settings →
Privacy & Security → Location Services.

## Websites you visit

Websites you open in Eden WebXR Browser are operated by third parties and may collect
information under their own privacy policies. Eden WebXR Browser applies WebKit's built-in
protections. If you enable **Global Privacy Control** in Settings, pages see
`navigator.globalPrivacyControl = true`, which asks websites not to sell or share your data where
that signal is legally recognized.

## What we do not do

* No advertising, no tracking, and no third-party analytics, crash reporting or other SDKs that
  send data anywhere. The only usage figures we have are the daily message-of-the-day counts
  described above, including the device information you may choose to share, which contain no
  identifiers.
* No account, no sign-in, no cloud sync in this version.
* We do not sell or share personal information.

## Children

Eden WebXR Browser is rated 16+ on the App Store because it provides unrestricted web access. It
is not directed at children.

## Your rights

Our records contain no identifier and cannot be linked to you, and everything else stays on
your device, so there is nothing for us to access, correct or delete on your behalf. The only
exception is Cloudflare's operational logs, which are deleted automatically within 7 days.
The controls above let you do so yourself. If you have questions or concerns, contact our Privacy
Officer at <info@eden.net.nz>. You may also contact the New Zealand Office of the Privacy
Commissioner (privacy.org.nz) or, in the EU/UK, your local data protection authority.

## Changes

If a future version adds optional accounts or sync, this policy will be replaced before that
version is released, and the app will ask you before any data leaves your device. Smaller
changes are announced through the message of the day.

Contact: Eden Networks Ltd, 5 Hurst Seager Lane, Christchurch 8081, New Zealand, <info@eden.net.nz>.
