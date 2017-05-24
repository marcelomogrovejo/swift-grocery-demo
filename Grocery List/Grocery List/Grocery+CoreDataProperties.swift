//
//  Grocery+CoreDataProperties.swift
//  Grocery List
//
//  Created by Marcelo Mogrovejo on 4/28/17.
//  Copyright © 2017 Marcelo Mogrovejo. All rights reserved.
//

import Foundation
import CoreData


extension Grocery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery");
    }

    @NSManaged public var item: String?

}
