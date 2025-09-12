typealias Deck = [Card]

extension Deck {
  static var standard: Deck {
    return Rank.allWithoutJoker.flatMap { rank in
      Suit.allCases.map { suit in
        Card(rank: rank, suit: suit)
      }
    }
  }
  
  static var standardWithJokers: Deck {
    return standard + [
      JokerCard(color: .red),
      JokerCard(color: .black),
    ]
  }
}
