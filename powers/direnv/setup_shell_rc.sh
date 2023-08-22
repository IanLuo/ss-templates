
add_to_file() {
  echo "Cheking $1"

  file=$1

  symbol="# For direnv"

  if ! grep -q "$symbol" $file; then
    echo "Adding to $file"
cat > $file <<'EOF'
# For direnv
eval "$(direnv hook zsh)"
eval "$(direnv hook bash)"

# end-for direnv 
EOF
  else
    echo "Already added to $file"
  fi
}

zshrc=$HOME/.zshrc
bashrc=$HOME/.bashrc

if [ -e $bashrc ]; then
  add_to_file $bashrc
fi


if [ -e $zshrc ]; then
  add_to_file $zshrc
fi
