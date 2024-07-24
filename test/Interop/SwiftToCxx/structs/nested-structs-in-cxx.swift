// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend %s -enable-library-evolution -typecheck -module-name Structs -clang-header-expose-decls=all-public -emit-clang-header-path %t/structs.h
// RN: %FileCheck %s < %t/structs.h

// RUN: %check-interop-cxx-header-in-clang(%t/structs.h -DSWIFT_CXX_INTEROP_HIDE_STL_OVERLAY -std=c++17)

public enum AudioFileType {
	case CAF, WAVE
}

public enum AudioFormat {
	case PCM, ALAC, AAC
}

public struct RecordConfig {
	public struct Directory {
		public var path: String?
		public var diskSpaceBudgetGB: Double = 5.0
	}

	public struct File {
		public var type: AudioFileType = .CAF
		public var format: AudioFormat = .ALAC
		public var bitDepth: UInt = 20

        public struct Gate {
            public var triggerThresholdDB: Double = -80.0
            public var stopThresholdDB: Double = -80.0
            public var paddingDurationSec: Double = 0.500
            public var silenceDurationSec: Double = 5.0
        }
	}

	public var directory = Directory()
	public var file = File()
	public var gate = File.Gate()
}

public func makeRecordConfig() -> RecordConfig {
    return RecordConfig()
}