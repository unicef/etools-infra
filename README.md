##**eTools backend infrastructure configuration**

###***Notes:***

To start using this please get familiar with git submodules if you haven't used them before:
    - https://git-scm.com/book/en/v2/Git-Tools-Submodules
    - https://github.com/blog/2104-working-with-submodules

###***Dev Setup:***

 - Clone the repo: `git clone --recursive https://github.com/unicef/etools-infra.git`
 - Set the correct branches you want to work from for each submodule (eg: develop in PMP, staging in backend, etc)
 - Make sure you have fabric installed: http://www.fabfile.org/installing.html
 - Contact the Dev Lead to get your db dump, name it `db1.bz2` and add it to: `./db/`
 - For frontend apps `npm install` and `bower install` first in the local directories
 - Run: `fab devup` in the parent folder and wait for it. (this should update your db) ***sometimes db doesn't start first try, `CTRL-C` and run the command again.***
 - To bring migrations up to speed `fab backend_migrations`
 - Subsequent starts can be run with `fab devup:quick`
 
###***Prod-like environ setup:***

Coming soon...