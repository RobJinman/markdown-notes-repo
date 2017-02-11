Markdown Notes Repo
===================

A bash script to compile a directory of markdown notes into html.

Given a source folder containing your markdown notes, the watch.sh script will wait for changes and compile them into a build directory.

* src/
    * index.md
    * computing/
        * index.md
        * android_development.md
        * languages/
            * index.md
            * python.md
            * java.md
    * science/
        index.md
        * chemistry/
            * index.md
            * organic_chem.md
            * acids_and_bases.md
        * astronomy/
            * index.md
            * solar_system.md
            * stars.md
            * black_holes.md
* build/
* watch.sh

Where the contents of src/index.md might be something like

        Here is a repository of some notes I've taken over the years. Feel free to look around.

        ## Contents

        * [Computing](computing/index.html)
        * [Science](science/index.html)

Notice that the links have extension .html.

The compiled notes end up in a directory called build.


## Dependencies

Download and install [Pandoc](https://github.com/jgm/pandoc/releases/tag/1.19.2.1).

If inotifywait isn't installed, run

        sudo apt-get install inotify-tools

