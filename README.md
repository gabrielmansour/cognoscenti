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


## Notes / Caveats

* Due to time constraints, I used traditional rails views instead of using a React frontend.
Given more time, I could have built out the frontend using React.
* I would also normally perform network calls (e.g. URL shortening, Scraping web pages) in a background job (e.g. using Sidekiq). But for simplicity's sake, and to prevent adding additional complexity for this example application, I am performing these synchronously.
