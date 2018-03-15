# Marks
#   not owned by mveera (too easy for anyone to claim as theirs)
#
# This is a fairly straight forward way to mark your directories.
#
# - Use "mark <shortcut name>" to create a shortcut to a directory.
# - Use "jump <shortcut name>" to change to that directory.
# - Use "umark <shortcut name>" to get ridof a mark.
# - Use "marks" to list all of your marks for your user profile.
#
# I alias "j" to "jump" because I'm lazy
#

export MARKPATH=$HOME/.marks
function jump {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
  rm -i "$MARKPATH/$1"
}
function marks {
  ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
