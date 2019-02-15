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
resolved. Be sure to tag people you want to see the conversation (e.g.,
`@marcdotson`). Think of this as an email thread or slack channel where
all of the conversations are in one place, easily searchable, and
automatically archived.

### Writing

It is essential that we document what we’re doing in each project as we
do it. This is true for a number of reasons.

1.  Writing forces you to think clearly about what you’re doing.
2.  If you’re writing code, think of writing as long-form comments.
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
should do yourself a favor and impose version controls.

### Set-Up

To get started, complete Jenny Bryan’s [pre-workshop
set-up](https://happygitwithr.com/workshops.html?mkt_tok=eyJpIjoiT1RVelptVTNZams0T0dZMiIsInQiOiJlR0orVlVpaHZsRlwveWh5QUJPN2U1Q3BcL0pHVHo5RXJ5UkhabFlwVXM4NlEwcHhRTENQZmVxaEEyNnVLSkRFTTdVa0hyNjk4MkFHYUU1Nkt5VXNtRm9heFM3N3dnUFplZ1V5anpRTWdnWDVscE1lOUR6VzBHaGFQOUFhOGd1QkN3In0=#pre-workshop-set-up).
This can take up to a few hours, so plan accordingly.

## GitHub Basics

Now that you’re set up, let’s get started.

### Clone

![](Figures/clone.png%20=200x) You **clone** one of your existing repos
by creating a copy of it

### Vocabulary

  - clone
  - fork
  - commit
  - diff
  - pull
  - push
  - branch (?)
  - pull request

## To Do

  - Figure out use of branches.
      - Permissions?
      - Push/pull issues?
  - Decide on organization or repos (data and size limits).
  - Create and clone all projects.
  - Migrate to R Markdown.
  - Update issues for each project.
  - Flesh out details for this training conditioned on the above.

## Project-Oriented Workflow

  - Using RStudio projects.
  - Safe paths (use the `here` package).
  - Beware monoliths (file naming, separate scripts like separate
    functions).
  - Naming conventions (slugs).
  - Use `output: github_document` in the YAML of R Markdown documents.
  - Discuss the use of *branches*.

## Advanced Topics

  - .gitignore (see example)

## Links

  - WTF Workshop (repo)
  - All the links shared in the workshop
