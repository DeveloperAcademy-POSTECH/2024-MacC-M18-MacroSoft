//
//  SignTextEditor.swift
//  Modak
//
//  Created by kimjihee on 10/29/24.
//

import SwiftUI

struct SignTextFieldModifier: ViewModifier {
    
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool // 선택 여부에 따라 스타일 달라짐
    var alignment: Alignment = .center
    
    func body(content: Content) -> some View {
        HStack {
            content
                .focused($isFocused) // 포커스 상태 관리
                .padding(.leading, !isFocused && !text.isEmpty ? 0 : 10)
                .padding(.trailing, !isFocused && !text.isEmpty && placeholder == "km" ? 20 : 0)
                .frame(height: 30)
                .foregroundStyle(Color.white)
                .font(.custom("Pretendard-Bold", size: 18))
                .kerning(18 * 0.01)
                .multilineTextAlignment(!isFocused && !text.isEmpty ? .center : .leading)
                .background(alignment: alignment) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.custom("Pretendard-Bold", size: 18))
                            .kerning(18 * 0.01)
                            .foregroundColor(isFocused ? Color.clear : Color.init(hex: "B07E6E").opacity(0.5))
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 7))
                    } else {
                        if placeholder == "km" {
                            Text(placeholder)
                                .font(.custom("Pretendard-Bold", size: 18))
                                .kerning(18 * 0.01)
                                .foregroundColor(Color.white)
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 7))
                        }
                    }
                }
                .font(.custom("Pretendard-Bold", size: 18))
                .tint(Color.init(hex: "B07E6E"))
            
            if isFocused && !text.isEmpty {
                Button(action: {
                    text = "" // 텍스트를 초기화
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(Color.textColor3)
                        .font(.custom("Pretendard-SemiBold", size: 17))
                }
                .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 8))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 4) // 배경에 모서리 둥글게 적용
                .fill(isFocused ? Color.init(hex: "C28C7B") : Color.init(hex: "C28C7B").opacity(0.25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFocused ? Color.white : Color.clear, lineWidth: 1)
        )
        .padding(.trailing, -4)
    }
}

extension TextField {
    func customTextFieldStyle(placeholder: String, text: Binding<String>, alignment: Alignment = .center) -> some View {
        self.modifier(SignTextFieldModifier(placeholder: placeholder, text: text, alignment: alignment))
    }
}

#Preview {
    @Previewable @State var userInput: String = "반갑티비"

    TextField("", text: $userInput)
        .customTextFieldStyle(placeholder: "모닥불 이름", text: $userInput)
}
