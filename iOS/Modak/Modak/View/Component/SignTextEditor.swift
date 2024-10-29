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
        content
            .focused($isFocused) // 포커스 상태 관리
            .padding(10)
            .frame(height: 39)
            .background(isFocused ? Color.init(hex: "C28C7B").opacity(0.5) : Color.init(hex: "C28C7B").opacity(0.25))
            .background(alignment: alignment) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("Pretendard-Bold", size: 23))
                        .kerning(23 * 0.01)
                        .foregroundColor(isFocused ? Color.init(hex: "B07E6E").opacity(0) : Color.init(hex: "B07E6E").opacity(0.5))
                        .padding(.horizontal, 7)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isFocused ? Color.white : Color.clear, lineWidth: 1)
            )
            .font(.custom("Pretendard-Bold", size: 23))
            .padding(.trailing, -4)
    }
}

extension TextField {
    func customTextFieldStyle(placeholder: String, text: Binding<String>, alignment: Alignment = .center) -> some View {
        self.modifier(SignTextFieldModifier(placeholder: placeholder, text: text, alignment: alignment))
    }
}

#Preview {
    @Previewable @State var userInput: String = ""

    TextField("", text: $userInput)
        .customTextFieldStyle(placeholder: "모닥불 이름", text: $userInput)
}
