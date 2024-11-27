//
//  ResponseModel.swift
//  Modak
//
//  Created by Park Junwoo on 11/25/24.
//

struct ResponseModel<T: Codable>: Codable {
    let timeStamp: String
    let code: String
    let message: String
    let result: T
}
