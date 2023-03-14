import Foundation

// MARK: - Int
extension Int {
    
    /// 3桁カンマ区切りの文字列
    public var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(for: self)!
    }
    
    /// 金額表示用の文字列
    public var currency: String {
        return "¥" + formatted
    }
    
    /// 漢数字に変換した文字列
    public var japanese: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = .init(identifier: "ja-JP")
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    /// 指定した範囲の中から乱数を取得する
    /// 
    /// 最小値は0を下回ってはいけません。また、最小値は最大値を上回ってはいけません
    /// - Parameters:
    ///   - min: 最小値
    ///   - max: 最大値
    /// - Returns: 乱数
    public static func random(min: Int, max: Int) -> Int {
        let minn = min < 0 ? 0 : min
        let maxn = max + 1
        let x = UInt32(maxn < minn ? 0 : maxn - minn)
        let r = Int(arc4random_uniform(x))
        return minn + r
    }
    
    /// 0埋めした文字列を取得する
    /// - Parameters:
    ///   - length: 必要な文字数
    /// - Returns: 0埋めした文字列
    public func zeroFill(length: Int) -> String {
        return string.padding(length: length, pad: "0")
    }
    
    /// 文字列に変換した値
    public var string: String {
        return "\(self)"
    }
    
    /// Floatにキャストした値
    public var float: Float {
        return Float(self)
    }
    
    /// Doubleにキャストした値
    public var double: Double {
        return Double(self)
    }
}

// MARK: - Double
extension Double {
    
    /// Intにキャストした値
    public var int: Int {
        return Int(self)
    }
    
    /// Floatにキャストした値
    public var float: Float {
        return Float(self)
    }
    
    /// 文字列にキャストした値
    public var string: String {
        return "\(self)"
    }
}

// MARK: - Float
extension Float {
    
    /// Intにキャストした値
    public var int: Int {
        return Int(self)
    }
    
    /// Doubleにキャストした値
    public var double: Double {
        return Double(self)
    }
    
    /// 文字列にキャストした値
    public var string: String {
        return "\(self)"
    }
}

// MARK: - Bool
extension Bool {
    
    /// 文字列に変換した値
    public var string: String {
        return self ? "true" : "false"
    }
    
    /// 整数に変換した値
    public var int: Int {
        return self ? 1 : 0
    }
    
    /// 真偽反対の値
    public var reversed: Bool {
        return self ? false : true
    }
    
    /// 真偽反対の値に変更する
    public mutating func reverse() {
        self = self ? false : true
    }
}
