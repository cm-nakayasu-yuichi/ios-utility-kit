import UIKit

/// Chromeを開く用のUIActivity
public class ChromeActivity: UIActivity {
    
    private let url: URL
    private let title: String
    
    public init(url: URL, title: String = "Chromeで開く") {
        self.url = url
        self.title = title
        super.init()
    }
    
    override public var activityTitle: String? {
        return title
    }
    
    override public var activityImage: UIImage? {
        return UIImage(named: "icon_chrome")
    }
    
    override public func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    override public func prepare(withActivityItems activityItems: [Any]) {
        // NOP.
    }
    
    override public func perform() {
        let schemedUrlString = "googlechrome://" + url.absoluteString.urlEncoded
        
        if let targetUrl = URL(string: schemedUrlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(targetUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(targetUrl)
            }
        }
        self.activityDidFinish(true)
    }
}
