import SwiftUI

struct ContentView: View {
  
  @StateObject private var gameEngine = GameEngine(handSize: 4)
  
  var body: some View {
    switch gameEngine.gameState {
    case .start:
      MainMenu(onStartTapped: gameEngine.restartGame)
    default:
      GameView(gameEngine: gameEngine)
    }
  }
}


#Preview {
  ContentView()
}
