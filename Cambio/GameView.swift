import SwiftUI

struct DeckView: View {
  let count: Int

  var body: some View {
    VStack {
      ZStack {
        ForEach(0..<min(count, 5), id: \.self) { index in
          Image("card_back")
            .resizable()
            .frame(width: DECK_CARD_WIDTH, height: DECK_CARD_HEIGHT)
            .aspectRatio(2/3, contentMode: .fill)
            .scaledToFit()
            .clipShape(.buttonBorder)
            .shadow(color: .black.opacity(0.2), radius: 4)
            .edgesIgnoringSafeArea(.all)
        }
      }
      .accessibilityLabel("\(count) cards left in deck")
    }
    Text("\(count) cards remaining")
      .font(.callout)
  }
}
struct GameView: View {
  @StateObject private var engine = GameEngine(cardCount: 4)
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

struct PlayerHand: View {
  let cards: [Card]
  let onCardSelected: (Card) -> Void
  private let backgroundColor: Color = .green

  var body: some View {
    HStack {
      ForEach(cards.prefix(cards.count), id: \.self) { card in
        CardView(card: card)
          .onTapGesture {
            onCardSelected(card)
          }
          .frame(height: HAND_CARD_HEIGHT)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding()
//    .padding()
    .frame(maxWidth: .infinity)
//    .frame(height: HAND_CARD_HEIGHT)
    .background(backgroundColor.opacity(0.3))
    .cornerRadius(20)
  }
}

#Preview {
    GameView()
}
