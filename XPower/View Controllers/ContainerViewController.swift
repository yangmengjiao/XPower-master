//
//  ContainerViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/8/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var centerNavigationController: UINavigationController!
    var loginViewController: LoginViewController!
    var sideMenuViewController: SideMenuViewController?
    var homeViewController:HomeViewController!
    var leftPanelExpanded:Bool = false
    let centerPanelExpandedOffset: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewController = UIStoryboard.homeViewController()
        homeViewController.viewControllerDelegate = self
        centerNavigationController = UINavigationController(rootViewController: homeViewController)
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        centerNavigationController.didMove(toParent: self)
    }

}
private extension UIStoryboard {
  static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
  static func sideMenuViewController() -> SideMenuViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
  }
  static func homeViewController() -> HomeViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
  }
  
  static func loginViewController() -> LoginViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
  }
    static func pointsTabBarController() -> PointsTabBarController? {
      return mainStoryboard().instantiateViewController(withIdentifier: "PointsTabBarController") as? PointsTabBarController
    }
    static func scoreViewController() -> ScoreViewController? {
      return mainStoryboard().instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController
    }
    static func friendListViewController() -> FriendListViewController? {
         return mainStoryboard().instantiateViewController(withIdentifier: "FriendListViewController") as? FriendListViewController
       }
    static func settingsViewController() -> SettingsViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
    }
}
extension ContainerViewController: HomeViewControllerDelegate,SidePanelViewControllerDelegate {
    func didSelectMenu(VC: Menu) {
        var viewController:XpowerViewController?
        
        switch VC.menuName {
        case .home:
            viewController = UIStoryboard.homeViewController()
            viewController?.viewControllerDelegate = self
            centerNavigationController = UINavigationController(rootViewController: viewController!)
        case .points:
            let pointsViewController = UIStoryboard.pointsTabBarController()
            pointsViewController?.viewControllerDelegate = self
            centerNavigationController = UINavigationController(rootViewController: pointsViewController!)
        case .score:
            viewController = UIStoryboard.scoreViewController()
            viewController?.viewControllerDelegate = self
            centerNavigationController = UINavigationController(rootViewController: viewController!)
        case .friends:
            viewController = UIStoryboard.friendListViewController()
            viewController?.viewControllerDelegate = self
            centerNavigationController = UINavigationController(rootViewController: viewController!)
        case .settings:
            viewController = UIStoryboard.settingsViewController()
            viewController?.viewControllerDelegate = self
            centerNavigationController = UINavigationController(rootViewController: viewController!)
        case .logout:
            Utilities.logOutUser()
            setLoginController()
        }
       
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        centerNavigationController.didMove(toParent: self)
        toggleLeftPanel()
    }
    func setLoginController()  {
        let loginViewController = UIStoryboard.loginViewController()
        let loginNavigationController = UINavigationController(rootViewController: loginViewController!)
        loginNavigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = loginNavigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    func toggleLeftPanel() {
        if !leftPanelExpanded {
            addLeftPanelViewController()
        }
         
         animateLeftPanel(shouldExpand: !leftPanelExpanded)
        
    }
    func animateLeftPanel(shouldExpand: Bool) {
      if shouldExpand {
        leftPanelExpanded = true
        animateCenterPanelXPosition(
          targetPosition: centerNavigationController.view.frame.width
            - centerPanelExpandedOffset)
        showShadowForCenterViewController(leftPanelExpanded)
      } else {
        leftPanelExpanded = false
        animateCenterPanelXPosition(targetPosition: 0) { _ in
         
          self.sideMenuViewController?.view.removeFromSuperview()
          self.sideMenuViewController = nil
        }
      }
    }
    func animateCenterPanelXPosition(
        targetPosition: CGFloat,
        completion: ((Bool) -> Void)? = nil) {
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: .curveEaseInOut,
        animations: {
          self.centerNavigationController.view.frame.origin.x = targetPosition
        },
        completion: completion)
    }
    func collapseSidePanels() {
        if leftPanelExpanded {
            toggleLeftPanel()
        }
    }
    func addLeftPanelViewController() {
      guard sideMenuViewController == nil else { return }

      if let vc = UIStoryboard.sideMenuViewController() {
       
        addChildSidePanelController(vc)
        sideMenuViewController = vc
        sideMenuViewController?.delegate = self
      }
    }
    func addChildSidePanelController(_ sidePanelController: SideMenuViewController) {
      view.insertSubview(sidePanelController.view, at: 0)
      addChild(sidePanelController)
      sidePanelController.didMove(toParent: self)
    }
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
      if shouldShowShadow {
        centerNavigationController.view.layer.shadowOpacity = 0.8
      } else {
        centerNavigationController.view.layer.shadowOpacity = 0.0
      }
    }
}
