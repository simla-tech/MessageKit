import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: .MessageKit,
    targets: [
        Target(
            name: .MessageKit,
            resources: .defaultResourcesPath,
            lintConfigPath: nil,
            dependencies: [
                .target(name: .InputBarAccessoryView)
            ]
        ),
        Target(
            name: .MessageKitTests,
            product: .unitTests,
            sources: .defaultTestsPath,
            lintConfigPath: nil,
            dependencies: [
                .target(name: .MessageKit)
            ]
        )
    ]
)
