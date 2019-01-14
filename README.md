
# Alces Overware

## Installation 

1. Ensure Ruby version as specified in [`.ruby-version`](./.ruby-version) is
   installed

2. PostgreSQL 9.6 installed and running. The following should achieve this for
   a CentOS machine:

   ```bash
   yum install postgresql96 postgresql96-devel postgresql96-server
   postgresql-setup initdb
   sudoedit `/var/lib/pgsql/data/pg_hba.conf`
   # Change entries in `METHOD` column to 'trust' and then save the file
   systemctl start postgresql
   ```

3. Yarn installed

4. Clone this repo using `git clone https://github.com/alces-software/overware.git`

5. Install gems with `bundle install`

6. Prepare the database

6.1. Create DB `bin/rails db:create`

6.2. Load schema `bin/rails db:schema:load`

7. Copy the example environment variables file using `cp '.env.example', '.env'`

8. Edit `.env` as required to use valid environment variables. Some of these 
   are only important for specific environments.

9. Precompile assets using `RAILS_ENV=production bin/rails assets:precompile`

10. Launch server using `bin/rails s -p 80 -e production`
