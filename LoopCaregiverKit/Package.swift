// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoopCaregiverKit",
    platforms: [.iOS(.v16), .watchOS(.v10)],
    products: [
        .library(
            name: "LoopCaregiverKit",
            targets: ["LoopCaregiverKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/LoopKit/LoopKit.git", branch: "dev"),
//        .package(path: "../../LoopKit"),
        .package(url: "https://github.com/gestrich/NightscoutKit.git", branch: "feature/2023-07/bg/remote-commands"),
        .package(url: "https://github.com/mattrubin/OneTimePassword.git", revision: "8e4022f2852d77240d0a17482cbfe325354aac70"),
    ],
    targets: [
        .target(
            name: "LoopCaregiverKit",
            dependencies: [
                "LoopKit",
                "NightscoutKit",
                "OneTimePassword"
            ]
        ),
        .testTarget(
            name: "LoopCaregiverKitTests",
            dependencies: ["LoopCaregiverKit"]),
    ]
)
