//
//  NetworkLayer.swift
//  SwiftUINetWorkingKit
//
//  Created by Sajja Venu on 27/01/26.
//

import Foundation
import Alamofire
import Combine


open typealias OnApiFailure = (CustomFailures?) -> Void

open class ApiNetworkLayer: AlamofireApiNetworkProtocols,CombineApiNetworkProtocols{
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    private func networkAvailability() -> Bool {
        return reachabilityManager?.isReachable ?? false
        //        return false
    }
    
    func alamofireApiRequest<T>(requestData: any ApiInputDataModel, expecting: T.Type, success: @escaping (Result<T, any Error>) -> Void, failure: @escaping OnApiFailure, onNointernet: @escaping () -> Void) where T : Decodable {
        
        
        guard networkAvailability() else {
            onNointernet()
            return
        }
        
        let urlString =  "\(requestData.baseURL)\(requestData.endPoint)"
        var headers = HTTPHeaders()
        requestData.headers.forEach({headers.add(name: $0.key, value: $0.value)})
        headers.add(name: KeyChainConstants.authId, value: KeychainsStorageManager.shared.getKeyChainValue(key: KeyChainConstants.authId))
        
        print("Api Url is:\(urlString)")
        print("Api body is:\(requestData.parameters)")
        print("Api method is:\(requestData.httpMethod)")
        print("Api headers is:\(headers)")
        
        
        AF.request(urlString, method: requestData.httpMethod, parameters: requestData.parameters, encoder: .json , headers: headers).response { respone in
            switch respone.result{
            case .success(let jsonData):
                do{
                    let data = try JSONDecoder().decode(expecting, from: jsonData!)
                    success(.success(data))
                } catch{
                    print("json decoding error:\(error)")
                    success(.failure(CustomFailures.jsonDecodingError))
                }
            case .failure(let err):
                print("error on api call is: \(err)")
                failure(.unKnownError)
                
            }
        }
        
    }
    
    func combineApiRequest<T>(requestData: any ApiInputDataModel, expecting: T.Type) -> AnyPublisher<T, CustomFailures> where T : Decodable {
        guard networkAvailability() else {
            
            return Fail(error: CustomFailures.noInternet).eraseToAnyPublisher()
        }
        
        let urlString =  "\(requestData.baseURL)\(requestData.endPoint)"
        var headers = HTTPHeaders()
        requestData.headers.forEach({headers.add(name: $0.key, value: $0.value)})
        headers.add(name: KeyChainConstants.authId, value: KeychainsStorageManager.shared.getKeyChainValue(key: KeyChainConstants.authId))
        
        print("Api Url is:\(urlString)")
        print("Api method is:\(requestData.httpMethod)")
        print("Api input body is:\(requestData.parameters)")
        print("Api headers is:\(headers)")
        
        return AF.request(
            urlString,
            method: requestData.httpMethod,
            parameters: requestData.parameters,
            encoder: .json,
            headers: headers
        )
        .publishData()
        .tryMap { response in
            print("api repponse is :\(response)")
            guard let data = response.data else {
                throw CustomFailures.nilAPIResponse
            }
            do {
                return try JSONDecoder().decode(expecting, from: data)
            } catch {
                print("JSON decoding error: \(error)")
                throw CustomFailures.jsonDecodingError
            }
        }
        .mapError { error in
            print("error is:\(error)")
            return error as? CustomFailures ?? .unKnownError
        }
        .eraseToAnyPublisher()
    }
    
}

