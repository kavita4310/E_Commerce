//
//  ApiService.swift
//  ECommerceDemo
//
//  Created by kavita chauhan on 21/06/24.
//

import Foundation
import Alamofire


class ApiService{
    
    static let shared = ApiService()
    
    typealias apiHandler = (Result<WSApiModel, ErrorCondition>)->Void
    
    func getApiData(completion: @escaping apiHandler){
        
        guard let url = URL(string: "https://klinq.com/rest/V1/productdetails/6701/253620?lang=en&store=KWD") else {
            completion(.failure(ErrorCondition.invalidUrl))
            return
        }
        AF.request(url, method: .get, encoding: URLEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data else{
                    return
                }
                do{
                 let decoder = JSONDecoder()
                    let json = try decoder.decode(WSApiModel.self, from: data)
                    completion(.success(json))
                }
                catch{
                    completion(.failure(ErrorCondition.decodingError))
                }
                
            case.failure(let error):
                completion(.failure(ErrorCondition.networkError(error)))
            }
        }
        
    }
    
    
}

enum ErrorCondition: Error{
    case invalidUrl
    case invalidResponse
    case decodingError
    case networkError(Error?)
}



