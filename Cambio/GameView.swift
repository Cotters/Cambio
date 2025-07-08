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
        DeckView(namespace: dealNS, deck: engine.deck, onTap: dealOneCard)

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
    .onAppear { dealInitialCardsAnimated() }
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

}

#Preview {
    GameView()
}
