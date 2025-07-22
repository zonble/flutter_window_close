## 1.3.0

- Migrate to modern `web` packages for improved Flutter Web compatibility
- Update all dependencies to their latest stable versions
- Raise minimum Flutter version to 3.22.0 for better stability
- Update CI to use Windows Server 2025 for improved testing
- Enhance code quality with flutter_lints 5.0.0
- Thanks to [@vant3ch](https://github.com/vant3ch) for the web packages migration

## 1.2.0

- Add full Swift Package Manager (SPM) support for easier iOS/macOS integration
- Restructure macOS implementation to support SPM
- Add dedicated SPM CI workflow for automated testing
- Update project structure for modern package management

## 1.1.0

- Enhance the way active windows are determined on macOS for better reliability
- Update macOS example application with improved implementation
- Integrate Dependabot for automated dependency updates
- Update flutter_lints to 4.0.0 for better code quality
- Clean up and streamline CI settings

## 1.0.0

- Prevent window closing only after the plugin is properly initialized
- Enhance stability and reliability across all platforms (Windows, macOS, Linux)
- Fix window closing prevention to work only after SDK initialization on Windows
- Major updates to continuous integration settings
- Improve code structure and documentation

## 0.3.0

- Fix Linux plugin compatibility issues with Flutter 3.10 and above
- Update to use modern menu APIs for better future compatibility
- Update project dependencies to latest versions
- Enhance CI settings for better testing coverage

## 0.2.2

- Allow setting the web return value to null for more flexible web implementations
- Update continuous integration settings
- Thanks to [@doppio](https://github.com/doppio) for the web return value enhancement

## 0.2.1

- Fix critical issue where windows wouldn't close when the close message was sent after a delay on Windows
- Improve window reference handling in Windows plugin for better memory management

## 0.2.0

- Add full support for Flutter Web applications
- Extend cross-platform support to Windows, macOS, Linux, and Web
- Update example applications with web support
- Enhance README files with web usage examples
- Clean up build artifacts and unused files

## 0.1.1

- Comprehensive documentation improvements in README files
- Enhanced code documentation and API usage examples
- Update example applications with better implementations

## 0.1.0

- Initial release with basic window close confirmation for desktop platforms
- Support for Windows, macOS, and Linux platforms
- Clean, simple API for handling window close events
- Complete example applications for all supported platforms
- Windows: Full implementation with proper window message handling
- macOS: Native Cocoa implementation for close button interception
- Linux: GTK-based implementation for window close confirmation
- Seamless integration with Flutter's plugin architecture
