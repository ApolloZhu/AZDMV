# Disclaimer

I have no relationship with Virginia Department of Motor Vehicles (DMV). All information might be outdated, so please refer to the following links for accurate information:

- Data Provider: [Driver's Study Guide](https://www.dmv.virginia.gov/dmv-manuals/#/sections/manual/1)
- Logo Borrowed From: [DMV Website](https://www.dmv.virginia.gov/#/)

The reason why the informations are outdated is because the app is powered by JSON data I manually added to the project. The way I got the data is by looking into session data of the website and found `manualQuiz` and `manual`. 

> Apollo, 2016/12/22, preparing for DMV test

---

# DMV

An app you can use to practice for Virginia DMV tests written in Swift 3 under MIT license.

## How to use?

You may notice that answer choices/questions are probably not fitted in the button/label and ends with `...`. To view the whole answer/question, long press on them!

## Dependencies

- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [TTGSnackbar](https://github.com/zekunyan/TTGSnackbar)

## Test UI
Traffic Signals (Section 2.1) -> 1010
Yielding and Roundabouts (Section 3.2) -> 1057

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
