import SwiftUI

enum GameMode {
  case menu, solo, twoPlayer
}

struct ContentView: View {
  @State var gameMode: GameMode = .menu
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @StateObject private var soloGameEngine = SoloGameEngine(handSize: 8)
  @StateObject private var twoPlayerGameEngine = BaseGameEngine(handSize: 4)
  
  var body: some View {
    switch gameMode {
    case .menu:
      MainMenu(
        onSoloTapped: {
          gameMode = .solo
          soloGameEngine.restartGame()
        },
        onTwoPlayerTapped: {
          gameMode = .twoPlayer
          twoPlayerGameEngine.restartGame()
        },
      )
    case .solo:
      if horizontalSizeClass == .compact {
        SoloGameView(
          gameEngine: soloGameEngine,
          onMenuTapped: {
            gameMode = .menu
          }
        )
      } else {
        // TODO: iPad version
        // See https://stackoverflow.com/questions/65810300/change-view-based-on-device-swiftui
        SoloGameView(
          gameEngine: soloGameEngine,
          onMenuTapped: {
            gameMode = .menu
          }
        )
      }
    case .twoPlayer:
      GameView(
        gameEngine: twoPlayerGameEngine,
        onMenuTapped: {
          gameMode = .menu
        }
      )
    }
  }
}


#Preview {
  ContentView()
}
