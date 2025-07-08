import SwiftUI

struct DeckView: View {
  let namespace: Namespace.ID
  let deck: [Card]
  let onTap: () -> Void
  
  @State private var scale: CGFloat = 1.0

  var body: some View {
    ZStack {
      ForEach(deck, id: \.id) { card in
        Image("card_back")
          .resizable()
          .frame(width: DECK_CARD_WIDTH, height: DECK_CARD_HEIGHT)
          .aspectRatio(2/3, contentMode: .fill)
          .scaledToFit()
          .cornerRadius(12, antialiased: true)
          .shadow(color: .green.opacity(0.5), radius: 0.45)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .zIndex(Double(deck.count))
          .onTapGesture(perform: onTap)
      }
    }
    .accessibilityLabel("\(deck.count) cards left in deck")
  }
}
