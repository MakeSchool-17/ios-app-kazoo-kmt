#App Design Document


##Objective
DozePrevention is an app that keep drivers awake when driving. 
(Future: this app tracks drivers' behaviours)

##Audience
Drivers who drive a lot. Along with the rising ride-sharing economy, ordinary people are becoming taxi drivers and the risks to have accidents are increasing. By introducing this app, drivers can drive safely. 

##Experience
Putting your phone in front of you by using smartphone car mount (Future: attaching IRlight and IRcamera to your smartphone). 
When feeling sleepy, this app recognises your eye motion and sounds an alert in order to make you wake up. 
(Future: Recording your face and driving behaviour every time when driving and analysing your health and how to improve your driving skills)
(Future: Recording a sound when you drive, and if accidental situation occurs, this app makes emergency call to police or ride-sharing companies)

##Technical

####External Services
- Core Image (CIDetector) or OpenCV (need to choose beforehand) in order to detect eye motion 
- IRlight(+camera) attachment (after making MVP)

####Screens
- EyeDetection: conducting the main feature of this app. Providing a user how this app now watches your eye by showing user's face and drawing a circle onto each eye.
- HowToUse: It will be shown up after the first installation. Explaining how to use and how it works.
- Setting: Letting a user adjust the timing of alert, type of sound and volume of sound.
- (may need a screen for the initial calibration of user's face)

####Views / View Controllers/ Classes

####Data Models
- Realm(?) to store the data about how much time a user (a driver) closes each eye.

##MVP Milestones
Week 1 (Nov 9-), Week 2 (Nov 16-): 
- Search library and tutorial

Week 3 (Nov 23-): 
- Work on sample code for eye detection
- Make EyeDetection view and controller
- Make basic storyboard

Week 4 (Nov 30-): 
- Add sound feature
-Test with new users

Week 5 (Dec 7-):
-Write basic instructions for new users
-Add basic instructions to display first time app is launched
- Make IR light

Week 6 (Dec 14-):
- Modify UI/UX

Week 7 (Jan 4-):
- Work on the remaining tasks and modification
- Polish and ship

Week 8 (Jan 11-):
- Polish and ship

*Jan 14 (Thu) 18:00-21:00 Demo Night
