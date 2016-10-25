# Integration Test

To run tests:

* `docker-compose build`
* `docker-compose up -d`

To view test results:

`docker-compose logs -f test`

*Note:* it could take a while before the test logs show up, as it has to wait until all other services are up and running.

To clean up:

`docker-compose down`
