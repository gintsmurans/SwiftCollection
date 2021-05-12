// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "GMSwiftCollection",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v9)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GMSwiftCollection",
            targets: ["GMSwiftCollection"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "GMSwiftCollection",
            dependencies: [],
            path: "Sources",
            sources: ["Classes", "Controllers", "Extensions"],
            cSettings: [
                .headerSearchPath("Classes"),
                .headerSearchPath("Controllers"),
                .headerSearchPath("Extensions")
            ]
        )
    ]
)
