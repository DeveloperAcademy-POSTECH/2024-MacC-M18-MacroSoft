//
//  InviteMemberView.swift
//  Modak
//
//  Created by kimjihee on 11/11/24.
//

import SwiftUI
import FirebaseAnalytics

struct InviteMemberView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 12) {
                Text("새로운 멤버 초대하기")
                    .font(Font.custom("Pretendard-Bold", size: 23))
                    .foregroundStyle(.textColor1)
                
                Text("모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요.")
                    .font(Font.custom("Pretendard-Regular", size: 16))
                    .foregroundStyle(.textColorGray1)
            }
            .padding(.init(top: 36, leading: 20, bottom: 44, trailing: 0))
            
            Spacer()
            
            Image("milestone_component")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width)
                .overlay {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(hex: "C28C7B").opacity(0.25))
                                .frame(height: 30)
                                .overlay {
                                    Text("\(viewModel.mainCampfireInfo!.campfireName)")
                                        .foregroundStyle(Color.white)
                                        .font(.custom("Pretendard-Bold", size: 18))
                                        .kerning(18 * 0.01)
                                }
                            
                            Text("까지 ,")
                                .foregroundStyle(Color.init(hex: "795945"))
                                .font(.custom("Pretendard-Bold", size: 16))
                                .kerning(16 * 0.01)
                        }
                        .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (viewModel.mainCampfireInfo!.campfireName.count < 5 ? 214 : 84)))
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(hex: "C28C7B").opacity(0.25))
                                .frame(height: 30)
                                .overlay {
                                    Text("\(formattedPin())  km")
                                        .foregroundStyle(Color.white)
                                        .font(.custom("Pretendard-Bold", size: 18))
                                        .kerning(18 * 0.01)
                                        .padding(.leading, 22)
                                }
                            
                            Text("남음")
                                .foregroundStyle(Color.init(hex: "795945"))
                                .font(.custom("Pretendard-Bold", size: 16))
                                .kerning(16 * 0.01)
                        }
                        .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: UIScreen.main.bounds.width/3))
                    }
                    .padding(.top, -90)
                }
                .padding(.top, -110)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    
                    Text("지금은 됐어요")
                        .font(Font.custom("Pretendard-Bold", size: 17))
                        .foregroundStyle(.white)
                        .padding(.vertical, 18)
                    
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 73)
                    .fill(.mainColor1)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background {
            Color.backgroundDefault.ignoresSafeArea()
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
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "InviteMemberView",
                AnalyticsParameterScreenClass: "InviteMemberView"])
        }
    }
    
    private func formattedPin() -> String {
        let pinString = String(viewModel.mainCampfireInfo!.campfirePin)
        let formatted = pinString.prefix(3) + "." + pinString.suffix(3)
        return String(formatted)
    }
}

#Preview {
    NavigationStack {
        InviteMemberView()
    }
}
