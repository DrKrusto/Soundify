# Soundify

## Configuration

Pour faire en sorte que le backend soit fonctionnel il est nécessaire de configurer l'URL dans les settings.

### Pour le front-end

Dans le fichier [main.dart](https://github.com/DrKrusto/Soundify/blob/50ddfd72efc38583febda1383c8bf548574a846c/Soundify-mobile/lib/main.dart#L17) il faut modifier le serverUrl pour correspondre à l'IP votre ordinateur local (veuillez à mettre une addresse HTTP et non HTTPS).

### Pour le back-end

Dans le fichier [appsettings.json](https://github.com/DrKrusto/Soundify/blob/50ddfd72efc38583febda1383c8bf548574a846c/Soundify-backend/appsettings.json#L14) il faut aussi faire correspondre l'URL à votre adresse IP locale (veuillez à mettre une addresse HTTP et non HTTPS).

## Lancer le projet

Il faut en premier lieu lancer l'exécutable du back-end: [Soundify-backend.exe](https://github.com/DrKrusto/Soundify/blob/main/Soundify-backend/Soundify-backend.exe)

Ensuite il faut run le projet mobile Flutter, et normalement tout devrait fonctionner correctement.

## Informations supplémentaires

Il est possible d'accéder au SwaggerUI contenant nos endpoints du back-end en accédant dans un navigateur web à votre URL (toujours en HTTP) et au fichier /swagger/index.html.