//
//  BarChartViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-03-25.
//

import UIKit
import DGCharts

class BarChartViewController: UIViewController {
    @IBOutlet var barChartView: BarChartView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupChart()
       fetchHealthData() // Fetch data when view loads

        // Do any additional setup after loading the view.
    }
    func setupChart() {
            barChartView.noDataText = "No health data available"
            barChartView.chartDescription.enabled = false
            barChartView.legend.enabled = false
            barChartView.xAxis.labelPosition = .bottom
            barChartView.rightAxis.enabled = false
        }
     
        func fetchHealthData() {
            let healthKit = HealthKitManager.shared
     
            healthKit.fetchStepCount { steps in
                healthKit.fetchCaloriesBurned { calories in
                    healthKit.fetchExerciseMinutes { exerciseMinutes in
                        let healthStats = [
                            ("Steps", steps),
                            ("Calories", calories),
                            ("Exercise (min)", exerciseMinutes)
                        ]
                        DispatchQueue.main.async {
                            self.updateChart(with: healthStats)
                        }
                    }
                }
            }
        }
     
    func updateChart(with data: [(String, Double)]) {

        var entries: [BarChartDataEntry] = []

        var labels: [String] = []
     
        for (index, value) in data.enumerated() {

            let entry = BarChartDataEntry(x: Double(index), y: value.1)

            entries.append(entry)

            labels.append(value.0) // Store label separately

        }
     
        let dataSet = BarChartDataSet(entries: entries, label: "Health Stats")

        dataSet.colors = ChartColorTemplates.colorful()

        let data = BarChartData(dataSet: dataSet)
     
        barChartView.data = data

        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels) // Use stored labels

        barChartView.xAxis.granularity = 1

        barChartView.notifyDataSetChanged()

    }

     

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
