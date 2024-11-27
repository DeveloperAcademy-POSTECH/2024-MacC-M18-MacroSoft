//
//  JoinCampfireByCameraView.swift
//  Modak
//
//  Created by kimjihee on 10/31/24.
//

import SwiftUI

struct JoinCampfireByCameraView: View {
    @EnvironmentObject var viewModel: JoinCampfireViewModel
    
    var body: some View {
        ZStack {
            viewModel.cameraViewModel.cameraPreview
                .onAppear {
                    if !viewModel.cameraViewModel.cameraPermissionAlert {
                        viewModel.cameraViewModel.startSessionIfNeeded()
                    }
                }
                .onDisappear {
                    viewModel.cameraViewModel.stopSession()
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            if let image = viewModel.cameraViewModel.recentImage, viewModel.cameraViewModel.isCapturing == false {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .zIndex(-1)
                    .clipped()
                    .ignoresSafeArea()
            }
            
            Image(!viewModel.showError ? "joincmapfirebycamera_captureguideline" : "joincmapfirebycamera_captureguideline_error")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()

            HStack {
                VStack(alignment: .leading) {
                    Text("모닥불로 참여하기")
                        .foregroundStyle(Color.textColor1)
                        .font(.custom("Pretendard-Bold", size: 23))
                        .padding(EdgeInsets(top: 120, leading: 22, bottom: 12, trailing: 0))
                        .kerning(23 * 0.01)
                    
                    Text(!viewModel.showError ? "이정표를 촬영해주세요." : "모닥불 이름과 거리가 맞는지 확인해주세요")
                        .foregroundStyle(!viewModel.showError ? Color.textColorGray1 : Color.errorRed)
                        .font(.custom("Pretendard-Regular", size: 16))
                        .padding(.leading, 22)
                        .transition(.opacity) // 애니메이션 전환 효과
                        .animation(.easeOut(duration: 0.2), value: viewModel.showError)
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    viewModel.cameraViewModel.isCapturing = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if !viewModel.campfirePin.isEmpty {
                            viewModel.fetchCampfireInfo(campfirePin: viewModel.campfirePin)
                            viewModel.showSuccess = true
                        } else {
                            print("캠프파이어 PIN이 유효하지 않음: \(viewModel.campfirePin)")
                            viewModel.showError = true
                            
                            // 1초 후 에러 상태 초기화 및 카메라 다시 작동
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.cameraViewModel.startSessionIfNeeded() // 카메라 세션 재시작
                                viewModel.showError = false // 에러 상태 초기화
                            }
                        }
                    }
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(16)
                        .background {
                            Circle().fill(Color.mainColor1)
                        }
                })
                .padding(.bottom, 140)
                .onChange(of: viewModel.showSuccess) { _, newValue in
                    if !newValue {
                        viewModel.campfirePin = ""
                        viewModel.campfireName = ""
                        viewModel.cameraViewModel.startSessionIfNeeded()
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.cameraViewModel.cameraPermissionAlert) {
            Alert(
                title: Text("카메라 접근 권한이 필요합니다"),
                message: Text("설정에서 카메라 접근을 허용해주세요."),
                primaryButton: .default(Text("설정으로 이동"), action: {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }),
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
        
}

#Preview {
    JoinCampfireByCameraView()
}
