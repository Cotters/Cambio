import SwiftUI

struct PlayerHand: View {
  let namespace: Namespace.ID
  let cards: [Card]
//  let animatingCard: Card?
  let onCardSelected: (Card) -> Void
  private let backgroundColor: Color = .green

  var body: some View {
    HStack {
      ForEach(cards.prefix(cards.count), id: \.id) { card in
        FlippableCard(card: card)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            onCardSelected(card)
          }
          .frame(height: HAND_CARD_HEIGHT)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding()
    .frame(maxWidth: (CGFloat(((HAND_SIZE * 2) + 1)) * HAND_CARD_HEIGHT) / 3)
    .background(backgroundColor.opacity(0.4))
    .cornerRadius(20, antialiased: false)
    .zIndex(-5)
  }
}



#Preview {
  @Previewable @Namespace var namespace
  let deck = Card.fullDeck
  var faceUpDeck: [Card] {
    deck.forEach { $0.flip() }
    return deck
  }
  VStack {
    PlayerHand(
      namespace: namespace,
      cards: Array(deck.suffix(2)),
      onCardSelected: { _ in },
    )
    PlayerHand(
      namespace: namespace,
      cards: Array(faceUpDeck.prefix(4)),
      onCardSelected: { _ in },
    )
  }
  .padding()
  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  .background(Color.blue.opacity(0.3))
}
