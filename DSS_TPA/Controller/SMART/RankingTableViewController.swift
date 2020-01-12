//
//  RankingTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 10/16/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class RankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var kecamatanLabel: UILabel!
    @IBOutlet weak var bobotEvaluasiLabel: UILabel!
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rankLabel.layer.cornerRadius = 3
        rankLabel.layer.borderWidth = 1
        rankLabel.layer.borderColor = UIColor.white.cgColor
//
//        rankLabel.addShadow(to: [.top, .bottom, .left, .right])
    }
    
}

class RankingTableViewController: UITableViewController {
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var dataAlternatifArray = [DataAlternatifs]()
    var ranking = [(kecamatan:String, rank: Int, nilaiFinal: Float)]()
    var selectedKabupaten: Kabupaten? {
        didSet {
            loadDataAlternatifs()
        }
    }
    struct DataAlternatif {
        var kecamatan : String!
        var parameter : String!
        var alterKaliParam: Float!
        var bobotRelatif: Float!
        var maxAlterXBobotParam: Float!
        var minAlterXBobotKec: Float!
    }
    
    struct DataAlternatifDiolah {
        var kecamatan : String!
        var parameter : String!
        var bobotRelatif: Float!
        var nilaiDiatas: Float!
        var nilaiDibawah: Float!
    }
    
    struct DataAlternatifDiolah2 {
        var kecamatan : String!
        var parameter : String!
        var bobotRelatif : Float!
        var faktorEvaluasi : Float!
    }
    
    struct NilaiFinal {
        var kecamatan : String!
        var finalNilai : Float!
    }
    
    struct MaxParameter {
        var parameter: String!
        var alterKaliParam: Float!
    }
    
    struct MinKecamatan {
        var kecamatan: String!
        var alterKaliParam: Float!
    }
    
    var dataAlternatif = [DataAlternatif]()
    var dataAlternatifDiolah = [DataAlternatifDiolah]()
    var dataAlternatifDiolah2 = [DataAlternatifDiolah2]()
    var nilaiFinal = [NilaiFinal]()
    var resultSMART = [NilaiFinal]()
    var arrayMaxParameter = [MaxParameter]()
    var arrayMinKecamatan = [MinKecamatan]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
        view.layer.cornerRadius = 8
        tableView.allowsSelection = false
        navigationController?.applyDesign()
        
        
//        loadDataAlternatifs()
        
        let totalBobot = totalNilaiBobot()
        
         // MARK : - Nyari Maksimum nilai perparameter
        
        for i in dataAlternatifArray {
            arrayMaxParameter.append(MaxParameter(parameter: i.namaParameternya?.namaParameter, alterKaliParam: (i.namaParameternya!.nilaiBobotParameter * i.rangeNilainya!.nilai_klasifikasi)))
        }
        
        var dictMax = [String: [Float]]()
        
        for i in arrayMaxParameter {
            dictMax[i.parameter!, default: []].append(i.alterKaliParam!)
        }
        
        let arrayMax = dictMax.map ({ ($0, $1.max() ?? 0) })
        
        let arrayMaxBerhasil = arrayMax.reduce(into: [:]) { $0[$1.0] = $1.1 }
       
        // MARK : - Nyari Minimum nilai perkecamatan
        
        for i in dataAlternatifArray {
            arrayMinKecamatan.append(MinKecamatan(kecamatan: i.namaKecamatannya?.namaDaerah, alterKaliParam: (i.namaParameternya!.nilaiBobotParameter * i.rangeNilainya!.nilai_klasifikasi)))
        }
        
        var dictMin = [String: [Float]]()
        
        for i in arrayMinKecamatan {
            dictMin[i.kecamatan!, default: []].append(i.alterKaliParam!)
        }
        
        let arrayMin = dictMin.map ({ ($0, $1.min() ?? 0) })
        
        let arrayMinBerhasil = arrayMin.reduce(into: [:]) { $0[$1.0] = $1.1 }
        
        // MARK : - Lanjutan Perhitungan SMART
        
        
         for i in dataAlternatifArray {
            dataAlternatif.append(DataAlternatif(kecamatan: i.namaKecamatannya?.namaDaerah, parameter: i.namaParameternya?.namaParameter, alterKaliParam: (i.rangeNilainya!.nilai_klasifikasi * i.namaParameternya!.nilaiBobotParameter), bobotRelatif: (i.namaParameternya!.nilaiBobotParameter / totalBobot), maxAlterXBobotParam: arrayMaxBerhasil[i.namaParameternya!.namaParameter!], minAlterXBobotKec: arrayMinBerhasil[i.namaKecamatannya!.namaDaerah!]))
         }
        
        
        
        for i in dataAlternatif {
            dataAlternatifDiolah.append(DataAlternatifDiolah(kecamatan: i.kecamatan, parameter: i.parameter, bobotRelatif: i.bobotRelatif, nilaiDiatas: (i.maxAlterXBobotParam - i.alterKaliParam), nilaiDibawah: (i.maxAlterXBobotParam - i.minAlterXBobotKec)))
        }
        
        for i in dataAlternatifDiolah {
            
            var faktorEvaluasi1 = (i.nilaiDiatas / i.nilaiDibawah) * 100
            
            switch faktorEvaluasi1.isNaN {
            case true:
                faktorEvaluasi1 = 0
            default:
                break
            }
            
            dataAlternatifDiolah2.append(DataAlternatifDiolah2(kecamatan: i.kecamatan, parameter: i.parameter, bobotRelatif: i.bobotRelatif, faktorEvaluasi: faktorEvaluasi1 ))
        }
    
    
        for i in dataAlternatifDiolah2 {
            nilaiFinal.append(NilaiFinal(kecamatan: i.kecamatan, finalNilai: (i.bobotRelatif * i.faktorEvaluasi)))
        }
        
        
        
        let allKeys = Set<String>(nilaiFinal.filter({!$0.kecamatan.isEmpty}).map{$0.kecamatan})
        
        for key in allKeys {
            let sum = nilaiFinal.filter({$0.kecamatan == key}).map({$0.finalNilai}).reduce(0, +)
            resultSMART.append(NilaiFinal(kecamatan: key, finalNilai: sum))
            
        }
        
        ranking = Dictionary(grouping: resultSMART, by: { $0.finalNilai } )
                .sorted(by: {$0.key > $1.key})
                .enumerated()
                .flatMap { (offset, elem) in
                elem.value.map { (kecamatan: $0.kecamatan, rank: offset + 1, nilaiFinal: $0.finalNilai ) }
            }
   
    }

    // MARK: - Table view data source
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ranking.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RankTableViewCell
            
            cell.rankLabel.text = ("\(ranking[indexPath.row].rank)")
            cell.kecamatanLabel.text = ("Kecamatan \(ranking[indexPath.row].kecamatan)")
            cell.bobotEvaluasiLabel.text = ("Bobot Evaluasi : \(NSString(format: "%.2f", ranking[indexPath.row].nilaiFinal) as String)")
            return cell
            
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Manipulation Methods

    
    func loadDataAlternatifs(with request: NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()) {
        
        let predicate = NSPredicate(format: "namaKecamatannya.dariKabupaten.namaKabupaten MATCHES %@", selectedKabupaten!.namaKabupaten!)
                     
              request.predicate = predicate
         
           do {
               dataAlternatifArray = try context.fetch(request)
           } catch {
               print("Error fetching data from context \(error)")
           }
           
           tableView.reloadData()
       }
    
    // MARK: - Function
    
    func totalNilaiBobot() -> Float {
        
        var totalBobot: Float = 0
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "totalNilaiBobot"
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "nilaiBobotParameter")])
        sumExpressionDescription.expressionResultType = .floatAttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BobotParameters")
        
        request.propertiesToFetch = [sumExpressionDescription]
        request.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(request)
            let resultMap = results[0] as! [String:Float]
            totalBobot = resultMap["totalNilaiBobot"]!
        } catch let error as NSError {
            NSLog("Error when summing amounts: \(error.localizedDescription)")
        }
        
        return totalBobot
        
    }

 

}

//extension UILabel {
//    func addShadow(to edges: [UIRectEdge], radius: CGFloat = 3.0, opacity: Float = 0.2, color: CGColor = UIColor.black.cgColor) {
//
//        let fromColor = color
//        let toColor = UIColor.clear.cgColor
//        let viewFrame = self.frame
//        for edge in edges {
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.colors = [fromColor, toColor]
//            gradientLayer.opacity = opacity
//
//            switch edge {
//            case .top:
//                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
//            case .bottom:
//                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//                gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
//            case .left:
//                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
//            case .right:
//                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
//                gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
//            default:
//                break
//            }
//            self.layer.addSublayer(gradientLayer)
//        }
//    }
//}
