repo=$(curl --request GET \
	--url "https://api.github.com/user/repos?per_page=100" \
	--header "Authorization: Bearer $(skate get gh_token)" \
	--header "X-GitHub-Api-Version: 2022-11-28" | jq -r .[].ssh_url | gum filter)

cd ~/source/
name=$(basename -s .git $repo)
git clone ${repo} -o $name
cd $name

tmux