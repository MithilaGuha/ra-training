Research Assistant Training
================

Welcome\! This **repository** (i.e., **repo**) provides a walkthrough of
some essential tools and serves as a reference for research assistants.
The material draws heavily from Jenny Bryan’s training on using Git and
GitHub from rstudio::conf 2019.

## Getting Started

GitHub is a powerful collaboration and version control tool. We will be
using it for *project management*, *writing*, and *coding*.

### Project Management

By project management I primarily mean keeping track of assigned tasks
using the **Issues** tab on GitHub. We can have an ongoing conversation
here about each specific issue and close it out when its completed or
resolved. Be sure to tag collaborators you want to see the conversation
(e.g., `@marcdotson`). Think of this as an email thread or Slack channel
where all of the conversations are in one place, easily searchable, and
automatically archived.

### Writing

Think of using GitHub to collaborate on writing like using something
like Google Docs. It is essential that we document what we’re doing in
each project as we do it. This is true for a number of reasons.

1.  Writing forces you to think clearly about what you’re doing.
2.  If you’re coding, think of the associated writing as long-form
    comments.
3.  The final product of any project is going to be a report, so start
    writing it now.

GitHub supports **markdown** syntax, which you’re probably more familiar
with than you might expect from time spent with **R Markdown**. Here are
some [markdown
basics](https://rmarkdown.rstudio.com/authoring_basics.html). We will be
writing using R Markdown so we can easily include code. The output in
the **YAML**, the header at the top, should always be set to `output:
github_document`. When you knit changes to your R Markdown document, it
will create a markdown document that is easy for GitHub to read.

### Coding

While it is convenient that we can use GitHub for project management and
writing, the primary reason for using it is to collaborate and impose
version control on our code. GitHub was developed for software
developers. While we aren’t developing software, we will be importing,
wrangling, visualizing, and modeling data, and it’s going to be
essential for everyone to be on the same page. Even if you were just
working solo, you will be collaborating with your past self and you
should do yourself a favor and impose good version controls.

### Set-Up

To get started, complete Jenny Bryan’s [pre-workshop
set-up](https://happygitwithr.com/workshops.html?mkt_tok=eyJpIjoiT1RVelptVTNZams0T0dZMiIsInQiOiJlR0orVlVpaHZsRlwveWh5QUJPN2U1Q3BcL0pHVHo5RXJ5UkhabFlwVXM4NlEwcHhRTENQZmVxaEEyNnVLSkRFTTdVa0hyNjk4MkFHYUU1Nkt5VXNtRm9heFM3N3dnUFplZ1V5anpRTWdnWDVscE1lOUR6VzBHaGFQOUFhOGd1QkN3In0=#pre-workshop-set-up).
This can take up to a few hours, so plan accordingly.

## GitHub Basics

Now that you’re set up, let’s get started.

### Just Once: Clone

First **clone** one of your repos, or a repo that you’re a collaborator
on. This is simply creating a local copy of the repo. You do this inside
RStudio by creating a new project and selecting `Version Control > Git`.

![](Figures/clone.png)

### Daily Work: Commit, Push, Pull

Now you can open up the RStudio Project in the clone and work on the
project. You have a new Git pane in RStudio that notifies you that
changes you’ve made means you are out-of-sync with the repo. Once you’ve
made a number of changes, you click on the files you want to **commit**
and click commit. Think of a **commit** as saving a snapshot of all of
the changes you’ve made across these files all at once. Include a clear
commit message. You’ll do this fairly frequently, possibly just
**amending** the same commit each time.

Eventually you’ll be ready for other people to have access to your
changes on the repo. To do this, you’ll click on the green up arrow to
**push** your changes to the repo. You push far less often than you
commit, maybe once a work session, since this means you think it’s ready
for others to have access to. Each time you push, all of your commits
are archived, including the **diff** or the side-by-side comparison of
what changes you made to the previous version.

When you start a new work session, you’ll want to click on the blue down
arrow to **pull** the latest changes from the repo, possibly the work
other collaborators have pushed, so you’re synced.

![](Figures/daily-work.png)

### Collaborating: Branches and Pull Requests

Because GitHub is very systematic in the way it manages commits, we will
run into commit errors when multiple people have changed the same thing
at the same time. To avoid this problem, we will be using **branches**.
A branch is a separate version of the repo that exists in parallel, one
where you can make big changes or experiment without it affecting the
repo master.

I’ll create the branches. When you work, make sure you select the branch
you want to work on from the dropdown in the Git pane in RStudio. You
can commit, push, and pull as usual to the branch you’re working on.
When you’re *really* done with a big task associated with the branch,
more so than even a push, you can create a **pull request** on GitHub
and tag me (i.e., `@marcdotson`). This allows me to review what you’ve
done, have a conversation with you about it, and then pull what you’ve
done into the repo master.

## Project Organization

Each project repo has a similar directory organization. There are
certain limitations on the size and type of files that can be pushed to
GitHub. There are also certain things that shouldn’t be accessible by
the public (e.g., data we have a licence to access). For these reasons,
we have folders and files that are pushed to GitHub and those that are
not.

### Pushed to GitHub

  - `/Code` Each script should do something specific (like tidyverse
    functions), have a descriptive name, and include number prefixes if
    they are meant to be run in a certain order (e.g.,
    `01_import_data.R`, `02_clean_data.R`).
  - `/Data` While all data live here, only data that are small and can
    be shared publically will be pushed.
  - `/Figures` Figures created for the `README`, paper, and
    presentation, all saves as PNG files.
  - `/Paper` The manuscript of the paper, without any PDF knits.
  - `/Presentation` Slides for presentations, again without any PDF
    knits.
  - `README` The abstract and any specific details on project
    organization or workflow.

### Not Pushed to GitHub

  - `/Model Runs` These files tend to be too large. They are also
    something each user can create on their own.
  - `/Readings` Loose papers that you want to keep track of reading
    locally. GitHub is not a paper management system.

Note that you can create `Model Runs` and `Readings` folders in your
local clone without worrying about them being pushed. We can modify the
`.gitignore` file to add other folders and files that aren’t pushed to
GitHub.

## Project Workflow

  - Use RStudio projects.
  - Use `here::here()` to specify files paths.
  - Use tidyverse functions as much as possible.
  - Try and follow the [tidyverse style
    guide](https://style.tidyverse.org).

## Links

  - [Happy Git and GitHub for the useR](https://happygitwithr.com)
  - [WTF Workshop at
    rstudio::conf 2019](https://jennybc.github.io/wtf-2019-rsc/)
  - [What They Forgot to Teach You About R](https://whattheyforgot.org)
