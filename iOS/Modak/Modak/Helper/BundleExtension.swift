//
//  BundleExtension.swift
//  Modak
//
//  Created by kimjihee on 10/17/24.
//

import Foundation

extension Bundle {
    // Info.plist 또는 특정 plist 파일에서 LSEnvironment 섹션의 값을 반환하는 함수
    func environmentVariable(forKey key: String, fromPlist plistName: String = "Info", shouldFixSlashes: Bool = true) -> String? {
        guard let plistURL = self.url(forResource: plistName, withExtension: "plist") else {
            print("\(plistName).plist 파일을 찾을 수 없습니다.")
            return nil
        }
        
        guard let environment = NSDictionary(contentsOf: plistURL)?["LSEnvironment"] as? [String: Any] else {
            print("LSEnvironment 항목을 찾을 수 없습니다.")
            return nil
        }
        
        // 해당 키의 값을 가져옴
        if let value = environment[key] as? String {
            return shouldFixSlashes ? value.replacingOccurrences(of: "\\", with: "") : value
        }
        
        return nil
    }
    
    func value(forKey key: String, shouldFixSlashes: Bool = true) -> String? {
        if let value = infoDictionary?[key] as? String {
            return shouldFixSlashes ? value.replacingOccurrences(of: "\\", with: "") : value
        }
        return nil
    }
}
