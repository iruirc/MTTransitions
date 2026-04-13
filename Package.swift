// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MTTransitions",
    defaultLocalization: "en",
    platforms: [.iOS(.v11), .macOS(.v12)],
    products: [
        .library(
            name: "MTTransitions",
            targets: ["MTTransitions"]
        ),
        .library(
            name: "MTTransitions-Dynamic",
            type: .dynamic,
            targets: ["MTTransitions"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "git@github.com:iosflashintegro/MetalPetal.git", .exact("1.25.2-VSDC.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "MTTransitions",
                dependencies: [
                    .product(name: "MetalPetal-Dynamic", package: "MetalPetal"),
                ],
                // NOTE: .metal shaders are NOT compiled by SPM. They are compiled
                // externally into default.metallib via Scripts/compile_shaders.sh
                // in the main VSDC project, and loaded at runtime via
                // MTIDefaultLibraryURLForBundle (see MTTransition.swift kernel).
                // SPM 5.3+ auto-processes .metal files, which fails because the
                // Metal compiler cannot locate MetalPetal's MTIShaderLib.h header
                // (cross-target header resolution is not supported). Explicit
                // exclude keeps behavior identical to older swift-tools 5.1.
                path: "Source",
                exclude: [
                    "Transitions/MTAngularTransition.metal",
                    "Transitions/MTBookFlipTransition.metal",
                    "Transitions/MTBounceTransition.metal",
                    "Transitions/MTBowTieHorizontalTransition.metal",
                    "Transitions/MTBowTieVerticalTransition.metal",
                    "Transitions/MTBurnTransition.metal",
                    "Transitions/MTButterflyWaveScrawlerTransition.metal",
                    "Transitions/MTCannabisleafTransition.metal",
                    "Transitions/MTCircleCropTransition.metal",
                    "Transitions/MTCircleOpenTransition.metal",
                    "Transitions/MTCircleTransition.metal",
                    "Transitions/MTColorPhaseTransition.metal",
                    "Transitions/MTColourDistanceTransition.metal",
                    "Transitions/MTCoordFromInTransition.metal",
                    "Transitions/MTCrazyParametricFunTransition.metal",
                    "Transitions/MTCrossHatchTransition.metal",
                    "Transitions/MTCrossWarpTransition.metal",
                    "Transitions/MTCrossZoomTransition.metal",
                    "Transitions/MTCubeTransition.metal",
                    "Transitions/MTDirectionalEasingTransition.metal",
                    "Transitions/MTDirectionalTransition.metal",
                    "Transitions/MTDirectionalWarpTransition.metal",
                    "Transitions/MTDirectionalWipeTransition.metal",
                    "Transitions/MTDisplacementTransition.metal",
                    "Transitions/MTDoomScreenTransition.metal",
                    "Transitions/MTDoorwayTransition.metal",
                    "Transitions/MTDreamyTransition.metal",
                    "Transitions/MTDreamyZoomTransition.metal",
                    "Transitions/MTFadeColorTransition.metal",
                    "Transitions/MTFadeInWipeLeftTransition.metal",
                    "Transitions/MTFadeInWipeUpTransition.metal",
                    "Transitions/MTFadeTransition.metal",
                    "Transitions/MTFadegrayscaleTransition.metal",
                    "Transitions/MTFlyeyeTransition.metal",
                    "Transitions/MTGlitchDisplaceTransition.metal",
                    "Transitions/MTGlitchMemoriesTransition.metal",
                    "Transitions/MTGridFlipTransition.metal",
                    "Transitions/MTHeartTransition.metal",
                    "Transitions/MTHexagonalizeTransition.metal",
                    "Transitions/MTInvertedPageCurlTransition.metal",
                    "Transitions/MTKaleidoScopeTransition.metal",
                    "Transitions/MTLeftRightTransition.metal",
                    "Transitions/MTLinearBlurTransition.metal",
                    "Transitions/MTLumaTransition.metal",
                    "Transitions/MTLuminanceMeltTransition.metal",
                    "Transitions/MTMorphTransition.metal",
                    "Transitions/MTMosaicTransition.metal",
                    "Transitions/MTMosaicYueDevTransition.metal",
                    "Transitions/MTMultiplyBlendTransition.metal",
                    "Transitions/MTOverexposureTransition.metal",
                    "Transitions/MTPerlinTransition.metal",
                    "Transitions/MTPinwheelTransition.metal",
                    "Transitions/MTPixelizeTransition.metal",
                    "Transitions/MTPolarFunctionTransition.metal",
                    "Transitions/MTPolkaDotsCurtainTransition.metal",
                    "Transitions/MTPowerKaleidoTransition.metal",
                    "Transitions/MTRadialTransition.metal",
                    "Transitions/MTRandomNoisexTransition.metal",
                    "Transitions/MTRandomSquaresTransition.metal",
                    "Transitions/MTRippleTransition.metal",
                    "Transitions/MTRotateScaleFadeTransition.metal",
                    "Transitions/MTRotateTransition.metal",
                    "Transitions/MTScaleInTransition.metal",
                    "Transitions/MTSimpleZoomTransition.metal",
                    "Transitions/MTSquaresWireTransition.metal",
                    "Transitions/MTSqueezeTransition.metal",
                    "Transitions/MTStereoViewerTransition.metal",
                    "Transitions/MTSwapTransition.metal",
                    "Transitions/MTSwirlTransition.metal",
                    "Transitions/MTTVStaticTransition.metal",
                    "Transitions/MTTangentMotionBlurTransition.metal",
                    "Transitions/MTTopBottomTransition.metal",
                    "Transitions/MTUndulatingBurnOutTransition.metal",
                    "Transitions/MTWaterDropTransition.metal",
                    "Transitions/MTWindTransition.metal",
                    "Transitions/MTWindowBlindsTransition.metal",
                    "Transitions/MTWindowSliceTransition.metal",
                    "Transitions/MTWipeDownTransition.metal",
                    "Transitions/MTWipeLeftTransition.metal",
                    "Transitions/MTWipeRightTransition.metal",
                    "Transitions/MTWipeUpTransition.metal",
                    "Transitions/MTZoomInCirclesTransition.metal"
                ])
    ],
    swiftLanguageVersions: [.v5]
)
