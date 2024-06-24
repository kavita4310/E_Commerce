//
//  ApiViewModel.swift
//  ECommerceDemo
//
//  Created by kavita chauhan on 21/06/24.
//

import Foundation

class ApiViewModel{
    
    var apiSuccess:( (WSApiModel)-> Void)?
    var apiError:((Error)-> Void)?
    
    func callgetApi(){
        ApiService.shared.getApiData(completion: { response in
            switch response {
            case.success(let data):
            self.apiSuccess?(data)
            case.failure(let error):
            self.apiError?(error)
                
            }
        })

    }
    
}

