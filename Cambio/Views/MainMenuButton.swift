import SwiftUI

struct MainMenuButton: View {
  let icon: String
  let text: String
  let gradientColors: [Color]
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 12) {
        Image(systemName: icon)
          .font(.system(size: 18, weight: .bold))
        Text(text)
          .font(.system(size: 18, weight: .bold, design: .rounded))
      }
      .foregroundColor(.white)
      .frame(width: 160)
      .padding(.horizontal, 32)
      .padding(.vertical, 16)
      .background(
        LinearGradient(
          gradient: Gradient(colors: gradientColors),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(Capsule())
      .shadow(color: gradientColors.first?.opacity(0.3) ?? .clear, radius: 6, x: 0, y: 3)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    MainMenuButton(
      icon: "person.fill",
      text: "Solo",
      gradientColors: [.green, .mint],
      action: {}
    )
    MainMenuButton(
      icon: "person.2.fill",
      text: "Two Player",
      gradientColors: [.red, .orange],
      action: {}
    )
    MainMenuButton(
      icon: "book.fill",
      text: "The Rules",
      gradientColors: [.cyan, .blue],
      action: {}
    )
  }
} 
