Submitting patches
==================

Thank you for your interest in contributing to this project!

Please **do not** submit a pull request on GitHub.  The repository
there is an automated mirror, and I don't develop using GitHub's
platform.

Instead, either

- publish a branch somewhere (a GitHub fork is fine), and e-mail
  <spwhitton@spwhitton.name> asking me to merge your branch, possibly
  using git-request-pull(1)

- prepare patches with git-format-patch(1), and send them to
  <spwhitton@spwhitton.name>, probably using git-send-email(1)

Reporting bugs
==============

By e-mail to <spwhitton@spwhitton.name>.

Please read "How to Report Bugs Effectively" to ensure your bug report
constitutes a useful contribution to the project:
<https://www.chiark.greenend.org.uk/~sgtatham/bugs.html>

Signing off your commits
========================

Contributions are accepted upstream under the terms set out in the
file ``LICENSE``.  You must certify the contents of the file
``DEVELOPER-CERTIFICATE`` for your contribution.  To do this, append a
``Signed-off-by`` line to end of your commit message.  An easy way to
add this line is to pass the ``-s`` option to git-commit(1).  Here is
an example of a ``Signed-off-by`` line:

::

    Signed-off-by: Sean Whitton <spwhitton@spwhitton.name>
