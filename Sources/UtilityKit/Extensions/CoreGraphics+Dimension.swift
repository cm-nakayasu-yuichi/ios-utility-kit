import UIKit

extension CGFloat {
    
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public static func safeAreaTop(_ view: UIView) -> CGFloat {
        return view.safeAreaInsets.top
    }
    
    public static func safeAreaBottom(_ view: UIView) -> CGFloat {
        return view.safeAreaInsets.bottom
    }
    
    public static func safeAreaTop(_ viewController: UIViewController) -> CGFloat {
        return viewController.view.safeAreaInsets.top
    }
    
    public static func safeAreaBottom(_ viewController: UIViewController) -> CGFloat {
        return viewController.view.safeAreaInsets.bottom
    }
}
