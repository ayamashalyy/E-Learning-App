//
//  SceneDelegate.swift
//  E-Learning
//
//  Created by aya on 18/11/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let loadingVC = LoadingViewController()
        self.window?.rootViewController = loadingVC
        self.window?.makeKeyAndVisible()
        
        let session = UserSessionManager.shared
        let selectedTenant = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedTenant)
        
        if let token = session.token, !token.isEmpty {
            print("#debug: - User Token: \(String(describing: session.token))")
            
            let refreshTokenViewModel = RefreshTokenViewModel()
            print("#debug: - User Token: \(String(describing: session.token))")
            print("#debug: - Refresh Token: \(String(describing: session.refreshToken))")
            print("""
                              #debug: ===========================
                              """)
            refreshTokenViewModel.refreshToken(refreshToken: session.refreshToken!) { result in
                switch result {
                case .success(let response):
                    if let newToken = response.accessToken, let newRefreshToken = response.refreshToken {
                        session.token = newToken
                        session.refreshToken = newRefreshToken
                        session.role = response.role
                        
                        loadingVC.stopLoading()
                        
                        if response.role == "manager" {
                            print("DEBUG: Role is manager, navigating to CourseManagerViewController")
                            let managerVC = CourseManagerViewController()
                            let navigationController = UINavigationController(rootViewController: managerVC)
                            self.window?.rootViewController = navigationController
                        } else if response.role == "learner" {
                            print("DEBUG: Role is learner, navigating to TabBarViewController")
                            let mainViewController = TabBarViewController()
                            let navigationController = UINavigationController(rootViewController: mainViewController)
                            navigationController.setNavigationBarHidden(true, animated: false)
                            self.window?.rootViewController = navigationController
                        } else {
                            print("DEBUG: Unknown role: \(String(describing: response.role)), going to login")
                            self.gotoLoginPage()
                        }
                    }
                case .failure(let error):
                    print("#debug: failure - User Token: \(String(describing: session.token))")
                    print("#debug: failure - Refresh Token: \(String(describing: session.refreshToken))")
                    print("#debug: failure - \(error)")
                    loadingVC.stopLoading()
                    self.gotoLoginPage()
                }
            }
            
        } else if let tenant = selectedTenant, !tenant.isEmpty {
            loadingVC.stopLoading()
            gotoLoginPage()
        } else {
            loadingVC.stopLoading()
            let onboardingVC = OnboardingViewController()
            let navigationController = UINavigationController(rootViewController: onboardingVC)
            navigationController.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navigationController
        }
    }
    
    func gotoLoginPage(){
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigationController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

