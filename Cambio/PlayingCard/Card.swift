import SwiftUI

final class Card: ObservableObject, Identifiable, Equatable, CustomStringConvertible {
  
  let id = UUID()
  let rank: Rank
  let suit: Suit
  @Published private(set) var isFaceUp: Bool
  
  init(rank: Rank, suit: Suit, isFaceUp: Bool = false) {
    self.rank = rank
    self.suit = suit
    self.isFaceUp = isFaceUp
  }
  
  static let specialCardRanks: Set<Rank> = [.ace, .king] // TODO: Add Joker.
  
  var isHolographic: Bool {
    return Card.specialCardRanks.contains(rank)
  }
  
  func flip() {
    isFaceUp.toggle()
  }

  static var fullDeck: [Card] {
    var cards: [Card] = []
    for suit in Suit.allCases {
      for rank in Rank.allCases {
        cards.append(Card(rank: rank, suit: suit))
      }
    }
    return cards
  }

  var description: String {
    return "\(rank.rawValue)\(suit.asEmoji)"
  }
  
  static func == (lhs: Card, rhs: Card) -> Bool {
    lhs.id == rhs.id
  }
}

enum Suit: String, CaseIterable {
  case spades = "suit.spade.fill"
  case hearts = "suit.heart.fill"
  case diamonds = "suit.diamond.fill"
  case clubs = "suit.club.fill"
  
  func colour() -> Color {
    self == .spades || self == .clubs ? .black : .red
  }
  
  var asEmoji: String {
    switch self {
    case .clubs:
        return "♣️"
    case .hearts:
      return  "♥️"
    case .diamonds:
      return  "♦️"
    case .spades:
      return  "♠️"
    }
  }
}

// TODO: Add a Joker! Should skip the Suit pairing. 1 black; 1 red.
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
