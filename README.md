# update-hogwarts-legacy-engine.ini
Instructions:

    Click Download Link

    Open the Zip file and extract update-hogwarts-legacy-engine.ini-main

    Double click run.bat

    You may need to allow Defender to run it, by clicking More Info -> Run Anyway

If all is good it will say Succesfully updated the file C:\Users\%USER%\AppData\Local\Hogwarts Legacy\Saved\Config\WindowsNoEditor\Engine.ini

Then launch the game and see if its helped or not :)

What does the script do exactly?

    It loads C:\Users\%USER%\AppData\Local\Hogwarts Legacy\Saved\Config\WindowsNoEditor\Engine.ini

    It loads all the variables under [SystemSettings] if it doesn't exist it creates it

    It works out your avaliable vram and saves this information into r.Streaming.PoolSize

    It then checks all the variables to see if any match the settings I specified at the top of the file

    If the settings already exist it will remove it and update it with the new value

    If the settings don't exist it will add them, it won't mess with any other settings and is able to add them to the bottom of [SystemSettings]

Limitations:

    This won't work if your [SystemSettings] isn't the last variable in the file, this is because windows powershell cannot edit a specifical line it always has to add it to the bottom, if you haven't modified this file before you should be fine.
