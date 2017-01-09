# Disclaimer

I have no relationship with Virginia Department of Motor Vehicles (DMV). All information might be outdated, so please refer to the following links for accurate information:

- Data Provider: [Driver's Study Guide](https://www.dmv.virginia.gov/dmv-manuals/#/sections/manual/1)
- Logo/Photos Borrowed From: [DMV Website](https://www.dmv.virginia.gov/#/)

The reason why the informations are outdated is because the app is powered by JSON file I manually added to the project. The way I got the data is by looking into session data of the website and found `manualQuiz` and `manual`. 

> Apollo, 2016/12/22, preparing for DMV test

> UPDATE: I got ALL correct on the exam!

---

# DMV A-Z

An app you can use to practice for (Virginia) DMV tests

## Tips of Usage

You may notice that answer choices/questions are too small to see. Long press on it and you'll get a pop up!

Generally you should read the driver's manual carefully, and practice all the problems. But here are a few problems that people I know got wrong

- 3.7 Backing and Parking, 1121
- 3.8 Dangerous Driving Behaviors, 1143

---

# For Developers

This app is written in Swift 3, under MIT license.

Run `pod install` before opening the `DMV.xcworkspace` file

## Dependencies

- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [TTGSnackbar](https://github.com/zekunyan/TTGSnackbar)

## Test UI

- 2.1 Traffic Signals, 1010
- 3.2 Yielding and Roundabouts, 1057

## TODO 

> Anyone read all the way done here: PLEASE HELP! 

- [x] Quiz
- [ ] Auto adjust text size
	- [x] Now everything fits! 
	- [ ] We need to somehow increase the font size so it is easier to see. (But let's preserve long press to magnify mechanism)
- [ ] Record how many times correct/total tried
- [ ] Calculate percentage of a question, a subsection, a section, and overall
- [ ] Notice that there is an attribute called `category` having two possible values: `Sign` and `Safety`, how about some statistics?
- [ ] Favorite, wrong, correct filter
- [ ] Quiz Simulation
- [ ] Get data online! Keep stuff synchronized(as long as it does not break current logic)!
- [ ] Add manual for study
- [ ] List all signs and their meanings
