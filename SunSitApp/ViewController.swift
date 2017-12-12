//
//  ViewController.swift
//  SunSitApp
//
//  Created by Hazem on 11/27/17.
//  Copyright © 2017 Hazem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var CityName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func BtnCityClicked(_ sender: Any) {
        let url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(CityName.text!)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        
        LoadURL(url: url)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LoadURL(url:String){
        // To MultiThreading The Task [parallel processing]
        DispatchQueue.global().async {
            do{
                //Load Json Server
                let AppURL = URL(string: url)!
                let data = try Data(contentsOf: AppURL)
                let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let query = json["query"] as! [String:Any]
                let results = query["results"] as! [String:Any]
                let channel = results["channel"] as! [String:Any]
                let astronomy = channel["astronomy"] as! [String:Any]
                //print(astronomy["sunrise"]!)
                // We Cant Access UI Throw The [ASYNC]
                //So We Use [SYNC] To Access The UI And Display Our Data O  ut Of The [ASYNC]
                DispatchQueue.global().sync {
                    self.Result.text = "SunSet At: \(astronomy["sunrise"]!)"
                }
            }
            catch{
                print("Cannot Load From Server")
            }
        }
    }
}

