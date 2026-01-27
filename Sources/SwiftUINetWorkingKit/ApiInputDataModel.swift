//
//  ApiInputDataModel.swift
//  SwiftUINetWorkingKit
//
//  Created by Sajja Venu on 27/01/26.
//

import Alamofire

public protocol ApiInputDataModel {
    var baseURL:String {get}
    var endPoint: String {get}
    var httpMethod: HTTPMethod {get}
    var headers: [String: String] {get}
    var parameters:[String: String]? {get}
    
}
