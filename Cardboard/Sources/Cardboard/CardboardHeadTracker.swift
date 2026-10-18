import CardboardSDK
import Foundation
import simd

/// Sensor-fusion head tracker (CoreMotion gyroscope and accelerometer, with prediction and a
/// neck model). Wraps `CardboardHeadTracker`. Not thread-safe; use it from one thread.
public nonisolated final class CardboardHeadTracker {
    /// The orientation of the display the pose is expressed for. Named after
    /// `UIDeviceOrientation`, which is the *opposite* of the matching `UIInterfaceOrientation`
    /// (an interface locked to landscape-right is a device held landscape-left).
    public enum ViewportOrientation: Sendable {
        case landscapeLeft, landscapeRight, portrait, portraitUpsideDown

        var sdkValue: CardboardViewportOrientation {
            switch self {
            case .landscapeLeft: kLandscapeLeft
            case .landscapeRight: kLandscapeRight
            case .portrait: kPortrait
            case .portraitUpsideDown: kPortraitUpsideDown
            }
        }
    }

    /// A head pose in the SDK's convention, used by its own samples as
    /// `view = translation(position) × rotation(orientation)`; invert that for a head-to-world
    /// transform. `position` is the neck-model offset (there is no positional tracking).
    public struct Pose: Sendable {
        public let position: SIMD3<Float>
        public let orientation: simd_quatf
    }

    private let handle: OpaquePointer
    public private(set) var isTracking = false

    public init() {
        handle = CardboardHeadTracker_create()
    }

    deinit {
        CardboardHeadTracker_destroy(handle)
    }

    public func resume() {
        CardboardHeadTracker_resume(handle)
        isTracking = true
    }

    public func pause() {
        CardboardHeadTracker_pause(handle)
        isTracking = false
    }

    /// Makes the current heading the forward direction.
    public func recenter() {
        CardboardHeadTracker_recenter(handle)
    }

    /// Predicted pose at `timestampNanoseconds` on the `CLOCK_UPTIME_RAW` clock (see `now`).
    public func pose(at timestampNanoseconds: Int64, viewportOrientation: ViewportOrientation) -> Pose {
        var position = [Float](repeating: 0, count: 3)
        var orientation = [Float](repeating: 0, count: 4)
        CardboardHeadTracker_getPose(handle, timestampNanoseconds, viewportOrientation.sdkValue, &position, &orientation)
        return Pose(
            position: SIMD3(position[0], position[1], position[2]),
            orientation: simd_quatf(ix: orientation[0], iy: orientation[1], iz: orientation[2], r: orientation[3])
        )
    }

    /// The tracker's clock: `CLOCK_UPTIME_RAW` in nanoseconds, the same time base as
    /// `CACurrentMediaTime()`, `CADisplayLink` timestamps and CoreMotion sample timestamps.
    public static var now: Int64 {
        Int64(clock_gettime_nsec_np(CLOCK_UPTIME_RAW))
    }

    /// Converts a `CACurrentMediaTime()`-based timestamp (seconds) to tracker nanoseconds.
    public static func nanoseconds(mediaTime: TimeInterval) -> Int64 {
        Int64((mediaTime * 1_000_000_000).rounded())
    }
}
