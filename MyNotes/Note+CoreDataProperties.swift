//
//  Note+CoreDataProperties.swift
//  MyNotes
//
//  Created by student on 3/29/16.
//  Copyright © 2016 student. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    //The title, date and text attributes from the Note entity
    @NSManaged var title: String
    @NSManaged var date: String
    @NSManaged var text: String

}
