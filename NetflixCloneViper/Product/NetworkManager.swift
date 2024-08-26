//
//  NetworkManager.swift
//  NetflixCloneViper
//
//  Created by Yasin Özdemir on 5.07.2024.
//

import Foundation
import Alamofire
protocol INetworkManager{
    func request<T : Codable>(url : String , model : T.Type , method : HTTPMethod ,parameters : Parameters? , headers : HTTPHeaders?) async -> Result<T? , Error>
}

class NetworkManager : INetworkManager{
    func request<T : Codable>(url : String , model : T.Type , method : HTTPMethod ,parameters : Parameters? , headers : HTTPHeaders?) async -> Result<T?, Error>{
        let request = AF.request(url, method: method, parameters: parameters ,headers: headers).validate().serializingDecodable(T.self)
        
        let response = await request.response
        
        switch response.result {
        case .success(let value) : return.success(value)
        case.failure(let err) : return .failure(err)
        }
    }
}


