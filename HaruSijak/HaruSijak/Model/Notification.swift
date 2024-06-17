/*
    Description : HaruSijack App 개발 notification class
    Date : 2024.6.11
    Author : snr
    Detail :
    Updates :
        * 2024.06.13 by snr : class for notification
        * 2024.06.17 by snr : 설정대 시간대에서 한시간 일찍 알림 뜨도록 설정
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
        let calendarModel = CalendarDB()
        
        for notification in notifications {
            // 날짜 설정
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            
            // 알림 시간 설정
            print("시간 : ",dbModel.queryDB().first?.time ?? 0)
            dateComponents.hour = (dbModel.queryDB().first?.time ?? 0) - 1 //db에서 저장한 시간에서 한시간 먼저 알려주기*/
            dateComponents.minute = 06
            
            // 현재날짜와 calendar 날짜가 같은지 비교해서 알림표시
            let currentDate = Date() //오늘날짜에서
            let todayDate = formattedDate(currentDate: currentDate) //yyyy-MM-dd만 가져옴
            
            // CalendarDB()에서 캘린더일정과 todayDate가 같으면 알림에 task의 title값을 띄우기
            if let task = calendarModel.queryDB().first(where: { task in
                return isSameDay(date1: task.taskDate, date2: todayDate!)
            }) {
                print("진입시작")
                let content = UNMutableNotificationContent()
                content.title = "🔔하루시작 스케줄이 도착했습니다🔔"
                content.sound = .default
                content.subtitle = task.task[0].title
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
                    
                UNUserNotificationCenter.current().add(request) { error in
                    guard error == nil else {return}
                    print("scheduling notification with id:\(notification.id)")
                }
            }
        }
    }
    
    /* MARK: 날짜 체크 */
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    /* MARK: yyyy-MM-dd formatter */
    func formattedDate(currentDate: Date) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: formatter.string(from: currentDate))
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

