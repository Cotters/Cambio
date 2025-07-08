import SwiftUI

struct FlippableCard: View {
  let card: Card
  let canFlip: Bool
  let beginsFaceUp: Bool
  
  @State private var isFaceUp: Bool
  
  init(card: Card, canFlip: Bool = true, beginsFaceUp: Bool = false) {
    self.card = card
    self.canFlip = canFlip
    self.beginsFaceUp = beginsFaceUp
    self.isFaceUp = beginsFaceUp
  }
  
  var body: some View {
    ZStack {
      // Front
      CardFront(card: card)
        .opacity(isFaceUp ? 1 : 0)
      
      // Back (pre-rotated so it reads correctly after the outer spin)
      CardBack(card: card)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .opacity(isFaceUp ? 0 : 1)
    }
    // Outer rotation: 0° when face-up, 180° when face-down
    .rotation3DEffect(.degrees(isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
    .animation(.easeInOut(duration: 0.4), value: isFaceUp)
    .onTapGesture { if (canFlip) { isFaceUp.toggle() } }
  }
}

#Preview {
  FlippableCard(card: Card(rank: .ace, suit: .spades), beginsFaceUp: false)
    .frame(height: 180)
}
