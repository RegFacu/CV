name: New process
description: Request a new process definition
title: ""
labels: ["new-process"]
projects:
body:
  - type: markdown
    attributes:
      value: |
        This form is to request a new process definition.
        If it's doable in the project, I'll apply the process directly on this repo to show you how it would work.
        If it's not, I'll try to prepare a summary of how I´d solve it
  - type: input
    id: name
    attributes:
      label: Process name
      description: What is the process for
      placeholder: ex. Release process
    validations:
      required: true
  - type: textarea
    id: problem-to-solve
    attributes:
      label: Which is the problem to solve?
      description: Also tell us, what did you expect to happen?
      placeholder: ex. Release a new version of the project, including tagging, artifacts and code validations.
    validations:
      required: true
