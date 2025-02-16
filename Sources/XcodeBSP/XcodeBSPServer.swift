import LanguageServerProtocol
import Foundation
import XCLogParser
import OSLog
import XcodeProj

public actor XcodeBSPServer {
    static var shared: XcodeBSPServer = .init(.init(projectType: .project(scheme: "foo")))
    static var capabilities: BuildServerCapabilities {
        .init(
            compileProvider: .init(languageIds: [.swift]),
            testProvider: .init(languageIds: [.swift]),
            runProvider: .init(languageIds: [.swift]),
            debugProvider: .init(languageIds: [.swift]),
            inverseSourcesProvider: true,
            dependencySourcesProvider: true,
            dependencyModulesProvider: false,
            resourcesProvider: false,
            outputPathsProvider: false,
            buildTargetChangedProvider: true,
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
    private var xcodeProj: XcodeProj?
    var buildTargets: [Build.Target] {
        var targets: [Build.Target] = []
        for nativeTarget in nativeBuildTargets {
            guard let targetId = nativeTarget.bspId else { continue }
            let target: Build.Target = .init(
                id: .init(uri: targetId),
                displayName: nativeTarget.name,
                baseDirectory: nil,
                tags: [],
                languageIds: [.swift],
                dependencies: nativeTarget.dependencies.compactMap { dependency in
                    return dependency.target?.bspId.flatMap { .init(uri: $0) }
                },
                capabilities: .init(
                    canCompile: false,
                    canTest: false,
                    canRun: false,
                    canDebug: false
                )
            )
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
            self.projectBuildLogFolder = try logFinder.getProjectFolderWithHash(xcodeProjPath.path())
            Logger.bsp.debug("Found project build log directory: \(self.projectBuildLogFolder ?? "nil", privacy: .public)")

            try resolveXcodeProj()
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

    private func resolveXcodeProj() throws {
        Logger.bsp.debug("Resolving XcodeProj...")
        guard let rootDir = self.xcodeProjPath else { return }
        self.xcodeProj = try .init(pathString: rootDir.path())
    }

    private func getNativeBuildTargets() throws {
        Logger.bsp.debug("Getting build targets...")
        if self.xcodeProj == nil { try resolveXcodeProj() }

        if let targets = self.xcodeProj?.pbxproj.nativeTargets {
            Logger.bsp.debug("Native build targets found: \(targets.count, privacy: .public)")

            self.nativeBuildTargets = targets
        }
    }

    public func sources(for targetId: Build.Target.Identifier) throws -> [Build.Target.Source.Item] {
        Logger.bsp.debug("Getting sources for targetId: \(targetId.uri, privacy: .public)")
        if self.xcodeProj == nil { try resolveXcodeProj() }
        guard let target = self.nativeBuildTargets.first(where: { $0.bspId == targetId.uri }) else { return [] }
        Logger.bsp.debug("Target Found: \(target.name, privacy: .public)")
        var sourceFiles: [PBXFileElement]?
        do {
            sourceFiles = try target.sourceFiles() 
        } catch let error as PBXObjectError {
            Logger.bsp.error("Error getting build target source files: \(error.description)")
        }
        if let sourceFiles {
            var sourceItems: [Build.Target.Source.Item] = []
                for file in sourceFiles {
                    guard let _ = file.path else { continue }
                    if let projectRootDir = self.projectRootDir {
                        if let filePath = try file.fullPath(sourceRoot: projectRootDir.path()) {
                            let filePathUri = URL(filePath: filePath)
                            let item: Build.Target.Source.Item = .init(
                                uri: filePathUri, 
                                kind: .file,
                                generated: false
                            )

                            sourceItems.append(item)
                        }
                    }
                }

            return sourceItems 
        }

        return []
    }


    public func sourceKitOptions(for params: TextDocument.SourceKitOptions.Params) -> TextDocument.SourceKitOptions.Result {
        Logger.bsp.debug("Attempting to get sourceKitOptions for file: \(params.textDocument.uri)")
        guard let projectRootDir = self.projectRootDir else {
            Logger.bsp.error("Project root directory was nil")
            return .init(compilerArguments: [], workingDirectory: nil)
        }
        guard let target = self.nativeBuildTargets.first(where: { $0.bspId == params.target.uri }) else { 
            Logger.bsp.error("No build target found for identifier: \(params.target.uri)")
            return .init(compilerArguments: [], workingDirectory: nil)
        }
        
        var args: [String] = []

        args.append("-module-name")
        args.append(target.name)

        //disable optimizations
        args.append("-Onone")

        // args.append("-emit-module")
        args.append("-enforce-exclusivity=checked")

        args.append("-output-file-map")
        args.append(projectRootDir.appending(path: "/file_map.json").path())

        args.append("-incremental")
        args.append("-c")

        if let sources = try? target.sourceFiles() {
            for file in sources {
                if let filePath = try? file.fullPath(sourceRoot: projectRootDir.path()) {
                    args.append(filePath)
                }
            }
        }

        return .init(
            compilerArguments: args, 
            workingDirectory: nil
        )
    }
}
