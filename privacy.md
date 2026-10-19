---
title: Privacy Policy
permalink: /privacy/
---

# Eden WebXR Browser Privacy Policy

_Last updated: [date]. Applies to Eden WebXR Browser version 1.x._

Eden WebXR Browser is a web browser for iPhone and iPad published by **Eden Networks Ltd**,
[registered address], New Zealand ("we", "us"). This policy explains what the app does with
information. The short version: **the app sends us nothing about you or your browsing, and
everything it remembers stays on your device.** The one request it makes to us is a daily check
for a new message of the day, which carries no identifier and is described below.

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
  estimated lighting, and the surfaces you point at.
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
shown, whether this is the app's first check of the calendar month, and the app version.

Our server records each request with its date, the country and region it came from as
determined by our hosting provider (Cloudflare) from the connection, the data center that
answered, and the app version. It does not store your IP address, and the records contain
nothing that identifies you or your device. We use them to count how many devices use the app
each day and each month, and where. Records are deleted after [13 months]. If the check fails,
the app simply tries again the next day.

## Reporting a problem

**Report a Problem** in the … menu opens, in a browser tab, a new issue form on our public
GitHub repository, with the page address you were on, your device model, your iOS version and
the app version already filled in. Nothing is sent until you submit the form, and you can change
or remove any of it first. Reports are public and are handled by GitHub under its own privacy
policy, so please leave personal information out of them.

## Search suggestions

As you type in the address bar, Eden WebXR Browser can show suggestions from your chosen search
engine. To do this it sends the text you have typed so far to that search engine (for example
DuckDuckGo) over an encrypted connection, without cookies or any account identifier. The search
engine handles that request under its own privacy policy. We never see it. Suggestions are not
requested in private tabs, and you can turn them off in Settings → Search Suggestions. Matches
from your bookmarks, history and open tabs are found on your device only.

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
  described above, which contain no identifiers.
* No account, no sign-in, no cloud sync in this version.
* We do not sell or share personal information.

## Children

Eden WebXR Browser is rated 16+ on the App Store because it provides unrestricted web access. It
is not directed at children.

## Your rights

We hold no information that identifies you: the message-of-the-day records contain no
identifier and cannot be linked to you, and everything else stays on your device, so there is
nothing for us to access, correct or delete on your behalf. The controls above let you do so
yourself. If you have questions or concerns, contact our Privacy Officer at
**[privacy@edennz.example]**. You may also contact the New Zealand Office of the Privacy
Commissioner (privacy.org.nz) or, in the EU/UK, your local data protection authority.

## Changes

If a future version adds optional accounts or sync, this policy will be replaced before that
version is released, and the app will ask you before any data leaves your device. Smaller
changes are announced through the message of the day.

Contact: Eden Networks Ltd, [address], [email].
