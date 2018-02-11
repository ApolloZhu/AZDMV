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

[![Download on the App Store](https://devimages.apple.com.edgekey.net/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg)](https://itunes.apple.com/us/app/azdmv/id1193281712)

## Tips for Taking the Learner's Permit Test

You SHOULD read the driver's manual CAREFULLY. Then you should try ALL the problems included in this app. 

You might want to pay more attentions on the following problems. A lot of my friends got wrong on them.

- 3.7 Backing and Parking, 1121
- 3.8 Dangerous Driving Behaviors, 1143

If you want more practices, we used a Kahoot game in our Drivers Education class as a review -- [Driver Education Review by NSWalsh](https://play.kahoot.it/#/k/5e087226-a672-426e-b561-59f7d9f237ef/intro)

---

# For Developers

This app is written in Swift 3, under MIT license.

Run `pod install` before opening the `DMV.xcworkspace` file

## Dependencies

- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [TTGSnackbar](https://github.com/zekunyan/TTGSnackbar)

## TODO 

> Anyone who reads all the way done here -- PLEASE HELP! 

- [x] Quiz
- [x] Auto adjust text size
- [ ] Record how many times correct/total tried
- [ ] Calculate percentage of a question, a subsection, a section, and overall
- [ ] Notice that there is an attribute called `category` having two possible values: `Sign` and `Safety`, how about some statistics?
- [ ] Favorite, wrong, correct filter
- [ ] Quiz Simulation
- [ ] Get data online! Keep stuff synchronized(as long as it does not break current logic)!
- [ ] Add manual for study
- [ ] List all signs and their meanings
