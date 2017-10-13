//
//  Category.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Resource: Object {
    
    
//    @PrimaryKey
//    public Integer id;
//    
//    @SerializedName("resource_code")
//    public String resourceCode;
//    
//    @SerializedName("snapshot_code")
//    public String snapshotCode;
//    
//    @SerializedName("image_url")
//    public String imageUrl;
//    
//    @SerializedName("created_date")
//    public Date createdDate;
//    
//    @SerializedName("resource_rate")
//    public String resourceRate;
//    
//    @SerializedName("images")
//    public RealmList<Image> images = null;
//    
//    public String name;
//    public String description;
//    public User account;
//    public RealmList<ResourceCategory> categories = null;
//    public Double price;
//    public Integer quantity;
//    public String status;
//    public Location location;
//    
    
    dynamic var id = 0
    dynamic var resourceCode = ""
    dynamic var snapshotCode = ""
    dynamic var imageUrl = ""
    dynamic var createdDate = ""
    dynamic var resourceRate = ""
    let image = List<Image>()

    dynamic var name = ""
    dynamic var descriptionText = ""
    dynamic var account = ""
    dynamic var price = ""
    dynamic var quantity = ""
    dynamic var status = ""
    dynamic var location: Location?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    
    
}
