# 📄 Modified File Filter for GitHub Actions

This GitHub Action halts a workflow unless the file in the path specified in `args` has been modified.
Only use this Action in workflows triggered by `push` events.

## Usage

Let’s say you have a repository with a file located at `db/structure.sql` and you want to receive an alert in Slack each time that file is modified. You could [create a new workflow](https://help.github.com/articles/creating-a-workflow-with-github-actions/) with Modified File Filter and [Slack for GitHub Actions](https://github.com/Ilshidur/action-slack).

```hcl
workflow "Database change alert" {
  on = "push"
  resolves = ["Alert"]
}

action "Check" {
  uses = "nholden/modified-file-filter-action@master"
  args = "db/structure.sql"
}

action "Alert" {
  uses = "Ilshidur/action-slack@6286a077a2b77159fcc4f425a9e714173d374616"
  secrets = ["SLACK_WEBHOOK"]
  args = "db/structure.sql was modified!"
  needs = ["Check"]
}
```

The next time anyone pushes to the repository, if any of the commits in the push modify `db/structure.sql`, the `Check` Action will pass, triggering the `Alert` Action, which will send you a message in Slack. If none of the commits in the push modify `db/structure.sql`, the `Check` Action will fail, and the `Alert` Action will not be triggered.

## A special case: pull request merges

With most pushes, Modified File Filter will look at all of the commits in the push and will pass if any of the individual commits modify the specified file. However, merging a pull request triggers a push event, and for those pushes, Modified File Filter will only look at the merge commit and will not look at any of the individual commits in the pull request.

This special case prevents Modified File Filter from passing the specified file is changed in multiple commits in a pull request but there are ultimately no net changes to the file in the base branch when the pull request is merged.