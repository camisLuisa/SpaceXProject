import Foundation
import Combine

class SpaceXService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getCompanyInfo() -> AnyPublisher<CompanyInfoResponse, NetworkError> {
        return forecast(with: makeCompanyInfoComponents())
    }

    private func forecast<T>(with components: URLComponents) -> AnyPublisher<T, NetworkError> where T: Decodable {

        guard let url = components.url else {
            let error = NetworkError.serviceError

            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: URLRequest(url: url)).mapError { error in
            NetworkError.serviceError
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
}

private extension SpaceXService {
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
