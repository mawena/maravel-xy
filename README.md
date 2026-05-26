# Application Template

Un template minimaliste conçu pour faciliter le démarrage rapide de nouvelles applications web avec une gestion utilisateurs complète et une authentification sécurisée.

## Caractéristiques

- ✅ **Authentification sécurisée** avec Laravel Sanctum
- ✅ **Gestion des utilisateurs** complète (CRUD)
- ✅ **Système de rôles et permissions** avec CASL
- ✅ **Frontend moderne** avec Vue 3 + Vuetify
- ✅ **Backend robuste** avec Laravel
- ✅ **Base de données** avec migrations
- ✅ **API RESTful** prête à l'emploi

## Structure du Projet

```
├── app/
│   ├── Http/Controllers/Admin/  # Contrôleurs API
│   ├── Models/                   # Modèles Eloquent
│   └── Providers/                # Service providers
├── database/
│   ├── migrations/               # Migrations de base de données
│   └── seeders/                  # Seeders pour les données initiales
├── resources/
│   └── js/
│       ├── pages/                # Pages Vue (routing automatique)
│       ├── components/           # Composants réutilisables
│       ├── layouts/              # Layouts de l'application
│       └── stores/               # État (Pinia)
├── routes/api.php                # Routes API
└── public/                        # Fichiers publics
```

## Installation

### Prérequis

- PHP 8.2+
- Node.js 18+
- Composer
- npm/pnpm/yarn

### Setup

```bash
# Installer les dépendances PHP
composer install

# Installer les dépendances JavaScript
pnpm install

# Copier le fichier d'environnement
cp .env.example .env

# Générer la clé d'application
php artisan key:generate

# Exécuter les migrations
php artisan migrate

# Seeder les utilisateurs de test
php artisan db:seed
```

## Développement

### Démarrer le serveur de développement

```bash
# Terminal 1: Backend (Laravel)
php artisan serve

# Terminal 2: Frontend (Vite)
pnpm dev
```

L'application sera accessible à `http://localhost:5173`

### Identifiants de test

- **Admin:**
  - Email: `admin@example.com`
  - Password: `password`

- **User:**
  - Email: `user@example.com`
  - Password: `password`

## Ajouter une nouvelle fonctionnalité

### 1. Backend (API)

Créer un nouveau modèle et contrôleur:

```bash
php artisan make:model Produit -m
php artisan make:controller Api/ProduitController --model=Produit --api
```

Ajouter les routes dans `routes/api.php`:

```php
Route::apiResource('produits', ProduitController::class);
```

### 2. Frontend (Vue)

Créer une nouvelle page dans `resources/js/pages/admin/produits.vue`:

```vue
<script setup>
definePage({
  meta: {
    action: 'manage',
    subject: 'all',
  },
})

const produits = ref([])

onMounted(async () => {
  const { data } = await useApi('/admin/produits')
  produits.value = data
})
</script>

<template>
  <!-- Votre template -->
</template>
```

Le routing est automatique basé sur le chemin du fichier!

## Build pour la production

```bash
# Compiler et minifier
pnpm build

# Build du backend
```

## Tests

```bash
# Tests PHP
php artisan test

# Tests JavaScript
pnpm test
```

## Ressources

- [Documentation Laravel](https://laravel.com/docs)
- [Documentation Vue 3](https://vuejs.org/)
- [Documentation Vuetify](https://vuetifyjs.com/)
- [Documentation Vite](https://vitejs.dev/)

## Support

Pour des questions ou des problèmes, consultez la page d'accueil de l'application qui contient un guide complet d'implémentation.

## License

MIT
