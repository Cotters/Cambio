import SwiftUI

struct ContentView: View {
  var body: some View {
      VStack {
        Spacer()
        PlayerHand()
      }
    }
}

struct PlayerHand: View {
  let backgroundColor: Color = .green
  let cardCount: Int = 4

  var body: some View {
    HStack {
      CardView(rank: Rank.ace, suit: .spades)
      // Use cardCount to create that many cards, random rank and suit:
      
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(backgroundColor.opacity(0.3))
    .cornerRadius(20)
    .frame(height: 180)
  }
}

#Preview {
    ContentView()
}
