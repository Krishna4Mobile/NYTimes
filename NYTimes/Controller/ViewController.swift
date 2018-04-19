//
//  ViewController.swift
//  NYTimes
//
//  Created by mac admin on 18/04/18.
//  Copyright © 2018 mac admin. All rights reserved.
//

import UIKit
import Alamofire
//Model Object Data
class listData {
    var titleName : String
    var byLineValue : String
    var dateValue : String
    var abstractStr : String
    init(byLineValue : String,titleName : String,dateValue : String,abstractStr :String)
    {
        self.byLineValue = byLineValue
        self.titleName = titleName
        self.dateValue = dateValue
        self.abstractStr = abstractStr
    }
}
let navigationColor = UIColor.init(hex: "34A9DC")
let floatButtonRadius = 50
typealias arrayOfDict =  Array<Dictionary<String,Any>>
class ViewController: UIViewController {
      var loadingIndicator = UIView()
 var listInfoDataArray : [listData] = []
    var abstractString = ""
    @IBOutlet weak var nyListTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nyListTableview.register(UINib(nibName:String(describing: NYTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NYTableViewCell.self))
        self.nyListTableview.delegate = self
        self.nyListTableview.dataSource = self
        self.nyListTableview.estimatedRowHeight = 44.0
        self.nyListTableview.rowHeight = UITableViewAutomaticDimension
        self.listServiceDataResponse(Url: NYTimesWeekURL)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        let alertConroller = UIAlertController(title: "Multiple Actions", message: "The alert has more than one action which means more than one button.", preferredStyle: UIAlertControllerStyle.actionSheet)
        let dayAlert = UIAlertAction(title: "Day", style: UIAlertActionStyle.default) { _ in
        self.listServiceDataResponse(Url: NYTimesDayURL)
        }
        let weekAlert = UIAlertAction(title: "Week", style: UIAlertActionStyle.default) { _ in
        self.listServiceDataResponse(Url: NYTimesWeekURL)
        }
        let monthAlert = UIAlertAction(title: "Month", style: UIAlertActionStyle.default) { _ in
        self.listServiceDataResponse(Url: NYTimesMonthURL)
        }
        let dismiss = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        // relate actions to controllers
        alertConroller.addAction(dayAlert)
        alertConroller.addAction(weekAlert)
          alertConroller.addAction(monthAlert)
        alertConroller.addAction(dismiss)
        present(alertConroller, animated: true, completion: nil)
    }
    func listServiceDataResponse(Url:String)
    {
        self.listInfoDataArray.removeAll()
        loadingIndicator   = ViewController.displaySpinner(onView: self.view)
        let request = Singleton.createRquest(Url: Url, PostType: GetMethod, postObject:nil, contentType: jsonConten_Type, userPath: "")
        Singleton().postServiceResults(urlrequest: request) { (Results, errorMessage, statusCode) in
            if Results != nil , let response: Dictionary = Results as Dictionary<String,Any>?
            {
                if let groupParamList: arrayOfDict = response["results"] as? arrayOfDict, groupParamList.count != 0
                {
                   ViewController.removeSpinner(spinner: self.loadingIndicator)
                    let groupParamListArray = groupParamList
                    if (groupParamListArray.count) > 0
                    {
                        for paramDict in groupParamListArray
                        {
                            let dateParam = Singleton.nullToNil(value: paramDict["published_date"] as! String) as! String
                            let bylineParam = Singleton.nullToNil(value: paramDict["byline"] as! String) as! String
                            let titleParam = Singleton.nullToNil(value: paramDict["title"] as! String) as! String
                           let abstractString = Singleton.nullToNil(value: paramDict["abstract"] as! String) as! String

                            self.listInfoDataArray.append(listData(
                                byLineValue: bylineParam ,titleName: titleParam,dateValue: dateParam, abstractStr: abstractString
                            ))
                        }
                        DispatchQueue.main.async {
                         self.nyListTableview.reloadData()
                        }
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "NYDetailIdentifier" {
            let detailScreen = segue.destination as! NYDetailViewController
            detailScreen.detailInfo = self.abstractString
        }
        
    }
    
}



extension ViewController : UITableViewDataSource,UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listInfoDataArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : NYTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NYTableViewCell.self), for: indexPath) as! NYTableViewCell
        cell.imageBtn.layer.cornerRadius = 0.5 * cell.imageBtn.bounds.size.width
        cell.imageBtn.clipsToBounds = true
        cell.imageBtn.backgroundColor = UIColor.lightGray
        let listArrayData : listData = listInfoDataArray[indexPath.row]
        cell.titleLabel .text = listArrayData.titleName
        cell.byLineLabel.text = listArrayData.byLineValue
        cell.dateLabel.text = listArrayData.dateValue
        return cell
    }
   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
     public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         let listArrayData : listData = listInfoDataArray[indexPath.row]
        self.abstractString = listArrayData.abstractStr
      self.performSegue(withIdentifier: "NYDetailIdentifier", sender: self.abstractString)
    }
 
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension ViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        let loadingTextLabel = UILabel()
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        loadingTextLabel.textColor = UIColor.white
        loadingTextLabel.text = "Please Wait...."
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 16)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: spinnerView.center.x, y: spinnerView.center.y + 30)
        spinnerView.addSubview(loadingTextLabel)
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}



