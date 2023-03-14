import Foundation
import CoreGraphics

public enum ResultWithProgress<Success, Failure> where Failure : Error {

    case success(Success)

    case failure(Failure)
    
    case progress(CGFloat)
}
