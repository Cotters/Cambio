import SwiftUI
import Sticker

struct FlippableCard: View {
  @ObservedObject var card: Card
  let canFlip: Bool
  
  init(card: Card, canFlip: Bool = true) {
    self.card = card
    self.canFlip = canFlip
  }
  
  var body: some View {
    ZStack {
      CardFront(card: card)
        .stickerEffect(card.isHolographic)
        .stickerMotionEffect(.rotationEffect)
        .opacity(card.isFaceUp ? 1 : 0)
      
      // Pre-rotated so it reads correctly after the outer spin.
      CardBack()
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .opacity(card.isFaceUp ? 0 : 1)
    }
    // Outer rotation: 0° when face-up, 180° when face-down.
    .rotation3DEffect(.degrees(card.isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
    .animation(.easeInOut, value: card.isFaceUp)
  }
}

struct RotationMotionEffect: StickerMotionEffect {
  let startDate: Date = .init()
  
  func body(content: Content) -> some View {
    // This applies a sine wave rotation to the content.
    TimelineView(.animation) { context in
      let elapsedTime = context.date.timeIntervalSince(startDate)
      let rotation = sin(elapsedTime * 2) * 5
      content
        .rotationEffect(.degrees(rotation))
    }
  }
}

extension StickerMotionEffect where Self == RotationMotionEffect {
  static var rotationEffect: Self { .init() }
}

#Preview {
  let card = Card(rank: .ace, suit: .spades, isFaceUp: true)
  let card2 = Card(rank: .jack, suit: .spades)
  let card3 = Card(rank: .king, suit: .hearts, isFaceUp: true)
  VStack(spacing: 20) {
    FlippableCard(card: card)
      .frame(height: 180)
      .onTapGesture {
        card.flip()
      }
    FlippableCard(card: card2)
      .frame(height: 180)
      .onTapGesture {
        card2.flip()
      }
    FlippableCard(card: card3)
      .frame(height: 180)
      .onTapGesture {
        card3.flip()
      }
  }
}
