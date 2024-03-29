import UIKit

extension UIImage {
    
    /// 画像ファイルパスから画像を初期化する
    /// - parameter path: 画像ファイルパス
    public convenience init?(path: String) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        self.init(data: data)
    }
    
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
    
    /// 指定の領域で切り取った画像を生成して返す
    /// - parameter rect: 切り取る領域
    /// - returns: 切り取った画像
    public func cropped(to rect: CGRect) -> UIImage {
        guard let ref = cgImage?.cropping(to: rect) else {
            return UIImage.imageFromContext(rect.size) { _ in } // 空の画像
        }
        return UIImage(cgImage: ref, scale: scale, orientation: imageOrientation)
    }
    
    /// 画像のサイズは固定したまま指定のサイズへと変更した画像を生成して返す
    ///
    /// - Parameters:
    ///   - size: 指定のサイズ
    ///   - position: 位置(省略した(nilの)場合は中央位置)
    /// - Returns: 指定のサイズへと変更した画像
    public func resized(to size: CGSize, position: CGPoint? = nil) -> UIImage {
        let pos: CGPoint
        if position != nil {
            pos = position!
        } else {
            pos = CGPoint(
                x: (self.size.width - size.width) / 2,
                y: (self.size.height - size.height) / 2
            )
        }
        return UIImage.imageFromContext(size) { _ in
            let rect = CGRect(origin: pos, size: self.size)
            draw(in: rect)
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
    
    /// 指定した画像を重ね合わせた画像を生成して返す
    /// - Parameters:
    ///   - image: 重ねる画像
    ///   - position: 位置
    /// - Returns: 合成した画像
    public func synthesized(image: UIImage, position: CGPoint? = nil) -> UIImage {
        return UIImage.imageFromContext(size) { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
            
            let pos: CGPoint
            if position != nil {
                pos = position!
            } else {
                pos = CGPoint(
                    x: (size.width - image.size.width) / 2,
                    y: (size.height - image.size.height) / 2
                )
            }
            image.draw(in: CGRect(origin: pos, size: image.size))
        }
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
    
    /// 指定したサイズに収まるように拡大縮小(またはリサイズ)と切り取りをを行った画像を生成して返す
    /// - Parameters:
    ///   - size: 変更後のサイズ
    ///   - expand: 拡大縮小させる(元画像を引き延ばす)かどうか
    /// - Returns: 調整されたがぞ合う
    public func adjusted(to size: CGSize, shouldExpand expand: Bool = true) -> UIImage {
        
        // 再帰的に適切なサイズを探す内部関数
        func findProperSize(_ src: CGSize, dst: CGSize, reverse: Bool = false) -> CGSize {
            
            let scale: CGFloat, w: CGFloat, h: CGFloat
            
            if (!reverse && src.width > src.height) || (reverse && src.height > src.width) {
                scale = dst.width / src.width
                w = dst.width
                h = CGFloat(lroundf(Float(src.height * scale)))
            } else {
                scale = dst.height / src.height
                w = CGFloat(lroundf(Float(src.width * scale)))
                h = dst.height
            }
            
            let ret = CGSize(width: w, height: h)
            if w < dst.width || h < dst.height {
                return findProperSize(ret, dst: dst, reverse: !reverse)
            } else {
                return ret
            }
        }
        let scaledSize = findProperSize(self.size, dst: size)
        
        // 拡大縮小されたサイズから切り取る領域を計算
        var cropRect = CGRect(origin: .zero, size: size)
        if scaledSize.width > size.width {
            cropRect.origin.x = (scaledSize.width - size.width) / 2
        }
        if scaledSize.height > size.height {
            cropRect.origin.y = (scaledSize.height - size.height) / 2
        }
        
        // 拡大縮小実行
        var ret: UIImage
        if expand {
            ret = self.scaled(to: scaledSize)
        } else {
            ret = self.resized(to: scaledSize)
        }
        // 切り取り実行
        ret = ret.cropped(to: cropRect)
        
        return ret
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
    
    /// 空の画像を返す
    /// - Parameter size: サイズ
    /// - Returns: 空の画像
    public class func emptyImage(size: CGSize) -> UIImage {
        return imageFromContext(size) { _ in }
    }
    
    /// 指定した色で埋めた画像を生成して返す
    /// - Parameters:
    ///   - color: 色
    ///   - size: サイズ
    /// - Returns: 指定した色で埋めた画像
    public class func filled(color: UIColor?, size: CGSize) -> UIImage {
        return imageFromContext(size) { context in
            let filledColor = color ?? UIColor.clear
            context.saveGState()
            context.setFillColor(filledColor.cgColor)
            context.fill(CGRect(origin: CGPoint.zero, size: size))
            context.restoreGState()
        }
    }
    
    /// 透明のような見た目の画像を指定したサイズで生成して返す
    /// - Parameters:
    ///   - size: サイズ
    ///   - squareWidth: マス目の一辺の幅
    /// - Returns: 透明のような見た目の画像
    public class func transparentImage(size: CGSize, squareWidth: CGFloat = 10.0) -> UIImage {
        return imageFromContext(size) { context in
            let square = squareWidth
            var oddRow = false
            var oddCol = false
            
            let remainerWidth = size.width.truncatingRemainder(dividingBy: squareWidth)
            let remainerHeight = size.height.truncatingRemainder(dividingBy: squareWidth)
            var loc = CGPoint(x: -(remainerWidth / 2), y: -(remainerHeight / 2))
            
            while loc.y < size.height {
                oddRow = !oddRow
                oddCol = oddRow
                while loc.x < size.width {
                    let color = oddCol ? UIColor.white.withAlphaComponent(0.6) : UIColor.white.withAlphaComponent(0.3)
                    let frame = CGRect(x: loc.x, y: loc.y, width: square, height: square)
                    context.saveGState()
                    context.setFillColor(color.cgColor)
                    context.fill(frame)
                    context.restoreGState()
                    loc.x += square
                    oddCol = !oddCol
                }
                loc.x = -(size.width.truncatingRemainder(dividingBy: squareWidth) / 2)
                loc.y += square
            }
        }
    }
}
