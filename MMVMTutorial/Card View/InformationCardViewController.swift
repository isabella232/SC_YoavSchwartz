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

class InformationCardViewController: UIViewController {

  @IBOutlet var headerContainerView: UIView!
  @IBOutlet var detailsContainerView: UIView!

  var headerViewController: UIViewController?
  var detailsViewController: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /// Saves a reference to the curretly displayed airport
  var displayedAirport: Airport?

  /// Updates the card view with a new Airport to display
  ///
  /// - Parameter airport: The Airport to display
  func displayDetails(for airport: Airport) {
    displayedAirport = airport
    switchHeaderView(for: airport)
    fetchAndDisplayData(for: airport)
  }

  /// Switches the header view to match an airport. This is done be replacing the UIViewController in the headerContainerView
  ///
  /// - Parameter airport: The Airport to display
  private func switchHeaderView(for airport: Airport) {
    removeHeaderControllerIfNeeded()
    let headerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AirportCardHeaderViewController") as! AirportCardHeaderViewController
    headerVC.airportName = airport.code
    headerViewController = headerVC
    embedChildController(headerVC, in: headerContainerView)
  }

  /// Switches the information view to match an airport. This is done be replacing the UIViewController in the infoContainerView.
  /// We first put in the loading view, and then when the data is ready, switch to a child view controller that can display it.
  /// - Parameter airport: The Airport to display
  private func fetchAndDisplayData(for airport: Airport) {
    removeDetailsControllerIfNeeded()
    displayLoadingController()
    airport.getExtraInfo { [weak self] extraInfo in
      guard let strongSelf = self else { return }
      guard let displayedAirport = strongSelf.displayedAirport, displayedAirport == airport else { return }
      strongSelf.removeDetailsControllerIfNeeded()
      strongSelf.displayAirportInformationController(extraAirportInformation: extraInfo)
    }
  }

  /// Shows the loading view controller in the informationContainerView
  private func displayLoadingController() {
    let loadingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingDetailsViewController")
    detailsViewController = loadingVC
    embedChildController(loadingVC, in: detailsContainerView)
  }

  /// Shows the extra airport information view controller in the informationContainerView
  private func displayAirportInformationController(extraAirportInformation: ExtraAirportInfo) {
    let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExtraAirportInformationViewController") as! ExtraAirportInformationViewController
    detailsViewController = detailsVC
    detailsVC.airportInfo = extraAirportInformation
    embedChildController(detailsVC, in: detailsContainerView)
  }

  /// Helper method to remove the current view controller in the header
  private func removeHeaderControllerIfNeeded() {
    if let headerViewController = headerViewController {
      removeChildController(headerViewController)
    }
  }

  /// Helper method to remove the current view controller in the deatils
  private func removeDetailsControllerIfNeeded() {
    if let detailsViewController = detailsViewController {
      removeChildController(detailsViewController)
    }
  }
}
