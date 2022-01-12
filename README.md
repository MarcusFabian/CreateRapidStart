# CreateRapidStart
Purpose is a quick-and-dirty save/restore of all company-data for developers who suffer the lack of stability in their containers/sandboxes.

Creates a Rapid Start Package _ALLDATA for basically all records and fields within the application.
Exceptions are some tables as defined in Cu 70000.TableToExclude()

The Codeunit can be run via page "Create AllData Rapid Start" and creates a package "_ALLDATA", containing either all Tables or all Tables with data.

The Package is defined in a way that all table- and field-triggers are avoided: "Dirt out --> Dirt in"

## Recommended use
Naturally, you want to use this app if all Extensions (which might create data) are installed.
I recommend to run the app in debugging mode if you have customer apps installed as you might run into issues if user-apps contain tables which are not accessible
or not useable within Rapid-Start.
You migth then add failed tables in Codeunit 70000 to procedure TableToExclude()

## Changes


