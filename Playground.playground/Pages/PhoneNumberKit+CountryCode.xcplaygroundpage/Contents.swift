//: [Previous](@previous)

import Foundation
import PhoneNumberKit

extension String {
    var cleanPhoneNumber: String {
        let notPhoneCharacters = CharacterSet(charactersIn: "+*#0123456789").inverted
        return self.components(separatedBy: notPhoneCharacters).joined(separator: "")
    }

    var digitsOnly: String {
        let notDigits = CharacterSet.decimalDigits.inverted
        return self.components(separatedBy: notDigits).joined(separator: "")
    }

    var digitsOnlyWithoutLeadingZeros: String {
        if let number = Int(self.digitsOnly), number > 0 {
            return "\(number)"
        } else {
            return ""
        }
    }

    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        return String(self.dropFirst(prefix.count))
    }
}

private extension PhoneNumberKit {
    func parseIfPossible(_ numberString: String, withRegion region: String? = nil, ignoreType: Bool = false) -> PhoneNumber? {
        // If region is given explicitly then parse using that region.
        if let region = region {
            return try? self.parse(numberString, withRegion: region, ignoreType: ignoreType)
        }

        var phoneNumber: PhoneNumber?

        // If region is not given then parse using "US" region as there always must be some valid region.
        phoneNumber = try? self.parse(numberString, withRegion: "US", ignoreType: ignoreType)

        // Try remove prefix 011 if it exists and parse again.
        if phoneNumber == nil && numberString.hasPrefix("011") {
            phoneNumber = try? self.parse(numberString.deletingPrefix("011"), withRegion: "US", ignoreType: ignoreType)
        }

        // Try remove prefix 00 if it exists and parse again.
        if phoneNumber == nil && numberString.hasPrefix("00") {
            phoneNumber = try? self.parse(numberString.deletingPrefix("00"), withRegion: "US", ignoreType: ignoreType)
        }

        // Return nothing if number is not parsed.
        guard let phoneNumber = phoneNumber else {
            return nil
        }

        // Detect if country code is given for US number.
        if phoneNumber.countryCode == 1 {
            let standarized = self.format(phoneNumber, toType: .e164, withPrefix: true)
            if numberString.digitsOnlyWithoutLeadingZeros != standarized.digitsOnlyWithoutLeadingZeros {
                return nil
            }
        }

        return phoneNumber
    }
}

struct Test {
    var numberString: String
    var countryCode: String?
    var parsed: Bool
}

let tests: [Test] = [
    // US
    Test(numberString: "01115417543010", countryCode: "US", parsed: true),
    Test(numberString: "01115417543010", countryCode: nil, parsed: true), // failed, why?
    Test(numberString: "0015417543010", countryCode: "US", parsed: false),
    Test(numberString: "0015417543010", countryCode: nil, parsed: false), // parsed correctly, why?
    Test(numberString: "15417543010", countryCode: "US", parsed: true),
    Test(numberString: "15417543010", countryCode: nil, parsed: true),
    Test(numberString: "+15417543010", countryCode: "US", parsed: true),
    Test(numberString: "+15417543010", countryCode: nil, parsed: true),
    Test(numberString: "5417543010", countryCode: "US", parsed: true),
    Test(numberString: "5417543010", countryCode: nil, parsed: false),

    // NO
    Test(numberString: "0114747473204", countryCode: "NO", parsed: false),
    Test(numberString: "0114747473204", countryCode: nil, parsed: false), // parsed correctly, why?
    Test(numberString: "004747473204", countryCode: "NO", parsed: true),
    Test(numberString: "004747473204", countryCode: nil, parsed: true),
    Test(numberString: "4747473204", countryCode: "NO", parsed: true),
    Test(numberString: "4747473204", countryCode: nil, parsed: true),
    Test(numberString: "+4747473204", countryCode: "NO", parsed: true),
    Test(numberString: "+4747473204", countryCode: nil, parsed: true),
    Test(numberString: "47473204", countryCode: "NO", parsed: true),
    Test(numberString: "47473204", countryCode: nil, parsed: false),

    // PL
    Test(numberString: "01148690300400", countryCode: "PL", parsed: false),
    Test(numberString: "01148690300400", countryCode: nil, parsed: false), // parsed correctly, why?
    Test(numberString: "0048690300400", countryCode: "PL", parsed: true),
    Test(numberString: "0048690300400", countryCode: nil, parsed: true),
    Test(numberString: "48690300400", countryCode: "PL", parsed: true),
    Test(numberString: "48690300400", countryCode: nil, parsed: true),
    Test(numberString: "+48690300400", countryCode: "PL", parsed: true),
    Test(numberString: "+48690300400", countryCode: nil, parsed: true),
    Test(numberString: "690300400", countryCode: "PL", parsed: true),
    Test(numberString: "690300400", countryCode: nil, parsed: false), // detects country code = TK (+690)
]

var passed = 0
var all = 0
for (index, test) in tests.enumerated() {

    guard test.countryCode == nil else {
        continue
    }

    print("START \(index), test = \(test)")

    let phoneNumberKit = PhoneNumberKit()
    var parsed = false
    if let phoneNumber = phoneNumberKit.parseIfPossible(test.numberString, withRegion: test.countryCode) {

        print("Phone number: \(phoneNumber)")
        if let country = phoneNumberKit.getRegionCode(of: phoneNumber) {
            print("Country: \(country)")
        }
        let formatted = phoneNumberKit.format(phoneNumber, toType: .e164, withPrefix: true)
        print("Formatted: \(formatted)")
        parsed = true

    } else {

        print("Invalid number")
    }

    print("END \(index), passed = \(test.parsed == parsed)")
    print("")

    if test.parsed == parsed {
        passed += 1
    }

    all += 1
}

print("PASSED \(passed)/\(all)")

//: [Next](@next)
