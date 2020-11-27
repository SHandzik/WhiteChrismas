### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 075ae186-3096-11eb-3d69-418304b77f42
using Pkg

# ╔═╡ 3c3df92c-3096-11eb-2a26-3fc7062e9a71
using DataFrames, CSV, Statistics, Dates,  PlutoUI

# ╔═╡ 0e8c7c7c-30a9-11eb-1b63-5b0db0474b5e
md" # Weiße Weihnachten"

# ╔═╡ e005ce34-30b3-11eb-02ce-cdb741dd8a30
md" Jedes Jahr stellt sich die Frage, ob es weiße Weihnachen gibt."

# ╔═╡ 9ea052b2-30b2-11eb-0d57-9bfe97d4e11a
md" Auf Grundlage der Wetteraufzeichnungen der letzten 30 Jahre habe ich eine Auswertung der Daten durchgeführt. Die Bedingung weiße Weihnachen ist erfüllt wenn am **24. Dezember mindestens 2 cm Schnee liegen**."

# ╔═╡ 35ae104a-30b3-11eb-0ff6-db83d761ebd5
md" Als Datengrundlage dienen aufzeichnungen des Deutschen Wetterdienstes die über das [Open Data Portal](https://opendata.dwd.de/) des DWD zur Verfügung gestellt werden." 

# ╔═╡ 05570c7a-30b4-11eb-3c30-31c79f0b79de
md" **In die Auswertung einbezogen wurden die Stationen:**

* Kahler Asten  
* Eslohe  
* Lennestadt-Theten
* Lippstadt-Bökenförde
* Bad Berleburg
* Reichshof-Eckenhagen
* Lüdenscheid
* Brilon-Thülen  
* Meinerzhagen-Redlendorf "



# ╔═╡ 349de516-30b5-11eb-367b-01bd51569fdf
md" ## Los geht's"

# ╔═╡ 0803770c-30b5-11eb-1e9f-6331f54b715c
md" **Vorbereitung der IDE und Laden notwendiger Bibliotheken**"

# ╔═╡ 1477dfcc-3096-11eb-2495-4546658120e7
Pkg.activate()

# ╔═╡ 1dc5a1b6-309d-11eb-1473-572e732137d1
md" **Laden der Daten und Beseitigung fehlender Daten**"

# ╔═╡ 6652ebf4-3096-11eb-2906-61aa0012fbea
suedwest_weather = CSV.File("./dwd_hist_weather.csv") |> DataFrame;

# ╔═╡ 13b0b6ba-30a0-11eb-20b5-c969e54a0600
replace!(suedwest_weather.Snow, -999 => 0);

# ╔═╡ 11e8a3ba-309e-11eb-2560-81f8891c8130
md" **Selektion der Daten**
* Schritt 1: Alle Daten 1990 und später
* Schritt 2: Alle Daten aus Dezember"

# ╔═╡ ef171328-3096-11eb-1d47-bdefe7973ec8
data1 = filter(:Year => >=(1990), suedwest_weather)

# ╔═╡ cbbf0e16-3097-11eb-3d3f-b51eb0c55188
data2 = filter(:Month => ==(12), data1)

# ╔═╡ 2706134e-30bb-11eb-253d-7bf6c9c72a06
md" **Löschen von Station die keine relevanten Daten enthalten.**
* 3096 Lüdenscheid Geschwister Scholl Gymnasium ==> Daten nur bis 1995
* 7330 Arnsberg-Neheim ==> Station ohne Schneedaten

**Also Weg Damit!**"

# ╔═╡ 70cb316c-30b8-11eb-065d-9fed0bead62b
begin
	data2[data2[:Station_ID].!=3096,:]
	data2[data2[:Station_ID].!=7330,:]
end;

# ╔═╡ 16d52bba-30b6-11eb-3511-5513381f6e02


# ╔═╡ ebaab82e-30b5-11eb-2574-ebe3bcb39cef
md" **Hinzufügen einer neuen Spalte >Day< um anschießend den 24.12 separieren zu können**"

# ╔═╡ f97a44f6-3097-11eb-3399-59cb8ae9f1a4
data2[!, :Day] = day.(data2[!, :Date])

# ╔═╡ e159b87e-30c0-11eb-0971-c5c2c20edea2


# ╔═╡ a474e6a4-30bb-11eb-1fa6-fbffca20a38e
md" **Selektion des 24. Dezember**"

# ╔═╡ 3977ae86-3098-11eb-3078-b702d4abb2fa
whiteCh = filter(:Day => ==(24), data2)

# ╔═╡ 097f313e-30c2-11eb-001b-b9234bc8dc5e


# ╔═╡ 09334ecc-30c2-11eb-39eb-6571d27ef432


# ╔═╡ fb225e14-30bb-11eb-2ff0-cbe552d250f4
md" **Gruppierung der Daten über die Stations ID**"

# ╔═╡ 6e2e3816-3098-11eb-11d0-53319c74598f
whiteChStation = groupby(whiteCh, :Station_ID)

# ╔═╡ ec584f94-3098-11eb-05a4-730534c16d23
length(whiteChStation)

# ╔═╡ 139c4512-30c2-11eb-1b2c-572e9ad57dad
md" **Im Durchschnitt der betrachteten Periode liegt zu Weihnachten and den Stationen folgende Schneehöhe ;-)**

* 2483 ==> Kahler Asten 
* 1300 ==> Eslohe  
* 2947 ==> Lennestadt-Theten
* 3031 ==> Lippstadt-Bökenförde
* 0390 ==> Bad Berleburg
* 4127 ==> Reichshof-Eckenhagen
* 3098 ==> Lüdenscheid
* 6264 ==> Brilon-Thülen  
* 13713 => Meinerzhagen-Redlendorf "  

# ╔═╡ 64f9ffe2-3099-11eb-33fd-e78883ede319
combine(whiteChStation, :Snow => mean)

# ╔═╡ f8ed0b5a-30c0-11eb-31dc-c5d1737e5a8c
md" ## Interaktive Elemente
* Wählen Sie im Drop-down Menü die Station aus
und
* Wählen Sie über den Slider die Schneehöhe

## Schon Fertig!

## Viel Spaß!!"

# ╔═╡ 3d04a9d0-30a4-11eb-10cd-a10d1b0a5657
@bind statid Select(["2483" => "Kahler Asten",
					"1300" => "Eslohe",
					"2947" => "Lennestadt-Theten",
					"3031" => "Lippstadt-Bökenförde",
					"390" => "Bad Berleburg",
					"4127" => "Reichshof-Eckenhagen",
					"3098" => "Lüdenscheid",
					"6264" => "Brilon-Thülen",
					"7330" => "Arnsberg-Neheim",
					"13713" => "Meinerzhagen-Redlendorf"])

# ╔═╡ b6c17134-30a6-11eb-1b05-476cb6a00295
y = parse(Int64, statid);

# ╔═╡ 2865dd46-309a-11eb-1e0c-c194b0e934c7
station = filter(:Station_ID => ==(y), whiteCh);

# ╔═╡ 574cc278-30a4-11eb-3e2c-6d9bd74cfb5c
@bind x Slider(2:1:50)

# ╔═╡ ac24f3d8-30a4-11eb-13d0-5b84d85bfbeb
md" **Schneehöhe $x cm**"

# ╔═╡ dbdc676e-309a-11eb-0e29-2bc41f359003
begin
	total = size(station)
	total1 = total[1]
end;

# ╔═╡ 0aeb083a-309b-11eb-3060-b1de36466a16
begin
	snow = size(filter(:Snow => >=(x), station))
	snow1 = snow[1]
end;

# ╔═╡ f1cca890-30bd-11eb-3f98-0bbe5f90b067
white = round((snow[1]/total[1])*100, digits=3);

# ╔═╡ 0876ae50-30bf-11eb-07b7-199eb31094b3
md" ### Für eine Schneehöhe von

### $x cm 

### gibt es in $total1 Jahren $snow1 vorkommen"

# ╔═╡ 9978e648-30a1-11eb-0842-87ff6c93bc9c
md" ### Ihre Chance auf Weiße Weihnachten liegt bei $white %"

# ╔═╡ ae6722d2-30c3-11eb-2984-4d06ef28518b
begin
	if white > 50
		md" ### Es gibt noch Hoffung!"
	elseif white > 20
		md" ### Als das Wünschen noch geholfen hat"
	else	
		md" ### Oh, Oh, Ob das noch was wird?"
	end
end

# ╔═╡ Cell order:
# ╟─0e8c7c7c-30a9-11eb-1b63-5b0db0474b5e
# ╟─e005ce34-30b3-11eb-02ce-cdb741dd8a30
# ╟─9ea052b2-30b2-11eb-0d57-9bfe97d4e11a
# ╟─35ae104a-30b3-11eb-0ff6-db83d761ebd5
# ╟─05570c7a-30b4-11eb-3c30-31c79f0b79de
# ╟─349de516-30b5-11eb-367b-01bd51569fdf
# ╟─0803770c-30b5-11eb-1e9f-6331f54b715c
# ╠═075ae186-3096-11eb-3d69-418304b77f42
# ╠═1477dfcc-3096-11eb-2495-4546658120e7
# ╠═3c3df92c-3096-11eb-2a26-3fc7062e9a71
# ╟─1dc5a1b6-309d-11eb-1473-572e732137d1
# ╠═6652ebf4-3096-11eb-2906-61aa0012fbea
# ╠═13b0b6ba-30a0-11eb-20b5-c969e54a0600
# ╟─11e8a3ba-309e-11eb-2560-81f8891c8130
# ╠═ef171328-3096-11eb-1d47-bdefe7973ec8
# ╠═cbbf0e16-3097-11eb-3d3f-b51eb0c55188
# ╟─2706134e-30bb-11eb-253d-7bf6c9c72a06
# ╠═70cb316c-30b8-11eb-065d-9fed0bead62b
# ╟─16d52bba-30b6-11eb-3511-5513381f6e02
# ╟─ebaab82e-30b5-11eb-2574-ebe3bcb39cef
# ╠═f97a44f6-3097-11eb-3399-59cb8ae9f1a4
# ╟─e159b87e-30c0-11eb-0971-c5c2c20edea2
# ╟─a474e6a4-30bb-11eb-1fa6-fbffca20a38e
# ╠═3977ae86-3098-11eb-3078-b702d4abb2fa
# ╟─097f313e-30c2-11eb-001b-b9234bc8dc5e
# ╟─09334ecc-30c2-11eb-39eb-6571d27ef432
# ╟─fb225e14-30bb-11eb-2ff0-cbe552d250f4
# ╠═6e2e3816-3098-11eb-11d0-53319c74598f
# ╠═ec584f94-3098-11eb-05a4-730534c16d23
# ╟─139c4512-30c2-11eb-1b2c-572e9ad57dad
# ╟─64f9ffe2-3099-11eb-33fd-e78883ede319
# ╟─f8ed0b5a-30c0-11eb-31dc-c5d1737e5a8c
# ╟─3d04a9d0-30a4-11eb-10cd-a10d1b0a5657
# ╟─b6c17134-30a6-11eb-1b05-476cb6a00295
# ╟─2865dd46-309a-11eb-1e0c-c194b0e934c7
# ╟─574cc278-30a4-11eb-3e2c-6d9bd74cfb5c
# ╟─ac24f3d8-30a4-11eb-13d0-5b84d85bfbeb
# ╟─dbdc676e-309a-11eb-0e29-2bc41f359003
# ╟─0aeb083a-309b-11eb-3060-b1de36466a16
# ╟─f1cca890-30bd-11eb-3f98-0bbe5f90b067
# ╟─0876ae50-30bf-11eb-07b7-199eb31094b3
# ╟─9978e648-30a1-11eb-0842-87ff6c93bc9c
# ╟─ae6722d2-30c3-11eb-2984-4d06ef28518b
