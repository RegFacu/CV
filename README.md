# About The Project
This is a different way to share my CV. It is not only generating the PDF dynamically based on a file, it's also showing my way of doing the things.

You will be able to see my technical skill reading the code, automations and documentations as well as my management skills in terms of ticket tracking, milestone definitions and metrics (limited to what I can do with GitHub).

<p>Please download the PDF to view it:</p>
    <ul>
        <li><a href="cv/ruby/cv_english.pdf">English CV.pdf</a></li>
        <li><a href="cv/ruby/cv_spanish.pdf">Spanish CV.pdf</a></li>
    </ul>

## Built With

[![GHA][GHA]][GHA-url]
[![Ruby][Ruby]][Ruby-url]
[![Markdown][Markdown]][Markdown-url]

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

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[Ruby]: https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=Ruby&logoColor=white
[Ruby-url]: https://www.ruby-lang.org/en/
[GHA]: https://img.shields.io/badge/GHA-2088FF?style=for-the-badge&logo=githubactions&logoColor=white
[GHA-url]: https://docs.github.com/en/actions
[Markdown]: https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white
[Markdown-url]: https://www.markdownguide.org/