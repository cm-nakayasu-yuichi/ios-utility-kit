import UIKit

open class ClearButton: UIButton {
    
    @IBInspectable public var highlightedColor: UIColor? = #colorLiteral(red: 0.7498688102, green: 0.7498688102, blue: 0.7498688102, alpha: 0.5)
    
    override public var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedColor
            } else {
                UIView.transition(
                    with: self,
                    duration: 0.25,
                    options: .curveEaseOut,
                    animations: { [weak self] in
                        self?.backgroundColor = .clear
                    },
                    completion: nil
                )
            }
        }
    }
}
