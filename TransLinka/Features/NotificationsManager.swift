//
//  NotificationsManager.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import UserNotifications

class NotificationsManager {
    static let shared = NotificationsManager()
    
    private init() {}
    
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }
    
    func scheduleBookingReminder(booking: Booking, minutesBefore: Int = 30) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Trip"
        content.body = "Your trip to \(booking.route?.destination ?? "destination") departs in \(minutesBefore) minutes"
        content.sound = .default
        content.userInfo = ["bookingId": booking.id]
        
        guard let departureTime = booking.route?.departureTime else { return }
        let reminderTime = departureTime.addingTimeInterval(-Double(minutesBefore * 60))
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderTime),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "booking_\(booking.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for bookingId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["booking_\(bookingId)"])
    }
}

