import SwiftUI

let amber: Color = .init(red: 1, green: 0.84, blue: 0.4)

struct SoloPlayerMenu: View {
  
  let onGameModeSelected: (SoloGameMode) -> Void
  
  var body: some View {
    ZStack {
      GameBackground()
      
      VStack(spacing: 20) {
        Text("Single Player Modes")
          .font(.title)
        
        MainMenuButton(
          icon: "",
          text: "30s Rush",
          gradientColors: [.pink, .orange],
          action: { onGameModeSelected(.rush) },
        )
        
        MainMenuButton(
          icon: "",
          text: "60s Dash",
          gradientColors: [.orange, amber],
          action: { onGameModeSelected(.dash) },
        )
        
        MainMenuButton(
          icon: "",
          text: "120s Run",
          gradientColors: [.green, .mint],
          action: { onGameModeSelected(.run) },
        )
        
        MainMenuButton(
          icon: "",
          text: "Untimed",
          gradientColors: [.blue, .cyan],
          action: { onGameModeSelected(.untimed) },
        )
      }
    }
  }
}

#Preview {
  SoloPlayerMenu(
    onGameModeSelected: { _ in },
  )
}
