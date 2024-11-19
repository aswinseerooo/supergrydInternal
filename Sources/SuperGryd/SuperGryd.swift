import Foundation
import SwiftUI
import UIKit

public class SuperGryd {
    
    public static func greet(name: String) -> String {
        return "Hello, \(name)!"
    }
    
    // Public method for initialization
    public static func provideAPIKey(clientID: String, clientSecret: String) {
        let authentication = Authentication.shared
        authentication.authenticate(clientId: clientID, clientSecret: clientSecret)
    }
    
    public static func initialize(from viewController: UIViewController? = nil, navigationController: UINavigationController? = nil) {
        // Perform authentication logic here (e.g., API call)
        
        // Create SwiftUI view
        let homeView = LocationSelectingView()
        
        // Create a UIHostingController to wrap the SwiftUI view
        let hostingController = UIHostingController(rootView: homeView)
        
        // UIKit: If a navigation controller is provided, push the view controller
        if let navigationController = navigationController {
            print("Navigation Controller View")
            navigationController.pushViewController(hostingController, animated: true)
        }
        // UIKit: If no navigation controller is provided, fallback to presenting modally
        else if let viewController = viewController {
            print("No Navigation Controller View")
            hostingController.modalPresentationStyle = .fullScreen
            viewController.present(hostingController, animated: true, completion: nil)
        }
        // SwiftUI: Handle by presenting the view modally as a fallback (the host app should handle navigation)
        else {
            print("SwiftUI View")
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            if  let topViewController = windowScene?.windows.first?.rootViewController {
                hostingController.modalPresentationStyle = .fullScreen
                topViewController.present(hostingController, animated: true, completion: nil)
            }
        }
    }
}
