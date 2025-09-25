import SwiftUI

enum MenuNavigation {
  case menu, soloMenu, twoPlayer, soloGame(SoloGameMode)
  case tutorial
}

struct ContentView: View {
  @State var navigation: MenuNavigation = .menu
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  var body: some View {
    switch navigation {
    case .menu:
      MainMenu(
        onSoloTapped: {
          navigation = .soloMenu
        },
        onTwoPlayerTapped: {
          navigation = .twoPlayer
        },
        onHowToPlayTapped: {
          navigation = .tutorial
        },
      )
    case .tutorial:
      TutorialView(
        onTutorialFinished: {
          navigation = .menu
        }
      )
    case .soloMenu:
      SoloPlayerMenu(
        onGameModeSelected: { navigation = .soloGame($0) },
      )
      
    case .soloGame:
      if case let .soloGame(mode) = navigation {
        SoloGameView(
          gameMode: mode,
          onMenuTapped: {
            navigation = .menu
          }
        )
      }
      // TODO: iPad version
      // See https://stackoverflow.com/questions/65810300/change-view-based-on-device-swiftui
      // Using if horizontalSizeClass == .compact
    case .twoPlayer:
      GameView(
//        gameEngine: twoPlayerGameEngine,
        onMenuTapped: {
          navigation = .menu
        }
      )
    }
  }
}


#Preview {
  ContentView()
}
