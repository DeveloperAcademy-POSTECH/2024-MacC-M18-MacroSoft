//
//  JoinCampfire.swift
//  Modak
//
//  Created by kimjihee on 10/29/24.
//

import SwiftUI

struct JoinCampfireView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = JoinCampfireViewModel()
    var i = 0
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            
            contentView
                .environmentObject(viewModel)
            
            if viewModel.showSuccess {
                BottomSheet(
                    isPresented: $viewModel.showSuccess,
                    viewName: "JoinCampfireView",
                    campfireName: .constant(viewModel.campfireName),
                    createdAt: .constant(viewModel.createdAt),
                    membersNames: .constant(viewModel.membersNames)
                )
                .transition(.move(edge: .bottom))
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
//                    viewModel.showSuccess = true //테스트 전용
                    viewModel.validateAndSendCredentials() // TODO: 서버 api 연결
                    saveCampfireToLocalStorage()
                }) {
                    Text("완료")
                        .font(.custom("Pretendard-Regular", size: 18))
                        .foregroundColor((!viewModel.campfireName.isEmpty || !viewModel.campfirePin.isEmpty) ? (!viewModel.showSuccess ? Color.mainColor1 : Color.clear) : Color.disable)
                    
                    Spacer(minLength: 2)
                }
                .disabled(viewModel.campfireName.isEmpty && viewModel.campfirePin.isEmpty)
            }
            
            ToolbarItem(placement: .bottomBar) {
                if !viewModel.showSuccess {
                    cameraModeToggleButton
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isCameraMode {
            JoinCampfireByCameraView()
                .ignoresSafeArea()
        } else {
            JoinCampfireByTextView()
        }
    }

    private var cameraModeToggleButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                viewModel.isCameraMode.toggle()
            }) {
                Text(viewModel.isCameraMode ? "직접 입력하기" : "촬영해서 입력")
                    .font(.custom("Pretendard-Regular", size: 16))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                    .background(Color.textBackgroundRedGray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.mainColor1, lineWidth: 1.8)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
        }
        .padding(.bottom, 34)
    }
    
    private func saveCampfireToLocalStorage() {
        let extractedCampfirePin = viewModel.campfirePin.compactMap { $0.isNumber ? String($0) : nil }.joined()

        let newCampfire = Campfire(name: viewModel.campfireName, pin: Int(extractedCampfirePin) ?? 0)
        modelContext.insert(newCampfire)
        do {
            try modelContext.save()
            print("Campfire 데이터 - 로컬 데이터베이스 저장")
        } catch {
            print("Error saving Campfire data: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        JoinCampfireView()
    }
}
