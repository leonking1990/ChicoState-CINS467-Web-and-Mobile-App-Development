# Assignment 6

## Summary

I updated the app from Assignment 4 to implement Firestore, added a delete function, and made some quality of life improvements regarding usability.

## Details about Assignment 6:

* **Use a Form**
    * There needs to be some way for the user to provide text input and submit their input:
        * Used `showDialog` to add to the To-Do list. This can be done by tapping the plus button in the bottom corner.
        * Another `showDialog` to add a task under the To-Do instance. This can be done by tapping the desired To-Do text.
    * Need to have at least two separate fields where users can enter input: 
        * `showDialog` to add a To-Do.
        * `showDialog` to add a Task under the To-Do.

* **Store a Persistent State in SQLite DB, Local Filesystem, or Platform-Specific Persistent Storage**
    * You must store at least two different data types (e.g., String, int, bool, double, List):
        * I am storing instances of To-Do, each class has a String and List<dynamic>.
    * You must successfully use one of the plugins:
        * Used `cloud_firestore` and `firebase_core` plugins.

* **Have the Form Update the State**
    * When the form receives user input, it must update data that is stored in a persistent state:
        * This is done each time the user adds or deletes a new To-Do or task, or taps the task to mark it as complete.

* **Reflect Database Changes in the App State**
    * When the data in your Firestore Database changes, the view that the user sees in your app must also update to reflect that change:
        * This is accomplished within the `FireStorage` class. A function listens for a change in the database to update the state of the app accordingly.
    * The updates to the state and view should be tested with at least two different types of inputs. You will likely need to use operations to convert the data (e.g., from the form to storage, and/or from storage to what is displayed to the user). This is tested with three inputs from the user: adding a ToDo, adding a task under the ToDo, or marking it as complete.
