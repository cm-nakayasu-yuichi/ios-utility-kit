import Foundation
import CoreGraphics

public class ThreadManager {
    
    /// メインスレッドで処理を行う
    /// - Parameter block: 処理
    public static func main(block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }
    
    /// 別スレッドで処理を行う
    /// - Parameter block: 処理
    public static func new(block: @escaping () -> ()) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    /// 別スレッドで処理を行った後にメインスレッドで処理を行う
    /// - Parameters:
    ///   - asynchronousProcess: 別スレッドでの処理
    ///   - completion: メインスレッドでの処理
    public static func async(_ asynchronousProcess: @escaping () -> (), completion: @escaping () -> ()) {
        new {
            asynchronousProcess()
            main {
                completion()
            }
        }
    }
    
    /// タイマー処理を行う
    ///
    /// 繰り返し回数を指定した場合
    /// ```
    /// _ = ThreadManager.timer(interval: 1.0, count: 5, fired: { index in
    ///     // 発火時処理
    ///     // 引数(index)から繰り返し回数のインデックスを取得できる
    /// }, finished: {
    ///     // 終了時処理
    /// })
    /// ```
    /// 繰り返し回数を指定しない場合
    /// ```
    /// let timer = ThreadManager.timer(interval: 1.0, count: nil) { _ in
    ///     // 発火時処理
    ///     // 引数は常に0で渡される
    /// }
    ///
    /// // タイマーを終了させる処理を入れなければ永久にループされるので注意
    /// timer.invalidate()
    /// ```
    ///
    /// - Parameters:
    ///   - interval: タイマーのインターバル
    ///   - count: 繰り返す回数 (nilにした場合は永久ループするので、戻り値のtimerに対してinvalidate()を呼ぶ必要があります)
    ///   - fired: タイマーが発火した時の処理
    ///   - finished: 繰り返しのカウントを終えた時の処理 (count == nil の場合は呼ばれない)
    /// - Returns: 実行開始されたタイマーオブジェクト
    public static func timer(interval: TimeInterval, count: Int?, fired: @escaping (Int) -> (), finished: (() -> ())? = nil) -> Timer {
        var mutableCount = count
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let index = mutableCount == nil ? 0 : count! - mutableCount!
            fired(index)
            
            if mutableCount == nil {
                return
            }
            
            mutableCount! -= 1
            if mutableCount! <= 0 {
                finished?()
                timer.invalidate()
            }
        }
    }
    
    /// 非同期にスリープする
    /// - Parameters:
    ///   - interval: スリープする期間
    ///   - block: スリープ後のメインスレッドでの処理
    public static func sleepAsync(interval: DispatchTimeInterval, block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: block)
    }
    
    /// 非同期にスリープする
    /// - Parameters:
    ///   - seconds: スリープする秒数
    ///   - block: スリープ後のメインスレッドでの処理
    public static func sleepAsync(seconds: Double, block: @escaping () -> ()) {
        sleepAsync(interval: .microseconds(Int(seconds * 1000000)), block: block)
    }
    
    /// 同期的にスリープする
    /// - Parameter seconds: スリープする秒数
    public static func sleepSync(seconds: Double) {
        Darwin.usleep(UInt32(seconds * 1000000))
    }
}
