//
// Created by alexander on 6/14/2021.
//

import Foundation

extension Dictionary where Value: Hashable {
    func invert() -> [Value: Key] {
        var result = [Value: Key]()
        for (k, v) in self {
            result[v] = k
        }

        return result
    }
}
