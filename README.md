# Assignment 4

## Summery

I created a simple app that can help the user become more organized my allow think to list there To-Dos.

## Details about Assignment 4:

* **Use a Form**
    * Needs to be some way for the user to provide text input and submit their input:
        * used showDialog to add a to the To-do list this is can be done by tapping the plus button in the bottom corner.
        * another showDialog to add a tsk under the To-Do instance this is can be done by tapping the desired To-do text.
    * Need to have at least two separate fields where users can enter input: 
        * showDialog to add a To-Do.
        * showDialog to add a Task under the To-Do.

*  **Store a Persistent State in the SQLite DB, local filesystem, or platform-specific persistent storage on the phone or web**
    * You must store at least two different data types (e.g. String, int, bool, double, List):
        * I am storing each instances of To-do each class which has a String and a List<String>.
    * You must successfully use one of the plugins:
        * used shared_preferences

* **Have the Form update the state**
    * When the form receives user input, it must update data that is stored in a persistent state:
        * This is done each time the user adds a new To-Do or task under the To-Do.

* **Have the Form update the state**
    * Have the View update based on the changed state:
        * This is completed as each To_Do instances update.