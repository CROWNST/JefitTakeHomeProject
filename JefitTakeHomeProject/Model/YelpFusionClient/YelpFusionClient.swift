//
//  YelpClient.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/3/22.
//

import Foundation

/// Networking class interacting with Yelp Fusion API.
class YelpFusionClient {
    
    /// Provides URL objects for endpoints.
    private enum Endpoints {
        
        static let base = "https://api.yelp.com/v3"
        /// Maximum number of businesses to display per city.
        static let limitBusinesses = 10
        
        case getBusinesses(String)
        case getBusinessReviews(String)
        case getImage(String)
        
        /// Provides the url as a String.
        var stringValue: String {
            switch self {
            case .getBusinesses(let city): return Endpoints.base + "/businesses/search?location=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=\(Endpoints.limitBusinesses)"
            case .getBusinessReviews(let id): return Endpoints.base + "/businesses/\(id)/reviews"
            case .getImage(let imageUrl): return imageUrl
            }
        }
        
        /// Provides the URL object.
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    /// Performs network request to Business Search endpoint.
    /// - Parameters:
    ///   - city: The city of the businesses.
    ///   - completion: Performs further actions with the retrieved Result.
    class func getBusinesses(city: String, completion: @escaping (Result<BusinessResults, Error>) -> Void) {
        taskForGETRequest(url: Endpoints.getBusinesses(city).url, responseType: BusinessResults.self) { result in
            completion(result)
        }
    }
    
    /// Performs network request to Reviews endpoint.
    /// - Parameters:
    ///   - id: The API-provided id of the business.
    ///   - completion: Performs further actions with the retrieved Result.
    class func getBusinessReviews(id: String, completion: @escaping (Result<ReviewResults, Error>) -> Void) {
        taskForGETRequest(url: Endpoints.getBusinessReviews(id).url, responseType: ReviewResults.self) { result in
            completion(result)
        }
    }
    
    /// Performs network request to retrieve an image.
    /// - Parameters:
    ///   - imageUrl: The url of the image.
    ///   - completion: Performs further actions with the retrieved Result.
    class func getImage(imageUrl: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getImage(imageUrl).url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    /// Performs network request to a URL, given response type.
    /// - Parameters:
    ///   - url: The URL for the network request.
    ///   - responseType: The Type for the response.
    ///   - completion: Performs further actions with the retrieved Result.
    private class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(ApiKey.key)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                // Attempt to decode into the response type
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                do {
                    // Attempt to decode into YelpFusionErrorResponse
                    let errorResponse = try decoder.decode(YelpFusionErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(.failure(errorResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}
