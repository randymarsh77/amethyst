// Just a target to leverage swift cli!
//
// Pull in solution wide dependencies to be linked in each target.
//
// Workflow:
//  - Update Package.swift to add or update dependencies
//  - Use 'swift build' to pull in latest packages
//  - Use 'swift package generate-xcodeproj' to re-generate this project file
//  - Re-link CAsync with CoreFoundation (and any other special case linking)
//  - Update target os from default (macOS) to every os,including iphonesimulator
//
