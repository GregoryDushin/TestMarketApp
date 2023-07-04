import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        categoryViewController.viewModel = CategoryViewModel()
        self.window?.rootViewController = categoryViewController
        self.window?.makeKeyAndVisible()

        return true
    }
}
