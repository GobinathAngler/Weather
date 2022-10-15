//
//  BookMarkList.swift
//  weatherTasks
//
//  Created by Premkumar Arul on 15/10/22.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

class BookMarkList : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var cityListTbl: UITableView!
    var storedDataArray = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To Fetch From CoreData
        fetchData()
    }
    
    func fetchData() {
        storedDataArray.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewBookMarks")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        request.returnsObjectsAsFaults = true
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                storedDataArray.append(data)
            }
            print("The count = \(storedDataArray.count)")
        } catch {
            print("Failed")
        }
        cityListTbl.reloadData()
    }
    
    
    //MARK: Table View Delegates & Datasources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarksCell", for: indexPath) as! BookMarksCell
        let cityNameForRow = storedDataArray[indexPath.row]
        cell.citiesTitleLbl.text = cityNameForRow.value(forKey: "cityAddress") as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityNameForRow = storedDataArray[indexPath.row]
        let actualAddress = cityNameForRow.value(forKey: "cityAddress") as? String ?? ""

        //Navigate to Weather Report
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let wRVC = storyBoard.instantiateViewController(withIdentifier: "WRVC") as! WeatherReportViewController
        wRVC.SelectedCityLoc = actualAddress
        self.navigationController?.pushViewController(wRVC, animated: true)
        
        
    }
    
}
