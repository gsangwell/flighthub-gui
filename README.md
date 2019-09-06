
# FlightHub GUI 

## Installation 

1. Ensure Ruby version as specified in [`.ruby-version`](./.ruby-version) is
   installed

2. PostgreSQL 9+ installed and running. The following should achieve this for
   a CentOS machine:

    _Tested using v9.2 on CentOS 7_

    2.1. Install using `yum install postgresql` 

    2.2. Configure PostgreSQL like the following:

    ```bash
    postgresql-setup initdb
    sudoedit `/var/lib/pgsql/data/pg_hba.conf`
    # Change entries in `METHOD` column to 'trust' and then save the file
    systemctl start postgresql
    ```

3. Ensure Node.js v8.12 is installed

    * Install [directly](https://github.com/nodesource/distributions/blob/master/README.md#rpm)

    * Install using [Node Version Manager](https://github.com/creationix/nvm#installation-and-update)

4. Yarn installed

    4.1. Install repo using `curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo`

    4.2. Install `yarn` itself using `yum install yarn`


5. Install and configure `Flight Terminal Service` as described [here](https://github.com/alces-software/flight-terminal-service)

6. Clone this repo using `git clone https://github.com/alces-software/overware.git`

7. Copy the example environment variables file using `cp '.env.example' '.env'`

8. Edit `.env` as required to use valid environment variables. Some of these are only important for specific environments.

9. Install gems with `bundle install`

10. Prepare the database

    10.1. Create DB `RAILS_ENV=production bin/rails db:create`

    10.2. Load schema `RAILS_ENV=production bin/rails db:schema:load`

    10.3. Run database migrations `RAILS_ENV=production bin/rails db:migrate`

    10.4. Run data migrations `RAILS_ENV=production bin/rails data:migrate`

11. Precompile assets using `rake assets:precompile`

12. Launch server using `bin/rails -s -p 80 -e production`

13. Access the application at its public IP and login using the username and password of configured PAM user 

