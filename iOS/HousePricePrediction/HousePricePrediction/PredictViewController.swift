//
//  PredictViewController.swift
//  HousePricePrediction
//
//  Created by Nattagan Ananpech on 23/11/19.
//  Copyright © 2019 nooch. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PickerView
import CDAlertView
import MapKit
class PredictViewController: UIViewController {
    @IBOutlet weak var tfBathroom: SkyFloatingLabelTextField!
    @IBOutlet weak var tfBedroom: SkyFloatingLabelTextField!
    @IBOutlet weak var tfLandSpace: SkyFloatingLabelTextField!
    @IBOutlet weak var tfFloor: SkyFloatingLabelTextField!
    @IBOutlet weak var tfWaterfront: SkyFloatingLabelTextField!
    @IBOutlet weak var tfView: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCondition: SkyFloatingLabelTextField!
    @IBOutlet weak var tfGrade: SkyFloatingLabelTextField!
    @IBOutlet weak var tfAbove: SkyFloatingLabelTextField!
    @IBOutlet weak var tfBasement: SkyFloatingLabelTextField!
    @IBOutlet weak var tfYearBuilt: SkyFloatingLabelTextField!
    @IBOutlet weak var tfRenovated: SkyFloatingLabelTextField!
    
    @IBOutlet weak var switchBtn: UISwitch!
    
    @IBOutlet weak var hMapConst: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    
    var currentLocation = CLLocation()
    var textFields: [SkyFloatingLabelTextField] = []
    
    let housePricer = HousePricer()
    let housePricerLatLong = HouseLatLongPricer()
    
    let lightGreyColor: UIColor = UIColor(red: 197 / 255, green: 205 / 255, blue: 205 / 255, alpha: 1.0)
    let darkGreyColor: UIColor = UIColor(red: 52 / 255, green: 42 / 255, blue: 61 / 255, alpha: 1.0)
    let overcastBlueColor: UIColor = UIColor(red: 0, green: 187 / 255, blue: 204 / 255, alpha: 1.0)
    
    let bedrooms: [String] = {
         var numbers = [String]()
         
         for index in 0...100 {
             numbers.append(String(index))
         }

         return numbers
     }()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapContentView: UIView!
    //มองเห็นแม่น้ำ Y, N
    let waterfronts = ["No waterfront", "Waterfront"]
    
    //ทิวทัศน์ 0-4
    let views = ["Poor", "Fair", "Average", "Good", "Excellent"]
    
    //สภาพบ้าน 1-5
    let conditions = ["Poor", "Fair", "Average", "Good", "Excellent"]
        
        //การก่อสร้างและdesign
    //    1-3 fall
    //    7 average
    //    11-13 high quality
    let grades: [String] = {
        var numbers = [String]()
        for index in 1...13 {
            numbers.append(String(index))
        }
        return numbers
    }()

    let yearbuild: [String] = {
        var numbers = [String]()
        for index in 1900...2015 {
            numbers.append(String(index))
        }
        return numbers
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    let renovated = ["No", "Yes"]

    
    @IBOutlet weak var mapIconImage: UIImageView!
    let theme = YBTextPickerAppearanceManager.init (
           pickerTitle         : "Pick item",
           titleFont           : UIFont.boldSystemFont(ofSize: 16),
           titleTextColor      : .white,
           titleBackground     : nil,
           searchBarFont       : UIFont.systemFont(ofSize: 16),
           searchBarPlaceholder: "Search",
           closeButtonTitle    : "Cancel",
           closeButtonColor    : .darkGray,
           closeButtonFont     : UIFont.systemFont(ofSize: 16),
           doneButtonTitle     : "Okay",
           doneButtonColor     : nil,
           doneButtonFont      : UIFont.boldSystemFont(ofSize: 16),
           checkMarkPosition   : .Right,
           itemCheckedImage    : nil,
           itemUncheckedImage  : nil,
           itemColor           : .black,
           itemFont            : UIFont.systemFont(ofSize: 16)
       )

    
    var house: HouseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable map
        
//        hMapConst.constant = 0
        
        switchBtn.setOn(true, animated: true)
        mapContentView.isHidden = true
        checkLocationServices()
//        if switchBtn.isOn {
//        }

        // Do any additional setup after loading the view.
        textFields = [tfBathroom, tfLandSpace, tfFloor, tfAbove, tfBasement, tfBedroom, tfYearBuilt, tfRenovated, tfView, tfCondition, tfLandSpace, tfGrade]

        for textField in textFields {
            textField.delegate = self
        }

        house = HouseModel()
        house.getDate()
        
        setUpTextFields()
    }
    
    func setUpTextFields() {
 
        tfBedroom.placeholder = "Number of Bedroom"
        tfBedroom.selectedTitle = "Number of Bedroom"
        tfBedroom.title = "Number of Bedroom"
        
        tfBathroom.placeholder = "Number of Bathroom"
        tfBathroom.selectedTitle = "Number of Bathroom"
        tfBathroom.title = "Number of Bathroom"

        tfLandSpace.placeholder = "Square footage of the land space"
        tfLandSpace.selectedTitle = "Square footage of the land space"
        tfLandSpace.title = "Square footage of the land space"

        tfFloor.placeholder = "Number of Floor"
        tfFloor.selectedTitle = "Number of Floor"
        tfFloor.title = "Number of Floor"

        tfWaterfront.placeholder = "Waterfront"
        tfWaterfront.selectedTitle = "Waterfront"
        tfWaterfront.title = "Waterfront"

        tfView.placeholder = "How good the view of the property was"
        tfView.selectedTitle = "How good the view of the property was"
        tfView.title = "How good the view of the property was"

        //สภาพบ้าน
        tfCondition.placeholder = "Condition"
        tfCondition.selectedTitle = "Condition"
        tfCondition.title = "Condition"

        tfGrade.placeholder = "Building construction and design"
        tfGrade.selectedTitle = "How good the view of the property was"
        tfGrade.title = "How good the view of the property was"

        tfAbove.placeholder = "Sqft of interior housing space above ground level"
        tfAbove.selectedTitle = "(Sqft)Interior housing space above ground"
        tfAbove.title = "(Sqft)Interior housing space above ground"

        tfBasement.placeholder = "Sqft of the interior housing space below ground level"
        tfBasement.selectedTitle = "(Sqft)Interior housing space below ground"
        tfBasement.title = "(Sqft)Interior housing space below ground"

        tfYearBuilt.placeholder = "Year built"
        tfYearBuilt.selectedTitle = "Year built"
        tfYearBuilt.title = "Year built"

        tfRenovated.placeholder = "Renovated?"
        tfRenovated.selectedTitle = "Renovated?"
        tfRenovated.title = "Renovated?"

        //set Default value
        tfBedroom.text = ""
        tfBathroom.text = ""
        tfLandSpace.text = ""
        tfFloor.text = ""
        tfWaterfront.text = ""
        tfView.text = ""
        tfCondition.text = ""
        tfGrade.text = ""
        tfAbove.text = ""
        tfBasement.text = ""
        tfYearBuilt.text = ""
        tfRenovated.text = ""

        //set theme
        applySkyscannerTheme(textField: tfBedroom)
        applySkyscannerTheme(textField: tfBathroom)
        applySkyscannerTheme(textField: tfLandSpace)
        applySkyscannerTheme(textField: tfFloor)
        applySkyscannerTheme(textField: tfWaterfront)
        applySkyscannerTheme(textField: tfView)
        applySkyscannerTheme(textField: tfCondition)
        applySkyscannerTheme(textField: tfGrade)
        applySkyscannerTheme(textField: tfAbove)
        applySkyscannerTheme(textField: tfBasement)
        applySkyscannerTheme(textField: tfYearBuilt)
        applySkyscannerTheme(textField: tfRenovated)

    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        textField.backgroundColor = .clear

        textField.tintColor = overcastBlueColor

        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor

        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor

        textField.placeholderFont = UIFont.systemFont(ofSize: 12)
        textField.titleFont = UIFont.systemFont(ofSize: 13)
 
      }
    
    @IBAction func chooseBedroom(_ sender: Any) {
           let arrTheme = bedrooms
           let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
               if let selectedValue = selectedValues.first {
                self.tfBedroom.text = selectedValue
               } else {
                self.tfBedroom.text = ""
               }
            
           }, onCancel: {
               
           })
           picker.show(withAnimation: .FromBottom)
    }
    
    @IBAction func enableMap(_ sender: UISwitch) {
        if sender.isOn {
//            switchBtn.setOn(true, animated: true)
//            locationManager.startUpdatingLocation()
//            mapContentView.isHidden = false
            
        } else {
//            switchBtn.setOn(false, animated: true)
            currentLocation = CLLocation()
        }
    }

    @IBAction func chooseWaterfront(_ sender: Any) {
        let arrTheme = waterfronts
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfWaterfront.text = selectedValue
                } else {
                    self.tfWaterfront.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseView(_ sender: Any) {
        let arrTheme = views
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfView.text = selectedValue
                } else {
                    self.tfView.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseCondition(_ sender: Any) {
        let arrTheme = conditions
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfCondition.text = selectedValue
                } else {
                    self.tfCondition.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    
    @IBAction func chooseGrade(_ sender: Any) {
        let arrTheme = grades
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfGrade.text = selectedValue
                } else {
                    self.tfGrade.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseYearBuilt(_ sender: Any) {
        let arrTheme = yearbuild
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfYearBuilt.text = selectedValue
                } else {
                    self.tfYearBuilt.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseRenovated(_ sender: Any) {
        let arrTheme = renovated
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfRenovated.text = selectedValue
                } else {
                    self.tfRenovated.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @IBAction func predict(_ sender: Any) {
        
        if switchBtn.isOn && currentLocation.coordinate.latitude == 0 {
            print(currentLocation)
            let alert = CDAlertView(title: "Oops", message: "This Prediction need your current location", type: .warning)
            let doneAction = CDAlertViewAction(title: "OK")
            alert.add(action: doneAction)
            alert.show()
            return
        }
        
        for textfield in textFields {
            if textfield.text == "" {
                let alert = CDAlertView(title: "Oops", message: "Please fill your data!!", type: .warning)
                let doneAction = CDAlertViewAction(title: "OK")
                alert.add(action: doneAction)
                alert.show()
                return
            }
        }

        let formatter = NumberFormatter()
        formatter.locale = Locale.current // USA: Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        
        let index = find(value: tfBedroom.text ?? "", in: bedrooms)
        house.bedroom = Double(index ?? 0)
        
        guard let bt = formatter.number(from: tfBathroom.text ?? "") else { return }
        house.bathroom = bt.doubleValue
        
        let wfindex = find(value: tfWaterfront.text ?? "", in: waterfronts)
        house.waterfront = Double(wfindex ?? 0)
        
        guard let above = formatter.number(from: tfAbove.text ?? "") else { return }
        house.above = above.doubleValue
        
        guard let basement = formatter.number(from: tfBasement.text ?? "") else { return }
        house.basement = basement.doubleValue
        
        guard let flr = formatter.number(from: tfFloor.text ?? "") else { return }
        house.floor = flr.doubleValue
   
        let viewindex = find(value: tfView.text ?? "", in: views)
        house.view = Double(viewindex ?? 0)
        
        var conindex = find(value: tfCondition.text ?? "", in: conditions)
        conindex = (conindex ?? 0) + 1
        house.condition = Double(conindex ?? 0)
        
        guard let land = formatter.number(from: tfLandSpace.text ?? "") else { return }
        house.landspace = land.doubleValue
        
        var gindex = find(value: tfGrade.text ?? "", in: grades)
        gindex = (gindex ?? 0) + 1
        house.grade = Double(gindex ?? 0)
        
        guard let year = formatter.number(from: tfYearBuilt.text ?? "") else { return }
        house.yrsBuilt = year.doubleValue
        
        let renoindex = find(value: tfRenovated.text ?? "", in: renovated)
        house.renovate = renoindex == 0 ? "N" : "Y"

        
        if switchBtn.isOn {
            if let predictions = try? self.housePricerLatLong.prediction(date: house.date,
                                                                           bedrooms: house.bedroom,
                                                                           bathrooms: house.bathroom,
                                                                           sqft_living: house.above + house.basement,
                                                                           sqft_lot: house.landspace,
                                                                           floors: house.floor,
                                                                           waterfront: house.waterfront,
                                                                           view: house.view,
                                                                           condition: house.condition,
                                                                           grade: house.grade,
                                                                           sqft_above: house.above,
                                                                           sqft_basement: house.basement,
                                                                           yr_built: house.yrsBuilt,
                                                                           renovated: house.renovate,
                                                                           lat: currentLocation.coordinate.latitude,
                                                                           long_: currentLocation.coordinate.longitude) {
 
                         
                         let formatter = NumberFormatter()
                         formatter.locale = Locale(identifier: "en_US")
                         formatter.numberStyle = .currency
                         
                         let price = formatter.string(from: NSNumber(value: predictions.price))
                         let alert = CDAlertView(title: "The Price is", message: price, type: .notification)
                         let doneAction = CDAlertViewAction(title: "OK")
                         alert.add(action: doneAction)
                         alert.show()
                         
                     } else {
                         let alert = CDAlertView(title: "Oops", message: "Something went wrong!!", type: .error)
                                   let doneAction = CDAlertViewAction(title: "OK")
                                   alert.add(action: doneAction)
                                   alert.show()
                     }
        } else {
            if let predictions = try? self.housePricer.prediction(date: house.date,
                                                                  bedrooms: house.bedroom,
                                                                  bathrooms: house.bathroom,
                                                                  sqft_living: house.above + house.basement,
                                                                  sqft_lot: house.landspace,
                                                                  floors: house.floor,
                                                                  waterfront: house.waterfront,
                                                                  view: house.view,
                                                                  condition: house.condition,
                                                                  grade: house.grade,
                                                                  sqft_above: house.above,
                                                                  sqft_basement: house.basement,
                                                                  yr_built: house.yrsBuilt,
                                                                  renovated: house.renovate) {
                
                
                
                
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "en_US")
                formatter.numberStyle = .currency
                
                let price = formatter.string(from: NSNumber(value: predictions.price))
                let alert = CDAlertView(title: "The Price is", message: price, type: .notification)
                let doneAction = CDAlertViewAction(title: "OK")
                alert.add(action: doneAction)
                alert.show()
                
            } else {
                let alert = CDAlertView(title: "Oops", message: "Something went wrong!!", type: .error)
                          let doneAction = CDAlertViewAction(title: "OK")
                          alert.add(action: doneAction)
                          alert.show()
            }
        }
    }
    
    @IBAction func openMap(_ sender: Any) {
        if switchBtn.isOn {
        mapContentView.isHidden = false
        locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func refreshLocation(_ sender: Any) {
    locationManager.startUpdatingLocation()
    }
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }

        return nil
    }
    
    @IBAction func dismissMap(_ sender: Any) {
        mapContentView.isHidden = true
    }
}


extension PredictViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textFields.contains(textField as! SkyFloatingLabelTextField) {
            textField.text = ""
        }
    }
}

extension PredictViewController {
    
    func checkLocationServices() {
       if CLLocationManager.locationServicesEnabled() {
         checkLocationAuthorization()
       } else {
         // Show alert letting the user know they have to turn this on.
       }
     }
     
     
     func checkLocationAuthorization() {
       switch CLLocationManager.authorizationStatus() {
       case .authorizedWhenInUse:
         mapView.showsUserLocation = true
         
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         
//         mapView.delegate = self
        break
     
       // For these case, you need to show a pop-up telling users what's up and how to turn on permisneeded if needed
       case .denied:
         break
       case .notDetermined:
         locationManager.requestWhenInUseAuthorization()
         mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
       case .restricted:
         break
       case .authorizedAlways:
         break
       @unknown default: break
        
        }
     }
     
}

extension PredictViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
              locationManager.requestLocation()
          }
      }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            print("Latitude:\(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            
            
            let alert = CDAlertView(title: "Current Location", message: "Latitude:\(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)", type: .notification)
            let doneAction = CDAlertViewAction(title: "OK")
            alert.add(action: doneAction)
            alert.autoHideTime = 3
            alert.show()
            
            currentLocation = location
            locationManager.stopUpdatingLocation()
          }
      }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
          print("error:: (error)")
        locationManager.stopUpdatingLocation()
      }
}
