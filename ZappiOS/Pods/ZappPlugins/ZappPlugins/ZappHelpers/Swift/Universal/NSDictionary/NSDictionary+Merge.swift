//
//	NSDictionary+merge.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy 
//	of this software and associated documentation files (the "Software"), to deal 
//	in the Software without restriction, including without limitation the rights 
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
//	copies of the Software, and to permit persons to whom the Software is 
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in 
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

import Foundation

/*
	[Overiew]

	It doen't happen often, but when you like to merge two NSictionary, it is in fact
	a bit pain.  This pice of code may help you to make your coding life a bit eazier
	for that case.

	A dictionary's entries can be merged over the other dictionary entries.

	For example:
	["a": 1, "b": 2, "c": 30]		... d1
	["c": 3, "d": 4, "e": 5]		... d2

	When two dictionaries merged, in this case `d2` mereged over `d1`, all entries in `d1`
	are replaced with `d2` when applicable.

	["a": 1, "b": 2, "c": 3, "d": 4, "e": 5]	... d3 (merged)

	Here is an another case, when an entry is an array, and other dictionary's same
	entry is an array as well.  You like to merge the array as well.

	["a": [1, 2, 3], "b": [10, 20, 30]]		... d4
	["a": [4, 5, 6], "b": [40, 50, 60]]		... d5
	["a": [1, 2, 3, 4, 5, 6], "b": [10, 20, 30, 40, 50, 60]]   ... d6 (merged)

	or when an entry of both dictionary are both dictionary, those will be merged as well

	["a": ["p": 1, "q": 20, "r": 30]]			... d7
	["a": ["q": 2, "r": 3, "s": 4]]				... d8
	["a": ["p": 1, "q": 2, "r": 3, "s": 4]]		... d9

	However, the merging entry's type are different, then the destination's entry will be
	simply overwriien by the source's entry.

	["a": [1, 2, 3], b: 10, c: ["x": 100, "y": 200]]		... d10
	["a": "fr", "b": ["s": 25, "t": 50], "c": [10, 20, 30]]	... d11
	["a": "fr", "b": ["s": 25, "t": 50], "c": [10, 20, 30]]	... d12 (merged)

	[Usage]

	```
	let d11 = NSDictionary(dictionary: ["a": 1, "b": 2, "c": 3])
	let d12 = NSDictionary(dictionary: ["c": 13, "d": 14, "e": 15])
	let d13 = d11 + d12  // ["a": 1, "b": 2, "c": 13, "d": 14, "e": 15]
	```

	```
	let a11 = NSArray(array: [1, 2, 3])
	let a12 = NSArray(array: [4, 5, 6])
	let a13 = a11 + a12 // [1, 2, 3, 4, 5, 6]
	```

	```
	var d51 = NSMutableDictionary(dictionary: ["a": 1, "b": 2, "c": 3])
	let d52 = NSDictionary(dictionary: ["c": 13, "d": 14, "e": 15])
	d51 += d52 // merged
	```

	```
	var a21 = NSMutableArray(array: [1, 2, 3])
	let a22 = NSArray(array: [4, 5, 6])
	a21 += a22 // merged
	```
*/


extension NSDictionary {

	public static func + (lhs: NSDictionary, rhs: NSDictionary) -> NSDictionary {
		let dictionary = NSMutableDictionary()
		for (key, value) in lhs {
			if let key = key as? NSCopying {
				dictionary[key] = value
			}
		}
		for (key, valueR) in rhs {
			if let key = key as? NSCopying {
				if let valueL = lhs[key] {
					switch (valueL, valueR) {
					case (let dictionaryL as NSDictionary, let dictionaryR as NSDictionary):
						dictionary[key] = dictionaryL + dictionaryR
						break
					case (let arrayL as NSArray, let arrayR as NSArray):
						dictionary[key] = arrayL + arrayR
					default:
						dictionary[key] = valueR
					}
				}
				else {
					dictionary[key] = valueR
				}
			}
		}
		return dictionary
	}

}

extension NSMutableDictionary {

	public static func += (lhs: inout NSMutableDictionary, rhs: NSDictionary) {
		for (key, valueR) in rhs {
			if let valueL = lhs[key] {
				switch (valueL, valueR) {
				case (let dictionaryL as NSDictionary, let dictionaryR as NSDictionary):
					lhs[key] = dictionaryL + dictionaryR
				case (let arrayL as NSArray, let arrayR as NSArray):
					lhs[key] = arrayL + arrayR
				default:
					lhs[key] = valueR
				}
			}
			else {
				lhs[key] = valueR
			}
		}
	}

}

extension NSArray {

	public static func + (lhs: NSArray, rhs: NSArray) -> NSArray {
		let array = NSMutableArray()
		lhs.forEach { array.add($0) }
		rhs.forEach { array.add($0) }
		return array
	}

}

extension NSMutableArray {

	public static func += (lhs: inout NSMutableArray, rhs: NSArray) {
		for value in rhs {
			lhs.add(value)
		}
	}

}

