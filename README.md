ML-FinalProject2012-EdModeling
==============================

Hi There! Welcome to our README!!

Okay, so how do I get Git? Well, first, what is git? Git is a Distributed Version
Control System (DVCS) that allows us to keep our files in one place. It's
different from something like DropBox in that you DECIDE when to add
something to a repository (repo) of code, rather then it automatically happening.
This means when you're done with an idea or a nice chunk of code and you've
tested it, you can "commit" it to the repo. You commit it with a "commit
message" that describes what you did, which gives us a nice log of what's been
happening. Write your commit messages for us, not for yourself, so tell us
what the code does and why we care. Then you "push" the code to the main
branch on GitHub so that we can get at it!

TL;DR: we use git for sharing our code in an organized way.

So...

There's a command-line version of Git (that you use in terminal) and (at least) two
different apps that you can use. I (Ryan) prefer SourceTree, which you can get at
[here](http://sourcetreeapp.com) (Mac only). If you want, you can also use GitHub's
official app, which also has a Windows version. When I tried to use it on my
macbook, it ate up 1.5 GB of RAM, so there seems to be something really funky
with it... But I'm willing to bet the Windows version is more reliable. There
may be other apps for Windows, let me know if you're having trouble. Either go
to [windows.github.com](http://windows.github.com) or [mac.github.com](http://mac.github.com) 
to download.

See [GitHup Help](http://help.github.com/articles/set-up-git) for more help.

And more generally: [git-scm.com/book/en/Getting-Started-Git-Basics](http://git-scm.com/book/en/Getting-Started-Git-Basics)

Now that you have Git, you need to download the code, which I can help with if
it's not obvious, but there should be reasonable instructions on our GitHub
page. It should also be intuitive-ish from Sourcetree or the GitHub app.

SO, what the hell is in here right now?

Data
----

All of the DATA is in the "data" folder. I've concatenated students1-5 and 6-9
into one file called "alldata.csv", but the original .xlsx and .csv exports
are included in the "original-data" folder

Extraction
----------

Then there is some code to help us extract and format the code. That's in the
"extraction-and-formatting" directory. It contains a base class called
[Transaction](extraction-and-formatting/Transaction.py) that has certain properties 
that it knows about, which correspond to columns in the raw log file. Then there's 
the [Formatter](extraction-and-formatting/DataFormatter.py) base class, which
knows about lots of Transactions, one for each row in the row log file.

There are classes that are based on these (that "inherit" from them) called
[EdLogTransaction](extraction-and-formatting/EdLogTransaction.py) and 
[EdLogFormatter](extraction-and-formatting/EdLogFormatter.py), which are just 
classes that are specific to our data set. So basically there's general logic 
about how to extract data and what a "transaction" *is* in the base classes, and 
that logic is put to use in the child classes. 

Take a look at EdLogTransaction and EdLogFormatter to see how our data relates
to these scripts.

We actually EXTRACT the data in the [extract-logdata](extraction-and-formatting/extract-logdata.py) 
script, which instantiates a formatter, extracts the important columns according to
EdLogTransaction, and then writes out the relevant bits to a new file.

In the root directory, there's a bash script called [runme.sh](runme.sh). I figure we
can put calls to important scripts in here to show other people how to call
them from the command line if necessary. We don't need to do it that way--just
a thought--but right now it shows you how to run extract-logdata.py, which is
useful.

Okay, that should be everything you need to get started. Sorry it was so damn
long!

More Stuff!
-----------

TODO: Add more stuff as we add things!

