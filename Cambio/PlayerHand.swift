import SwiftUI

struct PlayerHand: View {
  let namespace: Namespace.ID

  let cards: [Card]
  let onCardSelected: (Card) -> Void
  private let backgroundColor: Color = .green

  var body: some View {
    HStack {
      ForEach(cards.prefix(cards.count), id: \.id) { card in
        FlippableCard(card: card)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .onTapGesture { onCardSelected(card) }
          .frame(height: HAND_CARD_HEIGHT)
      }
    }
//    .frame(height: HAND_CARD_HEIGHT)
    .padding()
    .frame(maxWidth: (CGFloat(((HAND_SIZE * 2) + 1)) * HAND_CARD_HEIGHT) / 3)
    .background(backgroundColor.opacity(0.4))
    .cornerRadius(20)
  }
}


#Preview {
  @Previewable @Namespace var namespace
  VStack {
    PlayerHand(
      namespace: namespace,
      cards: Array(Card.fullDeck.suffix(2)),
      onCardSelected: { _ in},
    )
    PlayerHand(
      namespace: namespace,
      cards: Array(Card.fullDeck.suffix(4)),
      onCardSelected: { _ in},
    )
  }
  .padding()
  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  .background(Color.blue.opacity(0.3))
}
