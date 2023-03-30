//
//  NotificationService.swift
//  NotificationService
//
//  Created by Apple on 11/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UserNotifications
import OneSignal
import os.log

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    var receivedRequest: UNNotificationRequest?


    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request;
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        let userInfo = request.content.userInfo
        let custom = userInfo["custom"]
        print("Running NotificationServiceExtension: userInfo = \(userInfo.description)")
        print("Running NotificationServiceExtension: custom = \(custom.debugDescription)")
      //debug log types need to be enabled in Console > Action > Include Debug Messages
        os_log("%{public}@", log: OSLog(subsystem: "com.montotech.Test", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, userInfo.debugDescription)
        

        
        if let bestAttemptContent = bestAttemptContent {
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
    
    override func serviceExtensionTimeWillExpire() {
  
       if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }

}
