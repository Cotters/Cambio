import SwiftUI

struct CardView: View {
  let card: Card

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(.white)
        .shadow(radius: 4)

      GeometryReader { geo in
        let cSize = geo.size
        let cornerSpacing = cSize.height * 0.05
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
          .padding(cornerSpacing)

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

#Preview {
  VStack(spacing: 20) {
    CardView(card: Card(rank: .ace, suit: .spades))
      .frame(width: 90)
      .onTapGesture {
        print("Ace of Spades!")
      }
    CardView(card: Card(rank: .ten, suit: .hearts))
      .frame(width: 180)
  }
  .padding()
  .background(Color.green.opacity(0.75))
}
