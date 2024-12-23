import XcodeProj
import Foundation



extension PBXTarget {
    var bspId: URL? {
        var components: URLComponents = .init()
        components.scheme = "bsp"
        components.host = self.uuid

        return components.url
    }
}
