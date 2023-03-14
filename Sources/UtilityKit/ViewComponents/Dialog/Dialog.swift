import UIKit

public class Dialog: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate static var instances = [Dialog]()
    
    private let behavior: DialogBehavior
    
    /// ダイアログを表示する
    /// - Parameters:
    ///   - presentedViewController: 表示するビューコントローラ
    ///   - presentingViewController: 表示元のビューコントローラ
    ///   - behavior: 挙動
    ///   - completion: 表示完了時の処理
    public class func show(_ presentedViewController: UIViewController, from presentingViewController: UIViewController, behavior: DialogBehavior.Name, completion: (() -> Void)? = nil) {
        show(
            presentedViewController,
            from: presentingViewController,
            behavior: behavior.instantiate(),
            completion: completion
        )
    }
    
    /// ダイアログを表示する
    /// - Parameters:
    ///   - presentedViewController: 表示するビューコントローラ
    ///   - presentingViewController: 表示元のビューコントローラ
    ///   - behavior: 挙動
    ///   - completion: 表示完了時の処理
    public class func show(_ presentedViewController: UIViewController, from presentingViewController: UIViewController, behavior: DialogBehavior, completion: (() -> Void)? = nil) {
        let instance = Dialog(behavior)
        Dialog.instances.append(instance)
        
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.transitioningDelegate = instance
        
        presentingViewController.present(presentedViewController, animated: true, completion: completion)
    }
    
    /// 画面サイズから指定の大きさだけ小さいサイズを計算して返す
    ///
    /// ```
    /// let size = Dialog.sizeForScreen(
    ///   horizontalInset: 20,
    ///   verticalInset: 50
    /// )
    /// Dialog.show(someViewController, from: self, behavior: .none(size: size))
    /// ```
    /// - Parameters:
    ///   - horizontalInset: 水平方向のインセット値
    ///   - verticalInset: 垂直方向のインセット値
    /// - Returns: サイズ
    public class func sizeForScreen(horizontalInset: CGFloat, verticalInset: CGFloat) -> CGSize {
        var size = UIScreen.main.bounds.size
        size.width -= horizontalInset * 2
        size.height -= verticalInset * 2
        return size
    }
    
    private init(_ behavior: DialogBehavior) {
        self.behavior = behavior
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = DialogPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        controller.behavior = behavior
        return controller
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return behavior.presentation
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return behavior.dismissal
    }
}

private class DialogPresentationController: UIPresentationController {
    
    var behavior: DialogBehavior!
    
    private var overlay: UIView!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard
            let containerView = self.containerView,
            let presentedView = self.presentedView
            else {
                return .zero
        }
        
        if behavior.fixedSize == nil {
            let width = UIScreen.main.bounds.width - 60
            let height = width * 0.8
            behavior.fixedSize = CGSize(width: width, height: height)
        }
        
        let presentedSize = behavior.fixedSize ??
        presentedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return behavior.frame(
            containerSize: containerView.bounds.size,
            presentedSize: presentedSize
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
        
        if behavior.overlayIsBlur {
            let effect = UIBlurEffect(style: behavior.overlayBlurEffectStyle)
            overlay = UIVisualEffectView(effect: effect)
            overlay.frame = containerView.bounds
            overlay.backgroundColor = .clear
        } else {
            overlay = UIView(frame: containerView.bounds)
            overlay.backgroundColor = behavior.overlayColor
        }
        
        overlay.alpha = 0
        if behavior.overlayTapDismissalEnabled {
            overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOverlay)))
        }
        
        containerView.insertSubview(overlay, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [unowned self] context in
                self.overlay.alpha = self.behavior.overlayIsBlur ? self.behavior.overlayBlurAlpha : 1
                }, completion: nil)
        } else {
            overlay.alpha = behavior.overlayIsBlur ? self.behavior.overlayBlurAlpha : 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            overlay.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [unowned self] context in
                self.overlay.alpha = 0
                }, completion: nil)
        } else {
            overlay.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlay.removeFromSuperview()
            Dialog.instances.removeLast()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        overlay.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    @objc func didTapOverlay() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

open class DialogAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public let behavior: DialogBehavior
    
    public init(behavior: DialogBehavior) {
        self.behavior = behavior
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return behavior.animationDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // expect override
        transitionContext.completeTransition(true)
    }
}
