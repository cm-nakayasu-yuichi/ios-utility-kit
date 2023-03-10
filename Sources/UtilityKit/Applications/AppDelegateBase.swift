import UIKit

open class AppDelegateBase: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    /// シングルトンオブジェクト
    public static var shared: AppDelegateBase {
        return UIApplication.shared.delegate as! AppDelegateBase
    }
    
    /// 画面全体を指定のビューコントローラに変更する
    /// - Parameter controller: 変更するビューコントローラ
    public func change(to controller: UIViewController) {
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    /// ウィンドウシーンの取得
    public var windowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    /// キーウィンドウの取得
    public var keyWindow: UIWindow? {
        return windowScene?.windows.first(where: { $0.isKeyWindow })
    }
    
    /// ステータスバーの高さを取得
    public var statusBarHeight: CGFloat {
        return windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    /// セーフエリアのインセット
    public var safeAreaInsets: UIEdgeInsets {
        return keyWindow?.safeAreaInsets ?? .zero
    }
}

extension AppDelegateBase {
    
    /// 指定したクラスのビューコントローラが画面トップに存在するかを検索する
    /// - Parameter type: 検索するビューコントローラのクラス
    /// - Returns: ビューコントローラ。見つからなかった場合はnil
    public func searchTopViewController<T: UIViewController>(type: T.Type) -> T? {
        return searchTopViewControllerRecursive(targetViewController: keyWindow?.rootViewController) as? T
    }
    
    private func searchTopViewControllerRecursive(targetViewController: UIViewController?) -> UIViewController? {
        if let navigationController = targetViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return searchTopViewControllerRecursive(targetViewController: visibleViewController)
        }
        
        if let tabBarController = targetViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return searchTopViewControllerRecursive(targetViewController: selectedViewController)
        }
        
        if let presentedViewController = targetViewController?.presentedViewController {
            return searchTopViewControllerRecursive(targetViewController: presentedViewController)
        }
        
        return targetViewController
    }
}
