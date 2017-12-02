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

class BackingViewController: UIViewController {

  var mainMapViewController: MainMapViewController!
  @IBOutlet var mapContainerView: UIView!

  var informationCardViewController: InformationCardViewController!
  @IBOutlet var cardContainerView: UIView!

  @IBOutlet var cardDownConstraint: NSLayoutConstraint!
  @IBOutlet var cardUpConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    applyCardCornerRadiusEffect()
    setCardPosition(.down, animated: false)
  }

  /// Sets the position of the card on the backing view
  ///
  /// - Parameters:
  ///   - position: The position to move the card to
  ///   - animated: Whether the change should be animated
  private func setCardPosition(_ position: CardPosition, animated: Bool) {
    switch position {
    case .up:
      cardDownConstraint.isActive = false
      cardUpConstraint.isActive = true
    case .down:
      cardUpConstraint.isActive = false
      cardDownConstraint.isActive = true
    }

    if animated {
      UIView.animate(withDuration: 0.1, animations: {
        self.view.layoutIfNeeded()
      })
    } else {
      self.view.layoutIfNeeded()
    }
  }

  /// Gives the card a iOS Maps feel by rounding corners
  private func applyCardCornerRadiusEffect() {
    cardContainerView.layer.cornerRadius = 20
    cardContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
  }

  /// Loads a list of airports from a JSON file
  ///
  /// - Returns: An array or Airport structs
  func getAirports() -> [Airport] {
    guard let path = Bundle.main.path(forResource: "airports", ofType: "json") else { fatalError("Add json file") }
    do {
      let url = URL(fileURLWithPath: path)
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let airports = try decoder.decode([Airport].self, from: data)
      return airports
    } catch {
      print(error)
      fatalError("json should always parse from file")
    }
  }

  // MARK: - Navigation

  // Prepare for segue, is a good place to save your child view controllers. Remember that Embed Segues are just like any other Segue.
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let destination as MainMapViewController:
      destination.airports = getAirports()
      destination.delegate = self
      mainMapViewController = destination
    case let destination as InformationCardViewController:
      informationCardViewController = destination
    default: break
    }
  }

  enum CardPosition {
    case up
    case down
  }
}

extension BackingViewController: MainMapViewControllerDelegate {
  func mapView(_ mapView: MainMapViewController, didSelectAirport airport: Airport) {
    informationCardViewController.displayDetails(for: airport)
    setCardPosition(.up, animated: true)
  }

  func mapView(_ mapView: MainMapViewController, didDeselectAirport airport: Airport) {
    setCardPosition(.down, animated: true)
  }
}
