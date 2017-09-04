#!/bin/sh
set -e
if [ ! -e "$GHOST_CONTENT/apps" ]; then
	echo "Initializing the Ghost application..."
	if [[ "$*" == npm*start* ]]; then
		baseDir="$GHOST_SOURCE/content"
		for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
			targetDir="$GHOST_CONTENT/${dir#$baseDir/}"
			mkdir -p "$targetDir"
			if [ -z "$(ls -A "$targetDir")" ]; then
				tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
			fi
		done

		echo "Substituting configuration values"
		sed -r "
			s/GHOST_DB_HOST/$GHOST_DB_HOST/g;
			s/GHOST_DB/$GHOST_DB/g;
			s/GHOST_USER/$GHOST_USER/g;
			s/GHOST_PASSWORD/$GHOST_PASSWORD/g;
			s!path.join\(__dirname, (.)/content!path.join(process.env.GHOST_CONTENT, \1!g;
		" "/config-example.js" > "$GHOST_SOURCE/config.js"

		chown -R user "$GHOST_CONTENT"

		set -- gosu user "$@"
	fi
fi
exec "$@"
