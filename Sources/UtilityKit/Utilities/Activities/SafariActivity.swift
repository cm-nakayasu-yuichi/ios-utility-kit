import UIKit

open class SafariActivity: UIActivity {
    
    private let title: String
    
    public init(title: String = "Safariで開く") {
        self.title = title
        super.init()
    }
    
    open override class var activityCategory: UIActivity.Category {
        return .action
    }
    
    open override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.apple.Safari.openurl")
    }
    
    open override var activityTitle: String? {
        return title
    }
    
    override public var activityImage: UIImage? {
        return UIImage(named: "icon_safari", in: Bundle.module, compatibleWith: nil)
    }
    
    open override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems where activityItem is URL {
            return true
        }
        return false
    }
    
    open override func prepare(withActivityItems activityItems: [Any]) {
        for activityItem in activityItems {
            if let url = activityItem as? URL, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
