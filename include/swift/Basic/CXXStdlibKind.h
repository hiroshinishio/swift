//===--- CXXStdlibKind.h ----------------------------------------*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#ifndef SWIFT_BASIC_CXX_STDLIB_KIND_H
#define SWIFT_BASIC_CXX_STDLIB_KIND_H

namespace swift {

enum class CXXStdlibKind : uint8_t {
  /// Use the default C++ stdlib for a particular platform: libc++ for Darwin,
  /// libstdc++ for most Linux distros.
  PlatformDefault = 0,
  
  /// Use libc++ instead of the default C++ stdlib on a platform where libc++
  /// is not the default, e.g. Ubuntu.
  OverrideLibcxx = 1,
};

} // namespace swift

#endif // SWIFT_BASIC_CXX_STDLIB_KIND_H
