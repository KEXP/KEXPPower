# KEXPPower
A networking library to communicate with streamguys and legacyAPI calls for iOS and tvOS. 

## UPDATING REQUIREMENTS
Modifying the KEXPPower requires the following
1. SSH Key from GitHub
2. CocoaPod Permissions
3. Build permissions and access to KEXP Radio project

## BUILD STEPS
All build steps are captured in the document titled "Updating KEXPPower into KEXP Radio", available internally. The following are the high level steps covered in that document. 

1. Make changes in KEXP Radio Pod files and test changes.
2. Update PodFile in KEXP Radio
3. Run update to pod to push changes to KEXP Radio
4. Create a new tag in KEXPPower repo
5. Update KEXPPower project to reflect new tag
6. Register session with CocoaPods
7. Push all new changes to CocoaPods
8. Push changes to Github
9. Create new Version and set tag
