//
//  APIRouter.swift
//  Modak
//
//  Created by kimjihee on 11/5/24.
//

import Foundation

// MARK: - APIRouter

enum APIRouter: URLRequestConvertible {
    // Campfire API
    case createCampfire(parameters: [String: Any])
    case joinCampfire(campfirePin: Int, parameters: [String: Any])
    case getCampfireName(campfirePin: Int)
    case updateCampfireName(campfirePin: Int, parameters: [String: Any])
    case getCampfireMainInfo(campfirePin: Int)
    case deleteCampfire(campfirePin: Int)
    case getMyCampfires
    case leaveCampfire(campfirePin: Int)

    // Auth API
    case socialLogin(socialType: String, parameters: [String: Any])
    case refreshAccessToken(refreshToken: String)
    case logout
    case deactivate

    // Member API
    case getMembersNicknames
    case updateNickname(parameters: [String: Any])
    
    // Image API
    case uploadImage(imageData: Data)

    private var baseURL: String {
        let url =  Bundle.main.environmentVariable(forKey: "ServerURL")!
        print("originalURL >> \(url)")
        return url
    }

    private var path: String {
        switch self {
        // Campfire API
        case .createCampfire:
            return "/api/campfires"
        case .joinCampfire(let campfirePin, _):
            return "/api/campfires/\(campfirePin)/join"
        case .getCampfireName(let campfirePin):
            return "/api/campfires/\(campfirePin)/name"
        case .updateCampfireName(let campfirePin, _):
            return "/api/campfires/\(campfirePin)/name"
        case .getCampfireMainInfo(let campfirePin):
            return "/api/campfires/\(campfirePin)"
        case .deleteCampfire(let campfirePin):
            return "/api/campfires/\(campfirePin)"
        case .getMyCampfires:
            return "/api/campfires/my"
        case .leaveCampfire(let campfirePin):
            return "/api/campfires/\(campfirePin)/leave"

        // Auth API
        case .socialLogin(let socialType, _):
            return "/api/auth/\(socialType)/login"
        case .refreshAccessToken:
            return "/api/auth/refresh-access-token"
        case .logout:
            return "/api/auth/logout"
        case .deactivate:
            return "/api/auth/deactivate"

        // Member API
        case .getMembersNicknames:
            return "/api/members/nickname"
        case .updateNickname:
            return "/api/members/nickname"
       
        // Image API
        case .uploadImage:
            return "/api/images"
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .createCampfire, .joinCampfire, .socialLogin, .refreshAccessToken, .logout, .uploadImage:
            return .POST
        case .getCampfireName, .getCampfireMainInfo, .getMyCampfires, .getMembersNicknames:
            return .GET
        case .updateCampfireName, .updateNickname:
            return .PATCH
        case .deleteCampfire, .leaveCampfire, .deactivate:
            return .DELETE
        }
    }

    private var headers: [String: String] {
        var headers = ["Content-Type": "application/json"]
        
        // 인증 토큰이 필요한 경우 추가
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            headers["Authorization"] = "Bearer \(accessToken)"
            print("Authorization Header: Bearer \(accessToken)")
        } else {
            print("No access token found in UserDefaults")
        }
        
        return headers
    }

    private var parameters: [String: Any]? {
        switch self {
        case .createCampfire(let parameters), .updateCampfireName(_, let parameters),
             .socialLogin(_, let parameters), .updateNickname(let parameters),
             .joinCampfire(_, let parameters):
            return parameters
        case .refreshAccessToken(let refreshToken):
            return ["refreshToken": refreshToken]
        default:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)!
        print("URL >> \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 헤더 추가
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 파라미터 설정
        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return request
    }
}

// MARK: - URLRequestConvertible Protocol

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

// MARK: - HTTPMethod Enum

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case DELETE
}


