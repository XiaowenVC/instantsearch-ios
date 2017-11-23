//
//  MultiIndexTableviewControllerDemo.swift
//  InstantSearchDemo
//
//  Created by Guy Daher on 09/11/2017.
//  Copyright © 2017 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class MultiIndexTableviewControllerDemo: UIViewController, HitsTableViewDataSource {
    
    @IBOutlet weak var ikeaTableView: HitsTableWidget!
    @IBOutlet weak var bestbuyTableView: HitsTableWidget!
    @IBOutlet weak var searchBar: SearchBarWidget!
    
    @IBOutlet weak var ikeaPriceSlider: SliderWidget!
    @IBOutlet weak var bestBuyPriceSlider: SliderWidget!
    @IBOutlet weak var ikeaPriceLabel: UILabel!
    @IBOutlet weak var bestbuyPriceLabel: UILabel!
    
    var ikeaHitsController: HitsController!
    var bestbuyHitsController: HitsController!

    private let ALGOLIA_APP_ID = "latency"
    private let ALGOLIA_API_KEY = "afc3dd66dd1293e2e2736a5a51b05c0a"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let indexIds: [SearcherId] = [SearcherId.init(name: "bestbuy"), SearcherId.init(name: "ikea")]
        InstantSearch.shared.configure(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY, indexIds: indexIds)
        InstantSearch.shared.registerAllWidgets(in: self.view)
        
        ikeaHitsController = HitsController(table: ikeaTableView)
        ikeaTableView.dataSource = ikeaHitsController
        ikeaTableView.delegate = ikeaHitsController
        ikeaHitsController.tableDataSource = self
        
        bestbuyHitsController = HitsController(table: bestbuyTableView)
        bestbuyTableView.dataSource = bestbuyHitsController
        bestbuyTableView.delegate = bestbuyHitsController
        bestbuyHitsController.tableDataSource = self
        
        ikeaPriceSlider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        bestBuyPriceSlider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        ikeaPriceLabel.text = "Ikea > \(ikeaPriceSlider.value.rounded())$"
        bestbuyPriceLabel.text = "Bestbuy > \(bestBuyPriceSlider.value.rounded())$"
    }
    
    @objc func sliderChanged(sender: UISlider) {
        ikeaPriceLabel.text = "Ikea > \(ikeaPriceSlider.value.rounded())$"
        bestbuyPriceLabel.text = "Bestbuy > \(bestBuyPriceSlider.value.rounded())$"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell: UITableViewCell!
        let salesPrice: String!
        if tableView == ikeaTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "ikeaCell", for: indexPath)
            salesPrice = String(hit["price"] as! Double)
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "bestbuyCell", for: indexPath)
            salesPrice = String(hit["salePrice"] as! Double)
        }
        
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.textLabel?.text = hit["name"] as? String
        cell.detailTextLabel?.text = salesPrice
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
