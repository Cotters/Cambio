import SwiftUI

class Card: ObservableObject, Identifiable, Equatable, CustomStringConvertible {
  
  let id: String// = UUID()
  let rank: Rank
  let suit: Suit
  @Published private(set) var isFaceUp: Bool
  
  init(rank: Rank, suit: Suit, isFaceUp: Bool = false) {
    self.id = "\(rank.rawValue)\(suit.asEmoji)"
    self.rank = rank
    self.suit = suit
    self.isFaceUp = isFaceUp
  }
  
  static let specialCardRanks: Set<Rank> = [.ace, .king] // TODO: Add Joker.
  
  var isHolographic: Bool {
    return points <= 0
  }
  
  var textColour: Color {
    return suit.color()
  }
  
  var points: Int { // TODO: Add Joker as -2.
    if (rank == .ace) {
      return ACE_SCORE
    } else if (rank == .king && suit.isRed()) {
      return RED_KING_SCORE
    } else if (rank.isFaceCard) {
      return FACE_CARD_SCORE
    } else if let rankAsScore = Int(rank.rawValue) {
      return rankAsScore
    } else {
      print("Failed to calculate points for \(self)")
      return 0
    }
  }
  
  func flip() {
    isFaceUp.toggle()
  }

  var description: String {
    return "\(rank.rawValue)\(suit.asEmoji)"
  }
  
  static func == (lhs: Card, rhs: Card) -> Bool {
    lhs.id == rhs.id
  }
}

enum JokerColor: String, CaseIterable {
  case red, black
  
  var color: Color {
    switch self {
    case .red: return .red
    case .black: return .black
    }
  }
  
  var displayName: String {
    return rawValue.capitalized
  }
}

class JokerCard: Card {
  
  let color: JokerColor
  
  init(color: JokerColor) {
    self.color = color
    super.init(rank: .joker, suit: color == .red ? .diamonds : .spades)
  }
  
  override var textColour: Color {
    return color.color
  }
  
  override var description: String {
    return "\(color.displayName)🤡"
  }
  
  override var points: Int {
    return JOKER_SCORE
  }
}

enum Suit: String, CaseIterable {
  case spades = "suit.spade.fill"
  case hearts = "suit.heart.fill"
  case diamonds = "suit.diamond.fill"
  case clubs = "suit.club.fill"
  
  func color() -> Color {
    self.isRed() ? .red : .black
  }
  
  func isRed() -> Bool {
    self == .hearts || self == .diamonds
  }
  
  var asEmoji: String {
    switch self {
    case .clubs: return "♣️"
    case .hearts: return "♥️"
    case .diamonds: return "♦️"
    case .spades: return "♠️"
    }
  }
  
  var systemImageName: String {
    return rawValue
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
  case joker = "Joker"
  
  static var allWithoutJoker: [Rank] = [.two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king, .ace]
  
  static var faceCards: [Rank] { [.jack, .queen, .king] }
  
  var displayText: String {
    return rawValue
  }
  
  var isFaceCard: Bool {
    return Rank.faceCards.contains(self)
  }
}
