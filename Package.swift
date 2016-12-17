import PackageDescription

let package = Package(
    name: "Relical",
    targets: [
        Target(name: "Relical")
    ],
    exclude: [
        "Relical.xcworkspace",
        "Relical.xcodeproj",
        "Sources/Relical/Supporting Files",
        "Tests/RelicalTests/Supporting Files",
    ]
)
