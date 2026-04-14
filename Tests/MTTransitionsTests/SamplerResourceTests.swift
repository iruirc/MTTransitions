import XCTest
@testable import MTTransitions

final class SamplerResourceTests: XCTestCase {

    /// Verifies that SPM ships Assets.bundle with displacementMap.jpg through
    /// Bundle.module — the exact mechanism used by MTDisplacementTransition
    /// at runtime via samplerImage(name:). If this test fails,
    /// MTDisplacementTransition will latent-crash at MTTransition.swift
    /// (`ciImage!` force-unwrap) when applied.
    func testDisplacementMapLoadsFromBundle() throws {
        let bundle = Bundle.module
        let bundleUrl = try XCTUnwrap(
            bundle.url(forResource: "Assets", withExtension: "bundle"),
            "Assets.bundle must be shipped inside Bundle.module"
        )
        let resourceBundle = try XCTUnwrap(
            Bundle(url: bundleUrl),
            "Assets.bundle must be loadable as a Bundle"
        )
        let imageUrl = try XCTUnwrap(
            resourceBundle.url(forResource: "displacementMap.jpg", withExtension: nil),
            "displacementMap.jpg must exist inside Assets.bundle"
        )
        let data = try Data(contentsOf: imageUrl)
        XCTAssertFalse(data.isEmpty, "displacementMap.jpg must be non-empty")
    }

    /// Same as testDisplacementMapLoadsFromBundle, but for spiral-1.png —
    /// used by MTLumaTransition. These are the only two sampler files
    /// actually referenced by runtime code (Research.md §1).
    func testSpiral1LoadsFromBundle() throws {
        let bundle = Bundle.module
        let bundleUrl = try XCTUnwrap(
            bundle.url(forResource: "Assets", withExtension: "bundle"),
            "Assets.bundle must be shipped inside Bundle.module"
        )
        let resourceBundle = try XCTUnwrap(
            Bundle(url: bundleUrl),
            "Assets.bundle must be loadable as a Bundle"
        )
        let imageUrl = try XCTUnwrap(
            resourceBundle.url(forResource: "spiral-1.png", withExtension: nil),
            "spiral-1.png must exist inside Assets.bundle"
        )
        let data = try Data(contentsOf: imageUrl)
        XCTAssertFalse(data.isEmpty, "spiral-1.png must be non-empty")
    }
}
