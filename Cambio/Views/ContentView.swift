import SwiftUI

enum GameMode {
  case menu, soloMenu, twoPlayer, soloGame(SoloGameMode)
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
          gameMode = .soloMenu
          soloGameEngine.restartGame()
        },
        onTwoPlayerTapped: {
          gameMode = .twoPlayer
          twoPlayerGameEngine.restartGame()
        },
      )
    case .soloMenu:
      SoloPlayerMenu(
        onGameModeSelected: { gameMode = .soloGame($0) },
      )
      
    case .soloGame:
      if case let .soloGame(mode) = gameMode {
        SoloGameView(
          gameEngine: soloGameEngine,
          gameMode: mode,
          onMenuTapped: {
            gameMode = .menu
          }
        )
      }
      // TODO: iPad version
      // See https://stackoverflow.com/questions/65810300/change-view-based-on-device-swiftui
      // Using if horizontalSizeClass == .compact
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
