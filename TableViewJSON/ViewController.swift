 //
//  ViewController.swift
//  TableViewJSON
//
//  Created by Giridhar Bhujanga on 24/05/17.
//  Copyright © 2017 Giridhar Bhujanga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var fetchedCountry = [Country]()
    
    @IBOutlet weak var countryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseData()
        
        countryTableView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedCountry.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = fetchedCountry[indexPath.row].country
        cell?.detailTextLabel?.text = fetchedCountry[indexPath.row].capital
        return cell!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseData() {
        fetchedCountry = []
        
        let url = "https://restcountries.eu/rest/v1/all"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("ERROR !")
            } else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    
                    //print(fetchedData)
                    
                    for eachFetchedCountry in fetchedData {
                        let eachCountry = eachFetchedCountry as! [String:Any]
                        let country = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as! String
                        
                        print(country)
                        print(capital)
                        print("\n")
                        
                        self.fetchedCountry.append(Country(country: country, capital: capital))
                        
                    }
                    
                    print(self.fetchedCountry)
                    self.countryTableView.reloadData()
                } catch {
                    print("Error in JSON Serialization !")
                } 
            }
        }
        task.resume()
    }

}


class Country {
    var country : String
    var capital : String
    init(country: String, capital: String) {
        self.country = country
        self.capital = capital
    }
}
