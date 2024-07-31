// RUN: %empty-directory(%t)

// RUN: %target-build-swift %s \
// RUN: -module-name=Lib -package-name Pkg \
// RUN: -parse-as-library -emit-module -emit-module-path %t/Lib.swiftmodule -I%t \
// RUN: -Xfrontend -experimental-package-cmo -Xfrontend -experimental-allow-non-resilient-access \
// RUN: -O -wmo -enable-library-evolution

// RUN: %target-sil-opt %t/Lib.swiftmodule -sil-verify-all -o %t/Lib.sil
// RUN: %FileCheck %s < %t/Lib.sil

// REQUIRES: swift_in_compiler

import Foundation

@objc
public protocol ProtoObjc {
  var pubVar: String { get }
}

public class PubKlass: ProtoObjc {
  // CHECK-NOT: sil [serialized_for_package] [canonical] @$s3Lib8PubKlassC6pubVarSSvg : $@convention(method) (@guaranteed PubKlass) -> @owned String {
  public var pubVar: String { return "" }
}


// CHECK-NOT: sil_vtable [serialized_for_package] FooObjc {
// CHECK-NOT: sil_vtable [serialized_for_package] BarObjc {

@objc
public class FooObjc: NSObject {
  // CHECK-NOT: sil [serialized_for_package] [canonical] @$s3Lib7FooObjcC3barAA03BarC0Cvg : $@convention(method) (@guaranteed FooObjc) -> @owned BarObjc {
  // CHECK-NOT: sil [serialized_for_package] [canonical] @$s3Lib7FooObjcC3barAA03BarC0Cvs : $@convention(method) (@owned BarObjc, @guaranteed FooObjc) -> () {
  // CHECK-NOT: sil [serialized_for_package] [canonical] @$s3Lib7FooObjcC3barAA03BarC0CvM : $@yield_once @convention(method) (@guaranteed FooObjc) -> @yields @inout BarObjc {
  public var bar: BarObjc

  public init(_ arg: BarObjc) {
    bar = arg
  }
}

@objc
public class BarObjc: NSObject {
}

package struct PkgStruct {
  // CHECK-NOT: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV3fooAA7FooObjcCvg : $@convention(method) (@in_guaranteed PkgStruct) -> @owned FooObjc {
  // CHECK-NOT: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV3fooAA7FooObjcCvs : $@convention(method) (@owned FooObjc, @inout PkgStruct) -> () {
  // CHECK-NOT: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV3fooAA7FooObjcCvM : $@yield_once @convention(method) (@inout PkgStruct) -> @yields @inout FooObjc {
  package var foo: FooObjc

  // CHECK-NOT: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV8usesObjcyXlvg : $@convention(method) (@in_guaranteed PkgStruct) -> @owned AnyObject {
  package var usesObjc: AnyObject { foo.bar as AnyObject }

  // PkgStruct.swiftVar.getter
  // CHECK-DAG: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV8swiftVarSSvg : $@convention(method) (@in_guaranteed PkgStruct) -> @owned String {
  // PkgStruct.swiftVar.setter
  // CHECK-DAG: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV8swiftVarSSvs : $@convention(method) (@owned String, @inout PkgStruct) -> () {
  // PkgStruct.swiftVar.modify
  // CHECK-DAG: sil package [serialized_for_package] [canonical] @$s3Lib9PkgStructV8swiftVarSSvM : $@yield_once @convention(method) (@inout PkgStruct) -> @yields @inout String {
  package var swiftVar: String
}

// CHECK: sil_vtable [serialized_for_package] PubKlass {
// CHECK:   #PubKlass.pubVar!getter: (PubKlass) -> () -> String : @$s3Lib8PubKlassC6pubVarSSvg
// CHECK:   #PubKlass.deinit!deallocator: @$s3Lib8PubKlassCfD
