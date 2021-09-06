# Overview

This project is developed within PHS by a core team, all in the open. This is a brief overview of the workflow followed, particularly around the use of Git.

All 'production ready' code is on the `master` branch, this requires this branch to be kept clean which is managed through branch protection rules. Namely, this means for any code to get onto the `master` branch must be code reviewed by at least 2 others. Throughout the intensive RAP development, analysts will each have their own development branch with optional feature branches. Separate bug-fix (or documentation, testing, etc.) branches may also be necessary which would come from the `master` branch. An image of this workflow is included below:

<img width="1487" alt="Git-Workflow" src="https://user-images.githubusercontent.com/33964310/132250571-fbe3d59a-a2a1-4489-91b2-0043a6d1c015.png">

* **Main (prev. Master)** - production ready codebase.
* **Analyst** - development branch for each analyst / contributing developer.
* **Feature\*** - (optional) development branch for specific feature development, splitting development work.
* **Bug-fix** - (or documentation, testing, etc.) short-lived development branches for specific items not related to main development workflow.

</br>

### Workflow

1. An [issue](https://github.com/Public-Health-Scotland/chronic-pain/issues) is opened with specific details of requirement, using a template where possible.
2. On the analyst branch, pull from the `master` branch (create an analyst branch if one doesn't exist).
3. (Optionally) create a feature branch for specific development on individual functionality / issues.
4. Make changes, with regular commits and meaningful commit messages. Sense check, test, and review code to ensure it meets expectations.
5. Open a pull request to merge to the `master` branch, tagged with a closing keyword, e.g. 'closes #x' where x is the issue number.

Pull requests should be approved by at least 2 others, specific reviewer(s) can be added on the pull request which will send them a notification to ensure they know the request has been actioned. In order to ensure that the `master` branch remains 'production ready', the pull request should review for functioning code but also style, structure, and efficiency. All branches (except `master` and any analyst branch) should be short-lived, used to develop specific features, and then deleted once merged (this happens automatically when the request is tagged with closing keywords using the issue number).

