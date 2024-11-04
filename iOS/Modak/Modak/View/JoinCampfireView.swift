//
//  JoinCampfire.swift
//  Modak
//
//  Created by kimjihee on 10/29/24.
//

import SwiftUI

struct JoinCampfireView: View {
    @StateObject private var viewModel = JoinCampfireViewModel()
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            
            contentView
            
            if viewModel.showSuccess {
                BottomSheet(isPresented: $viewModel.showSuccess, viewName: "JoinCampfireView")
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
                }) {
                    Text("완료")
                        .font(.custom("Pretendard-Regular", size: 18))
                        .foregroundColor((!viewModel.campfireName.isEmpty || !viewModel.campfirePin.isEmpty) ? (!viewModel.showSuccess ? Color.mainColor1 : Color.clear) : Color.disable)
                    
                    Spacer(minLength: 2)
                }
                .disabled(viewModel.campfireName.isEmpty && viewModel.campfirePin.isEmpty)
            }
            ToolbarItem(placement: .bottomBar) {
                cameraModeToggleButton
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isCameraMode {
            JoinCampfireByCameraView().ignoresSafeArea()
        } else {
            manualEntryView
        }
    }
    
    private var manualEntryView: some View {
        VStack(alignment: .leading) {
            VStack {
                if viewModel.showError {
                    Text("캠핑장 이름과 거리가 맞는지 확인해주세요")
                        .foregroundStyle(Color.errorRed)
                        .font(.custom("Pretendard-Regular", size: 18))
                        .padding(EdgeInsets(top: 8, leading: 22, bottom: 0, trailing: 0))
                } else if viewModel.showSuccess {
                    Text("모닥불 도착")
                        .foregroundStyle(Color.textColor1)
                        .font(.custom("Pretendard-Bold", size: 23))
                        .padding(EdgeInsets(top: 30, leading: 18, bottom: -28, trailing: 0))
                } else {
                    Text("모닥불로 가는 길을 알려주세요")
                        .foregroundStyle(Color.white)
                        .font(.custom("Pretendard-Bold", size: 18))
                        .padding(EdgeInsets(top: 8, leading: 22, bottom: 0, trailing: 0))
                }
            }
            .transition(.opacity) // 애니메이션 전환 효과
            .animation(.easeOut(duration: 0.2), value: viewModel.showError || viewModel.showSuccess)
                            
            Spacer()
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Image("joincampfire_sign")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                        .overlay {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    TextField("", text: $viewModel.campfireName)
                                        .customTextFieldStyle(placeholder: "모닥불 이름", text: $viewModel.campfireName, alignment: .center)
                                        .animation(.easeOut, value: viewModel.campfireName.count)
                                        .onChange(of: viewModel.campfireName) { _, newValue in
                                            if newValue.count > 12 {
                                                viewModel.campfireName = String(newValue.prefix(12))
                                            }
                                        }
                                    
                                    Text("까지 ,")
                                        .foregroundStyle(Color.init(hex: "795945"))
                                        .font(.custom("Pretendard-Bold", size: 16))
                                        .kerning(16 * 0.01)
                                        .fixedSize(horizontal: true, vertical: false) // 가로 크기 고정
                                        .transition(.opacity)
                                        .animation(.easeOut, value: viewModel.campfireName.count)
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (viewModel.campfireName.count < 5 ? 214 : 84)))
                                
                                HStack {
                                    TextField("", text: $viewModel.campfirePin)
                                        .customTextFieldStyle(placeholder: "km", text: $viewModel.campfirePin, alignment: .trailing)
                                        .animation(.easeOut, value: viewModel.campfirePin.count)
                                        .onChange(of: viewModel.campfirePin) { _, newValue in
                                            let filtered = newValue.filter { $0.isNumber || $0 == "." }
                                            if filtered != newValue {
                                                viewModel.campfirePin = filtered
                                            }
                                            if newValue.count > 7 {
                                                viewModel.campfirePin = String(newValue.prefix(7))
                                            }
                                        }
                                    
                                    Text("남음")
                                        .foregroundStyle(Color.init(hex: "795945"))
                                        .font(.custom("Pretendard-Bold", size: 16))
                                        .kerning(16 * 0.01)
                                        .transition(.opacity)
                                        .animation(.easeOut, value: viewModel.campfirePin.count)
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (viewModel.campfirePin.count < 6 ? 196 : 176)))
                            }
                            .padding(.top, -90)
                        }
                        .padding(.top, -110)
                    
                    Spacer()
                }
            }
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
    
}

#Preview {
    NavigationStack {
        JoinCampfireView()
    }
}
