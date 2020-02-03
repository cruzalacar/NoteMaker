//
//  TableViewController.swift
//  PlannerApp
//
//  Created by Murtaza on 2019-12-02.
//  Copyright © 2019 Ryle  Macaraig. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController{
    
    // step 6 - create variables below
    // connect table to sb
    let getData = GetData()
    var timer : Timer!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var myTable : UITableView!
    
    // step 7 call json parser from getData
    // step 8 start a timer to repeat until length of json array
    // is greater than zero (meaning data is finished downloading)
    // then refresh the table and disable the timer
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true);
        
        getData.jsonParser()
        
        
    }
 
    // swift 4 update
    @objc func refreshTable(){
        if(getData.dbData != nil)
        {
        if (getData.dbData?.count)! > 0
        {
            self.myTable.reloadData()
            self.timer.invalidate()
        }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // step 9 - delete extra table methods and set method below to return 1 table
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // step 10 set number of rows to length of dictionary array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if getData.dbData != nil
        {
            return (getData.dbData?.count)!
        }
        else
        {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        // step 11 - configure cell, then move on to DetailsViewController
        // don't forget cell identifier in sb
      let tableCell : MyDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? MyDataTableViewCell ?? MyDataTableViewCell(style: .default, reuseIdentifier: "myCell")

        let row = indexPath.row
        let rowData = (getData.dbData?[row])! as NSDictionary
        tableCell.myLogo.image = UIImage(named: "yellow.jpg")
        tableCell.myName.text = rowData["title"] as? String

        

        return tableCell
    }
 
    // step 14 - configure didselectrow to call update person
    // method from details view controller
    // done - now run the project
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            let detailViewController = controllers[controllers.count-1]
                as? DetailsViewController
            mainDelegate.data = getData
            detailViewController?.updatePerson(getData: getData, select: indexPath.row)
            
                
            
        }
        

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
