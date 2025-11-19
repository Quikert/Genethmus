# Genethmus
Credit analysis algorithm based on related/personal information.

## Usage and compile
- First of all, make sure you have Haskell GHC installed on your machine, if you don't have it, install it here: https://www.haskell.org/ghcup/
- Check if ghc and haskell are working, use: `ghc --version` or `ghci --version`
- Now go to the directory and compile: `ghc -o gnt processing.hs status.hs main.hs`
- The output should look like this:
```
[1 of 4] Compiling Processing       ( processing.hs, processing.o )
[2 of 4] Compiling Status           ( status.hs, status.o )
[3 of 4] Compiling Main             ( main.hs, main.o )
[4 of 4] Linking gnt [Objects changed]
```
- Next, exit the current directory and copy your .csv file to the Genethmus directory: `cp file.csv /Genethmus/file.csv`
- Note: The header should look like this: `name,surname,balance,income,typeofincome,mother,father,owes,livesalone,age,job,maritalstatus,children,city`
- Example of a line body: `Anne,Britch,2000,3000,fixed,yes,no,no,no,30,teacher,married,2,New York`
- Enter the directory again using `cd Genethmus` and run `./gnt file.csv`
- The output should look like this:
```
Approved: 11046
Rejected: 284
Pending: 3884
Processing finished. Results saved in approved.json, rejected.json, pending.json. usuarios.csv deleted.
```
---

> Powered by @Quikert <3
> 
