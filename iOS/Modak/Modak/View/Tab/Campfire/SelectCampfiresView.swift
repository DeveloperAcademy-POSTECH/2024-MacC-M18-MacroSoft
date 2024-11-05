//
//  SelectCampfiresView.swift
//  Modak
//
//  Created by Park Junwoo on 11/5/24.
//

import SwiftUI

// TODO: 테스트용 추후 제거
private class TestCampfire {
    var id: Int
    var title: String
    var todayImage: PublicLogImage?
    var pin: Int
    
    init(id: Int, title: String, todayImage: PublicLogImage? = nil, pin: Int) {
        self.id = id
        self.title = title
        self.todayImage = todayImage
        self.pin = pin
    }
}

struct SelectCampfiresView: View {
    // TODO: 테스트용 변수 추후 DB 데이터와 연결
    @State private var campfires: [TestCampfire] = [TestCampfire(id: 1, title: "매크로소프트", pin: 1), TestCampfire(id: 2, title: "매크로소프트", pin: 2)]
    // TODO: 테스트용 변수 추후 DB 데이터와 연결
    @State private var currentCampfireID: Int = 1
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("내 모닥불")
                    .font(Font.custom("Pretendard-SemiBold", size: 17))
                    .foregroundStyle(.textColor1)
                    .padding(.top, 8)
                    .padding(.leading, 24)
                
                HStack(spacing: 8) {
                    SelectCampfiresViewTopButton(buttonImage: .milestone, buttonText: "모닥불 참여")
                    
                    SelectCampfiresViewTopButton(buttonImage: .tent, buttonText: "모닥불 생성")
                }
                .padding(.init(top: 16, leading: 16, bottom: 10, trailing: 16))
                
                List($campfires, id: \.id) { campfire in
                    SelectCampfiresViewCampfireButton(campfire: campfire, currentCampfireId: $currentCampfireID, isShowSideMenu: $isShowSideMenu)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.clear)
                }
                .contentMargins(.all, 0)
                .scrollContentBackground(.hidden)
            }
            
            Spacer()
        }
    }
}

// MARK: - SelectCampfiresViewTopButton

private struct SelectCampfiresViewTopButton: View {
    private(set) var buttonImage: ImageResource
    private(set) var buttonText: String
    
    var body: some View {
        Button {
            
        } label: {
            RoundedRectangle(cornerRadius: 43)
                .fill(Color.init(hex: "464141"))
                .stroke(Color.init(hex: "4B4B4B"), lineWidth: 1)
                .overlay {
                    VStack(spacing: 8) {
                        Image(buttonImage)
                            .resizable()
                            .scaledToFit()
                        
                        Text(buttonText)
                            .font(Font.custom("Pretendard-SemiBold", size: 14))
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 8)
                }
        }
        .frame(height: 70)
    }
}

// MARK: - SelectCampfiresViewCampfireButton

private struct SelectCampfiresViewCampfireButton: View {
    @Binding private(set) var campfire: TestCampfire
    @Binding private(set) var currentCampfireId: Int
    @Binding private(set) var isShowSideMenu: Bool
    
    // TODO: 테스트용 변수 추후 DB 데이터와 연결
    private(set) var people = ["아서아서서", "온브", "조이", "에이스", "라무네라무네"]
    
    var body: some View {
        if campfire.id == currentCampfireId {
            Button {
                withAnimation {
                    isShowSideMenu = false
                }
            } label: {
                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                    .fill(Color(hex: "464141"))
                    .overlay(
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                            .strokeBorder(.mainColor2, lineWidth: 1)
                            .clipShape(
                                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                            )
                            .mask(
                                Rectangle()
                                    .padding(.leading, 1)
                            )
                    )
                    .overlay {
                        HStack(spacing: 12) {
                            Image(.progressDefault)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .aspectRatio(1, contentMode: .fit)
                            
                            VStack {
                                Text(campfire.title)
                                    .font(Font.custom("Pretendard-SemiBold", size: 14))
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                    }
            }
            .frame(height: 72)
            .padding(.trailing)
        } else {
            Button {
                currentCampfireId = campfire.id
                withAnimation {
                    isShowSideMenu = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.init(hex: "443D41"))
                    .overlay {
                        HStack(spacing: 12) {
                            Image(.progressDefault)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .aspectRatio(1, contentMode: .fit)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(campfire.title)
                                    .font(Font.custom("Pretendard-SemiBold", size: 14))
                                    .foregroundStyle(.textColorGray2)
                                
                                HStack(spacing: 2){
                                    ForEach(Array(zip(people.indices, people)), id: \.0) { index ,person in
                                        if index < 3{
                                            Text(person, textLimit: 4)
                                                .foregroundStyle(Color.init(hex: "B58580"))
                                                .padding(6)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 13)
                                                        .fill(Color.init(hex: "4D4343"))
                                                }
                                        }
                                    }
                                    if people.count > 3 {
                                        Text("+\(people.count - 3)")
                                            .padding(6)
                                            .foregroundStyle(.textColor2)
                                            .background {
                                                RoundedRectangle(cornerRadius: 13)
                                                    .stroke(Color.init(hex: "4D4343"), lineWidth: 1)
                                            }
                                    }
                                }
                                .font(Font.custom("Pretendard-Medium", size: 11))
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                    }
            }
            .frame(height: 72)
            .padding(.leading, 12)
            .padding(.trailing)
        }
    }
}

#Preview {
    SelectCampfiresView(isShowSideMenu: .constant(true))
}
