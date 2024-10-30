//
//  JoinCampfire.swift
//  Modak
//
//  Created by kimjihee on 10/29/24.
//

import SwiftUI

struct JoinCampfire: View {
    @State var roomName:  String = ""
    @State var roomPassword: String = ""
    @State private var isCameraMode: Bool = false
    @State private var showError: Bool = false
    @State private var showSuccess: Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            
            contentView
            
            // 모드 선택 토글 버튼
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isCameraMode.toggle() // 모드 전환
                    }) {
                        Text(isCameraMode ? "직접 입력하기" : "촬영해서 입력")
                            .font(.custom("Pretendard-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                            .background(Color.textBackgroundRedGray.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.mainColor1, lineWidth: 1.8) // 라인선 추가
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 14)
            }
            
            if showSuccess {
                BottomSheet(isPresented: $showSuccess, viewName: "JoinCampfireView")
                    .transition(.move(edge: .bottom))
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showSuccess = true
//                    sendRoomCredentialsToServer() //TODO: 서버 api 연결
                }) {
                    Text("완료")
                        .font(.custom("Pretendard-Regular", size: 18))
                        .foregroundColor((!roomName.isEmpty || !roomPassword.isEmpty) ? (!showSuccess ? Color.mainColor1 : Color.clear) : Color.disable)
                    
                    Spacer(minLength: 2)
                }
                .disabled(roomName.isEmpty && roomPassword.isEmpty)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if isCameraMode {
            cameraModeView
        } else {
            manualEntryView
        }
    }
    
    private var cameraModeView: some View {
        VStack {
            Text("카메라뷰")
        }
    }
    
    private var manualEntryView: some View {
        VStack(alignment: .leading) {
            VStack {
                if showError {
                    Text("캠핑장 이름과 거리가 맞는지 확인해주세요")
                        .foregroundStyle(Color.init(hex: "FF6464"))
                        .font(.custom("Pretendard-Regular", size: 18))
                        .padding(EdgeInsets(top: 8, leading: 22, bottom: 0, trailing: 0))
                } else if showSuccess {
                    Text("모닥불 도착")
                        .foregroundStyle(Color.textColor1)
                        .font(.custom("Pretendard-Bold", size: 23))
                        .padding(EdgeInsets(top: 30, leading: 18, bottom: -28, trailing: 0))
                } else {
                    Text("모닥불로 가는 길을 알려주세요")
                        .foregroundStyle(Color.white)
                        .font(.custom("Pretendard-Bold", size: 18))
                        .padding(EdgeInsets(top: 8, leading: 22, bottom: 0, trailing: 0))
                }
            }
            .transition(.opacity) // 애니메이션 전환 효과
            .animation(.easeOut(duration: 0.2), value: showError || showSuccess)
                            
            Spacer()
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Image("joincampfire_sign")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                        .overlay {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    TextField("", text: $roomName)
                                        .customTextFieldStyle(placeholder: "모닥불 이름", text: $roomName, alignment: .center)
                                        .animation(.easeOut, value: roomName.count)
                                        .onChange(of: roomName) { _, newValue in
                                            if newValue.count > 12 {
                                                roomName = String(newValue.prefix(12))
                                            }
                                        }
                                    
                                    Text("까지 ,")
                                        .foregroundStyle(Color.init(hex: "795945"))
                                        .font(.custom("Pretendard-Bold", size: 16))
                                        .kerning(16 * 0.01)
                                        .fixedSize(horizontal: true, vertical: false) // 가로 크기 고정
                                        .transition(.opacity)
                                        .animation(.easeOut, value: roomName.count)
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (roomName.count < 5 ? 214 : 84)))
                                
                                HStack {
                                    TextField("", text: $roomPassword)
                                        .customTextFieldStyle(placeholder: "km", text: $roomPassword, alignment: .trailing)
                                        .animation(.easeOut, value: roomPassword.count)
                                        .onChange(of: roomPassword) { _, newValue in
                                            let filtered = newValue.filter { $0.isNumber || $0 == "." }
                                            if filtered != newValue {
                                                roomPassword = filtered
                                            }
                                            if newValue.count > 7 {
                                                roomPassword = String(newValue.prefix(7))
                                            }
                                        }
                                    
                                    Text("남음")
                                        .foregroundStyle(Color.init(hex: "795945"))
                                        .font(.custom("Pretendard-Bold", size: 16))
                                        .kerning(16 * 0.01)
                                        .transition(.opacity)
                                        .animation(.easeOut, value: roomPassword.count)
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: (roomPassword.count < 6 ? 196 : 176)))
                            }
                            .padding(.top, -90)
                        }
                        .padding(.top, -128)
                    
                    Spacer()
                }
            }
        }
    }
    
    // 예시 함수 (아직 api 안나옴)
    private func sendRoomCredentialsToServer() {
        // 서버의 URL
        guard let url = URL(string: "not yet") else { return }
        
        // 전송할 데이터
        let parameters: [String: Any] = [
            "roomName": roomName,
            "roomPassword": roomPassword
        ]
        
        // JSON 데이터로 변환
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending request: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            // 서버 응답 처리
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    self.showSuccess = true
                default:
                    self.showError = true
                }
            }
        }
        task.resume()
    }
}

#Preview {
    NavigationStack {
        JoinCampfire()
    }
}
