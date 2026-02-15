declare fetcher url revs out

echo "exporting $url (revs $revs) into $out"

runHook preFetch

if [ -n "$gitConfigFile" ]; then
    echo "using GIT_CONFIG_GLOBAL=$gitConfigFile"
    export GIT_CONFIG_GLOBAL="$gitConfigFile"
fi

$SHELL "$fetcher" "$url" "$revs"

runHook postFetch
