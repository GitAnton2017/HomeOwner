//
//  AppDelegate.swift
//  HomeOwner
//
//  Created by Anton2016 on 15.10.17.
//  Copyright © 2017 Anton2016. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //MARK: - Setting-up Core Data Stack
    //MARK: - ****************************************************
    //MARK: - Setting-up Core Data MOM
    
    lazy var MOM : NSManagedObjectModel =
    {
     let mom_url = Bundle.main.url(forResource: "HomeOwner", withExtension: "momd")!
     return NSManagedObjectModel(contentsOf: mom_url)!
    } ()
    
    //MARK: - Setting-up Core Data PSC
    
    lazy var PSC : NSPersistentStoreCoordinator =
    {
     let psc = NSPersistentStoreCoordinator(managedObjectModel: self.MOM)
     let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     let db_url = urls.last!.appendingPathComponent("HomeOwner.sqlite")
     print (db_url)
     do
     {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: db_url , options: nil)
     }
     catch let error as NSError
     {
        print ("FATAL ERROR: \(error.userInfo)\nUnable to create persistent store at: \n\(db_url)")
        abort()
     }
     
     return psc
        
    } ()
    //MARK: - Setting-up Core Data MOC
    lazy var MOC : NSManagedObjectContext =
    {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator =  self.PSC
        return moc
    } ()
            
    func saveContext()
    {
      if MOC.hasChanges
      {
        do
        {
         try MOC.save()
        }
        catch let error as NSError
        {
            print ("FATAL ERROR: \(error.userInfo) - Unable to save context"); abort()
        }
      }
    }
    
    //MARK: -
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        print(#function)
        
        print(Bundle.main.bundlePath)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print(#function)
        print ("HomeOwner app is about to enter BG")
        print("Posting changes to Data Model....")
        
        saveContext()
        
        /*let rootVC = window!.rootViewController as! UINavigationController
        
        for vc in rootVC.viewControllers
        {
            if vc is ItemsViewController
            {
                let itemsVC = vc as! ItemsViewController
                let save_path = itemsVC.items.itemsArchiveURL.path
                
                if NSKeyedArchiver.archiveRootObject(itemsVC.items.itemsList, toFile: save_path)
                {
                    print("All items saved to path: \(save_path)")
                }
                else
                {
                    print("Unable to save items to: \(save_path)")
                }
                
                break
            }
        }*/
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print(#function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print(#function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print(#function)
        
        print ("HomeOwner app is about to terminate")
        print("Posting changes to Data Model....")
        
        saveContext()
    }


}

