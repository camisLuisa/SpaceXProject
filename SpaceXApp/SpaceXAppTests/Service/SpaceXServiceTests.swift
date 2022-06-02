import XCTest
@testable import SpaceXApp

class SpaceXServiceTests: XCTestCase {
    var sut: SpaceXService!

    override func setUp() {
        super.setUp()
        sut = SpaceXService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_getCompanyInfoWithSuccess_shouldReturnCompanyInfoModel() throws {
        let companyInfoMock = CompanyInfoResponse()
        //Given
        //Then
        let companyInfo = try awaitPublisher(sut.getCompanyInfo())

        XCTAssertEqual(companyInfo, companyInfoMock)
    }
}
