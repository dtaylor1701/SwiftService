import Foundation

public struct ErrorResponse: Codable {
    public var error: Bool
    public var reason: String
}
