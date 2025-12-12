//
//  BusScheduleView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct BusScheduleView: View {
    let route: Route
    @StateObject private var scheduleViewModel = BusScheduleViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Today's Schedule
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Today's Schedule")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(scheduleViewModel.todaySchedules) { schedule in
                            ScheduleRow(schedule: schedule)
                        }
                    }
                    .padding(.vertical)
                    
                    // Upcoming Schedules
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Upcoming Schedules")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(scheduleViewModel.upcomingSchedules) { schedule in
                            ScheduleRow(schedule: schedule)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Bus Schedule")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                scheduleViewModel.loadSchedules(for: route)
            }
        }
    }
}

struct ScheduleRow: View {
    let schedule: BusSchedule
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(schedule.departureTime, style: .time)
                    .font(.headline)
                    .foregroundColor(Theme.primaryBlue)
                
                Text(schedule.departureTime, style: .date)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                    Text("\(schedule.availableSeats) seats")
                        .font(.caption)
                }
                .foregroundColor(schedule.availableSeats > 10 ? Theme.accentGreen : Theme.accentOrange)
                
                StatusBadge(status: schedule.status)
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct BusSchedule: Identifiable {
    let id: String
    let departureTime: Date
    let availableSeats: Int
    let status: ScheduleStatus
    
    enum ScheduleStatus {
        case available
        case limited
        case soldOut
        case cancelled
    }
}

@MainActor
class BusScheduleViewModel: ObservableObject {
    @Published var todaySchedules: [BusSchedule] = []
    @Published var upcomingSchedules: [BusSchedule] = []
    
    func loadSchedules(for route: Route) {
        let calendar = Calendar.current
        let now = Date()
        
        // Generate today's schedules
        todaySchedules = (0..<5).compactMap { hourOffset in
            let departureTime = calendar.date(byAdding: .hour, value: hourOffset + 2, to: now) ?? now
            let availableSeats = Int.random(in: 5...route.availableSeats)
            
            return BusSchedule(
                id: UUID().uuidString,
                departureTime: departureTime,
                availableSeats: availableSeats,
                status: availableSeats > 10 ? .available : (availableSeats > 0 ? .limited : .soldOut)
            )
        }
        
        // Generate upcoming schedules
        upcomingSchedules = (1..<8).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: now) else { return nil }
            let departureTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: date) ?? date
            let availableSeats = Int.random(in: 10...route.availableSeats)
            
            return BusSchedule(
                id: UUID().uuidString,
                departureTime: departureTime,
                availableSeats: availableSeats,
                status: availableSeats > 10 ? .available : .limited
            )
        }
    }
}

