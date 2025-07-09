import SwiftUI

struct GameView: View {
  @Namespace private var cardNamespace // Any views that share this animate together. Used for animating cards around.
  @StateObject private var gameEngine = GameEngine(handSize: 4)

  var body: some View {
    VStack {
      PlayerHand(
        namespace: cardNamespace,
        cards: gameEngine.hands[.north] ?? [],
        onCardSelected: gameEngine.onCardSelected
      )
      .animation(.easeInOut, value: gameEngine.hands[.north])
      
      Spacer()
      
      VStack {
        HStack(spacing: 50) {
          AnimatedRealisticDeckView(namespace: cardNamespace, deck: gameEngine.deck)
            .frame(height: HAND_CARD_HEIGHT)
            .onTapGesture(perform: onDeckTapped)

          AnimatedRealisticDeckView(namespace: cardNamespace, deck: gameEngine.pile)
            .frame(height: HAND_CARD_HEIGHT)
            .animation(.easeInOut(duration: 0.4), value: gameEngine.pile)
        }
        .zIndex(200)
        .padding()

        Text("\(gameEngine.deck.count) cards remaining")
          .font(.title3)
        
        Button(action: gameEngine.skipTurn) {
          Text("Skip Turn")
        }
        .padding()
        .foregroundStyle(.white)
        .font(.system(size: 21, weight: .bold, design: .monospaced))
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(.blue.opacity(0.5))
        )
      }
      
      Spacer()
      
      PlayerHand(
        namespace: cardNamespace,
        cards: gameEngine.hands[.south] ?? [],
        onCardSelected: gameEngine.onCardSelected
      )
      .animation(.easeInOut(duration: 0.4), value: gameEngine.hands[.south])
    }
    .padding()
    .frame(width: UIScreen.main.bounds.width)
    .onAppear {
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
    .zIndex(-10)
    .background(Color.blue.opacity(0.3))
  }
  
  private func onDeckTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.drawCardForCurrentPlayer()
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
    GameView()
}
