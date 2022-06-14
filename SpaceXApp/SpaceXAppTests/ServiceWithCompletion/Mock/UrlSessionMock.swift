//
//  SessionMock.swift
//  SpaceXAppTests
//
//  Created by Camila Luísa Farias on 04/06/22.
//

import XCTest
@testable import SpaceXApp

class UrlSessionMock: URLSessionProtocol {
    var mockedData: Data?
    var mockedError: NetworkError?

    func dataTask(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {

        if mockedError != nil {
            completionHandler(nil, nil, mockedError)
        } else {
            completionHandler(mockedData, nil, nil)
        }
        return MockURLSessionDataTask()
    }
}
