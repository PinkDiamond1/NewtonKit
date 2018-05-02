
import Foundation
import CoreFoundation

// TODO:
// From NCX:
//
// "A NewtonScript date is classically the number of minutes
// since 1904.
//
// However…
//
// Newton measures time in seconds since 1993, but 2^29 seconds
// (signed NewtonScript integer) overflow in 2010.
//
// Avi Drissman’s fix (Fix2010) for this is rebase seconds on
// a hexade (16 years): 1993, 2009, 2025…"
//
// The Newton returns the unpatched value of Time(), so it
// needs to be offset here

public struct CurrentTimePacket: DecodableDockPacket {

    public static let command: DockCommand = .currentTime

    public enum DecodingError: Error {
        case invalidDate
    }

    public let date: Date

    public init(data: Data) throws {
        guard let minutesSince1904 = UInt32(bigEndianData: data) else {
            throw DecodingError.invalidDate
        }
        date = Date(timeIntervalSinceReferenceDate:
            -kCFAbsoluteTimeIntervalSince1904
            + Double(minutesSince1904) * 60.0
        )
    }
}