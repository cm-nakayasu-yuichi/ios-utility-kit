import UIKit

// MARK: - RGB値
extension UIColor {
    
    /// RGB整数値で初期化
    ///
    /// ```
    /// // 下記のように値を渡す想定
    /// let color = UIColor(rgbInteger: 0xDCBA98)
    /// ```
    /// - Parameter rgbInteger: RGB値
    public convenience init(rgbInteger: Int) {
        let r = CGFloat((rgbInteger & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbInteger & 0x00FF00) >>  8) / 255.0
        let b = CGFloat( rgbInteger & 0x0000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// RGB整数値
    public var rgbInteger: Int {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (int(float: r) * 0x010000) + (int(float: g) * 0x000100) + int(float: b)
    }
}

// MARK: - カラーコード
extension UIColor {
    
    /// カラーコードで初期化
    /// ```
    /// // 下記のように値を渡す想定
    /// let color = UIColor(colorCode: "DCBA98")
    /// ```
    /// - Parameter colorCode: カラーコード
    public convenience init?(colorCode colorCodeOrNil: String?) {
        guard let colorCode = colorCodeOrNil else { return nil }
        let hex = UIColor.stringToHex(colorCode) ?? 0
        self.init(rgbInteger: hex)
    }
    
    /// カラーコード
    public var colorCode: String {
        return UIColor.hexToColorCode(rgbInteger)
    }
}

// MARK: - 各値の取得
extension UIColor {
    
    /// RGB値
    public struct RGB {
        /// 赤色
        let red: CGFloat
        /// 青色
        let blue: CGFloat
        /// 緑色
        let green: CGFloat
    }
    
    /// HSB値
    public struct HSB {
        /// 色相
        let hue: CGFloat
        /// 彩度
        let saturation: CGFloat
        /// 明度
        let brightness: CGFloat
    }
    
    /// RGB各値
    public var rgb: RGB {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGB(red: r, blue: b, green: g)
    }
    
    /// HSB各値
    public var hsb: HSB {
        var h: CGFloat = -1, s: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return HSB(hue: h, saturation: s, brightness: b)
    }
    
    /// ホワイトの強さ
    public var whiteness: CGFloat {
        var w: CGFloat = -1, a: CGFloat = -1
        getWhite(&w, alpha: &a)
        return w
    }
    
    /// ホワイトが強いかどうか
    public var isWhiter: Bool {
        return whiteness >= 0.5
    }
}

// MARK: - Privates
private extension UIColor {
    
    private static func int(float: CGFloat) -> Int {
        return Int(round(float * 255.0))
    }
    
    private func int(float: CGFloat) -> Int {
        return UIColor.int(float: float)
    }
    
    private static func stringToHex(_ value: String) -> Int? {
        if (value as NSString).range(of: "^[a-fA-F0-9]+$", options: .regularExpression).location == NSNotFound {
            return nil
        }
        var ret: UInt64 = 0
        if Scanner(string: value).scanHexInt64(&ret) {
            return Int(ret)
        }
        return nil
    }
    
    private static func hexToColorCode(_ value: Int) -> String {
        var hex = value
        if hex > 0xFFFFFF {
            hex = 0xFFFFFF
        } else if hex < 0 {
            hex = 0
        }
        
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >>  8) / 255.0
        let b = CGFloat((hex & 0x0000FF)      ) / 255.0
        
        var ret = ""
        ret += hexString(for: r)
        ret += hexString(for: g)
        ret += hexString(for: b)
        
        return ret
    }
    
    private static func hexString(for cgFloat: CGFloat) -> String {
        let n = Int(round(cgFloat * 255.0))
        return NSString(format: "%02X", n) as String
    }
}
