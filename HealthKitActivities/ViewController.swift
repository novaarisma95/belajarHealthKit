//
//  ViewController.swift
//  HealthKitActivities
//
//  Created by Nova Arisma on 9/18/19.
//  Copyright © 2019 Nova Arisma. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here. Like process the data etc
            requestPermission()
        }
        // Do any additional setup after loading the view.
    }
    //izin ambil data
    func requestPermission () {
        ///Only request permission if it needed
        ///This function handle show the app asking for permission to read and share energy burned, cycling distance, walking or running distance, and heart rate samples.
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])
        //toShare:nil kalo cuma pengen nge read data doang. Kalo pengen ngubah jg tinggal ganti jd allTypes
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                // Handle the error here.
                fatalError("Your arenot allowed to the health data")
            } else {
                print ("Success")
            }
        }
    }
    //ambil data BMI dari health app
    func getBMIHealthData() {
        
        //sampleType
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyMassIndex)else {return}
        //predicate?
        
        //limit
        let limit = 1
        
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: limit, sortDescriptors: nil) { (sampleQuery, results, error)
            in
            
            guard let samples = results as? [HKQuantitySample] else {return}
            
            DispatchQueue.main.async {
                for sample in samples {
                    let bmi = sample.quantity.doubleValue(for: .count())
                    print(bmi)
                }
            }
        }
        
        healthStore.execute(sampleQuery)
    }
    
    func getBMIData() {
        let calendar = NSCalendar.current
        let now = NSDate()
        let components = calendar.dateComponents([.year,.day,.month], from: now as Date)
        
        guard let startDate = calendar.date(from:components) else {
            fatalError("*** Unable to create the start date ***")
        }
        
        let endDate = calendar.date(byAdding: components, to: startDate)
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyMassIndex) else {
            fatalError("*** This method should never fail ***")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        //        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
            }
            
            DispatchQueue.main.async {
                for sample in samples {
                    let bmi = sample.quantity.doubleValue(for: HKUnit.count())
                }
            }
        }
        
        healthStore.execute(query)
        
    }
    
    func getStepCountData() {
        
        //sampleType
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .bodyMassIndex)else {return}
        //predicate?
        
        //limit
        let limit = 5
        
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: limit, sortDescriptors: nil) { (sampleQuery, results, error)
            in
            
            guard let samples = results as? [HKQuantitySample] else {return}
            
            DispatchQueue.main.async {
                for sample in samples {
                    let bmi = sample.quantity.doubleValue(for: .count())
                    print(bmi)
                }
            }
        }
        
        healthStore.execute(sampleQuery)
}





