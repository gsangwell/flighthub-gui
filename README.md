
# Alces Overware

## Installation 

1. Ensure Ruby version as specified in [`.ruby-version`](./.ruby-version) is
   installed

2. PostgreSQL 9.6 installed and running. The following should achieve this for
   a CentOS machine:

   2.1. Install as described [here](https://wiki.postgresql.org/wiki/YUM_Installation)

   2.2. Configure PostgreSQL like the following:

   ```bash
   postgresql-setup initdb
   sudoedit `/var/lib/pgsql/data/pg_hba.conf`
   # Change entries in `METHOD` column to 'trust' and then save the file
   systemctl start postgresql
   ```

3. Yarn installed

4. Clone this repo using `git clone https://github.com/alces-software/overware.git`

5. Copy the example environment variables file using `cp '.env.example', '.env'`

6. Edit `.env` as required to use valid environment variables. Some of these 
   are only important for specific environments.

7. Install gems with `bundle install`

8. Prepare the database

   8.1. Create DB `RAILS_ENV=production bin/rails db:create`

   8.2. Load schema `RAILS_ENV=production bin/rails db:schema:load`

   8.3. Run database migrations `RAILS_ENV=production bin/rails db:migrate`

   8.4. Run data migrations `RAILS_ENV=production bin/rails data:migrate`

9. Create an initial user

   9.1. Enter the rails console using `RAILS_ENV=production rails c`

   9.2. Create the user with `User.create(username: '<USERNAME HERE>', password: '<PASSWORD HERE>')`


10. Precompile assets using `RAILS_ENV=production bin/rails assets:precompile`

11. Launch server using `bin/rails s -p 80 -e production`

12. Access the application at its public IP and use the details for the user
    you created in step 7 to log in

## Bolt-Ons

A Bolt-On is an optional part of the web interface configuration. These can be enabled on an individual basis in one of two ways:

1. Within the `rails-admin` interface

   1.1. Navigate to the `Bolt ons` section

   For each Bolt-On you wish to enable:

   1.2. Click the edit icon next to the database entry

   1.3. Click the `Enabled` checkbox

   1.4. Save the entry

2. Via the rails console

   2.1. Enter the rails console using `RAILS_ENV=production rails c`

   For each Bolt-On you wish to enable:

   2.2. Enable using:

    ```
      bolt_on = BoltOn.find_by(name: '<NAME_OF_BOLT_ON>')
      bolt_on.enabled = true
      bolt_on.save!
    ```

## Embedded Terminal

1. Ensure at least Node.js v8.12 is installed

  * Install [directly](https://nodejs.org/en/download/)

  * Install using [Node Version Manager](https://github.com/creationix/nvm#installation-and-update)

2. Clone the `develop` branch of the `flight-terminal-service` repo found [here](https://github.com/alces-software/flight-terminal-service/tree/develop)

3. Adjust interface value found within `lib/config.json` as necessary

  * Set to `0.0.0.0` if you want it to be open to all connections

4. Run the service using `INTEGRATION=no-auth-localhost yarn run start`

5. Ensure the `TERMINAL_IP` environment variable is set within the Overware `.env` file

6. Restart the rails server if it is running

7. Enable the `Terminal` Bolt-On
