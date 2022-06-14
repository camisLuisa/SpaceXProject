import Foundation
import Combine

protocol URLSessionProtocol {
    func dataTask(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol { func resume() }

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
extension URLSession: URLSessionProtocol {
    func dataTask(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlRequest, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

class SpaceXServiceWithCompletion {
    private let session: URLSessionProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol

    init(
        session: URLSessionProtocol = URLSession.shared,
         dispatchQueueWrapper: DispatchQueueWrapperProtocol
    ) {
        self.session = session
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }

    func getCompanyInfo(completion: @escaping (Result<CompanyInfoResponse, NetworkError>) -> Void) {

        let components = makeCompanyInfoComponents()
        guard let url = components.url else {
            completion(.failure(.serviceError))
            return
        }

        let task = session.dataTask(urlRequest: URLRequest(url: url)) { [weak self] data, urlResponse, error in

            self?.dispatchQueueWrapper.mainAsync {
                do {
                    guard let data = data else {
                        completion(.failure(.serviceError))
                        return
                    }

                    let decoder = JSONDecoder()
                    let response = try decoder.decode(CompanyInfoResponse.self, from: data)

                    completion(.success(response))
                } catch let _ {
                    completion(.failure(.parsing))
                }
            }
        }
        task.resume()
    }
}

private extension SpaceXServiceWithCompletion {
    struct SpaceXAPI {
        static let scheme = "https"
        static let host = "api.spacexdata.com"
        static let path = "/v3"
    }

    func makeCompanyInfoComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = SpaceXAPI.scheme
        components.host = SpaceXAPI.host
        components.path = SpaceXAPI.path + "/info"

        return components
    }
}
