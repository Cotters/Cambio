import SwiftUI

struct FlippableCard: View {
  @ObservedObject var card: Card
  let canFlip: Bool
  
  init(card: Card, canFlip: Bool = true) {
    self.card = card
    self.canFlip = canFlip
  }
  
  var body: some View {
    ZStack {
      if (card.isFaceUp) { // TODO: Trying to fix opacity issue (when moving card)
        CardFront(card: card )
      }
//        .opacity(card.isFaceUp ? 1 : 0)
      
      // Pre-rotated so it reads correctly after the outer spin.
      if (!card.isFaceUp) {
        CardBack(card: card)
          .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
      }
//        .opacity(card.isFaceUp ? 0 : 1)
    }
    // Outer rotation: 0° when face-up, 180° when face-down.
    .rotation3DEffect(.degrees(card.isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
    .animation(.easeInOut, value: card.isFaceUp)
//    .animation(.easeInOut(duration: 0.4), value: card.isFaceUp)
  }
}

#Preview {
  let card = Card(rank: .ace, suit: .spades)
  FlippableCard(card: card)
    .frame(height: 180)
    .onTapGesture {
      card.flip()
    }
}
