//
//  Authorization.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI
import Photos

struct AuthorizationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthorizationViewModel()
    @State private var showBottomSheet = false
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            VStack {
                Image("pagenationBar1")
                    .padding(.top, -12)
                
                onboardingCard(
                    title: "잊어버린 사진 속 순간들을\n추억으로 정리해요",
                    titleHighlightRanges: [5...11, 15...16],
                    context: "추억을 만나기 위해 다음 권한이 필요해요",
                    image: "null",
                    imagePadding: 0
                )
                
                Spacer()
                
                Button(action: {
                    viewModel.requestPhotoLibraryAccess()
                }) {
                    RoundedRectangle(cornerRadius: 73)
                        .frame(width: 345, height: 58)
                        .foregroundStyle(Color.mainColor1)
                        .overlay {
                            Text("동의하고 정리 시작하기")
                                .font(.custom("Pretendard-Bold", size: 17))
                                .lineSpacing(14 * 0.4)
                                .foregroundStyle(Color.white)
                        }
                }
                .padding(.bottom, 28)
                
                Button(action: {
                    showBottomSheet.toggle()
                }) {
                    Text("장작이 무엇인가요?")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.mainColor1)
                        .underline()
                }
                .padding(.bottom, 12)
            }
            
            VStack {
                Image("photosIcon")
                    .padding(.bottom, 20)
                
                Text("카메라•사진첩")
                    .foregroundStyle(Color.white)
                    .font(.custom("Pretendard-SemiBold", size: 17))
                    .padding(.bottom, 10)
                
                Text("추억이 담긴 사진을 정리하고 확인할 수 있어요")
                    .foregroundStyle(Color.textColorGray1)
                    .font(.custom("Pretendard-Regular", size: 15))
                    .padding(.bottom, 8)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 326, height: 56)
                    .foregroundStyle(Color.textBackgroundRedGray.opacity(0.1))
                    .overlay {
                        Text("사진은 휴대전화 내에서만 사용됩니다\n사진 정보는 개발자가 접근할 수 없어요.")
                            .font(.custom("Pretendard-Regular", size: 14))
                            .lineSpacing(14 * 0.4)
                            .foregroundStyle(Color.textColorGray2)
                    }
            }
            .padding(.top, 30)
            .padding(.bottom, 80)
            
            if showBottomSheet {
                BottomSheet(
                    isPresented: $showBottomSheet,
                    viewName: "AuthorizationView",
                    campfireName: .constant(nil),
                    createdAt: .constant(nil),
                    membersNames: .constant(nil)
                )
                .transition(.move(edge: .bottom))
            }
        }
        .multilineTextAlignment(.center)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("사진첩 전체 접근 권한을 허용해주세요"),
                message: Text("\n장작을 만들기 위해서 당신의 여러 활동이 담긴 사진이 필요합니다.\n\n*사진을 정리할 때의 사진과 개인 장작의 사진은 서버에 공유되지 않아요."),
                primaryButton: .default(Text("확인")) {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
        .fullScreenCover(isPresented: $viewModel.navigateToOrganizePhotoView) {
            OrganizePhotoView()
        }
        .onChange(of: viewModel.navigateToOrganizePhotoView, {
            if viewModel.navigateToOrganizePhotoView == false {
                dismiss()
            }
        })
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AuthorizationView()
}
