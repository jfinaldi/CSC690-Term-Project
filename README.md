# CSC690-Term-Project
Contact Tracing App

Jennifer Finaldi ID: 920290420

Contact Tracing iOS App

Overview: Uses location tracking in the iPhone to easily keep track of other phones that come into a certain vicinity of the user. 

# Features
## Must have:
- Display a list of the (appleIDs?) of the other phones that user came in contact with

- Modify list to output different data according to what the user wants (x days ago, etc)

- Push notification tells user if they have come in contact with an infected individual and may need to quarantine. 

- Keep track of any quarantine duration

- Self report button => backend search other users in contact => notify them

- Every 5 min, the app logs the location of the phone, using gps coordinates.

- If a user reports themselves sick, the app will push notifications to all app users who have similar gps locations within a 100' radius cached in data, 

## Good to have:

- Vicinity map 

- Show the user locations they have been
	
### Model
	- 14 arrays of location	
	- Back end servers/databases
	
### View Controllers
	- Create an Account VC:
		Connections:
		Action Button: Upload photo
		Action Button: Submit
		Text Field: Username
		Text Field: Password (hashed?)
		Label: Create an Account
		
		Functions:
		Action Button Clicked
		Upload Button Clicked
		
	- Home Screen VC: Changes depending on if the user is infected or not
		
### Backend 
	It handles self report and notify other users
	Node+MySQL(?)
