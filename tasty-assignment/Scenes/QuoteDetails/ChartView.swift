//
//  ChartView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import UIKit
import DGCharts

class ChartView: UIView {
    let dataEntries = [
        CandleChartDataEntry(x: 1, shadowH: 10, shadowL: 5, open: 6, close: 9),
        CandleChartDataEntry(x: 2, shadowH: 12, shadowL: 4, open: 8, close: 11)
        // ... more entries
    ]
    init() {
        super.init(frame: .zero)
        addSubview(candleStickChartView)
        setupConstraints()
        let dataSet = CandleChartDataSet(entries: dataEntries, label: "My Data")
        dataSet.colors = [NSUIColor.black]
        dataSet.shadowColor = NSUIColor.darkGray
        dataSet.shadowWidth = 0.7
        dataSet.decreasingColor = NSUIColor.red
        dataSet.decreasingFilled = true
        dataSet.increasingColor = NSUIColor.green
        dataSet.increasingFilled = true
        let data = CandleChartData(dataSet: dataSet)
        candleStickChartView.data = data
    }

    let candleStickChartView = CandleStickChartView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChartView {
    func setupConstraints() {
        candleStickChartView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
}
