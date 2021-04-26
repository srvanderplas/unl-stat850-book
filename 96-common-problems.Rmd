# (APPENDIX) Appendix {-}
# Common Problems and General Computing Topics

## File Paths, Working Directories, and Reproducibility

### File paths

A [file path](https://en.wikipedia.org/wiki/Path\_\(computing\)) is how you tell the computer where to find a file. You might be familiar with the "C:\\Program Files\\" structure - that's a file path telling Windows to look at the C:\ drive, in the Program Files folder. 

There are two types of file paths: absolute and relative.
- An **absolute file path** is a file path that tells the computer the location of the file, regardless of where the computer is currently working from (regardless of the current working directory). An absolute file path is something like an address - no matter where you're currently located, an address will give you the information necessary to get to the correct house.    
Examples:
    - `C:\USER\DOCS\LETTER.TXT` (Windows)
    - `\\SERVER01\USER\DOCS\LETTER.TXT` (Windows, for e.g. remote file servers)
    - `/home/user/docs/Letter.txt` (UNIX/macOS)

- A **relative file path** is a file path that tells the computer how to get to a file from its current location. To continue the analogy, a relative file path is like "Go down the hallway, turn left, take a right at the next hallway, and go to the third door on the right." - it gives you information on how to get from your current location to the destination, but that information wouldn't necessarily work for someone who's in a different location.    
Examples:
    - `../../Letter.txt`"` (this says go up two directories and look for Letter.txt)
    - `./Letter.txt` (this says look for Letter.txt in your current directory)
    - `./data/Letter.txt` (this says look for Letter.txt in the data folder in the current directory)
    
If you are using a UNIX-like environment (Linux, macOS), you have an additional shortcut available: `~/` is the shortcut for the user's home directory. So `~/` is equivalent to `/home/ted/` as long as you're logged in as ted. If you're logged in as theodora, though, `~/` is equivalent to `/home/theodora/`. 

[This YouTube video](https://youtu.be/BMT3JUWmqYY) has a good explanation as well. 


### Working Directory

When you start a program on a computer, it starts with a [**working directory**](https://en.wikipedia.org/wiki/Working_directory). In many cases, this may be the user's home directory, but that's not always the case. For instance, if you are working in an RStudio project, your working directory is the folder containing the .Rproj file. If you are compiling an Rmarkdown document, your working directory is the folder where the document is saved.

Your working directory determines what relative file path you should be using. 

[Here](https://use.vg/GiINjB) is a video showing how to change your working directory in SAS, and in R. 


### Reproducibility

Reproducibility is the idea that I should be able to run your code and get the same results you got. Ideally, to do this, I wouldn't have to configure my computer in exactly the same way your computer is set up. Instead, ideally, your code will use relative file paths, with a working directory that is appropriate to the project set-up. 

Since we're storing everything on GitHub for this class, a natural file setup is to have the project working directory be the same directory the git repository is based in (the directory should contain a `.git` folder, but you may have to view hidden files to see it). You can store your data in a data/ subfolder, your extra scripts in a code/ folder, etc., but all of the files you need to run the code should be included in the git repository unless they are too large for git. Then, when someone else clones your repository, they will have access to the data they need to run the code, and the code will be written with relative file paths that match the file structure. 

This also has the advantage of saving you tons of time trying to help your PI figure out how to run your code... you can direct them to GitHub, have them download the folder (or clone the repo, if they're tech-savvy), and everything should just work.
