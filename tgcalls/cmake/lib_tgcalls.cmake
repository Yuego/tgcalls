add_library(lib_tgcalls STATIC)

if (WIN32)
    init_target(lib_tgcalls cxx_std_17) # Small amount of patches required here.
elseif (LINUX)
    init_target(lib_tgcalls) # All C++20 on Linux, because otherwise ODR violation.
else()
    init_target(lib_tgcalls cxx_std_14) # Can't use std::optional::value on macOS.
endif()


set(tgcalls_dir ${third_party_loc}/lib_tgcalls)
set(tgcalls_loc ${tgcalls_dir}/tgcalls)

nice_target_sources(lib_tgcalls ${tgcalls_loc}
        PRIVATE
        Instance.cpp
        Instance.h

        CodecSelectHelper.cpp
        CodecSelectHelper.h
        CryptoHelper.cpp
        CryptoHelper.h
        EncryptedConnection.cpp
        EncryptedConnection.h
        InstanceImpl.cpp
        InstanceImpl.h
        LogSinkImpl.cpp
        LogSinkImpl.h
        Manager.cpp
        Manager.h
        MediaManager.cpp
        MediaManager.h
        Message.cpp
        Message.h
        NetworkManager.cpp
        NetworkManager.h
        ThreadLocalObject.h
        VideoCaptureInterface.cpp
        VideoCaptureInterface.h
        VideoCaptureInterfaceImpl.cpp
        VideoCaptureInterfaceImpl.h
        VideoCapturerInterface.h

        platform/PlatformInterface.h

        # Android
        platform/android/AndroidContext.cpp
        platform/android/AndroidContext.h
        platform/android/AndroidInterface.cpp
        platform/android/AndroidInterface.h
        platform/android/VideoCameraCapturer.cpp
        platform/android/VideoCameraCapturer.h
        platform/android/VideoCapturerInterfaceImpl.cpp
        platform/android/VideoCapturerInterfaceImpl.h

        # iOS / macOS
        platform/darwin/DarwinInterface.h
        platform/darwin/DarwinInterface.mm
        platform/darwin/GLVideoView.h
        platform/darwin/GLVideoView.mm
        platform/darwin/TGRTCCVPixelBuffer.h
        platform/darwin/TGRTCCVPixelBuffer.mm
        platform/darwin/TGRTCDefaultVideoDecoderFactory.h
        platform/darwin/TGRTCDefaultVideoDecoderFactory.mm
        platform/darwin/TGRTCDefaultVideoEncoderFactory.h
        platform/darwin/TGRTCDefaultVideoEncoderFactory.mm
        platform/darwin/TGRTCVideoDecoderH264.h
        platform/darwin/TGRTCVideoDecoderH264.mm
        platform/darwin/TGRTCVideoDecoderH265.h
        platform/darwin/TGRTCVideoDecoderH265.mm
        platform/darwin/TGRTCVideoEncoderH264.h
        platform/darwin/TGRTCVideoEncoderH264.mm
        platform/darwin/TGRTCVideoEncoderH265.h
        platform/darwin/TGRTCVideoEncoderH265.mm
        platform/darwin/VideoCameraCapturer.h
        platform/darwin/VideoCameraCapturer.mm
        platform/darwin/VideoCameraCapturerMac.h
        platform/darwin/VideoCameraCapturerMac.mm
        platform/darwin/VideoCapturerInterfaceImpl.h
        platform/darwin/VideoCapturerInterfaceImpl.mm
        platform/darwin/VideoMetalView.h
        platform/darwin/VideoMetalView.mm
        platform/darwin/VideoMetalViewMac.h
        platform/darwin/VideoMetalViewMac.mm

        # POSIX

        # Teleram Desktop
        platform/tdesktop/DesktopInterface.cpp
        platform/tdesktop/DesktopInterface.h
        platform/tdesktop/VideoCapturerInterfaceImpl.cpp
        platform/tdesktop/VideoCapturerInterfaceImpl.h
        platform/tdesktop/VideoCapturerTrackSource.cpp
        platform/tdesktop/VideoCapturerTrackSource.h
        platform/tdesktop/VideoCameraCapturer.cpp
        platform/tdesktop/VideoCameraCapturer.h

        # All
        reference/InstanceImplReference.cpp
        reference/InstanceImplReference.h
        )

target_link_libraries(lib_tgcalls
        PRIVATE
        external_webrtc
        )


target_compile_definitions(lib_tgcalls
        PRIVATE
        WEBRTC_APP_TDESKTOP
        RTC_ENABLE_VP9
        )

if (WIN32)
    target_compile_definitions(lib_tgcalls
            PRIVATE
            WEBRTC_WIN
            )
elseif (APPLE)
    target_compile_options(lib_tgcalls
            PRIVATE
            -fobjc-arc
            )
    target_compile_definitions(lib_tgcalls
            PRIVATE
            WEBRTC_MAC
            )

    remove_target_sources(lib_tgcalls ${tgcalls_loc}
            platform/darwin/GLVideoView.h
            platform/darwin/GLVideoView.mm
            platform/darwin/VideoCameraCapturer.h
            platform/darwin/VideoCameraCapturer.mm
            platform/darwin/VideoMetalView.h
            platform/darwin/VideoMetalView.mm
            platform/darwin/VideoMetalViewMac.h
            platform/darwin/VideoMetalViewMac.mm
            platform/tdesktop/DesktopInterface.cpp
            platform/tdesktop/DesktopInterface.h
            platform/tdesktop/VideoCapturerTrackSource.cpp
            platform/tdesktop/VideoCapturerTrackSource.h
            platform/tdesktop/VideoCapturerInterfaceImpl.cpp
            platform/tdesktop/VideoCapturerInterfaceImpl.h
            )
else()
    target_compile_definitions(lib_tgcalls
            PRIVATE
            WEBRTC_LINUX
            )
endif()

remove_target_sources(lib_tgcalls ${tgcalls_loc}
        platform/android/AndroidContext.cpp
        platform/android/AndroidContext.h
        platform/android/AndroidInterface.cpp
        platform/android/AndroidInterface.h
        platform/android/VideoCameraCapturer.cpp
        platform/android/VideoCameraCapturer.h
        platform/android/VideoCapturerInterfaceImpl.cpp
        platform/android/VideoCapturerInterfaceImpl.h
        reference/InstanceImplReference.cpp
        reference/InstanceImplReference.h
        )

target_include_directories(lib_tgcalls
        PUBLIC
        ${tgcalls_dir}
        PRIVATE
        ${tgcalls_loc}
        )
