import SwiftUI

struct GameView: View {
  @Namespace private var dealNS // Any views that share this animate together. Used for Deck -> Hand animation.
  @StateObject private var engine = GameEngine(handSize: 4)

  var body: some View {
    VStack {
      if let hand = engine.hands[.north] {
        PlayerHand(namespace: dealNS, cards: hand) { card in
          withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            engine.onCardSelected(card)
          }
        }
      }
      
      Spacer()
      
      VStack {
        HStack {
          DeckView(namespace: dealNS, deck: engine.deck)
            .frame(height: HAND_CARD_HEIGHT)
            .onTapGesture(perform: dealOneCard)
          DeckView(namespace: dealNS, deck: engine.pile)
            .frame(height: HAND_CARD_HEIGHT)
            .transition(.slide)
            .animation(.easeInOut(duration: 0.4), value: engine.pile)
        }
        .zIndex(200)
        .padding()

        Text("\(engine.deck.count) cards remaining")
          .font(.callout)
      }
      
      Spacer()
      
      if let hand = engine.hands[.south] {
        PlayerHand(namespace: dealNS, cards: hand) { card in
          withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            engine.onCardSelected(card)
          }
        }
      }
    }
    .padding()
    .onAppear {
      Task {
        dealInitialCardsAnimated()
        try? await Task.sleep(for: .milliseconds((50 * 8) * 2)) // Wait for cards to be dealt
        flipAllCards()
        try? await Task.sleep(for: .milliseconds(1500)) // Show cards for 1.5s.
        flipAllCards()
        try? await Task.sleep(for: .milliseconds(500)) // Briefly pause before starting the pile.
        engine.flipCardOntoPile()
      }
    }
    .background(Color.blue.opacity(0.3))
  }
  
  private func dealOneCard() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      engine.drawCardForCurrentPlayer()
    }
  }
  
  
  private func dealInitialCardsAnimated() {
    Task {
      for player in Player.allCases {
        for _ in 0..<engine.handSize {
          try? await Task.sleep(for: .milliseconds(50))
          withAnimation(.spring()) {
            engine.draw(for: player)
          }
        }
      }
    }
  }
  
  private func flipAllCards() {
    Task {
      for player in Player.allCases {
        try? await Task.sleep(for: .milliseconds(0))
        withAnimation(.spring()) {
          engine.flipAllCards(for: player)
        }
      }
    }
  }

}

#Preview {
    GameView()
}
