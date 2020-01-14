//
//  String+Extensions.swift
//  FuzzyTest2
//
//  Created by Michael Isasi on 1/13/20.
//  Copyright © 2020 Michael Isasi. All rights reserved.
//

extension String {
    
    var threes: Set<Set<Character>> {

        var foundSets = Set<Set<Character>>()
        //if the term is 3 or less chars then return self
        guard self.count > 3 else {
            foundSets.insert( Set(self) )
            return foundSets
        }

        let selfArray = Array(self)
        for index in 0...self.count - 3 {
            foundSets.insert(Set(selfArray[index..<index+3]))
        }
        return foundSets
    }
    
    ///Threes search
    /// - Important: Returns pass/fail and number of common elements
    func fuzzyContains(string s2: String, toloranceLevel: Int) -> (Bool, Int) {
        
        guard s2.count >= 3 else {
            return (self.contains(s2), 1)
        }
        
        let s1Threes = self.threes
        let s2Threes = s2.threes
        
        let toloranceCount = 1 - (0.15 *  Double(toloranceLevel))
        
        let common = s2Threes.filter{ s1Threes.contains($0)}
        
        return (Double(common.count) > (Double(s2Threes.count) * toloranceCount), common.count)
    }
    
    func levenshteinCount( bStr: String) -> Int {
        
        let aStr = self
        // create character arrays
        let a = Array(aStr)
        let b = Array(bStr)

        // initialize matrix of size |a|+1 * |b|+1 to zero
        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append([Int].init(repeating: 0, count: b.count + 1))
        }

        // 'a' prefixes can be transformed into empty string by deleting every char
        for i in 1...a.count {
            dist[i][0] = i
        }

        // 'b' prefixes can be created from empty string by inserting every char
        for j in 1...b.count {
            dist[0][j] = j
        }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]  // noop
                } else {
                    dist[i][j] = Swift.min(
                        dist[i-1][j] + 1,  // deletion
                        dist[i][j-1] + 1,  // insertion
                        dist[i-1][j-1] + 1  // substitution
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }
    
    ///Lev search
    /// - Important: Returns pass/fail and number of misses
    func containsLevenshtein( bStr: String, toloranceLevel: Int) -> (Bool, Int) {
        let lossCount =  7 - toloranceLevel
        let dif = max(self.count - bStr.count, 0)
        let count = self.levenshteinCount(bStr: bStr)
        return (count <= (bStr.count / lossCount) + dif, count)
    }
}
