//
//  CSVExporter.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/5/23.
//

import Foundation
import SwiftUI

extension Investment {
    func exportBuyingHistory() {
        exportCSV(changes: boughtShares,
                  label: "Purchase Date",
                  filename: "purchase-history")
    }
    
    func exportSellingHistory() {
        exportCSV(changes: soldShares,
                  label: "Sale Date",
                  filename: "sale-history")
    }
    
    func exportCSV(changes: [Change], label: String = "Date", filename: String) {
        var csvString = "\(label),Shares,Stock Date,Ticker,Company,Exchange,High,Close,Low,Close Change,Volume,Interval\n"
        
        for change in changes {
            let date = change.date
            let shares = change.shares
            let stockDate = change.stock.date
            let ticker = change.stock.ticker.uppercased()
            let company = change.stock.name
            let exchange = change.stock.exchangeName
            let high = change.stock.low
            let close = change.stock.close
            let low = change.stock.high
            let closeChange = change.stock.changePercent
            let volume = change.stock.volume
            let interval = change.stock.interval.rawValue
            
            csvString += "\(date.asProperString),\(shares),\(stockDate.asProperString),\(ticker),\(company),\(exchange),\(high),\(close),\(low),\(closeChange),\(volume),\(interval)\n"
        }
        
        #if os(iOS)
        do {
            let fileManager = FileManager.default
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil , create: false )

            let fileURL = path.appendingPathComponent("\(filename)-\(Date.today.asProperFileString).csv")

            try csvString.write(to: fileURL, atomically: true , encoding: .utf8)
            
            let controller = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            
            controller.popoverPresentationController?.sourceView = UIApplication.shared.topViewController?.view
            
            if UIDevice().userInterfaceIdiom == .pad {
                controller.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                controller.popoverPresentationController?.permittedArrowDirections = []
            }
            
            controller.completionWithItemsHandler = {
                (
                    activityType: UIActivity.ActivityType?,
                    completed: Bool,
                    arrayReturnedItems: [Any]?,
                    error: Error?
                ) in
                
                if let error = error {
                    //error occured
                    return
                }
                
                if completed {
                    if let activityType = activityType {
                        switch activityType {
                        case .saveToCameraRoll:
                            break
                        case .copyToPasteboard:
                            break
                        case .addToReadingList:
                            break
                        case .airDrop:
                            break
                        default:
                            //all others
                            break
                        }
                    }
                } else {
                    //Cancel
                }
            }
            
            UIApplication.shared.topViewController?.present(controller, animated: true)
        } catch {

            print("error creating file")

        }
        #endif
    }
}
