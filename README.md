###	käyttöohjeet

HUOM! Tämä skripti on kirjoitettu bash kielessä ja tarvitsee jonkin bash kuoren kuten git bashin, jonka voi ladata osoitteesta [https://git-scm.com/downloads] tai syöttämällä powershell komentokehotteeseen tämän komennon [winget install --id Git.Git -e --source winget]	Git latauksen koko pitäisi olla ~50 Mb
	Huom: Skriptin käyttö ei vaadi kokemusta bash koodikieleessä

Ennen käyttöönottoa sinun tarvitsee luoda minkä tahansa niminen tekstitiedosto [.txt] mihin tahansa sijaintiin tietokoeellesi ja ja kirjoittaa polku siihen mukana olevaan config.txt tiedostoon, tämä toimii joukko syöttö tiedostona, jonka avulla pystyy syöttämään useiden karttojen tiedot kerralla. Kaikkien pakkauksen tiedostojen (readme.txt, config.txt, template_module.json fvtt-mmbgs.sh) tulee sijaita samassa kansiossa täyden toiminnallisuuden takaamiseksi. Kaikki luodut modulit luodaan samaan kansioon jossa sckripti sijaitsee, mutta tämä sijainti tulee olevaan muutettavissa config.txt tiedostosta myöhemmin.

#esimerkki joukko syöttö tiedoston sisällöstä

	<	"Euripides" Smuggling Submarine 402
		Street Intersection 401
		Sewer Nest 400
		399 Scavtown Street
		CY-2290 Light Freighter Deckplan 398
		Wellspring Metro Station 397
		Wrecked Cargo Freighter 396
		395 Watson 913 Bodega					>

Tämä skripti luo kansio hierarkian ja module.json tiedoston, joka sisältää tarvittavan datan luomaan Foundry VTT compendium paketit. Tämä skriptin versio (v1.0) ei tee mitään muuta ja kaikki muu pitää tehdä manuaalisesti, lisäominaisuudet ovat suunnitteissa.

Kartat voi syöttää joukko syöttö tiedostoon yhden per rivi, kartan numero voi olla kartan nimeä ennen tai jälkeen  missä tahansa yhdistelmässä joukko syöttö tedostoon.
Halutessasi syöttää vain yhden kartan voit kirjoittaa samalla tavalla numeron ennen nimeä tai sen jälkeen.

		'Esimerkki Kartta 123' ja '123 Esimerkki Kartta' kelpaavat kumpikin

Kartan nimessä voi olla numeroita, mutta jos ne ovat nimen päässä, ne tulee sulkea käyttäen kartan numeroa.

		 '123 Esimerkki 3 Kartta' siis keplaavat, mutta '123 Esimerkki kartta 3' tulisi merkitä 'Esimerkki Kartta 3 123' ja '3Esimerkki Kartta 123' merkitä '123 3Esimerkki Kartta'
˔
	komennot

[kartan nimi ja numero]
		Kartan numeron voi kirjoittaa kummalle tahansa puolelle sen nimeä ja kartan nimi käyttäen välilyöntejä ja iosja kirjaimia

-help, -h
		Näyttää tämän listan

	NON FUNCTIONAL
-config, -cfg, -c [asetus] [arvo]
		Muuttaa asetuksen arvoa(katso config.txt tai -config ilman argumentteja nähdäksesi nykyiset asetukset ja niiden kuvaukset)
	
-exit, -ex, -e
		Pakota skriptin lopetus

-keyword, -keyw, -key, -k
		Näyttää nykyisen joukkosyöttö komennon ja aloittaa joukko syötön

-readme, -rdme, -rdme, -rm, -r [osio]
		Näyttää readme tiedoston sisällön (ikkunan suurentaminen suositeltua), tietyn osion otsikon lisääminen näyttää vain kyseisen osion tekstin, koko osion nimeä ei tarvitse kirjoittaa, sen alku riittää
˔
	suunnitellut ominaisuudet

-lisää asetuksia ja laajennetut käyttöohjeet
-koodin rakenteen parannus
-muita mahdollisesti tarpeeseen tulevia ominaisuuksia
-englannin kielinen versio
˔
	yksinkertaistetut käyttöohjeet

Yksi tiedosto:
1.	Avaa fvtt-mmbgs.sh
2.	Kirjoita kartan nimi ja sen numero
3.	paina 'ENTER' näppäintä

Useampi tiedosto:
1.	Listaa kaikkien karttojen nimet ja numerot yksi per rivi joukko syöttö tiedostoosi
2.	Avaa fvtt-mmbgs.sh ja syötä joukko syöttö komentosi tai kirjoita "-key" komentokehotteeseen
3.	paina 'ENTER' näppäintä
˔
	info

Foundry Virtual Tabletop Map Module Base Generator Script v.1.0
FVTT MMBGS requires a program capable of running bash to run, for windows users you can download git bash here: [https://git-scm.com/downloads]
