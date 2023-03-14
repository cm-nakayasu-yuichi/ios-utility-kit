import Foundation
import CoreGraphics

// MARK: - CGRect
extension CGRect {
    
    /// イニシャライザ
    /// - Parameters:
    ///   - width: 幅
    ///   - height: 高さ
    ///   - x: X座標
    ///   - y: Y座標
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
    
    /// イニシャライザ
    /// - Parameters:
    ///   - origin: 座標
    ///   - size: サイズ
    public init(_ origin: CGPoint, _ size: CGSize) {
        self.init(origin: origin, size: size)
    }
    
    /// 座標を0位置に固定した状態でサイズのみで初期化
    ///  - Parameter size: サイズ
    public init(_ size: CGSize) {
        self.init(origin: .zero, size: size)
    }
}

// MARK: - CGPoint
extension CGPoint {
    
    /// イニシャライザ
    /// - Parameters:
    ///   - x: X座標
    ///   - y: Y座標
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
    
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    public static func +(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(lhs.x + rhs, lhs.y + rhs)
    }
    
    public static func -(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(lhs.x - rhs, lhs.y - rhs)
    }
}

// MARK: - CGSize
extension CGSize {
    
    /// イニシャライザ
    /// - Parameters:
    ///   - width: 幅
    ///   - height: 高さ
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
    
    /// 水平方向で半分に割った時のサイズ
    public var horizontalHalfSize: CGSize {
        return CGSize(width / 2, height)
    }
    
    /// 垂直方向で半分に割った時のサイズ
    public var verticalHalfSize: CGSize {
        return CGSize(width, height / 2)
    }
    
    /// 水平方向で半分の場所に当たる位置
    public var horizontalHalfPoint: CGPoint {
        return CGPoint(width / 2, 0)
    }
    
    /// 垂直方向で半分の場所に当たる位置
    public var verticalHalfPoint: CGPoint {
        return CGPoint(0, height / 2)
    }
    
    /// 指定した親サイズの水平方向に中央に当たる座標サイズを取得
    /// - Parameter parentSize: 親サイズ
    /// - Returns: 水平方向に中央に当たる座標サイズ
    public func horizontalCenterRect(in parentSize: CGSize) -> CGRect {
        return CGRect((parentSize.width - width) / 2, 0, width, height)
    }
    
    /// 指定した親サイズの垂直方向に中央に当たる座標サイズを取得
    /// - Parameter parentSize: 親サイズ
    /// - Returns: 垂直方向に中央に当たる座標サイズ
    public func verticalCenterRect(in parentSize: CGSize) -> CGRect {
        return CGRect(0, (parentSize.height - height) / 2, width, height)
    }
    
    /// 指定した親サイズの中央に当たる座標サイズを取得
    /// - Parameter parentSize: 親サイズ
    /// - Returns: 中央に当たる座標サイズ
    public func centerRect(in parentSize: CGSize) -> CGRect {
        return CGRect(
            (parentSize.width - width) / 2,
            (parentSize.height - height) / 2,
            width,
            height
        )
    }
    
    /// 指定した親座標サイズの中央に当たる座標サイズを取得
    /// - Parameter parentRect: 親座標サイズ
    /// - Returns: 中央に当たる座標サイズ
    public func centerRect(in parentRect: CGRect) -> CGRect {
        return CGRect(
            ((parentRect.width - width) / 2) + parentRect.minY,
            ((parentRect.height - height) / 2) + parentRect.minY,
            width,
            height
        )
    }
    
    public static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(lhs.width * rhs, lhs.height * rhs)
    }
    
    public static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(lhs.width / rhs, lhs.height / rhs)
    }
}

// MARK: - CGFloat
extension CGFloat {
    
    /// 引数の値に対するパーセンテージを取得する
    /// - Parameter denominator: 対象の値
    /// - Returns: denominatorに対するパーセンテージ
    public func percentage(of denominator: CGFloat) -> CGFloat {
        if denominator <= 0 { return 0 }
        if self >= denominator { return 1 }
        return self / denominator
    }
    
    /// パーセンテージ表示用の文字列を取得
    /// - Parameter place: 小数点位置
    /// - Returns: パーセンテージ表示用の文字列
    public func percentageText(place: Int) -> String {
        let format = "%.\(NSString(format: "%02d", place) as String)f" as NSString
        return NSString(format: format, self * 100) as String
    }
}

// MARK: - 他の型からCGFloatへの変換
extension Int {
    
    /// CGFloat値を取得
    public var f: CGFloat {
        return CGFloat(self)
    }
}

extension Double {
    
    /// CGFloat値を取得
    public var f: CGFloat {
        return CGFloat(self)
    }
}

extension Float {
    
    /// CGFloat値を取得
    public var f: CGFloat {
        return CGFloat(self)
    }
}
