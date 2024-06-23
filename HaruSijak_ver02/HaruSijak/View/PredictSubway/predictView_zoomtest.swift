/*
 Description: 지하철 페이지 줌 테스트
 */

import SwiftUI
import Zoomable
import Charts

struct PredictView_zoomtest: View {
    
    @State private var dragAmount = CGSize.zero
    @State var stationName: String = ""
    @State var stationLine: String = "7"
    var bgColor: Color = Color.red
    @FocusState var isTextFieldFocused: Bool
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    //pinchzoom
    @GestureState private var magnifyBy = 1.0
    @State private var scale: CGFloat = 1.0
    
    var magnification: some Gesture {
      MagnifyGesture()
        .updating($magnifyBy) { value, gestureState, transaction in
          gestureState = value.magnification
        }
    }
    
    // 역과 버튼 위치 정보
    let stations = [
        ("장암", 80.0, 163.0),
        ("도봉산", 135.0, 164.0),
        ("수락산", 189.0, 161.0),
        ("마들", 245.0, 164.0),
        ("노원", 298.0, 162.0),
        ("중계", 351.0, 161.0),
        ("하계", 407.0, 162.0),
        ("공릉", 462.0, 161.0),
        ("태릉입구", 513.0, 158.0),
        ("먹골", 567.0, 162.0),
        ("중화", 623.0, 162.0),
        ("상봉", 674.0, 161.0),
        ("면목", 730.0, 161.0),
        ("사가정", 710.0, 300.0),
        ("용마산", 645.0, 301.0),
        ("중곡", 581.0, 300.0),
        ("군자", 514.0, 299.0),
        ("어린이대공원", 451.0, 298.0),
        ("건대입구", 385.0, 299.0),
        ("뚝섬유원지", 319.0, 300.0),
        ("청담", 257.0, 300.0),
        ("강남구청", 187.0, 300.0),
        ("학동", 124.0, 300.0),
        ("논현", 61.0, 298.0),
        ("반포", 63.0, 450.0),
        ("고속터미널", 129.0, 452.0),
        ("내방", 194.0, 454.0),
        ("이수", 257.0, 452.0),
        ("남성", 324.0, 451.0),
        ("숭실대입구", 387.0, 454.0),
        ("상도", 453.0, 453.0),
        ("장승배기", 519.0, 452.0),
        ("신대방삼거리", 585.0, 452.0),
        ("보라매", 648.0, 450.0),
        ("신풍", 714.0, 453.0),
        ("대림", 712.0, 614.0),
        ("남구로", 648.0, 612.0),
        ("가산디지털단지", 580.0, 613.0),
        ("철산", 518.0, 613.0),
        ("광명사거리", 451.0, 611.0),
        ("천왕", 388.0, 611.0),
        ("온수", 322.0, 612.0)
    ]
    // 줌 기능 사용을 위한 struct
    struct ZoomableView<Content: View>: View {
        let content: Content
        @State private var scale: CGFloat
        let minScale: CGFloat
        let maxScale: CGFloat
        
        init(initialScale: CGFloat = 1.0, minScale: CGFloat = 1.0, maxScale: CGFloat = 3.0, @ViewBuilder content: () -> Content) {
            self.minScale = minScale
            self.maxScale = maxScale
            self._scale = State(initialValue: initialScale)
            self.content = content()
        }
        
        var body: some View {
            content
                .scaleEffect(scale)
                .gesture(MagnificationGesture()
                    .onChanged { value in
                        let delta = value / self.scale
                        self.scale = min(max(self.scale * delta, self.minScale), self.maxScale)
                    }
                )
        }
    }
    
    var body: some View {
        VStack {
            Text("지하철 승하차인원 예측")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            ZStack {
                // 스크롤뷰 [노선도 사진]
                ZoomableView(initialScale: 2.0, minScale: 1.0, maxScale: 5.0) {
                    ScrollView([.horizontal, .vertical], showsIndicators: false) {
                        Image("Line7")
                            .resizable()
                            .frame(width: CGFloat(800), height: CGFloat(800))
                            .overlay(GeometryReader { geometry in
                                ForEach(stations, id: \.0) { station in
                                    Button(action: {
                                        print("버튼 눌ㄴ림")
                                    }) {
                                        Text("")
                                            .frame(width: 20, height: 20)
                                            .background(Color.red)
                                    }
                                    .position(x: CGFloat(station.1), y: CGFloat(station.2))
                                }
                            })
                        
                    }
                }
                .allowsHitTesting(true) // ScrollView가 터치 이벤트를 받도록 설정
                .zoomable(
                    minZoomScale: 10,        // Default value: 1
                    doubleTapZoomScale: 5,    // Default value: 3
                    outOfBoundsColor: .black
                )
                
                
                
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    PredictView_zoomtest()
}
