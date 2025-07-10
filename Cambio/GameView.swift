import SwiftUI

struct GameView: View {
  @Namespace private var cardNamespace // Any views that share this animate together. Used for animating cards around.
  @StateObject var gameEngine: GameEngine

  var body: some View {
    VStack {
      VStack {
        PlayerHand(
          namespace: cardNamespace,
          cards: gameEngine.hands[.north] ?? [],
          onCardSelected: gameEngine.onCardSelected
        )
        .animation(.easeInOut, value: gameEngine.hands[.north])
        
        if (gameEngine.currentPlayer == .north) {
          if let card = gameEngine.viewingCard {
            FlippableCard(card: card, canFlip: false)
              .matchedGeometryEffect(id: card.id, in: cardNamespace)
              .frame(height: HAND_CARD_HEIGHT)
              .animation(.easeInOut(duration: 0.4), value: card)
          }
        }
      }
      
      Spacer()
      
      if (gameEngine.isPlaying) {
        VStack {
          HStack(spacing: 50) {
            AnimatedRealisticDeckView(namespace: cardNamespace, deck: gameEngine.deck)
              .frame(height: HAND_CARD_HEIGHT)
              .onTapGesture(perform: onDeckTapped)
            
            AnimatedRealisticDeckView(namespace: cardNamespace, deck: gameEngine.pile)
              .frame(height: HAND_CARD_HEIGHT)
              .animation(.easeInOut(duration: 0.4), value: gameEngine.pile)
              .onTapGesture(perform: onPileTapped)
          }
          .zIndex(200)
          .padding()
          
          Text("\(gameEngine.deck.count) cards remaining")
            .font(.title3)
            .fontDesign(.monospaced)
          
          Button(action: gameEngine.onCambioTapped) {
            Text("Cambio!")
              .font(.system(size: 16, weight: .semibold))
          }
          .foregroundColor(.white)
          .padding(.horizontal, 32)
          .padding(.vertical, 12)
          .background(
              LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .green.opacity(0.4)]),
                  startPoint: .leading,
                  endPoint: .trailing
              )
          )
          .clipShape(Capsule())
          .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }
      } else {
        GameOverView(
          northScore: gameEngine.hands[.north]?.getScore() ?? 0,
          southScore: gameEngine.hands[.south]?.getScore() ?? 0,
          onRestartTapped: onRestartTapped
        )
        .animation(.easeIn, value: gameEngine.gameState)
      }
      
      Spacer()
      
      VStack {
        if let card = gameEngine.viewingCard, gameEngine.currentPlayer == .south {
          FlippableCard(card: card, canFlip: false)
            .matchedGeometryEffect(id: card.id, in: cardNamespace)
            .frame(height: HAND_CARD_HEIGHT)
            .animation(.easeInOut(duration: 0.4), value: card)
        }
        
        PlayerHand(
          namespace: cardNamespace,
          cards: gameEngine.hands[.south] ?? [],
          onCardSelected: onPlayerCardTapped
        )
        .animation(.easeInOut(duration: 0.4), value: gameEngine.hands[.south])
      }
    }
    .padding()
    .frame(width: UIScreen.main.bounds.width)
    .onAppear { beginGame() }
    .zIndex(-10)
    .background(Color.blue.opacity(0.3))
  }
  
  private func beginGame() {
    Task {
      dealInitialCardsAnimated()
      try? await Task.sleep(for: .milliseconds((150 * 8) * 2)) // Wait for cards to be dealt
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(1500)) // Show cards for 1.5s.
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(800)) // Briefly pause before starting the pile.
      gameEngine.flipCardOntoPile()
    }
  }
  
  private func onRestartTapped() {
    gameEngine.restartGame()
    beginGame()
  }
  
  private func onPlayerCardTapped(_ card: Card) {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onCardSelected(card)
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
      for player in Player.allCases {
        for _ in 0..<gameEngine.handSize {
          try? await Task.sleep(for: .milliseconds(150))
          withAnimation(.spring()) {
            gameEngine.draw(for: player)
          }
        }
      }
    }
  }
  
  private func flipAllCards() {
    for player in Player.allCases {
      withAnimation(.spring()) {
        gameEngine.flipAllCards(for: player)
      }
    }
  }

}

#Preview {
  let engine = GameEngine(handSize: 4)
  GameView(gameEngine: engine)
}
