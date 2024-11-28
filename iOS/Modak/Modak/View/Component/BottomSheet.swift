//
//  BottomSheetView.swift
//  Modak
//
//  Created by kimjihee on 10/9/24.
//

import SwiftUI

struct BottomSheet: View {
    @EnvironmentObject private var joinCampfireViewModel: JoinCampfireViewModel
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    let viewName: String
    
    @Binding var campfireName: String?
    @Binding var createdAt: String?
    @Binding var membersNames: [String]?
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
                .opacity(backgroundOpacity())
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    hideSheet()
                }

            VStack {
                Spacer()
                VStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.disable)
                        .frame(width: 40, height: 5)
                        .padding(.top, 14)
                        .padding(.bottom, 12)
                    
                    bottomSheetContent(viewName)
                    
                    Spacer()
                }
                .frame(height: (viewName == "OrganizePhotoView" ? geometry.size.height/3 : geometry.size.height*2/5))
                .frame(maxWidth: .infinity)
                .background(Color.backgroundDefault)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .offset(y: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = max(value.translation.height, 0)
                        }
                        .onEnded { value in
                            if value.translation.height > 50 {
                                hideSheet()
                            } else {
                                showSheet()
                            }
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
            .ignoresSafeArea()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if isPresented {
                showSheet()
            }
        }
    }
    
    private func showSheet() {
        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
            offset = 0
        }
    }
    
    private func hideSheet() {
        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
            offset = UIScreen.main.bounds.height
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
    
    private func backgroundOpacity() -> Double {
        let maxOpacity: Double = 0.5
        let progress = 1 - (offset / UIScreen.main.bounds.height)
        return maxOpacity * progress
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension BottomSheet {
    @ViewBuilder
    func bottomSheetContent(_ name: String) -> some View {
        switch name {
        case "OrganizePhotoView":
            VStack(alignment: .leading) {
                Text("장작이란?")
                    .foregroundStyle(Color.textColor2)
                    .font(.custom("Pretendard-Bold", size: 21))
                    .padding(.bottom, 18)
                
                HStack {
                    Text("여러분의 ")
                        .foregroundStyle(Color.textColorGray1)
                        .font(.custom("Pretendard-Regular", size: 18))
                    + Text("기억의 숲 ")
                        .foregroundStyle(Color.mainColor2)
                        .font(.custom("Pretendard-SemiBold", size: 18))
                    + Text("에서 구할 수 있는\n")
                        .foregroundStyle(Color.textColorGray1)
                        .font(.custom("Pretendard-Regular", size: 18))
                    + Text("특별한 장작")
                        .foregroundStyle(Color.textColor1)
                        .font(.custom("Pretendard-SemiBold", size: 18))
                    + Text("이에요")
                        .foregroundStyle(Color.textColorGray1)
                        .font(.custom("Pretendard-Regular", size: 18))
                    
                    Spacer()
                }
                .lineSpacing(18 * 0.45)
                .padding(.bottom, 18)
                
                Text("장작을 많이 구비해두면 기억하고싶은 특별한 순간의\n추억 불씨를 피울 수 있어요")
                    .foregroundStyle(Color.textColorGray2)
                    .font(.custom("Pretendard-Regular", size: 16))
                    .lineSpacing(16 * 0.5)
            }
            .padding(.leading, 24)
            
        case "JoinCampfireView":
            VStack(alignment: .leading) {
                HStack {
                    Text("\(campfireName ?? "000") 모닥불")
                        .foregroundStyle(Color.textColor2)
                        .font(.custom("Pretendard-Bold", size: 21))
                        .padding(.bottom, 14)
                    
                    Spacer()
                }
                
                Text("개설일")
                    .foregroundStyle(Color.textColorGray1)
                    .font(.custom("Pretendard-Light", size: 15))
                    .padding(.bottom, 2)
                Text(createdAt ?? "2024.00.00")
                    .foregroundStyle(Color.textColor1)
                    .font(.custom("Pretendard-SemiBold", size: 18))
                    .padding(.bottom, 10)
                
                Text("멤버")
                    .foregroundStyle(Color.textColorGray1)
                    .font(.custom("Pretendard-Light", size: 15))
                    .padding(.bottom, 2)
                Text("\(membersNames?.first ?? "000") 외 \((membersNames?.count ?? 1) - 1)명")
                    .foregroundStyle(Color.textColor1)
                    .font(.custom("Pretendard-SemiBold", size: 18))
                    .padding(.bottom, 14)
                
                Text("해당 모닥불에 참여할까요?")
                    .foregroundStyle(Color.textColorGray2)
                    .font(.custom("Pretendard-Light", size: 16))
                    .padding(.bottom, 16)
            }
            .padding(.leading, 24)
            
            Button(action: {
                joinCampfireViewModel.validateAndSendCredentials {
                    Task {
                        await campfireViewModel.testChangeCurrentCampfirePin(Int(joinCampfireViewModel.campfirePin) ?? 0)
                        await campfireViewModel.testFetchCampfireInfos()
                        await campfireViewModel.testFetchMainCampfireInfo()
                        await campfireViewModel.fetchTodayImageURL()
                        //TODO: 다음 페이지 전환 방법 생각해보기
                        dismiss()
                        dismiss()
                    }
                }
            }) {
                Text("모닥불 참여하기")
                    .font(.custom("Pretendard-Bold", size: 16))
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24))
                    .background(Color.mainColor1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1) // 라인선 추가
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            
        default:
            Text("기본 콘텐츠")
                .font(.custom("Pretendard-Regular", size: 16))
                .foregroundStyle(Color.textColorGray2)
        }
    }
}

#Preview {
//    BottomSheet(isPresented: .constant(true), viewName: "JoinCampfireView")
}
