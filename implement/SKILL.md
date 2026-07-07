---
name: implement
description: "Implement a piece of work based on a PRD or set of issues."
disable-model-invocation: true
---

Implement the work described by the user in the PRD or issues.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /vet to review the work.

After the review's findings are resolved, run /reconcile to bring the OKF knowledge bundle back into agreement with what you built — over the same diff the review used.

Commit your work to the current branch, so code and knowledge land in one commit.
