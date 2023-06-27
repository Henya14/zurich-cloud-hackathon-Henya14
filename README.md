# Zurich Cloud Hackathon Solution - Henrik Rudolf Élő
This project was created for the [Zurich cloud hackaton challenge](https://nuwe.io/dev/competitions/zurich-cloud-hackathon/online-preselection-cloud-challenge) 

## Infrastructure and decisions taken
[The infrastructure of the solution](docs/infrastructure.png)

I created a S3 bucket where the user data can be uploaded. 

The Lambda is triggered with the S3's ObjectCreated event. 
When the Lambda is triggered it downloads the JSON file from the S3 bucket and transforms it into user and car objects. 

After the Lambda collects all the user and car objects it writes them into the corresponding DynamoDB tables.

I decided to make a separate table for the users and cars. I did this so later the indexing of the car properties could be easier to implement. This way each record in the user table stores a car id in its car field. 

One drawbacsk of this solution is that the car object needs to be fetched with an additional request if we want to see that data. 

One other solution could have been to create a custom data transformer that maps the car embedded attributes to top-level attributes on the user object.
For example a user object that looked like this:
```json
{
    "id": "123",
    "car": {
        "make": "Seat",
        "model": "Leon"
    }
}
```
Would be turned into this: 
```json
{
    "id": "123",
    "car.make": "Seat",
    "car.model": "Leon"
}
```
But that would require 