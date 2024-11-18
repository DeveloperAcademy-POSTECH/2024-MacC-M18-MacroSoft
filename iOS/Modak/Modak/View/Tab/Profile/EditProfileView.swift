//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    @AppStorage("recentVisitedCampfirePin") private var recentVisitedCampfirePin: Int = 0
    @AppStorage("isInitialDataLoad") private var isInitialDataLoad: Bool = true
    @Environment(\.modelContext) private var modelContext
    @State private var showDeactivationAlert = false

    var body: some View {
        VStack {
            ProfileItem(title: "닉네임 변경", destination: AnyView(EditNicknameView()))
            .background { ProfileItemFrame() }
            ProfileItem(title: "회원 탈퇴") {
                showDeactivationAlert.toggle()
            }
            .background { ProfileItemFrame() }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 13)
        .background {
            ProfileBackground()
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    BackButton()
                        .colorMultiply(Color.textColorGray1)
                }
            }
        }
        .alert(isPresented: $showDeactivationAlert) {
            Alert(
                title: Text("회원 탈퇴"),
                message: Text("정말 회원 탈퇴를 진행하시겠습니까?"),
                primaryButton: .destructive(Text("탈퇴")) {
                    viewModel.deactivate { success in
                        if success {
                            recentVisitedCampfirePin = 0
                            clearAllLocalData()
                            isInitialDataLoad = true
                            isSkipRegister = false
                        } else {
                            print("탈퇴 실패")
                        }
                    }
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
    
    private func clearAllLocalData() {
        do {
            // 각 엔티티에 대해 데이터 삭제
            deleteAllEntities(ofType: Campfire.self)
            deleteAllEntities(ofType: PrivateLog.self)
            deleteAllEntities(ofType: PrivateLogImage.self)
            
            // 데이터 저장
            try modelContext.save()
            print("All local data cleared successfully.")
        } catch {
            print("Failed to clear all local data: \(error)")
        }
    }
    
    private func deleteAllEntities<T: PersistentModel>(ofType entityType: T.Type) {
        let fetchRequest = FetchDescriptor<T>() // SwiftData에서 데이터 가져오기
        if let entities = try? modelContext.fetch(fetchRequest) {
            for entity in entities {
                modelContext.delete(entity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
