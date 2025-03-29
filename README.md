# KEXPPower
A networking library to communicate with streamguys and legacyAPI calls for tvOS. 

## UPDATING REQUIREMENTS
Modifying the KEXPPower requires the following
1. SSH Key from GitHub
2. Build permissions and access to KEXP Radio project

## MODIFY/BUILD STEPS
All build steps are captured in the document titled "Updating KEXPPower into KEXP Radio", available internally. The following are the high level steps covered in that document. 

1. Make changes in KEXPPOWER Repo files and test changes.
	a) You can point to local version and changes of KEXPPOWER using Swift Package Manager in consuming app (KexpTVStream)
2. Create Pull Request with changes
3. Once Approved, merge changes in Main branch
4. Create a new tag in KEXPPower repo
5. Update KEXPPower project to reflect new tag
