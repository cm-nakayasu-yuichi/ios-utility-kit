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
    public func bind<T>(as type: T.Type, binding: (T) throws -> ()) rethrows {
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
