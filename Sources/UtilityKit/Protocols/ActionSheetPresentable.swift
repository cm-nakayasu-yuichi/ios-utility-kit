import UIKit

public protocol ActionSheetPresentable {
    // No Interface.
}

extension ActionSheetPresentable where Self: UIViewController {
    
    /// アクションシートを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - title: タイトル
    ///   - actions: アラートアクションの配列
    public func showActionSheet(message: String?, title: String?, actions: [UIAlertAction]) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true, completion: nil)
    }
}
