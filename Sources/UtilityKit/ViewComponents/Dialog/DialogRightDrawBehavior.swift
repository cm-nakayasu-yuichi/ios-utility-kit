import UIKit

open class DialogRightDrawBehavior: DialogBehavior {
    
    private let width: CGFloat
    
    public init(width: CGFloat = 200) {
        self.width = width
        super.init()
    }
    
    override open func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        return CGRect(
            x: containerSize.width - self.width,
            y: 0,
            width: self.width,
            height: containerSize.height
        )
    }
    
    open class Presentation: DialogAnimatedTransitioning {
        
        override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to),
                let rightDrawBehavior = behavior as? DialogRightDrawBehavior
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: rightDrawBehavior.width, y: 0)
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    open class Dismissal: DialogAnimatedTransitioning {
        
        override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from),
                let rightDrawBehavior = behavior as? DialogRightDrawBehavior
                else {
                    return
            }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(translationX: rightDrawBehavior.width, y: 0)
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    override open var presentation: DialogAnimatedTransitioning? {
        return Presentation(behavior: self)
    }
    
    override open var dismissal: DialogAnimatedTransitioning? {
        return Dismissal(behavior: self)
    }
}
