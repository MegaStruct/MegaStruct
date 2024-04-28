//
//  NetworkError.swift
//  MegaStruct
//
//  Created by 김정호 on 4/29/24.
//

import Foundation

enum NetworkError: Error {
    case urlConversionFailure
    case dataFailure
    case jsonDecodingFailure
}
