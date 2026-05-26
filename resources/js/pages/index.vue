<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
    <div class="max-w-4xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">Template Application</h1>
        <p class="text-xl text-gray-600">Un template minimaliste pour démarrer votre application</p>
      </div>

      <!-- Welcome Card -->
      <v-card class="mb-8 shadow-lg">
        <v-card-text class="p-8">
          <h2 class="text-2xl font-bold text-gray-900 mb-4">Bienvenue</h2>
          <p class="text-gray-700 mb-4">
            Ce template est conçu comme base de démarrage pour vos nouveaux projets. Il inclut un système de gestion des utilisateurs complet et une authentification sécurisée.
          </p>
          <p class="text-gray-700">
            Utilisez les ressources ci-dessous pour comprendre comment étendre cette application avec vos propres fonctionnalités.
          </p>
        </v-card-text>
      </v-card>

      <!-- Quick Start -->
      <v-card class="mb-8 shadow-lg">
        <v-card-text class="p-8">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">Démarrage Rapide</h2>

          <div class="grid md:grid-cols-2 gap-6">
            <!-- Authentication -->
            <div class="border-l-4 border-blue-500 pl-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-2">1. Authentification</h3>
              <p class="text-gray-700 text-sm mb-3">Le système d'authentification utilise Laravel Sanctum.</p>
              <ul class="text-sm text-gray-600 space-y-1">
                <li>✓ Pages de login/register disponibles</li>
                <li>✓ API endpoints configurés</li>
                <li>✓ Token-based authentication</li>
              </ul>
            </div>

            <!-- User Management -->
            <div class="border-l-4 border-green-500 pl-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-2">2. Gestion des Utilisateurs</h3>
              <p class="text-gray-700 text-sm mb-3">Système de gestion des utilisateurs inclus.</p>
              <ul class="text-sm text-gray-600 space-y-1">
                <li>✓ API CRUD complète</li>
                <li>✓ Rôles et permissions</li>
                <li>✓ Interface d'administration</li>
              </ul>
            </div>
          </div>
        </v-card-text>
      </v-card>

      <!-- Implementation Guide -->
      <v-card class="shadow-lg">
        <v-card-text class="p-8">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">Guide d'Implémentation</h2>

          <div class="space-y-6">
            <!-- Backend Section -->
            <div>
              <h3 class="text-lg font-semibold text-gray-900 mb-3 flex items-center">
                <v-icon class="mr-2" color="primary">mdi-server</v-icon>
                Backend (Laravel)
              </h3>
              <div class="bg-gray-50 rounded p-4 space-y-3">
                <div>
                  <p class="font-semibold text-sm text-gray-900">1. Créer un nouveau Modèle</p>
                  <code class="text-xs bg-gray-900 text-green-400 p-2 rounded block mt-1 overflow-x-auto">
                    php artisan make:model NomModele -m
                  </code>
                </div>
                <div>
                  <p class="font-semibold text-sm text-gray-900">2. Créer un Contrôleur</p>
                  <code class="text-xs bg-gray-900 text-green-400 p-2 rounded block mt-1 overflow-x-auto">
                    php artisan make:controller Api/NomController --model=NomModele --api
                  </code>
                </div>
                <div>
                  <p class="font-semibold text-sm text-gray-900">3. Ajouter les Routes</p>
                  <code class="text-xs bg-gray-900 text-green-400 p-2 rounded block mt-1 overflow-x-auto">
                    Route::apiResource('nom', NomController::class);
                  </code>
                </div>
              </div>
            </div>

            <!-- Frontend Section -->
            <div>
              <h3 class="text-lg font-semibold text-gray-900 mb-3 flex items-center">
                <v-icon class="mr-2" color="success">mdi-vuejs</v-icon>
                Frontend (Vue 3 + Vite)
              </h3>
              <div class="bg-gray-50 rounded p-4 space-y-3">
                <div>
                  <p class="font-semibold text-sm text-gray-900">1. Créer une Page Vue</p>
                  <code class="text-xs bg-gray-900 text-green-400 p-2 rounded block mt-1 overflow-x-auto">
                    resources/js/pages/nom.vue
                  </code>
                  <p class="text-xs text-gray-600 mt-1">Les pages sont automatiquement routées avec file-based routing</p>
                </div>
                <div>
                  <p class="font-semibold text-sm text-gray-900">2. Utiliser l'API</p>
                  <code class="text-xs bg-gray-900 text-green-400 p-2 rounded block mt-1 overflow-x-auto">
                    const { $axios }} = getCurrentInstance().appContext.config.globalProperties
                  </code>
                </div>
                <div>
                  <p class="font-semibold text-sm text-gray-900">3. Ajouter au Layout</p>
                  <p class="text-xs text-gray-600 mt-1">Utilisez le App.vue comme layout principal pour l'authentification</p>
                </div>
              </div>
            </div>

            <!-- Structure Section -->
            <div>
              <h3 class="text-lg font-semibold text-gray-900 mb-3 flex items-center">
                <v-icon class="mr-2" color="warning">mdi-folder-structure</v-icon>
                Structure du Projet
              </h3>
              <div class="bg-gray-50 rounded p-4 text-xs text-gray-700 font-mono">
                <div>app/</div>
                <div class="ml-4">├── Models/ → Modèles Eloquent</div>
                <div class="ml-4">├── Http/Controllers/Admin/ → Contrôleurs API</div>
                <div class="ml-4">└── Http/Requests/ → Validation des requêtes</div>
                <div class="mt-2">resources/js/</div>
                <div class="ml-4">├── pages/ → Pages Vue (route automatique)</div>
                <div class="ml-4">├── components/ → Composants réutilisables</div>
                <div class="ml-4">└── stores/ → État (Pinia)</div>
                <div class="mt-2">routes/api.php → Toutes les routes API</div>
              </div>
            </div>

            <!-- Tips Section -->
            <div>
              <h3 class="text-lg font-semibold text-gray-900 mb-3 flex items-center">
                <v-icon class="mr-2" color="info">mdi-lightbulb</v-icon>
                Conseils Pratiques
              </h3>
              <ul class="space-y-2 text-sm text-gray-700">
                <li class="flex items-start">
                  <span class="text-blue-500 mr-2 mt-0.5">→</span>
                  <span>Utilisez les Form Requests pour valider les données côté backend</span>
                </li>
                <li class="flex items-start">
                  <span class="text-blue-500 mr-2 mt-0.5">→</span>
                  <span>Protégez les routes admin avec le middleware <code class="bg-gray-200 px-1">can:manage,all</code></span>
                </li>
                <li class="flex items-start">
                  <span class="text-blue-500 mr-2 mt-0.5">→</span>
                  <span>Utilisez des ressources API pour formater les réponses</span>
                </li>
                <li class="flex items-start">
                  <span class="text-blue-500 mr-2 mt-0.5">→</span>
                  <span>Les tests sont importants : utilisez les répertoires tests/Unit et tests/Feature</span>
                </li>
              </ul>
            </div>
          </div>
        </v-card-text>
      </v-card>

      <!-- Actions -->
      <div class="mt-8 flex gap-4 justify-center">
        <router-link to="/login" class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
          Se Connecter
        </router-link>
        <router-link to="/register" class="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">
          S'Inscrire
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineComponent } from 'vue'

defineComponent({
  name: 'HomePage'
})
</script>

<style scoped>
code {
  font-family: 'Courier New', monospace;
}
</style>
