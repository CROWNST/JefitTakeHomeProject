//
//  YelpClient.swift
//  JefitTakeHomeProject
//
//  Created by David Hsieh on 7/3/22.
//

import Foundation

class YelpFusionClient {
    
    private enum Endpoints {
        static let base = "https://api.yelp.com/v3"
        static let limitBusinesses = 10
        
        case getBusinesses(String)
        case getBusinessReviews(String)
        
        var stringValue: String {
            switch self {
            case .getBusinesses(let city): return Endpoints.base + "/businesses/search?location=\(city)&limit=\(Endpoints.limitBusinesses)"
            case .getBusinessReviews(let id): return Endpoints.base + "/businesses/\(id)/reviews"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getBusinesses(city: String, completion: @escaping (Result<BusinessResults, Error>) -> Void) {
        taskForGETRequest(url: Endpoints.getBusinesses(city).url, responseType: BusinessResults.self) { result in
            completion(result)
        }
    }
    
    class func getBusinessReviews(id: String, completion: @escaping (Result<ReviewResults, Error>) -> Void) {
        taskForGETRequest(url: Endpoints.getBusinessReviews(id).url, responseType: ReviewResults.self) { result in
            completion(result)
        }
    }
    
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
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                do {
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
