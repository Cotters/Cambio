import SwiftUI

struct DeckView: View {
  let namespace: Namespace.ID
  let deck: [Card]

  var body: some View {
    ZStack {
      ForEach(Array(deck.enumerated()), id: \.element.id) { index, card in
        FlippableCard(card: card, canFlip: false)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .frame(height: HAND_CARD_HEIGHT)
          .zIndex(Double(index))
      }
    }
//    .zIndex(100)
    .accessibilityLabel("\(deck.count) cards left in deck")
  }
}
