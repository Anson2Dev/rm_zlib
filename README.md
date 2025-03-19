# Z-Library Filename Cleanup Tool

English | [中文](README_CN.md)

## Overview

Files downloaded from Z-Library often contain `(Z-Library)` in their filenames, making them unnecessarily long and less readable. This tool is a Bash script designed to batch remove the `(Z-Library)` portion from filenames.

`rm_zlib.sh` is a Bash script that automatically scans the current directory and its subdirectories for filenames containing `(Z-Library)` and removes this portion from the filenames.

## Features

- Automatically scans directory tree for filenames containing `(Z-Library)`
- Displays progress bar and statistics
- Supports safe rename operations
- Provides detailed success/failure reports

## Usage

1. Place the script in the target directory
2. Grant execute permission:
   ```bash
   chmod +x rm_zlib.sh
   ```
3. Run the script:
   ```bash
   ./rm_zlib.sh
   ```

## Example Output

```
⏳ Scanning file system...
------------------------------------------------
Z-Library Filename Cleanup Tool started!
📂 Found 15 items to process
------------------------------------------------
🚀 Continue? [Y/n] y
| [■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■] 1/15  ✅ Success: example_file(Z-Library).txt...

Processing complete! 🎉
-----------------------
 Total time: 3 seconds
 Statistics:
  ✅ Success: 15
  ❌ Failure: 0
  📂 Total: 15
-----------------------
```

## TODO
- [ ] Support custom search paths
- [ ] Support custom search patterns
- [ ] Support custom rename patterns

## Dependencies

- Bash (version 4.0+)
- Common Unix tools: `find`, `mv`, `sed`, `tput`

## Notes

- Please ensure to back up important files before running the script
- The script does not modify file contents, only renames filenames
- Works on most Unix/Linux systems

## Contribution

Contributions and feature extensions are welcome. Please participate by creating pull requests or submitting issues.

## Version

- v1.0.0 Initial version