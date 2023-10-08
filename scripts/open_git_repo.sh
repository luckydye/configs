provider=$(gum choose "gitlab.s-v.de" "github.com")

case $provider in

  "gitlab.s-v.de")
	repo=$(curl -s --request GET \
		--url "https://gitlab.s-v.de/api/v4/projects?per_page=100" \
		--header "Authorization: Bearer $(skate get gitlab_token)" \
		--header "X-GitHub-Api-Version: 2022-11-28" | jq -r .[].ssh_url_to_repo | gum filter)
    ;;

  "github.com")
	repo=$(curl --request GET \
		--url "https://api.github.com/user/repos?per_page=100" \
		--header "Authorization: Bearer $(skate get gh_token)" \
		--header "X-GitHub-Api-Version: 2022-11-28" | jq -r .[].ssh_url | gum filter)
    ;;

  *)
    ;;
esac
 

cd ~/source/
name=$(basename -s .git $repo)
git clone ${repo} -o $name
cd $name

tmux
