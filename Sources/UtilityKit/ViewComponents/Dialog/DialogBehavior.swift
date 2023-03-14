import UIKit

open class DialogBehavior {
    
    open var animationDuration: TimeInterval = 0.25
    
    open var overlayTapDismissalEnabled = true
    
    open var overlayColor = UIColor.black.withAlphaComponent(0.5)
    
    open var overlayIsBlur = false
    
    open var overlayBlurEffectStyle: UIBlurEffect.Style = .regular
    
    open var overlayBlurAlpha: CGFloat = 1.0
    
    open var fixedSize: CGSize?
    
    open var presentation: DialogAnimatedTransitioning? {
        return nil
    }
    
    open var dismissal: DialogAnimatedTransitioning? {
        return nil
    }
    
    open func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        let origin = CGPoint(
            x: (containerSize.width  - presentedSize.width)  / 2,
            y: (containerSize.height - presentedSize.height) / 2
        )
        return CGRect(origin: origin, size: presentedSize)
    }
}

extension DialogBehavior {
    public enum Name {
        case none(size: CGSize? = nil)
        case rightDraw(width: CGFloat = 200)
        case leftDraw(width: CGFloat = 200)
        case topDraw(height: CGFloat = 250)
        case bottomDraw(height: CGFloat = 250)
        case zoom(scale: CGFloat = 0.25)
        case riseup(offset: CGFloat = 30, size: CGSize? = nil)
        case fade(size: CGSize? = nil)
        
        public func instantiate() -> DialogBehavior {
            switch self {
            case .rightDraw(let width):
                return DialogRightDrawBehavior(width: width)
            case .leftDraw(let width):
                return DialogLeftDrawBehavior(width: width)
            case .topDraw(let height):
                return DialogTopDrawBehavior(height: height)
            case .bottomDraw(let height):
                return DialogBottomDrawBehavior(height: height)
            case .zoom(let scale):
                return DialogZoomBehavior(scale: scale)
            // 以下はサイズの指定がなければ 横5:縦4比率のダイアログを表示する
            case .none(let size):
                let behavior = DialogNoneBehavior()
                if let fixedSize = size {
                    behavior.fixedSize = fixedSize
                }
                return behavior
            case .riseup(let offset, let size):
                let behavior = DialogRiseupBehavior(offset: offset)
                if let fixedSize = size {
                    behavior.fixedSize = fixedSize
                }
                return behavior
            case .fade(let size):
                let behavior = DialogFadeBehavior()
                if let fixedSize = size {
                    behavior.fixedSize = fixedSize
                }
                return behavior
            }
        }
    }
}
