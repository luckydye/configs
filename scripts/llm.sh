while [ true ]
do
  curl http://localhost:11434/api/generate -d "{ \
    \"model\": \"llama2\", \
    \"prompt\": \"$(gum input)\" \
  }";
done

