//
//  LocationHelper.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 17/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import CiyaShopSecurityFramework
import SwiftyJSON

class LocationHelper: NSObject
{
    var latitude : String?
    var longitude : String?
    
    var location : String?
    var locationManager : CLLocationManager?
    var geocoder : CLGeocoder?
    var placemark : CLPlacemark?
    var oldLocation : CLLocation?
    var locationStatus : NSString?
    var storeLocation = CLLocation(latitude: storeLocationLatitude, longitude: storeLocationLongitude)
    class var sharedInstance: LocationHelper
    {
        struct Singleton {
            static let instance = LocationHelper()
        }
        return Singleton.instance
    }
    
}


//MARK:- CLLocationManager delegate methods

extension LocationHelper : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        var shouldIAllow = false

        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            self.locationManager!.requestWhenInUseAuthorization()
            self.locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager!.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(String(describing: locationStatus))")
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let newLocation = locations.last
        
        geocoder?.reverseGeocodeLocation(newLocation!, completionHandler: { (placemarks, error) in
            
            if(error == nil && placemarks!.count > 0)
            {
                self.placemark = placemarks?.last
                let lati = "\(newLocation!.coordinate.latitude)"
                let longi = "\(newLocation!.coordinate.longitude)"
                
                if(Int((newLocation?.distance(from: self.storeLocation))!) < Int(DistanceForLocationUpdate))
                {
                    self.oldLocation = newLocation
                    self.latitude=lati
                    self.longitude=longi
                    
                    //calling api here
                    self.changeLocation()
                    print("Location changed")
                }else{
                    isNotifyForGeoFence = false

                }
                
            }else{
                print("Error:: ",error ?? "errors")
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Cannot find the location.")
        self.latitude = "0"
        self.longitude = "0"
    }
}

//MARK:- Methods
extension LocationHelper
{
    func updateLocation()
    {
        if CLLocationManager.locationServicesEnabled() {
            //Location Services Enabled
            if CLLocationManager.authorizationStatus() == .denied {
                print("Please go to Settings and turn on Location Service for this app.")
            }

            //enable location
            geocoder = CLGeocoder()
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager!.desiredAccuracy = kCLLocationAccuracyBest
                locationManager!.delegate = self
                locationManager!.requestWhenInUseAuthorization()
            }
            locationManager!.startUpdatingLocation()
        }else{
            print("Please enable Location Service for this app.")
        }
    }
    
    func stopUpdateLocation()
    {
        locationManager?.stopUpdatingLocation()
    }
    func TriggerLocalNotification()
    {
        let notificationContent = UNMutableNotificationContent()

        // Add the content to the notification content
        notificationContent.title = APP_NAME
        notificationContent.body = strGeoFencingMessage
        notificationContent.badge = NSNumber(value: 1)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification",content: notificationContent, trigger: trigger)
        let userNotificationCenter = UNUserNotificationCenter.current()

//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
    }
}
//MARK:- API call
extension LocationHelper
{
    func changeLocation()
    {
        if(isNotifyForGeoFence)
        {
            self.TriggerLocalNotification()
        }
    }
    
}
