//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 www.ixx.com. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {

    // MARK: Properties
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleMeals()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedMeals = loadMeals() {
            
            meals += savedMeals
        }else {
            loadSampleMeals()
        }
        
     }

    func loadSampleMeals() {
        
        let photo1 = UIImage(named: "meal1")
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        meals += [meal1, meal2, meal3]
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = "MealTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            if let selectedMealCell = sender as? MealTableViewCell {
                
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                
                let selectedMeal = meals[indexPath.row]
                
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                meals[selectedIndexPath.row] = meal
                
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: UITableViewRowAnimation.None)
            }else {
                
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                
                meals.append(meal)
                
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                
                
            }
            saveMeals()
        }
    }
    
    // override to support editing the table view
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            meals.removeAtIndex(indexPath.row)
            
            saveMeals()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }else if editingStyle == UITableViewCellEditingStyle.Insert {
            
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    
    // MAKR: NSCoding
    func saveMeals() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() ->[Meal]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }
}
