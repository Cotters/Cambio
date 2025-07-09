import SwiftUI

struct DeckView: View {
  let namespace: Namespace.ID
  let deck: [Card]

  var body: some View {
    ZStack {
      ForEach(deck, id: \.id) { card in
        FlippableCard(card: card, canFlip: false)
          .matchedGeometryEffect(id: card.id, in: namespace)
//          .zIndex(Double(deck.count))
      }
    }
//    .zIndex(100)
    .accessibilityLabel("\(deck.count) cards left in deck")
  }
}
