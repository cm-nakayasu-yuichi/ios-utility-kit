import UIKit

extension UITableViewCell {
    
    /// 再利用されたセルが指定のセルクラスだった場合のみ、そのセルオブジェクトに対して処理を行う
    ///
    ///   ```
    ///   let cell = tableView.dequeueReusableCell(withIdentifier: row.identifier, for: indexPath)
    ///   cell.bind(as: BookListCell.self) { cell in
    ///       cell.book = row.book
    ///       cell.delegate = self
    ///   }
    ///   ```
    ///
    /// - Parameters:
    ///   - type: 指定するセルクラス
    ///   - binding:セルオブジェクトに対して行う処理
    ///
    public func bind<T: UITableViewCell>(as type: T.Type, binding: (T) throws -> ()) rethrows {
        if let cell = self as? T {
            try binding(cell)
        }
    }
}

extension UICollectionViewCell {
    
    /// 再利用されたセルが指定のセルクラスだった場合のみ、そのセルオブジェクトに対して処理を行う
    ///
    ///   ```
    ///   let cell = collectionView.dequeueReusableCell(withIdentifier: row.identifier, for: indexPath)
    ///   cell.bind(as: BookListCell.self) { cell in
    ///       cell.book = row.book
    ///       cell.delegate = self
    ///   }
    ///   ```
    ///
    /// - Parameters:
    ///   - type: 指定するセルクラス
    ///   - binding:セルオブジェクトに対して行う処理
    ///
    public func bind<T: UICollectionViewCell>(as type: T.Type, binding: (T) throws -> ()) rethrows {
        if let cell = self as? T {
            try binding(cell)
        }
    }
}

extension IndexPath {
    
    /// イニシャライザ
    ///
    /// このイニシャライザはinit(row:section:)のラッパーです
    ///
    /// - Parameters:
    ///   - row: 行
    ///   - section: セクション
    public init(_ row: Int, in section: Int = 0) {
        self.init(row: row, section: section)
    }
}

extension UITableView {
    
    /// テーブルビューにXIBでUIを定義したセルを登録する
    ///
    /// セルクラスと同名のXIBファイルがプロジェクト内に置かれている必要があります
    ///
    /// - Parameters:
    ///   - type: セルのクラス
    ///   - identifier: 再利用用のID文字列
    func register<T: UITableViewCell>(type: T.Type, forCellReuseIdentifier identifier: String) {
        let cellName = String(describing: type)
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// テーブルビューにXIBでUIを定義したヘッダ/フッタビューを登録する
    ///
    /// ヘッダ/フッタビュークラスと同名のXIBファイルがプロジェクト内に置かれている必要があります
    ///
    /// - Parameters:
    ///   - type: ヘッダ/フッタビューのクラス
    ///   - identifier: 再利用用のID文字列
    func register<T: UITableViewCell>(type: T.Type, forHeaderFooterViewReuseIdentifier identifier: String) {
        let viewName = String(describing: type)
        let nib = UINib(nibName: viewName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

extension UICollectionView {
    
    /// コレクションビューにXIBでUIを定義したセルを登録する
    ///
    /// セルクラスと同名のXIBファイルがプロジェクト内に置かれている必要があります
    ///
    /// - Parameters:
    ///   - type: セルのクラス
    ///   - identifier: 再利用用のID文字列
    func register<T: UICollectionViewCell>(type: T.Type, forCellReuseIdentifier identifier: String) {
        let cellName = String(describing: type)
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}
