//
//  CampfireEmptyLog.swift
//  Modak
//
//  Created by Park Junwoo on 11/7/24.
//

import SwiftUI

struct CampfireEmptyLog: View {
    @EnvironmentObject private var logPileViewModel: LogPileViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("추억 장작이 필요해요")
                .foregroundStyle(.textColorGray1)
                .font(Font.custom("Pretendard-Bold", size: 20))
                .padding(.bottom, 8)
            
            Text("\(campfireViewModel.mainCampfireInfo?.campfireName ?? "") 모닥불에 추억 장작을 넣어\n오늘의 사진을 확인해보세요")
                .foregroundStyle(.textColorGray2)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .padding(.bottom, 22)
                .lineSpacing(16 * 0.5)
                .multilineTextAlignment(.center)
            
            NavigationLink {
                SelectMergeLogsView()
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    
                    AddCampfireLogImage()
                    
                    // TODO: 임시로 인터넷 연결 없거나 내 개인장작이 없는 경우 글자색 바꿔서 버튼 누를 수 없다는 것을 보여주도록 했음
                    Text("모닥불에 장작 넣기")
                        .foregroundStyle(!networkMonitor.isConnected || logPileViewModel.yearlyLogs.isEmpty ? .gray : .white)
                        .font(Font.custom("Pretendard-Bold", size: 16))
                    
                    Spacer()
                }
                .padding(.vertical, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.init(hex: "4C4545"))
                    .stroke(Color.disable, lineWidth: 1)
            }
            .padding(.horizontal, 70)
            .disabled(!networkMonitor.isConnected || logPileViewModel.yearlyLogs.isEmpty)
            .simultaneousGesture(TapGesture().onEnded {
                if !networkMonitor.isConnected {
                    campfireViewModel.showTemporaryNetworkAlert()
                } else if logPileViewModel.yearlyLogs.isEmpty {
                    campfireViewModel.showEmptyLogPileAlert()
                }
            })
            .overlay {
                if campfireViewModel.showEmptyLogAlert {
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                            Text("개인 장작을 먼저 채워주세요!")
                        }
                        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                        .background(Color.errorRed)
                        .foregroundColor(Color.white)
                        .cornerRadius(14)
                        
                        Text("*개인 장작은 장작 창고 탭에서 채울 수 있어요.")
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    .font(Font.custom("Pretendard-Regular", size: 14))
                    .padding(.top, 200)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            Spacer()
        }
    }
}
