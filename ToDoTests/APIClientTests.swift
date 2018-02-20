//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by Niklas Rammerstorfer on 06.02.18.
//  Copyright © 2018 Niklas Rammerstorfer. All rights reserved.
//

import XCTest

@testable import ToDo

class APIClientTests: XCTestCase {

    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        super.setUp()

        sut = APIClient()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Login_UsesExpectedHost(){
        sut.loginUser(withName: "dasdom", password: "1234", completion: {(token: Token?, error: Error?) in })

        guard mockURLSession.url != nil else{
            XCTFail(); return
        }

        XCTAssertEqual(mockURLSession.urlComponents?.host, "awesometodos.com")
    }

    func test_Login_UsesExpectedPath(){
        sut.loginUser(withName: "dasdom", password: "1234", completion: {(token: Token?, error: Error?) in })

        guard mockURLSession.url != nil else{
            XCTFail(); return
        }

        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }

    func test_Login_UsesExpectedQuery(){
        let username = "dasdom"
        let password = "1234"

        sut.loginUser(withName: username, password: password, completion: {(token: Token?, error: Error?) in })

        guard mockURLSession.url != nil else{
            XCTFail(); return
        }

        let queryItems = mockURLSession.urlComponents?.queryItems
        XCTAssertTrue((queryItems?.contains(URLQueryItem(name: "username", value: username)))!)
        XCTAssertTrue((queryItems?.contains(URLQueryItem(name: "password", value: password)))!)
    }

    func test_Login_SpecialCharacters_UsesExpectedQuery(){
        let username = "dasdöm"
        let password = "%&34"
        sut.loginUser(withName: username, password: password, completion: {(token: Token?, error: Error?) in })

        guard mockURLSession.url != nil else{
            XCTFail(); return
        }

        let queryItems = mockURLSession.urlComponents?.queryItems
        XCTAssertTrue((queryItems?.contains(URLQueryItem(name: "username", value: username)))!)
        XCTAssertTrue((queryItems?.contains(URLQueryItem(name: "password", value: password)))!)
    }

    func test_Login_WhenSuccessful_CreatesToken(){
        let token = "1234567890"
        let jsonData = "{\"token\": \"\(token)\"}".data(using: .utf8)
        sut.session = MockURLSession(data: jsonData, urlResponse: nil, responseError: nil)

        let tokenExpectation = expectation(description: "Token")
        var caughtToken: Token? = nil
        sut.loginUser(withName: "foo", password: "bar"){
            token, _ in

            caughtToken = token
            tokenExpectation.fulfill()
        }

        waitForExpectations(timeout: 1){
            _ in

            XCTAssertEqual(caughtToken?.id, token)
        }
    }

    func test_Login_WhenJSONIsInvalid_ReturnsError(){
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.session = mockURLSession

        assertErrorNotNil()
    }

    func test_Login_WhenDataIsNil_ReturnsError(){
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.session = mockURLSession

        assertErrorNotNil()
    }

    func test_Login_WhenResponseHasError_ReturnsError(){
        let token = "1234567890"
        let jsonData = "{\"token\": \"\(token)\"}".data(using: .utf8)
        let responseError = NSError(domain: "SomeServerError", code: 1234, userInfo: nil)
        sut.session = MockURLSession(data: jsonData, urlResponse: nil, responseError: responseError)

        assertErrorNotNil()
    }

    private func assertErrorNotNil() {
        let errorExpectation = expectation(description: "Error")
        var caughtError: Error? = nil
        sut.loginUser(withName: "foo", password: "bar"){
            token, error in

            caughtError = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1){
            _ in

            XCTAssertNotNil(caughtError)
        }
    }
}

extension APIClientTests{
    class MockURLSession: SessionProtocol{
        var url: URL?
        var urlComponents: URLComponents?{
            guard let url = url else { return nil}

            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }

        private let dataTask: MockTask

        init(data: Data?, urlResponse: URLResponse?, responseError: Error?){
            dataTask = MockTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
            self.url = url

            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }

    class MockTask: URLSessionDataTask{
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?

        var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

        init(data: Data?, urlResponse: URLResponse?, responseError: Error?){
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }

        override func resume() {
            DispatchQueue.main.async{
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }
}
