import XCTest
@testable import ASCHangReporter

final class ASCHangReporterTests: XCTestCase {
    func testExample() throws {
        var command = ReportHangsCommand()
        try command.run()
    }
}
