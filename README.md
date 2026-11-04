# Maravel XY

[![Version](https://img.shields.io/badge/version-1.1.4-blue.svg)](https://github.com/mawena/maravel-xy/releases)
![PHP](https://img.shields.io/badge/php-%5E8.2-777BB4.svg)
![Laravel](https://img.shields.io/badge/laravel-%5E12.0-FF2D20.svg)
![Vue](https://img.shields.io/badge/vue-3.x-4FC08D.svg)

Template de démarrage Laravel + Vue 3 (Vuetify) pour lancer rapidement une nouvelle application web :
authentification par jeton Sanctum, gestion des utilisateurs, rôles et permissions dynamiques (RBAC)
partagés entre l'API et l'interface, le tout bâti sur la librairie [`mawena/maravel`](https://github.com/mawena/maravel).

## Table des matières

- [Fonctionnalités](#fonctionnalités)
- [Stack technique](#stack-technique)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [API](#api)
- [Ajouter une nouvelle ressource](#ajouter-une-nouvelle-ressource)
- [Gestion globale des erreurs API](#gestion-globale-des-erreurs-api)
- [Structure du projet](#structure-du-projet)
- [Tests et qualité](#tests-et-qualité)
- [Déploiement](#déploiement)
- [Versions](#versions)
- [Licence](#licence)

## Fonctionnalités

- **Authentification** par jeton Laravel Sanctum : connexion, récupération de l'utilisateur courant,
  déconnexion.
- **Statut de compte** : un compte peut être désactivé (`activated`) ou obligé de changer son mot de
  passe (`password_change_required`) ; le middleware `account.status` de Maravel bloque alors l'accès
  aux ressources protégées.
- **Gestion des utilisateurs, rôles et permissions** (CRUD) côté API et dans l'interface
  d'administration (`/admin/users`, `/admin/roles`, `/admin/permissions`).
- **RBAC dynamique** : une permission est un couple `action` + `subject` (ex. `read` / `user`) ; un rôle
  regroupe des permissions et peut être super-administrateur (`is_super_admin`, tous les droits). Les
  règles de l'utilisateur sont exposées au format CASL (`ability_rules`) et pilotent le menu, les gardes
  de navigation et les boutons du frontend.
- **Tableaux** avec recherche, filtres, tri et pagination entièrement côté frontend
  (`VDataTableServer` + composable `useClientTable`), bouton « Recharger » et animation de suppression
  de ligne.
- **Formulaires d'ajout/édition** générés à partir d'une liste de champs (composant `FieldRenderer`).
- **Redirections automatiques** sur réponse 401 (connexion) et 403 « changement de mot de passe
  requis » (page de sécurité du compte).
- **Interface** multilingue (fichiers `fr`, `en`, `ar`), thème clair/sombre, routage par fichiers.

## Stack technique

- **Backend** : PHP 8.2+, Laravel 12, Laravel Sanctum 4, [`mawena/maravel`](https://github.com/mawena/maravel) ^4.1
  (contrôleur API générique `APIController`, `BasePolicy`, modèles `AuthenticatableBase`, `Role`,
  `Permission`, middleware `AccountStatusMiddleware`).
- **Frontend** : Vue 3, Vuetify 3, Vite 7 (`laravel-vite-plugin`), Pinia, Vue Router avec routage par
  fichiers (`unplugin-vue-router`), CASL (`@casl/ability`, `@casl/vue`), vue-i18n, ofetch / VueUse.
  L'interface reprend le socle du thème d'administration Vuexy (`resources/js/@core`,
  `resources/js/@layouts`, composants et vues de démonstration dans `resources/js/views`).
- **Base de données** : MySQL par défaut (`.env.example`) ; tables de cache et de files d'attente
  fournies par les migrations.
- **Outillage** : pnpm, ESLint, Stylelint, Laravel Pint, PHPUnit, Laravel Sail (`compose.yaml`).

## Prérequis

- PHP 8.2 ou plus récent et Composer
- Node.js LTS (`.nvmrc` : `lts/*`) et pnpm (`pnpm-lock.yaml`)
- Un serveur MySQL (ou Docker pour utiliser Laravel Sail)

## Installation

```bash
# Dépendances PHP
composer install

# Dépendances JavaScript (le postinstall génère les icônes et le service worker MSW)
pnpm install

# Fichier d'environnement et clé d'application
cp .env.example .env
php artisan key:generate

# Renseigner DB_* dans .env, puis créer les tables
php artisan migrate

# Rôle « admin », permissions de base et compte administrateur
php artisan db:seed
```

Le script `composer setup` enchaîne ces étapes (sans le seeder), mais utilise `npm` et construit les
assets de production (`npm run build`).

## Configuration

Variables principales du fichier `.env` (voir `.env.example`) :

| Variable | Rôle |
| --- | --- |
| `APP_NAME`, `APP_URL`, `APP_LOCALE` | Nom, URL publique et langue de l'application |
| `DB_CONNECTION`, `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` | Connexion à la base de données |
| `SESSION_DRIVER`, `CACHE_STORE`, `QUEUE_CONNECTION` | Sessions, cache et files d'attente |
| `MAIL_*` | Envoi des e-mails |
| `VITE_APP_NAME` | Nom affiché côté frontend |
| `VITE_API_BASE_URL` | Base des appels API du frontend (vide = `/api`) |
| `VITE_MAPBOX_ACCESS_TOKEN` | Utilisé uniquement par des vues de démonstration du thème |

Les réglages par défaut des contrôleurs API Maravel (pagination, noms des capacités d'autorisation…)
sont dans `config/advanced-api-controller.php`.

## Utilisation

### Lancer l'environnement de développement

```bash
# Terminal 1 : serveur Laravel (http://127.0.0.1:8000 par défaut)
php artisan serve

# Terminal 2 : serveur Vite (rechargement à chaud des assets)
pnpm dev
```

L'application s'ouvre sur l'URL servie par Laravel ; Vite ne sert que les assets. La commande
`composer dev` lance en une fois le serveur, un worker de file d'attente, les logs (`pail`) et Vite.

Avec Docker (Laravel Sail : application, MySQL, Redis, Mailpit, Selenium) :

```bash
./vendor/bin/sail up -d
```

### Compte par défaut

`php artisan db:seed` crée un utilisateur administrateur (rôle `admin`, super-administrateur) :

- E-mail : `admin@example.com`
- Mot de passe : `password`

Changez ce mot de passe dès la première connexion hors environnement local.

### Pages de l'application

| Route | Contenu |
| --- | --- |
| `/` | Accueil (page publique de présentation du template) |
| `/login` | Connexion |
| `/admin/users` | Utilisateurs (permission `read` / `user`) |
| `/admin/roles` | Rôles (permission `read` / `role`) |
| `/admin/permissions` | Permissions (permission `read` / `permission`) |
| `/account/security` | Changement de mot de passe |

Toutes les URL non-API sont renvoyées vers l'application Vue (`routes/web.php`).

## API

Toutes les routes sont préfixées par `/api` (`routes/api.php`) et renvoient du JSON.

| Méthode | Route | Accès |
| --- | --- | --- |
| `POST` | `/api/auth/login` | public |
| `GET` | `/api/auth/data` | authentifié |
| `DELETE` | `/api/auth/logout` | authentifié |
| `PUT` | `/api/users/update-password` | authentifié (même si un changement de mot de passe est requis) |
| `GET/POST/PUT/PATCH/DELETE` | `/api/users`, `/api/roles`, `/api/permissions` (`apiResource`) | authentifié + `account.status` + policies |

Le jeton renvoyé à la connexion est transmis dans l'en-tête `Authorization: Bearer <jeton>`. Les listes
acceptent notamment le paramètre `paginate=false` pour récupérer tous les éléments en un appel.

## Ajouter une nouvelle ressource

Exemple avec une ressource `Produit`.

### 1. Backend

```bash
php artisan make:model Produit -m
php artisan make:controller API/ProduitController
php artisan make:policy ProduitPolicy
```

Le contrôleur hérite du contrôleur générique de Maravel, comme `UserController`, `RoleController` et
`PermissionController` :

```php
namespace App\Http\Controllers\API;

use App\Models\Produit;
use Maravel\Http\Controllers\APIController;

class ProduitController extends APIController
{
    protected string $modelClass = Produit::class;

    protected array $indexSearchFieldList = ['nom'];

    public function __construct()
    {
        parent::__construct();

        $this->storeValidationArray = [
            'nom' => 'required|string|max:255',
        ];
    }
}
```

La policy hérite de `Maravel\Policies\BasePolicy` et indique le sujet utilisé dans les permissions :

```php
namespace App\Policies;

use Maravel\Policies\BasePolicy;

class ProduitPolicy extends BasePolicy
{
    protected $modelName = 'produit';
}
```

Déclarez la route dans le groupe protégé de `routes/api.php` (`auth:sanctum` + `account.status`) :

```php
Route::apiResource('produits', ProduitController::class);
```

Créez enfin les permissions correspondantes (ex. `read` / `produit`) dans `RolePermissionSeeder` ou
depuis la page **Permissions**, puis attribuez-les à un rôle.

### 2. Frontend

Créez `resources/js/pages/admin/produits/index.vue` : la route `/admin/produits` est générée
automatiquement à partir du chemin du fichier.

```vue
<script setup>
definePage({
  meta: {
    action: 'read',
    subject: 'produit',
  },
})

const produits = ref([])

onMounted(async () => {
  const res = await $api('/produits', { query: { paginate: false } })
  produits.value = res.data
})
</script>

<template>
  <!-- Votre template -->
</template>
```

Ajoutez l'entrée de menu
dans `resources/js/navigation/vertical/index.js` (avec les mêmes `action` / `subject`).

### 3. Liste avec filtres + formulaire dynamique

Les pages `admin/users`, `admin/roles` et `admin/permissions` montrent le pattern à reproduire :

- **Liste** : un seul appel API avec `paginate: false` au montage, puis un `computed` qui applique la
  recherche/les filtres, et le composable `useClientTable(filteredItems)` pour le tri/la pagination
  (alimente `VDataTableServer` via `page`, `itemsPerPage`, `updateOptions`, `paginatedItems`,
  `totalItems` — aucun appel réseau supplémentaire).
- **Formulaire** : une liste de champs (`value_key`, `type`, `label`, `required`, `cols`, `data`, `show`)
  rendue avec `<FieldRenderer v-model="form[field.value_key]" :field="field" />` dans une boucle
  `v-for` sur `VCol`, plutôt que des champs Vuetify codés en dur. Types supportés : `text`, `number`,
  `email`, `password`, `textarea`, `tiptap`, `date`, `lov` (liste de valeurs/autocomplete), `select`,
  `boolean`, `checkbox`, `file`.
- **Rechargement + animation de suppression** : un bouton « Recharger » (`:loading="loading"` +
  `@click="fetchX"`) relance le chargement de la liste. À la suppression, l'id de la ligne est ajouté à un
  `Set` réactif `deletingIds`, exposé au tableau via `:row-props` (classe CSS `row-removing` définie dans
  le `<style scoped>` du composant) ; le rechargement de la liste est différé de la durée de l'animation
  (`ROW_REMOVE_ANIMATION_DURATION`) pour laisser la ligne disparaître en fondu avant de retirer la donnée.

## Gestion globale des erreurs API

Les deux clients HTTP du frontend — `$api` (`resources/js/utils/api.js`, basé sur ofetch) et `useApi`
(`resources/js/composables/useApi.js`, basé sur `createFetch` de VueUse) — partagent une gestion
centralisée des erreurs via `handleApiError(status, errors)` exportée par `resources/js/utils/api.js` :

- **401 Non authentifié** : la session locale est purgée (cookies `accessToken`, `userData`,
  `userAbilityRules`) et l'utilisateur est redirigé vers la page de connexion (`/login`). La page en
  cours est conservée dans le paramètre `?to=` afin d'y revenir automatiquement après reconnexion.
- **403 avec `errors.password_change_required`** (`sub_code` `002`, renvoyé par le middleware
  `AccountStatusMiddleware` du package Maravel) : l'utilisateur est redirigé vers la page de changement
  de mot de passe (`/account/security`), seule page — avec la déconnexion — autorisée par le backend
  tant que le mot de passe n'a pas été changé. Le cookie `userData` est mis à jour
  (`password_change_required: true`) pour que l'interface reflète cet état.

Les redirections utilisent l'instance `router` importée depuis `@/plugins/1.router` (et non
`useRouter()`, qui n'est pas disponible hors du contexte d'un composant).

Les hooks d'erreur définis localement sur un appel (par exemple `onResponseError` pour afficher les
erreurs de validation d'un formulaire) restent exécutés : ofetch ≥ 1.4 chaîne les hooks globaux et
locaux au lieu de les remplacer.

## Structure du projet

```
├── app/
│   ├── Http/Controllers/API/   # AuthController, UserController, RoleController, PermissionController
│   ├── Models/                 # User, Role, Permission (héritent des modèles Maravel)
│   └── Policies/               # Policies basées sur Maravel\Policies\BasePolicy
├── bootstrap/app.php           # Routage et alias du middleware account.status
├── config/advanced-api-controller.php  # Réglages des contrôleurs API Maravel
├── database/
│   ├── migrations/             # Utilisateurs, jetons Sanctum, rôles, permissions, statut de compte
│   └── seeders/                # DatabaseSeeder (admin) et RolePermissionSeeder
├── resources/
│   ├── js/
│   │   ├── pages/              # Pages Vue (routage par fichiers)
│   │   ├── components/         # Composants (dont FieldRenderer)
│   │   ├── composables/        # useApi, useClientTable…
│   │   ├── navigation/         # Menus vertical et horizontal
│   │   ├── plugins/            # Router (gardes), CASL, i18n, Vuetify, Pinia…
│   │   ├── utils/api.js        # Client $api et handleApiError
│   │   ├── @core, @layouts     # Socle du thème Vuexy
│   │   └── views/              # Vues et démos du thème
│   └── views/application.blade.php  # Point d'entrée HTML de l'application Vue
├── routes/
│   ├── api.php                 # Routes API
│   └── web.php                 # Renvoi de toutes les URL vers l'application Vue
├── tests/                      # Tests PHPUnit (Feature, Unit)
├── compose.yaml                # Laravel Sail
└── vite.config.js
```

## Tests et qualité

```bash
# Tests PHP (PHPUnit) — équivalent : composer test
php artisan test

# Lint du frontend (ESLint, avec correction automatique)
pnpm lint

# Formatage du code PHP
./vendor/bin/pint
```

`phpunit.xml` utilise la base `testing` (`DB_DATABASE`) avec la connexion définie dans `.env`. Le dépôt
ne contient pour l'instant que les tests d'exemple.

## Déploiement

```bash
composer install --no-dev --optimize-autoloader
pnpm install
pnpm build            # génère public/build
php artisan migrate --force
```

Le dossier `public/build` est versionné dans le dépôt : pensez à le régénérer avant de publier une
version qui modifie le frontend.

## Versions

L'historique des versions est tenu dans [CHANGELOG.md](CHANGELOG.md) ; chaque version est taguée
`vX.Y.Z` ([releases](https://github.com/mawena/maravel-xy/releases)).

## Licence

Le fichier `composer.json` déclare la licence MIT ; aucun fichier `LICENSE` n'est présent dans le dépôt.
