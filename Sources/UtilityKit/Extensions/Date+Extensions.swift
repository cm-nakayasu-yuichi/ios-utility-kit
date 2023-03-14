import Foundation

extension Date {
    
    /// 各コンポーネントを指定して初期化する
    ///
    /// 指定は省略可。指定しなかったコンポーネントは現時刻の値が使用される
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 時
    ///   - minute: 分
    ///   - second: 秒
    public init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        self.init()
        if let value = year   { self.year   = value }
        if let value = month  { self.month  = value }
        if let value = day    { self.day    = value }
        if let value = hour   { self.hour   = value }
        if let value = minute { self.minute = value }
        if let value = second { self.second = value }
    }
}

// MARK: - 列挙型

extension Date {
    
    public enum Week: Int {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    public enum MonthSymbol: Int {
        case january
        case february
        case march
        case april
        case may
        case june
        case july
        case august
        case september
        case october
        case november
        case december
    }
    
    public enum SymbolType {
        case `default`
        case standalone
        case veryShort
        case short
        case shortStandalone
        case veryShortStandalone
        case custom(symbols: [String])
    }
}

// MARK: - 各コンポーネント

extension Date {
    
    /// 年
    public var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            setComponentValue(newValue, for: .year)
        }
    }
    
    /// 月
    public var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            setComponentValue(newValue, for: .month)
        }
    }
    
    /// 日
    public var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            setComponentValue(newValue, for: .day)
        }
    }
    
    /// 時
    public var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            setComponentValue(newValue, for: .hour)
        }
    }
    
    /// 分
    public var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            setComponentValue(newValue, for: .minute)
        }
    }
    
    /// 秒
    public var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            setComponentValue(newValue, for: .second)
        }
    }
    
    private mutating func setComponentValue(_ value: Int, for component: Calendar.Component) {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.setValue(value, for: component)
        if let date = calendar.date(from: components) {
            self = date
        }
    }
}

// MARK: - 各コンポーネント絶対指定

extension Date {
    
    /// 各コンポーネントの値を絶対指定で変更する
    ///
    /// 指定は省略可
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 時
    ///   - minute: 分
    ///   - second: 秒
    public mutating func fix(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        if let value = year   { self.year   = value }
        if let value = month  { self.month  = value }
        if let value = day    { self.day    = value }
        if let value = hour   { self.hour   = value }
        if let value = minute { self.minute = value }
        if let value = second { self.second = value }
    }
    
    /// 各コンポーネントの値が絶対指定された新しい日付オブジェクトを返す
    ///
    /// 指定は省略可。指定しなかったコンポーネントは現時刻の値が使用される
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 時
    ///   - minute: 分
    ///   - second: 秒
    /// - Returns: 新しい日付オブジェクト
    public func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year   = year   ?? calendar.component(.year,   from: self)
        comp.month  = month  ?? calendar.component(.month,  from: self)
        comp.day    = day    ?? calendar.component(.day,    from: self)
        comp.hour   = hour   ?? calendar.component(.hour,   from: self)
        comp.minute = minute ?? calendar.component(.minute, from: self)
        comp.second = second ?? calendar.component(.second, from: self)
        
        return calendar.date(from: comp)!
    }
}

// MARK: - 各コンポーネント追加

extension Date {
    
    /// 各コンポーネントの値を追加する
    ///
    /// 指定は省略可
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 時
    ///   - minute: 分
    ///   - second: 秒
    public mutating func add(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        if let value = year   { self.year   += value }
        if let value = month  { self.month  += value }
        if let value = day    { self.day    += value }
        if let value = hour   { self.hour   += value }
        if let value = minute { self.minute += value }
        if let value = second { self.second += value }
    }
    
    /// 各コンポーネントの値を追加した新しい日付オブジェクトを返す
    ///
    /// 指定は省略可。指定しなかったコンポーネントは現時刻の値が使用される
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 時
    ///   - minute: 分
    ///   - second: 秒
    /// - Returns: 新しい日付オブジェクト
    public func added(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year   = (year   ?? 0) + calendar.component(.year,   from: self)
        comp.month  = (month  ?? 0) + calendar.component(.month,  from: self)
        comp.day    = (day    ?? 0) + calendar.component(.day,    from: self)
        comp.hour   = (hour   ?? 0) + calendar.component(.hour,   from: self)
        comp.minute = (minute ?? 0) + calendar.component(.minute, from: self)
        comp.second = (second ?? 0) + calendar.component(.second, from: self)
        
        return calendar.date(from: comp)!
    }
}

// MARK: - 文字列変換

extension Date {
    
    /// 文字列から日付への変換
    /// - Parameters:
    ///   - dateString: 日付文字列
    ///   - format: フォーマット
    /// - Returns: 日付オブジェクト
    public static func dateFromString(_ string: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = Date.commonDateFormatter(format: format)
        return formatter.date(from: string)
    }
    
    /// 日付から文字列への変換
    /// - Parameter format: フォーマット
    /// - Returns: 日付文字列
    public func string(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = Date.commonDateFormatter(format: format)
        return formatter.string(from: self)
    }
    
    /// ISO8601文字列から日付への変換
    /// - Parameters:
    ///   - string: 日付文字列
    ///   - options: オプション
    /// - Returns: 日付オブジェクト
    public static func dateFromISO8601String(_ string: String, options: ISO8601DateFormatter.Options? = nil) -> Date? {
        let formatter = commonISO8601DateFormatter(options: options)
        return formatter.date(from: string)
    }
    
    /// ISO8601形式の日付文字列取得
    /// - Parameter options: オプション
    /// - Returns: ISO8601形式の日付文字列
    public func iso8601String(options: ISO8601DateFormatter.Options? = nil) -> String {
        return Date.commonISO8601DateFormatter(options: options).string(from: self)
    }
    
    private static func commonDateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.japan
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
    
    private static func commonISO8601DateFormatter(options: ISO8601DateFormatter.Options?) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        if let options = options {
            formatter.formatOptions = options
        }
        formatter.timeZone = .japan
        return formatter
    }
}

// MARK: - 時刻揃え

extension Date {
    
    /// 0分0秒に揃えた日付オブジェクト
    public var oclock: Date {
        return fixed(minute: 0, second: 0)
    }
    
    /// 0時0分0秒に揃えた日付オブジェクト
    public var zeroclock: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }
    
    /// 日の先頭時刻(0時0分0秒)に揃えた日付オブジェクト
    ///
    /// zeroclockと同値が返る
    public var firstOfDay: Date {
        return zeroclock
    }
    
    /// 日の最終時刻(23時59分59秒)に揃えた日付オブジェクト
    public var lastOfDay: Date {
        return fixed(hour: 23, minute: 59, second: 59)
    }
    
    /// 0時0分0秒に設定された現在月の月初の日付オブジェクト
    public var firstDayOfMonth: Date {
        return fixed(day: 1, hour: 0, minute: 0, second: 0)
    }
    
    /// 0時0分0秒に設定された現在月の月末の日付オブジェクト
    public var lastDayOfMonth: Date {
        return added(month: 1).fixed(day: 0, hour: 0, minute: 0, second: 0)
    }
    
    /// 0分0秒に揃える
    public mutating func setOclock() -> Date {
        fix(minute: 0, second: 0)
        return self
    }
    
    /// 0時0分0秒に揃える
    public mutating func setZeroclock() -> Date {
        fix(hour: 0, minute: 0, second: 0)
        return self
    }
    
    /// 日の先頭時刻(0時0分0秒)に揃える
    public mutating func setFirstOfDay() -> Date {
        fix(hour: 0, minute: 0, second: 0)
        return self
    }
    
    /// 日の最終時刻(23時59分59秒)に揃える
    public mutating func setLastOfDay() -> Date {
        fix(hour: 23, minute: 59, second: 59)
        return self
    }
    
    /// 0時0分0秒に設定された現在月の月初に揃える
    public mutating func setFirstDayOfMonth() -> Date {
        fix(hour: 23, minute: 59, second: 59)
        return self
    }
    
    /// 0時0分0秒に設定された現在月の月末に揃える
    public mutating func setLastDayOfMonth() -> Date {
        fix(hour: 0, minute: 0, second: 0)
        return self
    }
}
// MARK: - 日付オブジェクトの生成

extension Date {
    
    /// 0時0分0秒に設定された本日の日付オブジェクト
    public static var today: Date {
        return now.zeroclock
    }
    
    /// 0時0分0秒に設定された指定した日数後の日付オブジェクト
    /// - Parameter days: 日数
    /// - Returns: 日付オブジェクト
    public static func day(after days: Int) -> Date {
        return today.added(day: days)
    }
    
    /// 0時0分0秒に設定された昨日の日付オブジェクト
    public static var yesterday: Date {
        return day(after: -1)
    }
    
    /// 0時0分0秒に設定された明日の日付オブジェクト
    public static var tomorrow: Date {
        return day(after: 1)
    }
    
    /// 0時0分0秒に設定された明後日の日付オブジェクト
    public static var dayAfterTomorrow: Date {
        return day(after: 2)
    }
}

// MARK: - 日付の比較

extension Date {
    
    /// 時刻は問わず同じ日かどうか
    /// - Parameter otherDay: 比較する日付オブジェクト
    /// - Returns: 時刻は問わず同じ日かどうか
    public func isSameDay(_ otherDay: Date) -> Bool {
        return self.zeroclock == otherDay.zeroclock
    }
    
    /// 日・時刻は問わず同じ月かどうか
    /// - Parameter otherDay: 比較する日付オブジェクト
    /// - Returns: 日・時刻は問わず同じ月かどうか
    public func isSameMonth(_ otherDay: Date) -> Bool {
        return year == otherDay.year && month == otherDay.month
    }
    
    /// 時刻は問わず指定した日数後の日付かどうか
    /// - Parameter days: 日数
    /// - Returns: 時刻は問わず指定した日数後の日付かどうか
    public func isSameDay(after days: Int) -> Bool {
        return isSameDay(Date.day(after: days))
    }
    
    /// 時刻は問わず本日の日付かどうか
    public var isToday: Bool {
        return isSameDay(Date.today)
    }
    
    /// 時刻は問わず昨日の日付かどうか
    public var isYesterday: Bool {
        return isSameDay(Date.yesterday)
    }
    
    /// 時刻は問わず明日の日付かどうか
    public var isTomorrow: Bool {
        return isSameDay(Date.tomorrow)
    }
    
    /// 時刻は問わず明後日の日付かどうか
    public var isDayAfterTomorrow: Bool {
        return isSameDay(Date.dayAfterTomorrow)
    }
}

// MARK: - 曜日

extension Date {
    
    /// 曜日インデックス (0〜6)
    public var weekIndex: Int {
        // index値を 1〜7 から 0〜6 にしている
        return calendar.component(.weekday, from: self) - 1
    }
    
    /// 日曜日かどうか
    public var isSunday: Bool {
        return weekIndex == Week.sunday.rawValue
    }
    
    /// 土曜日かどうか
    public var isSaturday: Bool {
        return weekIndex == Week.saturday.rawValue
    }
    
    /// 週末(土日)かどうか
    public var isWeekend: Bool {
        return isSunday || isSaturday
    }
    
    /// 平日(土日以外)かどうか
    public var isUsualDay: Bool {
        return !isWeekend
    }
    
    /// 曜日の文字列配列を取得する
    /// - Parameters:
    ///   - type: 種別
    ///   - locale: ロケール (省略時は日本)
    /// - Returns: 曜日の文字列配列
    public func weeks(_ type: SymbolType = .short, locale: Locale? = nil) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = locale ?? calendar.locale
        
        switch type {
        case .`default`:           return formatter.weekdaySymbols
        case .standalone:          return formatter.standaloneWeekdaySymbols
        case .veryShort:           return formatter.veryShortWeekdaySymbols
        case .short:               return formatter.shortWeekdaySymbols
        case .shortStandalone:     return formatter.shortStandaloneWeekdaySymbols
        case .veryShortStandalone: return formatter.veryShortStandaloneWeekdaySymbols
        case let .custom(symbols): return symbols
        }
    }
    
    /// 曜日を文字列で取得する
    /// - Parameters:
    ///   - type: 種別
    ///   - locale: ロケール (省略時は日本)
    /// - Returns: 曜日の文字列
    public func week(_ type: SymbolType = .short, locale: Locale? = nil) -> String {
        return weeks(type, locale: locale)[weekIndex]
    }
    
    /// 曜日の文字列
    ///
    /// week(:locale:) メソッドの引数をすべて省略した値と同値が返る
    public var weekName: String {
        return week()
    }
    
    /// 曜日の列挙値
    public var weekValue: Week {
        return Week(rawValue: weekIndex)!
    }
}

// MARK: - 月

extension Date {
    
    /// 月インデックス
    public var monthIndex: Int {
        // index値を 1〜12 から 0〜11 にしている
        return calendar.component(.month, from: self) - 1
    }
    
    /// 月の文字列表現の配列を取得する
    /// - Parameters:
    ///   - type: 種別
    ///   - locale: ロケール (省略時は日本)
    /// - Returns: 月の文字列表現の配列
    public func monthSymbols(_ type: SymbolType = .short, locale: Locale? = nil) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = locale ?? calendar.locale
        
        switch type {
        case .`default`:           return formatter.monthSymbols
        case .standalone:          return formatter.standaloneMonthSymbols
        case .veryShort:           return formatter.veryShortMonthSymbols
        case .short:               return formatter.shortMonthSymbols
        case .shortStandalone:     return formatter.shortStandaloneMonthSymbols
        case .veryShortStandalone: return formatter.veryShortStandaloneMonthSymbols
        case let .custom(symbols): return symbols
        }
    }
    
    /// 月の文字列表現を取得する
    /// - Parameters:
    ///   - type: 種別
    ///   - locale: ロケール (省略時は日本)
    /// - Returns: 月の文字列表現
    public func monthSymbol(_ type: SymbolType = .short, locale: Locale? = nil) -> String {
        return monthSymbols(type, locale: locale)[monthIndex]
    }
    
    /// 月の文字列表現
    ///
    /// monthSymbol(:locale:) メソッドの引数をすべて省略した値と同値が返る
    public var monthSymbolName: String {
        return monthSymbol()
    }
}

// MARK: - カレンダー用配列処理

extension Date {
    
    /// 月内すべての日付オブジェクトの配列
    public var datesInMonth: [Date] {
        return Date.dates(year: year, month: month)
    }
    
    /// 指定した年月の月内すべての日付オブジェクトの配列
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 日付オブジェクトの配列
    public static func dates(year: Int, month: Int) -> [Date] {
        let date = Date(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0)
        return (date.firstDayOfMonth.day...date.lastDayOfMonth.day).map { day in
            date.fixed(day: day).zeroclock
        }
    }
    
    /// 指定した年月のカレンダー用(前月・次月を一部含む)の日付オブジェクトの配列を返す
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - startWeek: 開始曜日 (デフォルトは日曜日)
    /// - Returns: 日付オブジェクトの配列
    public static func datesForCalendar(year: Int, month: Int, startWeek: Date.Week = .sunday) -> [Date] {
        var ret = [Date]()
        let weeks = Week.items(startWeek: startWeek)
        let date = Date(year: year, month: month).zeroclock
        
        if let weekIndex = weeks.firstIndex(of: date.firstDayOfMonth.weekValue) {
            for i in 0..<weekIndex {
                let n = -(weekIndex - i)
                ret.append(date.firstDayOfMonth.added(day: n))
            }
        }
        
        ret.append(contentsOf: date.datesInMonth)
        
        if let weekIndex = weeks.firstIndex(of: date.lastDayOfMonth.weekValue), weekIndex + 1 < 7 {
            for i in (weekIndex + 1)..<7 {
                ret.append(date.lastDayOfMonth.added(day: i))
            }
        }
        
        return ret
    }
    
    /// 指定した年月のカレンダー用(前月・次月を一部含む)の日付オブジェクトの配列を返す。
    /// 週ごとに配列が区切られている状態で返る
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - startWeek: 開始曜日 (デフォルトは日曜日)
    /// - Returns: 日付オブジェクト配列の配列
    public static func datesMatrixForCalendar(year: Int, month: Int, startWeek: Date.Week = .sunday) -> [[Date]] {
        var ret = [[Date]]()
        var i = 0, add = 1
        let dates = datesForCalendar(year: year, month: month, startWeek: startWeek)
        
        (0..<6).forEach { _ in // rows
            var columns = [Date]()
            (0..<7).forEach { _ in // columns
                if i <= dates.count - 1 {
                    columns.append(dates[i])
                    i += 1
                } else {
                    columns.append(dates.last!.added(day: add))
                    add += 1
                }
            }
            ret.append(columns)
        }
        
        return ret
    }
}

// MARK: - カレンダー/タイムゾーン/ロケール

private extension Date {
    
    var calendar: Calendar {
        return .japan
    }
}

extension Calendar {
    
    public static var japan: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale = .japan
        return calendar
    }
}

extension TimeZone {
    
    public static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    
    public static let japan = Locale(identifier: "ja_JP")
}

// MARK: - 曜日拡張

extension Date.Week {
    
    public static func items(startWeek: Date.Week = .sunday) -> [Date.Week] {
        return (0..<7).map { i -> Date.Week in // 7 = number of weeks
            let n = startWeek.rawValue + i
            let m = (n < 7) ? n : n - 7
            return Date.Week(rawValue: m)!
        }
    }
}

// MARK: - 配列処理

extension Array where Element == Date {
    
    /// 日付文字列の配列への変換
    /// - Parameter format: フォーマット
    /// - Returns: 日付文字列の配列
    public func strings(format: String = "yyyy-MM-dd HH:mm:ss") -> [String] {
        return map { $0.string(format: format) }
    }
}

extension Array where Element == [Date] {
    
    /// 日付文字列の配列への変換
    /// - Parameter format: フォーマット
    /// - Returns: 日付文字列の配列
    public func strings(format: String = "yyyy-MM-dd HH:mm:ss") -> [[String]] {
        return map { $0.map { $0.string(format: format) } }
    }
}

