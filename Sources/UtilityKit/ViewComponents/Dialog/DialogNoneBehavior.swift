import UIKit

open class DialogNoneBehavior: DialogBehavior {
    
    open class Presentation: DialogAnimatedTransitioning {
        
        override open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0
        }
        
        override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to)
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            toView.alpha = 1
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        }
    }
    
    open class Dismissal: DialogAnimatedTransitioning {
        
        override open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0
        }
        
        override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from)
                else {
                    return
            }
            
            fromView.alpha = 0
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    override open var presentation: DialogAnimatedTransitioning? {
        return Presentation(behavior: self)
    }
    
    override open var dismissal: DialogAnimatedTransitioning? {
        return Dismissal(behavior: self)
    }
}
