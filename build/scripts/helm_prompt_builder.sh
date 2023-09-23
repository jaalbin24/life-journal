#! /bin/bash

FILES_TO_INCLUDE=();
FILES_TO_INCLUDE+=("../values.yaml");
FILES_TO_INCLUDE+=("service.yaml");
FILES_TO_INCLUDE+=("ingress.yaml");
FILES_TO_INCLUDE+=("deployment.yaml");

PROMPT="How???";

for file in "${FILES_TO_INCLUDE[@]}"; do
  echo "### This is my $file file";
  cat "$HOME/workspace/life-journal/build/helm/templates/$file";
  echo;
done

echo "$PROMPT";