//
//  BobotParameters+CoreDataProperties.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/13/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//
//

import Foundation
import CoreData


extension BobotParameters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BobotParameters> {
        return NSFetchRequest<BobotParameters>(entityName: "BobotParameters")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var namaParameter: String?
    @NSManaged public var nilaiBobotParameter: Float
    @NSManaged public var nilaiRelatifBobot: Float
    @NSManaged public var totalBobot: Float
    @NSManaged public var updatedAt: Date?
    @NSManaged public var createdBy: Users?
    @NSManaged public var kasiNamaPDAlternatif: NSSet?
    @NSManaged public var kasiNamaPKlasifikasi: NSSet?

}

// MARK: Generated accessors for kasiNamaPDAlternatif
extension BobotParameters {

    @objc(addKasiNamaPDAlternatifObject:)
    @NSManaged public func addToKasiNamaPDAlternatif(_ value: DataAlternatifs)

    @objc(removeKasiNamaPDAlternatifObject:)
    @NSManaged public func removeFromKasiNamaPDAlternatif(_ value: DataAlternatifs)

    @objc(addKasiNamaPDAlternatif:)
    @NSManaged public func addToKasiNamaPDAlternatif(_ values: NSSet)

    @objc(removeKasiNamaPDAlternatif:)
    @NSManaged public func removeFromKasiNamaPDAlternatif(_ values: NSSet)

}

// MARK: Generated accessors for kasiNamaPKlasifikasi
extension BobotParameters {

    @objc(addKasiNamaPKlasifikasiObject:)
    @NSManaged public func addToKasiNamaPKlasifikasi(_ value: NilaiKlasifikasi)

    @objc(removeKasiNamaPKlasifikasiObject:)
    @NSManaged public func removeFromKasiNamaPKlasifikasi(_ value: NilaiKlasifikasi)

    @objc(addKasiNamaPKlasifikasi:)
    @NSManaged public func addToKasiNamaPKlasifikasi(_ values: NSSet)

    @objc(removeKasiNamaPKlasifikasi:)
    @NSManaged public func removeFromKasiNamaPKlasifikasi(_ values: NSSet)

}
