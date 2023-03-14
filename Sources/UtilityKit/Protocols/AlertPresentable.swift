import UIKit

public protocol AlertPresentable {
    // No Interface.
}

extension AlertPresentable where Self: UIViewController {
    
    /// エラーダイアログを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - whenOk: OKを押下したときの処理
    public func showErrorDialog(message: String?, whenOk: (() -> ())? = nil) {
        showAlertDialog(message: message, title: "エラー", actions: [
            UIAlertAction(title: "OK", style: .default, handler: { _ in whenOk?() })
        ])
    }
    
    /// ボタンがOKのみのアラートダイアログを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - title: タイトル
    ///   - whenOk: OKを押下したときの処理
    public func showOkDialog(message: String?, title: String? = nil, whenOk: (() -> ())? = nil) {
        showAlertDialog(message: message, title: title, actions: [
            UIAlertAction(title: "OK", style: .default, handler: { _ in whenOk?() })
        ])
    }
    
    /// OKボタンとキャンセルボタンを設置したアラートダイアログを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - title: タイトル
    ///   - whenOk: OKを押下したときの処理
    ///   - whenCancel: キャンセルを押下したときの処理
    public func showOkCancelDialog(message: String?, title: String? = nil, whenOk: (() -> ())? = nil, whenCancel: (() -> ())? = nil) {
        showAlertDialog(message: message, title: title, actions: [
            UIAlertAction(title: "OK", style: .default, handler: { _ in whenOk?() }),
            UIAlertAction(title: "キャンセル", style: .default, handler: { _ in whenCancel?() })
        ])
    }
    
    /// はいボタンといいえボタンを設置したアラートダイアログを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - title: タイトル
    ///   - whenYes: はいを押下したときの処理
    ///   - whenNo: いいえを押下したときの処理
    public func showYesNoDialog(message: String?, title: String? = nil, whenYes: (() -> ())? = nil, whenNo: (() -> ())? = nil) {
        showAlertDialog(message: message, title: title, actions: [
            UIAlertAction(title: "はい", style: .default, handler: { _ in whenYes?() }),
            UIAlertAction(title: "いいえ", style: .default, handler: { _ in whenNo?() }),
        ])
    }
    
    /// 削除ボタンとキャンセルボタンを設置したアラートダイアログを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - title: タイトル
    ///   - whenDelete: 削除を押下したときの処理
    ///   - whenCancel: キャンセルを押下したときの処理
    public func showDeleteCancelDialog(message: String?, title: String? = nil, whenDelete: (() -> ())? = nil, whenCancel: (() -> ())? = nil) {
        showAlertDialog(message: message, title: title, actions: [
            UIAlertAction(title: "削除", style: .destructive, handler: { _ in whenDelete?() }),
            UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in whenCancel?() })
        ])
    }
    
    /// アラートダイアログを表示する
    /// - Parameters:
    ///   - message: メッセージ
    ///   - title: タイトル
    ///   - actions: アラートアクションの配列
    public func showAlertDialog(message: String?, title: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}
