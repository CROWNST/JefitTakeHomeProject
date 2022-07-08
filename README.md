# JefitTakeHomeProject
My take home project for Jefit
## General Info & Requirements
Thanks for seeing my project! This project requires iOS 15.5 and Swift 5 to run. To run the project,
open the project in Xcode, select a simulator, and click the run button. The project can be found
online at https://github.com/CROWNST/JefitTakeHomeProject. However, the file containing the Yelp Fusion API key is
ignored by version control, so the project must be run from the zip file.
## How to Use the Project
After the app loads, a list of five city names appears on the home screen. Selecting a city name 
navigates to the business screen, showing at most ten business names in the selected city. Next to
each business name is a either a filled heart if it is liked by the user, or an empty heart if it
is not. Selecting a business name will navigate to the business details screen, showing an image
of the business, its information, up to three review excerpts, and a bar button item for toggling
the like status for the business. Likes are saved persistenly to the device. Network activity is
indicated to the user, and alerts notify the user of network or storage errors. Back buttons let
the user return to the home screen.
