//
//  PhotoView.swift
//  Modak
//
//  Created by Park Junwoo on 10/14/24.
//

import SwiftUI

struct PhotoView: View {
    @State var selection: String = "log"
    let images = ["log", "leaf", "log_3D", "photosIcon", "tab_campfire", "tab_log_file", "tab_profile", "pagenationBar1", "pagenationBar2", "pagenationBar3"]
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ForEach(images, id: \.self) { image in
                    VStack {
                        Spacer()
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .tag(image)
                        Spacer()
                    }
                }
            }
            .background(.backgroundPhoto)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                
                ToolbarItem(placement: .principal) {
                    VStack{
                        Text("포항시 남구")
                            .foregroundStyle(.textColorWhite)
                            .font(Font.custom("Pretendard-Regular", size: 13))
                        Text("\(Date().logPileRowTitleDayFormat)")
                            .foregroundStyle(.textColor1)
                            .font(Font.custom("Pretendard-Regular", size: 10))
                    }
                }
                // TODO: 하단 사진 Selector 구현하기
                /*
                 ToolbarItem(placement: .status) {
                 ScrollViewReader { scrView in
                 ScrollView(.horizontal) {
                 
                 LazyHStack(spacing: 0) {
                 ForEach(images, id: \.self) { image in
                 Image(image)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: 34)
                 .foregroundStyle(.red)
                 .background(.blue)
                 .clipShape(Rectangle())
                 .padding(.horizontal, selection == image ? 16 : 1.5)
                 .onTapGesture {
                 selection = image
                 // 선택된 이미지로 스크롤
                 if let selectedIndex = images.firstIndex(of: image) {
                 scrView.scrollTo(image, anchor: .center)
                 }
                 
                 }
                 .padding(images.count > images.firstIndex(of: selection)! ? .leading : .trailing, CGFloat(images.count - images.firstIndex(of: selection)!) * 34)
                 .id(image)
                 }
                 
                 .onChange(of: selection) { _ , value in
                 if let selectedIndex = images.firstIndex(of: value) {
                 scrView.scrollTo(images[selectedIndex], anchor: .center)
                 }
                 }
                 }
                 
                 }
                 .scrollIndicators(.hidden)
                 }
                 }
                 */
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    PhotoView()
}
