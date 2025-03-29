# KEXPPower

**KEXPPower** is a Swift networking library designed for tvOS, enabling seamless communication with StreamGuys and legacy API services.

## Features

- Network communication with StreamGuys
- Legacy API integration support
- Built specifically for use in tvOS environments

## Updating Requirements

To modify or update `KEXPPower`, ensure the following prerequisites are met:

1. An SSH key registered with GitHub  
2. Proper build permissions and access to the `KEXPPower` repository

## Modify / Build Steps

Follow these steps to make and integrate changes to `KEXPPower`:

1. **Open the Swift package in Xcode using the terminal:**
   ```bash
   xed .

2. **Make changes in the `KEXPPower` repo files and test locally**  
   a) You can point to your local version of `KEXPPower` using Swift Package Manager in the consuming app (`KexpTVStream`)
   
3. **Create a Pull Request** with your changes

4. Once approved, **merge the changes** into the `main` branch

5. **Create a new Git tag** in the `KEXPPower` repository to version your changes  
   Example:  
   ```bash
   git tag 1.2.3  
   git push origin 1.2.3

6. Update **KexpTVStream** to use the new version of KEXPPower

    a) In Xcode, navigate to File > Packages > Update to Latest Package Versions to fetch the new tag.
