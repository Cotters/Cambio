import SwiftUI

enum SoloGameMode: TimeInterval {
  case rush = 30, dash = 60, run = 120 // TODO: rush to 30s
}

struct SoloGameView: View {
  
  @Namespace private var cardNamespace
  
  @StateObject var gameEngine: SoloGameEngine
  let gameMode: SoloGameMode
  let onMenuTapped: () -> Void
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        GameBackground()
        
        VStack(spacing: 12) {
          
          Spacer()
          
          if (gameEngine.isPlaying) {
            Text("Time Left: \(String(format: "%.1f", gameEngine.timeLeft))s")
              .font(.system(size: 22, weight: .bold, design: .monospaced))
              .foregroundStyle(gameEngine.timeLeft < 10 ? .orange : .black)
          }
          
          Spacer()
          
          // Center Game Area
          if gameEngine.gameState == .gameOver {
            SoloGameOverView(
              playerScore: gameEngine.getSouthScore(),
              penaltyPoints: gameEngine.getSouthPenaltyPoints(),
              onRestartTapped: onRestartTapped,
              onMenuTapped: onMenuTapped,
            )
            .transition(.scale.combined(with: .opacity))
            .animation(.easeInOut, value: gameEngine.gameState)
          } else {
            SoloGameCenterArea(
              namespace: cardNamespace,
              gameEngine: gameEngine,
              onDeckTapped: onDeckTapped,
              onPileTapped: onPileTapped,
            )
            .padding(.horizontal, 16)
          }
          
          // Player Section (Single Player)
          VStack(spacing: 8) {
            ZStack {
              SoloPlayerHand(
                namespace: cardNamespace,
                cards: gameEngine.hand,
                onCardSelected: onPlayerCardTapped
              )
              .animation(.easeInOut(duration: 0.4), value: gameEngine.hand)
              
              if let card = gameEngine.viewingCard {
                VStack {
                  Spacer()
                  ViewingCardDisplay(card: card, namespace: cardNamespace)
                }
              }
            }
            .frame(height: HAND_CARD_HEIGHT * 2 + 48) // Height for 2 rows + spacing + extra padding
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.secondarySystemBackground).opacity(0.8))
              .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
          )
          .padding(.horizontal, 16)
          .padding(.bottom, 16) // Add bottom padding for visibility
          
          if gameEngine.isPlaying {
            CambioButton(action: gameEngine.onCambioTapped)
          } else {
            CambioButton(action: gameEngine.onCambioTapped)
              .hidden()
          }
        }
      }
    }
    .onAppear(perform: beginGame)
  }
  
  private func beginGame() {
    Task {
      dealInitialCardsAnimated()
      try? await Task.sleep(for: .milliseconds((300 * gameEngine.handSize)))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(3000))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(800))
      gameEngine.flipCardOntoPile()
      
      try? await Task.sleep(for: .milliseconds(500))
      gameEngine.beginPlaying(gameMode: gameMode)
    }
  }
  
  private func onRestartTapped() {
    gameEngine.restartGame()
    beginGame()
  }
  
  private func onPlayerCardTapped(_ card: Card) {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onCardInHandTapped(card, for: .south)
    }
  }
  
  private func onDeckTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onDeckTapped()
    }
  }
  
  private func onPileTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onPileTapped()
    }
  }
  
  private func dealInitialCardsAnimated() {
    Task {
      for _ in 0..<gameEngine.handSize {
        try? await Task.sleep(for: .milliseconds(150))
        withAnimation(.spring()) {
          gameEngine.draw()
        }
      }
    }
  }
  
  private func flipAllCards() {
    withAnimation(.spring()) {
      gameEngine.flipAllCards()
    }
  }
}

#Preview {
  let engine = {
    let engine = SoloGameEngine()
    engine.restartGame()
    return engine
  }()
  SoloGameView(gameEngine: engine, gameMode: .dash, onMenuTapped: {})
}
