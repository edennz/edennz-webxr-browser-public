// swift-tools-version: 6.2
import PackageDescription

// Google Cardboard SDK (Apache-2.0) as a prebuilt static xcframework, plus a small Swift
// wrapper so the rest of the app never touches the C API. Rebuild the binary with
// Tools/build-cardboard.sh; see README.md for what is inside and what is excluded.
let package = Package(
    name: "Cardboard",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Cardboard", targets: ["Cardboard"])
    ],
    targets: [
        .binaryTarget(name: "CardboardSDK", path: "CardboardSDK.xcframework"),
        .target(
            name: "Cardboard",
            dependencies: ["CardboardSDK"],
            resources: [
                .copy("Resources/LICENSE-cardboard-sdk.txt"),
                .copy("Resources/LICENSE-protobuf.txt"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("InferIsolatedConformances")
            ],
            linkerSettings: [
                // What the static SDK references: CoreMotion sensors, the Metal and
                // OpenGL ES distortion renderers (compiled in, unused here), the QR
                // scanner view controller (unused here) and the C++ runtime.
                .linkedFramework("CoreMotion"),
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("OpenGLES"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("UIKit"),
                .linkedLibrary("c++"),
            ]
        ),
        .testTarget(name: "CardboardTests", dependencies: ["Cardboard"])
    ]
)
