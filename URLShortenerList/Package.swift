// swift-tools-version: 6.0
import PackageDescription

// Self-contained wrapper around the PeterDaveHello/url-shorteners domain list.
// Everything in this directory is published separately (git subtree split)
// because the list is CC BY-SA 4.0. Keep the rest of the app out of here.
let package = Package(
    name: "URLShortenerList",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "URLShortenerList", targets: ["URLShortenerList"])
    ],
    targets: [
        .target(
            name: "URLShortenerList",
            resources: [
                .copy("Resources/list.txt"),
                .copy("Resources/LICENSE.txt"),
            ]
        ),
        .testTarget(name: "URLShortenerListTests", dependencies: ["URLShortenerList"])
    ]
)
