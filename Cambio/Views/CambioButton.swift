import SwiftUI

struct CambioButton: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 12) {
        Image(systemName: "star.fill")
          .font(.system(size: 18, weight: .bold))
        Text("Call Cambio!")
          .font(.system(size: 18, weight: .bold, design: .rounded))
      }
      .foregroundColor(.white)
      .padding(.horizontal, 32)
      .padding(.vertical, 14)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [.orange, .red]),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(Capsule())
      .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)
    }
  }
}

#Preview {
  CambioButton(action: {})
} 