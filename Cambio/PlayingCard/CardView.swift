import SwiftUI

struct CardView: View {
  let card: Card

  var body: some View {
    if (card.isFaceUp) {
      CardFront(card: card)
    } else {
      CardBack(card: card)
//        .scaledToFit()
//        .frame(height: HAND_CARD_HEIGHT)
//        .cornerRadius(12, antialiased: true)
    }
  }
}

struct CardFront: View {
  let card: Card
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(.white)
        .shadow(radius: 4)
      
      GeometryReader { geo in
        let cSize = geo.size
        let cornerSpacingX = cSize.height * 0.05
        let cornerSpacingY = cSize.height * 0.025
        let rankTextSize = cSize.height * 0.16
        let suitImageSize = cSize.height * 0.14
        
        let rankSuitStack = VStack(spacing: 2) {
          Text(card.rank.rawValue)
            .font(.system(size: rankTextSize, weight: .bold))
          Image(systemName: card.suit.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: suitImageSize)
        }
          .foregroundColor(card.suit.colour())
          .padding(EdgeInsets(top: cornerSpacingY, leading: cornerSpacingX, bottom: 0, trailing: cornerSpacingX))
        
        // Top‑left corner
        rankSuitStack
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        // Bottom‑right corner (rotated 180°)
        rankSuitStack
          .rotationEffect(.degrees(180))
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
      }
    }
    .aspectRatio(2/3, contentMode: .fit)
  }
}
struct CardBack: View {
  let card: Card
  
  var body: some View {
    Image("card_back")
      .resizable()
      .aspectRatio(2/3, contentMode: .fit)
      .cornerRadius(12, antialiased: true)
  }
}


#Preview {
  VStack {
    HStack {
      CardView(card: Card(rank: .seven, suit: .hearts, isFaceUp: false))
        .frame(width: 120)
      CardView(card: Card(rank: .ace, suit: .spades, isFaceUp: true))
        .frame(width: 120)
    }
    .padding()
    HStack(spacing: 10) {
      CardView(card: Card(rank: .ace, suit: .spades, isFaceUp: true))
        .frame(width: 90)
      CardView(card: Card(rank: .seven, suit: .hearts, isFaceUp: false))
        .frame(width: 90)
      CardView(card: Card(rank: .ace, suit: .spades, isFaceUp: false))
        .frame(width: 90)
      CardView(card: Card(rank: .seven, suit: .hearts, isFaceUp: true))
        .frame(width: 90)
    }
    .padding()
    .background(Color.green.opacity(0.75))
  }
}
