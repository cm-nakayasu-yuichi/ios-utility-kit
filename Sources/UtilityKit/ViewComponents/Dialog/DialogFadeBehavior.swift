import UIKit

open class DialogFadeBehavior: DialogBehavior {
    
    open class Presentation: DialogAnimatedTransitioning {
        
        override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to)
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.alpha = 0
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    open class Dismissal: DialogAnimatedTransitioning {
        
        override open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from)
                else {
                    return
            }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
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
