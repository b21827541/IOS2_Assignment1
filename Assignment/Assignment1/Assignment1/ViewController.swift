//
//  ViewController.swift
//  Assignment1
//
//  Created by Berk Karaimer on 2023-02-02.
//

import UIKit

struct Photo: Codable {
    let id: Int
    let img_src: String
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var rover : UIPickerView!
    @IBOutlet var chooseimg : UIPickerView!
    @IBOutlet var datepicker : UIDatePicker!
    @IBOutlet var imageview : UIImageView!
    @IBOutlet var total : UILabel!
    
    var roverPickerData : [String] = []
    var imgPickerData : [Int] = []
    
    var text = "curiosity"
    var datetext = "2015-6-3"
    var finalUrl = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=XxBM4svOcWpvA7muWiEpdjN21o4thpmKdnoYiMd0&earth_date=2015-6-3"
    
    var id : Int = 0
    
    var resultArr: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Connect data:
        self.rover.delegate = self
        self.rover.dataSource = self
        
        self.chooseimg.delegate = self
        self.chooseimg.dataSource = self
        
        //print(imgPickerData)
        
        roverPickerData = ["curiosity", "opportunity", "spirit"]
        //
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        datetext = formatter.string(from: date)
        
        datepicker.datePickerMode = .date
        datepicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        //
        //useData()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        datetext = formatter.string(from:sender.date)
        print(datetext)
        useData()
    }
    
    func useData(){
        
        var urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
        //rover name
        var url2Str = "/photos?api_key=XxBM4svOcWpvA7muWiEpdjN21o4thpmKdnoYiMd0&earth_date="
        var dateStr = "" //"2015-6-3"
        dateStr = datetext.replacingOccurrences(of: "/", with: "-")
        var reversd = dateStr.components(separatedBy: "-")
        var datefinal = reversd[2] + "-" + reversd[1] + "-" + reversd[0]
        
        finalUrl = urlString + text + url2Str + datefinal
        print(finalUrl)
        ///
        NetworkingService.shared.getData2(urlString: finalUrl) { result in
            switch result{
            case .failure(let error):
                print(error)
                
            case .success(let data):
                let result =  JsonService.shared.parseJson(data: data)
                
                self.resultArr = result
                DispatchQueue.main.async {
                    self.total.text = "Total num of imgs:  \(result.count)"
                    var urlimg = ""
                    print("success id ; " + String(self.id))
                    if self.id > 0 {
                        for i in self.resultArr{
                            if i.id == self.id{
                                urlimg = String(i.img_src)
                            }
                        }
                        URLSession.shared.dataTask(with: URL(string: urlimg)!){ data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.async {
                                self.imageview.image = UIImage(data: data)
                            }
                            
                        }.resume()
                    }
                    
                    self.chooseimg.reloadAllComponents()
                    //for i in result{
                    //    self.imgPickerData.append(i.id)
                    //    print(i.id)
                    //}
                    //self.imgPickerData = resultArr[row].id
                    //    self.citiesNames = result
                    //    self.tableView.reloadData()
                    //    self.activityIndicator.isHidden = true
                }
                //print(result)
            }
            }
        //chooseimg.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }

        // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //
        // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return roverPickerData.count
        } else if pickerView.tag == 2{
            return resultArr.count
        }
        return 0
    }
        
        // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return roverPickerData[row]
        } else if pickerView.tag == 2 {
            return "\(resultArr[row].id)"
        }
        return "error"
    }
    
    func reloadPickerViewData(_ sender: Any){
        chooseimg.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            text = roverPickerData[row]
            print(text)
            useData()
        } else if pickerView.tag == 2 {
            id = resultArr[row].id
            print("pickerview id : " + String(id))
            print(resultArr[row].id)
            useData()
        }
    }
}

