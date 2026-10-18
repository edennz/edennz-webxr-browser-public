import CardboardSDK
import Foundation

/// The lens model for one viewer on one screen: per-eye projection and eye-offset matrices
/// and the distortion meshes. Wraps `CardboardLensDistortion`. Not thread-safe; use it from
/// one thread (the main thread in Eden WebXR).
public nonisolated final class CardboardLens {
    public enum Eye: String, Sendable, Codable, CaseIterable {
        case left, right

        var sdkValue: CardboardEye { self == .left ? kLeft : kRight }
    }

    /// A distortion mesh in the SDK's conventions: `vertices` are (x, y) pairs in clip space
    /// of the *whole* screen (both eyes are drawn with one full-screen viewport), `uvs` are
    /// (u, v) pairs into the eye's undistorted render texture (0...1, v up) and `indices`
    /// form a single triangle strip.
    public struct Mesh: Sendable, Codable, Hashable {
        public let indices: [UInt16]
        public let vertices: [Float]
        public let uvs: [Float]

        public var vertexCount: Int { vertices.count / 2 }
    }

    private let handle: OpaquePointer
    public let viewer: CardboardViewerParams
    /// Screen size in physical pixels, landscape (width > height).
    public let displayWidth: Int
    public let displayHeight: Int

    public init?(viewer: CardboardViewerParams, displayWidth: Int, displayHeight: Int) {
        guard displayWidth > 0, displayHeight > 0 else { return nil }
        let bytes = [UInt8](viewer.encoded)
        let created: OpaquePointer? = bytes.withUnsafeBufferPointer { buffer in
            CardboardLensDistortion_create(buffer.baseAddress, Int32(bytes.count), Int32(displayWidth), Int32(displayHeight))
        }
        guard let created else { return nil }
        handle = created
        self.viewer = viewer
        self.displayWidth = displayWidth
        self.displayHeight = displayHeight
    }

    deinit {
        CardboardLensDistortion_destroy(handle)
    }

    /// Transform from head space to the eye's space (a translation of half the inter-lens
    /// distance along x), column-major.
    public func eyeFromHeadMatrix(_ eye: Eye) -> [Float] {
        var matrix = [Float](repeating: 0, count: 16)
        CardboardLensDistortion_getEyeFromHeadMatrix(handle, eye.sdkValue, &matrix)
        return matrix
    }

    /// Off-axis perspective projection for the eye, column-major (OpenGL conventions).
    public func projectionMatrix(_ eye: Eye, near: Float, far: Float) -> [Float] {
        var matrix = [Float](repeating: 0, count: 16)
        CardboardLensDistortion_getProjectionMatrix(handle, eye.sdkValue, near, far, &matrix)
        return matrix
    }

    /// Half-angles in radians: left, right, bottom, top. Their tangents span the eye's
    /// render texture, which is what the distortion mesh samples.
    public func fieldOfView(_ eye: Eye) -> [Float] {
        var angles = [Float](repeating: 0, count: 4)
        CardboardLensDistortion_getFieldOfView(handle, eye.sdkValue, &angles)
        return angles
    }

    public func distortionMesh(_ eye: Eye) -> Mesh {
        var mesh = CardboardMesh()
        CardboardLensDistortion_getDistortionMesh(handle, eye.sdkValue, &mesh)
        let indexCount = Int(max(0, mesh.n_indices))
        let floatCount = Int(max(0, mesh.n_vertices)) * 2
        let indices = UnsafeBufferPointer(start: mesh.indices, count: indexCount).map { UInt16(clamping: $0) }
        let vertices = Array(UnsafeBufferPointer(start: mesh.vertices, count: floatCount))
        let uvs = Array(UnsafeBufferPointer(start: mesh.uvs, count: floatCount))
        return Mesh(indices: indices, vertices: vertices, uvs: uvs)
    }

    /// The projection the SDK builds from a field of view (`Matrix4x4::Perspective`), for
    /// callers that recompute it for other near/far planes without a round trip. The WebXR
    /// shim ports this formula to JS; the unit tests pin the two to each other.
    public static func projectionMatrix(fieldOfView angles: [Float], near: Float, far: Float) -> [Float] {
        precondition(angles.count == 4, "fieldOfView needs left, right, bottom, top")
        let xLeft = -tan(angles[0]) * near
        let xRight = tan(angles[1]) * near
        let yBottom = -tan(angles[2]) * near
        let yTop = tan(angles[3]) * near
        var m = [Float](repeating: 0, count: 16)
        m[0] = (2 * near) / (xRight - xLeft)
        m[5] = (2 * near) / (yTop - yBottom)
        m[8] = (xRight + xLeft) / (xRight - xLeft)
        m[9] = (yTop + yBottom) / (yTop - yBottom)
        m[10] = (near + far) / (near - far)
        m[11] = -1
        m[14] = (2 * near * far) / (near - far)
        return m
    }
}
