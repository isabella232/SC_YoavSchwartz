///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

extension UIViewController {

  /// Add a child UIViewController and constraints and add it as a subview of a selected UIView
  /// The order at which all these calls are called is important. We therefore make a helper method to help us avoid mistakes and stay DRY
  /// - Parameters:
  ///   - childController: The child UIViewController to add
  ///   - containerView: The view where the child UIViewController's view should be set in
  func embedChildController(_ childController: UIViewController, in containerView: UIView) {
    self.addChildViewController(childController)
    childController.view.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(childController.view)
    childController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    childController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    childController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    childController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    childController.didMove(toParentViewController: self)
  }

  /**
   Removes a child controller from its parent.
   It is very important to do all steps, and they are easy to forget, therefore we define an extension on UIViewController to help.
   - Parameter childController: the child UIViewController to remove.
   */
  func removeChildController(_ childController: UIViewController) {
    childController.willMove(toParentViewController: nil)
    childController.view.removeFromSuperview()
    childController.removeFromParentViewController()
  }
}
