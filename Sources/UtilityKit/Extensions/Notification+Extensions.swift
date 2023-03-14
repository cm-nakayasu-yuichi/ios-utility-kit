import Foundation

extension Notification.Name {
    
    /// 通知を監視する
    ///
    /// ```
    /// // 使用例
    /// UIApplication.didBecomeActiveNotification.observe { _ in
    ///     // アプリがアクティブになったときの処理
    /// }
    /// ```
    /// - Parameter handler: 通知が飛んできた時の処理
    public func observe(handler: @escaping (Notification) -> ()) {
        NotificationCenter.default.addObserver(
            forName: self,
            object: nil,
            queue: nil,
            using: handler
        )
    }
    
    /// 通知をポストする
    ///
    /// ```
    /// // 使用例
    /// UIApplication.didBecomeActiveNotification.post()
    /// ```
    /// - Parameters:
    ///   - object: オブジェクト
    ///   - userInfo: ユーザインフォ
    public func post(object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(
            name: self,
            object: object,
            userInfo: userInfo
        )
    }
}
