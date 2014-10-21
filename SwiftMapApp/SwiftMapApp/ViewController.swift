//
//  ViewController.swift
//  WhereToDo
//
//  Created by Rodrigo Borges Soares on 07/10/14.
//  Copyright (c) 2014 Rodrigo Borges. All rights reserved.
//

import UIKit

import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var selectedLatitude: Double = 0.0
    var selectedLongitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self;

        var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPressDetected:"))
        longPressGestureRecognizer.minimumPressDuration = 1.0;

        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let mainDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var annotationArray = mainDelegate.databaseHandler.getAnnotations()
        
        for annotation in annotationArray {
            mapView.addAnnotation(annotation)
        }
        
        
    }
    
    func longPressDetected(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state != UIGestureRecognizerState.Began {
            return;
        }
        
        var point = recognizer.locationInView(mapView)
        
        var longPressPoint = mapView.convertPoint(point, toCoordinateFromView: self.view)
        
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(longPressPoint)
        annotation.title = "Add annotation"
        
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true);
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locationArray = locations as NSArray
        var currentLocation = locationArray.lastObject as CLLocation
        var currentLocationCoordinates = currentLocation.coordinate
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: currentLocationCoordinates, span: span)
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
            
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("didFailWithError: %@", error.description);
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        NSLog("selectedAnnotationView");
        
        var latitude: Double = view.annotation.coordinate.latitude as Double
        var longitude: Double = view.annotation.coordinate.longitude as Double
        
        self.selectedLatitude = latitude
        self.selectedLongitude = longitude

    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        NSLog("didDeselectAnnotationView");

    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Red
            pinView!.draggable = true;
            
            //let button : UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            //button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            //pinView!.rightCalloutAccessoryView = button
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func buttonClicked (sender : UIButton!) {
        
        performSegueWithIdentifier("AddToDoSegue", sender: self)
    
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddToDoSegue" {
        
            var addToDoViewController = segue.destinationViewController as AnnotationDetailsViewController
            addToDoViewController.latitude = selectedLatitude
            addToDoViewController.longitude = selectedLongitude
            
        }
        
    }
    


}

