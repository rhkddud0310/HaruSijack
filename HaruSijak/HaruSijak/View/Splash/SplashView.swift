
// MARK: -- Description
/*
    Description : HaruSijack App splash 화면
    Date : 2024.6.14
    Author : j.park
    Dtail :
    Updates :
        * 2024.06.14 by j.park : 1.splash화면 생성
                                 2. Lotti 적용
    
 */

//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        VStack {
            Spacer()
            Text("HaruSijack")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding()
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        //메인화면으로 이동
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
}

#Preview {
    SplashView()
}
