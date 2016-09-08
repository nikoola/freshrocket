-let me give use case for area and radius

[2:22]  
Bangalore is the City
Indiranagar is the Area  > We will deliver 5 km within this area  ...

this is what we will specify in the backend  (either via zipcode or someway)

in frontend website > user will chose city ( bangalore) and then area (we will use google auto fill) .. so if this area matches with the delivery area radius, its allowed to next page

[2:22]  
this is the use case

[2:22]  
now figure out what to implement it

[2:22]  
also let me know how we will add the areas and radius in backend.

we can either add the pincode or area names 
should we add area name or pincode with kilometer radius

-validation check for area
geocode area and check returned object's city is the same as the city.

-validation check for address
check if address is in areas of a city

-one serious problem
deleting area cause a weird issue - deleting related addresses