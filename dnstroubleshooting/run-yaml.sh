set -eo pipefail

json=`cat $1 | yq -o json`
overrides=`echo "$json" | jq "{spec}"`
name=`echo "$json" | jq -r ".metadata.name"`
# annotations=`echo "$json" | jq -r '.metadata.annotations'`
# annotations=`echo "$json" | jq '.metadata.annotations | keys[] as $k | "\($k)='"'"'\(.[$k])'"'"',"' | sed -e "s/\"//g"`
# annotations=`echo "$json" | jq '.metadata.annotations | keys[] as $k | "\($k)='"'"'\(.[$k])'"'"'"' | sed "N;s/\n/,/"`
# annotations=`echo "$json" | jq '.metadata.annotations | keys[] as $k | "\($k)='"'"'\(.[$k])'"'"'"' | sed "s/^\"//;s/\"$//" | sed "N;s/\n/,/"`
annotations=`echo "$json" | jq '.metadata.annotations | keys[] as $k | "\($k)=\(.[$k])"' | sed "s/^\"//;s/\"$//" | sed "N;s/\n/,/"`
# annotations=`echo "$json" | jq '.metadata.annotations | keys[] as $k | "\($k)='"'"'\(.[$k])'"'"',"' | sed '/(?<!(?:[\\]))["]/d'`
# annotations=`echo "$json" | jq -r '.metadata.annotations | keys[] as $k | "\($k)=\'(.[$k])'"' | xargs | sed -e 's/ /, /g'`
labels=`echo "$json" | jq -r '.metadata.labels | keys[] as $k | "\($k)=\(.[$k])"' | paste -sd "," -`
image=`echo "$json" | jq -r ".spec.containers[0].image"`

shift

echo $annotations
# kubectl run "$name" -it --tty --rm --image="$image" --annotations="$annotations" --labels="$labels" --restart=Never -- sh --overrides="$overrides" "$@" --dry-run=client -o yaml
# echo $json