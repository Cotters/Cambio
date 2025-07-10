import SwiftUI

let cardCornerRadius: CGFloat = 12

struct CardFront: View {
  let card: Card
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
        .fill(.white)
        .stroke(Color.gray, lineWidth: 0.2)
      
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
          .padding(
            EdgeInsets(
              top: cornerSpacingY,
              leading: cornerSpacingX,
              bottom: 0,
              trailing: cornerSpacingX
            )
          )
        
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
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [
              Color.indigo,
              Color.mint
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .overlay(
          Canvas { context, size in
            let width = size.width
            let height = size.height
            
            // Diagonal line pattern
            for x in stride(from: -20, to: width + 20, by: 10) {
              for y in stride(from: -20, to: height + 20, by: 10) {
                let path = Path { p in
                  p.move(to: CGPoint(x: x, y: y))
                  p.addLine(to: CGPoint(x: x + 8, y: y + 8))
                }
                
                context.stroke(
                  path,
                  with: .color(.white.opacity(0.15)),
                  lineWidth: 1
                )
              }
            }
          }
        )
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
      
      // Centered joker symbol
      Text("🃟")
        .font(.system(size: 90))
        .foregroundStyle(Color.white.opacity(0.8))
        .padding(.bottom, 15)
    }
    .aspectRatio(2/3, contentMode: .fit)
  }
}

#Preview {
  VStack {
    HStack {
      CardFront(card: Card(rank: .seven, suit: .hearts, isFaceUp: false))
        .frame(width: 120)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
      CardBack()
        .frame(width: 120)
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
    .padding()
    HStack(spacing: 10) {
      CardFront(card: Card(rank: .ace, suit: .spades, isFaceUp: true))
        .frame(width: 90)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
      CardBack()
        .frame(width: 90)
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
      CardFront(card: Card(rank: .ace, suit: .spades, isFaceUp: false))
        .frame(width: 90)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
      CardBack()
        .frame(width: 90)
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
    .padding()
    .background(Color.green.opacity(0.6))
  }
}
