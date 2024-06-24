import SwiftUI
struct test: View {
    @State var currentScale: CGFloat = 1.0
    @State var previousScale: CGFloat = 1.0
    @State var currentOffset = CGSize.zero
    @State var previousOffset = CGSize.zero

    var body: some View {

        ZStack {

            GeometryReader { geometry in // here you'll have size and frame

                Image("subwayMap")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: self.currentOffset.width, y: self.currentOffset.height)
                    .scaleEffect(max(self.currentScale, 1.0)) // the second question
                    .gesture(DragGesture()
                        .onChanged { value in

                            let deltaX = value.translation.width - self.previousOffset.width
                            let deltaY = value.translation.height - self.previousOffset.height
                            self.previousOffset.width = value.translation.width
                            self.previousOffset.height = value.translation.height

                            let newOffsetWidth = self.currentOffset.width + deltaX / self.currentScale
                            // question 1: how to add horizontal constraint (but you need to think about scale)
                            if newOffsetWidth <= geometry.size.width - 150.0 && newOffsetWidth > -150.0 {
                                self.currentOffset.width = self.currentOffset.width + deltaX / self.currentScale
                            }

                            self.currentOffset.height = self.currentOffset.height + deltaY / self.currentScale }

                        .onEnded { value in self.previousOffset = CGSize.zero })

                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            let delta = value / self.previousScale
                            self.previousScale = value
                            self.currentScale = self.currentScale * delta
                    }
                    .onEnded { value in self.previousScale = 1.0 })

            }

            VStack {

                Spacer()

                HStack {
                    Text("Menu 1").padding().cornerRadius(30).background(Color.blue).padding()
                    Spacer()
                    Text("Menu 2").padding().cornerRadius(30).background(Color.blue).padding()
                }
            }
        }
    }
}

#Preview {
    test()
}
