//
//  CampfireMemberDetailView.swift
//  Modak
//
//  Created by kimjihee on 11/13/24.
//

import SwiftUI

struct CampfireMemberDetailView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("모닥불 멤버")
                    .foregroundStyle(.textColor1)
                    .font(.custom("Pretendard-Bold", size: 23))
                    .padding(.trailing, 4)
                
                HStack(spacing: 4) {
                    Text("멤버")
                        .foregroundStyle(.textColorTitleView)
                        .font(.custom("Pretendard_Medium", size: 12))
                        .padding(.init(top: 6, leading: 8, bottom: 6, trailing: 0))
                    Text("\(viewModel.campfire!.membersNames.isEmpty ? viewModel.campfire!.memberIds.count : viewModel.campfire!.membersNames.count)명")
                        .foregroundStyle(.textColor3)
                        .font(.custom("Pretendard_Medium", size: 14))
                        .padding(.init(top: 6, leading: 0, bottom: 6, trailing: 8))
                }
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.init(hex: "3A3539"))
                }

                Spacer()
                
                NavigationLink {
                    InviteMemberView()
                } label: {
                    Image("milestone_invitebutton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28)
                }
                
            }
            
            Spacer()
            
        }
        .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 0, trailing: 20))
        .background {
            Color.backgroundDefault.ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    BackButton()
                        .colorMultiply(Color.textColorGray1)
                    Text("\(viewModel.campfire!.name)")
                        .foregroundStyle(.textColor2)
                        .font(.custom("Pretendard-Regular", size: 16))
                        .padding(.leading, -10)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CampfireMemberDetailView()
    }
}
