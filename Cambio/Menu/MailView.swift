import SwiftUI
import UIKit
import MessageUI

struct MailData {
  let receipientEmail: String
  let subject: String
}

struct MailView: UIViewControllerRepresentable {
  
  @Environment(\.presentationMode) var presentation
  let mailData: MailData
  @Binding var result: Result<MFMailComposeResult, Error>?
  
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    
    @Binding var presentation: PresentationMode
    let mailData: MailData
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    init(
      presentation: Binding<PresentationMode>,
      mailData: MailData,
      result: Binding<Result<MFMailComposeResult, Error>?>
    ) {
      _presentation = presentation
      self.mailData = mailData
      _result = result
    }
    
    func mailComposeController(
      _ controller: MFMailComposeViewController,
      didFinishWith result: MFMailComposeResult,
      error: Error?
    ) {
      defer {
        $presentation.wrappedValue.dismiss()
      }
      guard error == nil else {
        self.result = .failure(error!)
        return
      }
      self.result = .success(result)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(presentation: presentation, mailData: mailData, result: $result)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
    let viewController = MFMailComposeViewController()
    viewController.mailComposeDelegate = context.coordinator
    viewController.setToRecipients([mailData.receipientEmail])
    viewController.setSubject(mailData.subject)
    return viewController
  }
  
  func updateUIViewController(
    _ uiViewController: MFMailComposeViewController,
    context: UIViewControllerRepresentableContext<MailView>
  ) {
  }
  
}
