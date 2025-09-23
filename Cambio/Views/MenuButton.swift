import SwiftUI

struct MenuButton: View {
  let action: () -> Void
  let width: CGFloat
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Image(systemName: "house.fill")
          .font(.system(size: 16, weight: .semibold))
        Text("Menu")
          .font(.system(size: 16, weight: .semibold))
      }
      .foregroundColor(.white)
      .frame(width: width)
      .padding(.horizontal, 32)
      .padding(.vertical, 12)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [.green, .mint]),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(Capsule())
      .shadow(color: .green.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    .scaleEffect(1.0)
    .animation(.easeInOut(duration: 0.1), value: false)
  }
}

#Preview {
  MenuButton(action: {}, width: 160)
} 
