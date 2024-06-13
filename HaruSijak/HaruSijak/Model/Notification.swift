/*
    Description : HaruSijack App 개발 notification class
    Date : 2024.6.11
    Author : snr
    Detail :
    Updates :
        * 2024.06.13 by snr : class for notification
 */

import SwiftUI
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class NotificationManager {
    
    var notifications = [Notification]()
    
    //제일 처음 알림설정을 위한 permission 함수
    func requestPermission() {
        // .alert : 알림 띄우기, .sound : 띵! 소리, .badge : 앱 로고 위에 숫자표시
        let options: UNAuthorizationOptions = [.alert, .sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error{
                print("Error : \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func addNotification(title: String) {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .notDetermined: self.requestPermission()
                case .authorized, .provisional: self.scheduleNotifications()
                default : break
            }
        }
    }
    
    func scheduleNotifications() {
        
        let dbModel = TimeSettingDB()
        
        for notification in notifications {
            // 날짜 설정
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = 18 /*dbModel.queryDB().first?.time ?? 0 //db에서 저장한 시간 가져오기*/
            dateComponents.minute = 28
            print("dateComponents.hour : ",dateComponents.hour!)
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            content.subtitle = "약 먹을 시간"
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
                
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else {return}
                print("scheduling notification with id:\(notification.id)")
            }
        }
    }
    
    func cancleNotification() {
        // 곧 다가올 알림 지우기
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //현재 폰에 떠 있는 알림 지우기
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func deleteBadgeNumber() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}

