import UIKit

public protocol TextFieldManagerDelegate: AnyObject {
    
    /// テキストフィールドの値が変更された時に呼ばれる
    /// - Parameters:
    ///   - textFieldManager: テキストフィールドマネージャ
    ///   - text: 変更後の文字列
    func textFieldManager(_ textFieldManager: TextFieldManager, changed text: String)
    
    /// テキストフィールドの値が確定した時に呼ばれる
    /// - Parameters:
    ///   - textFieldManager: テキストフィールドマネージャ
    ///   - text: 確定した文字列
    func textFieldManager(_ textFieldManager: TextFieldManager, commit text: String)
    
    /// テキストフィールドで入力された値で変更を行うかどうかを返す
    /// - Parameters:
    ///   - textFieldManager: テキストフィールドマネージャ
    ///   - range: 変更箇所範囲
    ///   - string: 変更されようとしている値
    /// - Returns: 変更を行うかどうか。false を返すとテキストフィールドに反映されない
    func textFieldManager(_ textFieldManager: TextFieldManager, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

// optionals
extension TextFieldManagerDelegate {
    func textFieldManager(_ textFieldManager: TextFieldManager, changed text: String) {}
    func textFieldManager(_ textFieldManager: TextFieldManager, commit text: String) {}
    func textFieldManager(_ textFieldManager: TextFieldManager, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
}

public class TextFieldManager: NSObject, UITextFieldDelegate {
    
    /// 管理するテキストフィールド
    public private(set) weak var textField: UITextField!
    
    /// デリゲート
    public weak var delegate: TextFieldManagerDelegate?
    
    /// リターンキー押下で値を確定させるかどうか
    public var shouldCommitReturnKey = true
    
    /// 許可する文字列長
    public var maxLength: Int? = nil
    
    /// テキストフィールドの文字値(非オプショナル)
    public var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    
    private var previous = ""
    
    /// テキストフィールドの参照を渡して初期化
    /// - Parameter textField: テキストフィールドの参照
    public init(_ textField: UITextField) {
        self.textField = textField
        super.init()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        previous = text
    }
    
    /// キーボードを閉じてテキストフィールドの値を確定させる
    public func commit() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textFieldDidEndEditing(textField)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shouldCommitReturnKey {
            commit()
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let max = maxLength, text.count > max {
            text = String(text.prefix(max))
        }
        
        delegate?.textFieldManager(self, commit: text)
        textField.text = text
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textFieldManager(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    @objc public func textFieldDidEditingChanged(_ textField: UITextField) {
        if previous == text { return }
        previous = text
        
        delegate?.textFieldManager(self, changed: text)
    }
}

