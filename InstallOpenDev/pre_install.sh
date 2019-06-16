#!/bin/bash

iOSSpec="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Specifications"
cp -r "Specifications/iPhoneOS" "${iOSSpec}"

iSimSpec="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Specifications"
cp -r "Specifications/iPhone Simulator" "${iSimSpec}"

iOSSDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library"
mkdir "${iOSSDK}/PrivateFrameworks"

iSimSDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library"
mkdir "${iSimSDK}/PrivateFrameworks"

mkdir "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr"
mkdir "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin"
