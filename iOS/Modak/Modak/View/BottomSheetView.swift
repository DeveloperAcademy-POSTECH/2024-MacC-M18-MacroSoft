//
//  BottomSheetView.swift
//  Modak
//
//  Created by kimjihee on 10/9/24.
//

import SwiftUI

struct BottomSheetView: View {
    @Binding var isPresented: Bool
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    
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
                    
                    VStack(alignment: .leading) {
                        Text("자작이란?")
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
                    
                    Spacer()
                }
                .frame(height: geometry.size.height / 3)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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

#Preview {
    BottomSheetView(isPresented: .constant(true))
}
