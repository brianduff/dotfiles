# Perforce diff / merge tools using meld if possible.

if bduff::has_display; then
  if hash meld 2>/dev/null; then
    export P4DIFF='bash -c "meld \${@/#:/--diff}" padding-to-occupy-argv0'
    export P4MERGE='bash -c "meld \$2 \$1 \$3 ; cp \$1 \$4" padding-to-occupy-argv0'
  else
    echo "Warning: meld is not installed!"
  fi
else
  # Explicitly use diff / merge for terminals.
  export P4DIFF=
  export P4MERGE=
fi

