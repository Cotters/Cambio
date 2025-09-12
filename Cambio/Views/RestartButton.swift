import SwiftUI

struct RestartButton: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Image(systemName: "arrow.clockwise")
          .font(.system(size: 16, weight: .semibold))
        Text("Play Again")
          .font(.system(size: 16, weight: .semibold))
      }
      .foregroundColor(.white)
      .padding(.horizontal, 32)
      .padding(.vertical, 12)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [.blue, .purple]),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(Capsule())
      .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    .scaleEffect(1.0)
    .animation(.easeInOut(duration: 0.1), value: false)
  }
}

#Preview {
  RestartButton(action: {})
} 