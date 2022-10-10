# ISEN Companion

[![Netlify Status](https://img.shields.io/netlify/6309014f-efa4-4fce-a934-37abf996f123)](https://app.netlify.com/sites/isen-companion/deploys)
[![Website Status](https://img.shields.io/website?url=https%3A%2F%2Fisen.melois.dev)][website-url]
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/sehnryr/isen_companion)](#)
[![GitHub](https://img.shields.io/github/license/sehnryr/isen_companion)](#)

Application web : [isen.melois.dev][website-url]

Cette application simplifie l'accès aux services de l'ISEN aux étudiants (et enseignants). (Aurion pour l'instant)

De nombreux étudiants peuvent témoigner qu'Aurion n'est pas assez ergonomique et c'est pourquoi certains ont pris l'initiative de l'améliorer. [Scorpion](https://github.com/LiamAbyss/Scorpion) codé en Java, [PyAurion](https://github.com/MylowMntr/PyAurion) en Python, [Aurion-Planning_to_ICS](https://github.com/Victor-Loos/Aurion-Planning_to_ICS) également en Python, [Api Aurion](https://github.com/nicolegrimpeur/apiAurion) en Javascript sont quelques-uns des nombreux projets entrepris par les étudiants. C'est pour cela que moi aussi j'ai décidé de prendre du temps pour l'améliorer.

[website-url]: https://isen.melois.dev/

## Fonctionnalités

- [x] Emploi du temps de l'utilisateur
- [ ] Emploi du temps d'un groupe
- [ ] Disponibilité d'une salle
- [ ] Voir les notes de l'utilisateur (si étudiant)
- [ ] Voir les absences de l'utilisateur (si étudiant)
- [x] Récupération du mot de passe
- [ ] Sondages

## Mentions légales

ISEN Companion fonctionne sur la base d'un web scraper[^1] qui fait interface aux services de l'ISEN. Vos identifiants (utilisateur, mot de passe, cookie de connexion) ne sont stockés que sur vos appareils et dans le cache du navigateur de manière encrypté à l'aide de [`encrypted_shared_preferences`](https://pub.dev/packages/encrypted_shared_preferences). Les données sont stockées dans le cache du navigateur et sont supprimées lorsque vous supprimez le cache ou lorsque vous vous déconnectez.

Si vous utilisez l'application web, vous devrez utiliser un proxy pour passer outre la sécurité CORS. Pour cela j'ai utilisé [cors-proxy](https://github.com/sehnryr/cors-proxy) un projet que j'ai optimisé pour ISEN Companion. Le proxy est hébergé sur [Fly.io](https://fly.io/) et est donc gratuit. Si vous souhaitez héberger votre propre proxy, vous pouvez le faire en suivant les instructions du projet.

> **Warning**
> Si vous êtes un utilisateur de Safari, vous ne pourrez pas modifier le proxy car le navigateur ne permet pas de faire des requêtes inter-sites et les cookies ne pourront pas êtres enregistrés. Il vous faudrait donc soit utiliser un autre navigateur, soit décocher l'option Confidentialité > Prevent cross-site tracking.

[^1]: Le web scraping est une technique d'extraction du contenu de sites Web, via un script ou un programme, dans le but de le transformer pour permettre son utilisation dans un autre contexte. (https://fr.wikipedia.org/wiki/Web_scraping)

## Contact

Pour tout problème, suggestion ou autre, vous pouvez me contacter via Discord [Sehnryr#0001](https://discord.com/users/230563291146092545) (ou par email [youn@melois.dev](mailto:youn@melois.dev))