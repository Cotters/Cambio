import SwiftUI

struct GameBackground: View {
  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: [
        Color(.systemBackground),
        Color.green.opacity(0.2),
        Color.blue.opacity(0.25)
      ]),
      startPoint: .top,
      endPoint: .bottom
    )
    .ignoresSafeArea()
  }
}


#Preview {
  GameBackground()
}
