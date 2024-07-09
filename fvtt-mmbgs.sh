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
echo 'käytä komentoa -help nähdäksesi saatavilla olevat komennot'
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
	ln=$(wc -l "$bulk"/bulk.txt | grep -oE '[0-9]+')
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
		let ln--
		#define per-file variables
		cur=$(head -n 1 "$bulk"/.txt | sed 's/\"/\\\\\"/g')
		num=$(echo "$cur" | grep -Eo '^[0-9]+|[0-9]+$')
		cur=$(echo "$cur" | sed -E "s/$num//g" | awk '{$1=$1};1')
		sed -i '1d' "$bulk"/bulk.txt
		lmap=${cur//[[:space:][:punct:]]/-}
		lmap=${lmap,,}
		lmap=$(echo "$lmap" | sed -E 's/-+/-/g' | sed -E 's/^-|-$//g')
		imgs=$(find "$scrt" -type d -wholename *$num*/*$num*/*WEBP*)
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
		#create directories and files
		if ! [[ "$cnt" =~ ^S|^s ]]
		then
			mkdir "$scn"
			cp -R "$dir"/template_module.json "$dir"/"$scn"/module.json
			sed -i 's/%num%/'"$num"'/g' "$dir"/"$scn"/module.json
			sed -i 's/%cur%/'"$cur"'/g' "$dir"/"$scn"/module.json
			sed -i 's/%lmap%/'"$lmap"'/g' "$dir"/"$scn"/module.json
			cd "$dir"/"$scn"
			mkdir artwork
			mkdir tokens
			mkdir audio
			mkdir maps
			mkdir tiles
			#copy map image files into module
			cp -R "$imgs" "$dir"/"$scn"/maps
			mv "$dir"/"$scn"/maps/*WEBP*/* "$dir"/"$scn"/maps
			rm -R "$dir"/"$scn"/maps/*WEBP
		fi
		cd $dir
		if [[ "$imgs" =~ ^[[:space:]]*$^$ ]]
		then
			if [[ "$cnt" =~ ^S$|^s$ ]]
			then
				cnt=""
				echo "Skipped $num $cur" > "$log"
			else
				echo "No files found $num $cur" > "$log"
			fi
		else
			echo "Processed $num $cur" > "$log"
		fi
	done
else
	#single file version
	cur=$(echo "$inp" | sed 's/\"/\\\\\"/g')
	num=$(echo "$cur" | grep -Eo '^[0-9]+|[0-9]+$')
	cur=$(echo "$cur" | sed -E "s/$num//g" | awk '{$1=$1};1')
	lmap=${cur//[[:space:][:punct:]]/-}
	lmap=${lmap,,}
	lmap=$(echo "$lmap" | sed -E 's/-+/-/g' | sed -E 's/^-|-$//g')
	imgs=$(find "$scrt" -type d -wholename *$num*/*$num*/*WEBP*)
	scn="miskasmaps-$num-$lmap"
	#create directories and files
		if [[ "$imgs" =~ ^[[:space:]]*$|^$ ]]
		then
			echo "$num" "$cur"
			read -p 'tiedostoja ei löytynyt, haluatko silti jatkaa?
[Y] kyllä [N] lopeta ohjelma: ' cnt
		fi
		if [[ "$cnt" =~ ^N|^n ]]
		then
			exit
		fi
	#create directories and files
	mkdir "$scn"
	cp -R "$dir"/template_module.json "$dir"/"$scn"/module.json
	sed -i 's/%num%/'"$num"'/g' "$dir"/"$scn"/module.json
	sed -i 's/%cur%/'"$cur"'/g' "$dir"/"$scn"/module.json
	sed -i 's/%lmap%/'"$lmap"'/g' "$dir"/"$scn"/module.json
	cd ./"$scn"
	mkdir artwork
	mkdir tokens
	mkdir audio
	mkdir maps
	mkdir tiles
	#copy map image files into module
	cp -R "$imgs" "$dir"/"$scn"/maps
	mv "$dir"/"$scn"/maps/*WEBP*/* "$dir"/"$scn"/maps
	rm -R "$dir"/"$scn"/maps/*WEBP*
fi
if [[ $inp == $keyw ]]
then
fi
if [[ "$wait" == true ]]
then
	read -p "press enter" 
else
	true
fi