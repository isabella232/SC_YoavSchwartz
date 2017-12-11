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
import MapKit

final class MainMapViewController: UIViewController {

  // MARK: - Properties
  weak var delegate: MainMapViewControllerDelegate?
  var airports: [Airport]!

  // MARK: - IBOutlets
  @IBOutlet var mapView: MKMapView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self
    let annotations = airports.map(AirportAnnotation.init(airport:))
    mapView.addAnnotations(annotations)
  }
}

// MARK: - MKMapViewDelegate
extension MainMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation as? AirportAnnotation else {
      return
    }

    delegate?.mapView(self, didSelectAirport: annotation.airport)
  }

  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    guard let annotation = view.annotation as? AirportAnnotation else {
      return
    }

    delegate?.mapView(self, didDeselectAirport: annotation.airport)
  }
}
