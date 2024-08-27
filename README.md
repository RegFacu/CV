# About The Project
This is a different way to share my CV. It is not only generating the PDF dynamically based on a file, it's also showing my way of doing things.

<p>Please download the PDF to view it:</p>
<ul>
    <li><a href="cv/ruby/cv_english.pdf">English CV.pdf</a></li>
    <li><a href="cv/ruby/cv_spanish.pdf">Spanish CV.pdf</a></li>
</ul>

---
<p align="center">
  <a href="https://github.com/RegFacu/CV/issues/new?labels=enhancement&template=1-feature_request.md">Request Feature</a>
  ·
  <a href="https://github.com/RegFacu/CV/issues/new?labels=bug&template=2-bug_report.md">Report Bug</a>
  ·
  <a href="https://github.com/RegFacu/CV/issues/new/choose">Open an issue</a>
</p>

## Which is the idea
You will be able to see my technical skill by reading the code, automations and documentations as well as my management skills in terms of ticket tracking, milestone definitions and metrics (limited to what I can do with GitHub).

#### Subscribe to my releases
Get notified when some milestone is completed and a new release is generated.

[![Get notified](docs/subscribe.gif)](https://github.com/RegFacu/CV/subscription)

Let me highlight some points that you can see in this project:

### GitHub Actions (GHA)
Under `.github/workflows` you can review different automations triggered automatically or manually on CI for checking the code as well as helpful tools for other development, testing and release process.

### Bash automation/Scripting
There are bash scripts to run the code and set up the environment if you want to test it under `ruby` folder.

### Dynamic PDF generation
PDF is generated based on a data file (JSON/YAML), and it's pretty much completely configurable. This approach allows to have a new PDF version easily by changing a few values as well as having a history of the information included there, as well as validate the content before applying the change.

Drawing a canvas for PDF generation or image rendering requires several maths for elements alignment, calculation for a new page, dynamic position, text descent and ascent considerations, etc. All these maths are done under the `ruby/classes` folder for each type of element, but the most complex one is the `Header.rb` class which contains maths for dynamic vertical text position aligned with the photo and including gaps between them depending on the available space.

## Built With

[![GHA][GHA]][GHA-url]
[![Markdown][Markdown]][Markdown-url]

[![Ruby][Ruby]][Ruby-url]
[![Rubocop][Rubocop]][Rubocop-url]

## Getting Started

Below you have the instructions to install and execute the project locally. If you have any issues, please <a href="https://github.com/RegFacu/CV/issues/new?labels=bug">report a bug</a>

### Installation

For now, only Ruby language is available but the PDF could be generated with any language tool that have libraries for PDF generations, it's just a tool that could be learned.

In order to use it, you only need to install the requirements by running the corresponding script using the following pattern:
`./[language]/env_setup/install.[ext]`

* `language` is the programming language to be used. E.g. `ruby`
* `ext` is the corresponding extension depending of the OS used:
  * `zsh` for `mac`
  * `sh` for `linux`
  * `bash` for `windows`

> **_NOTE:_**  Linux and Windows scripts are not generated yet given it's not the goal of the project.  

#### Ruby
```sh
./ruby/env_setup/install.zsh
```

## Usage

Each language contain one or several scripts to be executed locally.

#### Ruby
```sh
./ruby/run_locally.zsh
```

## Unit tests

Each language contain one or several scripts to be executed locally.

#### Ruby
```sh
./ruby/run_tests.zsh
```

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[GHA]: https://img.shields.io/badge/GHA-2088FF?style=for-the-badge&logo=githubactions&logoColor=white
[GHA-url]: https://docs.github.com/en/actions
[Markdown]: https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white
[Markdown-url]: https://www.markdownguide.org/
[Ruby]: https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=Ruby&logoColor=white
[Ruby-url]: https://www.ruby-lang.org/en/
[Rubocop]: https://img.shields.io/badge/RuboCop-000000?style=for-the-badge&logo=RuboCop&logoColor=white
[Rubocop-url]: https://rubocop.org/
