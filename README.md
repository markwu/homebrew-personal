## Prerequisites
1. Install Xcode from the AppStore. If you installed the Xcode command line tools earlier (e.g. by installing Homebrew), run this:  

    ````bash
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
    ````
2. Install [Homebrew](https://brew.sh/) to install/compile the dependencies and Zeal itself.

## Installing Zeal from Homebrew
1. Compile the latest development version of Zeal from Homebrew

    ```bash
    brew tap koraysels/personal
    brew install --HEAD zeal
    ```
> Brew will automatically install the dependency `qt@5` and `libarchive` for you

2. Zeal is now available to be run. If you want you can move it to your Applications folder (not necessary if you run it through Spotlight):

    ```bash
    cp -Rp /usr/local/Cellar/zeal/*/Zeal.app ~/Applications/
    ```
