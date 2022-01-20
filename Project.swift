import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: .MessageKit,
    targets: [
        Target(
            name: .MessageKit,
            lintConfigPath: nil,
            dependencies: [
                .target(name: .InputBarAccessoryView)
            ]
        )
    ]
)
