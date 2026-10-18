import Cardboard
import Foundation
import Testing
import simd

struct ViewerParamsTests {
    @Test func builtInViewersDecode() {
        let v1 = CardboardViewerParams.cardboardV1
        #expect(v1.vendor == "Google, Inc.")
        #expect(v1.model == "Cardboard v1")
        let v2 = CardboardViewerParams.cardboardV2
        #expect(v2.vendor == "Google")
        #expect(v2.model == "Cardboard I/O 2015")
        #expect(abs(v2.interLensDistance - 0.0639) < 1e-4)
        #expect(abs(v2.screenToLensDistance - 0.0364) < 1e-4)
        #expect(v2.displayName == "Google Cardboard I/O 2015")
        #expect(v1 != v2)
    }

    @Test func profileURLsParseOffline() {
        #expect(CardboardViewerParams.parse(profileURL: URL(string: "https://g.co/cardboard")!) == .cardboardV1)
        #expect(CardboardViewerParams.parse(profileURL: CardboardViewerParams.cardboardV2ProfileURL) == .cardboardV2)
        let http = URL(string: CardboardViewerParams.cardboardV2ProfileURL.absoluteString.replacingOccurrences(of: "https://", with: "http://"))!
        #expect(CardboardViewerParams.parse(profileURL: http) == .cardboardV2)
        #expect(CardboardViewerParams.isProfileURL(http))
        #expect(CardboardViewerParams.parse(profileURL: URL(string: "https://example.com/cardboard/cfg?p=abc")!) == nil)
        #expect(CardboardViewerParams.parse(profileURL: URL(string: "https://google.com/cardboard/cfg?p=AAAA")!) == nil)
        #expect(!CardboardViewerParams.isProfileURL(URL(string: "https://goo.gl/abc")!))
    }

    @Test func qrPayloadsBecomeHTTPSURLs() {
        #expect(CardboardViewerParams.url(fromQRPayload: "goo.gl/abc")?.absoluteString == "https://goo.gl/abc")
        #expect(CardboardViewerParams.url(fromQRPayload: "http://example.com/v?x=1")?.absoluteString == "https://example.com/v?x=1")
        #expect(CardboardViewerParams.url(fromQRPayload: " https://g.co/cardboard \n")?.absoluteString == "https://g.co/cardboard")
        #expect(CardboardViewerParams.url(fromQRPayload: "not a url at all") == nil)
        #expect(CardboardViewerParams.url(fromQRPayload: "") == nil)
        #expect(CardboardViewerParams.url(fromQRPayload: "localhost") == nil)
    }

    @Test func rejectsInvalidPayloads() {
        #expect(CardboardViewerParams(encoded: Data()) == nil)
        #expect(CardboardViewerParams(encoded: Data([0x01, 0x02, 0x03])) == nil)
        // A vendor string alone is a well-formed message without the lens fields.
        #expect(CardboardViewerParams(encoded: Data([0x0a, 0x02, 0x48, 0x69])) == nil)
        // Truncated v2 payload.
        #expect(CardboardViewerParams(encoded: CardboardViewerParams.cardboardV2.encoded.prefix(30)) == nil)
    }

    @Test func roundTripsThroughCodable() throws {
        let data = try JSONEncoder().encode(CardboardViewerParams.cardboardV2)
        #expect(try JSONDecoder().decode(CardboardViewerParams.self, from: data) == .cardboardV2)
    }
}

struct LensTests {
    @Test func eyeDataForDefaultViewer() throws {
        let lens = try #require(CardboardLens(viewer: .cardboardV2, displayWidth: 2622, displayHeight: 1206))
        let halfIPD = CardboardViewerParams.cardboardV2.interLensDistance / 2
        let left = lens.eyeFromHeadMatrix(.left)
        let right = lens.eyeFromHeadMatrix(.right)
        #expect(abs(left[12] - halfIPD) < 1e-6)
        #expect(abs(right[12] + halfIPD) < 1e-6)
        #expect(left[0] == 1 && left[5] == 1 && left[10] == 1 && left[15] == 1)

        for eye in CardboardLens.Eye.allCases {
            let fov = lens.fieldOfView(eye)
            #expect(fov.count == 4)
            #expect(fov.allSatisfy { $0 > 0 && $0 < .pi / 2 })

            let projection = lens.projectionMatrix(eye, near: 0.1, far: 1000)
            #expect(projection[11] == -1 && projection[15] == 0)
            #expect(projection[0] > 0 && projection[5] > 0)
            let formula = CardboardLens.projectionMatrix(fieldOfView: fov, near: 0.1, far: 1000)
            for i in 0..<16 {
                #expect(abs(projection[i] - formula[i]) < 1e-4, "projection entry \(i)")
            }

            let mesh = lens.distortionMesh(eye)
            #expect(mesh.vertexCount == 1600)
            #expect(mesh.indices.count == 3158)
            #expect(mesh.uvs.count == 3200)
            #expect(mesh.indices.allSatisfy { Int($0) < mesh.vertexCount })
            #expect(mesh.uvs.allSatisfy { $0 >= -1e-5 && $0 <= 1 + 1e-5 })
            #expect(mesh.vertices.allSatisfy { $0.isFinite && abs($0) < 4 })
        }

        // The left eye's mesh lies in the left half of the screen and the right eye's in the right half.
        func meanX(_ mesh: CardboardLens.Mesh) -> Float {
            stride(from: 0, to: mesh.vertices.count, by: 2).map { mesh.vertices[$0] }.reduce(0, +) / Float(mesh.vertexCount)
        }
        #expect(meanX(lens.distortionMesh(.left)) < -0.2)
        #expect(meanX(lens.distortionMesh(.right)) > 0.2)
        // The outer field of view is wider than the inner one for each eye (nose side is narrower).
        #expect(lens.fieldOfView(.left)[0] >= lens.fieldOfView(.left)[1])
        #expect(lens.fieldOfView(.right)[1] >= lens.fieldOfView(.right)[0])
    }

    @Test func rejectsEmptyDisplay() {
        #expect(CardboardLens(viewer: .cardboardV2, displayWidth: 0, displayHeight: 100) == nil)
    }
}

struct HeadTrackerTests {
    @Test func poseIsAUnitQuaternion() {
        let tracker = CardboardHeadTracker()
        tracker.resume()
        #expect(tracker.isTracking)
        let pose = tracker.pose(at: CardboardHeadTracker.now + 16_000_000, viewportOrientation: .landscapeLeft)
        #expect(abs(simd_length(pose.orientation.vector) - 1) < 1e-4)
        #expect(pose.position.x.isFinite && pose.position.y.isFinite && pose.position.z.isFinite)
        tracker.recenter()
        tracker.pause()
        #expect(!tracker.isTracking)
    }

    @Test func clockConversion() {
        let now = CardboardHeadTracker.now
        #expect(now > 0)
        #expect(CardboardHeadTracker.nanoseconds(mediaTime: 1.5) == 1_500_000_000)
    }
}
