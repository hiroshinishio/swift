//===--- CxxSpanTests.swift ----------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import TestsUtils
import CxxStdlibPerformance
import CxxStdlib

let iterRepeatFactor = 7

// FIXME swift-ci linux tests do not support std::span
#if os(Linux)
public let benchmarks = [BenchmarkInfo]()

#else

public let benchmarks = [
  BenchmarkInfo(
    name: "CxxSpanTests.raw.iterator",
    runFunction: rawIterator,
    tags: [.validation, .bridging, .cxxInterop],
    setUpFunction: makeSpanOnce),
  BenchmarkInfo(
    name: "CxxSpanTests.index.subscript",
    runFunction: indexAndSubscript,
    tags: [.validation, .bridging, .cxxInterop],
    setUpFunction: makeSpanOnce),
  BenchmarkInfo(
    name: "CxxSpanTests.for.loop",
    runFunction: forInLoop,
    tags: [.validation, .bridging, .cxxInterop],
    setUpFunction: makeSpanOnce),
  BenchmarkInfo(
    name: "CxxSpanTests.map",
    runFunction: mapSpan,
    tags: [.validation, .bridging, .cxxInterop],
    setUpFunction: makeSpanOnce),
  BenchmarkInfo(
    name: "CxxSpanTests.filter",
    runFunction: filterSpan,
    tags: [.validation, .bridging, .cxxInterop],
    setUpFunction: makeSpanOnce),
  BenchmarkInfo(
    name: "CxxSpanTests.reduce",
    runFunction: reduceSpan,
    tags: [.validation, .bridging, .cxxInterop],
    setUpFunction: makeSpanOnce)
]

func makeSpanOnce() {
  initSpan()
}

@inline(never)
public func rawIterator(_ n: Int) {
  var sum: UInt32 = 0
  for _ in 0..<(n * iterRepeatFactor * 2) {
    var b = span.__beginUnsafe()
    let e = span.__endUnsafe()
    while b != e {
      sum = sum &+ b.pointee
      b = b.successor()
    }
  }
  blackHole(sum)
}

@inline(never)
public func indexAndSubscript(_ n: Int) {
  var sum: UInt32 = 0
  for _ in 0..<(n * iterRepeatFactor * 2) {
    for i in 0..<span.size() {
      sum = sum &+ span[i]
    }
  }
  blackHole(sum)
}

@inline(never)
public func forInLoop(_ n: Int) {
  var sum: UInt32 = 0
  for _ in 0..<(n * iterRepeatFactor * 2) {
    for x in span {
      sum = sum &+ x
    }
  }
  blackHole(sum)
}

@inline(never)
public func mapSpan(_ n: Int) {
  for _ in 0..<(n * iterRepeatFactor) {
    let result = span.map { $0 + 5 }
    blackHole(result)
  }
}

@inline(never)
public func filterSpan(_ n: Int) {
  for _ in 0..<(n * iterRepeatFactor) {
    let result = span.filter { $0 % 2 == 0 }
    blackHole(result)
  }
}

@inline(never)
public func reduceSpan(_ n: Int) {
  var sum: UInt32 = 0
  for _ in 0..<(n * iterRepeatFactor * 2) {
    sum = sum &+ span.reduce(sum, &+)
  }
  blackHole(sum)
}

#endif
