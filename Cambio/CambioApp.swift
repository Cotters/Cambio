import SwiftUI

@main
struct CambioApp: App {
  @StateObject private var gameCenterManager = GameCenterManager.shared
  @Environment(\.scenePhase) private var scenePhase
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(gameCenterManager)
        .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
          if newPhase == .active && !gameCenterManager.isAuthenticated {
            Task {
              await gameCenterManager.authenticatePlayer()
            }
          }
        }
    }
  }
}
