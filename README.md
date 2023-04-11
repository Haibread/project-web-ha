# Projet Web Haute Disponibilité

L'objectif de ce projet est de metre en place une haute disponibilité des serveurs web grâce à Consul est à NGINX

## Mise en place de la partie serveur

### Installation de Consul et Nginx

#### Installation de Consul

Pour installer Consul, on peut suivre [le documentation de Hashicorp](https://developer.hashicorp.com/consul/downloads)

Les commandes pour Ubuntu/Debian :

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul consul-template
```

#### Installation de NGINX

Pour installer NGINX, on peut généralement le faire depuis les repository déjà intégrés avec la commande `apt install nginx`

### Récupération du projet pour le serveur

Sur le serveur Consul/NGINX on peut cloner ce projet avec la commande `git clone https://github.com/Haibread/project-web-ha.git`

### Configuration de Consul et NGINX

#### Configuration de NGINX

Pour NGINX, il est suffisant de supprimer le fichier `/etc/nginx/sites-enabled/default` s'il est présent afin que le serveur agisse comme un reverse proxy/load balancer plutôt qu'un serveur web

#### Configuration de Consul

La configuration de Consul nécessite de copier le fichier `template/lb-template.conf.ctmpl` de ce projet à l'emplacement `/etc/nginx/conf.d/` sur le serveur

### Lancement des applicatifs

On peut relancer NGINX suite aux modification effectuées avec la commande `systemctl restart nginx`

Consul peut être démarré avec la commande `consul agent -config-dir=project-web-ha/consul/server`

Enfin, consul-template doit aussi être démarré avec la commande `consul-template -config=project-web-ha/template/consul-template-lb.hcl`

## Mise en place de la partie cliente

### Installation de Consul et NGINX (Ou httpd)

Pour installer Consul, la manipulation est la même que pour la partie serveur, on peut suivre [le documentation de Hashicorp](https://developer.hashicorp.com/consul/downloads).

Les commandes sout Ubuntu/Debian sont :

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul consul-template
```

Pour la partie du serveur Web, on peut installer le serveur web de son choix, il est uniquement nécessaire qu'un serveur réponde sur le port 80.

### Récupération du projet pour chacun des clients

Sur chacun des clients on peut cloner le projet avec la commande `git clone https://github.com/Haibread/project-web-ha.git`

### Configuration de Consul sur les clients

Par défaut, les client Consul vont essayer d'aller accéder au serveur `consul-server1`.
Il est nécessaire de soit rajouter une entrée DNS pour cet hôte, soit de modifier le serveur pour pointer vers le votre.
Pour se faire, il est nécessaire de modifier la clé `retry_join` dans le fichier `project-web-ha/consul/client/client.json`

### Lancement de Consul sur les clients

Il suffit ainsi de démarrer Consul avec la commande `consul agent -config-dir=project-web-ha/consul/client`

## Vérification du bon fonctionnement

Pour vérifier que les serveurs web aient bien été ajoutés à la configuration du load balancer, on peut aller vérifier le contenu du fichier `/etc/nginx/conf.d/load-balancer.conf`

Si tout fonctionne correctement, vous devriez avoir les adresses ip de vos serveurs web dans le fichier.
