# 定义输出文件夹 SRCROOT:当前project根目录
UNIVERSAL_OUTPUTFOLDER=${SRCROOT}/Framework

#build mode Release
BUILD_MODE=Release

# 创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
rm -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework"

# 分别编译模拟器和真机的Framework
xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration "${BUILD_MODE}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build -UseModernBuildSystem=NO

xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration "${BUILD_MODE}" -sdk iphonesimulator clean build BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build -UseModernBuildSystem=NO

# 拷贝真机的framework到univer目录
cp -R "${BUILD_DIR}/${BUILD_MODE}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# 合并framework，输出最终的framework到build目录
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${BUILD_MODE}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${BUILD_MODE}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"

# 删除 build文件夹
rm -r "build"
