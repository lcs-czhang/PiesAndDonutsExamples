//
//  ContentView.swift
//  PiesAndDonutsExamples
//
//  Created by Yuzhou Zhang on 2024-11-08.
//

import SwiftUI
import Charts

struct ContentView: View {
    private var coffeeSales = [
        (name: "Americano", count: 120),
        (name: "Cappuccino", count: 234),
        (name: "Espresso", count: 62),
        (name: "Latte", count: 625),
        (name: "Mocha", count: 320),
        (name: "Affogato", count: 50)
    ]
    var body: some View {
        VStack {
            Chart {
                ForEach(coffeeSales, id: \.name) { coffee in
                    BarMark(
                        x: .value("Type", coffee.name),
                        y: .value("Cup", coffee.count)
                    )
                    .foregroundStyle(by: .value("Type", coffee.name))
                }
            }
        }
        .padding()
    }
}
struct OneDimensionalView: View {
    private var coffeeSales = [
        (name: "Americano", count: 120),
        (name: "Cappuccino", count: 234),
        (name: "Espresso", count: 62),
        (name: "Latte", count: 625),
        (name: "Mocha", count: 320),
        (name: "Affogato", count: 50)
    ]
    var body: some View {
        VStack {
            Chart {
                ForEach(coffeeSales, id: \.name) { coffee in

                    BarMark(
                        x: .value("Cup", coffee.count),
                        stacking: .normalized
                    )
                    .foregroundStyle(by: .value("Type", coffee.name))
                }
            }
            .frame(height: 100)
        }
        .padding()
    }
}

struct PieView: View {
    private var coffeeSales = [
        (name: "Americano", count: 120),
        (name: "Cappuccino", count: 234),
        (name: "Espresso", count: 62),
        (name: "Latte", count: 625),
        (name: "Mocha", count: 320),
        (name: "Affogato", count: 50)
    ]
    var body: some View {
        Chart {
            ForEach(coffeeSales, id: \.name) { coffee in

                SectorMark(
                    angle: .value("Cup", coffee.count),
                    outerRadius: coffee.name == "Latte" ? 150 : 120,
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value("Type", coffee.name))
                .annotation(position: .overlay) {
                    Text("\(coffee.count)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(height: 500)
    }
}

struct DonutView: View {
    private var coffeeSales = [
        (name: "Americano", count: 120),
        (name: "Cappuccino", count: 234),
        (name: "Espresso", count: 62),
        (name: "Latte", count: 625),
        (name: "Mocha", count: 320),
        (name: "Affogato", count: 50)
    ]
    @State private var selectedCount: Int?
    @State private var selectedSector: String?
    private func findSelectedSector(value: Int) -> String? {

        var accumulatedCount = 0

        let coffee = coffeeSales.first { (_, count) in
            accumulatedCount += count
            return value <= accumulatedCount
        }

        return coffee?.name
    }
    var body: some View {
        Chart {
            ForEach(coffeeSales, id: \.name) { coffee in

                SectorMark(
                    angle: .value("Cup", coffee.count),
                    innerRadius: .ratio(0.65),
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value("Type", coffee.name))
                .cornerRadius(10.0)
                .annotation(position: .overlay) {
                    Text("\(coffee.count)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .opacity(selectedSector == nil ? 1.0 : (selectedSector == coffee.name ? 1.0 : 0.5))
            }
        }
        .frame(height: 500)
        .chartBackground { proxy in
            Text("coffee")
                .font(.system(size: 100))
        }
        .chartAngleSelection(value: $selectedCount)
        .onChange(of: selectedCount) { oldValue, newValue in
            if let newValue {
                selectedSector = findSelectedSector(value: newValue)
            } else {
                selectedSector = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
#Preview {
    OneDimensionalView()
}
#Preview {
    PieView()
}

#Preview {
    DonutView()
}
