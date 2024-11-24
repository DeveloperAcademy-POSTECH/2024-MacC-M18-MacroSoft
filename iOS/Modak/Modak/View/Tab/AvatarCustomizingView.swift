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
    private var categories: [String] = ItemModel.sample.map { $0.category }

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                SceneView(
                    scene: viewModel.scene,
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    viewModel.setupScene()
                }
                .frame(height: 460)
                
                saveButton
                    .padding(20)
            }
            
            categorySelection
            itemSelection
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.save()
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
            HStack {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        viewModel.selectCategory(category: category)
                    }) {
                        Text(category)
                            .fontWeight(viewModel.selectedCategory == category ? .bold : .regular)
                            .foregroundColor(viewModel.selectedCategory == category ? .orange : .black)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
    }
    
    private var itemSelection: some View {
        let category = viewModel.selectedCategory
        let items = viewModel.availableItems(for: category)
        
        return ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 28), count: 3),
                spacing: 28
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
                                .stroke(viewModel.selectedItems[category] == item ? Color.orange : Color.clear, lineWidth: 3)
                                .foregroundStyle(Color.gray.opacity(0.1))
                        }
                        .cornerRadius(14)
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 10)
        }
    }
}

#Preview {
    AvatarCustomizingView()
}