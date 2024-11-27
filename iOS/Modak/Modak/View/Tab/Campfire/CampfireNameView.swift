//
//  CampfireNameView.swift
//  Modak
//
//  Created by Park Junwoo on 10/31/24.
//

import SwiftUI
import FirebaseAnalytics

struct CampfireNameView: View {
    @State private var campfireName: String = ""
    
    private(set) var isCreate: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            CampfireNameViewTitle(isCreate: isCreate)
                .padding(.init(top: 36, leading: 20, bottom: 44, trailing: 0))
            
            CampfireViewTextField(campfireName: $campfireName)
                .padding(.horizontal, 20)
            
            Spacer()
            
            CampfireViewNextButton(campfireName: $campfireName, isCreate: isCreate)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            
        }
        .background {
            Color.backgroundDefault.ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
        .onTapDismissKeyboard()
        .onAppear{
            if isCreate {
                Analytics.logEvent(AnalyticsEventScreenView,
                    parameters: [AnalyticsParameterScreenName: "CreateCampfireView",
                    AnalyticsParameterScreenClass: "CreateCampfireView"])
            } else {
                Analytics.logEvent(AnalyticsEventScreenView,
                    parameters: [AnalyticsParameterScreenName: "EditCampfireView",
                    AnalyticsParameterScreenClass: "EditCampfireView"])
            }
        }
    }
}

// MARK: - CampfireNameViewTitle

private struct CampfireNameViewTitle: View {
    private(set) var isCreate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(isCreate ? "모닥불 생성하기" : "모닥불 이름 변경하기")")
                .font(Font.custom("Pretendard-Bold", size: 23))
                .foregroundStyle(.textColor1)
            
            Text("모닥불의 이름은 언제든 변경 가능해요")
                .font(Font.custom("Pretendard-Regular", size: 16))
                .foregroundStyle(.textColorGray1)
        }
    }
}

// MARK: - CampfireViewTextField

private struct CampfireViewTextField: View {
    @Binding private(set) var campfireName: String
    @FocusState private var isFocusedTextField: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("모닥불 이름")
                .font(Font.custom("Pretendard-Medium", size: 14))
                .foregroundStyle(.textColor2)
                .padding(.leading, 2)
            
            TextField("", text: $campfireName,prompt: Text("모닥불 이름").foregroundStyle(.disable))
                .tint(.white)
                .foregroundStyle(.white)
                .focused($isFocusedTextField)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 8).fill(Color.init(hex: "A1988E").opacity(0.1))
                        .stroke(Color.textColor2, lineWidth: isFocusedTextField ? 1 : 0)
                }
                .overlay {
                    if campfireName != ""{
                        HStack {
                            Spacer()
                            
                            Button {
                                campfireName = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.textColor3)
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }
                        .padding(14)
                    }
                }
            HStack {
                if campfireName.count > 12 {
                    Text("모닥불 이름은 12자까지 가능해요")
                        .font(Font.custom("Pretendard-Regular", size: 16))
                        .foregroundStyle(.disable)
                        .padding(.init(top: 8, leading: 2, bottom: 0, trailing: 0))
                }
                
                Spacer()
                
                Text("\(campfireName.count > 12 ? 12 : campfireName.count)/12")
                    .font(Font.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(campfireName.count > 12 ? Color.init(hex: "FF6464") : .textColorGray2)
                    .padding(.top, 12)
                
            }
        }
    }
}

// MARK: - CampfireViewNextButton

private struct CampfireViewNextButton: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding private(set) var campfireName: String
    private(set) var isCreate: Bool
    
    var body: some View {
        Button {
            if isCreate {
                Task {
                    await viewModel.testCreateCampfire(newCampfireName: campfireName)
                    dismiss()
                }
                Analytics.logEvent("create_campfire", parameters: [:])
//                viewModel.createCampfire(campfireName: campfireName) {
//                    saveCampfireToLocalStorage()
//                }
            } else {
                Task {
                    await viewModel.updateCampfireName(newName: campfireName)
                    dismiss()
                }
                Analytics.logEvent("edit_campfire", parameters: [:])
            }
        } label: {
            HStack {
                Spacer()
                
                Text("다음으로")
                    .font(Font.custom("Pretendard-Bold", size: 17))
                    .foregroundStyle((campfireName == "" || campfireName.count > 12) ? .textColorGray4 : .white)
                    .padding(.vertical, 18)
                
                Spacer()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 73)
                .fill((campfireName == "" || campfireName.count > 12) ? .disable : .mainColor1)
        }
        .disabled((campfireName == "" || campfireName.count > 12))
    }
    
    private func saveCampfireToLocalStorage() {
        let newCampfire = Campfire(name: campfireName, pin: viewModel.recentVisitedCampfirePin, todayImage: viewModel.currentCampfire?.todayImage ?? TodayImage(imageId: 0, name: "", emotions: []), imageName: "")
        modelContext.insert(newCampfire)
        do {
            try modelContext.save()
            print("Campfire 데이터 - 로컬 데이터베이스 저장 완료")
        } catch {
            print("Error saving Campfire data: \(error)")
        }
    }
}

#Preview {
    CampfireNameView(isCreate: true)
}
