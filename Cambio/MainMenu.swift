import SwiftUI

struct MainMenu : View {
  @State private var isPresentingRules = false

  let onStartTapped: () -> Void
    
  var body: some View {
    VStack(spacing: 36) {
      VStack(spacing: 0) {
        Text("♠ CAMBIO ♣")
          .font(.system(size: 36, weight: .black, design: .rounded))
          .foregroundStyle(
            LinearGradient(
              gradient: Gradient(colors: [.blue, .purple]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
        
        Text("The Card Game")
          .font(.system(size: 20, weight: .medium, design: .rounded))
          .foregroundColor(.secondary)
          .tracking(2)
      }
      .padding(.top, 20)
      
      VStack(spacing: 16) {
        Button(action: onStartTapped) {
          HStack(spacing: 12) {
            Image(systemName: "play.fill")
              .font(.system(size: 18, weight: .bold))
            Text("Play")
              .font(.system(size: 18, weight: .bold, design: .rounded))
          }
          .foregroundColor(.white)
          .frame(width: 140)
          .padding(.horizontal, 32)
          .padding(.vertical, 16)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [.green, .mint]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .clipShape(Capsule())
          .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        Button(action: { isPresentingRules.toggle() }) {
          HStack(spacing: 12) {
            Image(systemName: "book.fill")
              .font(.system(size: 18, weight: .bold))
            Text("The Rules")
              .font(.system(size: 18, weight: .bold, design: .rounded))
          }
          .foregroundColor(.white)
          .frame(width: 140)
          .padding(.horizontal, 32)
          .padding(.vertical, 16)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [.cyan, .blue]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .clipShape(Capsule())
          .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        
      }
    }
    .sheet(isPresented: $isPresentingRules) {
      RulesView()
    }
  }
}

#Preview {
  MainMenu(
    onStartTapped: {},
  )
}
