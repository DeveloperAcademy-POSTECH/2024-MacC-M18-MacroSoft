//
//  ProfileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var nickname: String = ""
    
    var body: some View {
        VStack {
            
            Text("닉네임 : \(nickname)")
            
            ProfileViewButton(title: "프로필 정보 편집", destination: EmptyView())
            .background { ProfileViewButtonFrame() }
            
            GroupBox {
                ProfileViewButton(title: "모닥불 정보", destination: EmptyView())
                ProfileViewButton(title: "개인정보 처리방침", destination: EmptyView())
                ProfileViewButton(title: "이용약관", destination: EmptyView())
            }
            .groupBoxStyle(ProfileViewGroupBox())
            
            ProfileViewButton(title: "로그아웃", destination: EmptyView())
            .background { ProfileViewButtonFrame() }
            
            Spacer()
        }
        .padding(.top, 18)
        .padding(.horizontal, 13)
        .background {
            ProfileBackground()
                .ignoresSafeArea()
        }
        .onAppear {
            fetchNickname()
        }
    }
    
    // TODO: MVVM 패턴 고려
    private func fetchNickname() {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getMembersNicknames)
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let resultArray = jsonResponse["result"] as? [[String: Any]],
                   let firstResult = resultArray.first,
                   let fetchedNickname = firstResult["nickname"] as? String {
                    DispatchQueue.main.async {
                        self.nickname = fetchedNickname
                    }
                } else {
                    print("Failed to fetch nickname")
                }
            } catch {
                print("Error fetching nickname: \(error)")
            }
        }
    }
}

#Preview {
    ProfileView()
}
