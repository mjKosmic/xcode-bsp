import LanguageServerProtocol
import Foundation
import XCLogParser
import OSLog
import XcodeProj

public actor BSPServer {
    static var shared: BSPServer = .init(.init(projectType: .project(scheme: "foo")))
    static var capabilities: BuildServerCapabilities {
        .init(
            compileProvider: .init(languageIds: [.swift]),
            testProvider: .init(languageIds: [.swift]),
            runProvider: .init(languageIds: [.swift]),
            debugProvider: .init(languageIds: [.swift]),
            inverseSourcesProvider: false,
            dependencySourcesProvider: false,
            dependencyModulesProvider: false,
            resourcesProvider: false,
            outputPathsProvider: false,
            buildTargetChangedProvider: false,
            canReload: false
        )
    }

    private var initialized: Bool = false

    var launchOptions: LaunchOptions
    var projectRootDir: URL?
    var xcodeProjPath: URL?
    var projectBuildLogFolder: String?
    var activityLog: IDEActivityLog?
    private var nativeBuildTargets: [PBXNativeTarget] = []
    var buildTargets: [Build.Target] {
        var targets: [Build.Target] = []
        for nativeTarget in nativeBuildTargets {
            let target: Build.Target = .init(
                id: .init(uri: "bsp://\(nativeTarget.uuid)"),
                displayName: nativeTarget.name,
                baseDirectory: nil,
                tags: [],
                languageIds: [.swift],
                dependencies: nativeTarget.dependencies.flatMap { dependency in
                    if let uuid = dependency.target?.uuid { 
                        return .init(uri: "bsp://\(uuid)") 
                    }
                    return nil
                },
                capabilities: []
            )

            Logger.bsp.debug("Build Target: \n\tID: \(target.id.uri, privacy: .public)\n\tName: \(target.displayName ?? "nil", privacy: .public)")
            targets.append(target)
        }

        return targets
    }

    init(_ launchOptions: LaunchOptions) {
        self.launchOptions = launchOptions
    }


    func initialize(_ params: Initialize.Params) async throws {
        self.projectRootDir = params.rootUri

        do {
            let logFinder: LogFinder = .init()
            guard let xcodeProjPath: URL = try findXcodeprojDirectory(forProjectRoot: params.rootUri) else { return }
            self.xcodeProjPath = xcodeProjPath
            let projFileDirString = xcodeProjPath.absoluteString.replacing("file://", with: "")
            self.projectBuildLogFolder = try logFinder.getProjectFolderWithHash(projFileDirString)
            Logger.bsp.debug("Found project build log directory: \(self.projectBuildLogFolder ?? "nil", privacy: .public)")

            try parseLatestActivityLog()
            try getNativeBuildTargets()

            initialized = true
        } catch let error as XCodeProjError {
            switch error {
                case .notFound(let path):
                    Logger.bsp.error("path not found: \(path, privacy: .public)")
                case .pbxprojNotFound(let path):
                    Logger.bsp.error("pbxproj path not found: \(path, privacy: .public)")
                case .xcworkspaceNotFound(let path):
                    Logger.bsp.error("xcworkspace path not found: \(path, privacy: .public)")
            }
        } catch {
            Logger.bsp.error("Error initializing BSP Server: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func findXcodeprojDirectory(forProjectRoot rootUri: URL) throws -> URL? {
        let fileManager: FileManager = .default
        for item in try fileManager.contentsOfDirectory(at: rootUri, includingPropertiesForKeys: []) {
            if item.absoluteString.contains(".xcodeproj/") {
                Logger.bsp.debug("xcodeproj found at: \(item, privacy: .public)")
                return item
            }
        }
        return nil
    }   

    private func parseLatestActivityLog() throws {
        let logFinder: LogFinder = .init()
        Logger.bsp.debug("Finding latest build log...")
        guard let projectBuildLogFolder = self.projectBuildLogFolder else { return }
        let fullBuildLogPath = launchOptions.derivedData.appending(component: projectBuildLogFolder)
        let latestLogPath = try logFinder.getLatestLogInDir(fullBuildLogPath)
        Logger.bsp.debug("Latest build log found")
        let logPathUri: URL = .init(filePath: latestLogPath)
        Logger.bsp.debug("Parsing xcactivitylog at path: \(latestLogPath, privacy: .public)")


        let parser = XCLogParser.ActivityParser.init()
        self.activityLog = try parser.parseActivityLogInURL(logPathUri, redacted: false, withoutBuildSpecificInformation: false)
    }   

    private func getNativeBuildTargets() throws {
        Logger.bsp.debug("Getting build targets...")
        guard let rootDir = self.xcodeProjPath else { return }
        let filePath = rootDir.absoluteString.replacing("file://", with: "")
        let xcodeProj: XcodeProj = try .init(pathString: filePath)
        let targets = xcodeProj.pbxproj.nativeTargets
        Logger.bsp.debug("Native build targets found: \(targets.count, privacy: .public)")
        self.nativeBuildTargets = targets
    }
}
