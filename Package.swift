// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MTTransitions",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "MTTransitions",
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
                path: "Source")
    ],
    swiftLanguageVersions: [.v5]
)
