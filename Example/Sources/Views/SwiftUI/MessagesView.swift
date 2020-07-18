//
//  MessagesView.swift
//  ChatExample
//
//  Created by Kino Roy on 2020-07-18.
//  Copyright © 2020 MessageKit. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
#endif
import MessageKit
import InputBarAccessoryView

class MessageSwiftUIVC: MessagesViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Because SwiftUI wont automatically make our controller the first responder, we need to do it on viewDidAppear
        becomeFirstResponder()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

@available(iOS 13.0.0, *)
struct MessagesView: UIViewControllerRepresentable {
    
    @State var initialized = false
    @Binding var messages: [MessageType]
    
    func makeUIViewController(context: Context) -> MessagesViewController {
        let messagesVC = MessageSwiftUIVC()
        
        messagesVC.messagesCollectionView.messagesDisplayDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesLayoutDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesDataSource = context.coordinator
        messagesVC.messageInputBar.delegate = context.coordinator
        messagesVC.scrollsToBottomOnKeyboardBeginsEditing = true // default false
        messagesVC.maintainPositionOnKeyboardFrameChanged = true // default false
        
        return messagesVC
    }
    
    func updateUIViewController(_ uiViewController: MessagesViewController, context: Context) {
        uiViewController.messagesCollectionView.reloadData()
        scrollToBottom(uiViewController)
    }
    
    private func scrollToBottom(_ uiViewController: MessagesViewController) {
        DispatchQueue.main.async {
            // The initialized state variable allows us to start at the bottom with the initial messages without seeing the inital scroll flash by
            uiViewController.messagesCollectionView.scrollToBottom(animated: self.initialized)
            self.initialized = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(messages: $messages)
    }
    
    final class Coordinator {
        var messages: Binding<[MessageType]>
        init(messages: Binding<[MessageType]>) {
            self.messages = messages
        }
    }

}

@available(iOS 13.0.0, *)
extension MessagesView.Coordinator: MessagesDataSource {
    func currentSender() -> SenderType {
        return SampleData.shared.currentSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages.wrappedValue[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.wrappedValue.count
    }
}

@available(iOS 13.0.0, *)
extension MessagesView.Coordinator: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MockMessage(text: text, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date())
        messages.wrappedValue.append(message)
        inputBar.inputTextView.text = ""
    }
}

@available(iOS 13.0.0, *)
extension MessagesView.Coordinator: MessagesLayoutDelegate, MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
}
