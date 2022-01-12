# CreateRapidStart
Creates a Rapid Start Package for basically all records and fields within the application.
Exceptions are some tables as defined in Cu 70000.TableToExclude()

The Codeunit is run automatically on installation of the app and creates a package "_ALLDATA"

Purpose is a quick-and-dirty save/restore of company-data for developers who suffer the lack of stability in their containers/sandboxes.

The Package is defined in a way that all table- and field-triggers are avoided: "Dirt out --> Dirt in"

##Changes
### V1.0.0.2
Create Entries for all Tables witin range and not only for Tables with data.
Reason is that we want to be able to create the package on an empty Company as well.
