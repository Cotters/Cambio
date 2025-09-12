import SwiftUI

struct PlayerHand: View {
  let namespace: Namespace.ID
  let cards: [Card]
  let onCardSelected: (Card) -> Void
  let isOpponent: Bool
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(cards.prefix(cards.count), id: \.id) { card in
        FlippableCard(card: card)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            onCardSelected(card)
          }
          .frame(height: HAND_CARD_HEIGHT)
          .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(isOpponent ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(isOpponent ? Color.red.opacity(0.2) : Color.blue.opacity(0.2), lineWidth: 1)
        )
    )
  }
}


#Preview {
  @Previewable @Namespace var namespace
  let deck = Deck.standardWithJokers
  var faceUpDeck: [Card] {
    deck.forEach { $0.flip() }
    return deck
  }
  VStack {
    PlayerHand(
      namespace: namespace,
      cards: Array(deck.suffix(2)),
      onCardSelected: { $0.flip() },
      isOpponent: true
    )
    PlayerHand(
      namespace: namespace,
      cards: Array(faceUpDeck.shuffled().prefix(4)),
      onCardSelected: { $0.flip() },
      isOpponent: false
    )
  }
  .padding()
  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  .background(Color.blue.opacity(0.3))
}
