//
//  DatabaseHandler.swift
//  SwiftMapApp
//
//  Created by Rodrigo Borges Soares on 20/10/14.
//  Copyright (c) 2014 Rodrigo Borges. All rights reserved.
//

import Foundation

import MapKit

class DatabaseHandler {
    var dbFilePath: NSString = NSString()
    
    func initializeDb() {
        
        createDb()
        
        // Initialize FMDB
        let db: FMDatabase = FMDatabase(path:dbFilePath)
        
        if db.open() {
            NSLog("Database was successfully open")
        } else {
            NSLog("Error while opening database")
        }
        
        // Create table
        let createTableSQL = "CREATE TABLE IF NOT EXISTS annotation (id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, latitude REAL, longitude REAL)";
        
        var success = db.executeUpdate(createTableSQL, withArgumentsInArray:nil)
        
        if success {
            NSLog("Annotation table created")
        } else {
            NSLog("Error while creating annotation table: \(db.lastErrorMessage())")
        }
    }
    
    func insertAnnotation(description: String, latitude: Double, longitude: Double) -> Bool {
        let db: FMDatabase = FMDatabase(path:dbFilePath)
        
        if !db.open() {
            NSLog("Error while opening database")
        }
        
        let addQuery = "INSERT INTO annotation (description, latitude, longitude) VALUES ('\(description)', \(latitude), \(longitude))"
        
        let insertionResult = db.executeUpdate(addQuery, withArgumentsInArray: nil)

        return insertionResult;
    }
    
    func getAnnotations() -> [MKPointAnnotation] {
        // initialize FMDB
        let db: FMDatabase = FMDatabase(path:dbFilePath)
        
        var annotationArray = [MKPointAnnotation]()
        
        if !db.open() {
            NSLog("Error while opening database")
        }
        
        let mainQuery = "SELECT description, latitude, longitude FROM annotation"
        let rsMain: FMResultSet? = db.executeQuery(mainQuery, withArgumentsInArray: [])
        
        while (rsMain!.next() == true) {
            let description = rsMain?.stringForColumn("description")
            let latitude = rsMain?.doubleForColumn("latitude")
            let longitude = rsMain?.doubleForColumn("longitude")
            
            let latitudeLocationDegrees: CLLocationDegrees = CLLocationDegrees(latitude!)
            let longitudeLocationDegrees: CLLocationDegrees = CLLocationDegrees(longitude!)
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudeLocationDegrees, longitude: longitudeLocationDegrees)
            
            let annotation = MKPointAnnotation()
            annotation.setCoordinate(coordinate)
            annotation.title = description

            annotationArray.append(annotation)
            
            
        }

        return annotationArray
    }
    

    // MARK: - FMDB
    
    let DATABASE_RESOURCE_NAME = "swiftmapapp"
    let DATABASE_RESOURCE_TYPE = "sqlite"
    let DATABASE_FILE_NAME = "swiftmapapp.sqlite"
    
    func createDb() -> Bool {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let dbfile = "/" + DATABASE_FILE_NAME;
        
        self.dbFilePath = documentFolderPath.stringByAppendingString(dbfile)
        
        let filemanager = NSFileManager.defaultManager()
        if (!filemanager.fileExistsAtPath(dbFilePath) ) {
            
            let backupDbPath = NSBundle.mainBundle().pathForResource(DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE)
            
            if (backupDbPath == nil) {
                return false
            } else {
                var error: NSError?
                let copySuccessful = filemanager.copyItemAtPath(backupDbPath!, toPath:dbFilePath, error: &error)
                if !copySuccessful {
                    println("copy failed: \(error?.localizedDescription)")
                    return false
                }
                
            }
            
        }
        return true
        
    }
}