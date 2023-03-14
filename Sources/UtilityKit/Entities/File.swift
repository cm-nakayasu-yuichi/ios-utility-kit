import UIKit

public struct File {
    let path: String
}

extension File {
    
    /// ドキュメントディレクトリパス文字列
    public static let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory,
        .userDomainMask,
        true
    ).first!
    
    /// ライブラリディレクトリパス文字列
    public static let libraryDirectoryPath = NSSearchPathForDirectoriesInDomains(
        .libraryDirectory,
        .userDomainMask,
        true
    ).first!
    
    /// テンポラリディレクトリパス文字列
    public static let temporaryDirectoryPath = NSTemporaryDirectory()
    
    /// メインバンドルパス文字列
    public static let mainBundlePath = Bundle.main.bundlePath
    
    /// ドキュメントディレクトリ
    public static let documentDirectory = File(path: documentDirectoryPath)
    
    /// ライブラリディレクトリ
    public static let libraryDirectory = File(path: libraryDirectoryPath)
    
    /// テンポラリディレクトリ
    public static let temporaryDirectory = File(path: temporaryDirectoryPath)
    
    /// メインバンドル
    public static let mainBundle = File(path: mainBundlePath)
}

extension File {
    
    /// パスを追加したファイルオブジェクトを返す
    /// - Parameter pathComponent: 追加するパス
    /// - Returns: パスを追加したファイルオブジェクト
    public func append(pathComponent: String) -> File {
        return File(path: (path as NSString).appendingPathComponent(pathComponent))
    }
    
    public static func + (lhs: File, rhs: String) -> File {
        return lhs.append(pathComponent: rhs)
    }
}

extension File: Equatable {
    
    public static func == (lhs: File, rhs: File) -> Bool {
        return lhs.path == rhs.path
    }
}

extension File {
    
    /// ファイル(ディレクトリ)が存在するかどうか
    public var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}

extension File {
    
    /// 親ディレクトリのパス文字列
    public var parentDirectoryPath: String {
        if path == "/" { return "" }
        return (path as NSString).deletingLastPathComponent
    }
    
    /// 親ディレクトリのファイルオブジェクト
    public var parentDirectory: File {
        return File(path: parentDirectoryPath)
    }
}

extension File {
    
    /// ディレクトリを作成する
    /// - Throws: 作成失敗時はエラー
    public func makeDirectory() throws {
        if !exists {
            try FileManager.default.createDirectory(
                atPath: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
}

extension File {
    
    /// ファイルURL
    public var url: URL {
        return URL(fileURLWithPath: path)
    }
    
    /// ファイルのデータ
    public var data: Data? {
        return try? Data(contentsOf: url)
    }
}

extension File {
    
    /// ファイル内の文字列を取得する
    /// - Parameter encoding: エンコード
    /// - Returns: ファイルがテキストファイルである場合、その内容の文字列
    public func contents(encoding: String.Encoding) -> String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: encoding)
    }
    
    /// ファイル内の文字列 (UTF8でエンコード指定)
    public var contents: String? {
        return contents(encoding: .utf8)
    }

    /// ファイルに文字列を書き込む
    /// - Parameters:
    ///   - contents: 書き込む内容
    ///   - encoding: エンコード
    /// - Throws: 書き込み失敗時はエラー
    public func write(contents: String, encoding: String.Encoding = .utf8) throws {
        try parentDirectory.makeDirectory()
        try contents.write(to: url, atomically: false, encoding: encoding)
    }
}

extension File {
    
    /// 画像ファイルの画像
    public var image: UIImage? {
        guard let data = self.data else { return nil }
        return UIImage(data: data)
    }
    
    /// 画像をJPEG形式でファイルに書き込む
    /// - Parameters:
    ///   - image: 画像
    ///   - quality: 品質 (デフォルトは0.9)
    /// - Throws: 書き込み失敗時はエラー
    public func write(imageAsJpeg image: UIImage, quality: CGFloat = 0.9) throws {
        guard let data = image.jpegData(compressionQuality: quality) else { return }
        try parentDirectory.makeDirectory()
        try data.write(to: url)
    }
    
    /// 画像をPNG形式でファイルに書き込む
    /// - Parameters:
    ///   - image: 画像
    /// - Throws: 書き込み失敗時はエラー
    public func write(imageAsPng image: UIImage) throws {
        guard let data = image.pngData() else { return }
        try parentDirectory.makeDirectory()
        try data.write(to: url)
    }
}

extension File {
    
    /// ファイル名
    public var name: String {
        return (path as NSString).lastPathComponent
    }
    
    /// ドット付きの拡張子名
    public var `extension`: String {
        let ext = (name as NSString).pathExtension
        return ext.isEmpty ? "" : ".\(ext)"
    }
    
    /// ドット無しの拡張子名
    public var extensionWithoutDot: String {
        let ext = (name as NSString).pathExtension
        return ext.isEmpty ? "" : "\(ext)"
    }
    
    /// 拡張子を含めないファイル名
    public var nameWithoutExtension: String {
        return (name as NSString).deletingPathExtension
    }
}

extension File {
    
    /// ファイルかどうか
    public var isFile: Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return !isDirectory.boolValue
        }
        return false
    }
    
    /// ディレクトリかどうか
    public var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }
        return false
    }
}

extension File {

    /// 作成日時
    public var creationDate: Date? {
        return attributes[.creationDate] as? Date
    }
    
    /// 更新日時
    public var modificationDate: Date? {
        return attributes[.modificationDate] as? Date
    }
    
    /// ファイルサイズ
    public var size: UInt64 {
        return attributes[.size] as? UInt64 ?? 0
    }
    
    private var attributes: [FileAttributeKey : Any] {
        let attr1 = (try? FileManager.default.attributesOfFileSystem(forPath: path)) ?? [:]
        let attr2 = (try? FileManager.default.attributesOfItem(atPath: path)) ?? [:]
        return [attr1, attr2].reduce(into: [FileAttributeKey : Any](), { ret, attr in
            ret.merge(attr) { $1 }
        })
    }
}

extension File {
    
    /// ディレクトリ内のファイルオブジェクトの配列
    public var files: [File] {
        return filesMap { self + $0 }
    }
    
    /// ディレクトリ内のファイルパス文字列の配列
    public var filePaths: [String] {
        return filesMap { (self + $0).path }
    }
    
    /// ディレクトリ内のファイル名の配列
    public var fileNames: [String] {
        return filesMap { $0 }
    }
    
    private func filesMap<T>(_ transform: (String) throws -> (T)) rethrows -> [T] {
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: path) else {
            return []
        }
        return try fileNames.map { try transform($0) }
    }
}

extension File: CustomStringConvertible {
    
    public var description: String {
        let type = isDirectory ? "Dir" : "File"
        return "<\(type) \(name)>"
    }
}

extension File {
    
    /// ファイルを削除する
    /// - Throws: 削除失敗時はエラー
    public func delete() throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    /// ディレクトリ内のファイルをすべて削除
    /// - Throws: 削除失敗時はエラー
    public func deleteAllChildren() throws {
        try files.forEach { file in
            try file.delete()
        }
    }
    
    /// ファイルを指定の場所にコピーする
    /// - Parameters:
    ///   - destination: コピー先
    ///   - force: 既に存在している場合に上書きをするかどうか
    /// - Throws: コピー失敗時はエラー
    public func copy(to destination: File, force: Bool = true) throws {
        if force && destination.exists {
            try destination.delete()
        }
        try FileManager.default.copyItem(atPath: path, toPath: destination.path)
    }
    
    /// ファイルを指定の場所に移動する
    /// - Parameters:
    ///   - destination: 移動先
    ///   - force: 既に存在している場合に上書きをするかどうか
    /// - Throws: 移動失敗時はエラー
    public func move(to destination: File, force: Bool = true) throws {
        if force && destination.exists {
            try destination.delete()
        }
        try FileManager.default.moveItem(atPath: path, toPath: destination.path)
    }
    
    /// ファイルをリネームする
    /// - Parameters:
    ///   - name: リネーム後のファイル名
    ///   - force: 既に同名のファイルが存在している場合に上書きをするかどうか
    /// - Throws: リネーム失敗時はエラー
    public func rename(to name: String, force: Bool = true) throws -> File {
        let destination = File(path: parentDirectoryPath) + name
        try move(to: destination, force: force)
        return destination
    }
}

extension File {
    
    /// ファイル内のJSON文字列をデコードして指定の型のオブジェクトを取得する
    /// - Parameter type: 型
    /// - Throws: デコード失敗時はエラー
    /// - Returns: 指定の型のオブジェクト
    public func jsonDecoded<T>(_ type: T.Type) throws -> T? where T : Decodable {
        guard let data = self.data else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}

extension File {
    
    /// オブジェクトをJSON文字列データに変換する
    /// - Parameter value: エンコード可能なオブジェクト
    /// - Throws: エンコード失敗時はエラー
    /// - Returns: JSON文字列データ
    public func jsonEncode<T>(_ value: T) throws -> Data where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(value)
    }
    
    /// オブジェクトをJSON文字列に変換してファイルに書き込む
    /// - Parameters:
    ///   - value: エンコード可能なオブジェクト
    ///   - encoding: 文字列エンコード
    /// - Throws: 失敗時はエラー
    public func writeEncodedJson<T>(_ value: T, encoding: String.Encoding = .utf8) throws where T : Encodable {
        let encoded = try jsonEncode(value)
        let jsonString = String(data: encoded, encoding: encoding) ?? ""
        try parentDirectory.makeDirectory()
        try jsonString.write(to: url, atomically: false, encoding: encoding)
    }
}
