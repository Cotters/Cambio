import SwiftUI

struct Card: Identifiable, Hashable, CustomStringConvertible {
  let id = UUID()
  let rank: Rank
  let suit: Suit
  var isFaceUp = false
  
  mutating func flip() {
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
  
  // Create a function which describes the card when print(card):
  var description: String {
    let faceUpText = isFaceUp ? "FaceUp" : "FaceDown"
    return "\(rank.rawValue) of \(suit) (\(faceUpText))"
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
