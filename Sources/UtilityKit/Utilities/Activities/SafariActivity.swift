import UIKit

/// Safariを開く用のUIActivity
public class SafariActivity: UIActivity {
    
    private let url: URL
    private let title: String
    
    public init(url: URL, title: String = "Safariで開く") {
        self.url = url
        self.title = title
        super.init()
    }
    
    override public var activityTitle: String? {
        return title
    }
    
    override public var activityImage: UIImage? {
        return UIImage(named: "icon_safari")
    }
    
    override public func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    override public func prepare(withActivityItems activityItems: [Any]) {
        // NOP.
    }
    
    override public func perform() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        self.activityDidFinish(true)
    }
}
