//
//  ChartView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import DGCharts
import UIKit

class ChartView: UIView {
 
    private let candleStickChartView = CandleStickChartView()

    init() {
        super.init(frame: .zero)
        addSubview(candleStickChartView)
        setupConstraints()
    }

    @available(*, unavailable, message: "Use init() method instead.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateChart(with entries: [CandleChartDataEntry]) {
        let dataSet = CandleChartDataSet(entries: entries, label: "D1 chart")
        dataSet.colors = [NSUIColor.black]
        dataSet.shadowColor = NSUIColor.darkGray
        dataSet.shadowWidth = 0.7
        dataSet.decreasingColor = NSUIColor.red
        dataSet.decreasingFilled = true
        dataSet.increasingColor = NSUIColor.green
        dataSet.increasingFilled = true
    
        candleStickChartView.data = CandleChartData(dataSet: dataSet)
    }
}

private extension ChartView {
    func setupConstraints() {
        candleStickChartView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
}
