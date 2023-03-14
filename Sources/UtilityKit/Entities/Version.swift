import Foundation

public struct Version {
    
    /// バージョン番号
    public let versionNumber: String
    
    public init(_ versionNumber: String) {
        self.versionNumber = versionNumber
    }
    
    /// 現在のアプリバージョン (info.plist の CFBundleShortVersionString の値)
    public static var bundleShortVersion: Version {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return Version(versionNumber)
    }
}

extension Version: Comparable {
    
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return compare(lhs: lhs, rhs: rhs) == .orderedSame
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        return compare(lhs: lhs, rhs: rhs) == .orderedDescending
    }
}

extension Version {
    
    private static func splitByDot(_ versionNumber: String) -> [Int] {
        return versionNumber.split(separator: ".").map { string -> Int in
            return Int(string) ?? 0
        }
    }
    
    private static func filled(_ target: [Int], count: Int) -> [Int] {
        return (0..<count).map { i -> Int in
            (i < target.count) ? target[i] : 0
        }
    }
    
    private static func compare(lhs: Version, rhs: Version) -> ComparisonResult {
        var lhsComponents = splitByDot(lhs.versionNumber)
        var rhsComponents = splitByDot(rhs.versionNumber)
        
        let count = max(lhsComponents.count, rhsComponents.count)
        lhsComponents = filled(lhsComponents, count: count)
        rhsComponents = filled(rhsComponents, count: count)
        
        for i in 0..<count {
            let lhsComponent = lhsComponents[i]
            let rhsComponent = rhsComponents[i]
            
            if lhsComponent < rhsComponent {
                return .orderedDescending
            }
            if lhsComponent > rhsComponent {
                return .orderedAscending
            }
        }
        return .orderedSame
    }
}
