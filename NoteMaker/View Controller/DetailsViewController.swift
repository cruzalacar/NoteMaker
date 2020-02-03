//
//  DetailsViewController.swift
//  PlannerApp
//
//  Created by Murtaza on 2019-12-02.
//  Copyright © 2019 Ryle  Macaraig. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // step 12 - create variables and link them to sb
    @IBOutlet var lblID : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblBody : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var imgView : UIImageView!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // step 13 - create method below to populate details page
    // step 14 - move back to table view controller
    func updatePerson(getData : GetData, select : Int)
    {
        let rowData = (getData.dbData?[select])! as NSDictionary
       
        self.lblID.text = rowData["ID"] as? String
        self.lblTitle.text = rowData["title"] as? String
        self.lblBody.text = rowData["note"] as? String
        self.lblDate.text = rowData["date"] as? String
        self.imgView.image = UIImage(named : rowData["logo"] as! String)
        
        
        
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
