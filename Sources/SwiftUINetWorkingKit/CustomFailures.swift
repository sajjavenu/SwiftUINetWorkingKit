//
//  CustomFailures.swift
//  SwiftUINetWorkingKit
//
//  Created by Sajja Venu on 27/01/26.
//

public enum CustomFailures : String, Error, CaseIterable, Equatable{
    case jsonDecodingError = "JsonDecodingError"
    case noInternet = "NoInternet"
    case nilAPIResponse = "NilAPIResponse"
    case unKnownError = "UnKnownError"
//    case sslPinningError = "SSLPinningError"
}
