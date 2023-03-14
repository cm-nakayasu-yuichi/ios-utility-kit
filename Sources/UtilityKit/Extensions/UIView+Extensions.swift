import UIKit

// MARK: - 追加プロパティ
extension UIView {
    
    /// 角丸の半径
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// 枠線の幅
    @IBInspectable open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// 枠線の色
    @IBInspectable open var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    
    /// XIBから自身のビューをインスタンス化する
    ///
    /// `CustomView`であれば`CustomView.xib`を用意して、その中で当該クラスのビューを一つ用意している必要があります。
    ///
    /// - Returns: 自身のビュー
    public static func instantiate() -> Self {
        guard let className = NSStringFromClass(self).components(separatedBy: ".").last else {
            fatalError("UIView instantiate() Error. could not get class name.")
        }
        let nib = UINib(nibName: className, bundle: nil)
        guard let view = nib.instantiate(withOwner: nil).first as? Self else {
            fatalError("UIView instantiate() Error. \(className) could not instantiate from xib.")
        }
        return view
    }
}

// MARK: - 親ビューと配置
extension UIView {
    
    /// 親ビュー
    public var parent: UIView? {
        get {
            return superview
        }
        set {
            if let view = newValue {
                view.addSubview(self)
            } else {
                removeFromSuperview()
            }
        }
    }
    
    /// 全てのサブビューを削除する
    public func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

// MARK: - ビューの差秒サイズの取得と設定
extension UIView {
    
    /// サイズ
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            var r = frame
            r.size = newValue
            frame = r
        }
    }
    
    /// 座標
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var r = frame
            r.origin = newValue
            frame = r
        }
    }
    
    /// 幅
    public var width: CGFloat {
        get {
            return frame.width
        }
        set {
            var r = frame
            r.size.width = newValue
            frame = r
        }
    }
    
    /// 高さ
    public var height: CGFloat {
        get {
            return frame.height
        }
        set {
            var r = frame
            r.size.height = newValue
            frame = r
        }
    }
    
    /// X座標
    public var x: CGFloat {
        get {
            return frame.minX
        }
        set {
            var r = frame
            r.origin.x = newValue
            frame = r
        }
    }
    
    /// Y座標
    public var y: CGFloat {
        get {
            return frame.minY
        }
        set {
            var r = frame
            r.origin.y = newValue
            frame = r
        }
    }
}

// MARK: - 複数のビューへのアクセス
extension Array where Element == UIView {
    
    public var isHidden: Bool {
        get {
            return first?.isHidden ?? false
        }
        set {
            forEach { $0.isHidden = newValue }
        }
    }
}
