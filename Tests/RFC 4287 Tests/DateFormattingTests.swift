import Testing

@testable import RFC_4287

@Suite
struct `RFC 3339 DateTime Tests` {
    @Test func createDateTimeFromComponents() async throws {
        let time = try Time(year: 2021, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let dateTime = RFC_3339.DateTime(time: time, offset: .utc)

        #expect(dateTime.time.year == 2021)
        #expect(dateTime.time.month == 1)
        #expect(dateTime.time.day == 1)
        #expect(dateTime.offset == RFC_3339.Offset.utc)
    }

    @Test func parseRFC3339String() async throws {
        let dateString = "2021-01-01T00:00:00Z"
        let dateTime = try RFC_3339.DateTime(dateString)

        #expect(dateTime.time.year == 2021)
        #expect(dateTime.time.month == 1)
        #expect(dateTime.time.day == 1)
        #expect(dateTime.offset == RFC_3339.Offset.utc)
    }

    @Test func formatRFC3339String() async throws {
        let time = try Time(year: 2021, month: 1, day: 1, hour: 12, minute: 30, second: 45)
        let dateTime = RFC_3339.DateTime(time: time, offset: .utc)

        let formatted = String(dateTime)

        // Should be ISO 8601 format
        #expect(formatted.contains("2021-01-01"))
        #expect(formatted.contains("T"))
        #expect(formatted.contains("12:30:45"))
    }

    @Test func roundTripDateTimeFormatting() async throws {
        let time = try Time(year: 2021, month: 6, day: 15, hour: 14, minute: 30, second: 0)
        let original = RFC_3339.DateTime(time: time, offset: .utc)

        let formatted = String(original)
        let parsed = try RFC_3339.DateTime(formatted)

        #expect(parsed.time.year == original.time.year)
        #expect(parsed.time.month == original.time.month)
        #expect(parsed.time.day == original.time.day)
        #expect(parsed.time.hour == original.time.hour)
        #expect(parsed.time.minute == original.time.minute)
    }

    @Test func variousRFC3339Formats() async throws {
        let formats = [
            "2021-01-01T00:00:00Z",
            "2021-01-01T00:00:00.000Z",
            "2021-01-01T12:30:45Z",
            "2021-12-31T23:59:59Z",
        ]

        for format in formats {
            let dateTime = try RFC_3339.DateTime(format)
            #expect(dateTime.time.year > 0)
        }
    }
}
