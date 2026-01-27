//
//  ApiNetworkProtocols.swift
//  SwiftUINetWorkingKit
//
//  Created by Sajja Venu on 27/01/26.
//

import Combine

public protocol AlamofireApiNetworkProtocols{
    func alamofireApiRequest<T:Decodable>(requestData:ApiInputDataModel,expecting:T.Type, success: @escaping (Swift.Result<T, Error>)-> Void, failure: @escaping OnApiFailure, onNointernet:@escaping
                                          ()->Void)
}

public protocol CombineApiNetworkProtocols{
    func combineApiRequest<T:Decodable>(requestData:ApiInputDataModel,expecting:T.Type) -> AnyPublisher<T, CustomFailures>
}

