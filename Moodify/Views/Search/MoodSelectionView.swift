//
//  MoodSelectionView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI

struct MoodSelectionView: View {
    @Binding var selectedMood: Mood?
    let onMoodSelected: (Mood) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.mediumSpacing) {
            Text("How are you feeling?")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: Constants.UI.smallSpacing) {
                ForEach(Mood.allCases) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMood == mood,
                        action: {
                            selectedMood = mood
                            onMoodSelected(mood)
                        }
                    )
                }
            }
        }
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Constants.UI.smallSpacing) {
                Text(mood.emoji)
                    .font(.system(size: 30))
                
                Text(mood.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Constants.UI.mediumSpacing)
            .background(
                isSelected ?
                Color.moodColor(for: mood).opacity(0.3) :
                Color(.systemGray6)
            )
            .cornerRadius(Constants.UI.mediumCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.mediumCornerRadius)
                    .stroke(
                        isSelected ? Color.moodColor(for: mood) : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MoodSelectionView(selectedMood: .constant(.happy)) { mood in
        print("Selected: \(mood)")
    }
    .padding()
}
