//
//  MapViewController.swift
//  SOS
//
//  Created by Neha Patil on 4/10/23.
//

import UIKit
import MapKit


class ServicesViewController: UIViewController {

    let localSearch = LocalSearch()
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mapOfServices: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var cells: [Landmark] = []
    
    @IBOutlet weak var policeButton: UIButton!
    @IBOutlet weak var hospitalsButton: UIButton!
    
    var numberPoliceClicked = 0
    var numberHospitalsClicked = 0
    override func viewDidLoad() {
        errorLabel.isHidden = true
        hospitalsButton.layer.cornerRadius = 10.0
        policeButton.layer.cornerRadius = 10.0
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LandmarkCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.delegate = self
        


        // Do any additional setup after loading the view.
    }
    
    
    
    func loadHospitalMap(){
        let allAnnotations = self.mapOfServices.annotations
        self.mapOfServices.removeAnnotations(allAnnotations)
        mapOfServices.region = localSearch.region
        mapOfServices.showsUserLocation = true
        
        if localSearch.landmarksHospital != []{
            let sizeOfArr = localSearch.landmarksHospital.count
            for i in 0..<(sizeOfArr-1){
                mapOfServices.addAnnotation(localSearch.landmarksHospital[i].placemark)
            }
        }
  
    }
    
    func loadPoliceMap(){
        let allAnnotations = self.mapOfServices.annotations
        self.mapOfServices.removeAnnotations(allAnnotations)
        
        mapOfServices.region = localSearch.region
        mapOfServices.showsUserLocation = true
        
        if localSearch.landmarksPolice != []{
            let sizeOfArr = localSearch.landmarksPolice.count
            for i in 0..<(sizeOfArr-1){
                mapOfServices.addAnnotation(localSearch.landmarksPolice[i].placemark)
            }
        }
    }
    
    @IBAction func policeClicked(_ sender: UIButton) {
        numberPoliceClicked += 1
        loadPoliceMap()
        cells = []
        tableView.reloadData()
        localSearch.searchPolice(query: "Police Stations")
        print(localSearch.searchPolice(query: "Police Stations"))
        print(localSearch.landmarksPolice)
        let landmarks = localSearch.landmarksPolice
        tableView.reloadData()
        viewDidLoad()
        DispatchQueue.main.async{
            self.cells.append(contentsOf: self.localSearch.landmarksPolice)
                    //print(self.cells)
                    //print(self.localSearch.landmarks)
            
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.cells.count - 1, section: 0)
                    
                }
        
        if cells == []{
            errorLabel.isHidden = false
        }
        loadPoliceMap()
                    
            }
        
    @IBAction func hospitalsClicked(_ sender: UIButton) {
        loadHospitalMap()
        cells = []
        tableView.reloadData()
        localSearch.searchHospital(query: "Hospitals")
        DispatchQueue.main.async{
                    self.cells.append(contentsOf: self.localSearch.landmarksHospital)
                    //print(self.cells)
                    //print(self.localSearch.landmarks)

                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.cells.count - 1, section: 0)

                }
        
        if cells == []{
            errorLabel.isHidden = false
        }

        loadHospitalMap()
        
        

            }
    
    
   
        
}


extension ServicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("its working")
        print("you selected " + cells[indexPath.row].name)
        let selectedRegion = MKCoordinateRegion(center: cells[indexPath.row].coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapOfServices.region = selectedRegion
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                                                            "comgooglemaps://?saddr=&daddr=\(cells[indexPath.row].coordinate.latitude),\(cells[indexPath.row].coordinate.longitude)&directionsmode=driving")! as URL)

        } else if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com/")! as URL)){
            let coordinate = CLLocationCoordinate2DMake(cells[indexPath.row].coordinate.latitude, cells[indexPath.row].coordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                        mapItem.name = "Destination"
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                }
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! LandmarkCell
        cell.title.text = cells[indexPath.row].name
        cell.address.text = cells[indexPath.row].title
        
        
        return cell
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

       return tableView.rowHeight

    }
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    
    

    
    
}
