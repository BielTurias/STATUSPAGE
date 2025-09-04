# a vegades fent el docker compose peta pq no estem registrats al azure container registry, aquesta comanda ho soluciona
# si et fa fer login pel navegador petarà pq assumeix que estas en local. En aquest cas s'ha d'afegir una altra flag que no recordo pero que segur està a stackoverflow

az acr login --name d01dataunit
