import SwiftUI

struct GameView: View {
  @StateObject private var engine = GameEngine(handSize: 4)
  private let currentPlayer: Player = .south

  var body: some View {
    VStack {
      if let hand = engine.hands[.north] {
        PlayerHand(cards: hand) { card in
          engine.onCardSelected(card)
        }
      }
      Spacer()
      DeckView(count: engine.deck.count)
        .onTapGesture {
          engine.drawCardsForCurrentPlayer()
        }
      Spacer()
      if let hand = engine.hands[.south] {
        PlayerHand(cards: hand) { card in
          engine.onCardSelected(card)
        }
      }
    }
    .padding()
  }
}

#Preview {
    GameView()
}
