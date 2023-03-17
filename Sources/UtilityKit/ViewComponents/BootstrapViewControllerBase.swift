import UIKit

/// 動作確認用のブートストラップビューコントローラの規定クラス
open class BootstrapViewControllerBase: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public typealias Section = (String, [Row])
    public typealias Row = (String, (UIViewController) -> ())
    
    /// テーブルに表示するアイテム
    ///
    /// ```
    /// open override var sections: [Section] = [
    ///     ("動作確認", [
    ///         // thisにはBootstrapViewCpntrollerのインスタンスが代入されている
    ///         ("画面遷移のテスト", { this in
    ///             let vc = NewViewController()
    ///             this.present(vc)
    ///         }),
    ///     ]),
    /// ]
    /// ```
    open func sections() -> [Section] { return [] }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: .zero)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "row")
        
        view.addSubview(tableView)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections().count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections()[section]
        return section.1.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections()[indexPath.section].1[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
        cell.textLabel?.text = row.0
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = sections()[indexPath.section].1[indexPath.row]
        row.1(self)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections()[section].0
    }
}
