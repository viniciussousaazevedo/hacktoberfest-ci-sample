<div align="center">
  <img src="https://github.com/viniciussousaazevedo/hacktoberfest-ci-sample/assets/62118039/3b832bbe-73fa-43ce-bca0-933b80e43aa7" width=150px>
</div>

# OpenDev UFCG Hacktoberfest 2023 - CircleCI Lecture Sample
This Repo contains a simple CI example usage and it was used as a practical exercise in UFCG Hacktoberfest 2023

## What is this about?

- I've developed a simple CLI contact CRUD system using shell script. To use it, execute the `./src/contact_controller.sh` file and type the choice that the menu highlight using parentheses.

![image](https://github.com/viniciussousaazevedo/hacktoberfest-ci-sample/assets/62118039/e6caea1d-e723-436f-ba87-b0dba7edcd79)

- The actions on this system creates or updates a file called `contacts.json` using the `jq` command-line processing tool.
- Besides the whole system itself, I have also created a really simple testing logic, which uses a separate JSON file to persist and delete data in every test execution. It uses a `grep` in these contents to check if a feature works or not. In order to facilitate log views, I have also used a [logging library](https://github.com/oyvinev/log.sh).

## What about this "ci-sample"?
- I ended up choosing a really simple and failable logic because the focus of this repo is to create and explain to UFCG students how a CI/CD pipeline works with [CircleCI](https://circleci.com/)
- The pipeline that I've created with them basically downloads the `jq` tool, execute tests and build a new version of the docker image based on the `Dockerfile` if the commit is located on the `main` branch
