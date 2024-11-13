//
//  NetworkManager.swift
//  Modak
//
//  Created by kimjihee on 11/5/24.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Request Method using APIRouter
    
    func request<T: Decodable>(router: APIRouter) async throws -> T {
        let request = try router.asURLRequest()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.serverError
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // 모델 없이 원시 데이터를 반환
    func requestRawData(router: APIRouter) async throws -> Data {
        let request = try router.asURLRequest()
        print("Request Headers:", request.allHTTPHeaderFields ?? "No headers")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            print("Unexpected response code: \(response)")
            throw NetworkError.serverError
        }
        
        return data
    }
}

// MARK: - NetworkError Enum

enum NetworkError: Error {
    case invalidURL
    case serverError
    case decodingError
}

