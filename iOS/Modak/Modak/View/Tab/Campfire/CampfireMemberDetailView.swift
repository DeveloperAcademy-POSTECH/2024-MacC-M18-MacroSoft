//
//  CampfireMemberDetailView.swift
//  Modak
//
//  Created by kimjihee on 11/13/24.
//

import SwiftUI

struct CampfireMemberDetailView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @StateObject private var avatarViewModel = CampfireMemberDetailViewModel()

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
            
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                    spacing: 20
                ) {
                    ForEach(avatarViewModel.memberAvatars, id: \.memberId) { member in
                        VStack {
                            if let viewModel = avatarViewModel.memberViewModels[member.memberId] {
                                CustomSCNView(scene: viewModel.scene) // 멤버별 Scene 사용
                                    .frame(height: 270)
                                    .padding(EdgeInsets.init(top: -48, leading: 0, bottom: -54, trailing: 0))
                            }
                            Text(member.nickname)
                                .font(.custom("Pretendard-Medium", size: 12))
                                .kerning(14 * 0.01)
                                .foregroundColor(Color.pagenationAble)
                                .lineLimit(1)
                                .padding(EdgeInsets.init(top: 6, leading: 11, bottom: 6, trailing: 11))
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.init(hex: "4D4343"))
                                }
                        }
                    }
                }
            }
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
        .onAppear {
            Task {
                guard let memberIds = viewModel.campfire?.memberIds else { return }
                await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CampfireMemberDetailView()
    }
}
