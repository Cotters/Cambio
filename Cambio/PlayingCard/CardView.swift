import SwiftUI

// MARK: - Design Constants
struct CardDesign {
  static let cornerRadius: CGFloat = 16
  static let shadowRadius: CGFloat = 6
  static let shadowOpacity: Double = 0.15
  static let borderWidth: CGFloat = 0.5
  static let aspectRatio: CGFloat = 2/3
  
  // Sizing ratios relative to card height
  static let cornerSpacingXRatio: CGFloat = 0.06
  static let cornerSpacingYRatio: CGFloat = 0.04
  static let rankTextSizeRatio: CGFloat = 0.18
  static let suitImageSizeRatio: CGFloat = 0.13
  static let jokerImageSizeRatio: CGFloat = 4.5
}

// MARK: - Reusable Components
struct RankView: View {
  let rank: Rank
  let size: CGFloat
  let color: Color
  
  var body: some View {
    Text(rank.displayText)
      .font(.system(size: size, weight: .bold, design: .default))
      .foregroundColor(color)
      .minimumScaleFactor(0.8)
  }
}

struct SuitView: View {
  let suit: Suit
  let size: CGFloat
  
  var body: some View {
    Image(systemName: suit.systemImageName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(height: size)
      .foregroundColor(suit.color())
  }
}

struct RankSuitStack: View {
  let card: Card
  let rankSize: CGFloat
  let suitSize: CGFloat
  let spacing: CGFloat
  
  var body: some View {
    VStack(spacing: spacing) {
      RankView(rank: card.rank, size: rankSize, color: card.textColour)
      SuitView(suit: card.suit, size: suitSize)
    }
  }
}

struct JokerContent: View {
  let jokerCard: JokerCard
  let imageSize: CGFloat
  
  var body: some View {
    jokerSymbolView
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  private var jokerSymbolView: some View {
    VStack(spacing: 4) {
      Image(systemName: "crown.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: imageSize * 0.6)
        .foregroundStyle(
          LinearGradient(
            colors: [jokerCard.color.color, jokerCard.color.color.opacity(0.7)],
            startPoint: .top,
            endPoint: .bottom
          )
        )
      
      Text("JOKER")
        .font(.system(size: imageSize * 0.15, weight: .black, design: .rounded))
        .frame(maxWidth: .infinity)
        .foregroundColor(jokerCard.color.color)
        .kerning(4)
    }
  }
}

// MARK: - Main Card Views
struct CardFront: View {
  let card: Card
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: CardDesign.cornerRadius, style: .continuous)
        .fill(.white)
        .stroke(Color.gray.opacity(0.3), lineWidth: CardDesign.borderWidth)
      
      // Card content
      GeometryReader { geometry in
        let cardSize = geometry.size
        let cornerSpacingX = cardSize.height * CardDesign.cornerSpacingXRatio
        let cornerSpacingY = cardSize.height * CardDesign.cornerSpacingYRatio
        let rankTextSize = cardSize.height * CardDesign.rankTextSizeRatio
        let suitImageSize = cardSize.height * CardDesign.suitImageSizeRatio
        let jokerImageSize = cardSize.height * CardDesign.suitImageSizeRatio * CardDesign.jokerImageSizeRatio
        
        if let jokerCard = card as? JokerCard {
          JokerContent(jokerCard: jokerCard, imageSize: jokerImageSize)
            .padding(cornerSpacingX)
        } else {
          let rankSuitStack = RankSuitStack(
            card: card,
            rankSize: rankTextSize,
            suitSize: suitImageSize,
            spacing: 2
          )
            .padding(EdgeInsets(
              top: cornerSpacingY,
              leading: cornerSpacingX,
              bottom: cornerSpacingY,
              trailing: cornerSpacingX
            ))
          
          // Top-left corner
          rankSuitStack
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          
          // Bottom-right corner (rotated 180°)
          rankSuitStack
            .rotationEffect(.degrees(180))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
      }
    }
    .aspectRatio(CardDesign.aspectRatio, contentMode: .fit)
  }
}

struct CardBack: View {
  var body: some View {
    ZStack {
      // Modern gradient background
      RoundedRectangle(cornerRadius: CardDesign.cornerRadius, style: .continuous)
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [
              Color.blue,
              Color.indigo,
              Color.purple
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
      
      // Geometric pattern overlay
      GeometryReader { geometry in
        Canvas { context, size in
          let width = size.width
          let height = size.height
          let spacing: CGFloat = 12
          
          // Diamond pattern
          for x in stride(from: 0, to: width, by: spacing) {
            for y in stride(from: 0, to: height, by: spacing) {
              let path = Path { p in
                let centerX = x + spacing/2
                let centerY = y + spacing/2
                let size: CGFloat = 3
                
                p.move(to: CGPoint(x: centerX, y: centerY - size))
                p.addLine(to: CGPoint(x: centerX + size, y: centerY))
                p.addLine(to: CGPoint(x: centerX, y: centerY + size))
                p.addLine(to: CGPoint(x: centerX - size, y: centerY))
                p.closeSubpath()
              }
              
              context.fill(
                path,
                with: .color(.white.opacity(0.12))
              )
            }
          }
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: CardDesign.cornerRadius, style: .continuous))
      
      // Center emblem
      VStack(spacing: 8) {
        Image(systemName: "suit.spade.fill")
          .font(.system(size: 40, weight: .bold))
          .foregroundStyle(.white.opacity(0.9))
        
        Text("CAMBIO")
          .font(.system(size: 12, weight: .bold, design: .rounded))
          .foregroundColor(.white.opacity(0.8))
          .kerning(2)
      }
    }
    .aspectRatio(CardDesign.aspectRatio, contentMode: .fit)
  }
}

// MARK: - Main Card View Component
struct CardView: View {
  let card: Card
  let size: CGSize = CGSize(width: 120, height: 180)
  
  var body: some View {
    Group {
      if card.isFaceUp {
        CardFront(card: card)
      } else {
        CardBack()
      }
    }
    .frame(width: size.width, height: size.height)
    .shadow(
      color: .black.opacity(CardDesign.shadowOpacity),
      radius: CardDesign.shadowRadius,
      x: 0,
      y: 2
    )
  }
}

// MARK: - Preview
#Preview {
  ScrollView {
    VStack(spacing: 20) {
      Text("Joker Variations")
        .font(.headline)
      
      HStack(spacing: 15) {
        CardView(card: {
          let card = JokerCard(color: .red)
          card.flip()
          return card
        }())
        
        CardView(card: {
          let card = JokerCard(color: .black)
          card.flip()
          return card
        }())
      }
      
      Text("Standard Cards")
        .font(.headline)
      
      HStack(spacing: 15) {
        CardView(card: {
          let card = Card(rank: .ace, suit: .spades)
          card.flip()
          return card
        }())
        
        CardView(card: {
          let card = Card(rank: .king, suit: .hearts)
          card.flip()
          return card
        }())
        
        CardView(card: Card(rank: .seven, suit: .diamonds))
      }
      
      Text("Face Cards")
        .font(.headline)
      
      HStack(spacing: 10) {
        ForEach([Rank.jack, .queen, .king], id: \.self) { rank in
          CardView(card: {
            let card = Card(rank: rank, suit: .clubs)
            card.flip()
            return card
          }())
        }
      }
    }
    .padding()
    .background(Color.green.opacity(0.1))
  }
}
