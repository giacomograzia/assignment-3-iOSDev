# Flag Guessing Game

An iOS app that lets you guess the correct flag emoji for a given country. It is written in SwiftUI and tracks high scores in a simple on-device leaderboard.
By Megan, Giacomo and Shilpi

## Repository
<https://github.com/giacomograzia/assignment-3-iOSDev>

## Content
The repository is organised into three top-level folders.

* **`assets`**  
  Holds static media used by the app. At the moment this is a single background image that appears behind most game views.

* **`countriesDataset`**  
  Stores the raw emoji-flag data set together with a Jupyter notebook that merges country information with the flag emoji list, computes a score for every country and writes a JSON file ready for the game.

* **`flagGuessingGame`**  
  Contains the Xcode project itself.  
  The project’s root folder has the workspace and project files.  
  Inside **`flagGuessingGame/`** (same name as the parent) you will find the Swift source files, SwiftUI views and asset catalog.

* **`prototypingViews.pages`**  
  Contains the Pages file used for prototyping the app views before building them in Xcode.  

### Directory structure

```text
.
├── assets/
│   └── backgroundMap.png
├── countriesDataset/
│   ├── countriesWorld.csv
│   ├── final_matches.csv
│   ├── flags_review.csv
│   └── createDataset.ipynb
├── flagGuessingGame/
│   ├── flagGuessingGame.xcodeproj
│   └── flagGuessingGame/
│       ├── Assets.xcassets
│       ├── emoji_flags_data.json
│       ├── ContentView.swift
│       ├── Country.swift
│       ├── CountryDataManager.swift
│       ├── GameView.swift
│       ├── Item.swift
│       ├── LeaderboardModel.swift
│       ├── LeaderboardView.swift
│       ├── PlayerScores.swift
│       ├── SettingsView.swift
│       └── flagGuessingGameApp.swift
├── prototypingViews.pages
└── .gitignore
```

## Cloning the repo
git clone https://github.com/giacomograzia/assignment-3-iOSDev.git
cd assignment-3-iOSDev

## Open the workspace in Xcode
open flagGuessingGame/flagGuessingGame.xcworkspace

