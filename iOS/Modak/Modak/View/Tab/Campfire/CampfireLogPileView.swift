//
//  CampfireLogPileView.swift
//  Modak
//
//  Created by Park Junwoo on 11/7/24.
//

import SwiftUI

struct CampfireLogPileView: View {
    // TODO: 테스트용 변수들 추후 제거
    @State private var isEmpty: Bool = false
    @State private var campfireName: String = "Macro"
    @State private var campfireMemberCount: Int = 6
    
    init() {
        let appearanceWhenNotScrolled = UINavigationBarAppearance()
        appearanceWhenNotScrolled.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 0, weight: .semibold),
            .foregroundColor: UIColor.clear
        ]
        appearanceWhenNotScrolled.configureWithTransparentBackground()
        
        let appearanceWhenScrolled = UINavigationBarAppearance()
        appearanceWhenScrolled.titleTextAttributes = [
            .font: UIFont.init(name: "Pretendard-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.textColorTitleView
        ]
        appearanceWhenScrolled.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        UINavigationBar.appearance().standardAppearance = appearanceWhenScrolled
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceWhenNotScrolled
    }
    
    var body: some View {
        ZStack {
            // TODO: 캠프파이어 로그가 없는지 체크하는 로직 추가
            if isEmpty {
                VStack {
                    CampfireLogPileViewTitle(campfireName: $campfireName, campfireMemberCount: $campfireMemberCount)
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    CampfireEmptyLog(campfireName: $campfireName)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    CampfireLogPileViewTitle(campfireName: $campfireName, campfireMemberCount: $campfireMemberCount)
                        .padding(.leading, 24)
                }
            }
            
            CampfireLogPileViewFloatingButton()
                .padding(.init(top: 0, leading: 0, bottom: 14, trailing: 24))
        }
        .background {
            Group {
                Color.backgroundLogPile
                
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.08, green: 0.06, blue: 0.08).opacity(0.5), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.15, green: 0.15, blue: 0.15).opacity(0.5), location: 0.36),
                        Gradient.Stop(color: Color(red: 0.24, green: 0.23, blue: 0.23).opacity(0), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0.93, blue: 0.63).opacity(0), location: 0.65),
                        Gradient.Stop(color: Color(red: 1, green: 0.77, blue: 0.63).opacity(0.05), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            }
            .ignoresSafeArea()
        }
        .navigationTitle("\(campfireName) 모닥불")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

private struct CampfireLogPileViewTitle: View {
    @Binding private(set) var campfireName: String
    @Binding private(set) var campfireMemberCount: Int
    
    var body: some View {
        HStack {
            Text("\(campfireName) 모닥불")
                .foregroundStyle(.textColor1)
                .font(.custom("Pretendard-Bold", size: 23))
                .padding(.trailing, 4)
            
            // TODO: CampfireNameView 화면 데이터 연결
            NavigationLink {
                CampfireNameView(isCreate: false)
            } label: {
                Image(systemName: "pencil.line")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 20)
                    .foregroundStyle(.textColorGray1)
            }
            .padding(.trailing, 12)
            
            // TODO: CampfireMemberDetail 화면으로 연결
            NavigationLink {
                
            } label: {
                HStack(spacing: 4) {
                    Text("멤버")
                        .foregroundStyle(.textColorTitleView)
                        .font(.custom("Pretendard_Medium", size: 12))
                        .padding(.init(top: 6, leading: 8, bottom: 6, trailing: 0))
                    
                    // TODO: 캠프파이어 멤버 숫자 로직 추가
                    Text("\(campfireMemberCount)명")
                        .foregroundStyle(.textColorGray2)
                        .font(.custom("Pretendard_Medium", size: 14))
                        .padding(.init(top: 6, leading: 0, bottom: 6, trailing: 8))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.profileButtonBackground,lineWidth: 1)
                }
            }
            
            Spacer()
        }
    }
}

private struct CampfireLogPileViewFloatingButton: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                // TODO: SelectMergeLogs 화면으로 연결
                NavigationLink {
                    
                } label: {
                    Circle()
                        .fill(Color.init(hex: "4C4545"))
                        .stroke(Color.mainColor2, lineWidth: 1)
                        .frame(width: 62, height: 62)
                        .shadow(color: .black.opacity(0.15), radius: 17.44, y: 5.23)
                        .overlay {
                            AddCampfireLogImage()
                        }
                }
            }
        }
    }
}

#Preview{
    CampfireLogPileView()
}