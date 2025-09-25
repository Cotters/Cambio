import SwiftUI

struct TutorialGameView: View {
  
  @Namespace private var cardNamespace
  
  @StateObject var gameEngine: TutorialGameEngine
  let onMenuTapped: () -> Void
  let onRestartTapped: () -> Void
  
  var body: some View {
    VStack(spacing: 12) {
      
//      Spacer()
      
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
      
      if gameEngine.isPlaying && gameEngine.tutorialStep == .cambio {
        CambioButton(action: gameEngine.onCambioTapped)
      }
    }
    .animation(.easeInOut, value: gameEngine.isPlaying)
    .onChange(of: gameEngine.tutorialStep) { oldValue, newValue in
      switch (newValue) {
      case .deal: beginGame()
      case .drawCard: flipAllCards()
      default: break
      }
    }
  }
  
  private func beginGame() {
    Task {
      dealInitialCardsAnimated()
      try? await Task.sleep(for: .milliseconds((300 * gameEngine.handSize)))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(800))
      gameEngine.flipCardOntoPile()
    }
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
  TutorialGameView(
    gameEngine: TutorialGameEngine(),
    onMenuTapped: {},
    onRestartTapped: {},
  )
}
