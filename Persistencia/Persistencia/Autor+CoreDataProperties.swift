//
//  Autor+CoreDataProperties.swift
//  Persistencia
//
//  Created by Timo Siegle on 03.07.16.
//  Copyright © 2016 Timo Siegle. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Autor {

    @NSManaged var nombre: String?
    @NSManaged var pertenece: Libro?

}
