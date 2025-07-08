import SwiftUI

enum Suit: String, CaseIterable {
  case spades = "suit.spade.fill"
  case hearts = "suit.heart.fill"
  case diamonds = "suit.diamond.fill"
  case clubs = "suit.club.fill"
  
  func colour() -> Color {
    self == .spades || self == .clubs ? .black : .red
  }
}

enum Rank: String, CaseIterable {
  case two = "2"
  case three = "3"
  case four = "4"
  case five = "5"
  case six = "6"
  case seven = "7"
  case eight = "8"
  case nine = "9"
  case ten = "10"
  case jack = "J"
  case queen = "Q"
  case king = "K"
  case ace = "A"
}

struct CardView: View {
  let rank: Rank
  let suit: Suit

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
          Text(rank.rawValue)
            .font(.system(size: rankTextSize, weight: .bold))
          Image(systemName: suit.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: suitImageSize)
        }
          .foregroundColor(suit.colour())
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
    CardView(rank: Rank.ace, suit: .spades)
      .frame(width: 90)
    CardView(rank: .ten, suit: .hearts)
      .frame(width: 180)
  }
  .padding()
  .background(Color.green.opacity(0.75))
}
