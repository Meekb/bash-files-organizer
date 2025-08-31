# File Organizer (bash)

A simple Bash script that organizes files by extension.  
It moves files from a source folder into subfolders inside a target folder based on their file type.

---

## Table of Contents
- [About](#about)
- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)

---

## About
The File Organizer helps keep your folders clean by automatically sorting files into subfolders based on their file extensions.  

For example: `.txt` files go into a `txt/` folder, `.jpg` files into a `jpg/` folder, and files without an extension are placed in `no-ext-files/`.

---

## Usage

```bash
./files_organizer.sh ./unorganized ./organized
```
Creates subfolders like png, pdf, txt, etc.

Files without an extension are placed in no-ext-files.

####  Safety:
- The script first `copies` the files from `./unorganized` into `./organized`  
- Uses `${ORGANIZED:?}` so it will `exit` if the organized path is empty - preventing accidental `rm -rf /*`

## Requirements
- Bash 4+
  - macOS 13+ includes this by default
  - For older macOS: install via Homebrew
    -  `brew install bash`

## Installation
### Clone the repository
- `git clone git@github.com:Meekb/bash-files-organizer.git`
- `cd bash-file-organizer`
- Open the `./unorganized` directory and look at the files
- Open `./files_organizer.sh`
  - Change the value of `USER` to your username 


### Make the script executable
```bash
chmod +x files_organizer.sh
```

## Example

### Before
unorganized/  
├── document.txt  
├── photo1.jpeg  
├── photo2.jpeg  
├── report.pdf  
├── script

### Run
`./files_organizer.sh ./bash_unorganized ./bash_organized
`

### After
organized/  
├── txt/  
│   └── document.txt  
├── jpeg/  
│   ├── photo1.jpeg  
│   └── photo2.jpeg  
├── pdf/  
│   └── report.pdf  
└── no-ext-files/  
└── script
