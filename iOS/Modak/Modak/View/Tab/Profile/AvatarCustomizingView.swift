//
//  CustomizableCharacter6View.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SwiftUI
import SceneKit

struct AvatarCustomizingView: View {
    @StateObject private var viewModel = AvatarCustomizingViewModel()
    @Environment(\.dismiss) private var dismiss
    private var categories: [String] = ItemData.sample.map { $0.category }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                CustomSCNView(scene: viewModel.scene)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if let loadedItems = viewModel.loadSelectedItems() {
                        viewModel.selectedItems = loadedItems
                        viewModel.setupScene()
                    }
                }
                .frame(height: 480)
                
                VStack(alignment: .trailing) {
                    Button(action: {
                        dismiss() // 이전 화면으로 이동
                    }) {
                        Image(systemName: "xmark")
                            .font(.custom("Pretendard-Medium", size: 22))
                            .foregroundColor(Color.textColorGray1)
                            .padding()
                    }
                    Spacer()
                    saveButton
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 20))
                }
            }
            
            VStack {
                categorySelection
                itemSelection
            }
            .padding(.horizontal, 20)
            .background {
                Color.init(hex: "252526")
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, topTrailing: 20))
                    .fill(Color.pagenationDisable)
                    .ignoresSafeArea()
            }
            .padding(.top, -10)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.saveAvatarCustomInfo()
            dismiss()
        }) {
            Text("저장하고 나가기")
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
    
    private var categorySelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        viewModel.selectCategory(category: category)
                    }) {
                        Image(systemName: iconName(for: category))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .gray)
                            .padding(6)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(viewModel.selectedCategory == category ? Color.init(hex: "524646") : .clear)
                            }
                    }
                }
            }
            .padding(.vertical, 14)
        }
    }
    
    private func iconName(for category: String) -> String {
        switch category {
        case "Top":
            return viewModel.selectedCategory == "Top" ? "tshirt.fill" : "tshirt"
        case "Hat":
            return viewModel.selectedCategory == "Hat" ? "hat.widebrim.fill" : "hat.widebrim"
        case "Face":
            return viewModel.selectedCategory == "Face" ? "sunglasses.fill" : "sunglasses"
        default:
            return "questionmark"
        }
    }
    
    private var itemSelection: some View {
        let category = viewModel.selectedCategory
        let items = viewModel.availableItems(for: category)
        
        return ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3),
                spacing: 20
            ) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        viewModel.applyItemToScene(category: category, item: item)
                    }) {
                        ZStack {
                            Image(item)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(14)
                            
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(viewModel.isSelected(item: item, in: category) ? Color.mainColor1 : Color.clear, lineWidth: 4)
                                .foregroundStyle(Color.gray.opacity(0.1))
                        }
                        .cornerRadius(14)
                    }
                }
            }
        }
    }
}

#Preview {
    AvatarCustomizingView()
}
