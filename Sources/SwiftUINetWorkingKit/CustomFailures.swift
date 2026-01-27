//
//  CustomFailures.swift
//  SwiftUINetWorkingKit
//
//  Created by Sajja Venu on 27/01/26.
//

public enum CustomFailures : String, Error, CaseIterable, Equatable{
    case jsonDecodingError = "jsonDecodingError"
    case noInternet = "nointernet"
    case nilAPIResponse = "nilAPIResponse"
    case unKnownError = "unKnownError"
}
