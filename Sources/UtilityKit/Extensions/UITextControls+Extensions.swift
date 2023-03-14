import UIKit

extension UITextField {
    
    /// テキストの値
    public var textValue: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
    
    /// プレースホルダの色
    @IBInspectable public var placeholderColor : UIColor? {
        get {
            var range : NSRange? = NSMakeRange(0, 1)
            guard
                let placeholder = attributedPlaceholder,
                let color = placeholder.attribute(.foregroundColor, at: 0, effectiveRange: &range!) as? UIColor
                else {
                    return nil
            }
            return color
        }
        set {
            guard let color = newValue, let font = font else {
                return
            }
            let attributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : color,
                .font            : font,
            ]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        }
    }
}

extension UITextView {
    
    /// テキストの値
    public var textValue: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}
