//
//  AppDelegate.swift
//  ContactTracing
//
//  Created by Jennifer Finaldi on 11/23/20.
//

import UIKit
import UserNotifications
import PushKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    //The following four functions are attributed to
    //https://github.com/spaceotech/BackgroundTask/blob/master/SOBackgroundTask/Application/AppDelegate.swift
    
    //register background tasks, for using location fetching in background
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.CT.locationFetcher", using: nil) { task in
        //This task is cast with processing request (BGProcessingTask)
        
            self.handleLocationFetcherTask(task: task as! BGProcessingTask)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleLocationFetcher()
    }
    
    //IM NOT ACTUALLY SURE IF WE NEED THIS. IT WAS ADDED TO ENSURE THAT
    //OUR BACKGROUND STUFF WILL HOPEFULLY STILL OPERATE EVEN WHEN THE
    //USER IS USING THE APP
    func applicationWillEnterForeground(_ application: UIApplication) {
        scheduleLocationFetcher()
    }
    
    func scheduleLocationFetcher() {
        let request = BGProcessingTaskRequest(identifier: "com.CT.locationFetcher")
        request.requiresNetworkConnectivity = true //the task needs network processing
        request.requiresExternalPower = false
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 5) //get location after 5 min
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule location fetch.")
        }
    }
    
    private func handleLocationFetcherTask(task: BGProcessingTask) {
        scheduleLocationFetcher() //schedule the location fetch
        
        //I'm assuming this is the stuff we do when the timer expires??
        task.expirationHandler = {
            //This Block call by System
            //Cancel your all tasks & queues
        }
        
        /* THIS IS THE TUTORIAL CODE
        I DON"T KNOW IF THIS IS WHERE WE ACTUALLY PULL LOCATION FROM.
        IF IT IS, I DON'T KNOW HOW TO SET UP LOCATION SERVICES FROM
        ANYWHERE OTHER THAN A VC inside viewDidLoad(). AND I DON"T KNOW
        IF I CAN REQUEST THE VC TO DO IT FOR ME FROM HERE, ESPECIALLY
        IF THE APP IS RUNNING IN THE BACKGROUND
        //Get & Set New Data
        let interator =  ListInterator()
        let presenter =  ListPresenter()
        presenter.interator = interator
        presenter.setNewData()
        */
                
        
        task.setTaskCompleted(success: true)
        
    }

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let token = deviceToken.map{String(format: "%02.2hhx", $0)}.joined()
		print("token: \(token)")
		UserDefaults().setValue(token, forKey: "deviceToken")
		UserDefaults().synchronize()
	}

	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("error: \(error)")
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .sound])
	}
	
    static let dangerMessage = Notification.Name("DangerMessage")
    
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		if response.notification.request.identifier == "" {
			print("handling")
		}
		completionHandler()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //Post a notification to the Home VC to output modal
        NotificationCenter.default.post(name: AppDelegate.dangerMessage, object: nil)
	}


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
			print("granted: \(granted)")
		})
        
        registerBackgroundTask()
		
		UIApplication.shared.registerForRemoteNotifications()
		UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
		UIApplication.shared.applicationIconBadgeNumber = 0
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

