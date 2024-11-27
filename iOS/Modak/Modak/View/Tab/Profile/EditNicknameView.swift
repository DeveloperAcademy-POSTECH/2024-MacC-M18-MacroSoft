//
//  CampfireNameView.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI
import FirebaseAnalytics

struct EditNicknameView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var editedNickname: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 12) {
                Text("닉네임 변경하기")
                    .font(Font.custom("Pretendard-Bold", size: 23))
                    .foregroundStyle(.textColor1)
                
                Text("모닥불의 이름은 언제든 변경 가능해요")
                    .font(Font.custom("Pretendard-Regular", size: 16))
                    .foregroundStyle(.textColorGray1)
            }
            .padding(.init(top: 36, leading: 20, bottom: 44, trailing: 0))
            
            EditNicknameViewTextField(editedNickname: $editedNickname)
                .padding(.horizontal, 20)
            
            Spacer()
            
            EditNicknameViewNextButton(editedNickname: $editedNickname)
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
        .tapDismissesKeyboard()
        .onAppear {
            viewModel.fetchNickname()
            editedNickname = viewModel.originalNickname
        }
    }
}

// MARK: - CampfireViewTextField

private struct EditNicknameViewTextField: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    @Binding var editedNickname: String
    @FocusState private var isFocusedTextField: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
                .font(Font.custom("Pretendard-Medium", size: 14))
                .foregroundStyle(.textColor2)
                .padding(.leading, 2)
            
            TextField("", text: $editedNickname)
                .tint(.white)
                .foregroundStyle(.white)
                .focused($isFocusedTextField)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 8).fill(Color.init(hex: "A1988E").opacity(0.1))
                        .stroke(Color.textColor2, lineWidth: isFocusedTextField ? 1 : 0)
                }
                .overlay {
                    if !editedNickname.isEmpty {
                        HStack {
                            Spacer()
                            
                            Button {
                                editedNickname = ""
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
                if editedNickname.count > 15 {
                    Text("닉네임은 15자까지 가능해요")
                        .font(Font.custom("Pretendard-Regular", size: 16))
                        .foregroundStyle(.disable)
                        .padding(.init(top: 8, leading: 2, bottom: 0, trailing: 0))
                }
                
                Spacer()
                
                Text("\(editedNickname.count > 15 ? 15 : editedNickname.count)/15")
                    .font(Font.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(editedNickname.count > 15 ? Color.errorRed : .textColorGray2)
                    .padding(.top, 15)
                
            }
        }
    }
}

// MARK: - CampfireViewNextButton

private struct EditNicknameViewNextButton: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    @Binding var editedNickname: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            Analytics.logEvent("change_nickname", parameters: [:])
            viewModel.saveNickname(newNickname: editedNickname) {
                dismiss()
            }
        } label: {
            HStack {
                Spacer()
                
                Text("변경하기")
                    .font(Font.custom("Pretendard-Bold", size: 17))
                    .foregroundStyle((editedNickname.isEmpty || editedNickname.count > 15 || editedNickname == viewModel.originalNickname) ? .textColorGray4 : .white)
                    .padding(.vertical, 18)
                
                Spacer()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 73)
                .fill((editedNickname.isEmpty || editedNickname.count > 15 || editedNickname == viewModel.originalNickname) ? .disable : .mainColor1)
        }
        .disabled(editedNickname.isEmpty || editedNickname.count > 15 || editedNickname == viewModel.originalNickname)
    }
}

//#Preview {
//    EditNicknameView()
//}
