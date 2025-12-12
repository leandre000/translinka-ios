//
//  FavoritesView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if favoritesViewModel.favoriteRoutes.isEmpty {
                    VStack(spacing: Theme.spacingMedium) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.textSecondary)
                        
                        Text("No favorite routes yet")
                            .font(.headline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, Theme.spacingXLarge)
                } else {
                    ForEach(favoritesViewModel.favoriteRoutes) { route in
                        FavoriteRouteRow(route: route)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    favoritesViewModel.removeFavorite(route)
                                } {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Favorite Routes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FavoriteRouteRow: View {
    let route: Route
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(route.origin) → \(route.destination)")
                    .font(.headline)
                
                Text(route.departureTime, style: .time)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(route.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(Theme.primaryBlue)
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, Theme.spacingSmall)
    }
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteRoutes: [Route] = []
    
    init() {
        loadFavorites()
    }
    
    func addFavorite(_ route: Route) {
        if !favoriteRoutes.contains(where: { $0.id == route.id }) {
            favoriteRoutes.append(route)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ route: Route) {
        favoriteRoutes.removeAll { $0.id == route.id }
        saveFavorites()
    }
    
    func isFavorite(_ route: Route) -> Bool {
        favoriteRoutes.contains(where: { $0.id == route.id })
    }
    
    private func loadFavorites() {
        // Load from UserDefaults or Core Data
    }
    
    private func saveFavorites() {
        // Save to UserDefaults or Core Data
    }
}

