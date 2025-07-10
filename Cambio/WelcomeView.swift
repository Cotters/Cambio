import SwiftUI

struct WelcomeView: View {
    let onStartTapped: () -> Void
    
    var body: some View {
        ScrollView { // Wrap the content in a ScrollView
            VStack {
                Spacer()
                Text("Cambio Card Game")
                    .font(.largeTitle)
                    .padding(.bottom, 20) // Add some padding for spacing
              
                Button("Begin (I Know the Rules)", action: onStartTapped)
                  .padding(10)
                  .foregroundStyle(.white)
                  .font(.system(size: 18, weight: .bold, design: .monospaced))
                  .background(
                    RoundedRectangle(cornerRadius: 12)
                      .fill(.blue.opacity(0.5))
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("Game Rules")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Text("Objective:")
                        .font(.headline)
                    Text("The goal is to have the least points possible, typically by removing all your cards or keeping low scoring cards.")
                    .italic()

                    Text("Setup:")
                        .font(.headline)
                    Text("   • Each player is dealt \(HAND_SIZE) cards.")
                    Text("   • There is a draw pile and a discard pile in the middle.")

                    Text("Gameplay:")
                        .font(.headline)
                    Text("   • Players take turns drawing cards from the draw pile or the discard pile.")
                    Text("   • Players can choose to keep or discard the drawn card.")
                    Text("   • At any time, players can tap their own cards if they think it matches with the top card on the discard pile.")
                    Text("   • If you correctly match, you discard the matched card from your hand. If you incorrectly match, you gain an additional card (Max hand size is \(HAND_SIZE)).")
                    Text("   • On your turn, if you think you have the least amount of points - based on the scoring below - you tap Cambio!")
                    Text("   • The other player has one last turn and afterwards the points are scored.")

                    Text("Scoring:")
                        .font(.headline)
                    Text("   • Red Kings score ") + Text("\(RED_KING_SCORE) points").foregroundColor(.red)
                    Text("   • Aces score ") + Text("\(ACE_SCORE) points").foregroundColor(.blue)
                    Text("   • Face cards score ") + Text("+\(FACE_CARD_SCORE) points").foregroundColor(.green)
                    Text("   • 2-10 cards score their value. For example, 4 of Spades scores ") + Text("-4 points").foregroundColor(.red)
                }
                .padding()
                
                Button("Play Cambio", action: onStartTapped)
                  .padding(10)
                  .foregroundStyle(.white)
                  .font(.system(size: 18, weight: .bold, design: .monospaced))
                  .background(
                    RoundedRectangle(cornerRadius: 12)
                      .fill(.blue.opacity(0.5))
                  )
                Spacer()
            }
            .padding() // Add padding to the outer VStack
            .fontDesign(.monospaced)
        }
    }
}

#Preview {
  WelcomeView(onStartTapped: {})
}
