import UIKit

extension UIImage {
    
    /// グラフィックコンテキストの描画処理をラッピングして画像を生成する
    /// - Parameters:
    ///   - size: サイズ
    ///   - drawingBlock: 描画処理
    /// - Returns: 生成した画像
    public class func imageFromContext(_ size: CGSize, _ drawingBlock: (CGContext) -> Void) -> UIImage {
        UIGraphicsBeginImageContext(size)
        drawingBlock(UIGraphicsGetCurrentContext()!)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret!
    }
    
    /// 指定のサイズに拡大縮小した画像を生成して返す
    /// - parameter size: サイズ
    /// - returns: 拡大縮小した画像
    public func scaled(to size: CGSize) -> UIImage {
        return UIImage.imageFromContext(size) { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// 指定のサイズに縮尺を変更せずに拡大縮小した画像を生成して返す
    /// - Parameter fixedSize: サイズ
    /// - Returns: 縮尺を変更せずに拡大縮小した画像
    public func fixed(size fixedSize: CGSize) -> UIImage {
        return UIImage.imageFromContext(fixedSize) { _ in
            let rect = CGRect(
                (fixedSize.width - size.width) / 2,
                (fixedSize.height - size.height) / 2,
                size.width,
                size.height
            )
            draw(in: rect)
        }
    }
    
    /// 指定の領域で切り取った画像を生成して返す
    /// - parameter rect: 切り取る領域
    /// - returns: 切り取った画像
    public func cropped(to rect: CGRect) -> UIImage {
        guard let ref = cgImage?.cropping(to: rect) else {
            return UIImage.imageFromContext(rect.size) { _ in } // 空の画像
        }
        return UIImage(cgImage: ref, scale: scale, orientation: imageOrientation)
    }
    
    /// 指定の色でマスクした画像を返す
    /// - Parameter color: 色
    /// - Returns: 指定の色でマスクした画像
    public func masked(color: UIColor) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let bitmap = CGImageAlphaInfo.premultipliedLast.rawValue
        let space = CGColorSpaceCreateDeviceRGB()
        
        let contextOrNil = CGContext(
            data: nil,
            width: Int(rect.width),
            height: Int(rect.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: space,
            bitmapInfo: bitmap
        )
        guard let context = contextOrNil else { return nil }
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let imageRef = context.makeImage()!
        context.clear(rect)
        context.clip(to: rect, mask: cgImage!)
        context.draw(imageRef, in: rect)
        return UIImage(cgImage: context.makeImage()!)
    }
    
    /// 文字を画像化して返す
    /// - Parameters:
    ///   - text: 文字列
    ///   - color: 文字色
    ///   - font: フォント
    /// - Returns: 画像化された文字
    public class func text(_ text: String, color: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 32)) -> UIImage? {
        let ns = (text as NSString)
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let size = ns.size(withAttributes: attributes)
        return UIImage.imageFromContext(size) { _ in
            ns.draw(at: .zero, withAttributes: attributes)
        }
    }
}
