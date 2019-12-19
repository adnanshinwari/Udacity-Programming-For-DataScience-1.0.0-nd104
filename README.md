# Udacity: Programming For DataScience V1.0
 Downloaded this course via torrents for learning purposes.
 
 Database folder contains **Parch And Posey** database taken from [Ayushi](https://github.com/ayushi-b).

**This Database works fine with PostgreSQL**
# Parch And Posey Database.
**Instructions to load**
1. Download [PostgreSQL](https://www.postgresql.org/).
2. Windows users need to add path of /bin and /lib
3. This PC -> Properties -> Environment Variable -> Select _**Path**_ -> New
4. Add <code> C:\Program Files\PostgreSQL\12\bin</code> **AND** <code> C:\Program Files\PostgreSQL\12\lib to path</code>
5. Go to download location of *parch_and_posey_db*
6. Open **CMD**
7. Run <code> pg_restore --create --dbname=postgres --username=postgres parch_and_posey_db </code>
8. Run **pgAdmin** and look up *Parch & Posey Database*

**Note:** Schema image file is also available in *Parch And Posey Database* folder.

## SQL Files
* Contains all the .sql query files used on the database.
