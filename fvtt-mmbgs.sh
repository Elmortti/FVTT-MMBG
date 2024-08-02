#set -x
echo FVTT MMBGS v1.0
sed -i 's/\\/\//g' config.txt
help=$(sed -e n\;d config.txt)
carg=$(grep -oE '^[^\t]+-\w+' config.txt | tr '\n' ' ' | tr -d '\t' | sed -E 's/(-\w+)/"\1"/g' | sed 's/\ $//')
#get basic variables
dt=$(date '+%d-%m-%Y %H.%M.%S');
args=(-keyw -bulk -wait -scrt -trgt)
cfg=$(grep -v '^[\	]' config.txt)
dir=$(pwd | sed 's/\/c/c:/')
lang=$(grep "lang=.*" config.txt | sed 's/.*=//')
keyw=$(grep "keyw=.*" config.txt | sed 's/.*=//')
bulk=$(grep "bulk=.*" config.txt | sed 's/.*=//')
wait=$(grep "wait=.*" config.txt | sed 's/.*=//')
scrt=$(grep "scrt=.*" config.txt | sed 's/.*=//')
trgt=$(grep "trgt=.*" config.txt | sed 's/.*=//')
log="$dt"".log"
touch "$log"
echo 'Use command -help to see available commands'
read -p 'FVTT MMBGS: ' inp
while [[ "$inp" =~ ^- ]]; do
	if [[ "$inp" == "-help" || "$inp" == "-h" ]]
	then
		echo "$(sed -n "/\tkomennot/,/˔/p" README.md | sed '1d' | sed '$d')
		"
	elif [[ "$inp" =~ ^(-exit)$|^(-ex)$|^(\-e)$ ]]
	then
		exit
	elif [[ "$inp" =~ ^(-config)|^(-conf)|^(\-c) ]]
	then
		arg=$(echo "$inp" | sed -E 's/(-config\ )|(-conf\ )|(-c\ )|(-cfg\ )//')
		val=$(echo "$arg" | sed 's/.*//')
		arg=$(echo "$arg" | sed -E 's/(.*)\ (.*)/\1/')
		echo '	'set "$arg"="$val"
		sed -Ei s/^"$arg".*/"$arg"="$val"/ config.txt
	elif [[ "$inp" =~ ^(-readme)$|^(-rdme)$|^(-read)$|^(\-r)$ ]]
	then
		echo '
'; cat README"$lang".md; echo '
'
	elif [[ "$inp" =~ ^(-readme)|^(-rdme)|^(-rdm)|^(\-r) ]]
	then
		sec=$(echo "$inp" | sed -E 's/(-readme\ )|(-rdme\ )|(-rdm\ )|(-r\ )//' | tr "[:upper:]" "[:lower:]")
		echo "$(sed -n "/\t$sec.*/,/˔/p" README.md | sed '1d' | sed '$d')
		"
	elif [[ "$inp" =~ ^(-keyword)$|^(-keyw)$|^(-key)$|^(\-k)$ ]]
	then
		echo "$keyw"
		$inp
	fi
    read -p 'FVTT MMBGS: ' inp
done
if [[ $inp == $keyw ]]
then
	ln=$(wc -l "$bulk"bulk.txt | grep -oE '[0-9]+')
	let ln++
	read -p "$ln modulia listassa, suorita? [Y]/[N]: " cnt
	if [[ "$cnt" =~ ^N|^n ]]
	then
		exit
	fi
	inp="$dir"'/'"$inp"
	while [[ $ln -gt 0 ]]
	do
		echo $ln jäljellä
		#define per-file variables
		cur=$(head -n 1 "$bulk"bulk.txt | sed 's/\"/\\\\\"/g')
		num=$(echo "$cur" | grep -Eo '^[0-9]+|[0-9]+$')
		cur=$(echo "$cur" | sed -E "s/$num//g" | awk '{$1=$1};1')
		lmap=${cur//[[:space:][:punct:]]/-}
		lmap=${lmap,,}
		lmap=$(echo "$lmap" | sed -E 's/-+/-/g' | sed -E 's/^-|-$//g')
		imgs=$(find "$scrt" -type d -wholename "*$num*/*$num*/*WEBP*")
		scn="miskasmaps-$num-$lmap"
		if [[ "$imgs" =~ ^[[:space:]]*$|^$ ]]
		then
			if ! [[ "$cnt" =~ ^A|^a ]]
			then
				echo "$num" "$cur"
				read -p 'tiedostoja ei löytynyt, haluatko silti jatkaa?
	[Y] kyllä [A] kyllä kaikkiin [N] lopeta ohjelma [S] ohita tämä moduli: ' cnt
			fi
		fi
		if [[ "$cnt" =~ ^N|^n ]]
		then
			exit
		fi
		let ln--
		sed -i '1d' "$bulk"bulk.txt
		#create directories and files
		if ! [[ "$cnt" =~ ^S|^s ]]
		then
			mkdir "$trgt"/"$scn"
			cp -R "$dir"/template_module.json "$trgt"/"$scn"/module.json
			sed -i 's/%num%/'"$num"'/g' "$trgt"/"$scn"/module.json
			sed -i 's/%cur%/'"$cur"'/g' "$trgt"/"$scn"/module.json
			sed -i 's/%lmap%/'"$lmap"'/g' "$trgt"/"$scn"/module.json
			cd "$trgt"/"$scn"
			mkdir artwork
			mkdir tokens
			mkdir audio
			mkdir maps
			mkdir tiles
			#copy map image files into module
			cp -R "$imgs" "$trgt"/"$scn"/maps
			mv "$trgt"/"$scn"/maps/*WEBP*/* "$trgt"/"$scn"/maps
			rm -R "$trgt"/"$scn"/maps/*WEBP
		fi
		cd $dir
		if [[ "$imgs" =~ ^[[:space:]]*$^$ ]]
		then
			if [[ "$cnt" =~ ^S$|^s$ ]]
			then
				cnt=""
				echo "Skipped" "$num" "$cur" >> "$log"
			else
				echo "No files found" "$num" "$cur" >> "$log"
			fi
		else
			echo "Processed" "$num" "$cur" >> "$log"
		fi
	done
fi
if [[ "$wait" == true ]]
then
	read -p "Press enter to exit" 
else
	true
fi