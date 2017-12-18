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

import Foundation
import CoreLocation

typealias ExtraAirportInfo = (name: String, city: String, country: String)

struct Airport: Codable {

  // MARK: - Properties
  let code: String

  /// JSON is not strictly correct, as the lat should be a num
  private let lat: String
  /// JSON is not strictly correct, as the lat should be a num
  private let lon: String

  var latitude: CLLocationDegrees {
    return Double(lat)!
  }

  var longitude: CLLocationDegrees {
    return Double(lon)!
  }

  fileprivate let name: String
  fileprivate let city: String
  fileprivate let country: String
}

// MARK: - Equatable
extension Airport: Equatable {

  static func == (lhs: Airport, rhs: Airport) -> Bool {
    guard lhs.code == rhs.code else { return false }
    guard lhs.latitude == rhs.latitude else { return false }
    guard lhs.longitude == rhs.longitude else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.city == rhs.city else { return false }
    guard lhs.country == rhs.country else { return false }

    return true
  }
}

// MARK: - Internal
extension Airport {

  /// This is meant to imitate a network fetch
  ///
  /// - Parameter completion: Called after a delay with the extra information on the airport
  func getExtraInfo(completion: @escaping ((ExtraAirportInfo) -> Void)) {
    let info = ExtraAirportInfo(name: name, city: city, country: country)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      completion(info)
    }
  }
}
