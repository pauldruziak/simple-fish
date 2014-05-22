# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _rvm_info
  echo (command rvm-prompt v p g)
end

function _box_name
  echo (command cat ~/.box-name)
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l magenta (set_color magenta)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -l rvm $yellow (_rvm_info)
  set -l cwd $blue (basename (prompt_pwd))
  set -l box $magenta (_box_name)

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Print ruby version
  echo -n -s '# ' $rvm $normal

  # Print box name
  echo -n -s ' at ' $box $normal

  # Print pwd or full path
  echo -n -s ' in ' $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info $red $git_branch $normal
    else
      set git_info $green $git_branch $normal
    end
    echo -n -s ' on ' $git_info $normal
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s '> ' $normal
end
