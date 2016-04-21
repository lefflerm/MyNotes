//
//  MyNotesTableViewController.swift
//  MyNotes
//
//  Created by student on 3/29/16.
//  Copyright © 2016 student. All rights reserved.

// Created to go along with the TableViewController made in the storyboard
// This is making the TVC functional
//

import UIKit
import CoreData //importing core data so we can actually WORK WITH the coredata

class MyNotesTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext! //the managed object context. we were allowed to be passed it because of the work we did in the appdelegate
    
    var notes = [Note] () //an array of notes, our whole pile of these note objects

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //actually creating the add button! :D
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNote:")
        
        //time to call the helper :D gotta make sure the data is FRESH
        reloadData()
        
        title = "Current Notes: " + String(notes.count)
        
        

    }
    
    //Helper method! For reloading data for viewing
    func reloadData() {
        //fetch request for data from note entity
        let fetchRequest = NSFetchRequest(entityName: "Note")
        
        //time to execute that fetch request. do catch for catching error it could throw
        do {
            //we had to cast the fetch request results as a Note type
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Note] {
                notes = results //if it doesnt throw the error save the info :D
                tableView.reloadData() //this is not the same reload data as we are creating
            }
        } catch {
            fatalError("There was an error fetching notes!") //mm error messages
        }
    }
    
    //Our add note fuction
    func addNote(sender: AnyObject?) {
        //Create a reference to the alert controller
        let alert = UIAlertController(title: "Add", message: "Note", preferredStyle: .Alert)
        
        //define action for the add action
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action) -> Void in
            
            //This is a wall of text. Saving references to the text fields if a non-empty string was entered in the text fields. Then a reference to the note entity so we can insert into it and then get the text field info and assign it to temp variables
            if let titleTextField = alert.textFields?[0], dateTextField = alert.textFields?[1], textTextField = alert.textFields?[2], noteEntity = NSEntityDescription.entityForName("Note", inManagedObjectContext: self.managedObjectContext), title = titleTextField.text, date = dateTextField.text, text = textTextField.text {
                //here we mate a note object at last
                let newNote = Note(entity: noteEntity, insertIntoManagedObjectContext: self.managedObjectContext)
                //filling in the info to the note object
                newNote.title = title
                newNote.date = date
                newNote.text = text
                
                //saving the nsmanaged object context or throwing an error if we cant
                do{
                    try self.managedObjectContext.save()
                    self.viewDidLoad()
                } catch {
                    print("Error saving the managed object context!")
                }
                
                //finally we reload the data
                self.reloadData()
            }
            
        }
        
        //define cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
        
            //mmmm nice simple cancel action. Doing nothing is nice and easy
        }
        
        //add the alert text fields for title, date, and text
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Title" }
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Date" }
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Text" }
        
        
        //add the buttons to the alert
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        //present view controller
        presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // The number of sections in our table view - we want 1
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is how many rows to display, we want as many as there are notes so we use our notes array's count
        return notes.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
        // We had to uncomment this :D also man I gave my cell the most obvious name X3
        //Time to configure this nonsense!!! We want it to set things where they belong, after all
        //Each cell should have the title date and text. I'm putting title and date on the same line since text feels like it is most important and needs the full line 
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title + " - " + note.date
        cell.detailTextLabel?.text = note.text

        return cell
    }


    //These two methods allow for deleting. The first we just had to uncomment so it can return true and let us edit
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   

  
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //emptied the text out of this method and added our own code :D
            let note = notes[indexPath.row] //this is the note we are currently swiping left on to delete
            managedObjectContext.deleteObject(note) //deleting said note
            
            //saving the managed object context, like ya do
            do{
                try self.managedObjectContext.save()
                self.viewDidLoad()
            } catch {
                print("Error saving managed object context!")
            }
            
            //reloading data so you can tell that your delete went through
            reloadData()
        } //got rid of the else if cause it wasn't necessary
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
