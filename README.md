# Flag Guessing Game

An iOS app that lets you guess the correct flag emoji for a given country. It is written in SwiftUI and tracks high scores in a simple on-device leaderboard.

Made with ❤️ by Megan, Giacomo and Shilpi 

## How to Play

Launch the app and tap the **Play** button. 🕹️ Enter your name, pick a difficulty, and race the clock to match each flag to its country. 🌍

* Difficulty sets the pace 🏁  
  * **Level 1** shows two flags per round (gentle warm-up) 🌱  
  * **Level 2** shows four flags per round (balanced challenge) 🌟  
  * **Level 3** shows six flags per round (expert mode) 🔥  

* You have two limits ⏳❤️  
  * A **30-second countdown timer** ⏱️  
  * **Three hearts (lives)** 💔  

  The game ends when either one runs out. ❌

* On-screen indicators keep you focused 🔍  
  * **Top left:** Remaining time ⏲️ and chosen name 📝  
  * **Centre:** Your current score 📊 and the best score ever recorded on this device 🏆  
  * **Top right:** Hearts ❤️  

* Flag values range from 1 to 25. The scoring algorithm rewards obscurity, so recognising a little-known flag can change the result in an instant. 🥇🌍

Master the map, climb the leaderboard, and see how many rare flags you can identify before time or hearts expire! 🚀


## App Views
<table>
  <tr>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/98dbd961-1b5d-4825-b577-04fd1f3dc53e" alt="Start screen" width="100%"><br/>
      <em>Start screen</em>
    </td>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/31d9a768-fbc7-4bd8-919f-8196e5daac7e" alt="In-game" width="100%"><br/>
      <em>Settings View</em>
    </td>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/ae20592f-58cd-4b09-a962-1d03efbfe707" alt="Game over" width="100%"><br/>
      <em>Game View</em>
    </td>
    <td align="center" width="25%">
      <img src="https://github.com/user-attachments/assets/3f583a45-37c3-4570-80b4-d7a0ca0e2525" alt="Leaderboard" width="100%"><br/>
      <em>Leaderboard</em>
    </td>
  </tr>
</table>

<p align="center"><em><b>Figure 1</b>: Main app views</em></p>

## Future Improvements 🚀

This app is just an MVP, but we have brainstormed ways to enhance and expand it in the future. We're considering:

- **Custom Game Duration**: Add a slider to choose the game time, allowing for shorter or longer rounds. ⏳  
- **Improved Leaderboard**: Introduce more features such as filtering by difficulty, viewing historical high scores, and tracking personal bests. 🏆  
- **Sound Effects and Music**: Add sound cues for correct and incorrect answers, as well as background music that matches the game’s pace. 🎵  
- **Enhanced Visuals**: Implement smooth animations when selecting the correct flag or losing a life to make gameplay more dynamic and visually appealing. ✨  
- **Detailed Statistics**: Track gameplay metrics such as the most frequently mistaken flags, average answer time, and performance by point value. 📊  
- **Adaptive Scoring Algorithm**: Adjust flag scores dynamically based on how often players mistake them, making the game more balanced over time. 🤔  
- **Reverse Mode**: Flip the challenge by giving the country name and asking players to choose the correct flag. 🔄  

These improvements aim to make the game more customizable, engaging, and visually dynamic, offering a richer experience for players of all levels. 🌟


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
```
git clone https://github.com/giacomograzia/assignment-3-iOSDev.git
cd assignment-3-iOSDev
```

## Open the workspace in Xcode
```
open flagGuessingGame/flagGuessingGame.xcworkspace
```




