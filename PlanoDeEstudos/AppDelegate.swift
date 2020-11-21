//
//  AppDelegate.swift
//  PlanoDeEstudos
//
//  Created by Eric Alves Brito on 19/11/20.
//  Copyright © 2020 Afrodev. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .carPlay, .badge]) { (status, error) in
            if status {
                print("Usuário aceitou receber notificação")
            } else {
                print("Ahhhh fí-duma-égua!!!")
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "confirm", title: "Já estudei 👍", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Fechar", options: [])
        
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        center.setNotificationCategories([category])
        
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "confirm":
            StudyManager.shared.setPlanDone(id: response.notification.request.identifier)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "confirmed"), object: nil)
        case "cancel":
            print("Usuário clicou no botão de cancelar")
        case UNNotificationDefaultActionIdentifier:
            print("Usuário clicou na notificação em si!")
        case UNNotificationDismissActionIdentifier:
            print("Usuário dismissou a notificação")
        default:
            break
        }
        
        completionHandler()
    }
}
