 //
//  NYDetailViewController.swift
//  NYTimes
//
//  Created by mac admin on 19/04/18.
//  Copyright © 2018 mac admin. All rights reserved.
//

import UIKit

class NYDetailViewController: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    var detailInfo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTableView.register(UINib(nibName:String(describing: NYDetailTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NYDetailTableViewCell.self))
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.estimatedRowHeight = 44.0
        self.detailTableView.rowHeight = UITableViewAutomaticDimension
        print(detailInfo)
      
        // Do any additional setup after loading the view.
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



extension NYDetailViewController : UITableViewDataSource,UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : NYDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NYDetailTableViewCell.self), for: indexPath) as! NYDetailTableViewCell
        cell.infoLabel.text =  detailInfo
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

