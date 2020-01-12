//
//  AlterKaliParamTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/13/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class AlterKaliParamTableViewController: UITableViewController {
    
    var dataAlternatifArray = [DataAlternatifs]()
    var selectedKecamatan: Kecamatans? {
        didSet {
            loadDataAlternatifs()
        }
    }
    
    var dataAlternatifPure = [DataAlternatifs]()
    
    var selectedButton: String?
    var totalBobotEvaluasi: Float = 0
    var BobotEvaluasi: [Double] = []
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dict : [String : [Double] ] = [:]
    
    struct MaxParameter {
        var parameter: String!
        var alterKaliParam: Float!
    }
    
    struct MinKecamatan {
        var kecamatan: String!
        var alterKaliParam: Float!
    }
    
    var arrayMaxParameter = [MaxParameter]()
    var arrayMaxBerhasil = [String: Float]()
    var arrayMinKecamatan = [MinKecamatan]()
    var arrayMinBerhasil = [String: Float]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.rowHeight = 80.0
        
        tableView.allowsSelection = false
        
        loadDataAlternatifsPure()
        navigationController?.applyDesign()
        
        // MARK : - Nyari Maksimum nilai perparameter
           
           for i in dataAlternatifPure {
               arrayMaxParameter.append(MaxParameter(parameter: i.namaParameternya?.namaParameter, alterKaliParam: (i.namaParameternya!.nilaiBobotParameter * i.rangeNilainya!.nilai_klasifikasi)))
           }
           
           var dictMax = [String: [Float]]()
           
           for i in arrayMaxParameter {
               dictMax[i.parameter!, default: []].append(i.alterKaliParam!)
           }
           
           let arrayMax = dictMax.map ({ ($0, $1.max() ?? 0) })
           
            arrayMaxBerhasil = arrayMax.reduce(into: [:]) { $0[$1.0] = $1.1 }
          
           // MARK : - Nyari Minimum nilai perkecamatan
           
           for i in dataAlternatifPure {
               arrayMinKecamatan.append(MinKecamatan(kecamatan: i.namaKecamatannya?.namaDaerah, alterKaliParam: (i.namaParameternya!.nilaiBobotParameter * i.rangeNilainya!.nilai_klasifikasi)))
           }
           
           var dictMin = [String: [Float]]()
           
           for i in arrayMinKecamatan {
               dictMin[i.kecamatan!, default: []].append(i.alterKaliParam!)
           }
           
           let arrayMin = dictMin.map ({ ($0, $1.min() ?? 0) })
           
           arrayMinBerhasil = arrayMin.reduce(into: [:]) { $0[$1.0] = $1.1 }
        
        
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAlternatifArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlterKaliParamCell", for: indexPath)

        let nilaiAlternatif = dataAlternatifArray[indexPath.row]
        let nilaiBobot = nilaiAlternatif.namaParameternya?.nilaiBobotParameter
        let nilaiKlasifikasi = nilaiAlternatif.rangeNilainya?.nilai_klasifikasi
        let paramKaliAlter = CGFloat(nilaiBobot!) * CGFloat(nilaiKlasifikasi!)
        let maxParamByParam = arrayMaxBerhasil[nilaiAlternatif.namaParameternya!.namaParameter!]!
        let minParamByKec = arrayMinBerhasil[nilaiAlternatif.namaKecamatannya!.namaDaerah!]!
        
        let faktorEvaluasiAtas = CGFloat(maxParamByParam) - CGFloat(paramKaliAlter)
        let faktorEvaluasiBawah = maxParamByParam - minParamByKec
        let faktorEvaluasiDibagi = faktorEvaluasiAtas / CGFloat(faktorEvaluasiBawah)
        var faktorEvaluasi = faktorEvaluasiDibagi * 100
        
    
        switch faktorEvaluasi.isNaN {
        case true :
            faktorEvaluasi = 0
        default:
            break
        }

        let totalBobot = totalNilaiBobot()
        let bobotRelatif = nilaiAlternatif.namaParameternya!.nilaiBobotParameter / totalBobot
        
        let total = Double(CGFloat(faktorEvaluasi) * CGFloat(bobotRelatif))

        switch selectedButton {
        case "AlterKaliParam":
            cell.textLabel?.text = nilaiAlternatif.namaParameternya?.namaParameter
            cell.detailTextLabel?.text = NSString(format: "%.2f", paramKaliAlter) as String
            navigationItem.title = "Alternatif x Parameter"
        case "FaktorEvaluasi":
            cell.textLabel?.text = nilaiAlternatif.namaParameternya?.namaParameter
            cell.detailTextLabel?.text = NSString(format: "%.2f", faktorEvaluasi) as String
            navigationItem.title = "Faktor Evaluasi"
        case "BobotEvaluasi":
            cell.textLabel?.text = nilaiAlternatif.namaParameternya?.namaParameter
            cell.detailTextLabel?.text = NSString(format: "%.2f", total) as String
            navigationItem.title = "Bobot Evaluasi per Alternatif"
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Data Manipulation Methods
    
    func loadDataAlternatifs(with request: NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()) {
        
        let predicate = NSPredicate(format: "namaKecamatannya.namaDaerah MATCHES %@", selectedKecamatan!.namaDaerah!)
        
        request.predicate = predicate
        
        do {
            dataAlternatifArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadDataAlternatifsPure(with request: NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()) {
            
              do {
                  dataAlternatifPure = try context.fetch(request)
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


