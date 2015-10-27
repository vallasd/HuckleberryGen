//
//  MidVC.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/23/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Cocoa

//
//protocol EDVCDelegate: AnyObject {
//    // midVC
//    func edvc(vc: EntityDetailVC, selectedRelationship: Relationship)
//    func edvc(vc: EntityDetailVC, selectedAttribute: Attribute)
//}
//
//class EntityDetailVC: NSTabViewController, AttributeVCDelegate, RelationshipsVCDelegate {
//    
//    weak var delegate: EDVCDelegate? = nil
//    var entity: Entity? {
//        
//        didSet {
//            attributeVC.attribute = (entity?.attributes.sort{ $0.name < $1.name })!
//            relationshipsVC.relationships = (entity?.relationships.sort{ $0.name < $1.name })!
//            attributeVC.refresh()
//            relationshipsVC.refresh()
//        }
//    }
//    
//    // MARK: View Controllers
//    
//    weak var attributeVC: AttributeVC!
//    weak var relationshipsVC: RelationshipsVC!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do view setup here.
//        view.backgroundColor(HGColor.White)
//        setupViewControllers()
//    }
//    
//    
//    private func setupViewControllers() {
//        for item in tabView.tabViewItems {
//            if let avc = item.viewController as? AttributeVC { attributesVC = avc; attributesVC.delegate = self }
//            if let rvc = item.viewController as? RelationshipsVC { relationshipsVC = rvc; relationshipsVC.delegate = self }
//        }
//        
//    }
//    
//    // MARK: AttributesVCDelegate
//    
//    func attVC(vc: AttributeVC, selectedAttribute: Attribute) {
//        
//    }
//
//    
//    // MARK: RelationshipsVCDelegate
//    
//    func relVC(vc: RelationshipsVC, selectedRelationship: Relationship) {
//        
//    }
//    
//    
//}
