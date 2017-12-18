/// Copyright (c) 2017 Razeware LLC
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

final class InformationCardViewController: UIViewController {

  // MARK: - Properties
  var headerViewController: UIViewController?
  var detailsViewController: UIViewController?
  /// Saves a reference to the curretly displayed airport
  var displayedAirport: Airport?

  /// Helper method to retrieve the main storyboard for the application
  private lazy var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

  // MARK: - IBOutlets
  @IBOutlet var headerContainerView: UIView!
  @IBOutlet var detailsContainerView: UIView!
}

// MARK: - Internal
extension InformationCardViewController {

  /// Updates the card view with a new Airport to display
  ///
  /// - Parameter airport: The Airport to display
  func displayDetails(for airport: Airport) {
    displayedAirport = airport
    switchHeaderView(for: airport)
    fetchAndDisplayData(for: airport)
  }
}

// MARK: - Private
private extension InformationCardViewController {

  /// Switches the header view to match an airport. This is done be replacing the UIViewController in the headerContainerView
  ///
  /// - Parameter airport: The Airport to display
  func switchHeaderView(for airport: Airport) {
    removeHeaderControllerIfNeeded()
    let headerViewController = mainStoryboard.instantiateViewController(withIdentifier: "AirportCardHeaderViewController") as! AirportCardHeaderViewController
    headerViewController.airportName = airport.code
    self.headerViewController = headerViewController
  }

  /// Switches the information view to match an airport. This is done be replacing the UIViewController in the infoContainerView.
  /// We first put in the loading view, and then when the data is ready, switch to a child view controller that can display it.
  /// - Parameter airport: The Airport to display
  func fetchAndDisplayData(for airport: Airport) {
    removeDetailsControllerIfNeeded()
    displayLoadingController()
    airport.getExtraInfo { [weak self] extraInfo in
      guard let strongSelf = self,
        let displayedAirport = strongSelf.displayedAirport,
        displayedAirport == airport else {
          return
      }

      strongSelf.removeDetailsControllerIfNeeded()
      strongSelf.displayAirportInformationController(extraAirportInformation: extraInfo)
    }
  }

  /// Shows the loading view controller in the informationContainerView
  func displayLoadingController() {
    let loadingViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoadingDetailsViewController")
    self.detailsViewController = loadingViewController
  }

  /// Shows the extra airport information view controller in the informationContainerView
  func displayAirportInformationController(extraAirportInformation: ExtraAirportInfo) {
    let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "ExtraAirportInformationViewController") as! ExtraAirportInformationViewController
    self.detailsViewController = detailsViewController
    detailsViewController.airportInfo = extraAirportInformation
  }

  /// Helper method to remove the current view controller in the header
  func removeHeaderControllerIfNeeded() {
    guard let headerViewController = headerViewController else {
      return
    }

  }

  /// Helper method to remove the current view controller in the deatils
  func removeDetailsControllerIfNeeded() {
    guard let detailsViewController = detailsViewController else {
      return
    }

  }
}
