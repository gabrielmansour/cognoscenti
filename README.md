# Cognoscenti

*A directory of people who are especially well informed about a particular subject*

## Instructions on how to build/run your application

This application uses [Docker](https://www.docker.com). Please ensure that it is installed on your system before proceeding.

To install the app for the very first time, please run:

```
./setup.sh
```

(This only ever needs to be done once.)

To run the app locally, run:

```
docker-compose up
```

## Application Usage

* Add Experts using the "Add Experts" button by providing their name and URL.
  Their expertise topics will automatically be pulled in from the provided website.
* Once you've populated enough experts in the system, you can add them as friends
  from their profile.
* From an expert's profile, you can search their extended network for 2nd-degree
  contacts (and further) who are knowledgable about a particular topic or keyword.
  A great way to make some new friends!


## Notes / Caveats

* Due to time constraints, I used traditional rails views instead of using a React frontend.
Given more time, I could have built out the frontend using React.
* I would also normally perform network calls (e.g. URL shortening, Scraping web pages) in a background job (e.g. using Sidekiq). But for simplicity's sake, and to prevent adding additional complexity for this example application, I am performing these synchronously.
