//
//  JoinCampfireByTextView.swift
//  Modak
//
//  Created by kimjihee on 11/4/24.
//

import SwiftUI

struct JoinCampfireByTextView: View {
    @EnvironmentObject var viewModel: JoinCampfireViewModel

    var body: some View {
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
            .transition(.opacity)
            .animation(.easeOut(duration: 0.2), value: viewModel.showError || viewModel.showSuccess)
            
            Spacer()
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Image("milestone_component")
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
                                        .fixedSize(horizontal: true, vertical: false)
                                        .transition(.opacity)
                                        .animation(.easeOut, value: viewModel.campfireName.count)
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (viewModel.campfireName.count < 5 ? UIScreen.main.bounds.width/2 : 84)))
                                
                                HStack {
                                    TextField("", text: $viewModel.campfirePin)
                                        .customTextFieldStyle(placeholder: "km", text: $viewModel.campfirePin, alignment: .trailing)
                                        .keyboardType(.decimalPad)
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
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (viewModel.campfirePin.count < 4 ? UIScreen.main.bounds.width/2 : UIScreen.main.bounds.width/3)))
                            }
                            .padding(.top, -90)
                        }
                        .padding(.top, -110)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    JoinCampfireByTextView()
}
