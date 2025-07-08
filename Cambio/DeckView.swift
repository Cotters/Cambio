import SwiftUI

struct DeckView: View {
  let count: Int

  var body: some View {
    VStack {
      ZStack {
        ForEach(0..<min(count, 5), id: \.self) { index in
          Image("card_back")
            .resizable()
            .frame(width: DECK_CARD_WIDTH, height: DECK_CARD_HEIGHT)
            .aspectRatio(2/3, contentMode: .fill)
            .scaledToFit()
            .clipShape(.buttonBorder)
            .shadow(color: .black.opacity(0.2), radius: 4)
            .edgesIgnoringSafeArea(.all)
        }
      }
      .accessibilityLabel("\(count) cards left in deck")
    }
    Text("\(count) cards remaining")
      .font(.callout)
  }
}
