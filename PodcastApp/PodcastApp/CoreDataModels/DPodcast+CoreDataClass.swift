//
//  DPodcast+CoreDataClass.swift
//  PodcastsApp
//
//  Created by aldybuana on 01/11/22.
//
//

import Foundation
import CoreData


public class DPodcast: NSManagedObject {
    class func save(_ podcast: Podcast, at context: NSManagedObjectContext) {
        
        //sebelum save bikin request untuk select dari table DPodcast
        let request: NSFetchRequest<DPodcast> = DPodcast.fetchRequest()
        // where "trackId = \(podcast.trackId)"
        request.predicate = NSPredicate(format: "trackId_ = \(podcast.trackId)")
        
        let entity: DPodcast
        if let dPodcast = try? context.fetch(request).first {
            entity = dPodcast
        }
        else {
            let dPodcast = NSEntityDescription.entity(forEntityName: "DPodcast", in: context)!
            entity = NSManagedObject(entity: dPodcast, insertInto: context) as! DPodcast
        }
        
        entity.trackId_ = Int64(podcast.trackId)
        entity.trackName = podcast.trackName
        entity.trackCount_ = Int16(podcast.trackCount)
        entity.artistName = podcast.artistName
        entity.artwork = podcast.artworkUrl600
        entity.feedUrl = podcast.feedUrl
        entity.isFavorited = true
        
        try? context.save()
    }
    
    class func fetch(in context: NSManagedObjectContext) -> [Podcast] {
        let request: NSFetchRequest<DPodcast> = DPodcast.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorited = \(true)")
        let podcasts = (try? context.fetch(request)) ?? []
        return podcasts //.sorted { $0.trackName < $1.trackName
    }
    
    class func fetch(trackId: Int, at context: NSManagedObjectContext) -> Podcast? {
        let request: NSFetchRequest<DPodcast> = DPodcast.fetchRequest()
        request.predicate = NSPredicate(format: "trackId_ = \(trackId) AND isFavorited = \(true)")
        
        return try? context.fetch(request).first
    }
    
    class func delete(trackId: Int, at context: NSManagedObjectContext) {
        if let entity = DPodcast.fetch(trackId: trackId, at: context) as? DPodcast {
//            context.delete(entity as! NSManagedObject)
            entity.isFavorited = false
            
            try? context.save()
        }
    }
}

extension DPodcast: Podcast {
    var trackId: Int {
        return Int(trackId_)
    }
    
    var trackCount: Int {
        return Int(trackCount_)
    }
    
    var artworkUrl600: String {
        return artwork
    }
}
